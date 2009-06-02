Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1763 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZFBEHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 00:07:45 -0400
Date: Tue, 2 Jun 2009 00:05:04 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: use GFP_ATOMIC for michael mic failure message
Message-ID: <20090602040503.GA5385@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nl80211_michael_mic_failure can be called in atomic context but
does a GFP_KERNEL allocation.  Fixes the error below:

[  126.793225] BUG: sleeping function called from invalid context at mm/slab.c:3055
[  126.793234] in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
[  126.793241] 2 locks held by swapper/0:
[  126.793246]  #0:  (&sc->rxbuflock){+.-.+.}, at: [<f94e1b46>] ath5k_tasklet_rx+0x34/0x55e [ath5k]
[  126.793294]  #1:  (rcu_read_lock){.+.+.+}, at: [<f92872f3>] __ieee80211_rx+0x7e/0x563 [mac80211]
[  126.793342] Pid: 0, comm: swapper Not tainted 2.6.30-rc7-wl #124
[  126.793347] Call Trace:
[  126.793361]  [<c014499d>] ? __debug_show_held_locks+0x1e/0x20
[  126.793380]  [<c011e9a3>] __might_sleep+0x100/0x107
[  126.793386]  [<c018ea99>] kmem_cache_alloc+0x35/0x170
[  126.793393]  [<c02e8bb1>] ? __alloc_skb+0x2e/0x117
[  126.793397]  [<c014517d>] ? mark_held_locks+0x43/0x5b
[  126.793402]  [<c02e8bb1>] __alloc_skb+0x2e/0x117
[  126.793419]  [<f851a836>] nl80211_michael_mic_failure+0x2a/0x1fa [cfg80211]
[  126.793425]  [<c01453b8>] ? trace_hardirqs_on_caller+0xf6/0x130
[  126.793430]  [<c01453fd>] ? trace_hardirqs_on+0xb/0xd
[  126.793444]  [<f851b2b8>] cfg80211_michael_mic_failure+0x30/0x38 [cfg80211]
[  126.793463]  [<f928bf69>] mac80211_ev_michael_mic_failure+0xfd/0x108 [mac80211]
[  126.793480]  [<f9279fbd>] ieee80211_rx_h_michael_mic_verify+0xd4/0x117 [mac80211]
[  126.793499]  [<f9285ef3>] ieee80211_invoke_rx_handlers+0xdde/0x1963 [mac80211]
[  126.793505]  [<c0107152>] ? sched_clock+0x3f/0x64
[  126.793511]  [<c0107152>] ? sched_clock+0x3f/0x64
[  126.793516]  [<c01445d7>] ? trace_hardirqs_off+0xb/0xd
[  126.793521]  [<c0107152>] ? sched_clock+0x3f/0x64
[  126.793526]  [<c0146454>] ? __lock_acquire+0x62c/0x1271
[  126.793545]  [<f9286fbb>] __ieee80211_rx_handle_packet+0x543/0x564 [mac80211]
[  126.793564]  [<f9287757>] __ieee80211_rx+0x4e2/0x563 [mac80211]
[  126.793577]  [<f94e1ff6>] ath5k_tasklet_rx+0x4e4/0x55e [ath5k]
[  126.793583]  [<c0102b54>] ? restore_nocheck_notrace+0x0/0xe
[  126.793589]  [<c0129aa2>] tasklet_action+0x92/0xe5
[  126.793594]  [<c0129f22>] __do_softirq+0xb1/0x182
[  126.793599]  [<c012a023>] do_softirq+0x30/0x48
[  126.793603]  [<c012a19b>] irq_exit+0x3d/0x74
[  126.793609]  [<c0358016>] do_IRQ+0x76/0x8c
[  126.793613]  [<c010312e>] common_interrupt+0x2e/0x34
[  126.793618]  [<c014007b>] ? timer_list_show+0x277/0x939
[  126.793630]  [<f88eb321>] ? acpi_idle_enter_bm+0x266/0x291 [processor]
[  126.793636]  [<c02d00f6>] cpuidle_idle_call+0x6a/0x9c
[  126.793640]  [<c0101cc8>] cpu_idle+0x53/0x87
[  126.793645]  [<c0344510>] rest_init+0x6c/0x6e
[  126.793651]  [<c04dd74d>] start_kernel+0x286/0x28b
[  126.793656]  [<c04dd037>] __init_begin+0x37/0x3c

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/wireless/nl80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3b10569..34c6bc8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3828,7 +3828,7 @@ void nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!msg)
 		return;
 
@@ -3852,7 +3852,7 @@ void nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_KERNEL);
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_ATOMIC);
 	return;
 
  nla_put_failure:
-- 
1.6.0.6

-- 
Bob Copeland %% www.bobcopeland.com

