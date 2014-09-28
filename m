Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:40036 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaI1WNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2014 18:13:43 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so1220305wes.39
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2014 15:13:42 -0700 (PDT)
Message-ID: <54288813.60601@gmail.com> (sfid-20140929_001347_946712_5C59968E)
Date: Mon, 29 Sep 2014 00:13:39 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	driverdev-devel@linuxdriverproject.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: RTL8188SU(r8712u) - drivers/usb/core/urb.c:339 usb_submit_urb+0x11d/0x5f0()
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


0bda:8171 Realtek Semiconductor Corp. RTL8188SU 802.11n WLAN Adapter

r8712u: module is from the staging directory, the quality is unknown, you have been warned.
r8712u: Staging version
r8712u: register rtl8712_netdev_ops to netdev_ops
usb 2-1: r8712u: USB_SPEED_HIGH with 4 endpoints
usb 2-1: r8712u: Boot from EFUSE: Autoload OK
usb 2-1: r8712u: CustomerID = 0x0000
usb 2-1: r8712u: MAC Address from efuse = 00:e0:4c:87:00:00
usb 2-1: r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
usbcore: registered new interface driver r8712u
r8712u 2-1:1.0 wlp0s4f1u1: renamed from wlan0
systemd-udevd[394]: renamed network interface wlan0 to wlp0s4f1u1

------------[ cut here ]------------
WARNING: CPU: 3 PID: 679 at drivers/usb/core/urb.c:339 usb_submit_urb+0x11d/0x5f0()
URB ffff8800cb25eb40 submitted while active
Modules linked in: r8712u(C) 
CPU: 3 PID: 679 Comm: NetworkManager Tainted: G         C     3.17.0-0.rc6.git2.1.fc22.x86_64 #1
Call Trace:
 [<ffffffff8173c341>] dump_stack+0x45/0x56
 [<ffffffff81096eed>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81096f6c>] warn_slowpath_fmt+0x5c/0x80
 [<ffffffff817414f6>] ? __down_interruptible+0xa6/0xf0
 [<ffffffff8151f51d>] usb_submit_urb+0x11d/0x5f0
 [<ffffffffa047f7f5>] r8712_usb_write_mem+0xa5/0xc0 [r8712u]
 [<ffffffffa04801ba>] r8712_write_mem+0x1a/0x20 [r8712u]
 [<ffffffffa047de64>] rtl8712_hal_init+0x274/0x7e0 [r8712u]
 [<ffffffffa047e510>] rtl871x_hal_init+0x40/0x60 [r8712u]
 [<ffffffffa048f91e>] netdev_open+0xfe/0x260 [r8712u]
 [<ffffffff8163140e>] __dev_open+0xce/0x150
 [<ffffffff8163173d>] __dev_change_flags+0x9d/0x160
 [<ffffffff81631829>] dev_change_flags+0x29/0x70
 [<ffffffff8163f2b9>] do_setlink+0x409/0xb80
 [<ffffffff812027ab>] ? mem_cgroup_bad_page_check+0x1b/0x30
 [<ffffffff810cf673>] ? find_busiest_group+0x143/0x910
 [<ffffffff813aa7e2>] ? nla_parse+0x32/0x120
 [<ffffffff81641a4d>] rtnl_newlink+0x61d/0x780
 [<ffffffff8130c748>] ? security_capable+0x18/0x20
 [<ffffffff8109f09b>] ? ns_capable+0x2b/0x60
 [<ffffffff8163dea1>] rtnetlink_rcv_msg+0xa1/0x260
 [<ffffffff811f1111>] ? __kmalloc_node_track_caller+0x191/0x2e0
 [<ffffffff81394fd6>] ? rhashtable_lookup_compare+0x36/0x70
 [<ffffffff8163de00>] ? rtnetlink_rcv+0x30/0x30
 [<ffffffff8165fea9>] netlink_rcv_skb+0xa9/0xd0
 [<ffffffff8163ddf8>] rtnetlink_rcv+0x28/0x30
 [<ffffffff8165f4ca>] netlink_unicast+0x12a/0x1a0
 [<ffffffff8165f891>] netlink_sendmsg+0x351/0x7b0
 [<ffffffff8161344e>] sock_sendmsg+0x9e/0xe0
 [<ffffffff8161311e>] ? move_addr_to_kernel.part.20+0x1e/0x70
 [<ffffffff81614021>] ? move_addr_to_kernel+0x21/0x30
 [<ffffffff816138b8>] ___sys_sendmsg+0x3c8/0x3e0
 [<ffffffff8122a685>] ? __fget_light+0x25/0x70
 [<ffffffff81613a4d>] ? SYSC_sendto+0x17d/0x1c0
 [<ffffffff8122a685>] ? __fget_light+0x25/0x70
 [<ffffffff816147d1>] __sys_sendmsg+0x51/0x90
 [<ffffffff81614822>] SyS_sendmsg+0x12/0x20
 [<ffffffff817434a9>] system_call_fastpath+0x16/0x1b
---[ end trace c3332f64cf535dba ]---


