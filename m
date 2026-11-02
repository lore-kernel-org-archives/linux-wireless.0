Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651939;
	b=tJZGV9wamtmgCRPQethr5qSOuh8aT+WrRdGwRjkh59+ltbTDI9ZCEFc23FN03w253Ikc
	 CQ4OrnfqNNfJLH0vjhUgXKYAuuvb/GfdPQjOaZZ1ACon+OxSetw2yvO5kt3+7gUw5vpvp
	 /4Vv9pu1yE+9TiVQLg5G/QTUOwYOoYCTgUM6F+E756mGgl+by1KvMA9ED0BVL6zBv80l6
	 x2o1pLZw9mQflWXbB5kT/NOu2gD371Ei+JhzOQs73rdv3PvqBg91mzMVIBC6ttvtwxDuF
	 fOcqiH3tFox0xMGGmixjTbLP4ouvF6ZBFhwlO6I5No3qa5BwVh1pNvToL8pfRrbrzZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651939;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=5QsaCob/lxpuL1bHPL2qQEKsns+hCywsl7yjj9cqy3Y=;
	b=H0PkPCcclEQmPvK2jLqvhv26qpL9Mf/wFs01YQJ0XYMo/U2NTUrv4sDA0+4lnFo3/mN/
	 B9wv3NIeHTPhuJ8vh+mEzxf2cFxH/nRfoZAx1C+Kx0waOKdMpsDg3bKdUeJr/NfcVQ7C+
	 XPL8UWWkoq0CXWyZtJOx9EhypawUTTotVjSpNRR5qkqwLDGVkhEFF5d857wFM5Gu8bhRB
	 1xOcp5rN0YrcgY26wJIQiYWLgxSqzFRsg5ZUI5G+XkbZhptuuGqtMm4sjioRpb2Npn7G9
	 vYwfDPxMp7RILN3bAElwQIRc4Al8hXCZ0Q8ErmzQcbTSRyKdBtc1RBqYmwLj07+TzPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=jTsx1ouA;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27B76082BC0
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=jTsx1ouA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=5QsaCob/lxpuL1bHPL2qQEKsns+hCywsl7yjj9cqy3Y=;
	t=1793651938; x=1794861538; b=jTsx1ouAxRRXmOFTyophwHr7z++H0wpcwZfH00Kw+LIVF5H
	J71tkQ4+rBCZ5yCoqrekINE1Fe2IvtBOA9a6fNwrl+Y06c2sZHz220aZwWLbWVFFGNP9gUd923He4
	yRygpZngieoVM8W6IdMv5LyPPYr8bpe9BXNgmNlR9WZQwLkCNwthEPumcwNC0JCJzANrtcBAKVqUh
	P2tpooSlXhdg7hy46WAtCdgNJOWBR5as/1tdigxTzMFj5VylGbzIFZlCE0tE5bsX8TqXH4IVUgkOL
	mqYDfmi2PvVPg/P6Xb9hHjyT32auaaQPRdfUC3cY8ZKLmQ2eaiPiwdnDvWwIR5Sw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynw-00000001vzr-3HAG;
	Mon, 02 Nov 2026 21:38:56 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 19/30] wifi: mac80211: use MMPDU TXQ for filtered mgmt frames
Date: Mon,  2 Nov 2026 21:23:09 +0100
Message-ID: <20261102203831.1058362-51-johannes@sipsolutions.net>
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

After the previous change, filtered data frames lived on the
TXQs in the frags list, but not management frames. Change it
for management frames, now that we always have the MMPDU TXQ,
which enables removing the tx_filtered[] queues entirely.

Note a small change that filtered MMPDUs are now VO, which
was wrong because they don't have a QoS header and then BE
was used as a fallback.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c |   2 +-
 net/mac80211/mesh_ps.c     |  29 +++-------
 net/mac80211/sta_info.c    |  83 ++++-------------------------
 net/mac80211/sta_info.h    |   7 ---
 net/mac80211/status.c      | 106 ++++++++++++++++++++-----------------
 5 files changed, 76 insertions(+), 151 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 088fd9d90c81..e0d797045d0b 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -112,7 +112,7 @@ static ssize_t sta_num_ps_buf_frames_read(struct file *file,
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		unsigned long tids = ieee80211_tids_for_ac(ac);
-		unsigned int n = skb_queue_len(&sta->tx_filtered[ac]);
+		unsigned int n = 0;
 		int tid;
 
 		spin_lock_bh(&fq->lock);
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index e3d815fbe31b..513f98e94899 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -462,7 +462,7 @@ static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 	int ac;
 	struct sk_buff_head frames;
 	struct sk_buff *skb;
-	bool more_data = false;
+	bool more_data;
 
 	skb_queue_head_init(&frames);
 
@@ -472,23 +472,12 @@ static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 	txq_buffered_tids = ieee80211_sta_txq_buffered_tids(sta);
 
 	/* collect frame(s) from buffers */
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		while (n_frames > 0 &&
-		       (skb = skb_dequeue(&sta->tx_filtered[ac]))) {
-			n_frames--;
-			__skb_queue_tail(&frames, skb);
-		}
-
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 		n_frames = ieee80211_sta_ps_dequeue_txqs(sta,
 				txq_buffered_tids & ieee80211_tids_for_ac(ac),
 				n_frames, &frames);
 
-		if (!skb_queue_empty(&sta->tx_filtered[ac]))
-			more_data = true;
-	}
-
-	if (ieee80211_sta_txq_buffered_tids(sta))
-		more_data = true;
+	more_data = ieee80211_sta_txq_buffered_tids(sta);
 
 	/* nothing to send? -> EOSP */
 	if (skb_queue_empty(&frames)) {
@@ -588,8 +577,7 @@ void ieee80211_mpsp_trigger_process(u8 *qc, struct sta_info *sta,
 void ieee80211_mps_frame_release(struct sta_info *sta,
 				 struct ieee802_11_elems *elems)
 {
-	int ac, buffer_local = 0;
-	bool has_buffered = false;
+	bool has_buffered = false, buffer_local = false;
 
 	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
 		has_buffered = ieee80211_check_tim(elems->tim, elems->tim_len,
@@ -604,12 +592,9 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 	    (!elems->awake_window || !get_unaligned_le16(elems->awake_window)))
 		return;
 
-	if (!test_sta_flag(sta, WLAN_STA_MPSP_OWNER)) {
-		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			buffer_local += skb_queue_len(&sta->tx_filtered[ac]);
-		if (ieee80211_sta_txq_buffered_tids(sta))
-			buffer_local++;
-	}
+	if (!test_sta_flag(sta, WLAN_STA_MPSP_OWNER) &&
+	    ieee80211_sta_txq_buffered_tids(sta))
+		buffer_local = true;
 
 	if (!has_buffered && !buffer_local)
 		return;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 3161e00c32a9..ad73a20eddb5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -123,10 +123,9 @@ void ieee80211_purge_sta_txqs(struct sta_info *sta)
 
 static void __cleanup_single_sta(struct sta_info *sta)
 {
-	int ac, i;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
 	struct ps_data *ps;
+	int i;
 
 	cancel_work_sync(&sta->drv_deliver_wk);
 
@@ -150,9 +149,6 @@ static void __cleanup_single_sta(struct sta_info *sta)
 
 	ieee80211_purge_sta_txqs(sta);
 
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-		ieee80211_purge_tx_queue(&local->hw, &sta->tx_filtered[ac]);
-
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_sta_cleanup(sta);
 
@@ -713,7 +709,6 @@ __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->airtime_weight = IEEE80211_DEFAULT_AIRTIME_WEIGHT;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		skb_queue_head_init(&sta->tx_filtered[i]);
 		sta->airtime[i].deficit = sta->airtime_weight;
 		atomic_set(&sta->airtime[i].aql_tx_pending, 0);
 		sta->airtime[i].aql_limit_low = local->aql_txq_limit_low[i];
@@ -1160,10 +1155,6 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 		if (ignore_for_tim & ieee80211_ac_to_qos_mask[ac])
 			continue;
 
-		indicate_tim |= !skb_queue_empty(&sta->tx_filtered[ac]);
-		if (indicate_tim)
-			break;
-
 		tids = ieee80211_tids_for_ac(ac);
 
 		indicate_tim |=
@@ -1292,36 +1283,10 @@ static bool sta_info_cleanup_expire_txqs(struct ieee80211_local *local,
 static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 						struct sta_info *sta, int ac)
 {
-	unsigned long flags;
-	struct sk_buff *skb;
 	bool have_buffered;
 
 	have_buffered = sta_info_cleanup_expire_txqs(local, sta, ac);
 
-	/*
-	 * Also check for frames that should expire on the filtered
-	 * queue. Frames here were rejected by the driver.
-	 */
-	for (;;) {
-		spin_lock_irqsave(&sta->tx_filtered[ac].lock, flags);
-		skb = skb_peek(&sta->tx_filtered[ac]);
-		if (sta_info_buffer_expired(sta, skb))
-			skb = __skb_dequeue(&sta->tx_filtered[ac]);
-		else
-			skb = NULL;
-		spin_unlock_irqrestore(&sta->tx_filtered[ac].lock, flags);
-
-		/*
-		 * Frames are queued in order, so if this one
-		 * hasn't expired yet we can stop testing. If
-		 * we actually reached the end of the queue we
-		 * also need to stop, of course.
-		 */
-		if (!skb)
-			break;
-		ieee80211_free_txskb(&local->hw, skb);
-	}
-
 	/*
 	 * Finally, recalculate the TIM bit for this station -- it might
 	 * now be clear because the station was too slow to retrieve its
@@ -1334,7 +1299,7 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 	 * used to check whether the cleanup timer still needs to run,
 	 * if there are no frames we don't need to rearm the timer.
 	 */
-	return have_buffered || !skb_queue_empty(&sta->tx_filtered[ac]);
+	return have_buffered;
 }
 
 static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
@@ -1897,10 +1862,9 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	struct ieee80211_local *local = sdata->local;
 	struct txq_info *mmpdu_txqi = sta->mmpdu_txqi;
 	struct sk_buff_head pending;
-	int filtered = 0, buffered = 0, ac, i;
-	unsigned long flags;
 	struct sk_buff *skb;
 	struct ps_data *ps;
+	int buffered, i;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
@@ -1939,17 +1903,11 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 	skb_queue_head_init(&pending);
 
-	/* sync with ieee80211_tx_h_unicast_ps_buf */
+	/*
+	 * Sync with ieee80211_tx_h_unicast_ps_buf() and the TX status
+	 * path, the internal management TXQ isn't serviced by the driver.
+	 */
 	spin_lock_bh(&sta->ps_lock);
-	/* Send all buffered frames to the station */
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		spin_lock_irqsave(&sta->tx_filtered[ac].lock, flags);
-		skb_queue_splice_tail_init(&sta->tx_filtered[ac], &pending);
-		spin_unlock_irqrestore(&sta->tx_filtered[ac].lock, flags);
-	}
-	filtered = skb_queue_len(&pending);
-
-	/* the internal management TXQ isn't serviced by the driver */
 	if (!sta->sta.txq[IEEE80211_NUM_TIDS]) {
 		rcu_read_lock();
 		while ((skb = ieee80211_tx_dequeue_ps_release(local,
@@ -1957,7 +1915,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 			__skb_queue_tail(&pending, skb);
 		rcu_read_unlock();
 	}
-	buffered = skb_queue_len(&pending) - filtered;
+	buffered = skb_queue_len(&pending);
 
 	ieee80211_add_pending_skbs(local, &pending);
 
@@ -1976,8 +1934,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	sta_info_recalc_tim(sta);
 
 	ps_dbg(sdata,
-	       "STA %pM aid %d sending %d filtered/%d management frames since STA woke up\n",
-	       sta->sta.addr, sta->sta.aid, filtered, buffered);
+	       "STA %pM aid %d sending %d management frames since STA woke up\n",
+	       sta->sta.addr, sta->sta.aid, buffered);
 
 	ieee80211_check_fast_xmit(sta);
 }
@@ -2109,8 +2067,7 @@ ieee80211_sta_ps_more_data(struct sta_info *sta, u8 ignored_acs,
 		if (ignored_acs & ieee80211_ac_to_qos_mask[ac])
 			continue;
 
-		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
-		    buffered_tids & ieee80211_tids_for_ac(ac))
+		if (buffered_tids & ieee80211_tids_for_ac(ac))
 			return true;
 	}
 
@@ -2170,19 +2127,6 @@ int ieee80211_sta_ps_dequeue_txqs(const struct sta_info *sta, unsigned long tids
 	return n_frames;
 }
 
-static int ieee80211_sta_ps_dequeue(struct sk_buff_head *queue, int n_frames,
-				    struct sk_buff_head *frames)
-{
-	struct sk_buff *skb;
-
-	while (n_frames > 0 && (skb = skb_dequeue(queue))) {
-		__skb_queue_tail(frames, skb);
-		n_frames--;
-	}
-
-	return n_frames;
-}
-
 static void
 ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 			    enum ieee80211_frame_release_type reason,
@@ -2218,8 +2162,6 @@ ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 		if (!*driver_release_tids) {
 			unsigned long txq_tids;
 
-			n_frames = ieee80211_sta_ps_dequeue(&sta->tx_filtered[ac],
-							    n_frames, frames);
 			txq_tids = txq_buffered_tids & tids & mac80211_tids;
 			n_frames = ieee80211_sta_ps_dequeue_txqs(sta, txq_tids,
 								 n_frames, frames);
@@ -2229,9 +2171,6 @@ ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 		 * loop since we can't send more data from other ACs before
 		 * the buffered frames from this.
 		 */
-		if (!skb_queue_empty(&sta->tx_filtered[ac]))
-			break;
-
 		if (ieee80211_sta_txq_buffered_tids(sta) & tids & mac80211_tids)
 			break;
 	}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 299cc06653ca..89be51a010b8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -657,12 +657,6 @@ struct ieee80211_sta_removed_link_stats {
  * @ps_lock: used for powersave (when mac80211 is the AP) related locking
  * @mmpdu_txqi: the management TXQ, used internally even if the driver
  *	doesn't want to use it
- * @tx_filtered: buffers (per AC) of frames we already tried to
- *	transmit but were filtered by hardware due to STA having
- *	entered power saving state, these are also delivered to
- *	the station when it leaves powersave or polls for frames.
- *	Only used for frames not on a TID TXQ, filtered data frames
- *	are put back onto the frags queue of their TXQ instead.
  * @driver_buffered_tids: bitmap of TIDs the driver has data buffered on
  * @ps_release_tids: TIDs for which the driver can dequeue from TXQs during
  *	during release_buffered_frames(), only non-zero during that
@@ -750,7 +744,6 @@ struct sta_info {
 	/* STA powersave lock and frame queues */
 	spinlock_t ps_lock;
 	struct txq_info *mmpdu_txqi;
-	struct sk_buff_head tx_filtered[IEEE80211_NUM_ACS];
 	unsigned long driver_buffered_tids;
 	unsigned long ps_release_tids;
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 6134c37e081b..9b8e0b7e173b 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -49,7 +49,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct txq_info *txqi = NULL;
 	u32 ctrl_flags, flags;
-	int ac;
+	bool queued;
 
 	if (info->flags & (IEEE80211_TX_CTL_NO_PS_BUFFER |
 			   IEEE80211_TX_CTL_AMPDU |
@@ -58,11 +58,12 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 		return;
 	}
 
-	if (ieee80211_is_data_present(hdr->frame_control) && sta->uploaded) {
-		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
-
-		if (sta->sta.txq[tid])
-			txqi = to_txq_info(sta->sta.txq[tid]);
+	if (sta->uploaded) {
+		if (ieee80211_is_data_present(hdr->frame_control))
+			txqi = sta_txqi(sta, skb->priority &
+					     IEEE80211_QOS_CTL_TID_MASK);
+		else
+			txqi = sta->mmpdu_txqi;
 	}
 
 	/* keep these flags across another trip through the TXQ */
@@ -86,10 +87,6 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	info->control.flags |= IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 	info->flags |= IEEE80211_TX_INTFL_RETRANSMISSION;
 	info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
-	if (txqi) {
-		info->control.flags |= ctrl_flags;
-		info->flags |= flags;
-	}
 
 	sta->deflink.status_stats.filtered++;
 
@@ -105,7 +102,6 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		u8 *p = ieee80211_get_qos_ctl(hdr);
-		int tid = *p & IEEE80211_QOS_CTL_TID_MASK;
 
 		/*
 		 * Clear EOSP if set, this could happen e.g.
@@ -114,9 +110,6 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 		 */
 		if (*p & IEEE80211_QOS_CTL_EOSP)
 			*p &= ~IEEE80211_QOS_CTL_EOSP;
-		ac = ieee80211_ac_from_tid(tid);
-	} else {
-		ac = IEEE80211_AC_BE;
 	}
 
 	/*
@@ -161,50 +154,66 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	 *      changes before calling TX status events if ordering can be
 	 *	unknown.
 	 */
-	if (txqi) {
-		if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
-			if (info->flags & IEEE80211_TX_INTFL_RETRIED)
-				goto drop;
-			info->flags |= IEEE80211_TX_INTFL_RETRIED;
+	if (!txqi)
+		goto retry;
+
+	if (txqi->txq.tid == IEEE80211_NUM_TIDS &&
+	    !sta->sta.txq[IEEE80211_NUM_TIDS]) {
+		/*
+		 * The internal management TXQ is only used while the station
+		 * is in powersave, see ieee80211_tx_h_unicast_ps_buf().
+		 */
+		spin_lock_bh(&sta->ps_lock);
+		if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
+		    !test_sta_flag(sta, WLAN_STA_PS_DRIVER) &&
+		    !test_sta_flag(sta, WLAN_STA_PS_DELIVER)) {
+			spin_unlock_bh(&sta->ps_lock);
+			goto retry;
 		}
 
-		if (!ieee80211_txq_queue_filtered(local, txqi, skb))
+		info->control.flags |= ctrl_flags;
+		info->flags |= flags;
+		queued = ieee80211_txq_queue_filtered(local, txqi, skb);
+		spin_unlock_bh(&sta->ps_lock);
+
+		if (!queued)
 			goto drop;
 
-		/*
-		 * ieee80211_sta_ps_deliver_wakeup() either sees the frame
-		 * and wakes the TXQ, or this code sees it awake and does
-		 */
-		smp_mb();
-
-		if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
+		if (test_sta_flag(sta, WLAN_STA_PS_STA))
 			sta_info_recalc_tim(sta);
-
-			if (!timer_pending(&local->sta_cleanup))
-				mod_timer(&local->sta_cleanup,
-					  round_jiffies(jiffies +
-							STA_INFO_CLEANUP_INTERVAL));
-		} else {
-			/* avoid recursive driver calls */
-			ieee80211_schedule_txq(&local->hw, &txqi->txq);
-			set_bit(IEEE80211_TXQ_DIRTY, &txqi->flags);
-			tasklet_schedule(&local->wake_txqs_tasklet);
-		}
+		sta_info_schedule_cleanup(local);
 		return;
 	}
 
-	if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
-	    skb_queue_len(&sta->tx_filtered[ac]) < STA_MAX_TX_BUFFER) {
-		skb_queue_tail(&sta->tx_filtered[ac], skb);
+	if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
+		if (info->flags & IEEE80211_TX_INTFL_RETRIED)
+			goto drop;
+		info->flags |= IEEE80211_TX_INTFL_RETRIED;
+	}
+
+	info->control.flags |= ctrl_flags;
+	info->flags |= flags;
+	if (!ieee80211_txq_queue_filtered(local, txqi, skb))
+		goto drop;
+
+	/*
+	 * ieee80211_sta_ps_deliver_wakeup() either sees the frame
+	 * and wakes the TXQ, or this code sees it awake and does
+	 */
+	smp_mb();
+
+	if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
 		sta_info_recalc_tim(sta);
-
-		if (!timer_pending(&local->sta_cleanup))
-			mod_timer(&local->sta_cleanup,
-				  round_jiffies(jiffies +
-						STA_INFO_CLEANUP_INTERVAL));
-		return;
+		sta_info_schedule_cleanup(local);
+	} else {
+		/* avoid recursive driver calls */
+		ieee80211_schedule_txq(&local->hw, &txqi->txq);
+		set_bit(IEEE80211_TXQ_DIRTY, &txqi->flags);
+		tasklet_schedule(&local->wake_txqs_tasklet);
 	}
+	return;
 
+retry:
 	if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
 	    !(info->flags & IEEE80211_TX_INTFL_RETRIED)) {
 		/* Software retry the packet once */
@@ -215,8 +224,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 
 drop:
 	ps_dbg_ratelimited(sta->sdata,
-			   "dropped TX filtered frame, queue_len=%d PS=%d @%lu\n",
-			   txqi ? -1 : skb_queue_len(&sta->tx_filtered[ac]),
+			   "dropped TX filtered frame PS=%d @%lu\n",
 			   !!test_sta_flag(sta, WLAN_STA_PS_STA), jiffies);
 	ieee80211_free_txskb(&local->hw, skb);
 }
-- 
2.56.0

