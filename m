Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:32840 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbJ0Hf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 03:35:28 -0400
Received: by lbbec13 with SMTP id ec13so54924066lbb.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 00:35:27 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 01/14] mac80211: fix divide by zero when NOA update
Date: Tue, 27 Oct 2015 08:35:11 +0100
Message-Id: <1445931311-14091-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151027_083532_697903_7FE8C586)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of one shot NOA the interval could be 0.
This patch fix such dump:

divide error: 0000 [#1] SMP
CPU: 4 PID: 0 Comm: swapper/4 Tainted: G        W  OE   4.3.0-rc3master-2015-10-12-00-hz250-wl-ath+ #27
Hardware name: Dell Inc. Latitude E6430/0H3MT5, BIOS A13 09/02/2013
task: ffff88022452d400 ti: ffff880224564000 task.ti: ffff880224564000
RIP: 0010:[<ffffffffc08e886a>]  [<ffffffffc08e886a>] ieee80211_extend_noa_desc+0x3a/0x80 [mac80211]
RSP: 0018:ffff88022e303da8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880221649e98 RCX: 00000000ffffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880221649e98
RBP: ffff88022e303da8 R08: ffff880221649e98 R09: 0000000000000000
R10: 0000000098ce2400 R11: 0000000000000000 R12: ffff880221649e98
R13: ffff880221649e98 R14: 0000000000000000 R15: ffff880221649e9c
FS:  0000000000000000(0000) GS:ffff88022e300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feac4d4e1b8 CR3: 0000000001c10000 CR4: 00000000001406e0
Stack:
ffff88022e303df0 ffffffffc08e891c 98ce24a3e24e1520 ffff88022e303e0c
0000000000000005 ffff880221649e98 ffff880221649ec8 0000000098ce24a3
000000007fffffff ffff88022e303e38 ffffffffc08e8a17 00000000c068d1bd
Call Trace:
<IRQ>
[<ffffffffc08e891c>] ieee80211_extend_absent_time+0x6c/0xb0 [mac80211]
[<ffffffffc08e8a17>] ieee80211_update_p2p_noa+0xb7/0xe0 [mac80211]
[<ffffffffc069cc30>] ath9k_p2p_ps_timer+0x170/0x190 [ath9k]
[<ffffffffc070adf8>] ath_gen_timer_isr+0xc8/0xf0 [ath9k_hw]
[<ffffffffc0691156>] ath9k_tasklet+0x296/0x2f0 [ath9k]
[<ffffffff8107ad65>] tasklet_action+0xe5/0xf0
[<ffffffff8107afc7>] __do_softirq+0xd7/0x2a0
[<ffffffff8107b417>] irq_exit+0xd7/0xe0
[<ffffffff81794506>] do_IRQ+0x56/0xd0
[<ffffffff81792187>] common_interrupt+0x87/0x87
<EOI>
[<ffffffff816347e8>] ? cpuidle_enter_state+0xb8/0x220
[<ffffffff816347c4>] ? cpuidle_enter_state+0x94/0x220
[<ffffffff81634987>] cpuidle_enter+0x17/0x20
[<ffffffff810b700b>] call_cpuidle+0x3b/0x70
[<ffffffff81634963>] ? cpuidle_select+0x13/0x20
[<ffffffff810b72ac>] cpu_startup_entry+0x26c/0x330
[<ffffffff8104c769>] start_secondary+0x149/0x170
Code: e5 4c 8d 04 87 45 8b 50 0c 41 8b 48 10 44 01 d1 83 e9 01 29 f1 31 f6 85 c9 7e 04 89 f0 5d c3 45 8b 58 14 31 d2 41 8d 43 ff 29 c8 <41> f7 f3 42 0f b6 54 0f 06 80 fa ff 74 0e 0f b6 ca 39 c8 7d 1b
RIP  [<ffffffffc08e886a>] ieee80211_extend_noa_desc+0x3a/0x80 [mac80211]
RSP <ffff88022e303da8>
---[ end trace e9ffc912b1ac465a ]---
Kernel panic - not syncing: Fatal exception in interrupt

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/util.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 60c4dbf..96ec2d1 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2954,6 +2954,13 @@ ieee80211_extend_noa_desc(struct ieee80211_noa_data *data, u32 tsf, int i)
 	if (end > 0)
 		return false;
 
+	/* One shot NOA  */
+	if (data->count[i] == 1)
+		return false;
+
+	if (data->desc[i].interval == 0)
+		return false;
+
 	/* End time is in the past, check for repetitions */
 	skip = DIV_ROUND_UP(-end, data->desc[i].interval);
 	if (data->count[i] < 255) {
-- 
1.9.1

