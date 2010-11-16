Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26170 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab0KPQGl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:41 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/18] iwlagn: used frame count info in compressed ba packet
Date: Tue, 16 Nov 2010 08:01:34 -0800
Message-Id: <1289923311-14920-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For newer devices, uCode provide both "number of frames sent"
and "number of frames acked" information inside the compressed_ba
packet. So instead of figure the success/failure information through
the bitmap, use those information which is much betrer approach.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   68 ++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 +
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 ++-
 4 files changed, 54 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 4748d06..a172bd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2620,6 +2620,7 @@ static struct iwl_base_params iwl4965_base_params = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+	.no_agg_framecnt_info = true,
 };
 
 struct iwl_cfg iwl4965_agn_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 2b078a9..522c77f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1241,37 +1241,61 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	if (sh < 0) /* tbw something is wrong with indices */
 		sh += 0x100;
 
-	/* don't use 64-bit values for now */
-	bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
-
 	if (agg->frame_count > (64 - sh)) {
 		IWL_DEBUG_TX_REPLY(priv, "more frames than bitmap size");
 		return -1;
 	}
-
-	/* check for success or failure according to the
-	 * transmitted bitmap and block-ack bitmap */
-	sent_bitmap = bitmap & agg->bitmap;
-
-	/* For each frame attempted in aggregation,
-	 * update driver's record of tx frame's status. */
-	i = 0;
-	while (sent_bitmap) {
-		ack = sent_bitmap & 1ULL;
-		successes += ack;
-		IWL_DEBUG_TX_REPLY(priv, "%s ON i=%d idx=%d raw=%d\n",
-			ack ? "ACK" : "NACK", i, (agg->start_idx + i) & 0xff,
-			agg->start_idx + i);
-		sent_bitmap >>= 1;
-		++i;
+	if (!priv->cfg->base_params->no_agg_framecnt_info && ba_resp->txed) {
+		/*
+		 * sent and ack information provided by uCode
+		 * use it instead of figure out ourself
+		 */
+		if (ba_resp->txed_2_done > ba_resp->txed) {
+			IWL_DEBUG_TX_REPLY(priv,
+				"bogus sent(%d) and ack(%d) count\n",
+				ba_resp->txed, ba_resp->txed_2_done);
+			/*
+			 * set txed_2_done = txed,
+			 * so it won't impact rate scale
+			 */
+			ba_resp->txed = ba_resp->txed_2_done;
+		}
+		IWL_DEBUG_HT(priv, "agg frames sent:%d, acked:%d\n",
+				ba_resp->txed, ba_resp->txed_2_done);
+	} else {
+		/* don't use 64-bit values for now */
+		bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
+
+		/* check for success or failure according to the
+		 * transmitted bitmap and block-ack bitmap */
+		sent_bitmap = bitmap & agg->bitmap;
+
+		/* For each frame attempted in aggregation,
+		 * update driver's record of tx frame's status. */
+		i = 0;
+		while (sent_bitmap) {
+			ack = sent_bitmap & 1ULL;
+			successes += ack;
+			IWL_DEBUG_TX_REPLY(priv, "%s ON i=%d idx=%d raw=%d\n",
+				ack ? "ACK" : "NACK", i,
+				(agg->start_idx + i) & 0xff,
+				agg->start_idx + i);
+			sent_bitmap >>= 1;
+			++i;
+		}
 	}
-
 	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb);
 	memset(&info->status, 0, sizeof(info->status));
 	info->flags |= IEEE80211_TX_STAT_ACK;
 	info->flags |= IEEE80211_TX_STAT_AMPDU;
-	info->status.ampdu_ack_len = successes;
-	info->status.ampdu_len = agg->frame_count;
+	if (!priv->cfg->base_params->no_agg_framecnt_info && ba_resp->txed) {
+		info->status.ampdu_ack_len = ba_resp->txed_2_done;
+		info->status.ampdu_len = ba_resp->txed;
+
+	} else {
+		info->status.ampdu_ack_len = successes;
+		info->status.ampdu_len = agg->frame_count;
+	}
 	iwlagn_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
 
 	IWL_DEBUG_TX_REPLY(priv, "Bitmap %llx\n", (unsigned long long)bitmap);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 424801a..31c29a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2022,6 +2022,9 @@ struct iwl_compressed_ba_resp {
 	__le64 bitmap;
 	__le16 scd_flow;
 	__le16 scd_ssn;
+	/* following only for 5000 series and up */
+	u8 txed;	/* number of frames sent */
+	u8 txed_2_done; /* number of frames acked */
 } __packed;
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ee8cf24..98b79f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -291,7 +291,9 @@ struct iwl_mod_params {
  * @chain_noise_calib_by_driver: driver has the capability to perform
  *	chain noise calibration operation
  * @shadow_reg_enable: HW shadhow register bit
-*/
+ * @no_agg_framecnt_info: uCode do not provide aggregation frame count
+ *	information
+ */
 struct iwl_base_params {
 	int eeprom_size;
 	int num_of_queues;	/* def: HW dependent */
@@ -322,6 +324,7 @@ struct iwl_base_params {
 	const bool sensitivity_calib_by_driver;
 	const bool chain_noise_calib_by_driver;
 	const bool shadow_reg_enable;
+	const bool no_agg_framecnt_info;
 };
 /*
  * @advanced_bt_coexist: support advanced bt coexist
-- 
1.7.0.4

