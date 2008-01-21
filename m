Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757982AbYAULwX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 06:52:23 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 01/12] mac80211: A-MPDU Tx add session's and low level driver's API
Date: Mon, 21 Jan 2008 13:52:01 +0200
Message-Id: <12009163391152-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115237_868897_926DBC00)
In-Reply-To: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the API for 3 stages in A-MPDU Tx session flow:
- request mac80211 to start/stop A-MPDU Tx session for specific TID. such a
  request should be issued by a load aware element, either mac80211 itself
  or external element.
- requests by mac80211 to low-level driver to start/stop Tx aggregation.
  notice that low level driver responds now with Starting Sequence Number.
- async feedback by low-level to mac80211 to inform that HW is ready for
  next A-MPDU Tx state.
Changes in API to Rx A-MPDU were also made, reflected in iwlwifi changes as
well.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.h |    2 +-
 include/net/mac80211.h                  |   85 ++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_sta.c            |    4 +-
 4 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 04db34b..36ef618 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4719,7 +4719,7 @@ static void iwl4965_sta_modify_del_ba_tid(struct iwl4965_priv *priv,
 
 int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 			     enum ieee80211_ampdu_mlme_action action,
-			     const u8 *addr, u16 tid, u16 ssn)
+			     u8 *addr, u16 tid, u16 *ssn)
 {
 	struct iwl4965_priv *priv = hw->priv;
 	int sta_id;
@@ -4731,7 +4731,7 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		IWL_DEBUG_HT("start Rx\n");
-		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, ssn);
+		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, *ssn);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
 		IWL_DEBUG_HT("stop Rx\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 78bc148..615b8fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -778,7 +778,7 @@ extern void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index,
 				struct ieee80211_ht_info *sta_ht_inf);
 extern int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 				    enum ieee80211_ampdu_mlme_action action,
-				    const u8 *addr, u16 tid, u16 ssn);
+				    u8 *addr, u16 tid, u16 *ssn);
 #ifdef CONFIG_IWL4965_HT_AGG
 extern int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da,
 				   u16 tid, u16 *start_seq_num);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9083baf..2ba6e73 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -967,10 +967,14 @@ enum ieee80211_filter_flags {
  * &struct ieee80211_ops to indicate which action is needed.
  * @IEEE80211_AMPDU_RX_START: start Rx aggregation
  * @IEEE80211_AMPDU_RX_STOP: stop Rx aggregation
+ * @IEEE80211_AMPDU_TX_START: start Tx aggregation
+ * @IEEE80211_AMPDU_TX_STOP: stop Tx aggregation
  */
 enum ieee80211_ampdu_mlme_action {
 	IEEE80211_AMPDU_RX_START,
 	IEEE80211_AMPDU_RX_STOP,
+	IEEE80211_AMPDU_TX_START,
+	IEEE80211_AMPDU_TX_STOP,
 };
 
 /**
@@ -1111,7 +1115,8 @@ enum ieee80211_ampdu_mlme_action {
  * 	The RA/TID combination determines the destination and TID we want
  * 	the ampdu action to be performed for. The action is defined through
  * 	ieee80211_ampdu_mlme_action. Starting sequence number (@ssn)
- * 	is the first frame we expect to perform the action on.
+ * 	is the first frame we expect to perform the action on. notice
+ * 	that TX/RX_STOP can pass NULL for this parameter.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
@@ -1162,7 +1167,7 @@ struct ieee80211_ops {
 	int (*conf_ht)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    enum ieee80211_ampdu_mlme_action action,
-			    const u8 *ra, u16 tid, u16 ssn);
+			    u8 *addr, u16 tid, u16 *ssn);
 };
 
 /**
@@ -1574,4 +1579,80 @@ void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
 						struct ieee80211_vif *vif),
 					 void *data);
 
+/**
+ * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @ra: receiver address of the BA session recipient
+ * @tid: the TID to BA on.
+ * @return: success if addBA request was sent, failure otherwise
+ *
+ * Although mac80211/low level driver/user space application can estimate
+ * the need to start aggregation on a certain RA/TID, the session level
+ * will be managed by the mac80211.
+ */
+int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid);
+
+/**
+ * ieee80211_start_tx_ba_cb - low level driver ready to aggregate.
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @ra: receiver address of the BA session recipient.
+ * @tid: the TID to BA on.
+ *
+ * This function must be called by low level driver once it has
+ * finished with preparations for the BA session.
+ */
+void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid);
+
+/**
+ * ieee80211_start_tx_ba_cb_irqsafe - low level driver ready to aggregate.
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @ra: receiver address of the BA session recipient.
+ * @tid: the TID to BA on.
+ *
+ * This function must be called by low level driver once it has
+ * finished with preparations for the BA session.
+ * This version of the function is irq safe.
+ */
+void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, u8 *ra,
+				      u16 tid);
+
+/**
+ * ieee80211_stop_tx_ba_session - Stop a Block Ack session.
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @ra: receiver address of the BA session recipient
+ * @tid: the TID to stop BA.
+ * @initiator: if indicates initiator DELBA frame will be sent.
+ * @return: error if no sta with matching da found, success otherwise
+ *
+ * Although mac80211/low level driver/user space application can estimate
+ * the need to stop aggregation on a certain RA/TID, the session level
+ * will be managed by the mac80211.
+ */
+int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
+				 u8 *ra, u16 tid,
+				 enum ieee80211_back_parties initiator);
+
+/**
+ * ieee80211_stop_tx_ba_cb - low level driver ready to stop aggregate.
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @ra: receiver address of the BA session recipient.
+ * @tid: the desired TID to BA on.
+ *
+ * This function must be called by low level driver once it has
+ * finished with preparations for the BA session tear down.
+ */
+void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid);
+
+/**
+ * ieee80211_stop_tx_ba_cb_irqsafe - low level driver ready to stop aggregate.
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @ra: receiver address of the BA session recipient.
+ * @tid: the desired TID to BA on.
+ *
+ * This function must be called by low level driver once it has
+ * finished with preparations for the BA session tear down.
+ * This version of the function is irq safe.
+ */
+void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, u8 *ra, u16 tid);
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 2019b4f..514c7f2 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1126,7 +1126,7 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_START,
-					       sta->addr, tid, start_seq_num);
+					       sta->addr, tid, &start_seq_num);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx A-MPDU on tid %d result %d", tid, ret);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
@@ -1228,7 +1228,7 @@ void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *ra, u16 tid,
 	BUG_ON(!local->ops->ampdu_action);
 
 	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
-					ra, tid, EINVAL);
+					ra, tid, NULL);
 	if (ret)
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggergation for tid %d\n", tid);
-- 
1.5.3.7

