Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651932;
	b=UMAcopG+tgce92GQQBVOureALK0pdVWquAJdro0M1uWTAB6Y1+cXI4O71UFJooHvEfhd
	 oje9Qv/dnxcoc3cNPbHU9QPGA0uv8ETDxDHIW55CRwtXaSlnwsqks24fwS3t4PHfIUqy/
	 /godDCZ/4WaGP7MyG9Z18Wzx4Dnz4mMw98Z/PTpLr8+tBijU5A75wdrNpYipx81PzkJuB
	 QejXT+KP7gcFf96btQjgN7wILHZdhkeK+ynFpKGkc/Clf5cxXZKp5GADpDEi+j80tdAvV
	 Z7ZbDNSyDdKdqMmNsMJ9R1sgUZyPngZkfEbhVH/gm6oatNMabczkaGQLlN2FSMfXQng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651932;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=uEtY4djUW1xnN+hZjtOz7Bvak/gO3Vuyy82N5m0TqDw=;
	b=Ee+LUNien22l2zGFtNb+Wo5vQElrfih4zSQ1dEGdUivVA6e4ptehFYpUS4uA4UxWviLe
	 wG3dMZoc6/I5NlHMnoF+fyt5L8kJJV+i3aP68C6upRyCzoqWCcDOAsnlmsv1xTzfEyMj8
	 73lGPyXSM3G5lzCqZ0vXg+aLsbO1HHsyyelBL60ux2D1WVkeyAWdYZAQmvaRFku/swmow
	 z+ph/KIz0uhwBV1YKSxRXAUOaYVkvWaNHv0piM1We4jQM+ucYsESooMN1zhm5iJqMTEEx
	 Oq2VDcJvyhs5u0aPFwTvxCXMXCaEIOm8I+kwg1D5h8KM5i/aiOaVpfvKrpApw30JAUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=TqPrxmYs;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA52F606EEAF
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=TqPrxmYs
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=uEtY4djUW1xnN+hZjtOz7Bvak/gO3Vuyy82N5m0TqDw=;
	t=1793651931; x=1794861531; b=TqPrxmYseWxlUGnxQGGMNv2opsk9lymi1GuGnXDHf53wGQg
	fiPLZ1S3HdBCvqZ+vedlLc9/ReLSoo967M5o77o8b3pbw2V6/RiUWWxJwcLFA/+sNa3lokWrIgRLQ
	1XzkSUJ7mdXhWFmha9gNfr/x0N7mMF+DVAFC5gpaSjsV0s0cix8pjgFeoOqeVf6fu0Nt6lowu3jeQ
	3Wo7mwcoMgoY6ujWXnmFzeo4+lGG90zqQgzuZMrEq2ATsaOp04czeulZIxSqz46CZY/k2bMcD1wEo
	ffZ//lxafftjc8kIJ8WysNqz8F3h/K6dG+jtg0HpeoEEmyoj0vRK7xMKlmQp6VRw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyno-00000001vzr-4ByV;
	Mon, 02 Nov 2026 21:38:49 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 14/30] wifi: mac80211: put filtered data frames back on TXQs
Date: Mon,  2 Nov 2026 21:23:04 +0100
Message-ID: <20261102203831.1058362-46-johannes@sipsolutions.net>
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

When a device filters frames because the station went to
sleep, we put them back on tx_filtered or pending queues.
This can mix up ordering between TXQs and filtered frames
when the station wakes up again later.

Put filtered frames onto the frags queue of the TXQ they
came from, fixing the order and simplifying the queueing
structure in mac80211.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ht.c          |  5 ++++
 net/mac80211/ieee80211_i.h |  5 +++-
 net/mac80211/sta_info.c    | 52 +++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h    |  4 ++-
 net/mac80211/status.c      | 54 +++++++++++++++++++++++++++++++++++++-
 net/mac80211/tx.c          | 37 ++++++++++++++++++++++++++
 6 files changed, 153 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index c5c2113fa4f7..e26d12659942 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -372,6 +372,11 @@ void ieee80211_ba_session_work(struct wiphy *wiphy, struct wiphy_work *work)
 			/* Allow only frags to be dequeued */
 			set_bit(IEEE80211_TXQ_STOP, &txqi->flags);
 
+			/*
+			 * Fragments and filtered frames (which already have a
+			 * sequence number) must be out before aggregation
+			 * starts, otherwise they'd be sent as part of it.
+			 */
 			if (!skb_queue_empty(&txqi->frags)) {
 				/* Fragmented Tx is ongoing, wait for it to
 				 * finish. Reschedule worker to retry later.
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cb947341fee6..4a9b68022250 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -987,7 +987,8 @@ enum txq_info_flags {
  * @tin: contains packets split into multiple flows
  * @def_cvars: codel vars for the @tin's default_flow
  * @cstats: code statistics for this queue
- * @frags: used to keep fragments created after dequeue
+ * @frags: used to keep fragments created after dequeue, and frames that
+ *	were filtered by the device (queued before the fragments)
  * @schedule_order: used with ieee80211_local->active_txqs
  * @schedule_round: counter to prevent infinite loops on TXQ scheduling
  * @flags: TXQ flags from &enum txq_info_flags
@@ -2731,6 +2732,8 @@ struct sk_buff *ieee80211_tx_dequeue_ps_release(struct ieee80211_local *local,
 						struct txq_info *txqi);
 void ieee80211_txq_ps_backlog_start(struct ieee80211_local *local,
 				    struct txq_info *txqi);
+bool ieee80211_txq_queue_filtered(struct ieee80211_local *local,
+				  struct txq_info *txqi, struct sk_buff *skb);
 void ieee80211_txq_purge(struct ieee80211_local *local,
 			 struct txq_info *txqi);
 void ieee80211_purge_sta_txqs(struct sta_info *sta);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8d79e532b109..c536ab759fef 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1231,11 +1231,60 @@ static bool sta_info_buffer_expired(struct sta_info *sta, struct sk_buff *skb)
 }
 
 
+static bool sta_info_cleanup_expire_filtered_txqs(struct ieee80211_local *local,
+						  struct sta_info *sta, int ac)
+{
+	unsigned long tids = ieee80211_tids_for_ac(ac);
+	struct sk_buff_head expired;
+	struct fq *fq = &local->fq;
+	bool have_filtered = false;
+	int tid;
+
+	__skb_queue_head_init(&expired);
+
+	spin_lock_bh(&fq->lock);
+	for_each_set_bit(tid, &tids, IEEE80211_NUM_TIDS) {
+		struct txq_info *txqi;
+		struct sk_buff *skb;
+
+		if (!sta->sta.txq[tid])
+			continue;
+
+		txqi = to_txq_info(sta->sta.txq[tid]);
+
+		while ((skb = skb_peek(&txqi->frags))) {
+			if (!(IEEE80211_SKB_CB(skb)->flags &
+			      IEEE80211_TX_INTFL_RETRANSMISSION))
+				break;
+
+			if (!sta_info_buffer_expired(sta, skb)) {
+				have_filtered = true;
+				break;
+			}
+
+			__skb_unlink(skb, &txqi->frags);
+			__skb_queue_tail(&expired, skb);
+		}
+	}
+	spin_unlock_bh(&fq->lock);
+
+	if (!skb_queue_empty(&expired))
+		ps_dbg(sta->sdata, "%d filtered frames expired (STA %pM)\n",
+		       skb_queue_len(&expired), sta->sta.addr);
+
+	ieee80211_purge_tx_queue(&local->hw, &expired);
+
+	return have_filtered;
+}
+
 static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 						struct sta_info *sta, int ac)
 {
 	unsigned long flags;
 	struct sk_buff *skb;
+	bool have_filtered;
+
+	have_filtered = sta_info_cleanup_expire_filtered_txqs(local, sta, ac);
 
 	/*
 	 * First check for frames that should expire on the filtered
@@ -1305,7 +1354,8 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 	 * used to check whether the cleanup timer still needs to run,
 	 * if there are no frames we don't need to rearm the timer.
 	 */
-	return !(skb_queue_empty(&sta->ps_tx_buf[ac]) &&
+	return have_filtered ||
+	       !(skb_queue_empty(&sta->ps_tx_buf[ac]) &&
 		 skb_queue_empty(&sta->tx_filtered[ac]));
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index cd3c89a6a25a..ea7ead4b30b5 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -660,7 +660,9 @@ struct ieee80211_sta_removed_link_stats {
  * @tx_filtered: buffers (per AC) of frames we already tried to
  *	transmit but were filtered by hardware due to STA having
  *	entered power saving state, these are also delivered to
- *	the station when it leaves powersave or polls for frames
+ *	the station when it leaves powersave or polls for frames.
+ *	Only used for frames not on a TID TXQ, filtered data frames
+ *	are put back onto the frags queue of their TXQ instead.
  * @driver_buffered_tids: bitmap of TIDs the driver has data buffered on
  * @ps_release_tids: TIDs for which the driver can dequeue from TXQs during
  *	during release_buffered_frames(), only non-zero during that
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 414979e2a1d9..6134c37e081b 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -47,6 +47,8 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct txq_info *txqi = NULL;
+	u32 ctrl_flags, flags;
 	int ac;
 
 	if (info->flags & (IEEE80211_TX_CTL_NO_PS_BUFFER |
@@ -56,6 +58,19 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 		return;
 	}
 
+	if (ieee80211_is_data_present(hdr->frame_control) && sta->uploaded) {
+		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
+
+		if (sta->sta.txq[tid])
+			txqi = to_txq_info(sta->sta.txq[tid]);
+	}
+
+	/* keep these flags across another trip through the TXQ */
+	ctrl_flags = info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+	flags = info->flags & IEEE80211_TX_CTL_NO_ACK;
+	if (!(hdr->seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)))
+		flags |= IEEE80211_TX_CTL_FIRST_FRAGMENT;
+
 	/*
 	 * This skb 'survived' a round-trip through the driver, and
 	 * hopefully the driver didn't mangle it too badly. However,
@@ -71,6 +86,10 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	info->control.flags |= IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 	info->flags |= IEEE80211_TX_INTFL_RETRANSMISSION;
 	info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
+	if (txqi) {
+		info->control.flags |= ctrl_flags;
+		info->flags |= flags;
+	}
 
 	sta->deflink.status_stats.filtered++;
 
@@ -142,6 +161,38 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	 *      changes before calling TX status events if ordering can be
 	 *	unknown.
 	 */
+	if (txqi) {
+		if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
+			if (info->flags & IEEE80211_TX_INTFL_RETRIED)
+				goto drop;
+			info->flags |= IEEE80211_TX_INTFL_RETRIED;
+		}
+
+		if (!ieee80211_txq_queue_filtered(local, txqi, skb))
+			goto drop;
+
+		/*
+		 * ieee80211_sta_ps_deliver_wakeup() either sees the frame
+		 * and wakes the TXQ, or this code sees it awake and does
+		 */
+		smp_mb();
+
+		if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
+			sta_info_recalc_tim(sta);
+
+			if (!timer_pending(&local->sta_cleanup))
+				mod_timer(&local->sta_cleanup,
+					  round_jiffies(jiffies +
+							STA_INFO_CLEANUP_INTERVAL));
+		} else {
+			/* avoid recursive driver calls */
+			ieee80211_schedule_txq(&local->hw, &txqi->txq);
+			set_bit(IEEE80211_TXQ_DIRTY, &txqi->flags);
+			tasklet_schedule(&local->wake_txqs_tasklet);
+		}
+		return;
+	}
+
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
 	    skb_queue_len(&sta->tx_filtered[ac]) < STA_MAX_TX_BUFFER) {
 		skb_queue_tail(&sta->tx_filtered[ac], skb);
@@ -162,9 +213,10 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 		return;
 	}
 
+drop:
 	ps_dbg_ratelimited(sta->sdata,
 			   "dropped TX filtered frame, queue_len=%d PS=%d @%lu\n",
-			   skb_queue_len(&sta->tx_filtered[ac]),
+			   txqi ? -1 : skb_queue_len(&sta->tx_filtered[ac]),
 			   !!test_sta_flag(sta, WLAN_STA_PS_STA), jiffies);
 	ieee80211_free_txskb(&local->hw, skb);
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 856018cdb617..cc6996591853 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1515,6 +1515,33 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 		sta_info_recalc_tim(sta);
 }
 
+bool ieee80211_txq_queue_filtered(struct ieee80211_local *local,
+				  struct txq_info *txqi, struct sk_buff *skb)
+{
+	struct sk_buff *iter, *pos = (struct sk_buff *)&txqi->frags;
+	unsigned int n_filtered = 0;
+	struct fq *fq = &local->fq;
+	bool ret = false;
+
+	spin_lock_bh(&fq->lock);
+	skb_queue_walk(&txqi->frags, iter) {
+		if (!(IEEE80211_SKB_CB(iter)->flags &
+		      IEEE80211_TX_INTFL_RETRANSMISSION)) {
+			pos = iter;
+			break;
+		}
+		n_filtered++;
+	}
+
+	if (n_filtered < STA_MAX_TX_BUFFER) {
+		__skb_queue_before(&txqi->frags, pos, skb);
+		ret = true;
+	}
+	spin_unlock_bh(&fq->lock);
+
+	return ret;
+}
+
 static bool fq_vlan_filter_func(struct fq *fq, struct fq_tin *tin,
 				struct fq_flow *flow, struct sk_buff *skb,
 				void *data)
@@ -4051,6 +4078,16 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 			ieee80211_free_txskb(&local->hw, skb);
 			goto begin;
 		}
+
+		/*
+		 * First transmitted frame clears filter. The non-atomic check
+		 * is first since it's very unlikely.
+		 */
+		if (unlikely(test_sta_flag(tx.sta, WLAN_STA_CLEAR_PS_FILT)) &&
+		    test_and_clear_sta_flag(tx.sta, WLAN_STA_CLEAR_PS_FILT)) {
+			info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+			ieee80211_check_fast_xmit(tx.sta);
+		}
 	}
 
 	/*
-- 
2.56.0

