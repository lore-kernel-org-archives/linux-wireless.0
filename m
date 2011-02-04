Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60549 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab1BDNIc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 08:08:32 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 05:08:12 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH 2.6.38] ath9k: Fix possible double free of PAPRD skb's
Date: Fri, 4 Feb 2011 18:38:23 +0530
Message-ID: <1296824903-2114-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This patch reverts the following commit
ath9k: remove bfs_paprd_timestamp from struct ath_buf_state

Under high interference/noisy environment conditions where PAPRD frames
fails heavily introduces a possibility of double freeing skb's and causes
kernel panic after some time.This patch reverts back to the original approach
of using paprd_timestamp before freeing the PAPRD frame skb's

[  194.193705] Pid: 0, comm: swapper Tainted: G      D WC
2.6.35-22-generic #33-Ubuntu
[  194.193712] Call Trace:
[  194.193722]  [<c05c6468>] ? printk+0x2d/0x35
[  194.193732]  [<c05c63c3>] panic+0x5a/0xd2
[  194.193741]  [<c05ca3ed>] oops_end+0xcd/0xd0
[  194.193750]  [<c0105f74>] die+0x54/0x80
[  194.193758]  [<c05c9a16>] do_trap+0x96/0xc0
[  194.193837]  [<c0103fb0>] ? do_invalid_op+0x0/0xa0
[  194.193846]  [<c010403b>] do_invalid_op+0x8b/0xa0
[  194.193856]  [<c020bd4c>] ? kfree+0xec/0xf0
[  194.193866]  [<c012ce18>] ? default_spin_lock_flags+0x8/0x10
[  194.193877]  [<c01de47a>] ? free_one_page+0x12a/0x2d0
[  194.193888]  [<c01e04dc>] ? __free_pages+0x1c/0x40
[  194.193897]  [<c05c97a7>] error_code+0x73/0x78
[  194.193906]  [<c020bd4c>] ? kfree+0xec/0xf0
[  194.193915]  [<c04ecdd0>] ? skb_release_data+0x70/0xa0
[  194.193924]  [<c04ecdd0>] skb_release_data+0x70/0xa0
[  194.193933]  [<c04ec997>] __kfree_skb+0x17/0x90
[  194.193941]  [<c04eca31>] consume_skb+0x21/0x40
[  194.193964]  [<f85e0b70>] ieee80211_tx_status+0x760/0x860 [mac80211]
[  194.193979]  [<f85caddf>] ath_tx_complete_buf+0x1bf/0x2c0 [ath9k]
[  194.193988]  [<c05c8b9f>] ? _raw_spin_lock_irqsave+0x2f/0x50
[  194.193997]  [<c04ec40e>] ? skb_queue_tail+0x3e/0x50
[  194.194010]  [<f85cc803>] ath_tx_complete_aggr+0x823/0x940 [ath9k]
[  194.194021]  [<c0108a28>] ? sched_clock+0x8/0x10
[  194.194030]  [<c016bf14>] ? sched_clock_local+0xa4/0x180
[  194.194040]  [<c0139f57>] ? enqueue_sleeper+0x1e7/0x2b0
[  194.194051]  [<c013a194>] ? enqueue_entity+0x174/0x200
[  194.194064]  [<f85ce83d>] ath_tx_edma_tasklet+0x2bd/0x3b0 [ath9k]
[  194.194074]  [<c05c8b9f>] ? _raw_spin_lock_irqsave+0x2f/0x50
[  194.194088]  [<f85c7b9f>] ath9k_tasklet+0x9f/0x190 [ath9k]
[  194.194097]  [<c01505d7>] tasklet_action+0xa7/0xb0
[  194.194107]  [<c015127c>] __do_softirq+0x9c/0x1b0
[  194.194117]  [<c01a7f64>] ? irq_to_desc+0x14/0x20
[  194.194126]  [<c0124fc4>] ? ack_apic_level+0x64/0x1f0
[  194.194136]  [<c01513d5>] do_softirq+0x45/0x50
[  194.194145]  [<c0151545>] irq_exit+0x65/0x70
[  194.194153]  [<c05cf665>] do_IRQ+0x55/0xc0
[  194.194162]  [<c016a6c7>] ? hrtimer_start+0x27/0x30
[  194.194171]  [<c0103630>] common_interrupt+0x30/0x38
[  194.194181]  [<c012c21a>] ? native_safe_halt+0xa/0x10
[  194.194268]  [<c010a2f9>] default_idle+0x49/0xb0
[  194.194277]  [<c0101fcc>] cpu_idle+0x8c/0xd0
[  194.194286]  [<c05b2431>] rest_init+0x71/0x80
[  194.194295]  [<c081981a>] start_kernel+0x36e/0x374
[  194.194305]  [<c08199dd>] ? pass_all_bootoptions+0x0/0xa
[  194.194314]  [<c08190d7>] i386_start_kernel+0xd7/0xdf
[  194.194364] panic occurred, switching back to text console

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/main.c  |    2 --
 drivers/net/wireless/ath/ath9k/xmit.c  |    7 ++++++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index bd85e31..6181959 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -218,6 +218,7 @@ struct ath_frame_info {
 struct ath_buf_state {
 	u8 bf_type;
 	u8 bfs_paprd;
+	unsigned long bfs_paprd_timestamp;
 	enum ath9k_internal_frame_type bfs_ftype;
 };
 
@@ -600,7 +601,6 @@ struct ath_softc {
 	struct work_struct paprd_work;
 	struct work_struct hw_check_work;
 	struct completion paprd_complete;
-	bool paprd_pending;
 
 	u32 intrstatus;
 	u32 sc_flags; /* SC_OP_* */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e5c695d..9ec9504 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -325,7 +325,6 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 	tx_info->control.rates[1].idx = -1;
 
 	init_completion(&sc->paprd_complete);
-	sc->paprd_pending = true;
 	txctl.paprd = BIT(chain);
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
@@ -336,7 +335,6 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 
 	time_left = wait_for_completion_timeout(&sc->paprd_complete,
 			msecs_to_jiffies(ATH_PAPRD_TIMEOUT));
-	sc->paprd_pending = false;
 
 	if (!time_left)
 		ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_CALIBRATE,
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 68a1c76..9f4e755 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1752,6 +1752,9 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			ar9003_hw_set_paprd_txdesc(sc->sc_ah, bf->bf_desc,
 						   bf->bf_state.bfs_paprd);
 
+		if (txctl->paprd)
+			bf->bf_state.bfs_paprd_timestamp = jiffies;
+
 		ath_tx_send_normal(sc, txctl->txq, tid, &bf_head);
 	}
 
@@ -1909,7 +1912,9 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	bf->bf_buf_addr = 0;
 
 	if (bf->bf_state.bfs_paprd) {
-		if (!sc->paprd_pending)
+		if (time_after(jiffies,
+				bf->bf_state.bfs_paprd_timestamp +
+				msecs_to_jiffies(ATH_PAPRD_TIMEOUT)))
 			dev_kfree_skb_any(skb);
 		else
 			complete(&sc->paprd_complete);
-- 
1.7.0.4

