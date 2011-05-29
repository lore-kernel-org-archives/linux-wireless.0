Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:41238 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab1E2UHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 16:07:06 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id F296B8C663
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:07:04 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id DB94D2BD45
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:07:03 +0300 (EEST)
Subject: [RFC PATCH 25/27] mac80211: use mac80211 prefix with rx and tx msg
	flags
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 29 May 2011 23:07:03 +0300
Message-ID: <20110529200703.16479.42873.stgit@localhost6.localdomain6> (sfid-20110529_220711_042812_70E6352E)
In-Reply-To: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
References: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |    4 ++--
 net/mac80211/main.c       |    4 ++--
 net/mac80211/rx.c         |    2 +-
 net/mac80211/status.c     |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index 73ebb14..bf97b7e 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -628,8 +628,8 @@ enum sdata_queue_type {
 };
 
 enum {
-	IEEE80211_RX_MSG	= 1,
-	IEEE80211_TX_STATUS_MSG	= 2,
+	MAC80211_RX_MSG		= 1,
+	MAC80211_TX_STATUS_MSG	= 2,
 };
 
 enum queue_stop_reason {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index fd1f83c..a59821e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -330,13 +330,13 @@ static void ieee80211_tasklet_handler(unsigned long data)
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
 		switch (skb->pkt_type) {
-		case IEEE80211_RX_MSG:
+		case MAC80211_RX_MSG:
 			/* Clear skb->pkt_type in order to not confuse kernel
 			 * netstack. */
 			skb->pkt_type = 0;
 			ieee80211_rx(local_to_hw(local), skb);
 			break;
-		case IEEE80211_TX_STATUS_MSG:
+		case MAC80211_TX_STATUS_MSG:
 			skb->pkt_type = 0;
 			ieee80211_tx_status(local_to_hw(local), skb);
 			break;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index be041e5..3893271 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2955,7 +2955,7 @@ void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
 
-	skb->pkt_type = IEEE80211_RX_MSG;
+	skb->pkt_type = MAC80211_RX_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);
 }
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 41fe6ed..37c886d 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -23,7 +23,7 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int tmp;
 
-	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
+	skb->pkt_type = MAC80211_TX_STATUS_MSG;
 	skb_queue_tail(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS ?
 		       &local->skb_queue : &local->skb_queue_unreliable, skb);
 	tmp = skb_queue_len(&local->skb_queue) +

