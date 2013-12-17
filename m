Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:36269 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3LQKMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 05:12:46 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: Circular lock with mac80211_hwsim and DFS
Date: Tue, 17 Dec 2013 12:12:41 +0200
Message-ID: <87lhzjeqg6.fsf@kamboji.qca.qualcomm.com> (sfid-20131217_111250_394625_7CF651F6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I tried to run a simple DFS test with mac80211_hwsim for the first time
but got the deadlock below. Is this a regression or has DFS ever worked
with hwsim?

Using 31e1798fbf from mac80211-next.

[  232.576709] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  232.584928] 
[  232.585383] ======================================================
[  232.586828] [ INFO: possible circular locking dependency detected ]
[  232.587735] 3.12.0+ #3 Not tainted
[  232.588314] -------------------------------------------------------
[  232.589189] hostapd/611 is trying to acquire lock:
[  232.590039]  (&local->chanctx_mtx){+.+.+.}, at: [<ffffffff8143fffa>] ieee80211_vif_use_channel+0x5a/0x160
[  232.591249] 
[  232.591249] but task is already holding lock:
[  232.591249]  (&local->iflist_mtx){+.+...}, at: [<ffffffff814230ca>] ieee80211_start_radar_detection+0x7a/0xe0
[  232.591249] 
[  232.591249] which lock already depends on the new lock.
[  232.591249] 
[  232.591249] 
[  232.591249] the existing dependency chain (in reverse order) is:
[  232.591249] 
-> #2 (&local->iflist_mtx){+.+...}:
[  232.591249]        [<ffffffff8108a938>] check_prevs_add+0x148/0x1e0
[  232.591249]        [<ffffffff8108ae31>] validate_chain.isra.33+0x461/0x720
[  232.591249]        [<ffffffff8108e374>] __lock_acquire+0x424/0xad0
[  232.591249]        [<ffffffff810902fa>] lock_acquire+0xaa/0x200
[  232.591249]        [<ffffffff814852a0>] mutex_lock_nested+0x70/0x530
[  232.591249]        [<ffffffff814068ec>] ieee80211_offchannel_stop_vifs+0x4c/0x130
[  232.591249]        [<ffffffff81403e94>] ieee80211_start_sw_scan+0x84/0x2d0
[  232.591249]        [<ffffffff8140445d>] __ieee80211_start_scan+0x37d/0x7d0
[  232.591249]        [<ffffffff8140543b>] ieee80211_request_scan+0x3b/0x60
[  232.591249]        [<ffffffff8142080c>] ieee80211_scan+0x8c/0x90
[  232.591249]        [<ffffffff813d2445>] nl80211_trigger_scan+0x575/0x870
[  232.591249]        [<ffffffff812e52e3>] genl_family_rcv_msg+0x323/0x380
[  232.591249]        [<ffffffff812e5384>] genl_rcv_msg+0x44/0x80
[  232.591249]        [<ffffffff812e44d9>] netlink_rcv_skb+0xa9/0xd0
[  232.591249]        [<ffffffff812e468c>] genl_rcv+0x2c/0x40
[  232.591249]        [<ffffffff812e2da9>] netlink_unicast+0x159/0x1d0
[  232.591249]        [<ffffffff812e358c>] netlink_sendmsg+0x38c/0x410
[  232.591249]        [<ffffffff812a638c>] sock_sendmsg+0x6c/0x90
[  232.591249]        [<ffffffff812a6656>] ___sys_sendmsg.part.36+0x2a6/0x2b0
[  232.591249]        [<ffffffff812a7f69>] __sys_sendmsg+0xb9/0xd0
[  232.591249]        [<ffffffff812a7f8e>] SyS_sendmsg+0xe/0x10
[  232.591249]        [<ffffffff8148b3a9>] system_call_fastpath+0x16/0x1b
[  232.591249] 
-> #1 (&local->mtx){+.+...}:
[  232.591249]        [<ffffffff8108a938>] check_prevs_add+0x148/0x1e0
[  232.591249]        [<ffffffff8108ae31>] validate_chain.isra.33+0x461/0x720
[  232.591249]        [<ffffffff8108e374>] __lock_acquire+0x424/0xad0
[  232.591249]        [<ffffffff810902fa>] lock_acquire+0xaa/0x200
[  232.591249]        [<ffffffff814852a0>] mutex_lock_nested+0x70/0x530
[  232.591249]        [<ffffffff8143e9bd>] ieee80211_new_chanctx+0xad/0x430
[  232.591249]        [<ffffffff814400ee>] ieee80211_vif_use_channel+0x14e/0x160
[  232.591249]        [<ffffffff81421c17>] ieee80211_start_ap+0x87/0x6f0
[  232.591249]        [<ffffffff813cd24d>] nl80211_start_ap+0x37d/0x7d0
[  232.591249]        [<ffffffff812e52e3>] genl_family_rcv_msg+0x323/0x380
[  232.591249]        [<ffffffff812e5384>] genl_rcv_msg+0x44/0x80
[  232.591249]        [<ffffffff812e44d9>] netlink_rcv_skb+0xa9/0xd0
[  232.591249]        [<ffffffff812e468c>] genl_rcv+0x2c/0x40
[  232.591249]        [<ffffffff812e2da9>] netlink_unicast+0x159/0x1d0
[  232.591249]        [<ffffffff812e358c>] netlink_sendmsg+0x38c/0x410
[  232.591249]        [<ffffffff812a638c>] sock_sendmsg+0x6c/0x90
[  232.591249]        [<ffffffff812a6656>] ___sys_sendmsg.part.36+0x2a6/0x2b0
[  232.591249]        [<ffffffff812a7f69>] __sys_sendmsg+0xb9/0xd0
[  232.591249]        [<ffffffff812a7f8e>] SyS_sendmsg+0xe/0x10
[  232.591249]        [<ffffffff8148b3a9>] system_call_fastpath+0x16/0x1b
[  232.591249] 
-> #0 (&local->chanctx_mtx){+.+.+.}:
[  232.591249]        [<ffffffff8108a7da>] check_prev_add+0x82a/0x840
[  232.591249]        [<ffffffff8108a938>] check_prevs_add+0x148/0x1e0
[  232.591249]        [<ffffffff8108ae31>] validate_chain.isra.33+0x461/0x720
[  232.591249]        [<ffffffff8108e374>] __lock_acquire+0x424/0xad0
[  232.591249]        [<ffffffff810902fa>] lock_acquire+0xaa/0x200
[  232.591249]        [<ffffffff814852a0>] mutex_lock_nested+0x70/0x530
[  232.591249]        [<ffffffff8143fffa>] ieee80211_vif_use_channel+0x5a/0x160
[  232.591249]        [<ffffffff814230db>] ieee80211_start_radar_detection+0x8b/0xe0
[  232.591249]        [<ffffffff813c9551>] nl80211_start_radar_detection+0x111/0x150
[  232.591249]        [<ffffffff812e52e3>] genl_family_rcv_msg+0x323/0x380
[  232.591249]        [<ffffffff812e5384>] genl_rcv_msg+0x44/0x80
[  232.591249]        [<ffffffff812e44d9>] netlink_rcv_skb+0xa9/0xd0
[  232.591249]        [<ffffffff812e468c>] genl_rcv+0x2c/0x40
[  232.591249]        [<ffffffff812e2da9>] netlink_unicast+0x159/0x1d0
[  232.591249]        [<ffffffff812e358c>] netlink_sendmsg+0x38c/0x410
[  232.591249]        [<ffffffff812a638c>] sock_sendmsg+0x6c/0x90
[  232.591249]        [<ffffffff812a6656>] ___sys_sendmsg.part.36+0x2a6/0x2b0
[  232.591249]        [<ffffffff812a7f69>] __sys_sendmsg+0xb9/0xd0
[  232.591249]        [<ffffffff812a7f8e>] SyS_sendmsg+0xe/0x10
[  232.591249]        [<ffffffff8148b3a9>] system_call_fastpath+0x16/0x1b

-- 
Kalle Valo
