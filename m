Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:39633 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaGGHm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 03:42:57 -0400
Received: by mail-ig0-f180.google.com with SMTP id h18so4070794igc.7
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 00:42:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1404587237-26187-1-git-send-email-andrea.merello@gmail.com>
References: <1404587237-26187-1-git-send-email-andrea.merello@gmail.com>
Date: Mon, 7 Jul 2014 09:42:56 +0200
Message-ID: <CAGXE3d-o0xvzC4sQ+haTrvh3yK-8M7PVfeJRw9H4s0WjF440TA@mail.gmail.com> (sfid-20140707_094303_670913_55B0E388)
Subject: Re: [PATCH] rt2800usb: Don't perform DMA from stack
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: Ivo Van Doorn <IvDoorn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, mattias.nissler@gmx.de,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	rain_maker@root-forum.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 5, 2014 at 9:07 PM, Andrea Merello <andrea.merello@gmail.com> wrote:
> Function rt2800usb_autorun_detect() passes the address of a variable
> allocated onto the stack to be used for DMA by the USB layer. This has
> been caught by my debugging-enabled kernel.
>
> This patch change things in order to allocate that variable via
> kmalloc, and it adjusts things to handle the kmalloc failure case,
> propagating the error.
>
> [ 7363.238852] ------------[ cut here ]------------
> [ 7363.243529] WARNING: CPU: 1 PID: 5235 at lib/dma-debug.c:1153 check_for_stack+0xa4/0xf0()
> [ 7363.251759] ehci-pci 0000:00:04.1: DMA-API: device driver maps memory fromstack [addr=ffff88006b81bad4]
> [ 7363.261210] Modules linked in: rt2800usb(O+) rt2800lib(O) rt2x00usb(O) rt2x00lib(O) rtl818x_pci(O) rtl8187 led_class eeprom_93cx6 mac80211 cfg80211 [last unloaded: rt2x00lib]
> [ 7363.277143] CPU: 1 PID: 5235 Comm: systemd-udevd Tainted: G           O  3.16.0-rc3-wl+ #31
> [ 7363.285546] Hardware name: System manufacturer System Product Name/M3N78 PRO, BIOS ASUS M3N78 PRO ACPI BIOS Revision 1402 12/04/2009
> [ 7363.297511]  0000000000000009 ffff88006b81b710 ffffffff8175dcad ffff88006b81b758
> [ 7363.305062]  ffff88006b81b748 ffffffff8106d372 ffff88006cf10098 ffff88006cead6a0
> [ 7363.312622]  ffff88006b81bad4 ffffffff81c1e7c0 ffff88006cf10098 ffff88006b81b7a8
> [ 7363.320161] Call Trace:
> [ 7363.322661]  [<ffffffff8175dcad>] dump_stack+0x4d/0x6f
> [ 7363.327847]  [<ffffffff8106d372>] warn_slowpath_common+0x82/0xb0
> [ 7363.333893]  [<ffffffff8106d3e7>] warn_slowpath_fmt+0x47/0x50
> [ 7363.339686]  [<ffffffff813a93b4>] check_for_stack+0xa4/0xf0
> [ 7363.345298]  [<ffffffff813a995c>] debug_dma_map_page+0x10c/0x150
> [ 7363.351367]  [<ffffffff81521bd9>] usb_hcd_map_urb_for_dma+0x229/0x720
> [ 7363.357890]  [<ffffffff8152256d>] usb_hcd_submit_urb+0x2fd/0x930
> [ 7363.363929]  [<ffffffff810eac31>] ? irq_work_queue+0x71/0xd0
> [ 7363.369617]  [<ffffffff810ab5a7>] ? wake_up_klogd+0x37/0x50
> [ 7363.375219]  [<ffffffff810ab7a5>] ? console_unlock+0x1e5/0x420
> [ 7363.381081]  [<ffffffff810abc25>] ? vprintk_emit+0x245/0x530
> [ 7363.386773]  [<ffffffff81523d3c>] usb_submit_urb+0x30c/0x580
> [ 7363.392462]  [<ffffffff81524295>] usb_start_wait_urb+0x65/0xf0
> [ 7363.398325]  [<ffffffff815243ed>] usb_control_msg+0xcd/0x110
> [ 7363.404014]  [<ffffffffa005514d>] rt2x00usb_vendor_request+0xbd/0x170 [rt2x00usb]
> [ 7363.411544]  [<ffffffffa0074292>] rt2800usb_autorun_detect+0x32/0x50 [rt2800usb]
> [ 7363.418986]  [<ffffffffa0074aa1>] rt2800usb_read_eeprom+0x11/0x70 [rt2800usb]
> [ 7363.426168]  [<ffffffffa0063ffd>] rt2800_probe_hw+0x11d/0xf90 [rt2800lib]
> [ 7363.432989]  [<ffffffffa0074b7d>] rt2800usb_probe_hw+0xd/0x50 [rt2800usb]
> [ 7363.439808]  [<ffffffffa00453d8>] rt2x00lib_probe_dev+0x238/0x7c0 [rt2x00lib]
> [ 7363.446992]  [<ffffffffa00bfa48>] ? ieee80211_led_names+0xb8/0x100 [mac80211]
> [ 7363.454156]  [<ffffffffa0056116>] rt2x00usb_probe+0x156/0x1f0 [rt2x00usb]
> [ 7363.460971]  [<ffffffffa0074250>] rt2800usb_probe+0x10/0x20 [rt2800usb]
> [ 7363.467616]  [<ffffffff8152799e>] usb_probe_interface+0xce/0x1c0
> [ 7363.473651]  [<ffffffff81480c20>] really_probe+0x70/0x240
> [ 7363.479079]  [<ffffffff81480f01>] __driver_attach+0xa1/0xb0
> [ 7363.484682]  [<ffffffff81480e60>] ? __device_attach+0x70/0x70
> [ 7363.490461]  [<ffffffff8147eef3>] bus_for_each_dev+0x63/0xa0
> [ 7363.496146]  [<ffffffff814807c9>] driver_attach+0x19/0x20
> [ 7363.501570]  [<ffffffff81480468>] bus_add_driver+0x178/0x220
> [ 7363.507270]  [<ffffffff8148151b>] driver_register+0x5b/0xe0
> [ 7363.512874]  [<ffffffff815271b0>] usb_register_driver+0xa0/0x170
> [ 7363.518905]  [<ffffffffa007a000>] ? 0xffffffffa0079fff
> [ 7363.524074]  [<ffffffffa007a01e>] rt2800usb_driver_init+0x1e/0x20 [rt2800usb]
> [ 7363.531247]  [<ffffffff810002d4>] do_one_initcall+0x84/0x1b0
> [ 7363.536932]  [<ffffffff8113aa60>] ? kfree+0xd0/0x110
> [ 7363.541931]  [<ffffffff8112730a>] ? __vunmap+0xaa/0xf0
> [ 7363.547538]  [<ffffffff810ca07e>] load_module+0x1aee/0x2040
> [ 7363.553141]  [<ffffffff810c6f10>] ? store_uevent+0x50/0x50
> [ 7363.558676]  [<ffffffff810ca66e>] SyS_init_module+0x9e/0xc0
> [ 7363.564285]  [<ffffffff81764012>] system_call_fastpath+0x16/0x1b
> [ 7363.570338] ---[ end trace 01ef5f822bea9882 ]---
>
> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

Really good catch!
Thanks a lot Andrea.
