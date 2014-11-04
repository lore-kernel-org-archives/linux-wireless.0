Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:57639 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaKDOeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 09:34:24 -0500
Received: by mail-lb0-f179.google.com with SMTP id l4so4536001lbv.38
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 06:34:22 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/7] ath10k: start using sk_buff_head
Date: Tue,  4 Nov 2014 15:22:05 +0100
Message-Id: <1415110931-10945-2-git-send-email-michal.kazior@tieto.com> (sfid-20141104_153427_983647_C9FE6C72)
In-Reply-To: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using manual sk_buff linking via ->next
use sk_buff_head. It's more robust, cleaner and
there's plenty of helper functions in kernel
already to manage sk_buff_head.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 213 +++++++++++++------------------
 1 file changed, 91 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a691fdf..85f11e6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -303,27 +303,15 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 	return msdu;
 }
 
-static void ath10k_htt_rx_free_msdu_chain(struct sk_buff *skb)
-{
-	struct sk_buff *next;
-
-	while (skb) {
-		next = skb->next;
-		dev_kfree_skb_any(skb);
-		skb = next;
-	}
-}
-
 /* return: < 0 fatal error, 0 - non chained msdu, 1 chained msdu */
 static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 				   u8 **fw_desc, int *fw_desc_len,
-				   struct sk_buff **head_msdu,
-				   struct sk_buff **tail_msdu,
+				   struct sk_buff_head *amsdu,
 				   u32 *attention)
 {
 	struct ath10k *ar = htt->ar;
 	int msdu_len, msdu_chaining = 0;
-	struct sk_buff *msdu, *next;
+	struct sk_buff *msdu;
 	struct htt_rx_desc *rx_desc;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
@@ -333,10 +321,19 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		return -1;
 	}
 
-	msdu = *head_msdu = ath10k_htt_rx_netbuf_pop(htt);
-	while (msdu) {
+	for (;;) {
 		int last_msdu, msdu_len_invalid, msdu_chained;
 
+		msdu = ath10k_htt_rx_netbuf_pop(htt);
+		if (!msdu) {
+			ath10k_err(ar, "failed to pop msdu\n");
+			__skb_queue_purge(amsdu);
+			htt->rx_confused = true;
+			break;
+		}
+
+		__skb_queue_tail(amsdu, msdu);
+
 		rx_desc = (struct htt_rx_desc *)msdu->data;
 
 		/* FIXME: we must report msdu payload since this is what caller
@@ -354,10 +351,8 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		 */
 		if (!(__le32_to_cpu(rx_desc->attention.flags)
 				& RX_ATTENTION_FLAGS_MSDU_DONE)) {
-			ath10k_htt_rx_free_msdu_chain(*head_msdu);
-			*head_msdu = NULL;
-			msdu = NULL;
-			ath10k_err(ar, "htt rx stopped. cannot recover\n");
+			ath10k_err(ar, "popped an incomplete msdu\n");
+			__skb_queue_purge(amsdu);
 			htt->rx_confused = true;
 			break;
 		}
@@ -423,25 +418,20 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		skb_put(msdu, min(msdu_len, HTT_RX_MSDU_SIZE));
 		msdu_len -= msdu->len;
 
-		/* FIXME: Do chained buffers include htt_rx_desc or not? */
+		/* Note: Chained buffers do not contain rx descriptor */
 		while (msdu_chained--) {
-			struct sk_buff *next = ath10k_htt_rx_netbuf_pop(htt);
-
-			if (!next) {
+			msdu = ath10k_htt_rx_netbuf_pop(htt);
+			if (!msdu) {
 				ath10k_warn(ar, "failed to pop chained msdu\n");
-				ath10k_htt_rx_free_msdu_chain(*head_msdu);
-				*head_msdu = NULL;
-				msdu = NULL;
+				__skb_queue_purge(amsdu);
 				htt->rx_confused = true;
 				break;
 			}
 
-			skb_trim(next, 0);
-			skb_put(next, min(msdu_len, HTT_RX_BUF_SIZE));
-			msdu_len -= next->len;
-
-			msdu->next = next;
-			msdu = next;
+			__skb_queue_tail(amsdu, msdu);
+			skb_trim(msdu, 0);
+			skb_put(msdu, min(msdu_len, HTT_RX_BUF_SIZE));
+			msdu_len -= msdu->len;
 			msdu_chaining = 1;
 		}
 
@@ -450,18 +440,12 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 
 		trace_ath10k_htt_rx_desc(ar, &rx_desc->attention,
 					 sizeof(*rx_desc) - sizeof(u32));
-		if (last_msdu) {
-			msdu->next = NULL;
-			break;
-		}
 
-		next = ath10k_htt_rx_netbuf_pop(htt);
-		msdu->next = next;
-		msdu = next;
+		if (last_msdu)
+			break;
 	}
-	*tail_msdu = msdu;
 
-	if (*head_msdu == NULL)
+	if (skb_queue_empty(amsdu))
 		msdu_chaining = -1;
 
 	/*
@@ -915,11 +899,11 @@ static int ath10k_htt_rx_nwifi_hdrlen(struct ieee80211_hdr *hdr)
 
 static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 				struct ieee80211_rx_status *rx_status,
-				struct sk_buff *skb_in)
+				struct sk_buff_head *amsdu)
 {
 	struct ath10k *ar = htt->ar;
 	struct htt_rx_desc *rxd;
-	struct sk_buff *skb = skb_in;
+	struct sk_buff *skb;
 	struct sk_buff *first;
 	enum rx_msdu_decap_format fmt;
 	enum htt_rx_mpdu_encrypt_type enctype;
@@ -927,7 +911,9 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 	u8 hdr_buf[64], da[ETH_ALEN], sa[ETH_ALEN], *qos;
 	unsigned int hdr_len;
 
-	rxd = (void *)skb->data - sizeof(*rxd);
+	first = skb_peek(amsdu);
+
+	rxd = (void *)first->data - sizeof(*rxd);
 	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
 		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
 
@@ -936,8 +922,7 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 	memcpy(hdr_buf, hdr, hdr_len);
 	hdr = (struct ieee80211_hdr *)hdr_buf;
 
-	first = skb;
-	while (skb) {
+	while ((skb = __skb_dequeue(amsdu))) {
 		void *decap_hdr;
 		int len;
 
@@ -1005,18 +990,15 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 			break;
 		}
 
-		skb_in = skb;
-		ath10k_htt_rx_h_protected(htt, rx_status, skb_in, enctype, fmt,
+		ath10k_htt_rx_h_protected(htt, rx_status, skb, enctype, fmt,
 					  false);
-		skb = skb->next;
-		skb_in->next = NULL;
 
-		if (skb)
-			rx_status->flag |= RX_FLAG_AMSDU_MORE;
-		else
+		if (skb_queue_empty(amsdu))
 			rx_status->flag &= ~RX_FLAG_AMSDU_MORE;
+		else
+			rx_status->flag |= RX_FLAG_AMSDU_MORE;
 
-		ath10k_process_rx(htt->ar, rx_status, skb_in);
+		ath10k_process_rx(htt->ar, rx_status, skb);
 	}
 
 	/* FIXME: It might be nice to re-assemble the A-MSDU when there's a
@@ -1035,13 +1017,6 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt,
 	int hdr_len;
 	void *rfc1042;
 
-	/* This shouldn't happen. If it does than it may be a FW bug. */
-	if (skb->next) {
-		ath10k_warn(ar, "htt rx received chained non A-MSDU frame\n");
-		ath10k_htt_rx_free_msdu_chain(skb->next);
-		skb->next = NULL;
-	}
-
 	rxd = (void *)skb->data - sizeof(*rxd);
 	fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
 		 RX_MSDU_START_INFO1_DECAP_FORMAT);
@@ -1127,10 +1102,9 @@ static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
 	return CHECKSUM_UNNECESSARY;
 }
 
-static int ath10k_unchain_msdu(struct sk_buff *msdu_head)
+static int ath10k_unchain_msdu(struct sk_buff_head *amsdu)
 {
-	struct sk_buff *next = msdu_head->next;
-	struct sk_buff *to_free = next;
+	struct sk_buff *skb, *first;
 	int space;
 	int total_len = 0;
 
@@ -1141,40 +1115,33 @@ static int ath10k_unchain_msdu(struct sk_buff *msdu_head)
 	 * skb?
 	 */
 
-	msdu_head->next = NULL;
+	first = __skb_dequeue(amsdu);
 
 	/* Allocate total length all at once. */
-	while (next) {
-		total_len += next->len;
-		next = next->next;
-	}
+	skb_queue_walk(amsdu, skb)
+		total_len += skb->len;
 
-	space = total_len - skb_tailroom(msdu_head);
+	space = total_len - skb_tailroom(first);
 	if ((space > 0) &&
-	    (pskb_expand_head(msdu_head, 0, space, GFP_ATOMIC) < 0)) {
+	    (pskb_expand_head(first, 0, space, GFP_ATOMIC) < 0)) {
 		/* TODO:  bump some rx-oom error stat */
 		/* put it back together so we can free the
 		 * whole list at once.
 		 */
-		msdu_head->next = to_free;
+		__skb_queue_head(amsdu, first);
 		return -1;
 	}
 
 	/* Walk list again, copying contents into
 	 * msdu_head
 	 */
-	next = to_free;
-	while (next) {
-		skb_copy_from_linear_data(next, skb_put(msdu_head, next->len),
-					  next->len);
-		next = next->next;
+	while ((skb = __skb_dequeue(amsdu))) {
+		skb_copy_from_linear_data(skb, skb_put(first, skb->len),
+					  skb->len);
+		dev_kfree_skb_any(skb);
 	}
 
-	/* If here, we have consolidated skb.  Free the
-	 * fragments and pass the main skb on up the
-	 * stack.
-	 */
-	ath10k_htt_rx_free_msdu_chain(to_free);
+	__skb_queue_head(amsdu, first);
 	return 0;
 }
 
@@ -1223,6 +1190,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	struct ath10k *ar = htt->ar;
 	struct ieee80211_rx_status *rx_status = &htt->rx_status;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
+	struct sk_buff_head amsdu;
 	struct ieee80211_hdr *hdr;
 	int num_mpdu_ranges;
 	u32 attention;
@@ -1271,35 +1239,28 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 
 	for (i = 0; i < num_mpdu_ranges; i++) {
 		for (j = 0; j < mpdu_ranges[i].mpdu_count; j++) {
-			struct sk_buff *msdu_head, *msdu_tail;
-
 			attention = 0;
-			msdu_head = NULL;
-			msdu_tail = NULL;
-			ret = ath10k_htt_rx_amsdu_pop(htt,
-						      &fw_desc,
-						      &fw_desc_len,
-						      &msdu_head,
-						      &msdu_tail,
+			__skb_queue_head_init(&amsdu);
+			ret = ath10k_htt_rx_amsdu_pop(htt, &fw_desc,
+						      &fw_desc_len, &amsdu,
 						      &attention);
 
 			if (ret < 0) {
 				ath10k_warn(ar, "failed to pop amsdu from htt rx ring %d\n",
 					    ret);
-				ath10k_htt_rx_free_msdu_chain(msdu_head);
+				__skb_queue_purge(&amsdu);
 				continue;
 			}
 
-			if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
+			if (!ath10k_htt_rx_amsdu_allowed(htt, skb_peek(&amsdu),
 							 channel_set,
 							 attention)) {
-				ath10k_htt_rx_free_msdu_chain(msdu_head);
+				__skb_queue_purge(&amsdu);
 				continue;
 			}
 
-			if (ret > 0 &&
-			    ath10k_unchain_msdu(msdu_head) < 0) {
-				ath10k_htt_rx_free_msdu_chain(msdu_head);
+			if (ret > 0 && ath10k_unchain_msdu(&amsdu) < 0) {
+				__skb_queue_purge(&amsdu);
 				continue;
 			}
 
@@ -1313,12 +1274,13 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			else
 				rx_status->flag &= ~RX_FLAG_MMIC_ERROR;
 
-			hdr = ath10k_htt_rx_skb_get_hdr(msdu_head);
+			hdr = ath10k_htt_rx_skb_get_hdr(skb_peek(&amsdu));
 
 			if (ath10k_htt_rx_hdr_is_amsdu(hdr))
-				ath10k_htt_rx_amsdu(htt, rx_status, msdu_head);
+				ath10k_htt_rx_amsdu(htt, rx_status, &amsdu);
 			else
-				ath10k_htt_rx_msdu(htt, rx_status, msdu_head);
+				ath10k_htt_rx_msdu(htt, rx_status,
+						   __skb_dequeue(&amsdu));
 		}
 	}
 
@@ -1329,12 +1291,13 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 				       struct htt_rx_fragment_indication *frag)
 {
 	struct ath10k *ar = htt->ar;
-	struct sk_buff *msdu_head, *msdu_tail;
+	struct sk_buff *msdu;
 	enum htt_rx_mpdu_encrypt_type enctype;
 	struct htt_rx_desc *rxd;
 	enum rx_msdu_decap_format fmt;
 	struct ieee80211_rx_status *rx_status = &htt->rx_status;
 	struct ieee80211_hdr *hdr;
+	struct sk_buff_head amsdu;
 	int ret;
 	bool tkip_mic_err;
 	bool decrypt_err;
@@ -1346,13 +1309,11 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	fw_desc_len = __le16_to_cpu(frag->fw_rx_desc_bytes);
 	fw_desc = (u8 *)frag->fw_msdu_rx_desc;
 
-	msdu_head = NULL;
-	msdu_tail = NULL;
+	__skb_queue_head_init(&amsdu);
 
 	spin_lock_bh(&htt->rx_ring.lock);
 	ret = ath10k_htt_rx_amsdu_pop(htt, &fw_desc, &fw_desc_len,
-				      &msdu_head, &msdu_tail,
-				      &attention);
+				      &amsdu, &attention);
 	spin_unlock_bh(&htt->rx_ring.lock);
 
 	tasklet_schedule(&htt->rx_replenish_task);
@@ -1362,15 +1323,23 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	if (ret) {
 		ath10k_warn(ar, "failed to pop amsdu from httr rx ring for fragmented rx %d\n",
 			    ret);
-		ath10k_htt_rx_free_msdu_chain(msdu_head);
+		__skb_queue_purge(&amsdu);
 		return;
 	}
 
+	if (skb_queue_len(&amsdu) != 1) {
+		ath10k_warn(ar, "failed to pop frag amsdu: too many msdus\n");
+		__skb_queue_purge(&amsdu);
+		return;
+	}
+
+	msdu = __skb_dequeue(&amsdu);
+
 	/* FIXME: implement signal strength */
 	rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
-	hdr = (struct ieee80211_hdr *)msdu_head->data;
-	rxd = (void *)msdu_head->data - sizeof(*rxd);
+	hdr = (struct ieee80211_hdr *)msdu->data;
+	rxd = (void *)msdu->data - sizeof(*rxd);
 	tkip_mic_err = !!(attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR);
 	decrypt_err = !!(attention & RX_ATTENTION_FLAGS_DECRYPT_ERR);
 	fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
@@ -1378,22 +1347,22 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 
 	if (fmt != RX_MSDU_DECAP_RAW) {
 		ath10k_warn(ar, "we dont support non-raw fragmented rx yet\n");
-		dev_kfree_skb_any(msdu_head);
+		dev_kfree_skb_any(msdu);
 		goto end;
 	}
 
 	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
 		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
-	ath10k_htt_rx_h_protected(htt, rx_status, msdu_head, enctype, fmt,
+	ath10k_htt_rx_h_protected(htt, rx_status, msdu, enctype, fmt,
 				  true);
-	msdu_head->ip_summed = ath10k_htt_rx_get_csum_state(msdu_head);
+	msdu->ip_summed = ath10k_htt_rx_get_csum_state(msdu);
 
 	if (tkip_mic_err)
 		ath10k_warn(ar, "tkip mic error\n");
 
 	if (decrypt_err) {
 		ath10k_warn(ar, "decryption err in fragmented rx\n");
-		dev_kfree_skb_any(msdu_head);
+		dev_kfree_skb_any(msdu);
 		goto end;
 	}
 
@@ -1402,11 +1371,11 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 		paramlen = ath10k_htt_rx_crypto_param_len(ar, enctype);
 
 		/* It is more efficient to move the header than the payload */
-		memmove((void *)msdu_head->data + paramlen,
-			(void *)msdu_head->data,
+		memmove((void *)msdu->data + paramlen,
+			(void *)msdu->data,
 			hdrlen);
-		skb_pull(msdu_head, paramlen);
-		hdr = (struct ieee80211_hdr *)msdu_head->data;
+		skb_pull(msdu, paramlen);
+		hdr = (struct ieee80211_hdr *)msdu->data;
 	}
 
 	/* remove trailing FCS */
@@ -1420,17 +1389,17 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	    enctype == HTT_RX_MPDU_ENCRYPT_TKIP_WPA)
 		trim += MICHAEL_MIC_LEN;
 
-	if (trim > msdu_head->len) {
+	if (trim > msdu->len) {
 		ath10k_warn(ar, "htt rx fragment: trailer longer than the frame itself? drop\n");
-		dev_kfree_skb_any(msdu_head);
+		dev_kfree_skb_any(msdu);
 		goto end;
 	}
 
-	skb_trim(msdu_head, msdu_head->len - trim);
+	skb_trim(msdu, msdu->len - trim);
 
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx frag mpdu: ",
-			msdu_head->data, msdu_head->len);
-	ath10k_process_rx(htt->ar, rx_status, msdu_head);
+			msdu->data, msdu->len);
+	ath10k_process_rx(htt->ar, rx_status, msdu);
 
 end:
 	if (fw_desc_len > 0) {
-- 
1.8.5.3

