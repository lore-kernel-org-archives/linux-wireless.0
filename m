Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651946;
	b=xEIj/TQUrCe7C8XeTAohW1dhOMjja3PAW6UvRKhHEF77pLaStx9fJzgPsjtzRXxWABfH
	 ehEEP1nPWgcRU1dGztx94OyKlLkyfxIOSJulRBDXbnUm+xvWWs+wll2hl37L7/md6ylxQ
	 wRt2Wx62Y88iqlY7dTRdGofxI3MDDiTcW5wT/hyKJ88BkUGH9ygkATfIWxXEDW/Fd825G
	 b1ANIslmLZOtVS/5w6M0W7zdHbJnAHbYgFh/PdpBuV+Ll2KhipBoJSCB2lDIhrSd7A8JF
	 D8VwQeJPXoFdlgp/b4ofGnDC2AYuIhbnSW8M/P54AhmX3CvWeOJq1Iohl0q0vmKYPwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651946;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=NTO9GxwA5xEIBAxx3J49TLczxngJlh42wNXmgnyeDas=;
	b=jNFHX57iWXV26MMzdOmSJKXm9gIU5nVbtU4cIp6LCyKJuk58G7+Yahu7XpGoZqBnsocd
	 ikR2m5Ri449SISCCS7dcIyRcKouMm8i++Lo/cbvq5YPcdkZkR12ShAa0sP+6PDSeyfklz
	 zA+0+wy/COgCBXpgPqVBrb8WskZMC1F+Lw20Sw0/FJYBUiCV0yUXG9zCPbFOiSTD2AklQ
	 tsQEwoqZ/EBNTK+96Renuqnzg4QUIJMAGeSgFhfXJA1inVpqpG/l3xwz5VCb8+aXyz9A5
	 /37P7G9xd1bLUVAkYC9/QPyxYRmG+4gMEkt5+F0xfs4rpEdwJv9unHkgWlOH/q4aupQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=UkBM7kLE;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4516082BF0
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=UkBM7kLE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NTO9GxwA5xEIBAxx3J49TLczxngJlh42wNXmgnyeDas=;
	t=1793651946; x=1794861546; b=UkBM7kLEj62Z73kAM2+96wukSUy2A58pOsLZej+IkTBzEmX
	ZPreXTcnNbTSj+xS+S/0DLie/TnRxSPXZ/xUBRkWUd6K8c4HoLobNt6O7QY9HxcUf/3C1nzkqRVP4
	MTstAhP42nUBwYy8cB5/gB5GDjg2YzhKv10Hs9T3K0SJfVYhmA5nkkaVzpNWtSSp/v6Sc/Of9vyE5
	B44EMwF/VcC+wClaQFmu83IBksIJtBm1Wfc18HZD1+/UCD9RsMjqSIHeRrnJQfy5+2CKe0al/O11m
	++0TWVMR1XBNObYNQC2kOwV/96GBzIC+iJx8dvQFcYkQOMsKdIEpG8jem75NshdQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyo4-00000001vzr-06aT;
	Mon, 02 Nov 2026 21:39:04 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 26/30] wifi: mac80211: build A-MSDUs at dequeue
Date: Mon,  2 Nov 2026 21:23:16 +0100
Message-ID: <20261102203831.1058362-58-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Now that fast-xmit frames sit on the TXQ in ethernet
format, we can build A-MSDUs on dequeue. This way we
get better reactivity to link conditions that must be
taken into account for A-MSDU size, etc.

As before, only frames of a single flow are aggregated,
changing this would add additional complexity for how
codel operates.

With this, we might be able to relax the minstrel cap
on A-MSDU sizes, but that needs further investigation.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 291 ++++++++++++++++++++++------------------------
 1 file changed, 136 insertions(+), 155 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index fbe77131799d..57b67774f527 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3554,7 +3554,7 @@ static bool ieee80211_amsdu_realloc_pad(struct ieee80211_local *local,
 }
 
 static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_fast_tx *fast_tx,
+					 const struct ieee80211_fast_tx *fast_tx,
 					 struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -3620,152 +3620,6 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
 	return true;
 }
 
-static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
-				      struct sta_info *sta,
-				      struct ieee80211_fast_tx *fast_tx,
-				      struct sk_buff *skb,
-				      const u8 *da, const u8 *sa)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct fq *fq = &local->fq;
-	struct fq_tin *tin;
-	struct fq_flow *flow;
-	u8 tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
-	struct ieee80211_txq *txq = sta->sta.txq[tid];
-	struct txq_info *txqi;
-	struct sk_buff **frag_tail, *head;
-	int subframe_len = skb->len - ETH_ALEN;
-	u8 max_subframes = sta->sta.max_amsdu_subframes;
-	int max_frags = local->hw.max_tx_fragments;
-	int max_amsdu_len = sta->sta.cur->max_amsdu_len;
-	int orig_truesize;
-	u32 flow_idx;
-	__be16 len;
-	void *data;
-	bool ret = false;
-	unsigned int orig_len;
-	int n = 2, nfrags, pad = 0;
-	u16 hdrlen;
-
-	if (!ieee80211_hw_check(&local->hw, TX_AMSDU))
-		return false;
-
-	if (sdata->vif.offload_flags & IEEE80211_OFFLOAD_ENCAP_ENABLED)
-		return false;
-
-	if (ieee80211_vif_is_mesh(&sdata->vif))
-		return false;
-
-	if (skb_is_gso(skb))
-		return false;
-
-	if (!txq)
-		return false;
-
-	txqi = to_txq_info(txq);
-	if (test_bit(IEEE80211_TXQ_NO_AMSDU, &txqi->flags))
-		return false;
-
-	if (sta->sta.cur->max_rc_amsdu_len)
-		max_amsdu_len = min_t(int, max_amsdu_len,
-				      sta->sta.cur->max_rc_amsdu_len);
-
-	if (sta->sta.cur->max_tid_amsdu_len[tid])
-		max_amsdu_len = min_t(int, max_amsdu_len,
-				      sta->sta.cur->max_tid_amsdu_len[tid]);
-
-	flow_idx = fq_flow_idx(fq, skb);
-
-	spin_lock_bh(&fq->lock);
-
-	/* TODO: Ideally aggregation should be done on dequeue to remain
-	 * responsive to environment changes.
-	 */
-
-	tin = &txqi->tin;
-	flow = fq_flow_classify(fq, tin, flow_idx, skb);
-	head = skb_peek_tail(&flow->queue);
-	if (!head || skb_is_gso(head))
-		goto out;
-
-	orig_truesize = head->truesize;
-	orig_len = head->len;
-
-	if (skb->len + head->len > max_amsdu_len)
-		goto out;
-
-	nfrags = 1 + skb_shinfo(skb)->nr_frags;
-	nfrags += 1 + skb_shinfo(head)->nr_frags;
-	frag_tail = &skb_shinfo(head)->frag_list;
-	while (*frag_tail) {
-		nfrags += 1 + skb_shinfo(*frag_tail)->nr_frags;
-		frag_tail = &(*frag_tail)->next;
-		n++;
-	}
-
-	if (max_subframes && n > max_subframes)
-		goto out;
-
-	if (max_frags && nfrags > max_frags)
-		goto out;
-
-	if (!drv_can_aggregate_in_amsdu(local, head, skb))
-		goto out;
-
-	if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
-		goto out;
-
-	/* If n == 2, the "while (*frag_tail)" loop above didn't execute
-	 * and  frag_tail should be &skb_shinfo(head)->frag_list.
-	 * However, ieee80211_amsdu_prepare_head() can reallocate it.
-	 * Reload frag_tail to have it pointing to the correct place.
-	 */
-	if (n == 2)
-		frag_tail = &skb_shinfo(head)->frag_list;
-
-	/*
-	 * Pad out the previous subframe to a multiple of 4 by adding the
-	 * padding to the next one, that's being added. Note that head->len
-	 * is the length of the full A-MSDU, but that works since each time
-	 * we add a new subframe we pad out the previous one to a multiple
-	 * of 4 and thus it no longer matters in the next round.
-	 */
-	hdrlen = fast_tx->hdr_len - sizeof(rfc1042_header);
-	if ((head->len - hdrlen) & 3)
-		pad = 4 - ((head->len - hdrlen) & 3);
-
-	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(rfc1042_header) +
-						     2 + pad))
-		goto out_recalc;
-
-	ret = true;
-	data = skb_push(skb, ETH_ALEN + 2);
-	ether_addr_copy(data, da);
-	ether_addr_copy(data + ETH_ALEN, sa);
-
-	data += 2 * ETH_ALEN;
-	len = cpu_to_be16(subframe_len);
-	memcpy(data, &len, 2);
-	memcpy(data + 2, rfc1042_header, sizeof(rfc1042_header));
-
-	memset(skb_push(skb, pad), 0, pad);
-
-	head->len += skb->len;
-	head->data_len += skb->len;
-	*frag_tail = skb;
-
-out_recalc:
-	fq->memory_usage += head->truesize - orig_truesize;
-	if (head->len != orig_len) {
-		flow->backlog += head->len - orig_len;
-		tin->backlog_bytes += head->len - orig_len;
-	}
-out:
-	spin_unlock_bh(&fq->lock);
-
-	return ret;
-}
-
 /*
  * Can be called while the sta lock is held. Anything that can cause packets to
  * be generated will cause deadlock!
@@ -3929,7 +3783,6 @@ void __ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 			   const u8 *da, const u8 *sa)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_hdr *hdr = (void *)fast_tx->hdr;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
@@ -3938,10 +3791,6 @@ void __ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (unlikely(!skb))
 		return;
 
-	if ((hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) &&
-	    ieee80211_amsdu_aggregate(sdata, sta, fast_tx, skb, da, sa))
-		return;
-
 	if (ieee80211_fast_tx_encap(sdata, fast_tx, skb, da, sa))
 		goto free;
 
@@ -4134,7 +3983,135 @@ static void ieee80211_txq_mcast_ps(struct ieee80211_local *local,
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
 }
 
-static int ieee80211_txq_build_hdr(struct ieee80211_tx_data *tx)
+static bool ieee80211_amsdu_subframe(struct ieee80211_local *local,
+				     struct sk_buff *skb, int prev_len)
+{
+	__be16 len = cpu_to_be16(skb->len - ETH_ALEN);
+	int pad = (4 - (prev_len & 3)) & 3;
+	struct ethhdr eth;
+	void *data;
+
+	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(rfc1042_header) +
+						     2 + pad))
+		return false;
+
+	memcpy(&eth, skb->data, ETH_HLEN - 2);
+
+	data = skb_push(skb, sizeof(rfc1042_header) + 2);
+	ether_addr_copy(data, eth.h_dest);
+	ether_addr_copy(data + ETH_ALEN, eth.h_source);
+	memcpy(data + 2 * ETH_ALEN, &len, 2);
+	memcpy(data + ETH_HLEN, rfc1042_header, sizeof(rfc1042_header));
+
+	memset(skb_push(skb, pad), 0, pad);
+
+	return true;
+}
+
+static void ieee80211_tx_build_amsdu(const struct ieee80211_tx_data *tx,
+				     const struct txq_info *txqi,
+				     struct fq_flow *flow,
+				     const struct ieee80211_fast_tx *fast_tx)
+{
+	int hdrlen = fast_tx->hdr_len - sizeof(rfc1042_header);
+	struct ieee80211_hdr *hdr = (void *)fast_tx->hdr;
+	struct ieee80211_local *local = tx->local;
+	struct sta_info *sta = tx->sta;
+	struct sk_buff *head = tx->skb;
+	struct fq *fq = &local->fq;
+	struct sk_buff **frag_tail;
+	int max_frags = local->hw.max_tx_fragments;
+	u8 max_subframes = sta->sta.max_amsdu_subframes;
+	int max_amsdu_len = sta->sta.cur->max_amsdu_len;
+	int n = 1, nfrags, len;
+	u8 tid = txqi->txq.tid;
+
+	if (!flow || !ieee80211_hw_check(&local->hw, TX_AMSDU) ||
+	    !(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) ||
+	    test_bit(IEEE80211_TXQ_NO_AMSDU, &txqi->flags) ||
+	    skb_is_gso(head))
+		return;
+
+	if (sta->sta.cur->max_rc_amsdu_len)
+		max_amsdu_len = min_t(int, max_amsdu_len,
+				      sta->sta.cur->max_rc_amsdu_len);
+
+	if (sta->sta.cur->max_tid_amsdu_len[tid])
+		max_amsdu_len = min_t(int, max_amsdu_len,
+				      sta->sta.cur->max_tid_amsdu_len[tid]);
+
+	/* the head will get an A-MSDU subframe header */
+	len = head->len + ETH_HLEN;
+	nfrags = 1 + skb_shinfo(head)->nr_frags;
+	frag_tail = &skb_shinfo(head)->frag_list;
+
+	spin_lock_bh(&fq->lock);
+
+	/* the flow may have been reused while the lock was released */
+	if (flow->tin != &txqi->tin)
+		goto out;
+
+	while (*frag_tail) {
+		nfrags += 1 + skb_shinfo(*frag_tail)->nr_frags;
+		frag_tail = &(*frag_tail)->next;
+		n++;
+	}
+
+	while (1) {
+		struct sk_buff *skb = skb_peek(&flow->queue);
+		int pad = (4 - ((len - hdrlen) & 3)) & 3;
+		struct ieee80211_tx_info *info;
+
+		if (!skb)
+			break;
+
+		info = IEEE80211_SKB_CB(skb);
+		if (!(info->flags & IEEE80211_TX_INTFL_NEED_80211_ENCAP) ||
+		    !(info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) ||
+		    skb_is_gso(skb))
+			break;
+
+		if (len + pad + skb->len + sizeof(rfc1042_header) + 2 >
+		    max_amsdu_len)
+			break;
+
+		if (max_subframes && n + 1 > max_subframes)
+			break;
+
+		if (max_frags &&
+		    nfrags + 1 + skb_shinfo(skb)->nr_frags > max_frags)
+			break;
+
+		if (!drv_can_aggregate_in_amsdu(local, head, skb))
+			break;
+
+		if (!ieee80211_amsdu_prepare_head(tx->sdata, fast_tx, head))
+			break;
+
+		skb = fq_flow_dequeue_next(fq, flow);
+
+		if (!ieee80211_amsdu_subframe(local, skb, len - hdrlen)) {
+			ieee80211_free_txskb(&local->hw, skb);
+			break;
+		}
+
+		len += skb->len;
+		nfrags += 1 + skb_shinfo(skb)->nr_frags;
+		n++;
+
+		head->len += skb->len;
+		head->data_len += skb->len;
+		*frag_tail = skb;
+		frag_tail = &skb->next;
+	}
+
+out:
+	spin_unlock_bh(&fq->lock);
+}
+
+static int ieee80211_txq_build_hdr(struct ieee80211_tx_data *tx,
+				   const struct txq_info *txqi,
+				   struct fq_flow *flow)
 {
 	const struct ieee80211_fast_tx *fast_tx;
 	struct sk_buff *skb = tx->skb;
@@ -4151,6 +4128,7 @@ static int ieee80211_txq_build_hdr(struct ieee80211_tx_data *tx)
 			ieee80211_free_txskb(&tx->local->hw, skb);
 			return -ENOMEM;
 		}
+		ieee80211_tx_build_amsdu(tx, txqi, flow, fast_tx);
 		return 0;
 	}
 
@@ -4177,6 +4155,7 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	struct sk_buff *skb = NULL;
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
+	struct fq_flow *flow;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
@@ -4210,6 +4189,8 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
 	spin_lock_bh(&fq->lock);
 
+	flow = NULL;
+
 	/* Make sure fragments stay together. */
 	skb = __skb_dequeue(&txqi->frags);
 	if (unlikely(skb)) {
@@ -4222,7 +4203,7 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		if (unlikely(test_bit(IEEE80211_TXQ_STOP, &txqi->flags)))
 			goto out;
 
-		skb = fq_tin_dequeue(fq, tin, fq_tin_dequeue_func, NULL);
+		skb = fq_tin_dequeue(fq, tin, fq_tin_dequeue_func, &flow);
 	}
 
 	if (!skb)
@@ -4277,7 +4258,7 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	/* the fast-xmit check here distinguishes from HW offload */
 	if (info->flags & IEEE80211_TX_INTFL_NEED_80211_ENCAP &&
 	    info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {
-		if (ieee80211_txq_build_hdr(&tx))
+		if (ieee80211_txq_build_hdr(&tx, txqi, flow))
 			goto begin;
 		skb = tx.skb;
 		hdr = (struct ieee80211_hdr *)skb->data;
-- 
2.56.0

