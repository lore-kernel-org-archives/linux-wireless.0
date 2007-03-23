Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48995 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934304AbXCWUne (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:34 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/19] mac80211: Fix pkt_type annotations
Message-Id: <20070323204450.8E3854857A@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:50 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>

There is no need for an instance of the enum in ieee80211_local.
Remove it. Also make the constants uppercase to respect
kernel coding style.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211.c   |    8 ++++----
 net/mac80211/ieee80211_i.h |    9 +++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

4eb6baed5808950d168cb935c426148ba8256366
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 05c21d6..17c0ef9 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4046,7 +4046,7 @@ void ieee80211_rx_irqsafe(struct ieee802
 	skb->dev = local->mdev;
 	/* copy status into skb->cb for use by tasklet */
 	memcpy(skb->cb, status, sizeof(*status));
-	skb->pkt_type = ieee80211_rx_msg;
+	skb->pkt_type = IEEE80211_RX_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);
 }
@@ -4076,7 +4076,7 @@ void ieee80211_tx_status_irqsafe(struct 
 	/* copy pointer to saved status into skb->cb for use by tasklet */
 	memcpy(skb->cb, &saved, sizeof(saved));
 
-	skb->pkt_type = ieee80211_tx_status_msg;
+	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
 	skb_queue_tail(status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS ?
 		       &local->skb_queue : &local->skb_queue_unreliable, skb);
 	tmp = skb_queue_len(&local->skb_queue) +
@@ -4103,7 +4103,7 @@ static void ieee80211_tasklet_handler(un
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
 		switch (skb->pkt_type) {
-		case ieee80211_rx_msg:
+		case IEEE80211_RX_MSG:
 			/* status is in skb->cb */
 			memcpy(&rx_status, skb->cb, sizeof(rx_status));
 			/* Clear skb->type in order to not confuse kernel
@@ -4111,7 +4111,7 @@ static void ieee80211_tasklet_handler(un
 			skb->pkt_type = 0;
 			__ieee80211_rx(local_to_hw(local), skb, &rx_status);
 			break;
-		case ieee80211_tx_status_msg:
+		case IEEE80211_TX_STATUS_MSG:
 			/* get pointer to saved status out of skb->cb */
 			memcpy(&tx_status, skb->cb, sizeof(tx_status));
 			skb->pkt_type = 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cf37ce6..9ea1005 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -343,6 +343,11 @@ #define NUM_DEFAULT_KEYS 4
 
 #define IEEE80211_DEV_TO_SUB_IF(dev) netdev_priv(dev)
 
+enum {
+	IEEE80211_RX_MSG	= 1,
+	IEEE80211_TX_STATUS_MSG	= 2,
+};
+
 struct ieee80211_local {
 	/* embed the driver visible part.
 	 * don't cast (use the static inlines below), but we keep
@@ -375,10 +380,6 @@ #define IEEE80211_IRQSAFE_QUEUE_LIMIT 12
 	struct tasklet_struct tasklet;
 	struct sk_buff_head skb_queue;
 	struct sk_buff_head skb_queue_unreliable;
-	enum {
-		ieee80211_rx_msg = 1,
-		ieee80211_tx_status_msg = 2
-	} ieee80211_msg_enum;
 
 	/* Station data structures */
 	struct kset sta_kset;
-- 
1.3.0

