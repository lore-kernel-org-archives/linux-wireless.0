Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56769 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab0JEF1z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 01:27:55 -0400
Received: from [71.117.12.23] (pool-71-117-12-23.sttlwa.dsl-w.verizon.net [71.117.12.23])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o955RsHG024357
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 4 Oct 2010 22:27:55 -0700
Message-ID: <4CAAB75A.3050309@candelatech.com>
Date: Mon, 04 Oct 2010 22:27:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: deadlock on sdata->u.mgd.mtx between worker thread an 'ip'?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a big debug dump for the deadlock with ath5k VIFs
here:
http://www.candelatech.com/~greearb/20101004-1723-sysrqdump-double-double.txt

I think the deadlock might be between kworker and ip, on the
sdata->u.mgd.mtx v/s iflist_mtx lock.  It seems both processes
have ifmgd->mtx held, and worker is trying to grab it again but
blocks.

I think maybe the ip process has locked a different sdata than
'forsdata', so that is why this nested lock attempt by the worker thread
to all of the !forsdata objects blocks?

void ieee80211_recalc_smps(struct ieee80211_local *local,
			   struct ieee80211_sub_if_data *forsdata)
...
		if (sdata != forsdata) {
			/*
			 * This nested is ok -- we are holding the iflist_mtx
			 * so can't get here twice or so. But it's required
			 * since normally we acquire it first and then the
			 * iflist_mtx.
			 */
			mutex_lock_nested(&sdata->u.mgd.mtx, SINGLE_DEPTH_NESTING);
			count += check_mgd_smps(&sdata->u.mgd, &smps_mode);
			mutex_unlock(&sdata->u.mgd.mtx);
		} else


Oct  4 16:43:18 localhost kernel: kworker/u:3   D f6a41c78     0    44      2 0x00000000
Oct  4 16:43:18 localhost kernel: f6a41ca8 00000046 c0455f46 f6a41c78 f6a294e0 f6a2975c f6a29758 c09ee540
Oct  4 16:43:18 localhost kernel: c09ee540 f6a29758 c09ee540 c09ee540 c09ee540 c10fbef3 00000123 00000000
Oct  4 16:43:18 localhost kernel: 00000123 f6a294e0 00000001 f47baa20 f6a294e0 ffffff00 f6a41ce4 c0762e53
Oct  4 16:43:18 localhost kernel: Call Trace:
Oct  4 16:43:18 localhost kernel: [<c0455f46>] ? mark_lock+0x1e/0x1de
Oct  4 16:43:18 localhost kernel: [<c0762e53>] __mutex_lock_common+0x1d3/0x2e3
Oct  4 16:43:18 localhost kernel: [<c0763001>] mutex_lock_nested+0x30/0x38
Oct  4 16:43:18 localhost kernel: [<f89b0d37>] ? ieee80211_recalc_smps+0xb6/0x151 [mac80211]
Oct  4 16:43:18 localhost kernel: [<f89b0d37>] ieee80211_recalc_smps+0xb6/0x151 [mac80211]
Oct  4 16:43:18 localhost kernel: [<f89a35dd>] ieee80211_assoc_success+0x69f/0x7e4 [mac80211]
Oct  4 16:43:18 localhost kernel: [<f89a37c9>] ieee80211_assoc_done+0xa7/0xf6 [mac80211]
Oct  4 16:43:18 localhost kernel: [<c0455f46>] ? mark_lock+0x1e/0x1de
Oct  4 16:43:18 localhost kernel: [<c045614d>] ? mark_held_locks+0x47/0x5f
Oct  4 16:43:18 localhost kernel: [<c0762b4b>] ? __mutex_unlock_slowpath+0xf2/0xff
Oct  4 16:43:18 localhost kernel: [<c04563a9>] ? trace_hardirqs_on_caller+0x104/0x125
Oct  4 16:43:18 localhost kernel: [<c04563d5>] ? trace_hardirqs_on+0xb/0xd
Oct  4 16:43:18 localhost kernel: [<f89a515f>] ieee80211_work_work+0x306/0xd12 [mac80211]
Oct  4 16:43:18 localhost kernel: [<c0443d77>] process_one_work+0x1bd/0x2c3
Oct  4 16:43:18 localhost kernel: [<c0443d2d>] ? process_one_work+0x173/0x2c3
Oct  4 16:43:18 localhost kernel: [<f89a4e59>] ? ieee80211_work_work+0x0/0xd12 [mac80211]
Oct  4 16:43:18 localhost kernel: [<c0445422>] worker_thread+0xf7/0x1f7
Oct  4 16:43:18 localhost kernel: [<c044532b>] ? worker_thread+0x0/0x1f7
Oct  4 16:43:18 localhost kernel: [<c0447dff>] kthread+0x62/0x67
Oct  4 16:43:18 localhost kernel: [<c0447d9d>] ? kthread+0x0/0x67
Oct  4 16:43:18 localhost kernel: [<c0403506>] kernel_thread_helper+0x6/0x1a
Oct  4 16:43:18 localhost kernel: 5 locks held by kworker/u:3/44:
Oct  4 16:43:18 localhost kernel: #0:  ((wiphy_name(local->hw.wiphy))){+.+.+.}, at: [<c0443d2d>] process_one_work+0x173/0x2c3
Oct  4 16:43:18 localhost kernel: #1:  ((&local->work_work)){+.+.+.}, at: [<c0443d2d>] process_one_work+0x173/0x2c3
Oct  4 16:43:18 localhost kernel: #2:  (&ifmgd->mtx){+.+.+.}, at: [<f89a37bd>] ieee80211_assoc_done+0x9b/0xf6 [mac80211]
Oct  4 16:43:18 localhost kernel: #3:  (&local->iflist_mtx){+.+...}, at: [<f89a35ca>] ieee80211_assoc_success+0x68c/0x7e4 [mac80211]
Oct  4 16:43:18 localhost kernel: #4:  (&ifmgd->mtx/1){+.+...}, at: [<f89b0d37>] ieee80211_recalc_smps+0xb6/0x151 [mac80211]


Oct  4 16:43:18 localhost kernel: INFO: task ip:4076 blocked for more than 120 seconds.
Oct  4 16:43:18 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  4 16:43:18 localhost kernel: ip            D f3b6d848     0  4076   4066 0x00000080
Oct  4 16:43:18 localhost kernel: f3b6d878 00000046 c2807540 f3b6d848 f3a294e0 f3a2975c f3a29758 c09ee540
Oct  4 16:43:18 localhost kernel: c09ee540 f3a29758 c09ee540 c09ee540 c09ee540 c1137f01 00000123 00000000
Oct  4 16:43:18 localhost kernel: 00000123 f3a294e0 00000001 f6328b6c f3a294e0 ffffff00 f3b6d8b4 c0762e53
Oct  4 16:43:18 localhost kernel: Call Trace:
Oct  4 16:43:18 localhost kernel: [<c0762e53>] __mutex_lock_common+0x1d3/0x2e3
Oct  4 16:43:18 localhost kernel: [<c0763001>] mutex_lock_nested+0x30/0x38
Oct  4 16:43:18 localhost kernel: [<f89a35ca>] ? ieee80211_assoc_success+0x68c/0x7e4 [mac80211]
Oct  4 16:43:18 localhost kernel: [<f89a35ca>] ieee80211_assoc_success+0x68c/0x7e4 [mac80211]
Oct  4 16:43:18 localhost kernel: [<f89a37c9>] ieee80211_assoc_done+0xa7/0xf6 [mac80211]
Oct  4 16:43:18 localhost kernel: [<c0455f46>] ? mark_lock+0x1e/0x1de
Oct  4 16:43:18 localhost kernel: [<c045614d>] ? mark_held_locks+0x47/0x5f
Oct  4 16:43:18 localhost kernel: [<c0762b4b>] ? __mutex_unlock_slowpath+0xf2/0xff
Oct  4 16:43:18 localhost kernel: [<c04563a9>] ? trace_hardirqs_on_caller+0x104/0x125
Oct  4 16:43:18 localhost kernel: [<c04563d5>] ? trace_hardirqs_on+0xb/0xd
Oct  4 16:43:18 localhost kernel: [<f89a515f>] ieee80211_work_work+0x306/0xd12 [mac80211]
Oct  4 16:43:18 localhost kernel: [<c0455f46>] ? mark_lock+0x1e/0x1de
Oct  4 16:43:18 localhost kernel: [<c045614d>] ? mark_held_locks+0x47/0x5f
Oct  4 16:43:18 localhost kernel: [<f89a5bcd>] ieee80211_work_purge+0x62/0xa5 [mac80211]
Oct  4 16:43:18 localhost kernel: [<f89a6562>] ieee80211_do_stop+0x46/0x404 [mac80211]
Oct  4 16:43:18 localhost kernel: [<c04396ce>] ? local_bh_enable_ip+0x8/0xa
Oct  4 16:43:18 localhost kernel: [<c0763d96>] ? _raw_spin_unlock_bh+0x25/0x28
Oct  4 16:43:18 localhost kernel: [<c06e2401>] ? dev_deactivate_queue+0x10/0x44
Oct  4 16:43:18 localhost kernel: [<f89a6932>] ieee80211_stop+0x12/0x16 [mac80211]
Oct  4 16:43:18 localhost kernel: [<c06d2849>] __dev_close+0x6b/0x80
Oct  4 16:43:18 localhost kernel: [<c06d09bf>] __dev_change_flags+0xa0/0x115
Oct  4 16:43:18 localhost kernel: [<c06d2704>] dev_change_flags+0x13/0x3f
Oct  4 16:43:18 localhost kernel: [<c06dbf3b>] do_setlink+0x23a/0x51b
Oct  4 16:43:18 localhost kernel: [<c045539b>] ? register_lock_class+0x17/0x29e
Oct  4 16:43:18 localhost kernel: [<c06dc53f>] rtnl_newlink+0x269/0x432
Oct  4 16:43:18 localhost kernel: [<c06dc354>] ? rtnl_newlink+0x7e/0x432
Oct  4 16:43:18 localhost kernel: [<c0455f46>] ? mark_lock+0x1e/0x1de
Oct  4 16:43:18 localhost kernel: [<c045614d>] ? mark_held_locks+0x47/0x5f
Oct  4 16:43:18 localhost kernel: [<c0762f48>] ? __mutex_lock_common+0x2c8/0x2e3
Oct  4 16:43:18 localhost kernel: [<c04563a9>] ? trace_hardirqs_on_caller+0x104/0x125
Oct  4 16:43:18 localhost kernel: [<c0762f59>] ? __mutex_lock_common+0x2d9/0x2e3
Oct  4 16:43:18 localhost kernel: [<c06dc2d6>] ? rtnl_newlink+0x0/0x432
Oct  4 16:43:18 localhost kernel: [<c06dba90>] rtnetlink_rcv_msg+0x182/0x198
Oct  4 16:43:18 localhost kernel: [<c06db90e>] ? rtnetlink_rcv_msg+0x0/0x198
Oct  4 16:43:18 localhost kernel: [<c06e9168>] netlink_rcv_skb+0x30/0x77
Oct  4 16:43:18 localhost kernel: [<c06db907>] rtnetlink_rcv+0x1b/0x22
Oct  4 16:43:18 localhost kernel: [<c06e8fa3>] netlink_unicast+0xbe/0x119
Oct  4 16:43:18 localhost kernel: [<c06e9b41>] netlink_sendmsg+0x234/0x24c
Oct  4 16:43:18 localhost kernel: [<c06c388a>] __sock_sendmsg+0x51/0x5a
Oct  4 16:43:18 localhost kernel: [<c06c3af4>] sock_sendmsg+0x93/0xa7
Oct  4 16:43:18 localhost kernel: [<c04975bf>] ? might_fault+0x47/0x81
Oct  4 16:43:18 localhost kernel: [<c04975f4>] ? might_fault+0x7c/0x81
Oct  4 16:43:18 localhost kernel: [<c06cb87c>] ? copy_from_user+0x8/0xa
Oct  4 16:43:18 localhost kernel: [<c06cbba5>] ? verify_iovec+0x3e/0x6d
Oct  4 16:43:18 localhost kernel: [<c06c3cdc>] sys_sendmsg+0x149/0x193
Oct  4 16:43:18 localhost kernel: [<c045539b>] ? register_lock_class+0x17/0x29e
Oct  4 16:43:18 localhost kernel: [<c0455f46>] ? mark_lock+0x1e/0x1de
Oct  4 16:43:18 localhost kernel: [<c0499a73>] ? __do_fault+0x1fc/0x3a5
Oct  4 16:43:18 localhost kernel: [<c048732a>] ? unlock_page+0x40/0x43
Oct  4 16:43:18 localhost kernel: [<c0499bf0>] ? __do_fault+0x379/0x3a5
Oct  4 16:43:18 localhost kernel: [<c0457a41>] ? lock_release_non_nested+0x86/0x1d8
Oct  4 16:43:18 localhost kernel: [<c04975bf>] ? might_fault+0x47/0x81
Oct  4 16:43:18 localhost kernel: [<c04975bf>] ? might_fault+0x47/0x81
Oct  4 16:43:18 localhost kernel: [<c06c53db>] sys_socketcall+0x15e/0x1a5
Oct  4 16:43:18 localhost kernel: [<c0402f1c>] sysenter_do_call+0x12/0x38
Oct  4 16:43:18 localhost kernel: 3 locks held by ip/4076:
Oct  4 16:43:18 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06db8ea>] rtnl_lock+0xf/0x11
Oct  4 16:43:18 localhost kernel: #1:  (&ifmgd->mtx){+.+.+.}, at: [<f89a37bd>] ieee80211_assoc_done+0x9b/0xf6 [mac80211]
Oct  4 16:43:18 localhost kernel: #2:  (&local->iflist_mtx){+.+...}, at: [<f89a35ca>] ieee80211_assoc_success+0x68c/0x7e4 [mac80211]


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
