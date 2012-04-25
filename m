Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward4.mail.yandex.net ([77.88.46.9]:41118 "EHLO
	forward4.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2DYQLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 12:11:13 -0400
From: dzivalli dzivalli <dzivalli@yandex.ru>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Problem with TP-LINK TL-WN821N v3
MIME-Version: 1.0
Message-Id: <52591335369895@web28d.yandex.ru> (sfid-20120425_181118_049079_A7F64833)
Date: Wed, 25 Apr 2012 20:04:55 +0400
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone!

Adapter usb: TP-LINK TL-WN821N v3 

I have to be using different versions of ubuntu (x86, x64), to be using Fedora 16. And everywhere there was a same problem. Now I use last stable kernel 3.3.3. 
After several hours the adapter stops working as an access point.
I use a hostapd. After a while, disappear my SSID. I'm stoping hostapd and trying to unload a module ath9k_htc, but it does not work, "modprobe -r ath9k_htc" hangs, in the log appear messages:


Apr 24 01:52:23 s1 kernel: [37922.288169] irqbalance      D 00000000     0   721      1 0x00000000
Apr 24 01:52:23 s1 kernel: [37922.288176]  f7009e30 00000082 00000bf2 00000000 00000000 f5090000 c1809a00 c1809a00
Apr 24 01:52:23 s1 kernel: [37922.288186]  815aee29 00002215 f7907a00 f7371960 f5090000 00000000 f57c4000 f6ef6dd8
Apr 24 01:52:23 s1 kernel: [37922.288196]  f7009e1c c110c2ee fffa6a10 f6ef6dd8 00000029 00000000 f7355cb8 b7742000
Apr 24 01:52:23 s1 kernel: [37922.288206] Call Trace:
Apr 24 01:52:23 s1 kernel: [37922.288218]  [<c110c2ee>] ? handle_mm_fault+0x15e/0x2c0
Apr 24 01:52:23 s1 kernel: [37922.288226]  [<c14f82f7>] ? do_page_fault+0x227/0x490
Apr 24 01:52:23 s1 kernel: [37922.288231]  [<c14f4025>] schedule+0x35/0x50
Apr 24 01:52:23 s1 kernel: [37922.288236]  [<c14f2fb6>] __mutex_lock_slowpath+0xc6/0x120
Apr 24 01:52:23 s1 kernel: [37922.288243]  [<c14f2c64>] mutex_lock+0x24/0x40
Apr 24 01:52:23 s1 kernel: [37922.288248]  [<c144ba72>] rtnl_lock+0x12/0x20
Apr 24 01:52:23 s1 kernel: [37922.288253]  [<c14423d0>] dev_ioctl+0x1a0/0x500
Apr 24 01:52:23 s1 kernel: [37922.288260]  [<c112797d>] ? kmem_cache_alloc_trace+0xfd/0x130
Apr 24 01:52:23 s1 kernel: [37922.288267]  [<c1273353>] ? apparmor_file_alloc_security+0x23/0x50
Apr 24 01:52:23 s1 kernel: [37922.288273]  [<c1240814>] ? security_file_alloc+0x14/0x20
Apr 24 01:52:23 s1 kernel: [37922.288279]  [<c1491d80>] ? udp_poll+0x70/0x70
Apr 24 01:52:23 s1 kernel: [37922.288285]  [<c142cb4a>] sock_ioctl+0x8a/0x290
Apr 24 01:52:23 s1 kernel: [37922.288290]  [<c142cac0>] ? move_addr_to_user+0xa0/0xa0
Apr 24 01:52:23 s1 kernel: [37922.288295]  [<c11481c2>] do_vfs_ioctl+0x82/0x5b0
Apr 24 01:52:23 s1 kernel: [37922.288300]  [<c14f4bfd>] ? _raw_spin_lock+0xd/0x10
Apr 24 01:52:23 s1 kernel: [37922.288305]  [<c11366bc>] ? fd_install+0x4c/0x60
Apr 24 01:52:23 s1 kernel: [37922.288311]  [<c142c4b4>] ? sock_map_fd+0x24/0x30
Apr 24 01:52:23 s1 kernel: [37922.288316]  [<c142d9fd>] ? sys_socket+0x4d/0x80
Apr 24 01:52:23 s1 kernel: [37922.288321]  [<c142ec48>] ? sys_socketcall+0x78/0x2e0
Apr 24 01:52:23 s1 kernel: [37922.288325]  [<c114875f>] sys_ioctl+0x6f/0x80
Apr 24 01:52:23 s1 kernel: [37922.288331]  [<c14fbb9f>] sysenter_do_call+0x12/0x28
Apr 24 01:53:38 s1 kernel: [37996.898288] usbcore: deregistering interface driver ath9k_htc




Apr 24 01:56:23 s1 kernel: [38162.288487] modprobe        D 35ffe000     0  1963   1813 0x00000000
Apr 24 01:56:23 s1 kernel: [38162.288493]  e8073df0 00000086 35ffe000 35ffe000 e8019572 c170c020 c1809a00 c1809a00
Apr 24 01:56:23 s1 kernel: [38162.288504]  0a4623df 0000228f f7807a00 f6db8cb0 c170c020 00000002 00000000 00000001
Apr 24 01:56:23 s1 kernel: [38162.288514]  f6db8cb0 c106b9e0 00100100 00200200 00000001 ed92f7fc c1841f80 e8073dd0
Apr 24 01:56:23 s1 kernel: [38162.288523] Call Trace:
Apr 24 01:56:23 s1 kernel: [38162.288530]  [<c106b9e0>] ? try_to_wake_up+0x230/0x230
Apr 24 01:56:23 s1 kernel: [38162.288535]  [<c14f3fe7>] ? wait_for_completion+0x17/0x20
Apr 24 01:56:23 s1 kernel: [38162.288541]  [<c1058c82>] ? wait_on_work+0x152/0x160
Apr 24 01:56:23 s1 kernel: [38162.288546]  [<c14f4025>] schedule+0x35/0x50
Apr 24 01:56:23 s1 kernel: [38162.288550]  [<c14f2fb6>] __mutex_lock_slowpath+0xc6/0x120
Apr 24 01:56:23 s1 kernel: [38162.288556]  [<c12a0303>] ? blk_throtl_work+0x323/0x4b0
Apr 24 01:56:23 s1 kernel: [38162.288562]  [<c14f2c64>] mutex_lock+0x24/0x40
Apr 24 01:56:23 s1 kernel: [38162.288566]  [<c144ba72>] rtnl_lock+0x12/0x20
Apr 24 01:56:23 s1 kernel: [38162.288589]  [<f8981114>] ieee80211_unregister_hw+0x44/0x110 [mac80211]
Apr 24 01:56:23 s1 kernel: [38162.288598]  [<f875ef0d>] ? ath9k_deinit_leds+0x3d/0x50 [ath9k_htc]
Apr 24 01:56:23 s1 kernel: [38162.288606]  [<f875eaca>] ath9k_htc_disconnect_device+0x3a/0x90 [ath9k_htc]
Apr 24 01:56:23 s1 kernel: [38162.288613]  [<f8756874>] ath9k_htc_hw_deinit+0x14/0x20 [ath9k_htc]
Apr 24 01:56:23 s1 kernel: [38162.288619]  [<f8756bcc>] ath9k_hif_usb_disconnect+0x3c/0x120 [ath9k_htc]
Apr 24 01:56:23 s1 kernel: [38162.288625]  [<c1351b94>] ? __pm_runtime_resume+0x54/0x80
Apr 24 01:56:23 s1 kernel: [38162.288632]  [<c13cf1cc>] usb_unbind_interface+0x3c/0x140
Apr 24 01:56:23 s1 kernel: [38162.288638]  [<c134851b>] __device_release_driver+0x5b/0xb0
Apr 24 01:56:23 s1 kernel: [38162.288643]  [<c1348b3f>] driver_detach+0x8f/0xa0
Apr 24 01:56:23 s1 kernel: [38162.288648]  [<c13483f3>] bus_remove_driver+0x63/0xa0
Apr 24 01:56:23 s1 kernel: [38162.288653]  [<c13491b8>] driver_unregister+0x48/0x80
Apr 24 01:56:23 s1 kernel: [38162.288659]  [<c13ce5f5>] usb_deregister+0xa5/0xb0
Apr 24 01:56:23 s1 kernel: [38162.288665]  [<f8758482>] ath9k_hif_usb_exit+0x12/0x20 [ath9k_htc]
Apr 24 01:56:23 s1 kernel: [38162.288672]  [<f8764d49>] ath9k_htc_exit+0x9/0x2c0 [ath9k_htc]
Apr 24 01:56:23 s1 kernel: [38162.288679]  [<c1090c35>] sys_delete_module+0x135/0x230
Apr 24 01:56:23 s1 kernel: [38162.288684]  [<c110f544>] ? remove_vma+0x44/0x60
Apr 24 01:56:23 s1 kernel: [38162.288688]  [<c111050a>] ? do_munmap+0x16a/0x290
Apr 24 01:56:23 s1 kernel: [38162.288694]  [<c14fbb9f>] sysenter_do_call+0x12/0x28


Is it bug?

