package("vulkan-utility-libraries")
    set_homepage("https://github.com/KhronosGroup/Vulkan-Utility-Libraries")
    set_description("Utility libraries for Vulkan developers")
    set_license("Apache-2.0")

    add_urls("https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.275.tar.gz",
             "https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.268.tar.gz",
             "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git")

    add_versions("v1.3.281", "96d3ec7bda7b6e9fabbb471c570104a7b1cb56928d097dd0441c96129468b888")
    add_versions("v1.3.280", "075e13f2fdeeca3bb6fb39155c8cc345cf216ab93661549b1a33368aa28a9dea")
    add_versions("v1.3.275", "96d3ec7bda7b6e9fabbb471c570104a7b1cb56928d097dd0441c96129468b888")
    add_versions("v1.3.268", "990de84b66094b647ae420ba13356b79d69e1c6f95532f40466457d51a9d127d")

    if is_plat("windows") then
        add_syslinks("advapi32")
    end

    add_deps("cmake")
    add_deps("vulkan-headers")

    if is_plat("mingw") and is_subhost("msys") then
        add_extsources("pacman::vulkan-utility-libraries")
    elseif is_plat("linux") then
        add_extsources("apt::vulkan-utility-libraries-dev", "pacman::vulkan-utility-libraries")
    elseif is_plat("macosx") then
        add_extsources("brew::vulkan-utility-libraries")
    end

    on_install("windows", "linux", "macosx", "bsd", "mingw", "msys", "cross", function (package)
        local configs = {"-DBUILD_TESTS=OFF", "-DUPDATE_DEPS=OFF"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("vkuCreateLayerSettingSet", {includes = "vulkan/layer/vk_layer_settings.h"}))
    end)
