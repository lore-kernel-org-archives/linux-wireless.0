Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbYBAUtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 15:49:06 -0500
Subject: [RFC] mac80211: use TX queue enum in more places
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 21:48:59 +0100
Message-Id: <1201898939.4188.75.camel@johannes.berg> (sfid-20080201_204911_766605_7D936F3F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any comments on this?

johannes

---
 net/mac80211/wme.c |   20 ++++++++++++++++----
 net/mac80211/wme.h |    8 +++++---
 2 files changed, 21 insertions(+), 7 deletions(-)

--- everything.orig/net/mac80211/wme.c	2008-02-01 16:27:22.518654080 +0100
+++ everything/net/mac80211/wme.c	2008-02-01 16:36:07.378650499 +0100
@@ -21,7 +21,16 @@
 /* maximum number of hardware queues we support. */
 #define TC_80211_MAX_QUEUES 16
 
-const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0, 0 };
+const enum ieee80211_tx_queue ieee802_1d_to_ac[8] = {
+	IEEE80211_TX_QUEUE_DATA2,
+	IEEE80211_TX_QUEUE_DATA3,
+	IEEE80211_TX_QUEUE_DATA3,
+	IEEE80211_TX_QUEUE_DATA2,
+	IEEE80211_TX_QUEUE_DATA1,
+	IEEE80211_TX_QUEUE_DATA1,
+	IEEE80211_TX_QUEUE_DATA0,
+	IEEE80211_TX_QUEUE_DATA0
+};
 
 struct ieee80211_sched_data
 {
@@ -95,7 +104,8 @@ static inline int wme_downgrade_ac(struc
 
 /* positive return value indicates which queue to use
  * negative return value indicates to drop the frame */
-static inline int classify80211(struct sk_buff *skb, struct Qdisc *qd)
+static enum ieee80211_tx_queue
+classify80211(struct sk_buff *skb, struct Qdisc *qd)
 {
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -147,7 +157,8 @@ static int wme_qdiscop_enqueue(struct sk
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	struct Qdisc *qdisc;
-	int err, queue;
+	int err;
+	enum ieee80211_tx_queue queue;
 	struct sta_info *sta;
 	u8 tid;
 
@@ -699,7 +710,8 @@ void ieee80211_ht_agg_queue_remove(struc
 		q->queues[agg_queue]->ops->reset(q->queues[agg_queue]);
 }
 
-void ieee80211_requeue(struct ieee80211_local *local, int queue)
+void ieee80211_requeue(struct ieee80211_local *local,
+		       enum ieee80211_tx_queue queue)
 {
 	struct Qdisc *root_qd = local->mdev->qdisc_sleeping;
 	struct ieee80211_sched_data *q = qdisc_priv(root_qd);
--- everything.orig/net/mac80211/wme.h	2008-02-01 16:31:23.628666179 +0100
+++ everything/net/mac80211/wme.h	2008-02-01 16:32:45.718652452 +0100
@@ -24,7 +24,7 @@
 
 #define QOS_CONTROL_TAG1D_MASK 0x07
 
-extern const int ieee802_1d_to_ac[8];
+extern const enum ieee80211_tx_queue ieee802_1d_to_ac[8];
 
 static inline int WLAN_FC_IS_QOS_DATA(u16 fc)
 {
@@ -39,7 +39,8 @@ int ieee80211_ht_agg_queue_add(struct ie
 void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
 				   struct sta_info *sta, u16 tid,
 				   u8 requeue);
-void ieee80211_requeue(struct ieee80211_local *local, int queue);
+void ieee80211_requeue(struct ieee80211_local *local,
+		       enum ieee80211_tx_queue queue);
 int ieee80211_wme_register(void);
 void ieee80211_wme_unregister(void);
 #else
@@ -60,7 +61,8 @@ static inline void ieee80211_ht_agg_queu
 						 u8 requeue)
 {
 }
-static inline void ieee80211_requeue(struct ieee80211_local *local, int queue)
+static inline void ieee80211_requeue(struct ieee80211_local *local,
+				     enum ieee80211_tx_queue queue)
 {
 }
 static inline int ieee80211_wme_register(void)


