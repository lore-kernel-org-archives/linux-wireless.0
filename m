Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:60166 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbbGZNUz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2015 09:20:55 -0400
Message-ID: <55B4DEB4.80902@hauke-m.de> (sfid-20150726_152231_334302_54C36724)
Date: Sun, 26 Jul 2015 15:20:52 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
References: <1437512677-6153-1-git-send-email-linus.walleij@linaro.org> <55B3EC92.1070704@hauke-m.de> <55B4D36B.7010701@hauke-m.de>
In-Reply-To: <55B4D36B.7010701@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2015 02:32 PM, Hauke Mehrtens wrote:
> On 07/25/2015 10:07 PM, Hauke Mehrtens wrote:
>> Hi,
>>
>> I found some compile problems in the code, but I haven't runtime tested
>> it, but will do that.
>>
>> Hauke
>>
> Currently there is a NACK from me, but generally I like that this patch
> removes some code.
> 
> I tested with patch on top of kernel 4.1.3 with OpenWrt trunk on a
> Netgear r6250 and it results in this error message:
> 
> 
> [    7.488170] ------------[ cut here ]------------
> [    7.492824] WARNING: CPU: 0 PID: 390 at drivers/gpio/gpiolib.c:86
> gpio_to_desc+0xa4/0xbc()
> [    7.501058] invalid GPIO -517
> [    7.504011] Modules linked in: gpio_button_hotplug(+) usbcore
> nls_base usb_common
> [    7.511518] CPU: 0 PID: 390 Comm: kmodloader Not tainted 4.1.3 #1
> [    7.517575] Hardware name: BCM5301X
> [    7.521050] Backtrace:
> [    7.523523] [<c001612c>] (dump_backtrace) from [<c0016338>]
> (show_stack+0x18/0x1c)
> [    7.531072]  r6:c0362368 r5:00000009 r4:00000000 r3:dc8ba303
> [    7.536748] [<c0016320>] (show_stack) from [<c016a998>]
> (dump_stack+0x7c/0x98)
> [    7.543968] [<c016a91c>] (dump_stack) from [<c00206e8>]
> (warn_slowpath_common+0x90/0xbc)
> [    7.552025]  r4:c717bbe0 r3:dc8ba303
> [    7.555612] [<c0020658>] (warn_slowpath_common) from [<c002074c>]
> (warn_slowpath_fmt+0x38/0x40)
> [    7.564275]  r8:c71b3a10 r7:c78f7210 r6:fffffdfb r5:fffffdfb r4:c03da260
> [    7.570999] [<c0020718>] (warn_slowpath_fmt) from [<c0199630>]
> (gpio_to_desc+0xa4/0xbc)
> [    7.578964]  r3:fffffdfb r2:c0362477
> [    7.582549] [<c019958c>] (gpio_to_desc) from [<c019a4d4>]
> (gpio_request+0x18/0x3c)
> [    7.590091]  r5:fffffdfb r4:c053c7d0
> [    7.593676] [<c019a4bc>] (gpio_request) from [<c0197ea4>]
> (devm_gpio_request+0x3c/0x74)
> [    7.601643]  r5:c053c7d0 r4:c79d3f50
> [    7.605228] [<c0197e68>] (devm_gpio_request) from [<bf02d3e8>]
> (gpio_keys_remove+0x3e8/0x668 [gpio_button_hotplug])
> [    7.615615]  r7:c71b3a10 r6:0000002c r5:c78f7210 r4:c717e950
> [    7.621295] [<bf02d04c>] (gpio_keys_remove [gpio_button_hotplug])
> from [<bf02d834>] (gpio_keys_probe+0x20/0x1b4 [gpio_button_hotplug])
> [    7.633326]  r10:c717bf40 r9:c03d0408 r8:00000000 r7:c78f7200
> r6:bf02dfc0 r5:bf02dfc0
> [    7.641163]  r4:c78f7210
> [    7.643701] [<bf02d814>] (gpio_keys_probe [gpio_button_hotplug]) from
> [<c01cc698>] (platform_drv_probe+0x34/0x64)
> [    7.653915]  r10:c717bf40 r9:c03d0408 r8:00000000 r7:00000001
> r6:bf02dfc0 r5:bf02dfc0
> [    7.661751]  r4:c78f7210
> [    7.664285] [<c01cc664>] (platform_drv_probe) from [<c01cb0e0>]
> (driver_probe_device+0xf4/0x258)
> [    7.673034]  r5:00000000 r4:c78f7210
> [    7.676612] [<c01cafec>] (driver_probe_device) from [<c01cb300>]
> (__driver_attach+0x70/0x94)
> [    7.685010]  r7:00000000 r6:bf02dfc0 r5:c78f7244 r4:c78f7210
> [    7.690696] [<c01cb290>] (__driver_attach) from [<c01c9774>]
> (bus_for_each_dev+0x7c/0x90)
> [    7.698835]  r6:c01cb290 r5:bf02dfc0 r4:00000000 r3:c01cb290
> [    7.704511] [<c01c96f8>] (bus_for_each_dev) from [<c01cabf0>]
> (driver_attach+0x20/0x28)
> [    7.712485]  r6:c03db6d4 r5:c792e600 r4:bf02dfc0
> [    7.717110] [<c01cabd0>] (driver_attach) from [<c01ca890>]
> (bus_add_driver+0xe4/0x1d4)
> [    7.725006] [<c01ca7ac>] (bus_add_driver) from [<c01cb784>]
> (driver_register+0xa4/0xe8)
> [    7.732984]  r7:c03d3468 r6:bf030000 r5:c03d3468 r4:bf02dfc0
> [    7.738656] [<c01cb6e0>] (driver_register) from [<c01cc650>]
> (__platform_driver_register+0x50/0x64)
> [    7.747668]  r5:c03d3468 r4:c78d7640
> [    7.751257] [<c01cc600>] (__platform_driver_register) from
> [<bf030018>] (init_module+0x18/0x50 [gpio_button_hotplug])
> [    7.761837] [<bf030000>] (init_module [gpio_button_hotplug]) from
> [<c001318c>] (do_one_initcall+0x1a4/0x1e0)
> [    7.771627]  r4:c78d7640 r3:00000000
> [    7.775216] [<c0012fe8>] (do_one_initcall) from [<c006f9b0>]
> (do_init_module+0x60/0x1a8)
> [    7.783273]  r9:c006e734 r8:bf02e36c r7:00000015 r6:c78d75c0
> r5:c71b3d7c r4:bf02e36c
> [    7.791034] [<c006f950>] (do_init_module) from [<c0070fac>]
> (load_module+0x13cc/0x1854)
> [    7.798998]  r6:00000000 r5:c71b3d7c r4:c71b3c00
> [    7.803631] [<c006fbe0>] (load_module) from [<c007152c>]
> (SyS_init_module+0xf8/0x124)
> [    7.811430]  r10:00000000 r9:000122f7 r8:c717a000 r7:00acf500
> r6:c8a734f0 r5:00000000
> [    7.819258]  r4:000024f0
> [    7.821802] [<c0071434>] (SyS_init_module) from [<c0009680>]
> (ret_fast_syscall+0x0/0x3c)
> [    7.829860]  r9:c717a000 r8:c0009824 r7:00000080 r6:00000000
> r5:00000000 r4:00000000
> [    7.837604] ---[ end trace 2277938710cf7c41 ]---
> [    7.842209] gpiod_request: invalid GPIO
> [    7.846038] gpio-keys gpio-keys: unable to claim gpio 4294966779, err=-22
> [    7.852820] gpio-keys: probe of gpio-keys failed with error -22

I made my gpio-key driver compatible with EPROBE_DEFER, but then I saw this:
[    3.943859] missing gpiochip .dev parent pointer

and I added this to my gpio driver:
	chip->dev		= &cc->core->dev;
	chip->owner		= THIS_MODULE;

And then I am getting this:

[    3.936204] pci 0001:00:00.0:   bridge window [mem 0x40000000-0x400fffff]
[    3.943698] ------------[ cut here ]------------
[    3.948333] WARNING: CPU: 0 PID: 1 at lib/kobject.c:583
kobject_get+0x3c/0xa8()
[    3.955637] kobject: 'bcma0:0' (c7a35c18): is not initialized, yet
kobject_get() is being called.
[    3.964474] Modules linked in:
[    3.967531] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.1.3 #4
[    3.973346] Hardware name: BCM5301X
[    3.976820] Backtrace:
[    3.979283] [<c001612c>] (dump_backtrace) from [<c0016338>]
(show_stack+0x18/0x1c)
[    3.986827]  r6:c035e365 r5:00000009 r4:00000000 r3:dc8ba303
[    3.992514] [<c0016320>] (show_stack) from [<c016a998>]
(dump_stack+0x7c/0x98)
[    3.999728] [<c016a91c>] (dump_stack) from [<c00206e8>]
(warn_slowpath_common+0x90/0xbc)
[    4.007776]  r4:c782bc28 r3:dc8ba303
[    4.011374] [<c0020658>] (warn_slowpath_common) from [<c002074c>]
(warn_slowpath_fmt+0x38/0x40)
[    4.020037]  r8:00000000 r7:c7a35c10 r6:00000000 r5:c7987408 r4:c7a35c18
[    4.026753] [<c0020718>] (warn_slowpath_fmt) from [<c016c600>]
(kobject_get+0x3c/0xa8)
[    4.034639]  r3:c7954040 r2:c035e373
[    4.038223] [<c016c5c4>] (kobject_get) from [<c01c7610>]
(get_device+0x1c/0x24)
[    4.045499]  r5:c7987408 r4:c7987400
[    4.049079] [<c01c75f4>] (get_device) from [<c01c878c>]
(device_add+0xd0/0x518)
[    4.056371] [<c01c86bc>] (device_add) from [<c01c8d34>]
(device_create_groups_vargs+0x84/0xcc)
[    4.064957]  r10:00000000 r9:c03d0408 r8:00000000 r7:c7a35c10
r6:c03da2b0 r5:00000000
[    4.072801]  r4:c7987400
[    4.075335] [<c01c8cb0>] (device_create_groups_vargs) from
[<c01c8e10>] (device_create_with_groups+0x30/0x38)
[    4.085209]  r8:0000082c r7:00000000 r6:c03da2b0 r5:a0000113
r4:c7976464 r3:c7976464
[    4.092973] [<c01c8de0>] (device_create_with_groups) from
[<c019ba74>] (gpiochip_export+0x58/0x94)
[    4.101912] [<c019ba1c>] (gpiochip_export) from [<c0198dfc>]
(gpiochip_add+0x1e0/0x268)
[    4.109883]  r6:c7a5da00 r5:a0000113 r4:c7976464
[    4.114522] [<c0198c1c>] (gpiochip_add) from [<c0226428>]
(bcma_gpio_init+0xd4/0x1d8)
[    4.122318]  r7:0000052d r6:c7976464 r5:c797643c r4:c797643c
[    4.127996] [<c0226354>] (bcma_gpio_init) from [<c0222180>]
(bcma_bus_register+0x2a4/0x34c)
[    4.136317]  r8:0000082c r7:0000052d r6:c7976430 r5:c797643c r4:c7976410
[    4.143048] [<c0221edc>] (bcma_bus_register) from [<c0227158>]
(bcma_host_soc_probe+0x70/0x90)
[    4.151625]  r8:00000000 r7:00000000 r6:c6dea374 r5:c78f1a00
r4:c7976410 r3:dc8ba303
[    4.159386] [<c02270e8>] (bcma_host_soc_probe) from [<c01cc698>]
(platform_drv_probe+0x34/0x64)
[    4.168049]  r6:c03e1930 r5:c03e1930 r4:c78f1a10 r3:c02270e8
[    4.173726] [<c01cc664>] (platform_drv_probe) from [<c01cb0e0>]
(driver_probe_device+0xf4/0x258)
[    4.182476]  r5:00000000 r4:c78f1a10
[    4.186052] [<c01cafec>] (driver_probe_device) from [<c01cb300>]
(__driver_attach+0x70/0x94)
[    4.194451]  r7:00000000 r6:c03e1930 r5:c78f1a44 r4:c78f1a10
[    4.200132] [<c01cb290>] (__driver_attach) from [<c01c9774>]
(bus_for_each_dev+0x7c/0x90)
[    4.208267]  r6:c01cb290 r5:c03e1930 r4:00000000 r3:c01cb290
[    4.213944] [<c01c96f8>] (bus_for_each_dev) from [<c01cabf0>]
(driver_attach+0x20/0x28)
[    4.221919]  r6:c03db6d4 r5:c79d2a80 r4:c03e1930
[    4.226542] [<c01cabd0>] (driver_attach) from [<c01ca890>]
(bus_add_driver+0xe4/0x1d4)
[    4.234439] [<c01ca7ac>] (bus_add_driver) from [<c01cb784>]
(driver_register+0xa4/0xe8)
[    4.242415]  r7:c03d3468 r6:c03b9478 r5:c03d3468 r4:c03e1930
[    4.248089] [<c01cb6e0>] (driver_register) from [<c01cc650>]
(__platform_driver_register+0x50/0x64)
[    4.257093]  r5:c03d3468 r4:c7954240
[    4.260700] [<c01cc600>] (__platform_driver_register) from
[<c03b9618>] (bcma_host_soc_register_driver+0x18/0x20)
[    4.270931] [<c03b9600>] (bcma_host_soc_register_driver) from
[<c03b9488>] (bcma_modinit+0x10/0x44)
[    4.279950] [<c03b9478>] (bcma_modinit) from [<c001318c>]
(do_one_initcall+0x1a4/0x1e0)
[    4.287925] [<c0012fe8>] (do_one_initcall) from [<c03a2e64>]
(kernel_init_freeable+0x118/0x1e8)
[    4.296588]  r9:c03e5b50 r8:c03e5b58 r7:0000002f r6:c03c9f68
r5:c03c5458 r4:00000006
[    4.304365] [<c03a2d4c>] (kernel_init_freeable) from [<c000e178>]
(kernel_init+0x10/0x104)
[    4.312596]  r9:00000000 r8:00000000 r7:00000000 r6:00000000
r5:c000e168 r4:00000000
[    4.320353] [<c000e168>] (kernel_init) from [<c0009728>]
(ret_from_fork+0x14/0x2c)
[    4.327880]  r4:00000000 r3:c782a000
[    4.331479] ---[ end trace abf3e8af98903003 ]---
[    4.336071] ------------[ cut here ]------------
[    4.340689] WARNING: CPU: 0 PID: 1 at include/linux/kref.h:47
kobject_get+0x84/0xa8()
[    4.348477] Modules linked in:
[    4.351534] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W
4.1.3 #4
[    4.358543] Hardware name: BCM5301X
[    4.362015] Backtrace:
[    4.364466] [<c001612c>] (dump_backtrace) from [<c0016338>]
(show_stack+0x18/0x1c)
[    4.372005]  r6:c0339fed r5:00000009 r4:00000000 r3:dc8ba303
[    4.377674] [<c0016320>] (show_stack) from [<c016a998>]
(dump_stack+0x7c/0x98)
[    4.384883] [<c016a91c>] (dump_stack) from [<c00206e8>]
(warn_slowpath_common+0x90/0xbc)
[    4.392938]  r4:00000000 r3:dc8ba303
[    4.396519] [<c0020658>] (warn_slowpath_common) from [<c00207b8>]
(warn_slowpath_null+0x24/0x2c)
[    4.405273]  r8:00000000 r7:c7a35c10 r6:00000000 r5:c03d339a r4:c7a35c18
[    4.412001] [<c0020794>] (warn_slowpath_null) from [<c016c648>]
(kobject_get+0x84/0xa8)
[    4.419985] [<c016c5c4>] (kobject_get) from [<c01c7610>]
(get_device+0x1c/0x24)
[    4.427257]  r5:c7987408 r4:c7987400
[    4.430843] [<c01c75f4>] (get_device) from [<c01c878c>]
(device_add+0xd0/0x518)
[    4.438126] [<c01c86bc>] (device_add) from [<c01c8d34>]
(device_create_groups_vargs+0x84/0xcc)
[    4.446705]  r10:00000000 r9:c03d0408 r8:00000000 r7:c7a35c10
r6:c03da2b0 r5:00000000
[    4.454542]  r4:c7987400
[    4.457076] [<c01c8cb0>] (device_create_groups_vargs) from
[<c01c8e10>] (device_create_with_groups+0x30/0x38)
[    4.466948]  r8:0000082c r7:00000000 r6:c03da2b0 r5:a0000113
r4:c7976464 r3:c7976464
[    4.474711] [<c01c8de0>] (device_create_with_groups) from
[<c019ba74>] (gpiochip_export+0x58/0x94)
[    4.483648] [<c019ba1c>] (gpiochip_export) from [<c0198dfc>]
(gpiochip_add+0x1e0/0x268)
[    4.491615]  r6:c7a5da00 r5:a0000113 r4:c7976464
[    4.496244] [<c0198c1c>] (gpiochip_add) from [<c0226428>]
(bcma_gpio_init+0xd4/0x1d8)
[    4.504041]  r7:0000052d r6:c7976464 r5:c797643c r4:c797643c
[    4.509718] [<c0226354>] (bcma_gpio_init) from [<c0222180>]
(bcma_bus_register+0x2a4/0x34c)
[    4.518029]  r8:0000082c r7:0000052d r6:c7976430 r5:c797643c r4:c7976410
[    4.524751] [<c0221edc>] (bcma_bus_register) from [<c0227158>]
(bcma_host_soc_probe+0x70/0x90)
[    4.533334]  r8:00000000 r7:00000000 r6:c6dea374 r5:c78f1a00
r4:c7976410 r3:dc8ba303
[    4.541099] [<c02270e8>] (bcma_host_soc_probe) from [<c01cc698>]
(platform_drv_probe+0x34/0x64)
[    4.549763]  r6:c03e1930 r5:c03e1930 r4:c78f1a10 r3:c02270e8
[    4.555431] [<c01cc664>] (platform_drv_probe) from [<c01cb0e0>]
(driver_probe_device+0xf4/0x258)
[    4.564174]  r5:00000000 r4:c78f1a10
[    4.567751] [<c01cafec>] (driver_probe_device) from [<c01cb300>]
(__driver_attach+0x70/0x94)
[    4.576149]  r7:00000000 r6:c03e1930 r5:c78f1a44 r4:c78f1a10
[    4.581828] [<c01cb290>] (__driver_attach) from [<c01c9774>]
(bus_for_each_dev+0x7c/0x90)
[    4.589974]  r6:c01cb290 r5:c03e1930 r4:00000000 r3:c01cb290
[    4.595641] [<c01c96f8>] (bus_for_each_dev) from [<c01cabf0>]
(driver_attach+0x20/0x28)
[    4.603608]  r6:c03db6d4 r5:c79d2a80 r4:c03e1930
[    4.608231] [<c01cabd0>] (driver_attach) from [<c01ca890>]
(bus_add_driver+0xe4/0x1d4)
[    4.616128] [<c01ca7ac>] (bus_add_driver) from [<c01cb784>]
(driver_register+0xa4/0xe8)
[    4.624102]  r7:c03d3468 r6:c03b9478 r5:c03d3468 r4:c03e1930
[    4.629776] [<c01cb6e0>] (driver_register) from [<c01cc650>]
(__platform_driver_register+0x50/0x64)
[    4.638772]  r5:c03d3468 r4:c7954240
[    4.642363] [<c01cc600>] (__platform_driver_register) from
[<c03b9618>] (bcma_host_soc_register_driver+0x18/0x20)
[    4.652590] [<c03b9600>] (bcma_host_soc_register_driver) from
[<c03b9488>] (bcma_modinit+0x10/0x44)
[    4.661612] [<c03b9478>] (bcma_modinit) from [<c001318c>]
(do_one_initcall+0x1a4/0x1e0)
[    4.669586] [<c0012fe8>] (do_one_initcall) from [<c03a2e64>]
(kernel_init_freeable+0x118/0x1e8)
[    4.678250]  r9:c03e5b50 r8:c03e5b58 r7:0000002f r6:c03c9f68
r5:c03c5458 r4:00000006
[    4.686012] [<c03a2d4c>] (kernel_init_freeable) from [<c000e178>]
(kernel_init+0x10/0x104)
[    4.694242]  r9:00000000 r8:00000000 r7:00000000 r6:00000000
r5:c000e168 r4:00000000
[    4.702010] [<c000e168>] (kernel_init) from [<c0009728>]
(ret_from_fork+0x14/0x2c)
[    4.709543]  r4:00000000 r3:c782a000
[    4.713121] ---[ end trace abf3e8af98903004 ]---
[    4.717725] ------------[ cut here ]------------
[    4.722340] WARNING: CPU: 0 PID: 1 at lib/kobject.c:583
kobject_get+0x3c/0xa8()
[    4.729617] kobject: 'bcma0:0' (c7a35c18): is not initialized, yet
kobject_get() is being called.
[    4.738452] Modules linked in:
[    4.741508] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W
4.1.3 #4
[    4.748518] Hardware name: BCM5301X
[    4.751990] Backtrace:
[    4.754441] [<c001612c>] (dump_backtrace) from [<c0016338>]
(show_stack+0x18/0x1c)
[    4.761980]  r6:c035e365 r5:00000009 r4:00000000 r3:dc8ba303
[    4.767648] [<c0016320>] (show_stack) from [<c016a998>]
(dump_stack+0x7c/0x98)
[    4.774858] [<c016a91c>] (dump_stack) from [<c00206e8>]
(warn_slowpath_common+0x90/0xbc)
[    4.782914]  r4:c782bbb0 r3:dc8ba303
[    4.786492] [<c0020658>] (warn_slowpath_common) from [<c002074c>]
(warn_slowpath_fmt+0x38/0x40)
[    4.795161]  r8:00000000 r7:c7a35c18 r6:00000000 r5:c7a35c18 r4:c7a35c18
[    4.801889] [<c0020718>] (warn_slowpath_fmt) from [<c016c600>]
(kobject_get+0x3c/0xa8)
[    4.809776]  r3:c7954040 r2:c035e373
[    4.813355] [<c016c5c4>] (kobject_get) from [<c016cbd0>]
(kobject_add_internal+0x54/0x2ac)
[    4.821586]  r5:c7a35c18 r4:c79ba3c0
[    4.825165] [<c016cb7c>] (kobject_add_internal) from [<c016cff0>]
(kobject_add+0x78/0x90)
[    4.833310]  r8:00000000 r7:c7a35c18 r6:00000000 r5:c7a35c18 r4:c79ba3c0
[    4.840036] [<c016cf7c>] (kobject_add) from [<c01c847c>]
(get_device_parent+0x12c/0x184)
[    4.848085]  r3:c03722e6 r2:c033c735
[    4.851662]  r6:00000000 r5:c03da2b0 r4:c79ba3c0
[    4.856285] [<c01c8350>] (get_device_parent) from [<c01c879c>]
(device_add+0xe0/0x518)
[    4.864173]  r7:c7a35c10 r6:00000000 r5:c7987408 r4:c7987400
[    4.869848] [<c01c86bc>] (device_add) from [<c01c8d34>]
(device_create_groups_vargs+0x84/0xcc)
[    4.878412]  r10:00000000 r9:c03d0408 r8:00000000 r7:c7a35c10
r6:c03da2b0 r5:00000000
[    4.886248]  r4:c7987400
[    4.888782] [<c01c8cb0>] (device_create_groups_vargs) from
[<c01c8e10>] (device_create_with_groups+0x30/0x38)
[    4.898655]  r8:0000082c r7:00000000 r6:c03da2b0 r5:a0000113
r4:c7976464 r3:c7976464
[    4.906416] [<c01c8de0>] (device_create_with_groups) from
[<c019ba74>] (gpiochip_export+0x58/0x94)
[    4.915351] [<c019ba1c>] (gpiochip_export) from [<c0198dfc>]
(gpiochip_add+0x1e0/0x268)
[    4.923327]  r6:c7a5da00 r5:a0000113 r4:c7976464
[    4.927960] [<c0198c1c>] (gpiochip_add) from [<c0226428>]
(bcma_gpio_init+0xd4/0x1d8)
[    4.935755]  r7:0000052d r6:c7976464 r5:c797643c r4:c797643c
[    4.941434] [<c0226354>] (bcma_gpio_init) from [<c0222180>]
(bcma_bus_register+0x2a4/0x34c)
[    4.949752]  r8:0000082c r7:0000052d r6:c7976430 r5:c797643c r4:c7976410
[    4.956465] [<c0221edc>] (bcma_bus_register) from [<c0227158>]
(bcma_host_soc_probe+0x70/0x90)
[    4.965036]  r8:00000000 r7:00000000 r6:c6dea374 r5:c78f1a00
r4:c7976410 r3:dc8ba303
[    4.972796] [<c02270e8>] (bcma_host_soc_probe) from [<c01cc698>]
(platform_drv_probe+0x34/0x64)
[    4.981460]  r6:c03e1930 r5:c03e1930 r4:c78f1a10 r3:c02270e8
[    4.987129] [<c01cc664>] (platform_drv_probe) from [<c01cb0e0>]
(driver_probe_device+0xf4/0x258)
[    4.995880]  r5:00000000 r4:c78f1a10
[    4.999457] [<c01cafec>] (driver_probe_device) from [<c01cb300>]
(__driver_attach+0x70/0x94)
[    5.007855]  r7:00000000 r6:c03e1930 r5:c78f1a44 r4:c78f1a10
[    5.013533] [<c01cb290>] (__driver_attach) from [<c01c9774>]
(bus_for_each_dev+0x7c/0x90)
[    5.021679]  r6:c01cb290 r5:c03e1930 r4:00000000 r3:c01cb290
[    5.027347] [<c01c96f8>] (bus_for_each_dev) from [<c01cabf0>]
(driver_attach+0x20/0x28)
[    5.035316]  r6:c03db6d4 r5:c79d2a80 r4:c03e1930
[    5.039955] [<c01cabd0>] (driver_attach) from [<c01ca890>]
(bus_add_driver+0xe4/0x1d4)
[    5.047842] [<c01ca7ac>] (bus_add_driver) from [<c01cb784>]
(driver_register+0xa4/0xe8)
[    5.055823]  r7:c03d3468 r6:c03b9478 r5:c03d3468 r4:c03e1930
[    5.061502] [<c01cb6e0>] (driver_register) from [<c01cc650>]
(__platform_driver_register+0x50/0x64)
[    5.070514]  r5:c03d3468 r4:c7954240
[    5.074105] [<c01cc600>] (__platform_driver_register) from
[<c03b9618>] (bcma_host_soc_register_driver+0x18/0x20)
[    5.084332] [<c03b9600>] (bcma_host_soc_register_driver) from
[<c03b9488>] (bcma_modinit+0x10/0x44)
[    5.093352] [<c03b9478>] (bcma_modinit) from [<c001318c>]
(do_one_initcall+0x1a4/0x1e0)
[    5.101333] [<c0012fe8>] (do_one_initcall) from [<c03a2e64>]
(kernel_init_freeable+0x118/0x1e8)
[    5.109998]  r9:c03e5b50 r8:c03e5b58 r7:0000002f r6:c03c9f68
r5:c03c5458 r4:00000006
[    5.117752] [<c03a2d4c>] (kernel_init_freeable) from [<c000e178>]
(kernel_init+0x10/0x104)
[    5.125982]  r9:00000000 r8:00000000 r7:00000000 r6:00000000
r5:c000e168 r4:00000000
[    5.133741] [<c000e168>] (kernel_init) from [<c0009728>]
(ret_from_fork+0x14/0x2c)
[    5.141283]  r4:00000000 r3:c782a000
[    5.144853] ---[ end trace abf3e8af98903005 ]---
[    5.149451] ------------[ cut here ]------------
[    5.154065] WARNING: CPU: 0 PID: 1 at lib/kobject.c:675
kobject_put+0x3c/0x80()
[    5.161346] kobject: 'bcma0:0' (c7a35c18): is not initialized, yet
kobject_put() is being called.
[    5.170184] Modules linked in:
[    5.173231] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W
4.1.3 #4
[    5.180253] Hardware name: BCM5301X
[    5.183722] Backtrace:
[    5.186172] [<c001612c>] (dump_backtrace) from [<c0016338>]
(show_stack+0x18/0x1c)
[    5.193713]  r6:c035e365 r5:00000009 r4:00000000 r3:dc8ba303
[    5.199388] [<c0016320>] (show_stack) from [<c016a998>]
(dump_stack+0x7c/0x98)
[    5.206598] [<c016a91c>] (dump_stack) from [<c00206e8>]
(warn_slowpath_common+0x90/0xbc)
[    5.214654]  r4:c782bbb0 r3:dc8ba303
[    5.218234] [<c0020658>] (warn_slowpath_common) from [<c002074c>]
(warn_slowpath_fmt+0x38/0x40)
[    5.226897]  r8:00000000 r7:c7a35c18 r6:c7a35c18 r5:fffffffe r4:c7a35c18
[    5.233622] [<c0020718>] (warn_slowpath_fmt) from [<c016c6a8>]
(kobject_put+0x3c/0x80)
[    5.241507]  r3:c7954040 r2:c035e3c1
[    5.245087] [<c016c66c>] (kobject_put) from [<c016cd90>]
(kobject_add_internal+0x214/0x2ac)
[    5.253404]  r4:c79ba3c0
[    5.255938] [<c016cb7c>] (kobject_add_internal) from [<c016cff0>]
(kobject_add+0x78/0x90)
[    5.264084]  r8:00000000 r7:c7a35c18 r6:00000000 r5:c7a35c18 r4:c79ba3c0
[    5.270811] [<c016cf7c>] (kobject_add) from [<c01c847c>]
(get_device_parent+0x12c/0x184)
[    5.278858]  r3:c03722e6 r2:c033c735
[    5.282435]  r6:00000000 r5:c03da2b0 r4:c79ba3c0
[    5.287059] [<c01c8350>] (get_device_parent) from [<c01c879c>]
(device_add+0xe0/0x518)
[    5.294947]  r7:c7a35c10 r6:00000000 r5:c7987408 r4:c7987400
[    5.300625] [<c01c86bc>] (device_add) from [<c01c8d34>]
(device_create_groups_vargs+0x84/0xcc)
[    5.309192]  r10:00000000 r9:c03d0408 r8:00000000 r7:c7a35c10
r6:c03da2b0 r5:00000000
[    5.317039]  r4:c7987400
[    5.319573] [<c01c8cb0>] (device_create_groups_vargs) from
[<c01c8e10>] (device_create_with_groups+0x30/0x38)
[    5.329445]  r8:0000082c r7:00000000 r6:c03da2b0 r5:a0000113
r4:c7976464 r3:c7976464
[    5.337208] [<c01c8de0>] (device_create_with_groups) from
[<c019ba74>] (gpiochip_export+0x58/0x94)
[    5.346144] [<c019ba1c>] (gpiochip_export) from [<c0198dfc>]
(gpiochip_add+0x1e0/0x268)
[    5.354112]  r6:c7a5da00 r5:a0000113 r4:c7976464
[    5.358741] [<c0198c1c>] (gpiochip_add) from [<c0226428>]
(bcma_gpio_init+0xd4/0x1d8)
[    5.366538]  r7:0000052d r6:c7976464 r5:c797643c r4:c797643c
[    5.372216] [<c0226354>] (bcma_gpio_init) from [<c0222180>]
(bcma_bus_register+0x2a4/0x34c)
[    5.380534]  r8:0000082c r7:0000052d r6:c7976430 r5:c797643c r4:c7976410
[    5.387247] [<c0221edc>] (bcma_bus_register) from [<c0227158>]
(bcma_host_soc_probe+0x70/0x90)
[    5.395826]  r8:00000000 r7:00000000 r6:c6dea374 r5:c78f1a00
r4:c7976410 r3:dc8ba303
[    5.403586] [<c02270e8>] (bcma_host_soc_probe) from [<c01cc698>]
(platform_drv_probe+0x34/0x64)
[    5.412252]  r6:c03e1930 r5:c03e1930 r4:c78f1a10 r3:c02270e8
[    5.417918] [<c01cc664>] (platform_drv_probe) from [<c01cb0e0>]
(driver_probe_device+0xf4/0x258)
[    5.426663]  r5:00000000 r4:c78f1a10
[    5.430247] [<c01cafec>] (driver_probe_device) from [<c01cb300>]
(__driver_attach+0x70/0x94)
[    5.438637]  r7:00000000 r6:c03e1930 r5:c78f1a44 r4:c78f1a10
[    5.444324] [<c01cb290>] (__driver_attach) from [<c01c9774>]
(bus_for_each_dev+0x7c/0x90)
[    5.452470]  r6:c01cb290 r5:c03e1930 r4:00000000 r3:c01cb290
[    5.458138] [<c01c96f8>] (bus_for_each_dev) from [<c01cabf0>]
(driver_attach+0x20/0x28)
[    5.466105]  r6:c03db6d4 r5:c79d2a80 r4:c03e1930
[    5.470735] [<c01cabd0>] (driver_attach) from [<c01ca890>]
(bus_add_driver+0xe4/0x1d4)
[    5.478614] [<c01ca7ac>] (bus_add_driver) from [<c01cb784>]
(driver_register+0xa4/0xe8)
[    5.486581]  r7:c03d3468 r6:c03b9478 r5:c03d3468 r4:c03e1930
[    5.492258] [<c01cb6e0>] (driver_register) from [<c01cc650>]
(__platform_driver_register+0x50/0x64)
[    5.501269]  r5:c03d3468 r4:c7954240
[    5.504851] [<c01cc600>] (__platform_driver_register) from
[<c03b9618>] (bcma_host_soc_register_driver+0x18/0x20)
[    5.515079] [<c03b9600>] (bcma_host_soc_register_driver) from
[<c03b9488>] (bcma_modinit+0x10/0x44)
[    5.524098] [<c03b9478>] (bcma_modinit) from [<c001318c>]
(do_one_initcall+0x1a4/0x1e0)
[    5.532081] [<c0012fe8>] (do_one_initcall) from [<c03a2e64>]
(kernel_init_freeable+0x118/0x1e8)
[    5.540744]  r9:c03e5b50 r8:c03e5b58 r7:0000002f r6:c03c9f68
r5:c03c5458 r4:00000006
[    5.548498] [<c03a2d4c>] (kernel_init_freeable) from [<c000e178>]
(kernel_init+0x10/0x104)
[    5.556729]  r9:00000000 r8:00000000 r7:00000000 r6:00000000
r5:c000e168 r4:00000000
[    5.564489] [<c000e168>] (kernel_init) from [<c0009728>]
(ret_from_fork+0x14/0x2c)
[    5.572035]  r4:00000000 r3:c782a000
[    5.575609] ---[ end trace abf3e8af98903006 ]---
[    5.580211] ------------[ cut here ]------------
[    5.584812] WARNING: CPU: 0 PID: 1 at lib/kobject.c:244
kobject_add_internal+0x26c/0x2ac()
[    5.593046] kobject_add_internal failed for gpio (error: -2 parent:
bcma0:0)
[    5.600064] Modules linked in:
[    5.603113] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W
4.1.3 #4
[    5.610133] Hardware name: BCM5301X
[    5.613606] Backtrace:
[    5.616054] [<c001612c>] (dump_backtrace) from [<c0016338>]
(show_stack+0x18/0x1c)
[    5.623596]  r6:c035e365 r5:00000009 r4:00000000 r3:dc8ba303
[    5.629271] [<c0016320>] (show_stack) from [<c016a998>]
(dump_stack+0x7c/0x98)
[    5.636482] [<c016a91c>] (dump_stack) from [<c00206e8>]
(warn_slowpath_common+0x90/0xbc)
[    5.644538]  r4:c782bbd0 r3:dc8ba303
[    5.648117] [<c0020658>] (warn_slowpath_common) from [<c002074c>]
(warn_slowpath_fmt+0x38/0x40)
[    5.656780]  r8:00000000 r7:c7a35c18 r6:c7a35c18 r5:fffffffe r4:c79ba3c0
[    5.663506] [<c0020718>] (warn_slowpath_fmt) from [<c016cde8>]
(kobject_add_internal+0x26c/0x2ac)
[    5.672342]  r3:c035e2a0 r2:c035e4d0
[    5.675920] [<c016cb7c>] (kobject_add_internal) from [<c016cff0>]
(kobject_add+0x78/0x90)
[    5.684065]  r8:00000000 r7:c7a35c18 r6:00000000 r5:c7a35c18 r4:c79ba3c0
[    5.690790] [<c016cf7c>] (kobject_add) from [<c01c847c>]
(get_device_parent+0x12c/0x184)
[    5.698840]  r3:c03722e6 r2:c033c735
[    5.702425]  r6:00000000 r5:c03da2b0 r4:c79ba3c0
[    5.707049] [<c01c8350>] (get_device_parent) from [<c01c879c>]
(device_add+0xe0/0x518)
[    5.714937]  r7:c7a35c10 r6:00000000 r5:c7987408 r4:c7987400
[    5.720614] [<c01c86bc>] (device_add) from [<c01c8d34>]
(device_create_groups_vargs+0x84/0xcc)
[    5.729183]  r10:00000000 r9:c03d0408 r8:00000000 r7:c7a35c10
r6:c03da2b0 r5:00000000
[    5.737020]  r4:c7987400
[    5.739555] [<c01c8cb0>] (device_create_groups_vargs) from
[<c01c8e10>] (device_create_with_groups+0x30/0x38)
[    5.749427]  r8:0000082c r7:00000000 r6:c03da2b0 r5:a0000113
r4:c7976464 r3:c7976464
[    5.757188] [<c01c8de0>] (device_create_with_groups) from
[<c019ba74>] (gpiochip_export+0x58/0x94)
[    5.766123] [<c019ba1c>] (gpiochip_export) from [<c0198dfc>]
(gpiochip_add+0x1e0/0x268)
[    5.774094]  r6:c7a5da00 r5:a0000113 r4:c7976464
[    5.778722] [<c0198c1c>] (gpiochip_add) from [<c0226428>]
(bcma_gpio_init+0xd4/0x1d8)
[    5.786519]  r7:0000052d r6:c7976464 r5:c797643c r4:c797643c
[    5.792197] [<c0226354>] (bcma_gpio_init) from [<c0222180>]
(bcma_bus_register+0x2a4/0x34c)
[    5.800515]  r8:0000082c r7:0000052d r6:c7976430 r5:c797643c r4:c7976410
[    5.807230] [<c0221edc>] (bcma_bus_register) from [<c0227158>]
(bcma_host_soc_probe+0x70/0x90)
[    5.815808]  r8:00000000 r7:00000000 r6:c6dea374 r5:c78f1a00
r4:c7976410 r3:dc8ba303
[    5.823568] [<c02270e8>] (bcma_host_soc_probe) from [<c01cc698>]
(platform_drv_probe+0x34/0x64)
[    5.832238]  r6:c03e1930 r5:c03e1930 r4:c78f1a10 r3:c02270e8
[    5.837909] [<c01cc664>] (platform_drv_probe) from [<c01cb0e0>]
(driver_probe_device+0xf4/0x258)
[    5.846663]  r5:00000000 r4:c78f1a10
[    5.850246] [<c01cafec>] (driver_probe_device) from [<c01cb300>]
(__driver_attach+0x70/0x94)
[    5.858636]  r7:00000000 r6:c03e1930 r5:c78f1a44 r4:c78f1a10
[    5.864314] [<c01cb290>] (__driver_attach) from [<c01c9774>]
(bus_for_each_dev+0x7c/0x90)
[    5.872461]  r6:c01cb290 r5:c03e1930 r4:00000000 r3:c01cb290
[    5.878128] [<c01c96f8>] (bus_for_each_dev) from [<c01cabf0>]
(driver_attach+0x20/0x28)
[    5.886094]  r6:c03db6d4 r5:c79d2a80 r4:c03e1930
[    5.890726] [<c01cabd0>] (driver_attach) from [<c01ca890>]
(bus_add_driver+0xe4/0x1d4)
[    5.898613] [<c01ca7ac>] (bus_add_driver) from [<c01cb784>]
(driver_register+0xa4/0xe8)
[    5.906580]  r7:c03d3468 r6:c03b9478 r5:c03d3468 r4:c03e1930
[    5.912257] [<c01cb6e0>] (driver_register) from [<c01cc650>]
(__platform_driver_register+0x50/0x64)
[    5.921268]  r5:c03d3468 r4:c7954240
[    5.924850] [<c01cc600>] (__platform_driver_register) from
[<c03b9618>] (bcma_host_soc_register_driver+0x18/0x20)
[    5.935078] [<c03b9600>] (bcma_host_soc_register_driver) from
[<c03b9488>] (bcma_modinit+0x10/0x44)
[    5.944097] [<c03b9478>] (bcma_modinit) from [<c001318c>]
(do_one_initcall+0x1a4/0x1e0)
[    5.952081] [<c0012fe8>] (do_one_initcall) from [<c03a2e64>]
(kernel_init_freeable+0x118/0x1e8)
[    5.960746]  r9:c03e5b50 r8:c03e5b58 r7:0000002f r6:c03c9f68
r5:c03c5458 r4:00000006
[    5.968507] [<c03a2d4c>] (kernel_init_freeable) from [<c000e178>]
(kernel_init+0x10/0x104)
[    5.976737]  r9:00000000 r8:00000000 r7:00000000 r6:00000000
r5:c000e168 r4:00000000
[    5.984496] [<c000e168>] (kernel_init) from [<c0009728>]
(ret_from_fork+0x14/0x2c)
[    5.992038]  r4:00000000 r3:c782a000
[    5.995608] ---[ end trace abf3e8af98903007 ]---
[    6.000294] ------------[ cut here ]------------
[    6.004909] WARNING: CPU: 0 PID: 1 at lib/kobject.c:675
kobject_put+0x3c/0x80()
[    6.012198] kobject: 'bcma0:0' (c7a35c18): is not initialized, yet
kobject_put() is being called.
[    6.021033] Modules linked in:
[    6.024082] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W
4.1.3 #4
[    6.031103] Hardware name: BCM5301X
[    6.034573] Backtrace:
[    6.037024] [<c001612c>] (dump_backtrace) from [<c0016338>]
(show_stack+0x18/0x1c)
[    6.044563]  r6:c035e365 r5:00000009 r4:00000000 r3:dc8ba303
[    6.050248] [<c0016320>] (show_stack) from [<c016a998>]
(dump_stack+0x7c/0x98)
[    6.057450] [<c016a91c>] (dump_stack) from [<c00206e8>]
(warn_slowpath_common+0x90/0xbc)
[    6.065504]  r4:c782bc28 r3:dc8ba303
[    6.069083] [<c0020658>] (warn_slowpath_common) from [<c002074c>]
(warn_slowpath_fmt+0x38/0x40)
[    6.077748]  r8:00000000 r7:c7a35c10 r6:fffffffe r5:c7987408 r4:c7a35c18
[    6.084481] [<c0020718>] (warn_slowpath_fmt) from [<c016c6a8>]
(kobject_put+0x3c/0x80)
[    6.092371]  r3:c7954040 r2:c035e3c1
[    6.095959] [<c016c66c>] (kobject_put) from [<c01c764c>]
(put_device+0x1c/0x20)
[    6.103237]  r4:c7987400
[    6.105778] [<c01c7630>] (put_device) from [<c01c8950>]
(device_add+0x294/0x518)
[    6.113157] [<c01c86bc>] (device_add) from [<c01c8d34>]
(device_create_groups_vargs+0x84/0xcc)
[    6.121733]  r10:00000000 r9:c03d0408 r8:00000000 r7:c7a35c10
r6:c03da2b0 r5:00000000
[    6.129561]  r4:c7987400
[    6.132105] [<c01c8cb0>] (device_create_groups_vargs) from
[<c01c8e10>] (device_create_with_groups+0x30/0x38)
[    6.141977]  r8:0000082c r7:00000000 r6:c03da2b0 r5:a0000113
r4:c7976464 r3:c7976464
[    6.149736] [<c01c8de0>] (device_create_with_groups) from
[<c019ba74>] (gpiochip_export+0x58/0x94)
[    6.158668] [<c019ba1c>] (gpiochip_export) from [<c0198dfc>]
(gpiochip_add+0x1e0/0x268)
[    6.166636]  r6:c7a5da00 r5:a0000113 r4:c7976464
[    6.171277] [<c0198c1c>] (gpiochip_add) from [<c0226428>]
(bcma_gpio_init+0xd4/0x1d8)
[    6.179069]  r7:0000052d r6:c7976464 r5:c797643c r4:c797643c
[    6.184747] [<c0226354>] (bcma_gpio_init) from [<c0222180>]
(bcma_bus_register+0x2a4/0x34c)
[    6.193066]  r8:0000082c r7:0000052d r6:c7976430 r5:c797643c r4:c7976410
[    6.199786] [<c0221edc>] (bcma_bus_register) from [<c0227158>]
(bcma_host_soc_probe+0x70/0x90)
[    6.208350]  r8:00000000 r7:00000000 r6:c6dea374 r5:c78f1a00
r4:c7976410 r3:dc8ba303
[    6.216110] [<c02270e8>] (bcma_host_soc_probe) from [<c01cc698>]
(platform_drv_probe+0x34/0x64)
[    6.224779]  r6:c03e1930 r5:c03e1930 r4:c78f1a10 r3:c02270e8
[    6.230459] [<c01cc664>] (platform_drv_probe) from [<c01cb0e0>]
(driver_probe_device+0xf4/0x258)
[    6.239202]  r5:00000000 r4:c78f1a10
[    6.242788] [<c01cafec>] (driver_probe_device) from [<c01cb300>]
(__driver_attach+0x70/0x94)
[    6.251186]  r7:00000000 r6:c03e1930 r5:c78f1a44 r4:c78f1a10
[    6.256855] [<c01cb290>] (__driver_attach) from [<c01c9774>]
(bus_for_each_dev+0x7c/0x90)
[    6.265002]  r6:c01cb290 r5:c03e1930 r4:00000000 r3:c01cb290
[    6.270678] [<c01c96f8>] (bus_for_each_dev) from [<c01cabf0>]
(driver_attach+0x20/0x28)
[    6.278636]  r6:c03db6d4 r5:c79d2a80 r4:c03e1930
[    6.283268] [<c01cabd0>] (driver_attach) from [<c01ca890>]
(bus_add_driver+0xe4/0x1d4)
[    6.291164] [<c01ca7ac>] (bus_add_driver) from [<c01cb784>]
(driver_register+0xa4/0xe8)
[    6.299129]  r7:c03d3468 r6:c03b9478 r5:c03d3468 r4:c03e1930
[    6.304807] [<c01cb6e0>] (driver_register) from [<c01cc650>]
(__platform_driver_register+0x50/0x64)
[    6.313819]  r5:c03d3468 r4:c7954240
[    6.317402] [<c01cc600>] (__platform_driver_register) from
[<c03b9618>] (bcma_host_soc_register_driver+0x18/0x20)
[    6.327627] [<c03b9600>] (bcma_host_soc_register_driver) from
[<c03b9488>] (bcma_modinit+0x10/0x44)
[    6.336646] [<c03b9478>] (bcma_modinit) from [<c001318c>]
(do_one_initcall+0x1a4/0x1e0)
[    6.344632] [<c0012fe8>] (do_one_initcall) from [<c03a2e64>]
(kernel_init_freeable+0x118/0x1e8)
[    6.353298]  r9:c03e5b50 r8:c03e5b58 r7:0000002f r6:c03c9f68
r5:c03c5458 r4:00000006
[    6.361071] [<c03a2d4c>] (kernel_init_freeable) from [<c000e178>]
(kernel_init+0x10/0x104)
[    6.369295]  r9:00000000 r8:00000000 r7:00000000 r6:00000000
r5:c000e168 r4:00000000
[    6.377055] [<c000e168>] (kernel_init) from [<c0009728>]
(ret_from_fork+0x14/0x2c)
[    6.384596]  r4:00000000 r3:c782a000
[    6.388166] ---[ end trace abf3e8af98903008 ]---
[    6.392786] gpiochip_add: GPIOs 0..31 (bcma_gpio) failed to register
[    6.399105] bcma: bus0: Error registering GPIO driver: -2
[    6.404839] bcm47xx-wdt bcm47xx-wdt.0: BCM47xx Watchdog Timer enabled
(30 seconds, Software Timer)


