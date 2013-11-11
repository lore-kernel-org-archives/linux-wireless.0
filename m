Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51754 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab3KKVX6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 16:23:58 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3/3] ath9k: optimize ath9k_flush
Date: Mon, 11 Nov 2013 22:23:35 +0100
Message-Id: <1384205015-68622-3-git-send-email-nbd@openwrt.org> (sfid-20131111_222406_214445_D22D51F4)
In-Reply-To: <1384205015-68622-1-git-send-email-nbd@openwrt.org>
References: <1384205015-68622-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of checking the queues in a loop with hardcoded sleep times
inbetween, use a wait queue to trigger queue checks after the tx
processing tasklet has run.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/init.c  |  1 +
 drivers/net/wireless/ath/ath9k/main.c  | 46 ++++++++++++++++++----------------
 3 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 48aca2f..d0b2283 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -724,6 +724,7 @@ struct ath_softc {
 	struct work_struct hw_check_work;
 	struct work_struct hw_reset_work;
 	struct completion paprd_complete;
+	wait_queue_head_t tx_wait;
 
 	unsigned int hw_busy_count;
 	unsigned long sc_flags;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 0d0820b..1853dd0 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -683,6 +683,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	common = ath9k_hw_common(ah);
 	sc->dfs_detector = dfs_pattern_detector_init(common, NL80211_DFS_UNSET);
 	sc->tx99_power = MAX_RATE_POWER + 1;
+	init_waitqueue_head(&sc->tx_wait);
 
 	if (!pdata) {
 		ah->ah_flags |= AH_USE_EEPROM;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a85738d..34b6fa5 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -504,6 +504,8 @@ void ath9k_tasklet(unsigned long data)
 			ath_tx_edma_tasklet(sc);
 		else
 			ath_tx_tasklet(sc);
+
+		wake_up(&sc->tx_wait);
 	}
 
 	ath9k_btcoex_handle_interrupt(sc, status);
@@ -1834,13 +1836,31 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 	mutex_unlock(&sc->mutex);
 }
 
+static bool ath9k_has_tx_pending(struct ath_softc *sc)
+{
+	int i, npend;
+
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (!ATH_TXQ_SETUP(sc, i))
+			continue;
+
+		if (!sc->tx.txq[i].axq_depth)
+			continue;
+
+		npend = ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
+		if (npend)
+			break;
+	}
+
+	return !!npend;
+}
+
 static void ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	int timeout = 200; /* ms */
-	int i, j;
+	int timeout = HZ / 5; /* 200 ms */
 	bool drain_txq;
 
 	mutex_lock(&sc->mutex);
@@ -1858,25 +1878,9 @@ static void ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 		return;
 	}
 
-	for (j = 0; j < timeout; j++) {
-		bool npend = false;
-
-		if (j)
-			usleep_range(1000, 2000);
-
-		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-			if (!ATH_TXQ_SETUP(sc, i))
-				continue;
-
-			npend = ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
-
-			if (npend)
-				break;
-		}
-
-		if (!npend)
-		    break;
-	}
+	if (wait_event_timeout(sc->tx_wait, !ath9k_has_tx_pending(sc),
+			       timeout) > 0)
+		drop = false;
 
 	if (drop) {
 		ath9k_ps_wakeup(sc);
-- 
1.8.3.4 (Apple Git-47)

