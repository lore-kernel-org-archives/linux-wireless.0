Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61746 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2DJDUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 23:20:03 -0400
Received: by iagz16 with SMTP id z16so6758321iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2012 20:20:02 -0700 (PDT)
Message-ID: <4F83A6DE.7070109@lwfinger.net> (sfid-20120410_052008_360311_9D919FFA)
Date: Mon, 09 Apr 2012 22:19:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Suspicious RCU usage in mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running kernel 3.4-rc2 from wireless testing, I got the following logged:

[ 2299.344437] ===============================
[ 2299.344443] [ INFO: suspicious RCU usage. ]
[ 2299.344452] 3.4.0-rc2-wl+ #222 Not tainted
[ 2299.344458] -------------------------------
[ 2299.344466] net/mac80211/sta_info.h:449 suspicious 
rcu_dereference_protected() usage!
[ 2299.344472]
[ 2299.344474] other info that might help us debug this:
[ 2299.344477]
[ 2299.344484]
[ 2299.344486] rcu_scheduler_active = 1, debug_locks = 0
[ 2299.344493] 1 lock held by swapper/1/0:
[ 2299.344499]  #0:  (&tid_tx->session_timer){+.-...}, at: [<ffffffff8104850a>] 
run_timer_softirq+0xfa/0x6e0
[ 2299.344533]
[ 2299.344535] stack backtrace:
[ 2299.344544] Pid: 0, comm: swapper/1 Not tainted 3.4.0-rc2-wl+ #222
[ 2299.344551] Call Trace:
[ 2299.344557]  <IRQ>  [<ffffffff81092fdd>] lockdep_rcu_suspicious+0xfd/0x130
[ 2299.344651]  [<ffffffffa05db673>] sta_tx_agg_session_timer_expired+0xe3/0x100 
[mac80211]
[ 2299.344664]  [<ffffffff81048595>] run_timer_softirq+0x185/0x6e0
[ 2299.344676]  [<ffffffff8104850a>] ? run_timer_softirq+0xfa/0x6e0
[ 2299.344714]  [<ffffffffa05db590>] ? ieee80211_stop_tx_ba_session+0x240/0x240 
[mac80211]
[ 2299.344732]  [<ffffffff81040156>] __do_softirq+0xc6/0x3f0
[ 2299.344748]  [<ffffffff8139c934>] ? _raw_spin_lock+0x44/0x50
[ 2299.344758]  [<ffffffff8139d0f6>] ? _raw_spin_unlock+0x26/0x40
[ 2299.344771]  [<ffffffff8139f24c>] call_softirq+0x1c/0x30
[ 2299.344785]  [<ffffffff81004785>] do_softirq+0x85/0xc0
[ 2299.344795]  [<ffffffff810407b6>] irq_exit+0xa6/0xe0
[ 2299.344806]  [<ffffffff8100424e>] do_IRQ+0x5e/0xd0
[ 2299.344816]  [<ffffffff8139d56c>] common_interrupt+0x6c/0x6c
[ 2299.344823]  <EOI>  [<ffffffff8100c042>] ? default_idle+0x62/0x4f0
[ 2299.344844]  [<ffffffff8100c040>] ? default_idle+0x60/0x4f0
[ 2299.344854]  [<ffffffff8100c524>] amd_e400_idle+0x54/0x100
[ 2299.344864]  [<ffffffff8100ce96>] cpu_idle+0x96/0xe0
[ 2299.344875]  [<ffffffff8138fbc6>] start_secondary+0x1b7/0x1bb

The wireless driver in use was rtl8192ce.

Larry
