Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZA2Imu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 03:42:50 -0500
Message-Id: <20090129005808.843799105@sipsolutions.net> (sfid-20090129_094254_128060_5E7BDCBF)
References: <20090129005450.068797016@sipsolutions.net>
Date: Thu, 29 Jan 2009 01:54:56 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: m.sujith@gmail.com, tomasw@gmail.com
Subject: [RFC/RFT 06/11] mac80211: document TX aggregation (and small
	cleanup)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add documentation and move ieee80211_start_tx_ba_cb_irqsafe to right
after ieee80211_start_tx_ba_cb.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-tx.c |   76 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 25 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-01-27 23:10:04.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-01-27 23:10:07.000000000 +0100
@@ -18,6 +18,31 @@
 #include "ieee80211_i.h"
 #include "wme.h"
 
+/**
+ * DOC: TX aggregation
+ *
+ * Aggregation on the TX side requires setting the hardware flag
+ * %IEEE80211_HW_AMPDU_AGGREGATION as well as, if present, the @ampdu_queues
+ * hardware parameter to the number of hardware AMPDU queues. If there are no
+ * hardware queues then the driver will (currently) have to do all frame
+ * buffering.
+ *
+ * When TX aggregation is started by some subsystem (usually the rate control
+ * control algorithm would be appropriate) by calling the
+ * ieee80211_start_tx_ba_session() function, the driver will be notified via
+ * its @ampdu_action function, with the %IEEE80211_AMPDU_TX_START action.
+ *
+ * In response to that, the driver is later required to call the
+ * ieee80211_start_tx_ba_cb() (or ieee80211_start_tx_ba_cb_irqsafe())
+ * function, which will start the aggregation session.
+ *
+ * Similarly, when the aggregation session is stopped by
+ * ieee80211_stop_tx_ba_session(), the driver's @ampdu_action function will
+ * be called with the action %IEEE80211_AMPDU_TX_STOP. In this case, the
+ * call must not fail, and the driver must later call ieee80211_stop_tx_ba_cb()
+ * (or ieee80211_stop_tx_ba_cb_irqsafe()).
+ */
+
 static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 					 const u8 *da, u16 tid,
 					 u8 dialog_token, u16 start_seq_num,
@@ -362,6 +387,31 @@ void ieee80211_start_tx_ba_cb(struct iee
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb);
 
+void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
+				      const u8 *ra, u16 tid)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_ra_tid *ra_tid;
+	struct sk_buff *skb = dev_alloc_skb(0);
+
+	if (unlikely(!skb)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		if (net_ratelimit())
+			printk(KERN_WARNING "%s: Not enough memory, "
+			       "dropping start BA session", skb->dev->name);
+#endif
+		return;
+	}
+	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
+	memcpy(&ra_tid->ra, ra, ETH_ALEN);
+	ra_tid->tid = tid;
+
+	skb->pkt_type = IEEE80211_ADDBA_MSG;
+	skb_queue_tail(&local->skb_queue, skb);
+	tasklet_schedule(&local->tasklet);
+}
+EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
+
 
 int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
 				 u8 *ra, u16 tid,
@@ -491,31 +541,6 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb);
 
-void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
-				      const u8 *ra, u16 tid)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_ra_tid *ra_tid;
-	struct sk_buff *skb = dev_alloc_skb(0);
-
-	if (unlikely(!skb)) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		if (net_ratelimit())
-			printk(KERN_WARNING "%s: Not enough memory, "
-			       "dropping start BA session", skb->dev->name);
-#endif
-		return;
-	}
-	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-	memcpy(&ra_tid->ra, ra, ETH_ALEN);
-	ra_tid->tid = tid;
-
-	skb->pkt_type = IEEE80211_ADDBA_MSG;
-	skb_queue_tail(&local->skb_queue, skb);
-	tasklet_schedule(&local->tasklet);
-}
-EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
-
 void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
 				     const u8 *ra, u16 tid)
 {
@@ -541,6 +566,7 @@ void ieee80211_stop_tx_ba_cb_irqsafe(str
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb_irqsafe);
 
+
 void ieee80211_process_addba_resp(struct ieee80211_local *local,
 				  struct sta_info *sta,
 				  struct ieee80211_mgmt *mgmt,

-- 

