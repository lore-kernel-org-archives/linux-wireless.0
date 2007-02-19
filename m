Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54733 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965103AbXBSWjT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:19 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/12] d80211: remove hosttime from ieee80211_rx_status
Message-Id: <20070219223948.9F1F5484A8@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:48 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

Nobody fills hosttime in ieee80211_rx_status. Removing it allows
ieee80211_rx_status to fit in skb->cb.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 include/net/d80211.h   |    1 -
 net/d80211/ieee80211.c |   29 ++++++++---------------------
 2 files changed, 8 insertions(+), 22 deletions(-)

303082ed805ce3266a613182e2e0c2b95fef77ca
diff --git a/include/net/d80211.h b/include/net/d80211.h
index 326def5..0b7b963 100644
--- a/include/net/d80211.h
+++ b/include/net/d80211.h
@@ -225,7 +225,6 @@ #define RX_FLAG_DECRYPTED        0x2
  * (the subset supported by hardware) to the 802.11 code with each received
  * frame. */
 struct ieee80211_rx_status {
-        u64 hosttime;
 	u64 mactime;
         int freq; /* receive frequency in Mhz */
         int channel;
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index bbcefa9..a0c367c 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -2627,7 +2627,7 @@ ieee80211_fill_frame_info(struct ieee802
                 struct timespec ts;
 		struct ieee80211_rate *rate;
 
-                jiffies_to_timespec(status->hosttime, &ts);
+		jiffies_to_timespec(jiffies, &ts);
 		fi->hosttime = cpu_to_be64((u64) ts.tv_sec * 1000000 +
 					   ts.tv_nsec / 1000);
 		fi->mactime = cpu_to_be64(status->mactime);
@@ -4019,25 +4019,13 @@ static void ieee80211_stat_refresh(unsig
 void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb,
 			  struct ieee80211_rx_status *status)
 {
-	struct ieee80211_rx_status *saved;
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	skb->dev = local->mdev;
-	saved = kmalloc(sizeof(struct ieee80211_rx_status), GFP_ATOMIC);
-	if (unlikely(!saved)) {
-		if (net_ratelimit())
-			printk(KERN_WARNING "%s: Not enough memory, "
-			       "dropping packet", skb->dev->name);
-		/* should be dev_kfree_skb_irq, but due to this function being
-		 * named _irqsafe instead of just _irq we can't be sure that
-		 * people won't call it from non-irq contexts */
-		dev_kfree_skb_any(skb);
-		return;
-	}
-	memcpy(saved, status, sizeof(struct ieee80211_rx_status));
-	/* copy pointer to saved status into skb->cb for use by tasklet */
-	memcpy(skb->cb, &saved, sizeof(saved));
+	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
 
+	skb->dev = local->mdev;
+	/* copy status into skb->cb for use by tasklet */
+	memcpy(skb->cb, status, sizeof(*status));
 	skb->pkt_type = ieee80211_rx_msg;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);
@@ -4089,20 +4077,19 @@ static void ieee80211_tasklet_handler(un
 {
         struct ieee80211_local *local = (struct ieee80211_local *) data;
         struct sk_buff *skb;
-	struct ieee80211_rx_status *rx_status;
+	struct ieee80211_rx_status rx_status;
 	struct ieee80211_tx_status *tx_status;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
                 switch (skb->pkt_type) {
 		case ieee80211_rx_msg:
-			/* get pointer to saved status out of skb->cb */
+			/* status is in skb->cb */
 			memcpy(&rx_status, skb->cb, sizeof(rx_status));
 			/* Clear skb->type in order to not confuse kernel
 			 * netstack. */
 			skb->pkt_type = 0;
-			__ieee80211_rx(local_to_hw(local), skb, rx_status);
-			kfree(rx_status);
+			__ieee80211_rx(local_to_hw(local), skb, &rx_status);
 			break;
 		case ieee80211_tx_status_msg:
 			/* get pointer to saved status out of skb->cb */
-- 
1.3.0

