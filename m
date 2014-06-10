Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:62796 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaFJI1C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 04:27:02 -0400
Received: by mail-lb0-f173.google.com with SMTP id 10so3725798lbg.18
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 01:27:00 -0700 (PDT)
Message-ID: <5396C150.6030601@gmail.com> (sfid-20140610_102709_116682_6BB3AE93)
Date: Tue, 10 Jun 2014 10:26:56 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: IvDoorn@gmail.com, helmut.schaa@googlemail.com
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: rt2800usb: scheduling while atomic
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a reproducible sleep in atomic when I set up hostapd with TKIP on 
a rt2800 based USB dongle. As soon as a client connects I see this. I 
guess get_tkip_seq may not sleep.


[  860.827243] BUG: scheduling while atomic: hostapd/3397/0x00000002
[  860.827275] CPU: 0 PID: 3397 Comm: hostapd Tainted: G        W 
3.15.0+ #119
[  860.827275] Hardware name: Dell Inc.          Dell System XPS 
15Z/00WW5M, BIOS A12 09/07/2012
[  860.827276]  ffff88023fa12e00 ffff88022daff600 ffffffff81682ea6 
ffffffff81e6b600
[  860.827278]  ffff88022daff610 ffffffff8167eb9b ffff88022daff670 
ffffffff81685bb3
[  860.827279]  ffff88022c22c8f0 ffff88022dafffd8 0000000000012e00 
0000000000012e00
[  860.827280] Call Trace:
[  860.827282]  [<ffffffff81682ea6>] dump_stack+0x4d/0x66
[  860.827284]  [<ffffffff8167eb9b>] __schedule_bug+0x47/0x55
[  860.827285]  [<ffffffff81685bb3>] __schedule+0x733/0x7b0
[  860.827287]  [<ffffffff81685c59>] schedule+0x29/0x70
[  860.827289]  [<ffffffff81684f8a>] schedule_timeout+0x15a/0x2b0
[  860.827291]  [<ffffffff8105ac50>] ? ftrace_raw_event_tick_stop+0xc0/0xc0
[  860.827294]  [<ffffffff810c13c2>] ? __module_text_address+0x12/0x70
[  860.827296]  [<ffffffff81686823>] wait_for_completion_timeout+0xb3/0x140
[  860.827298]  [<ffffffff81080fc0>] ? wake_up_state+0x20/0x20
[  860.827301]  [<ffffffff814d5b3d>] usb_start_wait_urb+0x7d/0x150
[  860.827303]  [<ffffffff814d5cd5>] usb_control_msg+0xc5/0x110
[  860.827305]  [<ffffffffa02fb0c6>] rt2x00usb_vendor_request+0xc6/0x160 
[rt2x00usb]
[  860.827307]  [<ffffffffa02fb215>] 
rt2x00usb_vendor_req_buff_lock+0x75/0x150 [rt2x00usb]
[  860.827309]  [<ffffffffa02fb393>] 
rt2x00usb_vendor_request_buff+0xa3/0xe0 [rt2x00usb]
[  860.827311]  [<ffffffffa023d1a3>] 
rt2x00usb_register_multiread+0x33/0x40 [rt2800usb]
[  860.827314]  [<ffffffffa05805f9>] rt2800_get_tkip_seq+0x39/0x50 
[rt2800lib]
[  860.827321]  [<ffffffffa0480f88>] ieee80211_get_key+0x218/0x2a0 
[mac80211]
[  860.827322]  [<ffffffff815cc68c>] ? __nlmsg_put+0x6c/0x80
[  860.827329]  [<ffffffffa051b02e>] nl80211_get_key+0x22e/0x360 [cfg80211]
[  860.827334]  [<ffffffffa0512e10>] ? 
cfg80211_rx_unexpected_4addr_frame+0x130/0x130 [cfg80211]
[  860.827340]  [<ffffffffa050ea36>] ? 
__cfg80211_wdev_from_attrs+0x36/0x1a0 [cfg80211]
[  860.827342]  [<ffffffff815d1239>] genl_family_rcv_msg+0x199/0x380
[  860.827345]  [<ffffffff815d1420>] ? genl_family_rcv_msg+0x380/0x380
[  860.827346]  [<ffffffff815d14b1>] genl_rcv_msg+0x91/0xd0
[  860.827348]  [<ffffffff815cf579>] netlink_rcv_skb+0xa9/0xc0
[  860.827350]  [<ffffffff815cfa78>] genl_rcv+0x28/0x40
[  860.827351]  [<ffffffff815cef06>] netlink_unicast+0x166/0x220
[  860.827353]  [<ffffffff815cf2b4>] netlink_sendmsg+0x2f4/0x400
[  860.827355]  [<ffffffff816812fc>] ? __slab_free+0xfe/0x2b4
[  860.827357]  [<ffffffff8158a29b>] sock_sendmsg+0x8b/0xc0
[  860.827359]  [<ffffffff81152457>] ? might_fault+0x47/0x50
[  860.827361]  [<ffffffff81589fc8>] ? move_addr_to_kernel.part.19+0x28/0x80
[  860.827362]  [<ffffffff81152457>] ? might_fault+0x47/0x50
[  860.827364]  [<ffffffff81597dde>] ? verify_iovec+0x5e/0xe0
[  860.827366]  [<ffffffff8158a689>] ___sys_sendmsg+0x369/0x380
[  860.827367]  [<ffffffff811c88bf>] ? 
fsnotify_clear_marks_by_inode+0x2f/0x130
[  860.827369]  [<ffffffff81588f7f>] ? sock_destroy_inode+0x2f/0x40
[  860.827370]  [<ffffffff811a5618>] ? destroy_inode+0x38/0x60
[  860.827372]  [<ffffffff811a575c>] ? evict+0x11c/0x190
[  860.827373]  [<ffffffff811a001f>] ? __d_free+0x3f/0x60
[  860.827375]  [<ffffffff811a0074>] ? dentry_free+0x34/0x40
[  860.827377]  [<ffffffff811a10fd>] ? dput+0xad/0x190
[  860.827379]  [<ffffffff811aa044>] ? mntput+0x24/0x40
[  860.827380]  [<ffffffff8118c07d>] ? __fput+0x18d/0x1f0
[  860.827382]  [<ffffffff8158b3d2>] __sys_sendmsg+0x42/0x80
[  860.827384]  [<ffffffff8158b422>] SyS_sendmsg+0x12/0x20
[  860.827386]  [<ffffffff816927e2>] system_call_fastpath+0x16/0x1b

Cheers,

Pontus Fuchs
