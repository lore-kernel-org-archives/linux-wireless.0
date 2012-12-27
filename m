Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2L0RQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 12:16:12 -0500
Message-ID: <1356628591.15149.14.camel@jlt4.sipsolutions.net> (sfid-20121227_181617_500387_1846CC38)
Subject: Re: [PATCH 3/3] cfg80211: move world roaming check for beacon hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Thu, 27 Dec 2012 18:16:31 +0100
In-Reply-To: <1355943184-966-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20121219_200036_196307_E48D6F1B)
References: <1355943184-966-1-git-send-email-mcgrof@do-not-panic.com>
	 <1355943184-966-4-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20121219_200036_196307_E48D6F1B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-19 at 10:53 -0800, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> We should not add new beacon hints even if the wiphy
> is not world roaming. Without this we were always adding
> a beacon hint if not world roaming for every non world
> roaming wiphy interface.

This introduced a locking bug, lockdep splat below. I'm going to drop
the series for my pull request, please respin.

johannes


[ 2442.916674] ===============================
[ 2442.917287] [ INFO: suspicious RCU usage. ]
[ 2442.919345] 3.7.0-rc1+ #868 Tainted: G        W  O
[ 2442.921729] -------------------------------
[ 2442.923741] /home/johannes/sys/wireless/net/wireless/reg.c:125 suspicious rcu_dereference_protected() usage!
[ 2442.928222] 
[ 2442.928222] other info that might help us debug this:
[ 2442.928222] 
[ 2442.930621] 
[ 2442.930621] rcu_scheduler_active = 1, debug_locks = 1
[ 2442.931408] 4 locks held by kworker/0:3/1773:
[ 2442.931948]  #0:  (events){.+.+.+}, at: [<ffffffff810615b7>] process_one_work+0x197/0x770
[ 2442.933022]  #1:  (reg_work){+.+.+.}, at: [<ffffffff810615b7>] process_one_work+0x197/0x770
[ 2442.934128]  #2:  (cfg80211_mutex){+.+.+.}, at: [<ffffffffa01c0706>] reg_todo+0x186/0x580 [cfg80211]
[ 2442.935310]  #3:  (&(&reg_pending_beacons_lock)->rlock){+.-...}, at: [<ffffffffa01c0712>] reg_todo+0x192/0x580 [cfg80211]
[ 2442.936690] 
[ 2442.936690] stack backtrace:
[ 2442.937217] Pid: 1773, comm: kworker/0:3 Tainted: G        W  O 3.7.0-rc1+ #868
[ 2442.938119] Call Trace:
[ 2442.938427]  [<ffffffff8109f8b2>] lockdep_rcu_suspicious+0xe2/0x130
[ 2442.939192]  [<ffffffffa01bf887>] get_cfg80211_regdom+0x57/0x60 [cfg80211]
[ 2442.940104]  [<ffffffffa01bffe1>] handle_reg_beacon.isra.14+0x61/0x110 [cfg80211]
[ 2442.941010]  [<ffffffff815081b1>] ? _raw_spin_lock_bh+0x71/0x80
[ 2442.941725]  [<ffffffffa01c07a8>] reg_todo+0x228/0x580 [cfg80211]
[ 2442.942476]  [<ffffffff81061627>] process_one_work+0x207/0x770
[ 2442.943172]  [<ffffffff810615b7>] ? process_one_work+0x197/0x770
[ 2442.943893]  [<ffffffff8109ebb2>] ? get_lock_stats+0x22/0x70
[ 2442.944574]  [<ffffffffa01c0580>] ? regdom_changes+0x60/0x60 [cfg80211]
[ 2442.945367]  [<ffffffff81062a2e>] worker_thread+0x14e/0x3e0
[ 2442.946059]  [<ffffffff810628e0>] ? manage_workers+0x280/0x280
[ 2442.946762]  [<ffffffff8106911b>] kthread+0xdb/0xe0
[ 2442.947353]  [<ffffffff81069040>] ? __init_kthread_worker+0x70/0x70
[ 2442.948130]  [<ffffffff815099ec>] ret_from_fork+0x7c/0xb0
[ 2442.948760]  [<ffffffff81069040>] ? __init_kthread_worker+0x70/0x70
[ 2442.949515] 
[ 2442.949706] ===============================
[ 2442.950290] [ INFO: suspicious RCU usage. ]
[ 2442.950800] 3.7.0-rc1+ #868 Tainted: G        W  O
[ 2442.951379] -------------------------------
[ 2442.951887] /home/johannes/sys/wireless/net/wireless/reg.c:131 suspicious rcu_dereference_protected() usage!
[ 2442.953051] 
[ 2442.953051] other info that might help us debug this:
[ 2442.953051] 
[ 2442.954021] 
[ 2442.954021] rcu_scheduler_active = 1, debug_locks = 1
[ 2442.954807] 4 locks held by kworker/0:3/1773:
[ 2442.955331]  #0:  (events){.+.+.+}, at: [<ffffffff810615b7>] process_one_work+0x197/0x770
[ 2442.956381]  #1:  (reg_work){+.+.+.}, at: [<ffffffff810615b7>] process_one_work+0x197/0x770
[ 2442.957604]  #2:  (cfg80211_mutex){+.+.+.}, at: [<ffffffffa01c0706>] reg_todo+0x186/0x580 [cfg80211]
[ 2442.958909]  #3:  (&(&reg_pending_beacons_lock)->rlock){+.-...}, at: [<ffffffffa01c0712>] reg_todo+0x192/0x580 [cfg80211]
[ 2442.960366] 
[ 2442.960366] stack backtrace:
[ 2442.960901] Pid: 1773, comm: kworker/0:3 Tainted: G        W  O 3.7.0-rc1+ #868
[ 2442.961780] Call Trace:
[ 2442.962102]  [<ffffffff8109f8b2>] lockdep_rcu_suspicious+0xe2/0x130
[ 2442.962869]  [<ffffffffa01bfcdf>] get_wiphy_regdom.isra.10+0x5f/0x70 [cfg80211]
[ 2442.963765]  [<ffffffffa01bfff0>] handle_reg_beacon.isra.14+0x70/0x110 [cfg80211]
[ 2442.964663]  [<ffffffff815081b1>] ? _raw_spin_lock_bh+0x71/0x80
[ 2442.965383]  [<ffffffffa01c07a8>] reg_todo+0x228/0x580 [cfg80211]
[ 2442.966142]  [<ffffffff81061627>] process_one_work+0x207/0x770
[ 2442.966856]  [<ffffffff810615b7>] ? process_one_work+0x197/0x770
[ 2442.967584]  [<ffffffff8109ebb2>] ? get_lock_stats+0x22/0x70
[ 2442.968272]  [<ffffffffa01c0580>] ? regdom_changes+0x60/0x60 [cfg80211]
[ 2442.969073]  [<ffffffff81062a2e>] worker_thread+0x14e/0x3e0
[ 2442.969749]  [<ffffffff810628e0>] ? manage_workers+0x280/0x280
[ 2442.970597]  [<ffffffff8106911b>] kthread+0xdb/0xe0
[ 2442.971303]  [<ffffffff81069040>] ? __init_kthread_worker+0x70/0x70
[ 2442.972055]  [<ffffffff815099ec>] ret_from_fork+0x7c/0xb0
[ 2442.972771]  [<ffffffff81069040>] ? __init_kthread_worker+0x70/0x70
[ 2442.973609] 
[ 2442.973800] ===============================
[ 2442.974322] [ INFO: suspicious RCU usage. ]
[ 2442.974829] 3.7.0-rc1+ #868 Tainted: G        W  O
[ 2442.975451] -------------------------------
[ 2442.975958] /home/johannes/sys/wireless/net/wireless/reg.c:144 suspicious rcu_dereference_protected() usage!
[ 2442.977170] 
[ 2442.977170] other info that might help us debug this:
[ 2442.977170] 
[ 2442.978201] 
[ 2442.978201] rcu_scheduler_active = 1, debug_locks = 1
[ 2442.978988] 4 locks held by kworker/0:3/1773:
[ 2442.979522]  #0:  (events){.+.+.+}, at: [<ffffffff810615b7>] process_one_work+0x197/0x770
[ 2442.980654]  #1:  (reg_work){+.+.+.}, at: [<ffffffff810615b7>] process_one_work+0x197/0x770
[ 2442.981726]  #2:  (cfg80211_mutex){+.+.+.}, at: [<ffffffffa01c0706>] reg_todo+0x186/0x580 [cfg80211]
[ 2442.983048]  #3:  (&(&reg_pending_beacons_lock)->rlock){+.-...}, at: [<ffffffffa01c0712>] reg_todo+0x192/0x580 [cfg80211]
[ 2442.984560] 
[ 2442.984560] stack backtrace:
[ 2442.985086] Pid: 1773, comm: kworker/0:3 Tainted: G        W  O 3.7.0-rc1+ #868
[ 2442.985956] Call Trace:
[ 2442.986265]  [<ffffffff8109f8b2>] lockdep_rcu_suspicious+0xe2/0x130
[ 2442.987014]  [<ffffffffa01bf827>] get_last_request+0x57/0x60 [cfg80211]
[ 2442.987801]  [<ffffffffa01bfff8>] handle_reg_beacon.isra.14+0x78/0x110 [cfg80211]
[ 2442.988694]  [<ffffffff815081b1>] ? _raw_spin_lock_bh+0x71/0x80
[ 2442.989404]  [<ffffffffa01c07a8>] reg_todo+0x228/0x580 [cfg80211]
[ 2442.990277]  [<ffffffff81061627>] process_one_work+0x207/0x770
[ 2442.991026]  [<ffffffff810615b7>] ? process_one_work+0x197/0x770
[ 2442.991754]  [<ffffffff8109ebb2>] ? get_lock_stats+0x22/0x70
[ 2442.992439]  [<ffffffffa01c0580>] ? regdom_changes+0x60/0x60 [cfg80211]
[ 2442.993265]  [<ffffffff81062a2e>] worker_thread+0x14e/0x3e0
[ 2442.993997]  [<ffffffff810628e0>] ? manage_workers+0x280/0x280
[ 2442.994684]  [<ffffffff8106911b>] kthread+0xdb/0xe0
[ 2442.995271]  [<ffffffff81069040>] ? __init_kthread_worker+0x70/0x70
[ 2442.996070]  [<ffffffff815099ec>] ret_from_fork+0x7c/0xb0
[ 2442.996762]  [<ffffffff81069040>] ? __init_kthread_worker+0x70/0x70


