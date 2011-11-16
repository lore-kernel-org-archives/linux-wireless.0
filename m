Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab1KPO3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 09:29:48 -0500
Message-Id: <20111116142910.604837321@sipsolutions.net> (sfid-20111116_152953_894174_52DD3EC1)
Date: Wed, 16 Nov 2011 15:28:55 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mac80211: use skb list for fragments
References: <20111116142854.518391560@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We are currently linking the skbs by using skb->next
directly. This works, but the preferred way is to use
a struct sk_buff_head instead. That also prepares for
passing that to drivers directly.

While at it I noticed we calculate the duration for
fragments twice -- remove one of them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    1 
 net/mac80211/tx.c          |  116 +++++++++++++++++++++++----------------------
 net/mac80211/util.c        |    6 +-
 net/mac80211/wep.c         |    5 -
 net/mac80211/wpa.c         |   25 ++++++---
 5 files changed, 82 insertions(+), 71 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2011-11-16 15:19:36.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2011-11-16 15:19:38.000000000 +0100
@@ -142,6 +142,7 @@ typedef unsigned __bitwise__ ieee80211_t
 
 struct ieee80211_tx_data {
 	struct sk_buff *skb;
+	struct sk_buff_head skbs;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
--- a/net/mac80211/tx.c	2011-11-16 15:19:36.000000000 +0100
+++ b/net/mac80211/tx.c	2011-11-16 15:19:43.000000000 +0100
@@ -36,7 +36,8 @@
 
 /* misc utils */
 
-static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
+static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
+				 struct sk_buff *skb, int group_addr,
 				 int next_frag_len)
 {
 	int rate, mrate, erp, dur, i;
@@ -44,7 +45,7 @@ static __le16 ieee80211_duration(struct
 	struct ieee80211_local *local = tx->local;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_hdr *hdr;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	/* assume HW handles this */
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS)
@@ -76,7 +77,7 @@ static __le16 ieee80211_duration(struct
 	 *   at the highest possible rate belonging to the PHY rates in the
 	 *   BSSBasicRateSet
 	 */
-	hdr = (struct ieee80211_hdr *)tx->skb->data;
+	hdr = (struct ieee80211_hdr *)skb->data;
 	if (ieee80211_is_ctl(hdr->frame_control)) {
 		/* TODO: These control frames are not currently sent by
 		 * mac80211, but should they be implemented, this function
@@ -844,11 +845,12 @@ ieee80211_tx_h_sequence(struct ieee80211
 	return TX_CONTINUE;
 }
 
-static int ieee80211_fragment(struct ieee80211_local *local,
+static int ieee80211_fragment(struct ieee80211_tx_data *tx,
 			      struct sk_buff *skb, int hdrlen,
 			      int frag_threshold)
 {
-	struct sk_buff *tail = skb, *tmp;
+	struct ieee80211_local *local = tx->local;
+	struct sk_buff *tmp;
 	int per_fragm = frag_threshold - hdrlen - FCS_LEN;
 	int pos = hdrlen + per_fragm;
 	int rem = skb->len - hdrlen - per_fragm;
@@ -856,6 +858,8 @@ static int ieee80211_fragment(struct iee
 	if (WARN_ON(rem < 0))
 		return -EINVAL;
 
+	/* first fragment was already added to queue by caller */
+
 	while (rem) {
 		int fraglen = per_fragm;
 
@@ -868,8 +872,9 @@ static int ieee80211_fragment(struct iee
 				    IEEE80211_ENCRYPT_TAILROOM);
 		if (!tmp)
 			return -ENOMEM;
-		tail->next = tmp;
-		tail = tmp;
+
+		__skb_queue_tail(&tx->skbs, tmp);
+
 		skb_reserve(tmp, local->tx_headroom +
 				 IEEE80211_ENCRYPT_HEADROOM);
 		/* copy control information */
@@ -885,6 +890,7 @@ static int ieee80211_fragment(struct iee
 		pos += fraglen;
 	}
 
+	/* adjust first fragment's length */
 	skb->len = hdrlen + per_fragm;
 	return 0;
 }
@@ -899,6 +905,10 @@ ieee80211_tx_h_fragment(struct ieee80211
 	int hdrlen;
 	int fragnum;
 
+	/* no matter what happens, tx->skb moves to tx->skbs */
+	__skb_queue_tail(&tx->skbs, skb);
+	tx->skb = NULL;
+
 	if (info->flags & IEEE80211_TX_CTL_DONTFRAG)
 		return TX_CONTINUE;
 
@@ -927,21 +937,21 @@ ieee80211_tx_h_fragment(struct ieee80211
 	 * of the fragments then we will simply pretend to accept the skb
 	 * but store it away as pending.
 	 */
-	if (ieee80211_fragment(tx->local, skb, hdrlen, frag_threshold))
+	if (ieee80211_fragment(tx, skb, hdrlen, frag_threshold))
 		return TX_DROP;
 
 	/* update duration/seq/flags of fragments */
 	fragnum = 0;
-	do {
+
+	skb_queue_walk(&tx->skbs, skb) {
 		int next_len;
 		const __le16 morefrags = cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
 
 		hdr = (void *)skb->data;
 		info = IEEE80211_SKB_CB(skb);
 
-		if (skb->next) {
+		if (!skb_queue_is_last(&tx->skbs, skb)) {
 			hdr->frame_control |= morefrags;
-			next_len = skb->next->len;
 			/*
 			 * No multi-rate retries for fragmented frames, that
 			 * would completely throw off the NAV at other STAs.
@@ -956,10 +966,9 @@ ieee80211_tx_h_fragment(struct ieee80211
 			hdr->frame_control &= ~morefrags;
 			next_len = 0;
 		}
-		hdr->duration_id = ieee80211_duration(tx, 0, next_len);
 		hdr->seq_ctrl |= cpu_to_le16(fragnum & IEEE80211_SCTL_FRAG);
 		fragnum++;
-	} while ((skb = skb->next));
+	}
 
 	return TX_CONTINUE;
 }
@@ -967,16 +976,16 @@ ieee80211_tx_h_fragment(struct ieee80211
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 {
-	struct sk_buff *skb = tx->skb;
+	struct sk_buff *skb;
 
 	if (!tx->sta)
 		return TX_CONTINUE;
 
 	tx->sta->tx_packets++;
-	do {
+	skb_queue_walk(&tx->skbs, skb) {
 		tx->sta->tx_fragments++;
 		tx->sta->tx_bytes += skb->len;
-	} while ((skb = skb->next));
+	}
 
 	return TX_CONTINUE;
 }
@@ -1015,21 +1024,25 @@ ieee80211_tx_h_encrypt(struct ieee80211_
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_calculate_duration(struct ieee80211_tx_data *tx)
 {
-	struct sk_buff *skb = tx->skb;
+	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
 	int next_len;
 	bool group_addr;
 
-	do {
+	skb_queue_walk(&tx->skbs, skb) {
 		hdr = (void *) skb->data;
 		if (unlikely(ieee80211_is_pspoll(hdr->frame_control)))
 			break; /* must not overwrite AID */
-		next_len = skb->next ? skb->next->len : 0;
+		if (!skb_queue_is_last(&tx->skbs, skb)) {
+			struct sk_buff *next = skb_queue_next(&tx->skbs, skb);
+			next_len = next->len;
+		} else
+			next_len = 0;
 		group_addr = is_multicast_ether_addr(hdr->addr1);
 
 		hdr->duration_id =
-			ieee80211_duration(tx, group_addr, next_len);
-	} while ((skb = skb->next));
+			ieee80211_duration(tx, skb, group_addr, next_len);
+	}
 
 	return TX_CONTINUE;
 }
@@ -1108,6 +1121,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 	tx->local = local;
 	tx->sdata = sdata;
 	tx->channel = local->hw.conf.channel;
+	__skb_queue_head_init(&tx->skbs);
 
 	/*
 	 * If this flag is set to true anywhere, and we get here,
@@ -1183,17 +1197,18 @@ ieee80211_tx_prepare(struct ieee80211_su
 /*
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
-static bool __ieee80211_tx(struct ieee80211_local *local, struct sk_buff **skbp,
+static bool __ieee80211_tx(struct ieee80211_local *local,
+			   struct sk_buff_head *skbs,
 			   struct sta_info *sta, bool txpending)
 {
-	struct sk_buff *skb = *skbp, *next;
+	struct sk_buff *skb, *tmp;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
 	int len;
 	bool fragm = false;
 
-	while (skb) {
+	skb_queue_walk_safe(skbs, skb, tmp) {
 		int q = skb_get_queue_mapping(skb);
 		__le16 fc;
 
@@ -1205,24 +1220,10 @@ static bool __ieee80211_tx(struct ieee80
 			 * transmission from the tx-pending tasklet when the
 			 * queue is woken again.
 			 */
-
-			do {
-				next = skb->next;
-				skb->next = NULL;
-				/*
-				 * NB: If txpending is true, next must already
-				 * be NULL since we must've gone through this
-				 * loop before already; therefore we can just
-				 * queue the frame to the head without worrying
-				 * about reordering of fragments.
-				 */
-				if (unlikely(txpending))
-					__skb_queue_head(&local->pending[q],
-							 skb);
-				else
-					__skb_queue_tail(&local->pending[q],
-							 skb);
-			} while ((skb = next));
+			if (txpending)
+				skb_queue_splice(skbs, &local->pending[q]);
+			else
+				skb_queue_splice_tail(skbs, &local->pending[q]);
 
 			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 					       flags);
@@ -1236,10 +1237,9 @@ static bool __ieee80211_tx(struct ieee80
 			info->flags &= ~(IEEE80211_TX_CTL_CLEAR_PS_FILT |
 					 IEEE80211_TX_CTL_FIRST_FRAGMENT);
 
-		next = skb->next;
 		len = skb->len;
 
-		if (next)
+		if (!skb_queue_is_last(skbs, skb))
 			info->flags |= IEEE80211_TX_CTL_MORE_FRAMES;
 
 		sdata = vif_to_sdata(info->control.vif);
@@ -1263,14 +1263,17 @@ static bool __ieee80211_tx(struct ieee80
 			info->control.sta = NULL;
 
 		fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
+
+		__skb_unlink(skb, skbs);
 		drv_tx(local, skb);
 
 		ieee80211_tpt_led_trig_tx(local, fc, len);
-		*skbp = skb = next;
 		ieee80211_led_tx(local, 1);
 		fragm = true;
 	}
 
+	WARN_ON(!skb_queue_empty(skbs));
+
 	return true;
 }
 
@@ -1280,8 +1283,7 @@ static bool __ieee80211_tx(struct ieee80
  */
 static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 {
-	struct sk_buff *skb = tx->skb;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	ieee80211_tx_result res = TX_DROP;
 
 #define CALL_TXH(txh) \
@@ -1315,13 +1317,10 @@ static int invoke_tx_handlers(struct iee
  txh_done:
 	if (unlikely(res == TX_DROP)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop);
-		while (skb) {
-			struct sk_buff *next;
-
-			next = skb->next;
-			dev_kfree_skb(skb);
-			skb = next;
-		}
+		if (tx->skb)
+			dev_kfree_skb(tx->skb);
+		else
+			__skb_queue_purge(&tx->skbs);
 		return -1;
 	} else if (unlikely(res == TX_QUEUED)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_queued);
@@ -1364,7 +1363,7 @@ static bool ieee80211_tx(struct ieee8021
 	info->band = tx.channel->band;
 
 	if (!invoke_tx_handlers(&tx))
-		result = __ieee80211_tx(local, &tx.skb, tx.sta, txpending);
+		result = __ieee80211_tx(local, &tx.skbs, tx.sta, txpending);
  out:
 	rcu_read_unlock();
 	return result;
@@ -2112,10 +2111,15 @@ static bool ieee80211_tx_pending_skb(str
 	if (info->flags & IEEE80211_TX_INTFL_NEED_TXPROCESSING) {
 		result = ieee80211_tx(sdata, skb, true);
 	} else {
+		struct sk_buff_head skbs;
+
+		__skb_queue_head_init(&skbs);
+		__skb_queue_tail(&skbs, skb);
+
 		hdr = (struct ieee80211_hdr *)skb->data;
 		sta = sta_info_get(sdata, hdr->addr1);
 
-		result = __ieee80211_tx(local, &skb, sta, true);
+		result = __ieee80211_tx(local, &skbs, sta, true);
 	}
 
 	return result;
--- a/net/mac80211/util.c	2011-11-16 15:19:36.000000000 +0100
+++ b/net/mac80211/util.c	2011-11-16 15:19:38.000000000 +0100
@@ -96,13 +96,13 @@ u8 *ieee80211_get_bssid(struct ieee80211
 
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 {
-	struct sk_buff *skb = tx->skb;
+	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
 
-	do {
+	skb_queue_walk(&tx->skbs, skb) {
 		hdr = (struct ieee80211_hdr *) skb->data;
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
-	} while ((skb = skb->next));
+	}
 }
 
 int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
--- a/net/mac80211/wep.c	2011-11-16 15:19:36.000000000 +0100
+++ b/net/mac80211/wep.c	2011-11-16 15:19:38.000000000 +0100
@@ -330,13 +330,12 @@ ieee80211_crypto_wep_encrypt(struct ieee
 
 	ieee80211_tx_set_protected(tx);
 
-	skb = tx->skb;
-	do {
+	skb_queue_walk(&tx->skbs, skb) {
 		if (wep_encrypt_skb(tx, skb) < 0) {
 			I802_DEBUG_INC(tx->local->tx_handlers_drop_wep);
 			return TX_DROP;
 		}
-	} while ((skb = skb->next));
+	}
 
 	return TX_CONTINUE;
 }
--- a/net/mac80211/wpa.c	2011-11-16 15:19:36.000000000 +0100
+++ b/net/mac80211/wpa.c	2011-11-16 15:19:38.000000000 +0100
@@ -223,14 +223,14 @@ static int tkip_encrypt_skb(struct ieee8
 ieee80211_tx_result
 ieee80211_crypto_tkip_encrypt(struct ieee80211_tx_data *tx)
 {
-	struct sk_buff *skb = tx->skb;
+	struct sk_buff *skb;
 
 	ieee80211_tx_set_protected(tx);
 
-	do {
+	skb_queue_walk(&tx->skbs, skb) {
 		if (tkip_encrypt_skb(tx, skb) < 0)
 			return TX_DROP;
-	} while ((skb = skb->next));
+	}
 
 	return TX_CONTINUE;
 }
@@ -449,14 +449,14 @@ static int ccmp_encrypt_skb(struct ieee8
 ieee80211_tx_result
 ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx)
 {
-	struct sk_buff *skb = tx->skb;
+	struct sk_buff *skb;
 
 	ieee80211_tx_set_protected(tx);
 
-	do {
+	skb_queue_walk(&tx->skbs, skb) {
 		if (ccmp_encrypt_skb(tx, skb) < 0)
 			return TX_DROP;
-	} while ((skb = skb->next));
+	}
 
 	return TX_CONTINUE;
 }
@@ -554,15 +554,22 @@ static inline void bip_ipn_swap(u8 *d, c
 ieee80211_tx_result
 ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx)
 {
-	struct sk_buff *skb = tx->skb;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_mmie *mmie;
 	u8 aad[20];
 	u64 pn64;
 
+	if (WARN_ON(skb_queue_len(&tx->skbs) != 1))
+		return TX_DROP;
+
+	skb = skb_peek(&tx->skbs);
+
+	info = IEEE80211_SKB_CB(skb);
+
 	if (info->control.hw_key)
-		return 0;
+		return TX_CONTINUE;
 
 	if (WARN_ON(skb_tailroom(skb) < sizeof(*mmie)))
 		return TX_DROP;


