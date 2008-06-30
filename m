Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19551 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbYF3J1K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 12/33] iwlwifi: move rx aggregation functions to iwl-rx.c
Date: Mon, 30 Jun 2008 17:23:12 +0800
Message-Id: <1214817813-17639-13-git-send-email-yi.zhu@intel.com> (sfid-20080630_113814_518676_E7CFC79C)
In-Reply-To: <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch moves Rx aggregation functions into iwl-rx.c

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   47 +-----------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-rx.c   |   43 ++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 57a853d..311b37c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2074,49 +2074,6 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	return 0;
 }
 
-static int iwl4965_rx_agg_start(struct iwl_priv *priv,
-				const u8 *addr, int tid, u16 ssn)
-{
-	unsigned long flags;
-	int sta_id;
-
-	sta_id = iwl_find_station(priv, addr);
-	if (sta_id == IWL_INVALID_STATION)
-		return -ENXIO;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags_msk = 0;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_ADDBA_TID_MSK;
-	priv->stations[sta_id].sta.add_immediate_ba_tid = (u8)tid;
-	priv->stations[sta_id].sta.add_immediate_ba_ssn = cpu_to_le16(ssn);
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
-					CMD_ASYNC);
-}
-
-static int iwl4965_rx_agg_stop(struct iwl_priv *priv,
-			       const u8 *addr, int tid)
-{
-	unsigned long flags;
-	int sta_id;
-
-	sta_id = iwl_find_station(priv, addr);
-	if (sta_id == IWL_INVALID_STATION)
-		return -ENXIO;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags_msk = 0;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_DELBA_TID_MSK;
-	priv->stations[sta_id].sta.remove_immediate_ba_tid = (u8)tid;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
-					CMD_ASYNC);
-}
-
 int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 			     enum ieee80211_ampdu_mlme_action action,
 			     const u8 *addr, u16 tid, u16 *ssn)
@@ -2130,10 +2087,10 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		IWL_DEBUG_HT("start Rx\n");
-		return iwl4965_rx_agg_start(priv, addr, tid, *ssn);
+		return iwl_rx_agg_start(priv, addr, tid, *ssn);
 	case IEEE80211_AMPDU_RX_STOP:
 		IWL_DEBUG_HT("stop Rx\n");
-		return iwl4965_rx_agg_stop(priv, addr, tid);
+		return iwl_rx_agg_stop(priv, addr, tid);
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT("start Tx\n");
 		return iwl_tx_agg_start(priv, addr, tid, ssn);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 06c272c..7814a48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -211,6 +211,8 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 void iwl_rx_replenish(struct iwl_priv *priv);
 int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
+int iwl_rx_agg_start(struct iwl_priv *priv, const u8 *addr, int tid, u16 ssn);
+int iwl_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid);
 /* FIXME: remove when TX is moved to iwl core */
 int iwl_rx_queue_restock(struct iwl_priv *priv);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 9c346cc..bfe1ad2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -468,6 +468,49 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_rx_missed_beacon_notif);
 
+int iwl_rx_agg_start(struct iwl_priv *priv, const u8 *addr, int tid, u16 ssn)
+{
+	unsigned long flags;
+	int sta_id;
+
+	sta_id = iwl_find_station(priv, addr);
+	if (sta_id == IWL_INVALID_STATION)
+		return -ENXIO;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags_msk = 0;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_ADDBA_TID_MSK;
+	priv->stations[sta_id].sta.add_immediate_ba_tid = (u8)tid;
+	priv->stations[sta_id].sta.add_immediate_ba_ssn = cpu_to_le16(ssn);
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
+					CMD_ASYNC);
+}
+EXPORT_SYMBOL(iwl_rx_agg_start);
+
+int iwl_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid)
+{
+	unsigned long flags;
+	int sta_id;
+
+	sta_id = iwl_find_station(priv, addr);
+	if (sta_id == IWL_INVALID_STATION)
+		return -ENXIO;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags_msk = 0;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_DELBA_TID_MSK;
+	priv->stations[sta_id].sta.remove_immediate_ba_tid = (u8)tid;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
+					CMD_ASYNC);
+}
+EXPORT_SYMBOL(iwl_rx_agg_stop);
+
 
 /* Calculate noise level, based on measurements during network silence just
  *   before arriving beacon.  This measurement can be done only if we know
-- 
1.5.3.6

