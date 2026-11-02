Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651939;
	b=Lbi+t9BNVWkV4Zv5YScY7iTRndR5JbEk6PrQYlYheINyuuH1DDD2GsXcNfZjJNMpbU+7
	 3Bdx1MkIdY8Q4H0+nxdeDCf2M156wlxYW97n8UXvVLJTUuwxgjsxHWwZQ1GTWWwgSJgDm
	 9dQWAZeYixZ2M34Pw5GH7wRl5HHC+xeXFapXErCGlWbwdHd4OYP/B2pD+C/0MWw3SesWl
	 RZ0qVW0TU0VVbl1qY7epeiBja/rlBm5EDFbSDbA4KASiSESwWCsVBJYRLMmr9UhaNXdFB
	 6xwYBma6Lf6jo3bDZ1kuI4ba1y/K4K2l3hD8sY2O8ns9biG4vVemG3oAcpuGephkJyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651939;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=IFFuDGvIUGifOl9bOFuzFdZK9VVK9mp8+8Zsh7ZhR2g=;
	b=gMsCJ9YQAuipr7eWFMMfSF+ewLxmCEMIBtjLwVBcw6XzBJdwyV54OtAitJxCLtXzE901
	 5lJrVP4VbjuWVyWGZHEZJfqYyj50crf5uP8kgqvBHXU/NMKsrJaOtiSKPOam3/2icrZLu
	 yreaQQcm77VV4ve/dWp/qWmmKRkd9gVy7A9Goh7gf1n3AyWSmfyiVFY5oo+twpO7v3ecd
	 MdsEHLqFHa45qlZi0j2s90XNJLEWJBW5Y8/goiOPuHFlZGFs5eJMb1gKB302Fyqahrd3Q
	 zdOqroDyAJH/wwaiMS8PEDwJogQLMTYyMkBZlco7vJhf5wekrlXSRSbuVjaBghvYlhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=jFBObf7y;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11249606EEBC
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=jFBObf7y
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=IFFuDGvIUGifOl9bOFuzFdZK9VVK9mp8+8Zsh7ZhR2g=;
	t=1793651937; x=1794861537; b=jFBObf7y2Jx0Y//7g+2i2MW6GNxRMnxpGIZ7svCH6bDNmFZ
	QfcZMBnCrDiM2oDPhOK96ZDtahg2mJ+mePLfyClmhop/Vbxj2frDI4J0sL/1pHprtk1I9CN3al2PW
	0+9aJYtW/QLjFaSqcBLsms1gRBVNH/1mArvdbioXQ2Cns5LNVM3NSjABS9Ojx8eQptRWHfYDVUePA
	8CgaDMR08qQVU1YDRXzlrYJxPikRm1pf0W8I+OoZ4EsyylJY/McbEq3e9OcQ6czG3XRffWuoi/LuI
	iN4N5y0tBbQEmjmJNAlx/b6uctFAVx3AIX+UEyOqdzYvQilRUcZLgDRmolBRPjQg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynw-00000001vzr-0I8f;
	Mon, 02 Nov 2026 21:38:56 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 18/30] wifi: mac80211: always use per-STA MMPDU TXQ
Date: Mon,  2 Nov 2026 21:23:08 +0100
Message-ID: <20261102203831.1058362-50-johannes@sipsolutions.net>
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

If the driver uses the MMPDU TXQ we now hold PS frames there,
but if it doesn't we still use extra ps_tx_buf[ac] queues.
Change this to always allocate the MMPDU TXQ even if a given
driver doesn't want it, and then use that to buffer frames.
This gets rid of the ps_tx_buf[ac] queues.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c |  21 +++++--
 net/mac80211/ieee80211_i.h |  13 ++++-
 net/mac80211/mesh_ps.c     |  18 +-----
 net/mac80211/sta_info.c    | 109 +++++++----------------------------
 net/mac80211/sta_info.h    |   6 +-
 net/mac80211/tx.c          | 115 +++++++++++++++----------------------
 6 files changed, 101 insertions(+), 181 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 203f608eba67..088fd9d90c81 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -106,13 +106,26 @@ static ssize_t sta_num_ps_buf_frames_read(struct file *file,
 					  size_t count, loff_t *ppos)
 {
 	struct sta_info *sta = file->private_data;
+	struct fq *fq = &sta->local->fq;
 	char buf[17*IEEE80211_NUM_ACS], *p = buf;
 	int ac;
 
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-		p += scnprintf(p, sizeof(buf)+buf-p, "AC%d: %d\n", ac,
-			       skb_queue_len(&sta->ps_tx_buf[ac]) +
-			       skb_queue_len(&sta->tx_filtered[ac]));
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		unsigned long tids = ieee80211_tids_for_ac(ac);
+		unsigned int n = skb_queue_len(&sta->tx_filtered[ac]);
+		int tid;
+
+		spin_lock_bh(&fq->lock);
+		for_each_set_bit(tid, &tids, IEEE80211_NUM_TIDS + 1) {
+			struct txq_info *txqi = sta_txqi(sta, tid);
+
+			n += txqi->tin.backlog_packets +
+			     skb_queue_len(&txqi->frags);
+		}
+		spin_unlock_bh(&fq->lock);
+
+		p += scnprintf(p, sizeof(buf) + buf - p, "AC%d: %u\n", ac, n);
+	}
 	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
 }
 STA_OPS(num_ps_buf_frames);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ebfa772a6dd8..89581935659c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -45,7 +45,7 @@ struct ieee80211_mesh_fast_tx;
  * associated stations are using power saving. */
 #define AP_MAX_BC_BUFFER 128
 
-/* Maximum number of frames buffered to all STAs, including multicast frames.
+/* Maximum number of multicast frames buffered for all interfaces.
  * Note: increasing this limit increases the potential memory requirement. Each
  * frame can be up to about 2 kB long. */
 #define TOTAL_MAX_TX_BUFFER 512
@@ -1717,8 +1717,8 @@ struct ieee80211_local {
 #endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
 
 
-	int total_ps_buffered; /* total number of all buffered unicast and
-				* multicast packets for power saving stations
+	int total_ps_buffered; /* total number of all buffered multicast
+				* packets for power saving stations
 				*/
 
 	bool pspolling;
@@ -1987,6 +1987,13 @@ static inline struct txq_info *to_txq_info(struct ieee80211_txq *txq)
 	return container_of(txq, struct txq_info, txq);
 }
 
+static inline struct txq_info *sta_txqi(const struct sta_info *sta, int tid)
+{
+	if (tid == IEEE80211_NUM_TIDS)
+		return sta->mmpdu_txqi;
+	return to_txq_info(sta->sta.txq[tid]);
+}
+
 static inline bool txq_has_queue(struct ieee80211_txq *txq)
 {
 	struct txq_info *txqi = to_txq_info(txq);
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index ddf35cdd558a..e3d815fbe31b 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -471,10 +471,7 @@ static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 
 	txq_buffered_tids = ieee80211_sta_txq_buffered_tids(sta);
 
-	/*
-	 * collect frame(s) from buffers, frames on the TXQs were queued
-	 * before those on the PS buffer
-	 */
+	/* collect frame(s) from buffers */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		while (n_frames > 0 &&
 		       (skb = skb_dequeue(&sta->tx_filtered[ac]))) {
@@ -486,15 +483,7 @@ static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 				txq_buffered_tids & ieee80211_tids_for_ac(ac),
 				n_frames, &frames);
 
-		while (n_frames > 0 &&
-		       (skb = skb_dequeue(&sta->ps_tx_buf[ac]))) {
-			local->total_ps_buffered--;
-			n_frames--;
-			__skb_queue_tail(&frames, skb);
-		}
-
-		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
-		    !skb_queue_empty(&sta->ps_tx_buf[ac]))
+		if (!skb_queue_empty(&sta->tx_filtered[ac]))
 			more_data = true;
 	}
 
@@ -617,8 +606,7 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 
 	if (!test_sta_flag(sta, WLAN_STA_MPSP_OWNER)) {
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			buffer_local += skb_queue_len(&sta->ps_tx_buf[ac]) +
-					skb_queue_len(&sta->tx_filtered[ac]);
+			buffer_local += skb_queue_len(&sta->tx_filtered[ac]);
 		if (ieee80211_sta_txq_buffered_tids(sta))
 			buffer_local++;
 	}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 1ec59cdd4fa2..3161e00c32a9 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -117,16 +117,8 @@ void ieee80211_purge_sta_txqs(struct sta_info *sta)
 	struct ieee80211_local *local = sta->sdata->local;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
-		struct txq_info *txqi;
-
-		if (!sta->sta.txq[i])
-			continue;
-
-		txqi = to_txq_info(sta->sta.txq[i]);
-
-		ieee80211_txq_purge(local, txqi);
-	}
+	for (i = 0; i <= IEEE80211_NUM_TIDS; i++)
+		ieee80211_txq_purge(local, sta_txqi(sta, i));
 }
 
 static void __cleanup_single_sta(struct sta_info *sta)
@@ -158,11 +150,8 @@ static void __cleanup_single_sta(struct sta_info *sta)
 
 	ieee80211_purge_sta_txqs(sta);
 
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf[ac]);
-		ieee80211_purge_tx_queue(&local->hw, &sta->ps_tx_buf[ac]);
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 		ieee80211_purge_tx_queue(&local->hw, &sta->tx_filtered[ac]);
-	}
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_sta_cleanup(sta);
@@ -715,7 +704,6 @@ __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 		struct txq_info *txq = txq_data + i * size;
 
-		/* might not do anything for the (bufferable) MMPDU TXQ */
 		ieee80211_txq_init(sdata, sta, txq, i);
 	}
 
@@ -725,7 +713,6 @@ __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->airtime_weight = IEEE80211_DEFAULT_AIRTIME_WEIGHT;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		skb_queue_head_init(&sta->ps_tx_buf[i]);
 		skb_queue_head_init(&sta->tx_filtered[i]);
 		sta->airtime[i].deficit = sta->airtime_weight;
 		atomic_set(&sta->airtime[i].aql_tx_pending, 0);
@@ -1099,13 +1086,6 @@ unsigned long ieee80211_tids_for_ac(int ac)
 	}
 }
 
-static struct txq_info *sta_txqi(const struct sta_info *sta, int tid)
-{
-	if (!sta->sta.txq[tid])
-		return NULL;
-	return to_txq_info(sta->sta.txq[tid]);
-}
-
 unsigned long ieee80211_sta_txq_buffered_tids(struct sta_info *sta)
 {
 	struct fq *fq = &sta->local->fq;
@@ -1180,8 +1160,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 		if (ignore_for_tim & ieee80211_ac_to_qos_mask[ac])
 			continue;
 
-		indicate_tim |= !skb_queue_empty(&sta->tx_filtered[ac]) ||
-				!skb_queue_empty(&sta->ps_tx_buf[ac]);
+		indicate_tim |= !skb_queue_empty(&sta->tx_filtered[ac]);
 		if (indicate_tim)
 			break;
 
@@ -1320,11 +1299,8 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 	have_buffered = sta_info_cleanup_expire_txqs(local, sta, ac);
 
 	/*
-	 * First check for frames that should expire on the filtered
-	 * queue. Frames here were rejected by the driver and are on
-	 * a separate queue to avoid reordering with normal PS-buffered
-	 * frames. They also aren't accounted for right now in the
-	 * total_ps_buffered counter.
+	 * Also check for frames that should expire on the filtered
+	 * queue. Frames here were rejected by the driver.
 	 */
 	for (;;) {
 		spin_lock_irqsave(&sta->tx_filtered[ac].lock, flags);
@@ -1346,35 +1322,6 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 		ieee80211_free_txskb(&local->hw, skb);
 	}
 
-	/*
-	 * Now also check the normal PS-buffered queue, this will
-	 * only find something if the filtered queue was emptied
-	 * since the filtered frames are all before the normal PS
-	 * buffered frames.
-	 */
-	for (;;) {
-		spin_lock_irqsave(&sta->ps_tx_buf[ac].lock, flags);
-		skb = skb_peek(&sta->ps_tx_buf[ac]);
-		if (sta_info_buffer_expired(sta, skb))
-			skb = __skb_dequeue(&sta->ps_tx_buf[ac]);
-		else
-			skb = NULL;
-		spin_unlock_irqrestore(&sta->ps_tx_buf[ac].lock, flags);
-
-		/*
-		 * frames are queued in order, so if this one
-		 * hasn't expired yet (or we reached the end of
-		 * the queue) we can stop testing
-		 */
-		if (!skb)
-			break;
-
-		local->total_ps_buffered--;
-		ps_dbg(sta->sdata, "Buffered frame expired (STA %pM)\n",
-		       sta->sta.addr);
-		ieee80211_free_txskb(&local->hw, skb);
-	}
-
 	/*
 	 * Finally, recalculate the TIM bit for this station -- it might
 	 * now be clear because the station was too slow to retrieve its
@@ -1387,9 +1334,7 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 	 * used to check whether the cleanup timer still needs to run,
 	 * if there are no frames we don't need to rearm the timer.
 	 */
-	return have_buffered ||
-	       !(skb_queue_empty(&sta->ps_tx_buf[ac]) &&
-		 skb_queue_empty(&sta->tx_filtered[ac]));
+	return have_buffered || !skb_queue_empty(&sta->tx_filtered[ac]);
 }
 
 static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
@@ -1950,9 +1895,11 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
+	struct txq_info *mmpdu_txqi = sta->mmpdu_txqi;
 	struct sk_buff_head pending;
 	int filtered = 0, buffered = 0, ac, i;
 	unsigned long flags;
+	struct sk_buff *skb;
 	struct ps_data *ps;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -1996,21 +1943,21 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	spin_lock_bh(&sta->ps_lock);
 	/* Send all buffered frames to the station */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		int count = skb_queue_len(&pending), tmp;
-
 		spin_lock_irqsave(&sta->tx_filtered[ac].lock, flags);
 		skb_queue_splice_tail_init(&sta->tx_filtered[ac], &pending);
 		spin_unlock_irqrestore(&sta->tx_filtered[ac].lock, flags);
-		tmp = skb_queue_len(&pending);
-		filtered += tmp - count;
-		count = tmp;
-
-		spin_lock_irqsave(&sta->ps_tx_buf[ac].lock, flags);
-		skb_queue_splice_tail_init(&sta->ps_tx_buf[ac], &pending);
-		spin_unlock_irqrestore(&sta->ps_tx_buf[ac].lock, flags);
-		tmp = skb_queue_len(&pending);
-		buffered += tmp - count;
 	}
+	filtered = skb_queue_len(&pending);
+
+	/* the internal management TXQ isn't serviced by the driver */
+	if (!sta->sta.txq[IEEE80211_NUM_TIDS]) {
+		rcu_read_lock();
+		while ((skb = ieee80211_tx_dequeue_ps_release(local,
+							      mmpdu_txqi)))
+			__skb_queue_tail(&pending, skb);
+		rcu_read_unlock();
+	}
+	buffered = skb_queue_len(&pending) - filtered;
 
 	ieee80211_add_pending_skbs(local, &pending);
 
@@ -2026,12 +1973,10 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 	atomic_dec(&ps->num_sta_ps);
 
-	local->total_ps_buffered -= buffered;
-
 	sta_info_recalc_tim(sta);
 
 	ps_dbg(sdata,
-	       "STA %pM aid %d sending %d filtered/%d PS frames since STA woke up\n",
+	       "STA %pM aid %d sending %d filtered/%d management frames since STA woke up\n",
 	       sta->sta.addr, sta->sta.aid, filtered, buffered);
 
 	ieee80211_check_fast_xmit(sta);
@@ -2165,7 +2110,6 @@ ieee80211_sta_ps_more_data(struct sta_info *sta, u8 ignored_acs,
 			continue;
 
 		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
-		    !skb_queue_empty(&sta->ps_tx_buf[ac]) ||
 		    buffered_tids & ieee80211_tids_for_ac(ac))
 			return true;
 	}
@@ -2246,9 +2190,7 @@ ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 			    unsigned long *driver_release_tids)
 {
 	unsigned long txq_buffered_tids = ieee80211_sta_txq_buffered_tids(sta);
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	bool from_txqs = ieee80211_sta_ps_from_txqs(sta);
-	struct ieee80211_local *local = sdata->local;
 	int ac;
 
 	/* Get response frame(s) and more data bit for the last one. */
@@ -2275,26 +2217,19 @@ ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 
 		if (!*driver_release_tids) {
 			unsigned long txq_tids;
-			int remaining;
 
 			n_frames = ieee80211_sta_ps_dequeue(&sta->tx_filtered[ac],
 							    n_frames, frames);
 			txq_tids = txq_buffered_tids & tids & mac80211_tids;
 			n_frames = ieee80211_sta_ps_dequeue_txqs(sta, txq_tids,
 								 n_frames, frames);
-
-			remaining = n_frames;
-			n_frames = ieee80211_sta_ps_dequeue(&sta->ps_tx_buf[ac],
-							    n_frames, frames);
-			local->total_ps_buffered -= remaining - n_frames;
 		}
 
 		/* If we have more frames buffered on this AC, then abort the
 		 * loop since we can't send more data from other ACs before
 		 * the buffered frames from this.
 		 */
-		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
-		    !skb_queue_empty(&sta->ps_tx_buf[ac]))
+		if (!skb_queue_empty(&sta->tx_filtered[ac]))
 			break;
 
 		if (ieee80211_sta_txq_buffered_tids(sta) & tids & mac80211_tids)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 307c8b76b80f..299cc06653ca 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -655,8 +655,8 @@ struct ieee80211_sta_removed_link_stats {
  * @listen_interval: listen interval of this station, when we're acting as AP
  * @_flags: STA flags, see &enum ieee80211_sta_info_flags, do not use directly
  * @ps_lock: used for powersave (when mac80211 is the AP) related locking
- * @ps_tx_buf: buffers (per AC) of frames to transmit to this station
- *	when it leaves power saving state or polls
+ * @mmpdu_txqi: the management TXQ, used internally even if the driver
+ *	doesn't want to use it
  * @tx_filtered: buffers (per AC) of frames we already tried to
  *	transmit but were filtered by hardware due to STA having
  *	entered power saving state, these are also delivered to
@@ -749,7 +749,7 @@ struct sta_info {
 
 	/* STA powersave lock and frame queues */
 	spinlock_t ps_lock;
-	struct sk_buff_head ps_tx_buf[IEEE80211_NUM_ACS];
+	struct txq_info *mmpdu_txqi;
 	struct sk_buff_head tx_filtered[IEEE80211_NUM_ACS];
 	unsigned long driver_buffered_tids;
 	unsigned long ps_release_tids;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index aca68ab112e0..32c36a54fb7e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -335,13 +335,16 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
 	struct sta_info *sta = NULL;
+	struct sk_buff *drop = NULL;
+	bool was_empty;
 	u32 flow_idx;
 
 	ieee80211_set_skb_enqueue_time(skb);
 
 	spin_lock_bh(&fq->lock);
 	/* TXQ becomes non-empty, update TIM if STA is sleeping */
-	if (txqi->txq.sta && !txq_has_queue(&txqi->txq)) {
+	was_empty = !txq_has_queue(&txqi->txq);
+	if (txqi->txq.sta) {
 		sta = container_of(txqi->txq.sta, struct sta_info, sta);
 		if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
 		    !test_sta_flag(sta, WLAN_STA_PS_DRIVER))
@@ -353,11 +356,17 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 	 * we don't want to apply any shaping or anything we just
 	 * want to simplify the driver API by having them on the
 	 * txqi.
+	 * They're not subject to the fq limits either, so limit the
+	 * number of them held for a station in powersave.
 	 */
 	if (unlikely(txqi->txq.tid == IEEE80211_NUM_TIDS)) {
-		IEEE80211_SKB_CB(skb)->control.flags |=
-			IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
-		__skb_queue_tail(&txqi->frags, skb);
+		if (sta && skb_queue_len(&txqi->frags) >= STA_MAX_TX_BUFFER) {
+			drop = skb;
+		} else {
+			IEEE80211_SKB_CB(skb)->control.flags |=
+				IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
+			__skb_queue_tail(&txqi->frags, skb);
+		}
 	} else {
 		flow_idx = fq_flow_idx(fq, skb);
 		fq_tin_enqueue(fq, tin, flow_idx, skb,
@@ -365,22 +374,29 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 	}
 	spin_unlock_bh(&fq->lock);
 
-	if (sta) {
+	if (unlikely(drop)) {
+		ps_dbg(sta->sdata,
+		       "STA %pM management TXQ full - dropping frame\n",
+		       sta->sta.addr);
+		ieee80211_free_txskb(&local->hw, drop);
+		return;
+	}
+
+	if (sta && was_empty) {
 		sta_info_recalc_tim(sta);
 		sta_info_schedule_cleanup(local);
 	}
 }
 
 /* This function is called whenever the AP is about to exceed the maximum limit
- * of buffered frames for power saving STAs. This situation should not really
- * happen often during normal operation, so dropping the oldest buffered packet
- * from each queue should be OK to make some room for new frames. */
+ * of buffered multicast frames for power saving STAs. This situation should not
+ * really happen often during normal operation, so dropping the oldest buffered
+ * packet from each queue should be OK to make some room for new frames. */
 static void purge_old_ps_buffers(struct ieee80211_local *local)
 {
 	int total = 0, purged = 0;
 	struct sk_buff *skb;
 	struct ieee80211_sub_if_data *sdata;
-	struct sta_info *sta;
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		struct ps_data *ps;
@@ -400,24 +416,6 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 		total += skb_queue_len(&ps->bc_buf);
 	}
 
-	/*
-	 * Drop one frame from each station from the lowest-priority
-	 * AC that has frames at all.
-	 */
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
-		int ac;
-
-		for (ac = IEEE80211_AC_BK; ac >= IEEE80211_AC_VO; ac--) {
-			skb = skb_dequeue(&sta->ps_tx_buf[ac]);
-			total += skb_queue_len(&sta->ps_tx_buf[ac]);
-			if (skb) {
-				purged++;
-				ieee80211_free_txskb(&local->hw, skb);
-				break;
-			}
-		}
-	}
-
 	local->total_ps_buffered = total;
 	ps_dbg_hw(&local->hw, "PS buffers full - purged %d frames\n", purged);
 }
@@ -508,7 +506,6 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
-	struct ieee80211_local *local = tx->local;
 
 	if (unlikely(!sta))
 		return TX_CONTINUE;
@@ -517,31 +514,32 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		      test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
 		      test_sta_flag(sta, WLAN_STA_PS_DELIVER)) &&
 		     !(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER))) {
-		int ac = skb_get_queue_mapping(tx->skb);
-
 		if (ieee80211_is_mgmt(hdr->frame_control) &&
 		    !ieee80211_is_bufferable_mmpdu(tx->skb)) {
 			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
 			return TX_CONTINUE;
 		}
 
+		/* if it's not uploaded we're before assoc, can't be sleeping */
+		if (unlikely(!sta->uploaded)) {
+			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+			return TX_CONTINUE;
+		}
+
 		/* continue and put the frame on the TXQ */
-		if (sta->uploaded &&
-		    (ieee80211_is_data_present(hdr->frame_control) ||
-		     sta->sta.txq[IEEE80211_NUM_TIDS]))
+		if (ieee80211_is_data_present(hdr->frame_control) ||
+		    sta->sta.txq[IEEE80211_NUM_TIDS])
 			return TX_CONTINUE;
 
-		ps_dbg(sta->sdata, "STA %pM aid %d: PS buffer for AC %d\n",
-		       sta->sta.addr, sta->sta.aid, ac);
-		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
-			purge_old_ps_buffers(tx->local);
+		ps_dbg(sta->sdata, "STA %pM aid %d: buffer management frame\n",
+		       sta->sta.addr, sta->sta.aid);
 
 		/* sync with ieee80211_sta_ps_deliver_wakeup */
 		spin_lock(&sta->ps_lock);
 		/*
-		 * STA woke up the meantime and all the frames on ps_tx_buf have
-		 * been queued to pending queue. No reordering can happen, go
-		 * ahead and Tx the packet.
+		 * STA woke up the meantime and all the frames on the internal
+		 * management TXQ have been queued to pending queue. No
+		 * reordering can happen, go ahead and Tx the packet.
 		 */
 		if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
 		    !test_sta_flag(sta, WLAN_STA_PS_DRIVER) &&
@@ -550,33 +548,10 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 			return TX_CONTINUE;
 		}
 
-		if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER) {
-			struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf[ac]);
-			ps_dbg(tx->sdata,
-			       "STA %pM TX buffer for AC %d full - dropping oldest frame\n",
-			       sta->sta.addr, ac);
-			ieee80211_free_txskb(&local->hw, old);
-		} else
-			tx->local->total_ps_buffered++;
-
-		info->control.jiffies = jiffies;
 		info->control.vif = &tx->sdata->vif;
-		info->control.flags |= IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
-		info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
-		skb_queue_tail(&sta->ps_tx_buf[ac], tx->skb);
+		ieee80211_txq_enqueue(tx->local, sta->mmpdu_txqi, tx->skb);
 		spin_unlock(&sta->ps_lock);
 
-		if (!timer_pending(&local->sta_cleanup))
-			mod_timer(&local->sta_cleanup,
-				  round_jiffies(jiffies +
-						STA_INFO_CLEANUP_INTERVAL));
-
-		/*
-		 * We queued up some frames, so the TIM bit might
-		 * need to be set, recalculate it.
-		 */
-		sta_info_recalc_tim(sta);
-
 		return TX_QUEUED;
 	} else if (unlikely(test_sta_flag(sta, WLAN_STA_PS_STA))) {
 		ps_dbg(tx->sdata,
@@ -1670,24 +1645,26 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
+	txqi->txq.sta = &sta->sta;
+	txqi->txq.tid = tid;
+
 	if (tid == IEEE80211_NUM_TIDS) {
+		txqi->txq.ac = IEEE80211_AC_VO;
+		sta->mmpdu_txqi = txqi;
+
+		/* driver opt-in, but we always use it internally */
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			/* Drivers need to opt in to the management MPDU TXQ */
 			if (!ieee80211_hw_check(&sdata->local->hw,
 						STA_MMPDU_TXQ))
 				return;
 		} else if (!ieee80211_hw_check(&sdata->local->hw,
 					       BUFF_MMPDU_TXQ)) {
-			/* Drivers need to opt in to the bufferable MMPDU TXQ */
 			return;
 		}
-		txqi->txq.ac = IEEE80211_AC_VO;
 	} else {
 		txqi->txq.ac = ieee80211_ac_from_tid(tid);
 	}
 
-	txqi->txq.sta = &sta->sta;
-	txqi->txq.tid = tid;
 	sta->sta.txq[tid] = &txqi->txq;
 }
 
-- 
2.56.0

