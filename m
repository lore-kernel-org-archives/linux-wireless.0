Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932457Ab0EMVuT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/17] iwlwifi: split debug and debugfs options
Date: Thu, 13 May 2010 14:49:56 -0700
Message-Id: <1273787399-9280-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It may be desirable in some systems to have
insight into the driver via debugfs, but not
affect its operation via the debug logging
code that is inserted everywhere when DEBUG
is configured.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig    |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-3945.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    7 ++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    6 +++---
 6 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index dc8ed15..6491e27 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -30,9 +30,11 @@ config IWLWIFI_DEBUG
 
 config IWLWIFI_DEBUGFS
         bool "iwlagn debugfs support"
-        depends on IWLWIFI && IWLWIFI_DEBUG && MAC80211_DEBUGFS
+        depends on IWLWIFI && MAC80211_DEBUGFS
         ---help---
-	  Enable creation of debugfs files for the iwlwifi drivers.
+	  Enable creation of debugfs files for the iwlwifi drivers. This
+	  is a low-impact option that allows getting insight into the
+	  driver's state at runtime.
 
 config IWLWIFI_DEVICE_TRACING
 	bool "iwlwifi device access tracing"
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 5ffbce8..f9b6e39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -351,7 +351,7 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
  *  RX handler implementations
  *
  *****************************************************************************/
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 /*
  *  based on the assumption of all statistics counter are in DWORD
  *  FIXME: This function is for debugging, do not deal with
@@ -459,7 +459,7 @@ void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct iwl3945_notif_statistics),
 		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl3945_accumulative_statistics(priv, (__le32 *)&pkt->u.raw);
 #endif
 	iwl_recover_from_statistics(priv, pkt);
@@ -474,7 +474,7 @@ void iwl3945_reply_statistics(struct iwl_priv *priv,
 	__le32 *flag = (__le32 *)&pkt->u.raw;
 
 	if (le32_to_cpu(*flag) & UCODE_STATISTICS_CLEAR_MSK) {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 		memset(&priv->_3945.accum_statistics, 0,
 			sizeof(struct iwl3945_notif_statistics));
 		memset(&priv->_3945.delta_statistics, 0,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f910246..5bfa7b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1465,7 +1465,12 @@ bool iwl_good_ack_health(struct iwl_priv *priv,
 				" expected_ack_cnt = %d\n",
 				actual_ack_cnt_delta, expected_ack_cnt_delta);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+		/*
+		 * This is ifdef'ed on DEBUGFS because otherwise the
+		 * statistics aren't available. If DEBUGFS is set but
+		 * DEBUG is not, these will just compile out.
+		 */
 		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta = %d\n",
 				priv->_agn.delta_statistics.tx.rx_detected_cnt);
 		IWL_DEBUG_RADIO(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f007b36..5f56a0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -456,7 +456,7 @@ u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 		if (!sta_ht_inf->ht_supported)
 			return 0;
 	}
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (priv->disable_ht40)
 		return 0;
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 05a7a0d..57a3c57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1255,7 +1255,7 @@ struct iwl_priv {
 			struct delayed_work rfkill_poll;
 
 			struct iwl3945_notif_statistics statistics;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 			struct iwl3945_notif_statistics accum_statistics;
 			struct iwl3945_notif_statistics delta_statistics;
 			struct iwl3945_notif_statistics max_delta;
@@ -1299,7 +1299,7 @@ struct iwl_priv {
 			struct completion firmware_loading_complete;
 
 			struct iwl_notif_statistics statistics;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 			struct iwl_notif_statistics accum_statistics;
 			struct iwl_notif_statistics delta_statistics;
 			struct iwl_notif_statistics max_delta;
@@ -1347,7 +1347,7 @@ struct iwl_priv {
 			    iwl_debug_level if set */
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
-	bool disable_ht40;
+#endif /* CONFIG_IWLWIFI_DEBUG */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	/* debugfs */
 	u16 tx_traffic_idx;
@@ -1356,8 +1356,8 @@ struct iwl_priv {
 	u8 *rx_traffic;
 	struct dentry *debugfs_dir;
 	u32 dbgfs_sram_offset, dbgfs_sram_len;
+	bool disable_ht40;
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
-#endif /* CONFIG_IWLWIFI_DEBUG */
 
 	struct work_struct txpower_work;
 	u32 disable_sens_cal;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index aea5cf4..e118984 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -285,7 +285,7 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 			last_rx_noise);
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 /*
  *  based on the assumption of all statistics counter are in DWORD
  *  FIXME: This function is for debugging, do not deal with
@@ -447,7 +447,7 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 		    STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
 		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
 #endif
 	iwl_recover_from_statistics(priv, pkt);
@@ -480,7 +480,7 @@ void iwl_reply_statistics(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
 	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATISTICS_CLEAR_MSK) {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 		memset(&priv->_agn.accum_statistics, 0,
 			sizeof(struct iwl_notif_statistics));
 		memset(&priv->_agn.delta_statistics, 0,
-- 
1.6.3.3

