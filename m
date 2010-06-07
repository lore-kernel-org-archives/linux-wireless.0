Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35569 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab0FGLDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 07:03:11 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OLa6o-0007Bc-EW
	for linux-wireless@vger.kernel.org; Mon, 07 Jun 2010 13:03:10 +0200
Message-Id: <20100607110200.633073840@sipsolutions.net>
Date: Mon, 07 Jun 2010 13:01:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 09/21] mac80211: move aggregation callback processing
References: <20100607110133.472649120@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This moves the aggregation callback processing
to the per-sdata skb queue and a work function
rather than the tasklet.

Unfortunately, this means that it extends the
pkt_type hack to that skb queue. However, it
will enable making ampdu_action API changes
gradually, my current plan is to get rid of
this again by forcing drivers to only return
from ampdu_action() when everything is done,
thus removing the callbacks completely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c      |   14 ++++++--------
 net/mac80211/ieee80211_i.h |   11 +++++++----
 net/mac80211/iface.c       |   15 ++++++++++++---
 net/mac80211/main.c        |   13 -------------
 net/mac80211/rx.c          |    5 +++++
 5 files changed, 30 insertions(+), 28 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-06-06 13:22:15.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-06 13:22:21.000000000 +0200
@@ -564,11 +564,15 @@ ieee80211_sdata_set_mesh_id(struct ieee8
 #endif
 }
 
+enum sdata_queue_type {
+	IEEE80211_SDATA_QUEUE_TYPE_FRAME	= 0,
+	IEEE80211_SDATA_QUEUE_AGG_START		= 1,
+	IEEE80211_SDATA_QUEUE_AGG_STOP		= 2,
+};
+
 enum {
 	IEEE80211_RX_MSG	= 1,
 	IEEE80211_TX_STATUS_MSG	= 2,
-	IEEE80211_DELBA_MSG	= 3,
-	IEEE80211_ADDBA_MSG	= 4,
 };
 
 enum queue_stop_reason {
@@ -870,9 +874,8 @@ IEEE80211_DEV_TO_SUB_IF(struct net_devic
 	return netdev_priv(dev);
 }
 
-/* this struct represents 802.11n's RA/TID combination along with our vif */
+/* this struct represents 802.11n's RA/TID combination */
 struct ieee80211_ra_tid {
-	struct ieee80211_vif *vif;
 	u8 ra[ETH_ALEN];
 	u16 tid;
 };
--- wireless-testing.orig/net/mac80211/main.c	2010-06-06 13:11:21.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-06-06 13:22:21.000000000 +0200
@@ -259,7 +259,6 @@ static void ieee80211_tasklet_handler(un
 {
 	struct ieee80211_local *local = (struct ieee80211_local *) data;
 	struct sk_buff *skb;
-	struct ieee80211_ra_tid *ra_tid;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
@@ -274,18 +273,6 @@ static void ieee80211_tasklet_handler(un
 			skb->pkt_type = 0;
 			ieee80211_tx_status(local_to_hw(local), skb);
 			break;
-		case IEEE80211_DELBA_MSG:
-			ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-			ieee80211_stop_tx_ba_cb(ra_tid->vif, ra_tid->ra,
-						ra_tid->tid);
-			dev_kfree_skb(skb);
-			break;
-		case IEEE80211_ADDBA_MSG:
-			ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-			ieee80211_start_tx_ba_cb(ra_tid->vif, ra_tid->ra,
-						 ra_tid->tid);
-			dev_kfree_skb(skb);
-			break ;
 		default:
 			WARN(1, "mac80211: Packet is of unknown type %d\n",
 			     skb->pkt_type);
--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-06-06 13:12:57.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-06-06 13:22:21.000000000 +0200
@@ -502,11 +502,10 @@ void ieee80211_start_tx_ba_cb_irqsafe(st
 	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
 	memcpy(&ra_tid->ra, ra, ETH_ALEN);
 	ra_tid->tid = tid;
-	ra_tid->vif = vif;
 
-	skb->pkt_type = IEEE80211_ADDBA_MSG;
-	skb_queue_tail(&local->skb_queue, skb);
-	tasklet_schedule(&local->tasklet);
+	skb->pkt_type = IEEE80211_SDATA_QUEUE_AGG_START;
+	skb_queue_tail(&sdata->skb_queue, skb);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
 
@@ -637,11 +636,10 @@ void ieee80211_stop_tx_ba_cb_irqsafe(str
 	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
 	memcpy(&ra_tid->ra, ra, ETH_ALEN);
 	ra_tid->tid = tid;
-	ra_tid->vif = vif;
 
-	skb->pkt_type = IEEE80211_DELBA_MSG;
-	skb_queue_tail(&local->skb_queue, skb);
-	tasklet_schedule(&local->tasklet);
+	skb->pkt_type = IEEE80211_SDATA_QUEUE_AGG_STOP;
+	skb_queue_tail(&sdata->skb_queue, skb);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb_irqsafe);
 
--- wireless-testing.orig/net/mac80211/rx.c	2010-06-06 13:22:20.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-06-06 13:22:21.000000000 +0200
@@ -741,6 +741,7 @@ static void ieee80211_rx_reorder_ampdu(s
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	if (sc & IEEE80211_SCTL_FRAG) {
 		spin_unlock(&sta->lock);
+		skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
 		skb_queue_tail(&rx->sdata->skb_queue, skb);
 		ieee80211_queue_work(&local->hw, &rx->sdata->work);
 		return;
@@ -1969,6 +1970,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 			goto invalid;
 		}
 
+		rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
 		skb_queue_tail(&sdata->skb_queue, rx->skb);
 		ieee80211_queue_work(&local->hw, &sdata->work);
 		return RX_QUEUED;
@@ -2001,6 +2003,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 			if (memcmp(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN))
 				break;
 
+			rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
 			skb_queue_tail(&sdata->skb_queue, rx->skb);
 			ieee80211_queue_work(&local->hw, &sdata->work);
 			return RX_QUEUED;
@@ -2023,6 +2026,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 	case WLAN_CATEGORY_MESH_PATH_SEL:
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
+		rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
 		skb_queue_tail(&sdata->skb_queue, rx->skb);
 		ieee80211_queue_work(&local->hw, &sdata->work);
 		return RX_QUEUED;
@@ -2129,6 +2133,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 	}
 
 	/* queue up frame and kick off work to process it */
+	rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
 	skb_queue_tail(&sdata->skb_queue, rx->skb);
 	ieee80211_queue_work(&rx->local->hw, &sdata->work);
 
--- wireless-testing.orig/net/mac80211/iface.c	2010-06-06 13:22:20.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-06-06 13:22:21.000000000 +0200
@@ -482,7 +482,7 @@ static int ieee80211_stop(struct net_dev
 		}
 		/* fall through */
 	default:
-		cancel_work_sync(&sdata->work);
+		flush_work(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
 		 * Call synchronize_rcu() to wait for the RX path
@@ -708,6 +708,7 @@ static void ieee80211_iface_work(struct
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
+	struct ieee80211_ra_tid *ra_tid;
 
 	if (!ieee80211_sdata_running(sdata))
 		return;
@@ -727,8 +728,16 @@ static void ieee80211_iface_work(struct
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
 		struct ieee80211_mgmt *mgmt = (void *)skb->data;
 
-		if (ieee80211_is_action(mgmt->frame_control) &&
-		    mgmt->u.action.category == WLAN_CATEGORY_BACK) {
+		if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_START) {
+			ra_tid = (void *)&skb->cb;
+			ieee80211_start_tx_ba_cb(&sdata->vif, ra_tid->ra,
+						 ra_tid->tid);
+		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_STOP) {
+			ra_tid = (void *)&skb->cb;
+			ieee80211_stop_tx_ba_cb(&sdata->vif, ra_tid->ra,
+						ra_tid->tid);
+		} else if (ieee80211_is_action(mgmt->frame_control) &&
+			   mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
 
 			rcu_read_lock();


