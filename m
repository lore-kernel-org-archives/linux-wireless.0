Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:48938
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751601Ab2K1Jj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:39:26 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] ath9k: Move ethtool functions to debug.c
Date: Wed, 28 Nov 2012 15:08:52 +0530
Message-Id: <1354095535-3564-1-git-send-email-sujith@msujith.org> (sfid-20121128_103934_307314_A664571C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The ethtool statistics are available only when
CONFIG_ATH9K_DEBUGFS is enabled, move these functions
to debug.c

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 119 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h |   8 +++
 drivers/net/wireless/ath/ath9k/main.c  | 127 ---------------------------------
 3 files changed, 127 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 939308c..cb5e457 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1509,6 +1509,125 @@ static const struct file_operations fops_btcoex = {
 };
 #endif
 
+/* Ethtool support for get-stats */
+
+#define AMKSTR(nm) #nm "_BE", #nm "_BK", #nm "_VI", #nm "_VO"
+static const char ath9k_gstrings_stats[][ETH_GSTRING_LEN] = {
+	"tx_pkts_nic",
+	"tx_bytes_nic",
+	"rx_pkts_nic",
+	"rx_bytes_nic",
+	AMKSTR(d_tx_pkts),
+	AMKSTR(d_tx_bytes),
+	AMKSTR(d_tx_mpdus_queued),
+	AMKSTR(d_tx_mpdus_completed),
+	AMKSTR(d_tx_mpdu_xretries),
+	AMKSTR(d_tx_aggregates),
+	AMKSTR(d_tx_ampdus_queued_hw),
+	AMKSTR(d_tx_ampdus_queued_sw),
+	AMKSTR(d_tx_ampdus_completed),
+	AMKSTR(d_tx_ampdu_retries),
+	AMKSTR(d_tx_ampdu_xretries),
+	AMKSTR(d_tx_fifo_underrun),
+	AMKSTR(d_tx_op_exceeded),
+	AMKSTR(d_tx_timer_expiry),
+	AMKSTR(d_tx_desc_cfg_err),
+	AMKSTR(d_tx_data_underrun),
+	AMKSTR(d_tx_delim_underrun),
+	"d_rx_decrypt_crc_err",
+	"d_rx_phy_err",
+	"d_rx_mic_err",
+	"d_rx_pre_delim_crc_err",
+	"d_rx_post_delim_crc_err",
+	"d_rx_decrypt_busy_err",
+
+	"d_rx_phyerr_radar",
+	"d_rx_phyerr_ofdm_timing",
+	"d_rx_phyerr_cck_timing",
+
+};
+#define ATH9K_SSTATS_LEN ARRAY_SIZE(ath9k_gstrings_stats)
+
+void ath9k_get_et_strings(struct ieee80211_hw *hw,
+			  struct ieee80211_vif *vif,
+			  u32 sset, u8 *data)
+{
+	if (sset == ETH_SS_STATS)
+		memcpy(data, *ath9k_gstrings_stats,
+		       sizeof(ath9k_gstrings_stats));
+}
+
+int ath9k_get_et_sset_count(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif, int sset)
+{
+	if (sset == ETH_SS_STATS)
+		return ATH9K_SSTATS_LEN;
+	return 0;
+}
+
+#define AWDATA(elem)							\
+	do {								\
+		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].elem; \
+		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].elem; \
+		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].elem; \
+		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].elem; \
+	} while (0)
+
+#define AWDATA_RX(elem)						\
+	do {							\
+		data[i++] = sc->debug.stats.rxstats.elem;	\
+	} while (0)
+
+void ath9k_get_et_stats(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif,
+			struct ethtool_stats *stats, u64 *data)
+{
+	struct ath_softc *sc = hw->priv;
+	int i = 0;
+
+	data[i++] = (sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_pkts_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].tx_pkts_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].tx_pkts_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].tx_pkts_all);
+	data[i++] = (sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_bytes_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].tx_bytes_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].tx_bytes_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].tx_bytes_all);
+	AWDATA_RX(rx_pkts_all);
+	AWDATA_RX(rx_bytes_all);
+
+	AWDATA(tx_pkts_all);
+	AWDATA(tx_bytes_all);
+	AWDATA(queued);
+	AWDATA(completed);
+	AWDATA(xretries);
+	AWDATA(a_aggr);
+	AWDATA(a_queued_hw);
+	AWDATA(a_queued_sw);
+	AWDATA(a_completed);
+	AWDATA(a_retries);
+	AWDATA(a_xretries);
+	AWDATA(fifo_underrun);
+	AWDATA(xtxop);
+	AWDATA(timer_exp);
+	AWDATA(desc_cfg_err);
+	AWDATA(data_underrun);
+	AWDATA(delim_underrun);
+
+	AWDATA_RX(decrypt_crc_err);
+	AWDATA_RX(phy_err);
+	AWDATA_RX(mic_err);
+	AWDATA_RX(pre_delim_crc_err);
+	AWDATA_RX(post_delim_crc_err);
+	AWDATA_RX(decrypt_busy_err);
+
+	AWDATA_RX(phy_err_stats[ATH9K_PHYERR_RADAR]);
+	AWDATA_RX(phy_err_stats[ATH9K_PHYERR_OFDM_TIMING]);
+	AWDATA_RX(phy_err_stats[ATH9K_PHYERR_CCK_TIMING]);
+
+	WARN_ON(i != ATH9K_SSTATS_LEN);
+}
+
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index f9bee18..bfc21b3 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -307,6 +307,14 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		       struct ath_tx_status *ts, struct ath_txq *txq,
 		       unsigned int flags);
 void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs);
+int ath9k_get_et_sset_count(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif, int sset);
+void ath9k_get_et_stats(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif,
+			struct ethtool_stats *stats, u64 *data);
+void ath9k_get_et_strings(struct ieee80211_hw *hw,
+			  struct ieee80211_vif *vif,
+			  u32 sset, u8 *data);
 
 #else
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0653dbc..ffae384 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1882,133 +1882,6 @@ static int ath9k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
 	return 0;
 }
 
-#ifdef CONFIG_ATH9K_DEBUGFS
-
-/* Ethtool support for get-stats */
-
-#define AMKSTR(nm) #nm "_BE", #nm "_BK", #nm "_VI", #nm "_VO"
-static const char ath9k_gstrings_stats[][ETH_GSTRING_LEN] = {
-	"tx_pkts_nic",
-	"tx_bytes_nic",
-	"rx_pkts_nic",
-	"rx_bytes_nic",
-	AMKSTR(d_tx_pkts),
-	AMKSTR(d_tx_bytes),
-	AMKSTR(d_tx_mpdus_queued),
-	AMKSTR(d_tx_mpdus_completed),
-	AMKSTR(d_tx_mpdu_xretries),
-	AMKSTR(d_tx_aggregates),
-	AMKSTR(d_tx_ampdus_queued_hw),
-	AMKSTR(d_tx_ampdus_queued_sw),
-	AMKSTR(d_tx_ampdus_completed),
-	AMKSTR(d_tx_ampdu_retries),
-	AMKSTR(d_tx_ampdu_xretries),
-	AMKSTR(d_tx_fifo_underrun),
-	AMKSTR(d_tx_op_exceeded),
-	AMKSTR(d_tx_timer_expiry),
-	AMKSTR(d_tx_desc_cfg_err),
-	AMKSTR(d_tx_data_underrun),
-	AMKSTR(d_tx_delim_underrun),
-
-	"d_rx_decrypt_crc_err",
-	"d_rx_phy_err",
-	"d_rx_mic_err",
-	"d_rx_pre_delim_crc_err",
-	"d_rx_post_delim_crc_err",
-	"d_rx_decrypt_busy_err",
-
-	"d_rx_phyerr_radar",
-	"d_rx_phyerr_ofdm_timing",
-	"d_rx_phyerr_cck_timing",
-
-};
-#define ATH9K_SSTATS_LEN ARRAY_SIZE(ath9k_gstrings_stats)
-
-static void ath9k_get_et_strings(struct ieee80211_hw *hw,
-				 struct ieee80211_vif *vif,
-				 u32 sset, u8 *data)
-{
-	if (sset == ETH_SS_STATS)
-		memcpy(data, *ath9k_gstrings_stats,
-		       sizeof(ath9k_gstrings_stats));
-}
-
-static int ath9k_get_et_sset_count(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif, int sset)
-{
-	if (sset == ETH_SS_STATS)
-		return ATH9K_SSTATS_LEN;
-	return 0;
-}
-
-#define AWDATA(elem)							\
-	do {								\
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].elem; \
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].elem; \
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].elem; \
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].elem; \
-	} while (0)
-
-#define AWDATA_RX(elem)						\
-	do {							\
-		data[i++] = sc->debug.stats.rxstats.elem;	\
-	} while (0)
-
-static void ath9k_get_et_stats(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       struct ethtool_stats *stats, u64 *data)
-{
-	struct ath_softc *sc = hw->priv;
-	int i = 0;
-
-	data[i++] = (sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_pkts_all +
-		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].tx_pkts_all +
-		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].tx_pkts_all +
-		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].tx_pkts_all);
-	data[i++] = (sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_bytes_all +
-		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].tx_bytes_all +
-		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].tx_bytes_all +
-		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].tx_bytes_all);
-	AWDATA_RX(rx_pkts_all);
-	AWDATA_RX(rx_bytes_all);
-
-	AWDATA(tx_pkts_all);
-	AWDATA(tx_bytes_all);
-	AWDATA(queued);
-	AWDATA(completed);
-	AWDATA(xretries);
-	AWDATA(a_aggr);
-	AWDATA(a_queued_hw);
-	AWDATA(a_queued_sw);
-	AWDATA(a_completed);
-	AWDATA(a_retries);
-	AWDATA(a_xretries);
-	AWDATA(fifo_underrun);
-	AWDATA(xtxop);
-	AWDATA(timer_exp);
-	AWDATA(desc_cfg_err);
-	AWDATA(data_underrun);
-	AWDATA(delim_underrun);
-
-	AWDATA_RX(decrypt_crc_err);
-	AWDATA_RX(phy_err);
-	AWDATA_RX(mic_err);
-	AWDATA_RX(pre_delim_crc_err);
-	AWDATA_RX(post_delim_crc_err);
-	AWDATA_RX(decrypt_busy_err);
-
-	AWDATA_RX(phy_err_stats[ATH9K_PHYERR_RADAR]);
-	AWDATA_RX(phy_err_stats[ATH9K_PHYERR_OFDM_TIMING]);
-	AWDATA_RX(phy_err_stats[ATH9K_PHYERR_CCK_TIMING]);
-
-	WARN_ON(i != ATH9K_SSTATS_LEN);
-}
-
-/* End of ethtool get-stats functions */
-
-#endif
-
-
 #ifdef CONFIG_PM_SLEEP
 
 static void ath9k_wow_map_triggers(struct ath_softc *sc,
-- 
1.8.0.1

