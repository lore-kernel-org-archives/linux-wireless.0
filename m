Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13405 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759815AbXG3C7e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 22:59:34 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/8] iwlwifi: avoid ucode assert for LQ cmd call
Date: Mon, 30 Jul 2007 10:56:59 +0800
Message-Id: <11857642343783-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11857642261522-git-send-email-yi.zhu@intel.com>
References: <11857642261522-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

This patch make sure we don't call any Link Quality commands until
the station is added, otherwise ucode will assert.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965-rs.c |   61 +++++++++++++++---------------------
 drivers/net/wireless/iwl-4965.h    |    1 +
 drivers/net/wireless/iwl-base.c    |    1 +
 3 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965-rs.c b/drivers/net/wireless/iwl-4965-rs.c
index aad244e..6f3d4ab 100644
--- a/drivers/net/wireless/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwl-4965-rs.c
@@ -110,7 +110,6 @@ struct iwl_rate_scale_priv {
 	u8 is_green;
 	u8 is_dup;
 	u8 phymode;
-	u8 ready;
 	u8 ibss_sta_added;
 	u16 active_rate;
 	u16 active_siso_rate;
@@ -183,7 +182,7 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	int i;
 #endif
-	int rc = 0;
+	int rc = -1;
 
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_LINK_QUALITY_CMD,
@@ -194,7 +193,7 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 
 	if ((lq->sta_id == 0xFF) &&
 	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
-		return -1;
+		return rc;
 
 	if (lq->sta_id == 0xFF)
 		lq->sta_id = IWL_AP_ID;
@@ -212,7 +211,8 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 
 	if (flags & CMD_ASYNC)
 		cmd.meta.u.callback = iwl_lq_sync_callback;
-	rc = iwl_send_cmd(priv, &cmd);
+	if (iwl_is_associated(priv) && priv->lq_mngr.lq_ready)
+		rc = iwl_send_cmd(priv, &cmd);
 
 	return rc;
 }
@@ -635,6 +635,9 @@ static void rs_tx_status(void *priv_rate,
 
 	lq = (struct iwl_rate_scale_priv *)sta->rate_ctrl_priv;
 
+	if (!priv->lq_mngr.lq_ready)
+		return;
+
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) && !lq->ibss_sta_added)
 		return;
 
@@ -1374,11 +1377,11 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	if (!sta || !sta->rate_ctrl_priv)
 		return;
 
-	lq_data = (struct iwl_rate_scale_priv *)sta->rate_ctrl_priv;
-	if (!lq_data->ready) {
+	if (!priv->lq_mngr.lq_ready) {
 		IWL_DEBUG_RATE("still rate scaling not ready\n");
 		return;
 	}
+	lq_data = (struct iwl_rate_scale_priv *)sta->rate_ctrl_priv;
 
 	if (!lq_data->search_better_tbl)
 		active_tbl = lq_data->active_tbl;
@@ -1449,6 +1452,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 					   &(lq_data->lq), sta);
 			if (!rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC))
 				lq_data->commit_lq = 0;
+			else
+				lq_data->commit_lq = 1;
 		}
 		goto out;
 
@@ -1577,6 +1582,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		rs_fill_link_cmd(lq_data, &mcs_rate, &(lq_data->lq), sta);
 		if (!rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC))
 			lq_data->commit_lq = 0;
+		else
+			lq_data->commit_lq = 1;
 	}
 	rs_stay_in_table(lq_data);
 	if (!update_lq
@@ -1603,6 +1610,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 					   &(lq_data->lq), sta);
 			if (!rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC))
 				lq_data->commit_lq = 0;
+			else
+				lq_data->commit_lq = 1;
 		}
 		tbl1 = &(lq_data->lq_info[lq_data->active_tbl]);
 		if (is_legacy(tbl1->lq_type) &&
@@ -1650,8 +1659,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 
 static void rs_initialize_lq(struct iwl_priv *priv,
-			     struct sta_info *sta,
-			     int flg)
+			     struct sta_info *sta)
 {
 	int i;
 	struct iwl_rate_scale_priv *lq;
@@ -1769,18 +1777,18 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 			lq->lq.sta_id = sta_id;
 			lq->lq.rate_scale_table[0].rate_n_flags = 0;
 			lq->ibss_sta_added = 1;
-			lq->ready = 1;
 			lq->commit_lq = 1;
-			rs_initialize_lq(priv, sta, CMD_ASYNC);
+			rs_initialize_lq(priv, sta);
 		}
 		if (!lq->ibss_sta_added)
 			goto done;
 	}
 
 
-	if (lq->commit_lq && lq->ready) {
+	if (lq->commit_lq) {
 		lq->commit_lq = 0;
-		rs_send_lq_cmd(priv, &lq->lq, CMD_ASYNC);
+		if (rs_send_lq_cmd(priv, &lq->lq, CMD_ASYNC))
+			lq->commit_lq = 1;
 	}
 
  done:
@@ -1855,7 +1863,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 			crl->lq.sta_id = sta_id;
 			crl->lq.rate_scale_table[0].rate_n_flags = 0;
 		}
-		crl->ready = 1;
+		priv->lq_mngr.lq_ready = 1;
 	}
 
 	for (i = 0; i < mode->num_rates; i++) {
@@ -1891,13 +1899,8 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	crl->active_mimo_rate = crl->active_mimo_rate << IWL_FIRST_OFDM_RATE;
 #endif /*CONFIG_IWLWIFI_HT*/
 
-	if (priv && (priv->iw_mode != IEEE80211_IF_TYPE_IBSS)) {
-		mutex_lock(&priv->mutex);
-		rs_initialize_lq(priv, sta, 0);
-		mutex_unlock(&priv->mutex);
-	} else
-		rs_initialize_lq(priv, sta, CMD_ASYNC);
-
+	if (priv)
+		rs_initialize_lq(priv, sta);
 }
 
 static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
@@ -2012,6 +2015,7 @@ static void rs_clear(void *priv_rate)
 
 	IWL_DEBUG_RATE("NOP\n");
 
+	priv->lq_mngr.lq_ready = 0;
 #ifdef CONFIG_IWLWIFI_HT
 #ifdef CONFIG_IWLWIFI_HT_AGG
 	if (priv->lq_mngr.agg_ctrl.granted_ba)
@@ -2133,24 +2137,9 @@ int iwl_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 
 void iwl_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
 	struct iwl_priv *priv = hw->priv;
-	struct iwl_rate_scale_priv *rs_priv;
-	struct sta_info *sta;
 
-	sta = sta_info_get(local, priv->stations[sta_id].sta.sta.addr);
-	if (!sta || !sta->rate_ctrl_priv) {
-		if (sta) {
-			sta_info_put(sta);
-			IWL_DEBUG_RATE("leave - no private rate data!\n");
-		} else
-			IWL_DEBUG_RATE("leave - no station!\n");
-		return;
-	}
-
-	rs_priv = (void *)sta->rate_ctrl_priv;
-	rs_priv->ready = 1;
-	sta_info_put(sta);
+	priv->lq_mngr.lq_ready = 1;
 }
 
 void iwl_rate_control_register(void)
diff --git a/drivers/net/wireless/iwl-4965.h b/drivers/net/wireless/iwl-4965.h
index 9e4a663..8665929 100644
--- a/drivers/net/wireless/iwl-4965.h
+++ b/drivers/net/wireless/iwl-4965.h
@@ -196,6 +196,7 @@ struct iwl_lq_mngr {
 	unsigned long stamp_last;
 	u32 flush_time;
 	u32 tx_packets;
+	u8 lq_ready;
 };
 
 
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 87ad5d8..57b8195 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -7878,6 +7878,7 @@ static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211("enter\n");
 
 #if IWL == 4965
+	priv->lq_mngr.lq_ready = 0;
 #ifdef CONFIG_IWLWIFI_HT
 	spin_lock_irqsave(&priv->lock, flags);
 	memset(&priv->current_assoc_ht, 0, sizeof(struct sta_ht_info));
-- 
1.5.2
