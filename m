Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56806.mail.re3.yahoo.com ([66.196.97.80]:37290 "HELO
	web56806.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754754Ab0LMM1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 07:27:49 -0500
Message-ID: <688860.58781.qm@web56806.mail.re3.yahoo.com>
Date: Mon, 13 Dec 2010 04:27:48 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH 04/17] rt2x00: fix hang when unplugging USB device in use
To: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, js@sig21.net
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <201012131232.50201.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Signed-off-by: Johannes Stezenbach <js@sig21.net>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
Hi.

I have two issues to report regarding system hangs. The system would either freeze entirely, prompting me to hard-reset it, or it would freeze certain parts of the system like, no shell commands execution. These occurrences manifest themselves sporadically, when I'm switching between modes (ad-hoc, monitor etc.), also when I try to rmmod the rt2xxx stuff or when unplugging the USB chip. I have to "ifconcfig wlanx down" the device first in order to not hang my box. My question is, will this patch fix all of that, or only parts of it? Here's log I managed to dig out.

[   67.784831] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x1718 with error -19.
[   67.789440] BUG: unable to handle kernel NULL pointer dereference at 00000004
[   67.789455] IP: [<f833e536>] rt2x00usb_kick_tx_entry+0x16/0xc0 [rt2x00usb]
[   67.789470] *pde = 7e56c067

[   67.789564] 
[   67.789571] Pid: 21, comm: khubd Not tainted 2.6.35-23-generic #41-Ubuntu Latitude C840            /Latitude C840                   
[   67.789577] EIP: 0060:[<f833e536>] EFLAGS: 00010282 CPU: 0
[   67.789583] EIP is at rt2x00usb_kick_tx_entry+0x16/0xc0 [rt2x00usb]
[   67.789588] EAX: 00000000 EBX: 00000000 ECX: 00000001 EDX: 00000000
[   67.789592] ESI: f833e520 EDI: 00000001 EBP: f712bc7c ESP: f712bc68
[   67.789597]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   67.789602] Process khubd (pid: 21, ti=f712a000 task=f7130000 task.ti=f712a000)
[   67.789606] Stack:
[   67.789609]  f712bc7c c05c94ef f20b603c f833e520 00000001 f712bcb4 f90c1825 c012ced8
[   67.789620] <0> f712bc9c c05c94ef f712bc9c 00000286 00000004 00000000 f20b6048 00000001
[   67.789631] <0> f20b6078 f20b603c f20cb040 f712bcc0 f833e7fe f833e520 f712bcdc f90c0198
[   67.789644] Call Trace:
[   67.789656]  [<c05c94ef>] ? _raw_spin_lock_irqsave+0x2f/0x50
[   67.789663]  [<f833e520>] ? rt2x00usb_kick_tx_entry+0x0/0xc0 [rt2x00usb]
[   67.789675]  [<f90c1825>] ? rt2x00queue_for_each_entry+0xc5/0x120 [rt2x00lib]
[   67.789685]  [<c012ced8>] ? default_spin_lock_flags+0x8/0x10
[   67.789691]  [<c05c94ef>] ? _raw_spin_lock_irqsave+0x2f/0x50
[   67.789699]  [<f833e7fe>] ? rt2x00usb_kick_tx_queue+0x1e/0x20 [rt2x00usb]
[   67.789706]  [<f833e520>] ? rt2x00usb_kick_tx_entry+0x0/0xc0 [rt2x00usb]
[   67.789714]  [<f90c0198>] ? rt2x00mac_flush+0x48/0xd0 [rt2x00lib]
[   67.789738]  [<f9090272>] ? __ieee80211_recalc_idle+0x192/0x1a0 [mac80211]
[   67.789753]  [<f90902ac>] ? ieee80211_recalc_idle+0x2c/0x60 [mac80211]
[   67.789766]  [<f9086642>] ? __ieee80211_scan_completed_finish+0x32/0x90 [mac80211]
[   67.789779]  [<f9086721>] ? ieee80211_scan_cancel+0x81/0x90 [mac80211]
[   67.789794]  [<f9090e77>] ? ieee80211_do_stop+0x4a7/0x4d0 [mac80211]
[   67.789804]  [<c050e5a4>] ? dev_deactivate_queue+0x44/0x60
[   67.789811]  [<c05c9736>] ? _raw_spin_unlock_bh+0x16/0x20
[   67.789817]  [<c050e93e>] ? dev_deactivate+0x17e/0x190
[   67.789832]  [<f9090eb7>] ? ieee80211_stop+0x17/0x20 [mac80211]
[   67.789841]  [<c04f75e6>] ? __dev_close+0x46/0x80
[   67.789849]  [<c0352206>] ? kset_unregister+0x16/0x20
[   67.789856]  [<c04f7639>] ? dev_close+0x19/0x40
[   67.789862]  [<c04f76b5>] ? rollback_registered_many+0x55/0x1d0
[   67.789868]  [<c04f789a>] ? unregister_netdevice_queue+0x1a/0xc0
[   67.789878]  [<f90d7b4f>] ? rt2800_mcu_request+0x6f/0xd0 [rt2800lib]
[   67.789885]  [<c04f7844>] ? unregister_netdevice_many+0x14/0x50
[   67.789900]  [<f9090543>] ? ieee80211_remove_interfaces+0x83/0xc0 [mac80211]
[   67.789906]  [<c05c88b0>] ? down_write+0x10/0x30
[   67.789917]  [<f90820cb>] ? ieee80211_unregister_hw+0x4b/0x120 [mac80211]
[   67.789925]  [<f90bfa60>] ? rt2x00lib_remove_dev+0xd0/0xe0 [rt2x00lib]
[   67.789932]  [<f833e10f>] ? rt2x00usb_disconnect+0x2f/0x70 [rt2x00usb]
[   67.789941]  [<c0475e00>] ? usb_unbind_interface+0x40/0x150
[   67.789949]  [<c0400821>] ? __device_release_driver+0x51/0xb0
[   67.789955]  [<c0400945>] ? device_release_driver+0x25/0x40
[   67.789961]  [<c03ffbcb>] ? bus_remove_device+0x7b/0xa0
[   67.789970]  [<c03fdd17>] ? device_del+0xf7/0x180
[   67.789977]  [<c0472b25>] ? usb_disable_device+0x85/0x100
[   67.789983]  [<c046cf4e>] ? usb_disconnect+0xae/0x140
[   67.789989]  [<c046d4fa>] ? hub_port_connect_change+0x8a/0x8f0
[   67.789995]  [<c04736f3>] ? usb_control_msg+0xd3/0x130
[   67.790003]  [<c0460101>] ? ppp_unattached_ioctl+0x1a1/0x270
[   67.790009]  [<c046ecd0>] ? hub_events+0x2b0/0x4f0
[   67.790019]  [<c016601f>] ? finish_wait+0x4f/0x70
[   67.790024]  [<c046ef4a>] ? hub_thread+0x3a/0x140
[   67.790030]  [<c0165eb0>] ? autoremove_wake_function+0x0/0x50
[   67.790036]  [<c046ef10>] ? hub_thread+0x0/0x140
[   67.790042]  [<c0165a84>] ? kthread+0x74/0x80
[   67.790047]  [<c0165a10>] ? kthread+0x0/0x80
[   67.790055]  [<c010363e>] ? kernel_thread_helper+0x6/0x10
[   67.790058] Code: d8 e8 6f 0d d8 00 eb 8b 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 83 ec 14 89 5d f4 89 75 f8 89 7d fc 0f 1f 44 00 00 89 c3 <8b> 40 04 8b 73 10 8b 00 8b 10 8b 3a 3e 0f ba 33 02 19 d2 85 d2 
[   67.790119] EIP: [<f833e536>] rt2x00usb_kick_tx_entry+0x16/0xc0 [rt2x00usb] SS:ESP 0068:f712bc68
[   67.790128] CR2: 0000000000000004
[   67.790133] ---[ end trace 81dd02b06472de40 ]---

My second question pertains to the STA drivers - rt3070sta. It is not possible to switch between the rt2800usb and rt3070sta without having to unplug the device and plugging it back again followed by loading manually the desired driver.
I'm not sure but I think this might have  something to do withe voltage settings or the firmware. But it really is annoying to physically unplug the USB chip every time I switch between the two modules. 
Is it possible to enable switching between rt3070sta/rt2800usb without unplugging/plugging the USB chip?

Walter


      
