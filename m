Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:60153 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbbGZMcq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2015 08:32:46 -0400
Message-ID: <55B4D36B.7010701@hauke-m.de> (sfid-20150726_143635_803371_704ADB21)
Date: Sun, 26 Jul 2015 14:32:43 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
References: <1437512677-6153-1-git-send-email-linus.walleij@linaro.org> <55B3EC92.1070704@hauke-m.de>
In-Reply-To: <55B3EC92.1070704@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/25/2015 10:07 PM, Hauke Mehrtens wrote:
> Hi,
> 
> I found some compile problems in the code, but I haven't runtime tested
> it, but will do that.
> 
> Hauke
> 
Currently there is a NACK from me, but generally I like that this patch
removes some code.

I tested with patch on top of kernel 4.1.3 with OpenWrt trunk on a
Netgear r6250 and it results in this error message:


[    7.488170] ------------[ cut here ]------------
[    7.492824] WARNING: CPU: 0 PID: 390 at drivers/gpio/gpiolib.c:86
gpio_to_desc+0xa4/0xbc()
[    7.501058] invalid GPIO -517
[    7.504011] Modules linked in: gpio_button_hotplug(+) usbcore
nls_base usb_common
[    7.511518] CPU: 0 PID: 390 Comm: kmodloader Not tainted 4.1.3 #1
[    7.517575] Hardware name: BCM5301X
[    7.521050] Backtrace:
[    7.523523] [<c001612c>] (dump_backtrace) from [<c0016338>]
(show_stack+0x18/0x1c)
[    7.531072]  r6:c0362368 r5:00000009 r4:00000000 r3:dc8ba303
[    7.536748] [<c0016320>] (show_stack) from [<c016a998>]
(dump_stack+0x7c/0x98)
[    7.543968] [<c016a91c>] (dump_stack) from [<c00206e8>]
(warn_slowpath_common+0x90/0xbc)
[    7.552025]  r4:c717bbe0 r3:dc8ba303
[    7.555612] [<c0020658>] (warn_slowpath_common) from [<c002074c>]
(warn_slowpath_fmt+0x38/0x40)
[    7.564275]  r8:c71b3a10 r7:c78f7210 r6:fffffdfb r5:fffffdfb r4:c03da260
[    7.570999] [<c0020718>] (warn_slowpath_fmt) from [<c0199630>]
(gpio_to_desc+0xa4/0xbc)
[    7.578964]  r3:fffffdfb r2:c0362477
[    7.582549] [<c019958c>] (gpio_to_desc) from [<c019a4d4>]
(gpio_request+0x18/0x3c)
[    7.590091]  r5:fffffdfb r4:c053c7d0
[    7.593676] [<c019a4bc>] (gpio_request) from [<c0197ea4>]
(devm_gpio_request+0x3c/0x74)
[    7.601643]  r5:c053c7d0 r4:c79d3f50
[    7.605228] [<c0197e68>] (devm_gpio_request) from [<bf02d3e8>]
(gpio_keys_remove+0x3e8/0x668 [gpio_button_hotplug])
[    7.615615]  r7:c71b3a10 r6:0000002c r5:c78f7210 r4:c717e950
[    7.621295] [<bf02d04c>] (gpio_keys_remove [gpio_button_hotplug])
from [<bf02d834>] (gpio_keys_probe+0x20/0x1b4 [gpio_button_hotplug])
[    7.633326]  r10:c717bf40 r9:c03d0408 r8:00000000 r7:c78f7200
r6:bf02dfc0 r5:bf02dfc0
[    7.641163]  r4:c78f7210
[    7.643701] [<bf02d814>] (gpio_keys_probe [gpio_button_hotplug]) from
[<c01cc698>] (platform_drv_probe+0x34/0x64)
[    7.653915]  r10:c717bf40 r9:c03d0408 r8:00000000 r7:00000001
r6:bf02dfc0 r5:bf02dfc0
[    7.661751]  r4:c78f7210
[    7.664285] [<c01cc664>] (platform_drv_probe) from [<c01cb0e0>]
(driver_probe_device+0xf4/0x258)
[    7.673034]  r5:00000000 r4:c78f7210
[    7.676612] [<c01cafec>] (driver_probe_device) from [<c01cb300>]
(__driver_attach+0x70/0x94)
[    7.685010]  r7:00000000 r6:bf02dfc0 r5:c78f7244 r4:c78f7210
[    7.690696] [<c01cb290>] (__driver_attach) from [<c01c9774>]
(bus_for_each_dev+0x7c/0x90)
[    7.698835]  r6:c01cb290 r5:bf02dfc0 r4:00000000 r3:c01cb290
[    7.704511] [<c01c96f8>] (bus_for_each_dev) from [<c01cabf0>]
(driver_attach+0x20/0x28)
[    7.712485]  r6:c03db6d4 r5:c792e600 r4:bf02dfc0
[    7.717110] [<c01cabd0>] (driver_attach) from [<c01ca890>]
(bus_add_driver+0xe4/0x1d4)
[    7.725006] [<c01ca7ac>] (bus_add_driver) from [<c01cb784>]
(driver_register+0xa4/0xe8)
[    7.732984]  r7:c03d3468 r6:bf030000 r5:c03d3468 r4:bf02dfc0
[    7.738656] [<c01cb6e0>] (driver_register) from [<c01cc650>]
(__platform_driver_register+0x50/0x64)
[    7.747668]  r5:c03d3468 r4:c78d7640
[    7.751257] [<c01cc600>] (__platform_driver_register) from
[<bf030018>] (init_module+0x18/0x50 [gpio_button_hotplug])
[    7.761837] [<bf030000>] (init_module [gpio_button_hotplug]) from
[<c001318c>] (do_one_initcall+0x1a4/0x1e0)
[    7.771627]  r4:c78d7640 r3:00000000
[    7.775216] [<c0012fe8>] (do_one_initcall) from [<c006f9b0>]
(do_init_module+0x60/0x1a8)
[    7.783273]  r9:c006e734 r8:bf02e36c r7:00000015 r6:c78d75c0
r5:c71b3d7c r4:bf02e36c
[    7.791034] [<c006f950>] (do_init_module) from [<c0070fac>]
(load_module+0x13cc/0x1854)
[    7.798998]  r6:00000000 r5:c71b3d7c r4:c71b3c00
[    7.803631] [<c006fbe0>] (load_module) from [<c007152c>]
(SyS_init_module+0xf8/0x124)
[    7.811430]  r10:00000000 r9:000122f7 r8:c717a000 r7:00acf500
r6:c8a734f0 r5:00000000
[    7.819258]  r4:000024f0
[    7.821802] [<c0071434>] (SyS_init_module) from [<c0009680>]
(ret_fast_syscall+0x0/0x3c)
[    7.829860]  r9:c717a000 r8:c0009824 r7:00000080 r6:00000000
r5:00000000 r4:00000000
[    7.837604] ---[ end trace 2277938710cf7c41 ]---
[    7.842209] gpiod_request: invalid GPIO
[    7.846038] gpio-keys gpio-keys: unable to claim gpio 4294966779, err=-22
[    7.852820] gpio-keys: probe of gpio-keys failed with error -22


