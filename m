Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58907 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbZCXBry (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 21:47:54 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 18:47:53 -0700
Date: Mon, 23 Mar 2009 17:47:16 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Lockdep complaint between drv->mtx and cfg80211_mutex
Message-ID: <20090324004716.GA22925@tesla> (sfid-20090324_024813_010108_D99AE49D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What I had done was load mac80211_hwsim with the module parameters regtest=4 radios=2.
Then I spawn hostapd for wlan0, bring up wlan1, trigger a scan using iw, and then
I rename wlan1.

[ 1098.897030] =======================================================
[ 1098.897060] [ INFO: possible circular locking dependency detected ]
[ 1098.897081] 2.6.29-rc8-wl #23
[ 1098.897092] -------------------------------------------------------
[ 1098.897111] iw/6409 is trying to acquire lock:
[ 1098.897126]  (cfg80211_mutex){--..}, at: [<ffffffffa03dd8b8>] cfg80211_dev_rename+0x28/0x1d0 [cfg80211]
[ 1098.897175]
[ 1098.897176] but task is already holding lock:
[ 1098.897196]  (&drv->mtx){--..}, at: [<ffffffffa03ddbfb>] cfg80211_get_dev_from_info+0xfb/0x150 [cfg80211]
[ 1098.897240]
[ 1098.897241] which lock already depends on the new lock.
[ 1098.897242]
[ 1098.897268]
[ 1098.897269] the existing dependency chain (in reverse order) is:
[ 1098.897292]
[ 1098.897292] -> #1 (&drv->mtx){--..}:
[ 1098.897318]        [<ffffffff8026e3dc>] __lock_acquire+0xeec/0x1370
[ 1098.897346]        [<ffffffff8026e8b6>] lock_acquire+0x56/0x80
[ 1098.897391]        [<ffffffff8053fc43>] __mutex_lock_common+0xa3/0x470
[ 1098.897430]        [<ffffffff805400ea>] mutex_lock_nested+0x3a/0x50
[ 1098.897474]        [<ffffffffa03ddbfb>] cfg80211_get_dev_from_info+0xfb/0x150 [cfg80211]
[ 1098.897537]        [<ffffffffa03e4aef>] nl80211_new_interface+0x5f/0x1f0 [cfg80211]
[ 1098.897604]        [<ffffffff804cb766>] genl_rcv_msg+0x1b6/0x1f0
[ 1098.897640]        [<ffffffff804c99f9>] netlink_rcv_skb+0x89/0xb0
[ 1098.897684]        [<ffffffff804cb599>] genl_rcv+0x29/0x40
[ 1098.897726]        [<ffffffff804c979c>] netlink_unicast+0x2cc/0x2e0
[ 1098.897768]        [<ffffffff804ca8d4>] netlink_sendmsg+0x214/0x300
[ 1098.897811]        [<ffffffff8049dcb7>] sock_sendmsg+0x107/0x130
[ 1098.897855]        [<ffffffff8049de25>] sys_sendmsg+0x145/0x280
[ 1098.897897]        [<ffffffff8020c7db>] system_call_fastpath+0x16/0x1b
[ 1098.897942]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1098.898014]
[ 1098.898015] -> #0 (cfg80211_mutex){--..}:  
[ 1098.898067]        [<ffffffff8026e4bb>] __lock_acquire+0xfcb/0x1370
[ 1098.898103]        [<ffffffff8026e8b6>] lock_acquire+0x56/0x80
[ 1098.898144]        [<ffffffff8053fc43>] __mutex_lock_common+0xa3/0x470
[ 1098.898187]        [<ffffffff805400ea>] mutex_lock_nested+0x3a/0x50
[ 1098.898229]        [<ffffffffa03dd8b8>] cfg80211_dev_rename+0x28/0x1d0 [cfg80211]
[ 1098.898291]        [<ffffffffa03e4cc2>] nl80211_set_wiphy+0x42/0x300 [cfg80211]
[ 1098.898358]        [<ffffffff804cb766>] genl_rcv_msg+0x1b6/0x1f0
[ 1098.898399]        [<ffffffff804c99f9>] netlink_rcv_skb+0x89/0xb0
[ 1098.898441]        [<ffffffff804cb599>] genl_rcv+0x29/0x40
[ 1098.898482]        [<ffffffff804c979c>] netlink_unicast+0x2cc/0x2e0
[ 1098.898524]        [<ffffffff804ca8d4>] netlink_sendmsg+0x214/0x300
[ 1098.898567]        [<ffffffff8049dcb7>] sock_sendmsg+0x107/0x130
[ 1098.898618]        [<ffffffff8049de25>] sys_sendmsg+0x145/0x280
[ 1098.898652]        [<ffffffff8020c7db>] system_call_fastpath+0x16/0x1b
[ 1098.898697]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1098.898734]
[ 1098.898735] other info that might help us debug this:
[ 1098.898736]
[ 1098.898804] 2 locks held by iw/6409:
[ 1098.898838]  #0:  (genl_mutex){--..}, at: [<ffffffff804cb58a>] genl_rcv+0x1a/0x40
[ 1098.898898]  #1:  (&drv->mtx){--..}, at: [<ffffffffa03ddbfb>] cfg80211_get_dev_from_info+0xfb/0x150 [cfg80211]
[ 1098.898981]
[ 1098.898981] stack backtrace:
[ 1098.899033] Pid: 6409, comm: iw Not tainted 2.6.29-rc8-wl #23
[ 1098.899072] Call Trace:
[ 1098.899108]  [<ffffffff8026bf64>] print_circular_bug_tail+0xa4/0x100
[ 1098.899149]  [<ffffffff8026e4bb>] __lock_acquire+0xfcb/0x1370
[ 1098.899188]  [<ffffffff8026e8b6>] lock_acquire+0x56/0x80
[ 1098.899232]  [<ffffffffa03dd8b8>] ? cfg80211_dev_rename+0x28/0x1d0 [cfg80211]
[ 1098.899273]  [<ffffffff8053fc43>] __mutex_lock_common+0xa3/0x470
[ 1098.899317]  [<ffffffffa03dd8b8>] ? cfg80211_dev_rename+0x28/0x1d0 [cfg80211]
[ 1098.899358]  [<ffffffff8053fee1>] ? __mutex_lock_common+0x341/0x470
[ 1098.899401]  [<ffffffffa03dd8b8>] ? cfg80211_dev_rename+0x28/0x1d0 [cfg80211]
[ 1098.899445]  [<ffffffff805400ea>] mutex_lock_nested+0x3a/0x50
[ 1098.899482]  [<ffffffffa03dd8b8>] cfg80211_dev_rename+0x28/0x1d0 [cfg80211]
[ 1098.899518]  [<ffffffff8053f9b9>] ? mutex_unlock+0x9/0x10
[ 1098.899555]  [<ffffffffa03e4cc2>] nl80211_set_wiphy+0x42/0x300 [cfg80211]
[ 1098.899596]  [<ffffffff804cb238>] ? validate_nla+0xa8/0x1c0
[ 1098.899636]  [<ffffffff804cb43f>] ? nla_parse+0xef/0x110
[ 1098.899668]  [<ffffffff804cb766>] genl_rcv_msg+0x1b6/0x1f0
[ 1098.899700]  [<ffffffff804cb5b0>] ? genl_rcv_msg+0x0/0x1f0
[ 1098.899733]  [<ffffffff804c99f9>] netlink_rcv_skb+0x89/0xb0
[ 1098.899769]  [<ffffffff804cb599>] genl_rcv+0x29/0x40
[ 1098.899799]  [<ffffffff804c979c>] netlink_unicast+0x2cc/0x2e0
[ 1098.899845]  [<ffffffff804a41ee>] ? __alloc_skb+0x6e/0x140
[ 1098.899876]  [<ffffffff804ca8d4>] netlink_sendmsg+0x214/0x300
[ 1098.899922]  [<ffffffff8029a8bd>] ? __rcu_read_unlock+0xad/0xd0
[ 1098.899954]  [<ffffffff8049dcb7>] sock_sendmsg+0x107/0x130
[ 1098.899998]  [<ffffffff80269604>] ? get_lock_stats+0x34/0x80
[ 1098.900039]  [<ffffffff80259c70>] ? autoremove_wake_function+0x0/0x40
[ 1098.900073]  [<ffffffff80269604>] ? get_lock_stats+0x34/0x80
[ 1098.900110]  [<ffffffff8026965e>] ? put_lock_stats+0xe/0x30
[ 1098.900153]  [<ffffffff8049d587>] ? move_addr_to_kernel+0x57/0x60
[ 1098.900193]  [<ffffffff804a6f9f>] ? verify_iovec+0x3f/0xe0
[ 1098.900224]  [<ffffffff8049de25>] sys_sendmsg+0x145/0x280
[ 1098.900260]  [<ffffffff80269604>] ? get_lock_stats+0x34/0x80
[ 1098.900298]  [<ffffffff8026965e>] ? put_lock_stats+0xe/0x30
[ 1098.900335]  [<ffffffff8026d232>] ? trace_hardirqs_on_caller+0x162/0x1b0
[ 1098.900383]  [<ffffffff80291f3f>] ? audit_syscall_entry+0x17f/0x1b0
[ 1098.900423]  [<ffffffff8054162f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1098.900457]  [<ffffffff8020c7db>] system_call_fastpath+0x16/0x1b

