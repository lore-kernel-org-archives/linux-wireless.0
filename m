Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab0FJI0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:14 -0400
Message-Id: <20100610082230.961704999@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:40 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/23] mac80211: remove non-irqsafe aggregation callbacks
References: <20100610082128.641664439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The non-irqsafe aggregation start/stop done
callbacks are currently only used by ath9k_htc,
and can cause callbacks into the driver again.
This might lead to locking issues, which will
only get worse as we modify locking. To avoid
trouble, remove the non-irqsafe versions and
change ath9k_htc to use those instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    6 ++--
 include/net/mac80211.h                        |   32 ++++----------------------
 net/mac80211/agg-tx.c                         |    2 -
 net/mac80211/ieee80211_i.h                    |    2 +
 4 files changed, 10 insertions(+), 32 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-06-09 17:21:02.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-06-09 17:21:12.000000000 +0200
@@ -1445,7 +1445,7 @@ enum ieee80211_filter_flags {
  *
  * Note that drivers MUST be able to deal with a TX aggregation
  * session being stopped even before they OK'ed starting it by
- * calling ieee80211_start_tx_ba_cb(_irqsafe), because the peer
+ * calling ieee80211_start_tx_ba_cb_irqsafe, because the peer
  * might receive the addBA frame and send a delBA right away!
  *
  * @IEEE80211_AMPDU_RX_START: start Rx aggregation
@@ -2314,25 +2314,14 @@ void ieee80211_queue_delayed_work(struct
 int ieee80211_start_tx_ba_session(struct ieee80211_sta *sta, u16 tid);
 
 /**
- * ieee80211_start_tx_ba_cb - low level driver ready to aggregate.
- * @vif: &struct ieee80211_vif pointer from the add_interface callback
- * @ra: receiver address of the BA session recipient.
- * @tid: the TID to BA on.
- *
- * This function must be called by low level driver once it has
- * finished with preparations for the BA session.
- */
-void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
-
-/**
  * ieee80211_start_tx_ba_cb_irqsafe - low level driver ready to aggregate.
  * @vif: &struct ieee80211_vif pointer from the add_interface callback
  * @ra: receiver address of the BA session recipient.
  * @tid: the TID to BA on.
  *
  * This function must be called by low level driver once it has
- * finished with preparations for the BA session.
- * This version of the function is IRQ-safe.
+ * finished with preparations for the BA session. It can be called
+ * from any context.
  */
 void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif, const u8 *ra,
 				      u16 tid);
@@ -2351,25 +2340,14 @@ void ieee80211_start_tx_ba_cb_irqsafe(st
 int ieee80211_stop_tx_ba_session(struct ieee80211_sta *sta, u16 tid);
 
 /**
- * ieee80211_stop_tx_ba_cb - low level driver ready to stop aggregate.
- * @vif: &struct ieee80211_vif pointer from the add_interface callback
- * @ra: receiver address of the BA session recipient.
- * @tid: the desired TID to BA on.
- *
- * This function must be called by low level driver once it has
- * finished with preparations for the BA session tear down.
- */
-void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
-
-/**
  * ieee80211_stop_tx_ba_cb_irqsafe - low level driver ready to stop aggregate.
  * @vif: &struct ieee80211_vif pointer from the add_interface callback
  * @ra: receiver address of the BA session recipient.
  * @tid: the desired TID to BA on.
  *
  * This function must be called by low level driver once it has
- * finished with preparations for the BA session tear down.
- * This version of the function is IRQ-safe.
+ * finished with preparations for the BA session tear down. It
+ * can be called from any context.
  */
 void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif, const u8 *ra,
 				     u16 tid);
--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-06-09 17:21:11.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-06-09 17:21:12.000000000 +0200
@@ -479,7 +479,6 @@ void ieee80211_start_tx_ba_cb(struct iee
 	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(ieee80211_start_tx_ba_cb);
 
 void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 				      const u8 *ra, u16 tid)
@@ -619,7 +618,6 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb);
 
 void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 				     const u8 *ra, u16 tid)
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-06-09 17:21:11.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-09 17:21:12.000000000 +0200
@@ -1119,6 +1119,8 @@ void ieee80211_process_addba_request(str
 
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				   enum ieee80211_back_parties initiator);
+void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
+void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2010-06-09 17:20:48.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2010-06-09 17:21:12.000000000 +0200
@@ -510,13 +510,13 @@ void ath9k_htc_aggr_work(struct work_str
 		ret = ath9k_htc_aggr_oper(priv, wk->vif, wk->sta_addr,
 					  wk->tid, true);
 		if (!ret)
-			ieee80211_start_tx_ba_cb(wk->vif, wk->sta_addr,
-						 wk->tid);
+			ieee80211_start_tx_ba_cb_irqsafe(wk->vif, wk->sta_addr,
+							 wk->tid);
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
 		ath9k_htc_aggr_oper(priv, wk->vif, wk->sta_addr,
 				    wk->tid, false);
-		ieee80211_stop_tx_ba_cb(wk->vif, wk->sta_addr, wk->tid);
+		ieee80211_stop_tx_ba_cb_irqsafe(wk->vif, wk->sta_addr, wk->tid);
 		break;
 	default:
 		ath_print(ath9k_hw_common(priv->ah), ATH_DBG_FATAL,


