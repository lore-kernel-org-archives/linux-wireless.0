Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45191 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab0JDXeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 19:34:01 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o94NY0To030689
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 4 Oct 2010 16:34:01 -0700
Message-ID: <4CAA6468.3030706@candelatech.com>
Date: Mon, 04 Oct 2010 16:34:00 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Lockup with ath5k, rtnl_mutex related?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm (also) trying to debug an issue with an ath5k system that deadlocks.

We have sysrq output for the held locks, process backtraces, etc.

One thing that has me confused is that the locks-held output shows
a large number of processes owning the rtnl_mutex.  Any idea
how to tell what process *really* owns it?


Oct  4 14:57:46 localhost kernel: SysRq : Show Locks Held
Oct  4 14:57:46 localhost kernel:
Oct  4 14:57:46 localhost kernel: Showing all locks held in the system:
Oct  4 14:57:46 localhost kernel: 4 locks held by kworker/u:0/5:
Oct  4 14:57:46 localhost kernel: #0:  ((wiphy_name(local->hw.wiphy))){+.+.+.}, at: [<c0443d2d>] process_one_work+0x173/0x2c3
Oct  4 14:57:46 localhost kernel: #1:  ((&local->work_work)){+.+.+.}, at: [<c0443d2d>] process_one_work+0x173/0x2c3
Oct  4 14:57:46 localhost kernel: #2:  (&ifmgd->mtx){+.+.+.}, at: [<f8a9b7bd>] ieee80211_assoc_done+0x9b/0xf6 [mac80211]
Oct  4 14:57:46 localhost kernel: #3:  (&local->iflist_mtx){+.+...}, at: [<f8aaa384>] ieee80211_set_channel_type+0x20/0xe3 [mac80211]
Oct  4 14:57:46 localhost kernel: 3 locks held by kworker/0:2/51:
Oct  4 14:57:46 localhost kernel: #0:  (events){+.+.+.}, at: [<c0443d2d>] process_one_work+0x173/0x2c3
Oct  4 14:57:46 localhost kernel: #1:  ((linkwatch_work).work){+.+.+.}, at: [<c0443d2d>] process_one_work+0x173/0x2c3
Oct  4 14:57:46 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c06db8ea>] rtnl_lock+0xf/0x11
Oct  4 14:57:46 localhost kernel: 1 lock held by hald/1316:
Oct  4 14:57:46 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06db8ea>] rtnl_lock+0xf/0x11
Oct  4 14:57:46 localhost kernel: 1 lock held by ntpd/1388:
Oct  4 14:57:46 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06db8ea>] rtnl_lock+0xf/0x11
Oct  4 14:57:46 localhost kernel: 1 lock held by mingetty/1497:
Oct  4 14:57:46 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f63f1>] n_tty_read+0x1d1/0x5ed
Oct  4 14:57:46 localhost kernel: 1 lock held by mingetty/1499:
Oct  4 14:57:46 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f63f1>] n_tty_read+0x1d1/0x5ed
Oct  4 14:57:46 localhost kernel: 1 lock held by mingetty/1501:
Oct  4 14:57:46 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f63f1>] n_tty_read+0x1d1/0x5ed
Oct  4 14:57:46 localhost kernel: 1 lock held by mingetty/1503:
Oct  4 14:57:46 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f63f1>] n_tty_read+0x1d1/0x5ed
Oct  4 14:57:46 localhost kernel: 1 lock held by mingetty/1505:
Oct  4 14:57:46 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f63f1>] n_tty_read+0x1d1/0x5ed
Oct  4 14:57:46 localhost kernel: 1 lock held by mingetty/1511:
Oct  4 14:57:46 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f63f1>] n_tty_read+0x1d1/0x5ed
Oct  4 14:57:46 localhost kernel: 1 lock held by bash/1802:
Oct  4 14:57:46 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c05f63f1>] n_tty_read+0x1d1/0x5ed
Oct  4 14:57:46 localhost kernel: 1 lock held by gnuserver/2195:
Oct  4 14:57:46 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06db8ea>] rtnl_lock+0xf/0x11
Oct  4 14:57:46 localhost kernel: 3 locks held by kworker/0:0/4000:
Oct  4 14:57:46 localhost kernel: #0:  (events){+.+.+.}, at: [<c0443d2d>] process_one_work+0x173/0x2c3
Oct  4 14:57:46 localhost kernel: #1:  (wireless_nlevent_work){+.+.+.}, at: [<c0443d2d>] process_one_work+0x173/0x2c3
Oct  4 14:57:46 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c06db8ea>] rtnl_lock+0xf/0x11
Oct  4 14:57:46 localhost kernel: 4 locks held by ip/4035:
Oct  4 14:57:46 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06db8ea>] rtnl_lock+0xf/0x11
Oct  4 14:57:46 localhost kernel: #1:  (&ifmgd->mtx){+.+.+.}, at: [<f8a9b7bd>] ieee80211_assoc_done+0x9b/0xf6 [mac80211]
Oct  4 14:57:46 localhost kernel: #2:  (&local->iflist_mtx){+.+...}, at: [<f8a9b5ca>] ieee80211_assoc_success+0x68c/0x7e4 [mac80211]
Oct  4 14:57:46 localhost kernel: #3:  (&ifmgd->mtx/1){+.+...}, at: [<f8aa8d37>] ieee80211_recalc_smps+0xb6/0x151 [mac80211]
Oct  4 14:57:46 localhost kernel: 1 lock held by iwconfig/4040:
Oct  4 14:57:46 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c06db8ea>] rtnl_lock+0xf/0x11
Oct  4 14:57:46 localhost kernel: 2 locks held by bash/5275:
Oct  4 14:57:46 localhost kernel: #0:  (sysrq_key_table_lock){......}, at: [<c06052d4>] __handle_sysrq+0x18/0x110
Oct  4 14:57:46 localhost kernel: #1:  (tasklist_lock){.+.+..}, at: [<c0455c6f>] debug_show_all_locks+0x41/0x142


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

