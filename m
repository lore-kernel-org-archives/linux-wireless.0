Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33616 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbYAJRY1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 12:24:27 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [RFC PATCH 01/10] mac80211: A-MPDU Tx add session's and low level driver's API
Date: Thu, 10 Jan 2008 19:22:13 +0200
Message-Id: <11999857491583-git-send-email-ron.rindjunsky@intel.com> (sfid-20080110_172457_956793_469E7134)
In-Reply-To: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
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

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/net/mac80211.h       |   62 +++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_sta.c |    4 +-
 2 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3b7bfc6..3151fcf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -943,10 +943,14 @@ enum ieee80211_erp_change_flags {
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
@@ -1130,7 +1134,7 @@ struct ieee80211_ops {
 	int (*conf_ht)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    enum ieee80211_ampdu_mlme_action action,
-			    const u8 *ra, u16 tid, u16 ssn);
+			    u8 *addr, u16 tid, u16 *ssn);
 };
 
 /**
@@ -1513,4 +1517,60 @@ void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
 						struct ieee80211_vif *vif),
 					 void *data);
 
+/**
+ * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @ra: destination address of the BA session recipient
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
+ * ieee80211_start_tx_ba_cb/_irqsafe - low level driver is ready to aggregate.
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @ra: destination address of the BA session recipient.
+ * @tid: the TID to BA on.
+ *
+ * This function must be called by low level driver once it has
+ * finished with preparations for the BA session.
+ * Two versions of the function are provided for low-deriver's convinience,
+ * a regular and irqsafe version.
+ */
+void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid);
+void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, u8 *ra,
+				      u16 tid);
+/**
+ * ieee80211_stop_tx_ba_session - Stop a Block Ack session.
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @ra: destination address of the BA session recipient
+ * @tid: the TID to stop BA.
+ * @initiator: if indicates initiator DELBA frame will be sent.
+ * @return: error if no sta with matching da found, success otherwise
+ *
+ * Although mac80211/low level driver/user space application can estimate
+ * the need to stop aggregation on a certain RA/TID, the session level
+ * will be managed by the mac80211.
+ */
+int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw, u8 *ra,
+				 u16 tid, u8 initiator);
+
+/**
+ * ieee80211_stop_BA_cb - low level driver is ready to stop aggregation.
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @ra: destination address of the BA session recipient.
+ * @tid: the desired TID to BA on.
+ *
+ * This function must be called by low level driver once it has
+ * finished with preparations for the BA session tear down.
+ * Two versions of the function are provided for low-deriver's convinience,
+ * a regular and an irqsafe version.
+ */
+void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid);
+void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, u8 *ra, u16 tid);
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index b1e7d17..ec62938 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1132,7 +1132,7 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_START,
-					       sta->addr, tid, start_seq_num);
+					       sta->addr, tid, &start_seq_num);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx A-MPDU on tid %d result %d", tid, ret);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
@@ -1237,7 +1237,7 @@ void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *ra, u16 tid,
 	BUG_ON(!local->ops->ampdu_action);
 
 	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
-					ra, tid, EINVAL);
+					ra, tid, NULL);
 	if (ret)
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggergation for tid %d\n", tid);
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

