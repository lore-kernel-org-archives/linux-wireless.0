Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56506 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759096Ab1JGA21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 20:28:27 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/4] ath9k: keep track of what's triggering hardware resets
Date: Fri,  7 Oct 2011 02:28:13 +0200
Message-Id: <1317947295-52172-2-git-send-email-nbd@openwrt.org> (sfid-20111007_022832_371962_6708B42B)
In-Reply-To: <1317947295-52172-1-git-send-email-nbd@openwrt.org>
References: <1317947295-52172-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Export how many times each of the reset triggers has fired through debugfs.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |   19 ++++++++++++++++---
 drivers/net/wireless/ath/ath9k/debug.h |   13 +++++++++++++
 drivers/net/wireless/ath/ath9k/main.c  |   15 ++++++++++++++-
 drivers/net/wireless/ath/ath9k/xmit.c  |    5 ++++-
 4 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index a5329c9..327aa28 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -523,9 +523,22 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 	if (tmp & ATH9K_RX_FILTER_PHYRADAR)
 		len += snprintf(buf + len, sizeof(buf) - len, " PHYRADAR");
 	if (tmp & ATH9K_RX_FILTER_MCAST_BCAST_ALL)
-		len += snprintf(buf + len, sizeof(buf) - len, " MCAST_BCAST_ALL\n");
-	else
-		len += snprintf(buf + len, sizeof(buf) - len, "\n");
+		len += snprintf(buf + len, sizeof(buf) - len, " MCAST_BCAST_ALL");
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+		       "\n\nReset causes:\n"
+		       "  baseband hang: %d\n"
+		       "  baseband watchdog: %d\n"
+		       "  fatal hardware error interrupt: %d\n"
+		       "  tx hardware error: %d\n"
+		       "  tx path hang: %d\n"
+		       "  pll rx hang: %d\n",
+		       sc->debug.stats.reset[RESET_TYPE_BB_HANG],
+		       sc->debug.stats.reset[RESET_TYPE_BB_WATCHDOG],
+		       sc->debug.stats.reset[RESET_TYPE_FATAL_INT],
+		       sc->debug.stats.reset[RESET_TYPE_TX_ERROR],
+		       sc->debug.stats.reset[RESET_TYPE_TX_HANG],
+		       sc->debug.stats.reset[RESET_TYPE_PLL_HANG]);
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index b93e88b..356352a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -25,8 +25,10 @@ struct ath_buf;
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 #define TX_STAT_INC(q, c) sc->debug.stats.txstats[q].c++
+#define RESET_STAT_INC(sc, type) sc->debug.stats.reset[type]++
 #else
 #define TX_STAT_INC(q, c) do { } while (0)
+#define RESET_STAT_INC(sc, type) do { } while (0)
 #endif
 
 #ifdef CONFIG_ATH9K_DEBUGFS
@@ -171,10 +173,21 @@ struct ath_rx_stats {
 	u8 rs_antenna;
 };
 
+enum ath_reset_type {
+	RESET_TYPE_BB_HANG,
+	RESET_TYPE_BB_WATCHDOG,
+	RESET_TYPE_FATAL_INT,
+	RESET_TYPE_TX_ERROR,
+	RESET_TYPE_TX_HANG,
+	RESET_TYPE_PLL_HANG,
+	__RESET_TYPE_MAX
+};
+
 struct ath_stats {
 	struct ath_interrupt_stats istats;
 	struct ath_tx_stats txstats[ATH9K_NUM_TX_QUEUES];
 	struct ath_rx_stats rxstats;
+	u32 reset[__RESET_TYPE_MAX];
 };
 
 #define ATH_DBG_MAX_SAMPLES	10
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9883186..366912f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -679,6 +679,16 @@ void ath9k_tasklet(unsigned long data)
 
 	if ((status & ATH9K_INT_FATAL) ||
 	    (status & ATH9K_INT_BB_WATCHDOG)) {
+#ifdef CONFIG_ATH9K_DEBUGFS
+		enum ath_reset_type type;
+
+		if (status & ATH9K_INT_FATAL)
+			type = RESET_TYPE_FATAL_INT;
+		else
+			type = RESET_TYPE_BB_WATCHDOG;
+
+		RESET_STAT_INC(sc, type);
+#endif
 		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 		goto out;
 	}
@@ -995,8 +1005,10 @@ void ath_hw_check(struct work_struct *work)
 	ath_dbg(common, ATH_DBG_RESET, "Possible baseband hang, "
 		"busy=%d (try %d)\n", busy, sc->hw_busy_count + 1);
 	if (busy >= 99) {
-		if (++sc->hw_busy_count >= 3)
+		if (++sc->hw_busy_count >= 3) {
+			RESET_STAT_INC(sc, RESET_TYPE_BB_HANG);
 			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+		}
 
 	} else if (busy >= 0)
 		sc->hw_busy_count = 0;
@@ -1016,6 +1028,7 @@ static void ath_hw_pll_rx_hang_check(struct ath_softc *sc, u32 pll_sqsum)
 			/* Rx is hung for more than 500ms. Reset it */
 			ath_dbg(common, ATH_DBG_RESET,
 				"Possible RX hang, resetting");
+			RESET_STAT_INC(sc, RESET_TYPE_PLL_HANG);
 			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 			count = 0;
 		}
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8980e7b..37d70b2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -564,8 +564,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	rcu_read_unlock();
 
-	if (needreset)
+	if (needreset) {
+		RESET_STAT_INC(sc, RESET_TYPE_TX_ERROR);
 		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+	}
 }
 
 static bool ath_lookup_legacy(struct ath_buf *bf)
@@ -2213,6 +2215,7 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 	if (needreset) {
 		ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
 			"tx hung, resetting the chip\n");
+		RESET_STAT_INC(sc, RESET_TYPE_TX_HANG);
 		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 	}
 
-- 
1.7.3.2

