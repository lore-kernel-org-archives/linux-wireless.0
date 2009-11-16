Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZKPLIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 06:08:44 -0500
Message-Id: <20091116110720.465457416@sipsolutions.net>
Date: Mon, 16 Nov 2009 12:00:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 2/4] mac80211: convert aggregation to operate on vifs/stas
References: <20091116110036.010062226@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The entire aggregation code currently operates on the
hw pointer and station addresses, but that needs to
change to make stations purely per-vif; As one step
preparing for that make the aggregation code callable
with the station, or by the combination of virtual
interface and station address.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ar9170/main.c    |    5 -
 drivers/net/wireless/ath/ath9k/main.c     |    5 -
 drivers/net/wireless/ath/ath9k/rc.c       |    2 
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    2 
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    1 
 drivers/net/wireless/iwlwifi/iwl-tx.c     |    8 +-
 include/net/mac80211.h                    |   28 ++++----
 net/mac80211/agg-rx.c                     |    6 +
 net/mac80211/agg-tx.c                     |   96 +++++++++++-------------------
 net/mac80211/driver-ops.h                 |    5 -
 net/mac80211/driver-trace.h               |    9 +-
 net/mac80211/ht.c                         |    3 
 net/mac80211/ieee80211_i.h                |    3 
 net/mac80211/main.c                       |    8 +-
 14 files changed, 84 insertions(+), 97 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-11-13 09:33:45.000000000 +0100
@@ -1519,6 +1519,7 @@ struct ieee80211_ops {
 	void (*reset_tsf)(struct ieee80211_hw *hw);
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
 	int (*ampdu_action)(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
 			    enum ieee80211_ampdu_mlme_action action,
 			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 
@@ -2040,8 +2041,7 @@ void ieee80211_queue_delayed_work(struct
 
 /**
  * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
- * @hw: pointer as obtained from ieee80211_alloc_hw().
- * @ra: receiver address of the BA session recipient
+ * @sta: the station for which to start a BA session
  * @tid: the TID to BA on.
  *
  * Return: success if addBA request was sent, failure otherwise
@@ -2050,22 +2050,22 @@ void ieee80211_queue_delayed_work(struct
  * the need to start aggregation on a certain RA/TID, the session level
  * will be managed by the mac80211.
  */
-int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid);
+int ieee80211_start_tx_ba_session(struct ieee80211_sta *sta, u16 tid);
 
 /**
  * ieee80211_start_tx_ba_cb - low level driver ready to aggregate.
- * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf
  * @ra: receiver address of the BA session recipient.
  * @tid: the TID to BA on.
  *
  * This function must be called by low level driver once it has
  * finished with preparations for the BA session.
  */
-void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid);
+void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
 
 /**
  * ieee80211_start_tx_ba_cb_irqsafe - low level driver ready to aggregate.
- * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf
  * @ra: receiver address of the BA session recipient.
  * @tid: the TID to BA on.
  *
@@ -2073,13 +2073,12 @@ void ieee80211_start_tx_ba_cb(struct iee
  * finished with preparations for the BA session.
  * This version of the function is IRQ-safe.
  */
-void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
+void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif, const u8 *ra,
 				      u16 tid);
 
 /**
  * ieee80211_stop_tx_ba_session - Stop a Block Ack session.
- * @hw: pointer as obtained from ieee80211_alloc_hw().
- * @ra: receiver address of the BA session recipient
+ * @sta: the station whose BA session to stop
  * @tid: the TID to stop BA.
  * @initiator: if indicates initiator DELBA frame will be sent.
  *
@@ -2089,24 +2088,23 @@ void ieee80211_start_tx_ba_cb_irqsafe(st
  * the need to stop aggregation on a certain RA/TID, the session level
  * will be managed by the mac80211.
  */
-int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
-				 u8 *ra, u16 tid,
+int ieee80211_stop_tx_ba_session(struct ieee80211_sta *sta, u16 tid,
 				 enum ieee80211_back_parties initiator);
 
 /**
  * ieee80211_stop_tx_ba_cb - low level driver ready to stop aggregate.
- * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf
  * @ra: receiver address of the BA session recipient.
  * @tid: the desired TID to BA on.
  *
  * This function must be called by low level driver once it has
  * finished with preparations for the BA session tear down.
  */
-void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid);
+void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
 
 /**
  * ieee80211_stop_tx_ba_cb_irqsafe - low level driver ready to stop aggregate.
- * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf
  * @ra: receiver address of the BA session recipient.
  * @tid: the desired TID to BA on.
  *
@@ -2114,7 +2112,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
  * finished with preparations for the BA session tear down.
  * This version of the function is IRQ-safe.
  */
-void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
+void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif, const u8 *ra,
 				     u16 tid);
 
 /**
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-11-13 09:33:45.000000000 +0100
@@ -138,7 +138,8 @@ static int ___ieee80211_stop_tx_ba_sessi
 	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
 
-	ret = drv_ampdu_action(local, IEEE80211_AMPDU_TX_STOP,
+	ret = drv_ampdu_action(local, &sta->sdata->vif,
+			       IEEE80211_AMPDU_TX_STOP,
 			       &sta->sta, tid, NULL);
 
 	/* HW shall not deny going back to legacy */
@@ -196,11 +197,11 @@ static inline int ieee80211_ac_from_tid(
 	return ieee802_1d_to_ac[tid & 7];
 }
 
-int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
+int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 	u8 *state;
 	int ret = 0;
 	u16 start_seq_num;
@@ -208,52 +209,37 @@ int ieee80211_start_tx_ba_session(struct
 	if (WARN_ON(!local->ops->ampdu_action))
 		return -EINVAL;
 
-	if ((tid >= STA_TID_NUM) || !(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION))
+	if ((tid >= STA_TID_NUM) ||
+	    !(local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION))
 		return -EINVAL;
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Open BA session requested for %pM tid %u\n",
-	       ra, tid);
+	       pubsta->addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	rcu_read_lock();
-
-	sta = sta_info_get(local, ra);
-	if (!sta) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Could not find the station\n");
-#endif
-		ret = -ENOENT;
-		goto unlock;
-	}
-
 	/*
 	 * The aggregation code is not prepared to handle
 	 * anything but STA/AP due to the BSSID handling.
 	 * IBSS could work in the code but isn't supported
 	 * by drivers or the standard.
 	 */
-	if (sta->sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sta->sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-	    sta->sdata->vif.type != NL80211_IFTYPE_AP) {
-		ret = -EINVAL;
-		goto unlock;
-	}
+	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+	    sdata->vif.type != NL80211_IFTYPE_AP)
+		return -EINVAL;
 
 	if (test_sta_flags(sta, WLAN_STA_SUSPEND)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Suspend in progress. "
 		       "Denying BA session request\n");
 #endif
-		ret = -EINVAL;
-		goto unlock;
+		return -EINVAL;
 	}
 
 	spin_lock_bh(&sta->lock);
 	spin_lock(&local->ampdu_lock);
 
-	sdata = sta->sdata;
-
 	/* we have tried too many times, receiver does not want A-MPDU */
 	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
 		ret = -EBUSY;
@@ -310,8 +296,9 @@ int ieee80211_start_tx_ba_session(struct
 
 	start_seq_num = sta->tid_seq[tid];
 
-	ret = drv_ampdu_action(local, IEEE80211_AMPDU_TX_START,
-			       &sta->sta, tid, &start_seq_num);
+	ret = drv_ampdu_action(local, &sdata->vif,
+			       IEEE80211_AMPDU_TX_START,
+			       pubsta, tid, &start_seq_num);
 
 	if (ret) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -336,7 +323,7 @@ int ieee80211_start_tx_ba_session(struct
 			sta->ampdu_mlme.dialog_token_allocator;
 	sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
 
-	ieee80211_send_addba_request(sta->sdata, ra, tid,
+	ieee80211_send_addba_request(sdata, pubsta->addr, tid,
 			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
 			 sta->ampdu_mlme.tid_tx[tid]->ssn,
 			 0x40, 5000);
@@ -348,7 +335,7 @@ int ieee80211_start_tx_ba_session(struct
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
 #endif
-	goto unlock;
+	return 0;
 
  err_free:
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
@@ -360,8 +347,6 @@ int ieee80211_start_tx_ba_session(struct
  err_unlock_sta:
 	spin_unlock(&local->ampdu_lock);
 	spin_unlock_bh(&sta->lock);
- unlock:
-	rcu_read_unlock();
 	return ret;
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
@@ -428,13 +413,15 @@ static void ieee80211_agg_tx_operational
 	ieee80211_agg_splice_finish(local, sta, tid);
 	spin_unlock(&local->ampdu_lock);
 
-	drv_ampdu_action(local, IEEE80211_AMPDU_TX_OPERATIONAL,
+	drv_ampdu_action(local, &sta->sdata->vif,
+			 IEEE80211_AMPDU_TX_OPERATIONAL,
 			 &sta->sta, tid, NULL);
 }
 
-void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid)
+void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u8 *state;
 
@@ -483,10 +470,11 @@ void ieee80211_start_tx_ba_cb(struct iee
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb);
 
-void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
+void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 				      const u8 *ra, u16 tid)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_ra_tid *ra_tid;
 	struct sk_buff *skb = dev_alloc_skb(0);
 
@@ -535,13 +523,12 @@ int __ieee80211_stop_tx_ba_session(struc
 	return ret;
 }
 
-int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
-				 u8 *ra, u16 tid,
+int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 				 enum ieee80211_back_parties initiator)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct sta_info *sta;
-	int ret = 0;
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 
 	if (WARN_ON(!local->ops->ampdu_action))
 		return -EINVAL;
@@ -549,22 +536,14 @@ int ieee80211_stop_tx_ba_session(struct 
 	if (tid >= STA_TID_NUM)
 		return -EINVAL;
 
-	rcu_read_lock();
-	sta = sta_info_get(local, ra);
-	if (!sta) {
-		rcu_read_unlock();
-		return -ENOENT;
-	}
-
-	ret = __ieee80211_stop_tx_ba_session(sta, tid, initiator);
-	rcu_read_unlock();
-	return ret;
+	return __ieee80211_stop_tx_ba_session(sta, tid, initiator);
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
 
-void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
+void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u8 *state;
 
@@ -627,10 +606,11 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb);
 
-void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
+void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 				     const u8 *ra, u16 tid)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_ra_tid *ra_tid;
 	struct sk_buff *skb = dev_alloc_skb(0);
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-13 09:33:45.000000000 +0100
@@ -770,8 +770,9 @@ IEEE80211_DEV_TO_SUB_IF(struct net_devic
 	return netdev_priv(dev);
 }
 
-/* this struct represents 802.11n's RA/TID combination */
+/* this struct represents 802.11n's RA/TID combination along with our vif */
 struct ieee80211_ra_tid {
+	struct ieee80211_vif *vif;
 	u8 ra[ETH_ALEN];
 	u16 tid;
 };
--- wireless-testing.orig/net/mac80211/main.c	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-11-13 09:33:45.000000000 +0100
@@ -296,14 +296,14 @@ static void ieee80211_tasklet_handler(un
 			break;
 		case IEEE80211_DELBA_MSG:
 			ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-			ieee80211_stop_tx_ba_cb(local_to_hw(local),
-						ra_tid->ra, ra_tid->tid);
+			ieee80211_stop_tx_ba_cb(ra_tid->vif, ra_tid->ra,
+						ra_tid->tid);
 			dev_kfree_skb(skb);
 			break;
 		case IEEE80211_ADDBA_MSG:
 			ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-			ieee80211_start_tx_ba_cb(local_to_hw(local),
-						 ra_tid->ra, ra_tid->tid);
+			ieee80211_start_tx_ba_cb(ra_tid->vif, ra_tid->ra,
+						 ra_tid->tid);
 			dev_kfree_skb(skb);
 			break ;
 		default:
--- wireless-testing.orig/net/mac80211/ht.c	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2009-11-13 09:33:45.000000000 +0100
@@ -141,7 +141,6 @@ void ieee80211_process_delba(struct ieee
 			     struct sta_info *sta,
 			     struct ieee80211_mgmt *mgmt, size_t len)
 {
-	struct ieee80211_local *local = sdata->local;
 	u16 tid, params;
 	u16 initiator;
 
@@ -164,7 +163,7 @@ void ieee80211_process_delba(struct ieee
 		sta->ampdu_mlme.tid_state_tx[tid] =
 				HT_AGG_STATE_OPERATIONAL;
 		spin_unlock_bh(&sta->lock);
-		ieee80211_stop_tx_ba_session(&local->hw, sta->sta.addr, tid,
+		ieee80211_stop_tx_ba_session(&sta->sta, tid,
 					     WLAN_BACK_RECIPIENT);
 	}
 }
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2009-11-13 09:33:45.000000000 +0100
@@ -2441,6 +2441,7 @@ static int ar9170_conf_tx(struct ieee802
 }
 
 static int ar9170_ampdu_action(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
 			       enum ieee80211_ampdu_mlme_action action,
 			       struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
@@ -2470,7 +2471,7 @@ static int ar9170_ampdu_action(struct ie
 		tid_info->state = AR9170_TID_STATE_PROGRESS;
 		tid_info->active = false;
 		spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
-		ieee80211_start_tx_ba_cb_irqsafe(hw, sta->addr, tid);
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 
 	case IEEE80211_AMPDU_TX_STOP:
@@ -2480,7 +2481,7 @@ static int ar9170_ampdu_action(struct ie
 		tid_info->active = false;
 		skb_queue_purge(&tid_info->queue);
 		spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
-		ieee80211_stop_tx_ba_cb_irqsafe(hw, sta->addr, tid);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2009-11-13 09:33:45.000000000 +0100
@@ -301,7 +301,7 @@ static void rs_tl_turn_on_agg_for_tid(st
 	if (rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
 		IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
 				sta->addr, tid);
-		ieee80211_start_tx_ba_session(priv->hw, sta->addr, tid);
+		ieee80211_start_tx_ba_session(sta, tid);
 	}
 }
 
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-tx.c	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-tx.c	2009-11-13 09:33:45.000000000 +0100
@@ -1264,7 +1264,7 @@ int iwl_tx_agg_start(struct iwl_priv *pr
 	if (tid_data->tfds_in_queue == 0) {
 		IWL_DEBUG_HT(priv, "HW queue is empty\n");
 		tid_data->agg.state = IWL_AGG_ON;
-		ieee80211_start_tx_ba_cb_irqsafe(priv->hw, ra, tid);
+		ieee80211_start_tx_ba_cb_irqsafe(priv->vif, ra, tid);
 	} else {
 		IWL_DEBUG_HT(priv, "HW queue is NOT empty: %d packets in HW queue\n",
 			     tid_data->tfds_in_queue);
@@ -1329,7 +1329,7 @@ int iwl_tx_agg_stop(struct iwl_priv *pri
 	if (ret)
 		return ret;
 
-	ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, ra, tid);
+	ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, ra, tid);
 
 	return 0;
 }
@@ -1353,7 +1353,7 @@ int iwl_txq_check_empty(struct iwl_priv 
 			priv->cfg->ops->lib->txq_agg_disable(priv, txq_id,
 							     ssn, tx_fifo);
 			tid_data->agg.state = IWL_AGG_OFF;
-			ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, addr, tid);
+			ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, addr, tid);
 		}
 		break;
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -1361,7 +1361,7 @@ int iwl_txq_check_empty(struct iwl_priv 
 		if (tid_data->tfds_in_queue == 0) {
 			IWL_DEBUG_HT(priv, "HW queue empty: continue ADDBA flow\n");
 			tid_data->agg.state = IWL_AGG_ON;
-			ieee80211_start_tx_ba_cb_irqsafe(priv->hw, addr, tid);
+			ieee80211_start_tx_ba_cb_irqsafe(priv->vif, addr, tid);
 		}
 		break;
 	}
--- wireless-testing.orig/net/mac80211/driver-ops.h	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2009-11-13 09:33:45.000000000 +0100
@@ -239,15 +239,16 @@ static inline int drv_tx_last_beacon(str
 }
 
 static inline int drv_ampdu_action(struct ieee80211_local *local,
+				   struct ieee80211_vif *vif,
 				   enum ieee80211_ampdu_mlme_action action,
 				   struct ieee80211_sta *sta, u16 tid,
 				   u16 *ssn)
 {
 	int ret = -EOPNOTSUPP;
 	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(&local->hw, action,
+		ret = local->ops->ampdu_action(&local->hw, vif, action,
 					       sta, tid, ssn);
-	trace_drv_ampdu_action(local, action, sta, tid, ssn, ret);
+	trace_drv_ampdu_action(local, vif, action, sta, tid, ssn, ret);
 	return ret;
 }
 
--- wireless-testing.orig/net/mac80211/driver-trace.h	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2009-11-13 09:33:45.000000000 +0100
@@ -634,11 +634,12 @@ TRACE_EVENT(drv_tx_last_beacon,
 
 TRACE_EVENT(drv_ampdu_action,
 	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_vif *vif,
 		 enum ieee80211_ampdu_mlme_action action,
 		 struct ieee80211_sta *sta, u16 tid,
 		 u16 *ssn, int ret),
 
-	TP_ARGS(local, action, sta, tid, ssn, ret),
+	TP_ARGS(local, vif, action, sta, tid, ssn, ret),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -647,10 +648,12 @@ TRACE_EVENT(drv_ampdu_action,
 		__field(u16, tid)
 		__field(u16, ssn)
 		__field(int, ret)
+		VIF_ENTRY
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
+		VIF_ASSIGN;
 		STA_ASSIGN;
 		__entry->ret = ret;
 		__entry->action = action;
@@ -659,8 +662,8 @@ TRACE_EVENT(drv_ampdu_action,
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT  STA_PR_FMT " action:%d tid:%d ret:%d",
-		LOCAL_PR_ARG, STA_PR_ARG, __entry->action, __entry->tid, __entry->ret
+		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " action:%d tid:%d ret:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->action, __entry->tid, __entry->ret
 	)
 );
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-11-13 09:33:45.000000000 +0100
@@ -41,7 +41,8 @@ void __ieee80211_stop_rx_ba_session(stru
 	       sta->sta.addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	if (drv_ampdu_action(local, IEEE80211_AMPDU_RX_STOP,
+	if (drv_ampdu_action(local, &sta->sdata->vif,
+			     IEEE80211_AMPDU_RX_STOP,
 			     &sta->sta, tid, NULL))
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggregation for tid %d\n", tid);
@@ -284,7 +285,8 @@ void ieee80211_process_addba_request(str
 		goto end;
 	}
 
-	ret = drv_ampdu_action(local, IEEE80211_AMPDU_RX_START,
+	ret = drv_ampdu_action(local, &sta->sdata->vif,
+			       IEEE80211_AMPDU_RX_START,
 			       &sta->sta, tid, &start_seq_num);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx A-MPDU request on tid %d result %d\n", tid, ret);
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-11-13 09:33:45.000000000 +0100
@@ -3118,6 +3118,7 @@ static void ath9k_reset_tsf(struct ieee8
 }
 
 static int ath9k_ampdu_action(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
 			      enum ieee80211_ampdu_mlme_action action,
 			      struct ieee80211_sta *sta,
 			      u16 tid, u16 *ssn)
@@ -3135,11 +3136,11 @@ static int ath9k_ampdu_action(struct iee
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		ath_tx_aggr_start(sc, sta, tid, ssn);
-		ieee80211_start_tx_ba_cb_irqsafe(hw, sta->addr, tid);
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
 		ath_tx_aggr_stop(sc, sta, tid);
-		ieee80211_stop_tx_ba_cb_irqsafe(hw, sta->addr, tid);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		ath_tx_aggr_resume(sc, sta, tid);
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-13 09:33:45.000000000 +0100
@@ -2646,6 +2646,7 @@ static int iwl_mac_set_key(struct ieee80
 }
 
 static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
 			     enum ieee80211_ampdu_mlme_action action,
 			     struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/rc.c	2009-11-13 09:33:40.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/rc.c	2009-11-13 09:33:45.000000000 +0100
@@ -1352,7 +1352,7 @@ static void ath_tx_status(void *priv, st
 			an = (struct ath_node *)sta->drv_priv;
 
 			if(ath_tx_aggr_check(sc, an, tid))
-				ieee80211_start_tx_ba_session(sc->hw, hdr->addr1, tid);
+				ieee80211_start_tx_ba_session(sta, tid);
 		}
 	}
 


