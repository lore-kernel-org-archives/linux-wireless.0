Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:32891 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693Ab0KQVTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 16:19:31 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oAHLJVSj024841
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 13:19:31 -0800
Message-ID: <4CE446E3.3090604@candelatech.com>
Date: Wed, 17 Nov 2010 13:19:31 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: recursive locking on wireless-testing.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found this while testing wpa_supplicant that shares scan results.
The kernel has no scan-sharing hacks in it..just a few patches
I've been using for a while (and the deadlock prevention patch
previously mentioned in other threads).


Nov 17 13:16:25 ath9k kernel: ieee80211 wiphy0: Removed STA 00:14:d1:c6:d2:54
Nov 17 13:16:25 ath9k kernel: ieee80211 wiphy0: Destroyed STA 00:14:d1:c6:d2:54

=============================================
[ INFO: possible recursive locking detected ]
2.6.37-rc1-wl+ #48
---------------------------------------------
wpa_supplicant/12334 is trying to acquire lock:
  (&(&txq->axq_lock)->rlock){+.-...}, at: [<f8fe90aa>] ath_tx_complete_buf+0x1d4/0x26c [ath9k]

but task is already holding lock:
  (&(&txq->axq_lock)->rlock){+.-...}, at: [<f8fe9ce6>] ath_tx_flush_tid+0x41/0xb6 [ath9k]

other info that might help us debug this:
6 locks held by wpa_supplicant/12334:
  #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
  #1:  (&wdev->mtx){+.+.+.}, at: [<f8bbc5a9>] cfg80211_wext_siwmlme+0x41/0x85 [cfg80211]
  #2:  (&ifmgd->mtx){+.+.+.}, at: [<f8f1b4ce>] ieee80211_mgd_deauth+0x28/0x1af [mac80211]
  #3:  (&local->sta_mtx){+.+.+.}, at: [<f8f1b150>] ieee80211_set_disassoc+0xab/0x1bc [mac80211]
  #4:  (&sta->ampdu_mlme.mtx){+.+...}, at: [<f8f19096>] __ieee80211_stop_tx_ba_session+0x25/0x4c [mac80211]
  #5:  (&(&txq->axq_lock)->rlock){+.-...}, at: [<f8fe9ce6>] ath_tx_flush_tid+0x41/0xb6 [ath9k]

stack backtrace:
Pid: 12334, comm: wpa_supplicant Not tainted 2.6.37-rc1-wl+ #48
Call Trace:
  [<7878bf56>] ? printk+0x18/0x1a
  [<7845bb58>] __lock_acquire+0xb14/0xb8b
  [<784593ff>] ? register_lock_class+0x17/0x297
  [<7845bc41>] lock_acquire+0x72/0x8d
  [<f8fe90aa>] ? ath_tx_complete_buf+0x1d4/0x26c [ath9k]
  [<7878de3a>] _raw_spin_lock_bh+0x38/0x45
  [<f8fe90aa>] ? ath_tx_complete_buf+0x1d4/0x26c [ath9k]
  [<f8fe90aa>] ath_tx_complete_buf+0x1d4/0x26c [ath9k]
  [<f8fe9d31>] ath_tx_flush_tid+0x8c/0xb6 [ath9k]
  [<f8fea716>] ath_tx_aggr_stop+0x7e/0x86 [ath9k]
  [<f8fe56bd>] ath9k_ampdu_action+0x93/0xf4 [ath9k]
  [<f8fe562a>] ? ath9k_ampdu_action+0x0/0xf4 [ath9k]
  [<f8f18708>] drv_ampdu_action+0x60/0x68 [mac80211]
  [<f8f18faf>] ___ieee80211_stop_tx_ba_session+0xde/0xfd [mac80211]
  [<f8f190aa>] __ieee80211_stop_tx_ba_session+0x39/0x4c [mac80211]
  [<f8f18683>] ieee80211_sta_tear_down_BA_sessions+0x31/0x56 [mac80211]
  [<f8f1b0a0>] ? set_sta_flags+0x23/0x28 [mac80211]
  [<f8f1b175>] ieee80211_set_disassoc+0xd0/0x1bc [mac80211]
  [<f8f1b4f5>] ieee80211_mgd_deauth+0x4f/0x1af [mac80211]
  [<f8f22cf1>] ieee80211_deauth+0x14/0x16 [mac80211]
  [<f8bb71e9>] __cfg80211_mlme_deauth+0x105/0x10d [cfg80211]
  [<f8bb994e>] __cfg80211_disconnect+0x112/0x199 [cfg80211]
  [<f8bbc5cc>] cfg80211_wext_siwmlme+0x64/0x85 [cfg80211]
  [<7876e089>] ioctl_standard_call+0x1f0/0x28e
  [<786f2b2b>] ? dev_name_hash+0x16/0x48
  [<786f653c>] ? __dev_get_by_name+0x32/0x3d
  [<7876e1b4>] wext_handle_ioctl+0x8d/0x18d
  [<f8bbc568>] ? cfg80211_wext_siwmlme+0x0/0x85 [cfg80211]
  [<786f7669>] dev_ioctl+0x520/0x53f
  [<785977bb>] ? copy_to_user+0x2f/0x108
  [<786e69dc>] ? sys_recvfrom+0xb8/0xc6
  [<786e5d1f>] ? sock_ioctl+0x0/0x202
  [<786e5f15>] sock_ioctl+0x1f6/0x202
  [<786e5d1f>] ? sock_ioctl+0x0/0x202
  [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
  [<784c130d>] ? fcheck_files+0x9b/0xca
  [<784c1369>] ? fget_light+0x2d/0xb0
  [<784cc10a>] sys_ioctl+0x43/0x62
  [<784030dc>] sysenter_do_call+0x12/0x38
Nov 17 13:16:25 ath9k kernel:
Nov 17 13:16:25 ath9k kernel: =============================================
Nov 17 13:16:25 ath9k kernel: [ INFO: possible recursive locking detected ]
Nov 17 13:16:25 ath9k kernel: 2.6.37-rc1-wl+ #48
Nov 17 13:16:25 ath9k kernel: ---------------------------------------------
Nov 17 13:16:25 ath9k kernel: wpa_supplicant/12334 is trying to acquire lock:
Nov 17 13:16:25 ath9k kernel: (&(&txq->axq_lock)->rlock){+.-...}, at: [<f8fe90aa>] ath_tx_complete_buf+0x1d4/0x26c [ath9k]
Nov 17 13:16:25 ath9k kernel:
Nov 17 13:16:25 ath9k kernel: but task is already holding lock:
Nov 17 13:16:25 ath9k kernel: (&(&txq->axq_lock)->rlock){+.-...}, at: [<f8fe9ce6>] ath_tx_flush_tid+0x41/0xb6 [ath9k]
Nov 17 13:16:25 ath9k kernel:
Nov 17 13:16:25 ath9k kernel: other info that might help us debug this:
Nov 17 13:16:25 ath9k kernel: 6 locks held by wpa_supplicant/12334:
Nov 17 13:16:25 ath9k kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 17 13:16:25 ath9k kernel: #1:  (&wdev->mtx){+.+.+.}, at: [<f8bbc5a9>] cfg80211_wext_siwmlme+0x41/0x85 [cfg80211]
Nov 17 13:16:25 ath9k kernel: #2:  (&ifmgd->mtx){+.+.+.}, at: [<f8f1b4ce>] ieee80211_mgd_deauth+0x28/0x1af [mac80211]
Nov 17 13:16:25 ath9k kernel: #3:  (&local->sta_mtx){+.+.+.}, at: [<f8f1b150>] ieee80211_set_disassoc+0xab/0x1bc [mac80211]
Nov 17 13:16:25 ath9k kernel: #4:  (&sta->ampdu_mlme.mtx){+.+...}, at: [<f8f19096>] __ieee80211_stop_tx_ba_session+0x25/0x4c [mac80211]
Nov 17 13:16:25 ath9k kernel: #5:  (&(&txq->axq_lock)->rlock){+.-...}, at: [<f8fe9ce6>] ath_tx_flush_tid+0x41/0xb6 [ath9k]
Nov 17 13:16:25 ath9k kernel:
Nov 17 13:16:25 ath9k kernel: stack backtrace:
Nov 17 13:16:25 ath9k kernel: Pid: 12334, comm: wpa_supplicant Not tainted 2.6.37-rc1-wl+ #48
Nov 17 13:16:25 ath9k kernel: Call Trace:
Nov 17 13:16:25 ath9k kernel: [<7878bf56>] ? printk+0x18/0x1a
Nov 17 13:16:25 ath9k kernel: [<7845bb58>] __lock_acquire+0xb14/0xb8b
Nov 17 13:16:25 ath9k kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 17 13:16:25 ath9k kernel: [<7845bc41>] lock_acquire+0x72/0x8d
Nov 17 13:16:25 ath9k kernel: [<f8fe90aa>] ? ath_tx_complete_buf+0x1d4/0x26c [ath9k]
Nov 17 13:16:25 ath9k kernel: [<7878de3a>] _raw_spin_lock_bh+0x38/0x45
Nov 17 13:16:25 ath9k kernel: [<f8fe90aa>] ? ath_tx_complete_buf+0x1d4/0x26c [ath9k]
Nov 17 13:16:25 ath9k kernel: [<f8fe90aa>] ath_tx_complete_buf+0x1d4/0x26c [ath9k]
Nov 17 13:16:25 ath9k kernel: [<f8fe9d31>] ath_tx_flush_tid+0x8c/0xb6 [ath9k]
Nov 17 13:16:25 ath9k kernel: [<f8fea716>] ath_tx_aggr_stop+0x7e/0x86 [ath9k]
Nov 17 13:16:25 ath9k kernel: [<f8fe56bd>] ath9k_ampdu_action+0x93/0xf4 [ath9k]
Nov 17 13:16:25 ath9k kernel: [<f8fe562a>] ? ath9k_ampdu_action+0x0/0xf4 [ath9k]
Nov 17 13:16:25 ath9k kernel: [<f8f18708>] drv_ampdu_action+0x60/0x68 [mac80211]
Nov 17 13:16:25 ath9k kernel: [<f8f18faf>] ___ieee80211_stop_tx_ba_session+0xde/0xfd [mac80211]
Nov 17 13:16:25 ath9k kernel: [<f8f190aa>] __ieee80211_stop_tx_ba_session+0x39/0x4c [mac80211]
Nov 17 13:16:25 ath9k kernel: [<f8f18683>] ieee80211_sta_tear_down_BA_sessions+0x31/0x56 [mac80211]
Nov 17 13:16:25 ath9k kernel: [<f8f1b0a0>] ? set_sta_flags+0x23/0x28 [mac80211]
Nov 17 13:16:25 ath9k kernel: [<f8f1b175>] ieee80211_set_disassoc+0xd0/0x1bc [mac80211]
Nov 17 13:16:25 ath9k kernel: [<f8f1b4f5>] ieee80211_mgd_deauth+0x4f/0x1af [mac80211]
Nov 17 13:16:25 ath9k kernel: [<f8f22cf1>] ieee80211_deauth+0x14/0x16 [mac80211]
Nov 17 13:16:25 ath9k kernel: [<f8bb71e9>] __cfg80211_mlme_deauth+0x105/0x10d [cfg80211]
Nov 17 13:16:25 ath9k kernel: [<f8bb994e>] __cfg80211_disconnect+0x112/0x199 [cfg80211]
Nov 17 13:16:25 ath9k kernel: [<f8bbc5cc>] cfg80211_wext_siwmlme+0x64/0x85 [cfg80211]
Nov 17 13:16:25 ath9k kernel: [<7876e089>] ioctl_standard_call+0x1f0/0x28e
Nov 17 13:16:25 ath9k kernel: [<786f2b2b>] ? dev_name_hash+0x16/0x48
Nov 17 13:16:25 ath9k kernel: [<786f653c>] ? __dev_get_by_name+0x32/0x3d
Nov 17 13:16:25 ath9k kernel: [<7876e1b4>] wext_handle_ioctl+0x8d/0x18d
Nov 17 13:16:25 ath9k kernel: [<f8bbc568>] ? cfg80211_wext_siwmlme+0x0/0x85 [cfg80211]
Nov 17 13:16:25 ath9k kernel: [<786f7669>] dev_ioctl+0x520/0x53f
Nov 17 13:16:25 ath9k kernel: [<785977bb>] ? copy_to_user+0x2f/0x108
Nov 17 13:16:25 ath9k kernel: [<786e69dc>] ? sys_recvfrom+0xb8/0xc6
Nov 17 13:16:25 ath9k kernel: [<786e5d1f>] ? sock_ioctl+0x0/0x202
Nov 17 13:16:25 ath9k kernel: [<786e5f15>] sock_ioctl+0x1f6/0x202
Nov 17 13:16:25 ath9k kernel: [<786e5d1f>] ? sock_ioctl+0x0/0x202
Nov 17 13:16:25 ath9k kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 17 13:16:25 ath9k kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 17 13:16:25 ath9k kernel: [<784c1369>] ? fget_light+0x2d/0xb0
Nov 17 13:16:25 ath9k kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 17 13:16:25 ath9k kernel: [<784030dc>] sysenter_do_call+0x12/0x38

  CTRL-A Z for help |115200 8N1 | NOR | Minicom 2.2    | VT102 | Online 03:17

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

