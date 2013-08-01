Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46485 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab3HAPaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 11:30:39 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 8/8] ath9k: Add statistics for antenna diversity
Date: Thu,  1 Aug 2013 20:57:06 +0530
Message-Id: <1375370826-1387-1-git-send-email-sujith@msujith.org> (sfid-20130801_173043_462666_B7EA854F)
In-Reply-To: <1375338204-2021-8-git-send-email-sujith@msujith.org>
References: <1375338204-2021-8-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 18 ++++---
 drivers/net/wireless/ath/ath9k/debug.c   | 85 ++++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/debug.h   | 20 +++++---
 3 files changed, 95 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 42f3b87..391d557 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -734,15 +734,18 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 		antcomb->main_total_rssi += main_rssi;
 		antcomb->alt_total_rssi  += alt_rssi;
 
-		if (main_ant_conf == rx_ant_conf) {
+		if (main_ant_conf == rx_ant_conf)
 			antcomb->main_recv_cnt++;
-			ANT_STAT_INC(ANT_MAIN, recv_cnt);
-			ANT_LNA_INC(ANT_MAIN, rx_ant_conf);
-		} else {
+		else
 			antcomb->alt_recv_cnt++;
-			ANT_STAT_INC(ANT_ALT, recv_cnt);
-			ANT_LNA_INC(ANT_ALT, rx_ant_conf);
-		}
+	}
+
+	if (main_ant_conf == rx_ant_conf) {
+		ANT_STAT_INC(ANT_MAIN, recv_cnt);
+		ANT_LNA_INC(ANT_MAIN, rx_ant_conf);
+	} else {
+		ANT_STAT_INC(ANT_ALT, recv_cnt);
+		ANT_LNA_INC(ANT_ALT, rx_ant_conf);
 	}
 
 	/* Short scan check */
@@ -821,6 +824,7 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 div_comb_done:
 	ath_ant_div_conf_fast_divbias(&div_ant_conf, antcomb, alt_ratio);
 	ath9k_hw_antdiv_comb_conf_set(sc->sc_ah, &div_ant_conf);
+	ath9k_debug_stat_ant(sc, &div_ant_conf, main_rssi_avg, alt_rssi_avg);
 
 	antcomb->scan_start_time = jiffies;
 	antcomb->total_pkt_count = 0;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 56cbe5d..a43bd8c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -321,6 +321,20 @@ static const struct file_operations fops_bt_ant_diversity = {
 	.llseek = default_llseek,
 };
 
+void ath9k_debug_stat_ant(struct ath_softc *sc,
+			  struct ath_hw_antcomb_conf *div_ant_conf,
+			  int main_rssi_avg, int alt_rssi_avg)
+{
+	struct ath_antenna_stats *as_main = &sc->debug.stats.ant_stats[ANT_MAIN];
+	struct ath_antenna_stats *as_alt = &sc->debug.stats.ant_stats[ANT_ALT];
+
+	as_main->lna_attempt_cnt[div_ant_conf->main_lna_conf]++;
+	as_alt->lna_attempt_cnt[div_ant_conf->alt_lna_conf]++;
+
+	as_main->rssi_avg = main_rssi_avg;
+	as_alt->rssi_avg = alt_rssi_avg;
+}
+
 static ssize_t read_file_antenna_diversity(struct file *file,
 					   char __user *user_buf,
 					   size_t count, loff_t *ppos)
@@ -330,9 +344,14 @@ static ssize_t read_file_antenna_diversity(struct file *file,
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_antenna_stats *as_main = &sc->debug.stats.ant_stats[ANT_MAIN];
 	struct ath_antenna_stats *as_alt = &sc->debug.stats.ant_stats[ANT_ALT];
+	struct ath_hw_antcomb_conf div_ant_conf;
 	unsigned int len = 0, size = 1024;
 	ssize_t retval = 0;
 	char *buf;
+	char *lna_conf_str[4] = {"LNA1_MINUS_LNA2",
+				 "LNA2",
+				 "LNA1",
+				 "LNA1_PLUS_LNA2"};
 
 	buf = kzalloc(size, GFP_KERNEL);
 	if (buf == NULL)
@@ -344,28 +363,66 @@ static ssize_t read_file_antenna_diversity(struct file *file,
 		goto exit;
 	}
 
+	ath9k_ps_wakeup(sc);
+	ath9k_hw_antdiv_comb_conf_get(ah, &div_ant_conf);
+	len += snprintf(buf + len, size - len, "Current MAIN config : %s\n",
+			lna_conf_str[div_ant_conf.main_lna_conf]);
+	len += snprintf(buf + len, size - len, "Current ALT config  : %s\n",
+			lna_conf_str[div_ant_conf.alt_lna_conf]);
+	len += snprintf(buf + len, size - len, "Average MAIN RSSI   : %d\n",
+			as_main->rssi_avg);
+	len += snprintf(buf + len, size - len, "Average ALT RSSI    : %d\n\n",
+			as_alt->rssi_avg);
+	ath9k_ps_restore(sc);
+
+	len += snprintf(buf + len, size - len, "Packet Receive Cnt:\n");
+	len += snprintf(buf + len, size - len, "-------------------\n");
+
 	len += snprintf(buf + len, size - len, "%30s%15s\n",
 			"MAIN", "ALT");
-	len += snprintf(buf + len, size - len, "%-15s%15d%15d\n",
-			"RECV CNT",
+	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			"TOTAL COUNT",
 			as_main->recv_cnt,
 			as_alt->recv_cnt);
-	len += snprintf(buf + len, size - len, "%-15s%15d%15d\n",
+	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			"LNA1",
+			as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1],
+			as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1]);
+	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			"LNA2",
+			as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA2],
+			as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA2]);
+	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			"LNA1 + LNA2",
+			as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2],
+			as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2]);
+	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			"LNA1 - LNA2",
+			as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2],
+			as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2]);
+
+	len += snprintf(buf + len, size - len, "\nLNA Config Attempts:\n");
+	len += snprintf(buf + len, size - len, "--------------------\n");
+
+	len += snprintf(buf + len, size - len, "%30s%15s\n",
+			"MAIN", "ALT");
+	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
 			"LNA1",
-			as_main->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1],
-			as_alt->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1]);
-	len += snprintf(buf + len, size - len, "%-15s%15d%15d\n",
+			as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1],
+			as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1]);
+	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
 			"LNA2",
-			as_main->lna_config_cnt[ATH_ANT_DIV_COMB_LNA2],
-			as_alt->lna_config_cnt[ATH_ANT_DIV_COMB_LNA2]);
-	len += snprintf(buf + len, size - len, "%-15s%15d%15d\n",
+			as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA2],
+			as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA2]);
+	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
 			"LNA1 + LNA2",
-			as_main->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2],
-			as_alt->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2]);
-	len += snprintf(buf + len, size - len, "%-15s%15d%15d\n",
+			as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2],
+			as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2]);
+	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
 			"LNA1 - LNA2",
-			as_main->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2],
-			as_alt->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2]);
+			as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2],
+			as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2]);
+
 exit:
 	if (len > size)
 		len = size;
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index a879e45..01c5c6a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -29,7 +29,7 @@ struct fft_sample_tlv;
 #define TX_STAT_INC(q, c) sc->debug.stats.txstats[q].c++
 #define RESET_STAT_INC(sc, type) sc->debug.stats.reset[type]++
 #define ANT_STAT_INC(i, c) sc->debug.stats.ant_stats[i].c++
-#define ANT_LNA_INC(i, c) sc->debug.stats.ant_stats[i].lna_config_cnt[c]++;
+#define ANT_LNA_INC(i, c) sc->debug.stats.ant_stats[i].lna_recv_cnt[c]++;
 #else
 #define TX_STAT_INC(q, c) do { } while (0)
 #define RESET_STAT_INC(sc, type) do { } while (0)
@@ -252,7 +252,9 @@ struct ath_rx_stats {
 
 struct ath_antenna_stats {
 	u32 recv_cnt;
-	u32 lna_config_cnt[4];
+	u32 rssi_avg;
+	u32 lna_recv_cnt[4];
+	u32 lna_attempt_cnt[4];
 };
 
 struct ath_stats {
@@ -294,10 +296,11 @@ void ath9k_sta_remove_debugfs(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta,
 			      struct dentry *dir);
-
 void ath_debug_send_fft_sample(struct ath_softc *sc,
 			       struct fft_sample_tlv *fft_sample);
-
+void ath9k_debug_stat_ant(struct ath_softc *sc,
+			  struct ath_hw_antcomb_conf *div_ant_conf,
+			  int main_rssi_avg, int alt_rssi_avg);
 #else
 
 #define RX_STAT_INC(c) /* NOP */
@@ -310,12 +313,10 @@ static inline int ath9k_init_debug(struct ath_hw *ah)
 static inline void ath9k_deinit_debug(struct ath_softc *sc)
 {
 }
-
 static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
 					    enum ath9k_int status)
 {
 }
-
 static inline void ath_debug_stat_tx(struct ath_softc *sc,
 				     struct ath_buf *bf,
 				     struct ath_tx_status *ts,
@@ -323,11 +324,16 @@ static inline void ath_debug_stat_tx(struct ath_softc *sc,
 				     unsigned int flags)
 {
 }
-
 static inline void ath_debug_stat_rx(struct ath_softc *sc,
 				     struct ath_rx_status *rs)
 {
 }
+static inline void ath9k_debug_stat_ant(struct ath_softc *sc,
+					struct ath_hw_antcomb_conf *div_ant_conf,
+					int main_rssi_avg, int alt_rssi_avg)
+{
+
+}
 
 #endif /* CONFIG_ATH9K_DEBUGFS */
 
-- 
1.8.3.4

