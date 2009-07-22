Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:49929 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZGVAuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 20:50:23 -0400
Received: by an-out-0708.google.com with SMTP id d40so5224901and.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2009 17:50:22 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 21 Jul 2009 17:50:02 -0700
Message-ID: <43e72e890907211750s69420e47ma98b4c3214dfd1f1@mail.gmail.com>
Subject: lockdep complaint on tip + some pending patches
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While running on wireless-testing + netns pending patches + wow patches:

wpa_supplicant -D wext -i wlan1 -c mosca.conf

[  233.096916] phy0: device now idle
[  233.114625] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  234.116189] phy0: device no longer idle - scanning
[  234.233767]
[  234.233772] =======================================================
[  234.233797] [ INFO: possible circular locking dependency detected ]
[  234.233807] 2.6.31-rc3-wl #16
[  234.233814] -------------------------------------------------------
[  234.233824] wpa_supplicant/3089 is trying to acquire lock:
[  234.233835]  (cfg80211_mutex){+.+.+.}, at: [<f83eb185>]
cfg80211_get_dev_from_ifindex+0x15/0x80 [cfg80211]
[  234.233887]
[  234.233889] but task is already holding lock:
[  234.233901]  (rtnl_mutex){+.+.+.}, at: [<c049de2f>] rtnl_lock+0xf/0x20
[  234.233932]
[  234.233934] which lock already depends on the new lock.
[  234.233936]
[  234.233957]
[  234.233958] the existing dependency chain (in reverse order) is:
[  234.233970]
[  234.233972] -> #1 (rtnl_mutex){+.+.+.}:
[  234.233996]        [<c0169b35>] __lock_acquire+0xba5/0x1020
[  234.234014]        [<c016a06b>] lock_acquire+0xbb/0xe0
[  234.234029]        [<c05838f4>] mutex_lock_nested+0x54/0x300
[  234.234045]        [<c049de2f>] rtnl_lock+0xf/0x20
[  234.234061]        [<f83f734a>]
nl80211_send_reg_change_event+0x1aa/0x250 [cfg80211]
[  234.234101]        [<f83ed75b>] set_regdom+0x21b/0x4b0 [cfg80211]
[  234.234133]        [<f83f1d84>] nl80211_set_reg+0xe4/0x270 [cfg80211]
[  234.234165]        [<c04b04cf>] genl_rcv_msg+0x1df/0x210
[  234.234183]        [<c04af6c6>] netlink_rcv_skb+0x76/0xa0
[  234.234199]        [<c04b02de>] genl_rcv+0x1e/0x30
[  234.234215]        [<c04af3fb>] netlink_unicast+0x23b/0x250
[  234.234231]        [<c04afedb>] netlink_sendmsg+0x1db/0x2d0
[  234.234246]        [<c048481a>] soc[  234.234265]
[<c0484951>] sys_sendmsg+0x111/0x230
[  234.234281]        [<c04850fa>] sys_socketcall+0xca/0x2a0
[  234.234297]        [<c010300c>] sysenter_do_call+0x12/0x38
[  234.234314]        [<ffffffff>] 0xffffffff
[  234.234353]
[  234.234355] -> #0 (cfg80211_mutex){+.+.+.}:
[  234.234383]        [<c0169be6>] __lock_acquire+0xc56/0x1020
[  234.234400]        [<c016a06b>] lock_acquire+0xbb/0xe0
[  234.234415]        [<c05838f4>] mutex_lock_nested+0x54/0x300
[  234.234431]        [<f83eb185>]
cfg80211_get_dev_from_ifindex+0x15/0x80 [cfg80211]
[  234.234462]        [<f83ef595>] cfg80211_wext_giwscan+0x35/0xc00 [cfg80211]
[  234.234492]        [<c0566fe9>] ioctl_standard_call+0x199/0x3a0
[  234.234508]        [<c0566aef>] wext_handle_ioctl+0x14f/0x230
[  234.234524]        [<c0495524>] dev_ioctl+0x474/0x540
[  234.234541]        [<c0482e75>] sock_ioctl+0xf5/0x270
[  234.234555]        [<c01f11a8>] vfs_ioctl+0x28/0x90
[  234.234573]        [<c01f135a>] do_vfs_ioctl+0x6a/0x5e0
[  234.234589]        [<c01f1933>] sys_ioctl+0x63/0x70
[  234.234607]        [<c010300c>] sysenter_do_call+0x12/0x38
[  234.234622]        [<ffffffff>] 0xffffffff
[  234.234640]
[  234.234641] other info that might help us debug this:
k_sendmsg+0xea/0x110
[  234.234658] 1 lock held by wpa_supplicant/3089:
[  234.234665]  #0:  (rtnl_mutex){+.+.+.}, at: [<c049de2f>] rtnl_lock+0xf/0x20
[  234.234693]
[  234.234695] stack backtrace:
[  234.234710] Pid: 3089, comm: wpa_supplicant Not tainted 2.6.31-rc3-wl #16
[  234.234719] Call Trace:
[  234.234733]  [<c0582215>] ? printk+0x18/0x1b
[  234.234747]  [<c01685b4>] print_circular_bug_tail+0x84/0xd0
[  234.234761]  [<c0169be6>] __lock_acquire+0xc56/0x1020
[  234.234774]  [<c016a06b>] lock_acquire+0xbb/0xe0
[  234.234802]  [<f83eb185>] ? cfg80211_get_dev_from_ifindex+0x15/0x80
[cfg80211]
[  234.234816]  [<c05838f4>] mutex_lock_nested+0x54/0x300
[  234.234842]  [<f83eb185>] ? cfg80211_get_dev_from_ifindex+0x15/0x80
[cfg80211]
[  234.234857]  [<c012bb7b>] ? __wake_up+0x1b/0x50
[  234.234869]  [<c0585535>] ? _spin_unlock_irqrestore+0x35/0x60
[  234.234896]  [<f83eb185>] cfg80211_get_dev_from_ifindex+0x15/0x80 [cfg80211]
[  234.234924]  [<f83ef595>] cfg80211_wext_giwscan+0x35/0xc00 [cfg80211]
[  234.234939]  [<c01689f3>] ? mark_held_locks+0x63/0x80
[  234.234951]  [<c01dc23d>] ? __kmalloc+0x9d/0x1d0
[  234.234964]  [<c0168cbc>] ? trace_hardirqs_on_caller+0x12c/0x170
[  234.234979]  [<c0168d0b>] ? trace_hardirqs_on+0xb/0x10
[  234.234991]  [<c0566fb3>] ? ioctl_standard_call+0x163/0x3a0
[  234.235004]  [<c01689f3>] ? mark_held_locks+0x63/0x80
[  234.235016]  [<c0566fe9>] ioctl_standard_call+0x199/0x3a0
[  234.235028]  [<c049de2f>] ? rtnl_lock+0xf/0x20
[  234.235043]  [<c049499d>] ? __dev_get_by_name+0x7d/0xa0
[  234.235055]  [<c0566aef>] wext_handle_ioctl+0x14f/0x230
[  234.235083]  [<f83ef560>] ? cfg80211_wext_giwscan+0x0/0xc00 [cfg80211]
[  234.235097]  [<c0495524>] dev_ioctl+0x474/0x540
[  234.235109]  [<c0482d80>] ? sock_ioctl+0x0/0x270
[  234.235121]  [<c0482e75>] sock_ioctl+0xf5/0x270
[  234.235132]  [<c0482d80>] ? sock_ioctl+0x0/0x270
[  234.235144]  [<c01f11a8>] vfs_ioctl+0x28/0x90
[  234.235157]  [<c01f135a>] do_vfs_ioctl+0x6a/0x5e0
[  234.235171]  [<c01c3feb>] ? might_fault+0x4b/0xa0
[  234.235183]  [<c01c4037>] ? might_fault+0x97/0xa0
[  234.235198]  [<c01c3feb>] ? might_fault+0x4b/0xa0
[  234.235210]  [<c0103041>] ? sysenter_exit+0xf/0x1a
[  234.235222]  [<c01f1933>] sys_ioctl+0x63/0x70
[  234.235234]  [<c010300c>] sysenter_do_call+0x12/0x38
[  234.792004] cfg80211: Found new beacon on frequency: 5180 MHz (Ch 36) on phy0
[  234.906721] cfg80211: Found new beacon on frequency: 5200 MHz (Ch 40) on phy0
[  235.089212] cfg80211: Found new beacon on frequency: 5220 MHz (Ch 44) on phy0
[  235.231620] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy0
[  235.231671] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy0
[  235.231696] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy0
[  235.866781] cfg80211: Found new beacon on frequency: 5745 MHz (Ch
149) on phy0
[  236.416552] phy0: device now idle
[  244.243725] phy0: device no longer idle - scanning
[  246.257179] cfg80211: Found new beacon on frequency: 5785 MHz (Ch
157) on phy0
[  246.533629] phy0: device now idle
[  251.530506] phy0: device no longer idle - scanning
[  253.822071] phy0: device now idle
[  258.816267] phy0: device no longer idle - scanning
[  261.109986] phy0: device now idle
[  266.106730] phy0: device no longer idle - scanning
[  268.409957] phy0: device now idle
