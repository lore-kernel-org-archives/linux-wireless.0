Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbYEJWWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 18:22:17 -0400
Received: from [91.5.117.77] (helo=[10.0.0.127])
	by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1JuxSK-0000zS-12
	for linux-wireless@vger.kernel.org; Sun, 11 May 2008 00:22:16 +0200
Message-Id: <20080510221908.318968000@sipsolutions.net> (sfid-20080511_002229_056989_0A16D1D7)
References: <20080510221845.340428000@sipsolutions.net>
Date: Sun, 11 May 2008 00:18:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT/C 6/7] mac80211: reorder some transmit handlers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The next patch will require that transmit handlers that are after
fragmentation are aware of the fact that the control info is also
fragmented. To make that easier, this patch moves a number of
transmit handlers before fragmentation.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |  234 +++++++++++++++++++++++++++---------------------------
 1 file changed, 118 insertions(+), 116 deletions(-)

--- everything.orig/net/mac80211/tx.c	2008-05-10 23:07:45.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-05-10 23:10:27.000000000 +0200
@@ -506,106 +506,6 @@ ieee80211_tx_h_select_key(struct ieee802
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
-	size_t hdrlen, per_fragm, num_fragm, payload_len, left;
-	struct sk_buff **frags, *first, *frag;
-	int i;
-	u16 seq;
-	u8 *pos;
-	int frag_threshold = tx->local->fragmentation_threshold;
-
-	if (!(tx->flags & IEEE80211_TX_FRAGMENTED))
-		return TX_CONTINUE;
-
-	first = tx->skb;
-
-	hdrlen = ieee80211_get_hdrlen(tx->fc);
-	payload_len = first->len - hdrlen;
-	per_fragm = frag_threshold - hdrlen - FCS_LEN;
-	num_fragm = DIV_ROUND_UP(payload_len, per_fragm);
-
-	frags = kzalloc(num_fragm * sizeof(struct sk_buff *), GFP_ATOMIC);
-	if (!frags)
-		goto fail;
-
-	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
-	seq = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ;
-	pos = first->data + hdrlen + per_fragm;
-	left = payload_len - per_fragm;
-	for (i = 0; i < num_fragm - 1; i++) {
-		struct ieee80211_hdr *fhdr;
-		size_t copylen;
-
-		if (left <= 0)
-			goto fail;
-
-		/* reserve enough extra head and tail room for possible
-		 * encryption */
-		frag = frags[i] =
-			dev_alloc_skb(tx->local->tx_headroom +
-				      frag_threshold +
-				      IEEE80211_ENCRYPT_HEADROOM +
-				      IEEE80211_ENCRYPT_TAILROOM);
-		if (!frag)
-			goto fail;
-		/* Make sure that all fragments use the same priority so
-		 * that they end up using the same TX queue */
-		frag->priority = first->priority;
-		skb_reserve(frag, tx->local->tx_headroom +
-				  IEEE80211_ENCRYPT_HEADROOM);
-		fhdr = (struct ieee80211_hdr *) skb_put(frag, hdrlen);
-		memcpy(fhdr, first->data, hdrlen);
-		if (i == num_fragm - 2)
-			fhdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREFRAGS);
-		fhdr->seq_ctrl = cpu_to_le16(seq | ((i + 1) & IEEE80211_SCTL_FRAG));
-		copylen = left > per_fragm ? per_fragm : left;
-		memcpy(skb_put(frag, copylen), pos, copylen);
-
-		pos += copylen;
-		left -= copylen;
-	}
-	skb_trim(first, hdrlen + per_fragm);
-
-	tx->num_extra_frag = num_fragm - 1;
-	tx->extra_frag = frags;
-
-	return TX_CONTINUE;
-
- fail:
-	printk(KERN_DEBUG "%s: failed to fragment frame\n", tx->dev->name);
-	if (frags) {
-		for (i = 0; i < num_fragm - 1; i++)
-			if (frags[i])
-				dev_kfree_skb(frags[i]);
-		kfree(frags);
-	}
-	I802_DEBUG_INC(tx->local->tx_handlers_drop_fragment);
-	return TX_DROP;
-}
-
-static ieee80211_tx_result
-ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
-{
-	if (!tx->key)
-		return TX_CONTINUE;
-
-	switch (tx->key->conf.alg) {
-	case ALG_WEP:
-		return ieee80211_crypto_wep_encrypt(tx);
-	case ALG_TKIP:
-		return ieee80211_crypto_tkip_encrypt(tx);
-	case ALG_CCMP:
-		return ieee80211_crypto_ccmp_encrypt(tx);
-	}
-
-	/* not reached */
-	WARN_ON(1);
-	return TX_DROP;
-}
-
-static ieee80211_tx_result
 ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 {
 	struct rate_selection rsel;
@@ -747,26 +647,114 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 			control->rts_cts_rate_idx = 0;
 	}
 
-	if (tx->sta) {
+	if (tx->sta)
 		control->aid = tx->sta->aid;
-		tx->sta->tx_packets++;
-		tx->sta->tx_fragments++;
-		tx->sta->tx_bytes += tx->skb->len;
-		if (tx->extra_frag) {
-			int i;
-			tx->sta->tx_fragments += tx->num_extra_frag;
-			for (i = 0; i < tx->num_extra_frag; i++) {
-				tx->sta->tx_bytes +=
-					tx->extra_frag[i]->len;
-			}
-		}
+
+	return TX_CONTINUE;
+}
+
+static ieee80211_tx_result
+ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
+	size_t hdrlen, per_fragm, num_fragm, payload_len, left;
+	struct sk_buff **frags, *first, *frag;
+	int i;
+	u16 seq;
+	u8 *pos;
+	int frag_threshold = tx->local->fragmentation_threshold;
+
+	if (!(tx->flags & IEEE80211_TX_FRAGMENTED))
+		return TX_CONTINUE;
+
+	first = tx->skb;
+
+	hdrlen = ieee80211_get_hdrlen(tx->fc);
+	payload_len = first->len - hdrlen;
+	per_fragm = frag_threshold - hdrlen - FCS_LEN;
+	num_fragm = DIV_ROUND_UP(payload_len, per_fragm);
+
+	frags = kzalloc(num_fragm * sizeof(struct sk_buff *), GFP_ATOMIC);
+	if (!frags)
+		goto fail;
+
+	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
+	seq = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ;
+	pos = first->data + hdrlen + per_fragm;
+	left = payload_len - per_fragm;
+	for (i = 0; i < num_fragm - 1; i++) {
+		struct ieee80211_hdr *fhdr;
+		size_t copylen;
+
+		if (left <= 0)
+			goto fail;
+
+		/* reserve enough extra head and tail room for possible
+		 * encryption */
+		frag = frags[i] =
+			dev_alloc_skb(tx->local->tx_headroom +
+				      frag_threshold +
+				      IEEE80211_ENCRYPT_HEADROOM +
+				      IEEE80211_ENCRYPT_TAILROOM);
+		if (!frag)
+			goto fail;
+		/* Make sure that all fragments use the same priority so
+		 * that they end up using the same TX queue */
+		frag->priority = first->priority;
+		skb_reserve(frag, tx->local->tx_headroom +
+				  IEEE80211_ENCRYPT_HEADROOM);
+		fhdr = (struct ieee80211_hdr *) skb_put(frag, hdrlen);
+		memcpy(fhdr, first->data, hdrlen);
+		if (i == num_fragm - 2)
+			fhdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREFRAGS);
+		fhdr->seq_ctrl = cpu_to_le16(seq | ((i + 1) & IEEE80211_SCTL_FRAG));
+		copylen = left > per_fragm ? per_fragm : left;
+		memcpy(skb_put(frag, copylen), pos, copylen);
+
+		pos += copylen;
+		left -= copylen;
 	}
+	skb_trim(first, hdrlen + per_fragm);
+
+	tx->num_extra_frag = num_fragm - 1;
+	tx->extra_frag = frags;
 
 	return TX_CONTINUE;
+
+ fail:
+	printk(KERN_DEBUG "%s: failed to fragment frame\n", tx->dev->name);
+	if (frags) {
+		for (i = 0; i < num_fragm - 1; i++)
+			if (frags[i])
+				dev_kfree_skb(frags[i]);
+		kfree(frags);
+	}
+	I802_DEBUG_INC(tx->local->tx_handlers_drop_fragment);
+	return TX_DROP;
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_load_stats(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
+{
+	if (!tx->key)
+		return TX_CONTINUE;
+
+	switch (tx->key->conf.alg) {
+	case ALG_WEP:
+		return ieee80211_crypto_wep_encrypt(tx);
+	case ALG_TKIP:
+		return ieee80211_crypto_tkip_encrypt(tx);
+	case ALG_CCMP:
+		return ieee80211_crypto_ccmp_encrypt(tx);
+	}
+
+	/* not reached */
+	WARN_ON(1);
+	return TX_DROP;
+}
+
+static ieee80211_tx_result
+ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_local *local = tx->local;
 	struct sk_buff *skb = tx->skb;
@@ -822,6 +810,20 @@ ieee80211_tx_h_load_stats(struct ieee802
 		tx->sta->channel_use_raw += load;
 	tx->sdata->channel_use_raw += load;
 
+	if (tx->sta) {
+		tx->sta->tx_packets++;
+		tx->sta->tx_fragments++;
+		tx->sta->tx_bytes += tx->skb->len;
+		if (tx->extra_frag) {
+			int i;
+			tx->sta->tx_fragments += tx->num_extra_frag;
+			for (i = 0; i < tx->num_extra_frag; i++) {
+				tx->sta->tx_bytes +=
+					tx->extra_frag[i]->len;
+			}
+		}
+	}
+
 	return TX_CONTINUE;
 }
 
@@ -834,11 +836,11 @@ static ieee80211_tx_handler ieee80211_tx
 	ieee80211_tx_h_ps_buf,
 	ieee80211_tx_h_select_key,
 	ieee80211_tx_h_michael_mic_add,
-	ieee80211_tx_h_fragment,
-	ieee80211_tx_h_encrypt,
 	ieee80211_tx_h_rate_ctrl,
 	ieee80211_tx_h_misc,
-	ieee80211_tx_h_load_stats,
+	ieee80211_tx_h_fragment,
+	ieee80211_tx_h_encrypt,
+	ieee80211_tx_h_stats,
 	NULL
 };
 

-- 

