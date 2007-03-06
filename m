Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33704
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965939AbXCFQpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 11:45:22 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: Fix pkt_type annotations
Date: Tue, 6 Mar 2007 17:43:41 +0100
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703061743.41510.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need for an instance of the enum in ieee80211_local.
Remove it. Also make the constants uppercase to respect
kernel coding style.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/net/mac80211/ieee80211.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-05 13:36:16.000000000 +0100
+++ wireless-dev/net/mac80211/ieee80211.c	2007-03-06 17:41:19.000000000 +0100
@@ -4051,7 +4051,7 @@ void ieee80211_rx_irqsafe(struct ieee802
 	skb->dev = local->mdev;
 	/* copy status into skb->cb for use by tasklet */
 	memcpy(skb->cb, status, sizeof(*status));
-	skb->pkt_type = ieee80211_rx_msg;
+	skb->pkt_type = IEEE80211_RX_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);
 }
@@ -4081,7 +4081,7 @@ void ieee80211_tx_status_irqsafe(struct 
 	/* copy pointer to saved status into skb->cb for use by tasklet */
 	memcpy(skb->cb, &saved, sizeof(saved));
 
-	skb->pkt_type = ieee80211_tx_status_msg;
+	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
 	skb_queue_tail(status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS ?
 		       &local->skb_queue : &local->skb_queue_unreliable, skb);
 	tmp = skb_queue_len(&local->skb_queue) +
@@ -4108,7 +4108,7 @@ static void ieee80211_tasklet_handler(un
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
 		switch (skb->pkt_type) {
-		case ieee80211_rx_msg:
+		case IEEE80211_RX_MSG:
 			/* status is in skb->cb */
 			memcpy(&rx_status, skb->cb, sizeof(rx_status));
 			/* Clear skb->type in order to not confuse kernel
@@ -4116,7 +4116,7 @@ static void ieee80211_tasklet_handler(un
 			skb->pkt_type = 0;
 			__ieee80211_rx(local_to_hw(local), skb, &rx_status);
 			break;
-		case ieee80211_tx_status_msg:
+		case IEEE80211_TX_STATUS_MSG:
 			/* get pointer to saved status out of skb->cb */
 			memcpy(&tx_status, skb->cb, sizeof(tx_status));
 			skb->pkt_type = 0;
Index: wireless-dev/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-03-05 13:36:16.000000000 +0100
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-03-06 17:40:15.000000000 +0100
@@ -342,6 +342,11 @@ struct ieee80211_sub_if_data {
 
 #define IEEE80211_DEV_TO_SUB_IF(dev) netdev_priv(dev)
 
+enum {
+	IEEE80211_RX_MSG	= 1,
+	IEEE80211_TX_STATUS_MSG	= 2,
+};
+
 struct ieee80211_local {
 	/* embed the driver visible part.
 	 * don't cast (use the static inlines below), but we keep
@@ -374,10 +379,6 @@ struct ieee80211_local {
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
Greetings Michael.
