Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:25352 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZBLTHT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 14:07:19 -0500
Subject: possible circular locking triggered from iw
From: reinette chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 12 Feb 2009 11:11:10 -0800
Message-Id: <1234465870.30608.20.camel@rc-desk> (sfid-20090212_200727_602309_F0E5BB47)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Running "iw dev wlan0 scan trigger" resulted in the message below. This
is on the latest wireless-testing and iw. It only happened the first
time I triggered the scan.

[  450.148335] =======================================================
[  450.148453] [ INFO: possible circular locking dependency detected ]
[  450.148521] 2.6.29-rc4-wl #22
[  450.148586] -------------------------------------------------------
[  450.148651] iw/6265 is trying to acquire lock:
[  450.148711]  (rtnl_mutex){--..}, at: [<ffffffff804414c2>] rtnl_lock+0x12/0x20
[  450.148898] 
[  450.148899] but task is already holding lock:
[  450.149008]  (&drv->mtx){--..}, at: [<ffffffffa018e68b>] cfg80211_get_dev_from_ifindex+0x5b/0x80 [cfg80211]
[  450.149221] 
[  450.149222] which lock already depends on the new lock.
[  450.149224] 
[  450.149384] 
[  450.149385] the existing dependency chain (in reverse order) is:
[  450.149498] 
[  450.149499] -> #2 (&drv->mtx){--..}:
[  450.149717]        [<ffffffff8026146f>] validate_chain+0xc1f/0x1270
[  450.149825]        [<ffffffff80261dde>] __lock_acquire+0x31e/0xa30
[  450.149929]        [<ffffffff80262548>] lock_acquire+0x58/0x80
[  450.150032]        [<ffffffff804c523d>] mutex_lock_nested+0x9d/0x2f0
[  450.150138]        [<ffffffffa018e68b>] cfg80211_get_dev_from_ifindex+0x5b/0x80 [cfg80211]
[  450.150265]        [<ffffffffa0191d08>] cfg80211_wext_siwscan+0x58/0x210 [cfg80211]
[  450.150392]        [<ffffffff804b0423>] ioctl_standard_call+0x1a3/0x390
[  450.150498]        [<ffffffff804aff31>] wext_handle_ioctl+0xf1/0x220
[  450.150602]        [<ffffffff80437be9>] dev_ioctl+0x559/0x5b0
[  450.150706]        [<ffffffff80425aa5>] sock_ioctl+0xe5/0x260
[  450.150810]        [<ffffffff802d12b1>] vfs_ioctl+0x31/0x90
[  450.150913]        [<ffffffff802d1640>] do_vfs_ioctl+0x330/0x540
[  450.151015]        [<ffffffff802d18d2>] sys_ioctl+0x82/0xa0
[  450.151117]        [<ffffffff8020c35b>] system_call_fastpath+0x16/0x1b
[  450.151223]        [<ffffffffffffffff>] 0xffffffffffffffff
[  450.151330] 
[  450.151332] -> #1 (cfg80211_drv_mutex){--..}:
[  450.151551]        [<ffffffff8026146f>] validate_chain+0xc1f/0x1270
[  450.151656]        [<ffffffff80261dde>] __lock_acquire+0x31e/0xa30
[  450.151759]        [<ffffffff80262548>] lock_acquire+0x58/0x80
[  450.151861]        [<ffffffff804c523d>] mutex_lock_nested+0x9d/0x2f0
[  450.151965]        [<ffffffffa018e64e>] cfg80211_get_dev_from_ifindex+0x1e/0x80 [cfg80211]
[  450.152010]        [<ffffffffa0191d08>] cfg80211_wext_siwscan+0x58/0x210 [cfg80211]
[  450.152010]        [<ffffffff804b0423>] ioctl_standard_call+0x1a3/0x390
[  450.152010]        [<ffffffff804aff31>] wext_handle_ioctl+0xf1/0x220
[  450.152010]        [<ffffffff80437be9>] dev_ioctl+0x559/0x5b0
[  450.152010]        [<ffffffff80425aa5>] sock_ioctl+0xe5/0x260
[  450.152010]        [<ffffffff802d12b1>] vfs_ioctl+0x31/0x90
[  450.152010]        [<ffffffff802d1640>] do_vfs_ioctl+0x330/0x540
[  450.152010]        [<ffffffff802d18d2>] sys_ioctl+0x82/0xa0
[  450.152010]        [<ffffffff8020c35b>] system_call_fastpath+0x16/0x1b
[  450.152010]        [<ffffffffffffffff>] 0xffffffffffffffff
[  450.152010] 
[  450.152010] -> #0 (rtnl_mutex){--..}:
[  450.152010]        [<ffffffff80261020>] validate_chain+0x7d0/0x1270
[  450.152010]        [<ffffffff80261dde>] __lock_acquire+0x31e/0xa30
[  450.152010]        [<ffffffff80262548>] lock_acquire+0x58/0x80
[  450.152010]        [<ffffffff804c523d>] mutex_lock_nested+0x9d/0x2f0
[  450.152010]        [<ffffffff804414c2>] rtnl_lock+0x12/0x20
[  450.152010]        [<ffffffffa0194c12>] nl80211_trigger_scan+0x52/0x490 [cfg80211]
[  450.152010]        [<ffffffff80453bc1>] genl_rcv_msg+0x181/0x1c0
[  450.152010]        [<ffffffff804509f9>] netlink_rcv_skb+0x89/0xb0
[  450.152010]        [<ffffffff80452f39>] genl_rcv+0x29/0x40
[  450.152010]        [<ffffffff8045077f>] netlink_unicast+0x27f/0x2c0
[  450.152010]        [<ffffffff80450fe1>] netlink_sendmsg+0x231/0x2e0
[  450.152010]        [<ffffffff80426797>] sock_sendmsg+0x127/0x140
[  450.152010]        [<ffffffff804268f2>] sys_sendmsg+0x142/0x260
[  450.152010]        [<ffffffff8020c35b>] system_call_fastpath+0x16/0x1b
[  450.152010]        [<ffffffffffffffff>] 0xffffffffffffffff
[  450.152010] 
[  450.152010] other info that might help us debug this:
[  450.152010] 
[  450.152010] 2 locks held by iw/6265:
[  450.152010]  #0:  (genl_mutex){--..}, at: [<ffffffff80452f2a>] genl_rcv+0x1a/0x40
[  450.152010]  #1:  (&drv->mtx){--..}, at: [<ffffffffa018e68b>] cfg80211_get_dev_from_ifindex+0x5b/0x80 [cfg80211]
[  450.152010] 
[  450.152010] stack backtrace:
[  450.152010] Pid: 6265, comm: iw Not tainted 2.6.29-rc4-wl #22
[  450.152010] Call Trace:
[  450.152010]  [<ffffffff80260805>] print_circular_bug_tail+0x95/0xe0
[  450.152010]  [<ffffffff80261020>] validate_chain+0x7d0/0x1270
[  450.152010]  [<ffffffff80261dde>] ? __lock_acquire+0x31e/0xa30
[  450.152010]  [<ffffffff80261dde>] __lock_acquire+0x31e/0xa30
[  450.152010]  [<ffffffff804414c2>] ? rtnl_lock+0x12/0x20
[  450.152010]  [<ffffffff80262548>] lock_acquire+0x58/0x80
[  450.152010]  [<ffffffff804414c2>] ? rtnl_lock+0x12/0x20
[  450.152010]  [<ffffffff804c523d>] mutex_lock_nested+0x9d/0x2f0
[  450.152010]  [<ffffffff804414c2>] ? rtnl_lock+0x12/0x20
[  450.152010]  [<ffffffffa018e69e>] ? cfg80211_get_dev_from_ifindex+0x6e/0x80 [cfg80211]
[  450.152010]  [<ffffffff804414c2>] rtnl_lock+0x12/0x20
[  450.152010]  [<ffffffffa0194c12>] nl80211_trigger_scan+0x52/0x490 [cfg80211]
[  450.152010]  [<ffffffff80453bc1>] genl_rcv_msg+0x181/0x1c0
[  450.152010]  [<ffffffff80453a40>] ? genl_rcv_msg+0x0/0x1c0
[  450.152010]  [<ffffffff804509f9>] netlink_rcv_skb+0x89/0xb0
[  450.152010]  [<ffffffff80452f39>] genl_rcv+0x29/0x40
[  450.152010]  [<ffffffff804505e8>] ? netlink_unicast+0xe8/0x2c0
[  450.152010]  [<ffffffff8045077f>] netlink_unicast+0x27f/0x2c0
[  450.152010]  [<ffffffff8042e159>] ? __alloc_skb+0x89/0x140
[  450.152010]  [<ffffffff80450fe1>] netlink_sendmsg+0x231/0x2e0
[  450.152010]  [<ffffffff80426797>] sock_sendmsg+0x127/0x140
[  450.152010]  [<ffffffff8024f400>] ? autoremove_wake_function+0x0/0x40
[  450.152010]  [<ffffffff8029a725>] ? get_page_from_freelist+0x485/0x590
[  450.152010]  [<ffffffff8026004a>] ? trace_hardirqs_on_caller+0x15a/0x1b0
[  450.152010]  [<ffffffff802600ad>] ? trace_hardirqs_on+0xd/0x10
[  450.152010]  [<ffffffff8029a648>] ? get_page_from_freelist+0x3a8/0x590
[  450.152010]  [<ffffffff80427357>] ? move_addr_to_kernel+0x57/0x60
[  450.152010]  [<ffffffff8043017c>] ? verify_iovec+0x3c/0xc0
[  450.152010]  [<ffffffff804268f2>] sys_sendmsg+0x142/0x260
[  450.152010]  [<ffffffff804c72f5>] ? _spin_unlock_irqrestore+0x55/0x60
[  450.152010]  [<ffffffff8026004a>] ? trace_hardirqs_on_caller+0x15a/0x1b0
[  450.152010]  [<ffffffff802600ad>] ? trace_hardirqs_on+0xd/0x10
[  450.152010]  [<ffffffff80368c36>] ? __up_read+0x46/0xb0
[  450.152010]  [<ffffffff802530f6>] ? up_read+0x26/0x30
[  450.152010]  [<ffffffff8026004a>] ? trace_hardirqs_on_caller+0x15a/0x1b0
[  450.152010]  [<ffffffff804c6911>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  450.152010]  [<ffffffff8020c35b>] system_call_fastpath+0x16/0x1b


