Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52007 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3BFPBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 10:01:23 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 1/4] mac80211: Return a status for tx operations
Date: Wed,  6 Feb 2013 09:01:10 -0600
Message-Id: <1360162873-17240-2-git-send-email-seth.forshee@canonical.com> (sfid-20130206_160128_549600_5404724D)
In-Reply-To: <1360162873-17240-1-git-send-email-seth.forshee@canonical.com>
References: <1360162873-17240-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For off-channel operation we would like to know whether or not frames
submitted for tx are dropped, but most tx interfaces don't return
any status. The low-level interfaces do return bool but make no
distinction between dropping a packet and sucessfully handing it off to
the driver.

Add an enum named ieee80211_tx_status which defines status codes to
indicate whether a tx request results in successfully handing the frame
off to the driver, queueing the frame, or dropping it. Convert all tx
interfaces to return one of the values.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/ieee80211_i.h |   53 ++++++++++++++++-------
 net/mac80211/tx.c          |  103 +++++++++++++++++++++++---------------------
 2 files changed, 92 insertions(+), 64 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5fba867..edea19e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1494,46 +1494,69 @@ void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int ke
 				     gfp_t gfp);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 			       bool bss_notify);
-void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		    enum ieee80211_band band);
 
-void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
-				 struct sk_buff *skb, int tid,
-				 enum ieee80211_band band);
+/**
+ * enum ieee80211_tx_status - Tx request status
+ * @IEEE80211_TX_OK: Tx request handed off to driver
+ * @IEEE80211_TX_DROPPED: Tx request dropped
+ * @IEEE80211_TX_QUEUED: Tx requeust queued
+ */
+enum ieee80211_tx_status {
+	IEEE80211_TX_OK,
+	IEEE80211_TX_DROPPED,
+	IEEE80211_TX_QUEUED,
+};
 
-static inline void
+enum ieee80211_tx_status
+ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+	       enum ieee80211_band band);
+
+enum ieee80211_tx_status
+__ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
+			    struct sk_buff *skb, int tid,
+			    enum ieee80211_band band);
+
+static inline enum ieee80211_tx_status
 ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 			  struct sk_buff *skb, int tid,
 			  enum ieee80211_band band)
 {
+	enum ieee80211_tx_status ret;
+
 	rcu_read_lock();
-	__ieee80211_tx_skb_tid_band(sdata, skb, tid, band);
+	ret = __ieee80211_tx_skb_tid_band(sdata, skb, tid, band);
 	rcu_read_unlock();
+
+	return ret;
 }
 
-static inline void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
-					struct sk_buff *skb, int tid)
+static inline enum ieee80211_tx_status
+ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		     int tid)
 {
 	struct ieee80211_chanctx_conf *chanctx_conf;
+	enum ieee80211_tx_status ret;
 
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (WARN_ON(!chanctx_conf)) {
 		rcu_read_unlock();
 		kfree_skb(skb);
-		return;
+		return IEEE80211_TX_DROPPED;
 	}
 
-	__ieee80211_tx_skb_tid_band(sdata, skb, tid,
-				    chanctx_conf->def.chan->band);
+	ret = __ieee80211_tx_skb_tid_band(sdata, skb, tid,
+					  chanctx_conf->def.chan->band);
 	rcu_read_unlock();
+
+	return ret;
 }
 
-static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
-				    struct sk_buff *skb)
+static inline enum ieee80211_tx_status
+ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
-	ieee80211_tx_skb_tid(sdata, skb, 7);
+	return ieee80211_tx_skb_tid(sdata, skb, 7);
 }
 
 void ieee802_11_parse_elems(u8 *start, size_t len,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a2cb6a3..fde1bc9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1200,11 +1200,10 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	return TX_CONTINUE;
 }
 
-static bool ieee80211_tx_frags(struct ieee80211_local *local,
-			       struct ieee80211_vif *vif,
-			       struct ieee80211_sta *sta,
-			       struct sk_buff_head *skbs,
-			       bool txpending)
+static enum ieee80211_tx_status
+ieee80211_tx_frags(struct ieee80211_local *local, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta, struct sk_buff_head *skbs,
+		   bool txpending)
 {
 	struct ieee80211_tx_control control;
 	struct sk_buff *skb, *tmp;
@@ -1238,7 +1237,7 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 
 			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 					       flags);
-			return false;
+			return IEEE80211_TX_QUEUED;
 		}
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
@@ -1249,26 +1248,23 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		drv_tx(local, &control, skb);
 	}
 
-	return true;
+	return IEEE80211_TX_OK;
 }
 
-/*
- * Returns false if the frame couldn't be transmitted but was queued instead.
- */
-static bool __ieee80211_tx(struct ieee80211_local *local,
-			   struct sk_buff_head *skbs, int led_len,
-			   struct sta_info *sta, bool txpending)
+static enum ieee80211_tx_status
+__ieee80211_tx(struct ieee80211_local *local, struct sk_buff_head *skbs,
+	       int led_len, struct sta_info *sta, bool txpending)
 {
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_vif *vif;
 	struct ieee80211_sta *pubsta;
 	struct sk_buff *skb;
-	bool result = true;
+	enum ieee80211_tx_status result;
 	__le16 fc;
 
 	if (WARN_ON(skb_queue_empty(skbs)))
-		return true;
+		return IEEE80211_TX_OK;
 
 	skb = skb_peek(skbs);
 	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
@@ -1291,7 +1287,7 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
 				vif->hw_queue[skb_get_queue_mapping(skb)];
 		} else if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL) {
 			dev_kfree_skb(skb);
-			return true;
+			return IEEE80211_TX_DROPPED;
 		} else
 			vif = NULL;
 		break;
@@ -1371,23 +1367,20 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	return 0;
 }
 
-/*
- * Returns false if the frame couldn't be transmitted but was queued instead.
- */
-static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
-			 struct sk_buff *skb, bool txpending,
-			 enum ieee80211_band band)
+static enum ieee80211_tx_status
+ieee80211_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+	     bool txpending, enum ieee80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	bool result = true;
+	enum ieee80211_tx_status result = IEEE80211_TX_OK;
 	int led_len;
 
 	if (unlikely(skb->len < 10)) {
 		dev_kfree_skb(skb);
-		return true;
+		return IEEE80211_TX_DROPPED;
 	}
 
 	/* initialises tx */
@@ -1396,9 +1389,17 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 
 	if (unlikely(res_prepare == TX_DROP)) {
 		ieee80211_free_txskb(&local->hw, skb);
-		return true;
+		return IEEE80211_TX_DROPPED;
 	} else if (unlikely(res_prepare == TX_QUEUED)) {
-		return true;
+		/*
+		 * TX_QUEUED here means that the frame was queued in
+		 * tid_tx while aggregation is being set up. This need
+		 * not prevent tx of other pending frames, so indicate
+		 * success if txpending is true.
+		 */
+		if (txpending)
+			return IEEE80211_TX_OK;
+		return IEEE80211_TX_QUEUED;
 	}
 
 	info->band = band;
@@ -1447,8 +1448,9 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		    enum ieee80211_band band)
+enum ieee80211_tx_status
+ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+	       enum ieee80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1466,7 +1468,7 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 
 	if (ieee80211_skb_resize(sdata, skb, headroom, may_encrypt)) {
 		ieee80211_free_txskb(&local->hw, skb);
-		return;
+		return IEEE80211_TX_DROPPED;
 	}
 
 	hdr = (struct ieee80211_hdr *) skb->data;
@@ -1477,11 +1479,11 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 	    !is_multicast_ether_addr(hdr->addr1) &&
 	    mesh_nexthop_resolve(skb, sdata)) {
 		/* skb queued: don't free */
-		return;
+		return IEEE80211_TX_QUEUED;
 	}
 
 	ieee80211_set_qos_hdr(sdata, skb);
-	ieee80211_tx(sdata, skb, false, band);
+	return ieee80211_tx(sdata, skb, false, band);
 }
 
 static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
@@ -2174,18 +2176,17 @@ void ieee80211_clear_tx_pending(struct ieee80211_local *local)
 }
 
 /*
- * Returns false if the frame couldn't be transmitted but was queued instead,
- * which in this case means re-queued -- take as an indication to stop sending
- * more pending frames.
+ * A return value of IEEE80211_TX_QUEUED in this case means re-queued --
+ * take as an indication to stop sending more pending frames.
  */
-static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
-				     struct sk_buff *skb)
+static enum ieee80211_tx_status
+ieee80211_tx_pending_skb(struct ieee80211_local *local, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_hdr *hdr;
-	bool result;
+	enum ieee80211_tx_status tx_stat;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 
 	sdata = vif_to_sdata(info->control.vif);
@@ -2194,10 +2195,10 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 		if (unlikely(!chanctx_conf)) {
 			dev_kfree_skb(skb);
-			return true;
+			return IEEE80211_TX_DROPPED;
 		}
-		result = ieee80211_tx(sdata, skb, true,
-				      chanctx_conf->def.chan->band);
+		tx_stat = ieee80211_tx(sdata, skb, true,
+				       chanctx_conf->def.chan->band);
 	} else {
 		struct sk_buff_head skbs;
 
@@ -2207,10 +2208,10 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		hdr = (struct ieee80211_hdr *)skb->data;
 		sta = sta_info_get(sdata, hdr->addr1);
 
-		result = __ieee80211_tx(local, &skbs, skb->len, sta, true);
+		tx_stat = __ieee80211_tx(local, &skbs, skb->len, sta, true);
 	}
 
-	return result;
+	return tx_stat;
 }
 
 /*
@@ -2221,7 +2222,7 @@ void ieee80211_tx_pending(unsigned long data)
 	struct ieee80211_local *local = (struct ieee80211_local *)data;
 	unsigned long flags;
 	int i;
-	bool txok;
+	enum ieee80211_tx_status tx_stat;
 
 	rcu_read_lock();
 
@@ -2247,10 +2248,10 @@ void ieee80211_tx_pending(unsigned long data)
 			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 						flags);
 
-			txok = ieee80211_tx_pending_skb(local, skb);
+			tx_stat = ieee80211_tx_pending_skb(local, skb);
 			spin_lock_irqsave(&local->queue_stop_reason_lock,
 					  flags);
-			if (!txok)
+			if (tx_stat == IEEE80211_TX_QUEUED)
 				break;
 		}
 
@@ -2775,11 +2776,13 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_get_buffered_bc);
 
-void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
-				 struct sk_buff *skb, int tid,
-				 enum ieee80211_band band)
+enum ieee80211_tx_status
+__ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
+			    struct sk_buff *skb, int tid,
+			    enum ieee80211_band band)
 {
 	int ac = ieee802_1d_to_ac[tid & 7];
+	enum ieee80211_tx_status ret;
 
 	skb_set_mac_header(skb, 0);
 	skb_set_network_header(skb, 0);
@@ -2794,6 +2797,8 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 	 * requirements are that we do not come into tx with bhs on.
 	 */
 	local_bh_disable();
-	ieee80211_xmit(sdata, skb, band);
+	ret = ieee80211_xmit(sdata, skb, band);
 	local_bh_enable();
+
+	return ret;
 }
-- 
1.7.9.5

