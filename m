Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab1KPO3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 09:29:49 -0500
Message-Id: <20111116142910.914711801@sipsolutions.net> (sfid-20111116_152954_642678_726FEB81)
Date: Wed, 16 Nov 2011 15:28:56 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mac80211: move fragment flag adjustment
References: <20111116142854.518391560@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of adjusting the fragment flags at
TX time, adjust them at fragmentation time.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/net/mac80211/tx.c	2011-11-16 15:15:57.000000000 +0100
+++ b/net/mac80211/tx.c	2011-11-16 15:16:45.000000000 +0100
@@ -850,6 +850,7 @@ static int ieee80211_fragment(struct iee
 			      int frag_threshold)
 {
 	struct ieee80211_local *local = tx->local;
+	struct ieee80211_tx_info *info;
 	struct sk_buff *tmp;
 	int per_fragm = frag_threshold - hdrlen - FCS_LEN;
 	int pos = hdrlen + per_fragm;
@@ -879,6 +880,14 @@ static int ieee80211_fragment(struct iee
 				 IEEE80211_ENCRYPT_HEADROOM);
 		/* copy control information */
 		memcpy(tmp->cb, skb->cb, sizeof(tmp->cb));
+
+		info = IEEE80211_SKB_CB(tmp);
+		info->flags &= ~(IEEE80211_TX_CTL_CLEAR_PS_FILT |
+				 IEEE80211_TX_CTL_FIRST_FRAGMENT);
+
+		if (rem)
+			info->flags |= IEEE80211_TX_CTL_MORE_FRAMES;
+
 		skb_copy_queue_mapping(tmp, skb);
 		tmp->priority = skb->priority;
 		tmp->dev = skb->dev;
@@ -1206,7 +1215,6 @@ static bool __ieee80211_tx(struct ieee80
 	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
 	int len;
-	bool fragm = false;
 
 	skb_queue_walk_safe(skbs, skb, tmp) {
 		int q = skb_get_queue_mapping(skb);
@@ -1233,15 +1241,8 @@ static bool __ieee80211_tx(struct ieee80
 
 		info = IEEE80211_SKB_CB(skb);
 
-		if (fragm)
-			info->flags &= ~(IEEE80211_TX_CTL_CLEAR_PS_FILT |
-					 IEEE80211_TX_CTL_FIRST_FRAGMENT);
-
 		len = skb->len;
 
-		if (!skb_queue_is_last(skbs, skb))
-			info->flags |= IEEE80211_TX_CTL_MORE_FRAMES;
-
 		sdata = vif_to_sdata(info->control.vif);
 
 		switch (sdata->vif.type) {
@@ -1269,7 +1270,6 @@ static bool __ieee80211_tx(struct ieee80
 
 		ieee80211_tpt_led_trig_tx(local, fc, len);
 		ieee80211_led_tx(local, 1);
-		fragm = true;
 	}
 
 	WARN_ON(!skb_queue_empty(skbs));


