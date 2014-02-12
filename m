Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37726 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaBLW6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 17:58:22 -0500
Message-ID: <52FBFC77.8080603@candelatech.com> (sfid-20140212_235826_342137_7A0E596D)
Date: Wed, 12 Feb 2014 14:57:59 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Circular lock, related to ath10k.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I saw this while testing some dodgy firmware.  I have a few changes to
ath10k, but I don't think there is anything that could cause this.



======================================================
[ INFO: possible circular locking dependency detected ]
3.14.0-rc1-wl-ath+ #9 Tainted: G         C
-------------------------------------------------------
wpa_supplicant/3206 is trying to acquire lock:
 (&local->sta_mtx){+.+.+.}, at: [<ffffffffa0386a2b>] sta_info_insert_rcu+0x9e/0xb8 [mac80211]

but task is already holding lock:
 (&ar->conf_mutex){+.+.+.}, at: [<ffffffffa0588e61>] ath10k_bss_info_changed+0x43/0x6fa [ath10k_core]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ar->conf_mutex){+.+.+.}:
       [<ffffffff810fde2b>] lock_acquire+0x82/0x9d
       [<ffffffff815d5185>] mutex_lock_nested+0x68/0x3e0
       [<ffffffffa0588662>] ath10k_sta_state+0x3b/0x40e [ath10k_core]
       [<ffffffffa0385b9a>] drv_sta_state+0x87/0x17b [mac80211]
       [<ffffffffa038625b>] sta_info_insert_finish+0x88/0x2b3 [mac80211]
       [<ffffffffa0386a33>] sta_info_insert_rcu+0xa6/0xb8 [mac80211]
       [<ffffffffa0386a52>] sta_info_insert+0xd/0x1a [mac80211]
       [<ffffffffa03aaf0c>] ieee80211_prep_connection+0x579/0x681 [mac80211]
       [<ffffffffa03ae245>] ieee80211_mgd_auth+0x1e6/0x285 [mac80211]
       [<ffffffffa0395ff2>] ieee80211_auth+0x13/0x15 [mac80211]
       [<ffffffffa02db35c>] cfg80211_mlme_auth+0x13c/0x190 [cfg80211]
       [<ffffffffa02d881b>] nl80211_authenticate+0x295/0x2c1 [cfg80211]
       [<ffffffff81544939>] genl_family_rcv_msg+0x246/0x2ba
       [<ffffffff815449ea>] genl_rcv_msg+0x3d/0x60
       [<ffffffff81543b24>] netlink_rcv_skb+0x3d/0x8b
       [<ffffffff81543d23>] genl_rcv+0x24/0x34
       [<ffffffff81543302>] netlink_unicast+0xc6/0x147
       [<ffffffff81543923>] netlink_sendmsg+0x5a0/0x5e6
       [<ffffffff81508db0>] __sock_sendmsg_nosec+0x25/0x27
       [<ffffffff8150b521>] sock_sendmsg+0x5a/0x7b
       [<ffffffff8150bb78>] ___sys_sendmsg+0x21f/0x2c0
       [<ffffffff8150c847>] __sys_sendmsg+0x3d/0x5b
       [<ffffffff8150c872>] SyS_sendmsg+0xd/0x19
       [<ffffffff815dc3bd>] system_call_fastpath+0x1a/0x1f

-> #0 (&local->sta_mtx){+.+.+.}:
       [<ffffffff810fd69d>] __lock_acquire+0xac6/0xe48
       [<ffffffff810fde2b>] lock_acquire+0x82/0x9d
       [<ffffffff815d5185>] mutex_lock_nested+0x68/0x3e0
       [<ffffffffa0386a2b>] sta_info_insert_rcu+0x9e/0xb8 [mac80211]
       [<ffffffffa0386a52>] sta_info_insert+0xd/0x1a [mac80211]
       [<ffffffffa03aaf0c>] ieee80211_prep_connection+0x579/0x681 [mac80211]
       [<ffffffffa03ae245>] ieee80211_mgd_auth+0x1e6/0x285 [mac80211]
       [<ffffffffa0395ff2>] ieee80211_auth+0x13/0x15 [mac80211]
       [<ffffffffa02db35c>] cfg80211_mlme_auth+0x13c/0x190 [cfg80211]
       [<ffffffffa02d881b>] nl80211_authenticate+0x295/0x2c1 [cfg80211]
       [<ffffffff81544939>] genl_family_rcv_msg+0x246/0x2ba
       [<ffffffff815449ea>] genl_rcv_msg+0x3d/0x60
       [<ffffffff81543b24>] netlink_rcv_skb+0x3d/0x8b
       [<ffffffff81543d23>] genl_rcv+0x24/0x34
       [<ffffffff81543302>] netlink_unicast+0xc6/0x147
       [<ffffffff81543923>] netlink_sendmsg+0x5a0/0x5e6
       [<ffffffff81508db0>] __sock_sendmsg_nosec+0x25/0x27
       [<ffffffff8150b521>] sock_sendmsg+0x5a/0x7b
       [<ffffffff8150bb78>] ___sys_sendmsg+0x21f/0x2c0
       [<ffffffff8150c847>] __sys_sendmsg+0x3d/0x5b
       [<ffffffff8150c872>] SyS_sendmsg+0xd/0x19
       [<ffffffff815dc3bd>] system_call_fastpath+0x1a/0x1f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ar->conf_mutex);
                               lock(&local->sta_mtx);
                               lock(&ar->conf_mutex);
  lock(&local->sta_mtx);

 *** DEADLOCK ***

5 locks held by wpa_supplicant/3206:
 #0:  (cb_lock){++++++}, at: [<ffffffff81543d14>] genl_rcv+0x15/0x34
 #1:  (genl_mutex){+.+.+.}, at: [<ffffffff81543f26>] genl_lock+0x12/0x14
 #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff8152b23d>] rtnl_lock+0x12/0x14
 #3:  (&wdev->mtx){+.+.+.}, at: [<ffffffffa02cbd88>] wdev_lock+0xf/0x11 [cfg80211]
 #4:  (&ar->conf_mutex){+.+.+.}, at: [<ffffffffa0588e61>] ath10k_bss_info_changed+0x43/0x6fa [ath10k_core]

stack backtrace:
CPU: 0 PID: 3206 Comm: wpa_supplicant Tainted: G         C   3.14.0-rc1-wl-ath+ #9
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
 ffffffff81f57ac0 ffff88021525d4d8 ffffffff815cfed3 0000000000000006
 ffffffff81f57ac0 ffff88021525d528 ffffffff815cc171 ffff88021525d4f8
 ffff8800d309c520 ffff8800d309cdb0 ffff8800d309c520 ffff8800d309cdb0
Call Trace:
 [<ffffffff815cfed3>] dump_stack+0x4e/0x71
 [<ffffffff815cc171>] print_circular_bug+0x1f8/0x209
 [<ffffffff810fd69d>] __lock_acquire+0xac6/0xe48
 [<ffffffff810fde2b>] lock_acquire+0x82/0x9d
 [<ffffffffa0386a2b>] ? sta_info_insert_rcu+0x9e/0xb8 [mac80211]
 [<ffffffff815d5185>] mutex_lock_nested+0x68/0x3e0
 [<ffffffffa0386a2b>] ? sta_info_insert_rcu+0x9e/0xb8 [mac80211]
 [<ffffffffa0386a2b>] ? sta_info_insert_rcu+0x9e/0xb8 [mac80211]
 [<ffffffffa05891b7>] ? ath10k_bss_info_changed+0x399/0x6fa [ath10k_core]
 [<ffffffffa0386a2b>] sta_info_insert_rcu+0x9e/0xb8 [mac80211]
 [<ffffffffa0386a52>] sta_info_insert+0xd/0x1a [mac80211]
 [<ffffffffa03aaf0c>] ieee80211_prep_connection+0x579/0x681 [mac80211]
 [<ffffffffa03ae245>] ieee80211_mgd_auth+0x1e6/0x285 [mac80211]
 [<ffffffffa0395ff2>] ieee80211_auth+0x13/0x15 [mac80211]
 [<ffffffffa02db35c>] cfg80211_mlme_auth+0x13c/0x190 [cfg80211]
 [<ffffffff815d5465>] ? mutex_lock_nested+0x348/0x3e0
 [<ffffffffa02cbd88>] ? wdev_lock+0xf/0x11 [cfg80211]
 [<ffffffffa02d881b>] nl80211_authenticate+0x295/0x2c1 [cfg80211]
 [<ffffffff81544939>] genl_family_rcv_msg+0x246/0x2ba
 [<ffffffff815d5465>] ? mutex_lock_nested+0x348/0x3e0
 [<ffffffff815449ea>] genl_rcv_msg+0x3d/0x60
 [<ffffffff815449ad>] ? genl_family_rcv_msg+0x2ba/0x2ba
 [<ffffffff81543b24>] netlink_rcv_skb+0x3d/0x8b
 [<ffffffff81543d23>] genl_rcv+0x24/0x34
 [<ffffffff81543302>] netlink_unicast+0xc6/0x147
 [<ffffffff81543923>] netlink_sendmsg+0x5a0/0x5e6
 [<ffffffff810fd1c5>] ? __lock_acquire+0x5ee/0xe48
 [<ffffffff81508db0>] __sock_sendmsg_nosec+0x25/0x27
 [<ffffffff8150b521>] sock_sendmsg+0x5a/0x7b
 [<ffffffff810fdd7c>] ? lock_release+0x14e/0x17b
 [<ffffffff8116d932>] ? might_fault+0x9e/0xa5
 [<ffffffff8116d8e9>] ? might_fault+0x55/0xa5
 [<ffffffff81516469>] ? verify_iovec+0x60/0xb3
 [<ffffffff8150bb78>] ___sys_sendmsg+0x21f/0x2c0
 [<ffffffff810fd1c5>] ? __lock_acquire+0x5ee/0xe48
 [<ffffffff811cf145>] ? fsnotify+0x260/0x29b
 [<ffffffff811cef5b>] ? fsnotify+0x76/0x29b
 [<ffffffff810fde3d>] ? lock_acquire+0x94/0x9d
 [<ffffffff811163bf>] ? read_seqcount_begin.constprop.25+0x73/0x90
 [<ffffffff8150c847>] __sys_sendmsg+0x3d/0x5b
 [<ffffffff8150c872>] SyS_sendmsg+0xd/0x19
 [<ffffffff815dc3bd>] system_call_fastpath+0x1a/0x1f

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

