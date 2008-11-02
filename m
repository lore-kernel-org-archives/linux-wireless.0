Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:55600 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbYKBUXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 15:23:35 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mA2KNJf7023656
	for <linux-wireless@vger.kernel.org>; Sun, 2 Nov 2008 14:23:33 -0600
Received: from tikku (essapo-nirac25263.europe.nokia.com [10.162.252.63])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mA2KNTrB017949
	for <linux-wireless@vger.kernel.org>; Sun, 2 Nov 2008 22:23:29 +0200
To: linux-wireless@vger.kernel.org
Subject: Re: 2.6.28-rc2-wl: network lockups with iwl3945
References: <871vxuh70u.fsf@nokia.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 02 Nov 2008 22:23:28 +0200
Message-ID: <87iqr5ri67.fsf@nokia.com> (sfid-20081102_212342_548781_60CD5960)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@nokia.com> writes:

> I have now seen twice a network related lockup with 2.6.28-rc2-wl
> (wireless-testing commit d80fe004), once yesterday and once this
> morning. I'm guessing that it's somehow wireless related, most
> probably a deadlock somewhere. 

I can now easily reproduce this. First run wpa_supplicant and let it
associate:

$ sudo ./wpa_supplicant -i wlan0 -c valo.conf

Then suspend:

$ sudo sh -c 'echo mem > /sys/power/state'

Wake the laptop by pressing Fn key and run ip link:

$ ip link

And that's it, ip will never return. And even shutdown won't work
after this, I need to use sysrq+b to boot the laptop. So this is a
serious regression in wireless-testing.

This has to be somehow related with iwl3945 and it's priv->mutex:

[  570.327722] iwl3945/0     D 00000046     0  1830      2
[  570.327722]  f65ddea0 00000046 f65dde3c 00000046 ffffffff c03c13fc c03c3d60 c03c3d60
[  570.327722]  f6589810 f6589968 c2403d60 00000000 00000296 f648d7c0 00000007 f6589968
[  570.327722]  000173dc 0ab7e978 00000038 205b0003 35393320 3631332e 5d363138 00000000
[  570.327722] Call Trace:
[  570.327722]  [<c02871e4>] __mutex_lock_slowpath+0xef/0x1a5
[  570.327722]  [<c02872bb>] mutex_lock+0x21/0x24
[  570.327722]  [<f8421135>] iwl3945_mac_config+0x1c/0x3bb [iwl3945]
[  570.327722]  [<f8383f82>] ieee80211_hw_config+0x72/0x94 [mac80211]
[  570.327722]  [<f838a2db>] ieee80211_set_disassoc+0x122/0x133 [mac80211]
[  570.327722]  [<f838a3cb>] ieee80211_sta_req_auth+0x3f/0x61 [mac80211]
[  570.327722]  [<f838a41a>] ieee80211_notify_mac+0x2d/0x3d [mac80211]
[  570.327722]  [<f842386a>] iwl3945_bg_alive_start+0x526/0x5be [iwl3945]
[  570.327722]  [<c012e51c>] run_workqueue+0x79/0xf3
[  570.327722]  [<f8423344>] ? iwl3945_bg_alive_start+0x0/0x5be [iwl3945]
[  570.327722]  [<c012e64d>] worker_thread+0xb7/0xc3
[  570.327722]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
[  570.327722]  [<c012e596>] ? worker_thread+0x0/0xc3
[  570.327722]  [<c013115d>] kthread+0x3b/0x61
[  570.327722]  [<c0131122>] ? kthread+0x0/0x61
[  570.327722]  [<c0103c57>] kernel_thread_helper+0x7/0x10
[  570.327722] iwl3945       D f8387f1b     0  1837      2
[  570.327722]  f6b99e18 00000046 f6b99dc8 f8387f1b 043c1438 c03c13fc c03c3d60 c03c3d60
[  570.327722]  f64e2b80 f64e2cd8 c2403d60 00000000 f286d042 f73adc80 c01259c8 f64e2cd8
[  570.327722]  f64e8680 01005140 f286d01c f2a4d760 f64e8680 f6540240 00000246 f6b99e10
[  570.327722] Call Trace:
[  570.327722]  [<f8387f1b>] ? ieee80211_rx_bss_get+0x84/0x8e [mac80211]
[  570.327722]  [<c01259c8>] ? irq_exit+0x53/0x6d
[  570.327722]  [<f8388176>] ? ieee80211_rx_bss_put+0x28/0x9b [mac80211]
[  570.327722]  [<c02871e4>] __mutex_lock_slowpath+0xef/0x1a5
[  570.327722]  [<c02872bb>] mutex_lock+0x21/0x24
[  570.327722]  [<f841fd49>] iwl3945_mac_hw_scan+0x5e/0x3fe [iwl3945]
[  570.327722]  [<c0118cb0>] ? update_curr+0x45/0x85
[  570.327722]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
[  570.327722]  [<f83878c3>] ieee80211_start_scan+0x78/0x200 [mac80211]
[  570.327722]  [<c02317a8>] ? skb_dequeue+0x45/0x4c
[  570.327722]  [<f838c7ee>] ieee80211_sta_work+0xa5/0x5f9 [mac80211]
[  570.327722]  [<c028685c>] ? schedule+0x5f3/0x651
[  570.327722]  [<c012e51c>] run_workqueue+0x79/0xf3
[  570.327722]  [<f838c749>] ? ieee80211_sta_work+0x0/0x5f9 [mac80211]
[  570.327722]  [<c012e64d>] worker_thread+0xb7/0xc3
[  570.327722]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
[  570.327722]  [<c012e596>] ? worker_thread+0x0/0xc3
[  570.327722]  [<c013115d>] kthread+0x3b/0x61
[  570.327722]  [<c0131122>] ? kthread+0x0/0x61
[  570.327722]  [<c0103c57>] kernel_thread_helper+0x7/0x10

-- 
Kalle Valo
