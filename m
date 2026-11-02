Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651936;
	b=3nJRFx97QARHAPwsOBSQtZb3Il/Ymp7B8IUCQQQ82kHbcks1xgIlrGZ7RQm1PH6iw2e5
	 UvsMnNc/y6p3/ED65lFyZ1DlhiNyH11hiiLQ3mBZnG1VJ6BUa0/Yjhv0S0+9BGzA0twjJ
	 VgDAc1U1EunkGexJrQMzdaV1muitQXcf9HB82m/ZEDHWBQtskV5L2QxurakuIrLrmHc4Q
	 UuIDsiaCTI3FnPG25rQDwgtTidfWovlgDF1tRHk4zO8jM+Azth4fbdX4J6m7HXW/6LNcC
	 zedtQnCwvLBmytW6Dpybwi40PeUuHHG4jIi8QK7NGqGrNM5YLk1w3IsGpVCa1laJPNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651936;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FKG+detMvfe1YGMDMedkTD3DO47RpTdpaBCegxDdfu4=;
	b=BTGb4/v/jPDmfjQh0pOZB4AiowauMq2XEPOLuMkBkTcawi6bp83slrP/a7ndZRUYaecA
	 9BveCAcvVXZLW9/h9tA0qTx5Ee6xrTfF842g7A07yZGyyXjtyfcbLwRqcmqH8lI8pyA5Z
	 qbfi8x5MTlK1MngkM7i2sxrlzlWarFGKILenjdQpWweUHMIT4z7+3KFmqgnhgxbIzR2uB
	 1sXl94frWVEziytXYEokMTbJ+1Ajt+RuLtqgnmoOA5NEBUe/b4Bvyrs+aeZZVM7NqgoU6
	 IbpobUTZOAFYXFRooWfKsuZDC9C5KAZiSTx+xyOFQDe6D0GqCCtLCH10MEym6k+FjfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=TVunbb3f;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAA9606D823
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=TVunbb3f
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=FKG+detMvfe1YGMDMedkTD3DO47RpTdpaBCegxDdfu4=;
	t=1793651935; x=1794861535; b=TVunbb3fMQrTW1VVK3ajr6zkVZ/lciIhHuRtp3fLKdbzd51
	r2ogBVnkxhO9zYO+vLQ69j312dJhWcsJT7ESJHt4tPTThJBapMFXNf+OQkhSGEu6Kc8+hqovpNmVH
	00rSmnt6TUI0DJghkfWti/LihEVUYxyrn0BOxO10m2VUwmNAJ0AF8DoVC/UbWSYRSCbW1czscaOud
	V+1/KHmcaeIzQYdEf/pUMZtkTiKEimspU5HsixDxMd6FAAjP7SF8ZhpyKjFZeH066bXuKOHkQtjax
	RSP+OqhJzi7ory/LMpbx70OIzvE/TcB+B98arnZ7ghaeiAWnxPR6222YAIUmL6RA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynq-00000001vzr-2JCx;
	Mon, 02 Nov 2026 21:38:53 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 15/30] wifi: mac80211: handle the mgmt TXQ of sleeping STAs
Date: Mon,  2 Nov 2026 21:23:05 +0100
Message-ID: <20261102203831.1058362-47-johannes@sipsolutions.net>
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

Frames to a sleeping station are only transmitted when
it polls or wakes up, but the management TXQ doesn't
buffer frames right now. Change that, so we can later
get rid of the extra buffering layer.

Some frames aren't buffered, don't put those on a TXQ
at all, send them directly instead.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c       |  8 +++++--
 net/mac80211/sta_info.c | 46 ++++++++++++++++++++++-------------------
 net/mac80211/tx.c       | 22 +++++++++++---------
 3 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fede61d606fb..d17e06394142 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1684,10 +1684,14 @@ static void sta_ps_start(struct sta_info *sta)
 
 	ieee80211_clear_fast_xmit(sta);
 
-	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
+	for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
 		struct ieee80211_txq *txq = sta->sta.txq[tid];
-		struct txq_info *txqi = to_txq_info(txq);
+		struct txq_info *txqi;
 
+		if (!txq)
+			continue;
+
+		txqi = to_txq_info(txq);
 		spin_lock(&local->active_txq_lock[txq->ac]);
 		if (!list_empty(&txqi->schedule_order))
 			list_del_init(&txqi->schedule_order);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c536ab759fef..25cf1929fbfc 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1086,7 +1086,7 @@ unsigned long ieee80211_tids_for_ac(int ac)
 	/* If we ever support TIDs > 7, this obviously needs to be adjusted */
 	switch (ac) {
 	case IEEE80211_AC_VO:
-		return BIT(6) | BIT(7);
+		return BIT(6) | BIT(7) | BIT(IEEE80211_NUM_TIDS);
 	case IEEE80211_AC_VI:
 		return BIT(4) | BIT(5);
 	case IEEE80211_AC_BE:
@@ -1099,6 +1099,13 @@ unsigned long ieee80211_tids_for_ac(int ac)
 	}
 }
 
+static struct txq_info *sta_txqi(const struct sta_info *sta, int tid)
+{
+	if (!sta->sta.txq[tid])
+		return NULL;
+	return to_txq_info(sta->sta.txq[tid]);
+}
+
 unsigned long ieee80211_sta_txq_buffered_tids(struct sta_info *sta)
 {
 	struct fq *fq = &sta->local->fq;
@@ -1111,10 +1118,10 @@ unsigned long ieee80211_sta_txq_buffered_tids(struct sta_info *sta)
 
 	/* synchronize with enqueue */
 	spin_lock_bh(&fq->lock);
-	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
-		struct ieee80211_txq *txq = sta->sta.txq[tid];
+	for (tid = 0; tid <= IEEE80211_NUM_TIDS; tid++) {
+		struct txq_info *txqi = sta_txqi(sta, tid);
 
-		if (txq && txq_has_queue(txq))
+		if (txqi && txq_has_queue(&txqi->txq))
 			tids |= BIT(tid);
 	}
 	spin_unlock_bh(&fq->lock);
@@ -1243,15 +1250,13 @@ static bool sta_info_cleanup_expire_filtered_txqs(struct ieee80211_local *local,
 	__skb_queue_head_init(&expired);
 
 	spin_lock_bh(&fq->lock);
-	for_each_set_bit(tid, &tids, IEEE80211_NUM_TIDS) {
-		struct txq_info *txqi;
+	for_each_set_bit(tid, &tids, IEEE80211_NUM_TIDS + 1) {
+		struct txq_info *txqi = sta_txqi(sta, tid);
 		struct sk_buff *skb;
 
-		if (!sta->sta.txq[tid])
+		if (!txqi)
 			continue;
 
-		txqi = to_txq_info(sta->sta.txq[tid]);
-
 		while ((skb = skb_peek(&txqi->frags))) {
 			if (!(IEEE80211_SKB_CB(skb)->flags &
 			      IEEE80211_TX_INTFL_RETRANSMISSION))
@@ -2168,7 +2173,7 @@ int ieee80211_sta_ps_dequeue_txqs(const struct sta_info *sta, unsigned long tids
 		struct txq_info *txq;
 		struct sk_buff *skb;
 
-		txq = to_txq_info(sta->sta.txq[tid]);
+		txq = sta_txqi(sta, tid);
 		skb = ieee80211_tx_dequeue_ps_release(local, txq);
 		if (!skb) {
 			tids &= ~BIT(tid);
@@ -2213,12 +2218,14 @@ ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 
 	/* Get response frame(s) and more data bit for the last one. */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		unsigned long tids;
+		unsigned long tids, mac80211_tids;
 
 		if (ignored_acs & ieee80211_ac_to_qos_mask[ac])
 			continue;
 
 		tids = ieee80211_tids_for_ac(ac);
+		/* mac80211 releases frames from the management TXQ itself */
+		mac80211_tids = from_txqs ? tids : BIT(IEEE80211_NUM_TIDS);
 
 		/* if we already have frames from software, then we can't also
 		 * release from hardware queues
@@ -2227,21 +2234,19 @@ ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 			*driver_release_tids |=
 				sta->driver_buffered_tids & tids;
 			if (!from_txqs)
-				*driver_release_tids |= txq_buffered_tids & tids;
+				*driver_release_tids |= txq_buffered_tids & tids &
+							~BIT(IEEE80211_NUM_TIDS);
 		}
 
 		if (!*driver_release_tids) {
+			unsigned long txq_tids;
 			int remaining;
 
 			n_frames = ieee80211_sta_ps_dequeue(&sta->tx_filtered[ac],
 							    n_frames, frames);
-			if (from_txqs) {
-				unsigned long txq_tids = txq_buffered_tids & tids;
-				n_frames = ieee80211_sta_ps_dequeue_txqs(sta,
-									 txq_tids,
-									 n_frames,
-									 frames);
-			}
+			txq_tids = txq_buffered_tids & tids & mac80211_tids;
+			n_frames = ieee80211_sta_ps_dequeue_txqs(sta, txq_tids,
+								 n_frames, frames);
 
 			remaining = n_frames;
 			n_frames = ieee80211_sta_ps_dequeue(&sta->ps_tx_buf[ac],
@@ -2257,8 +2262,7 @@ ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 		    !skb_queue_empty(&sta->ps_tx_buf[ac]))
 			break;
 
-		if (from_txqs &&
-		    ieee80211_sta_txq_buffered_tids(sta) & tids)
+		if (ieee80211_sta_txq_buffered_tids(sta) & tids & mac80211_tids)
 			break;
 	}
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cc6996591853..6bace6ede373 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1278,7 +1278,9 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_txq *txq = NULL;
 
-	if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
+	/* TXQs buffer frames, send unbuffered ones directly */
+	if (info->flags & (IEEE80211_TX_CTL_SEND_AFTER_DTIM |
+			   IEEE80211_TX_CTL_NO_PS_BUFFER) ||
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
 		return NULL;
 
@@ -1486,6 +1488,14 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 	ieee80211_set_skb_enqueue_time(skb);
 
 	spin_lock_bh(&fq->lock);
+	/* TXQ becomes non-empty, update TIM if STA is sleeping */
+	if (txqi->txq.sta && !txq_has_queue(&txqi->txq)) {
+		sta = container_of(txqi->txq.sta, struct sta_info, sta);
+		if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
+		    !test_sta_flag(sta, WLAN_STA_PS_DRIVER))
+			sta = NULL;
+	}
+
 	/*
 	 * For management frames, don't really apply codel etc.,
 	 * we don't want to apply any shaping or anything we just
@@ -1497,14 +1507,6 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 			IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 		__skb_queue_tail(&txqi->frags, skb);
 	} else {
-		/* TXQ becomes non-empty, update TIM if STA is sleeping */
-		if (txqi->txq.sta && !txq_has_queue(&txqi->txq)) {
-			sta = container_of(txqi->txq.sta, struct sta_info, sta);
-			if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
-			    !test_sta_flag(sta, WLAN_STA_PS_DRIVER))
-				sta = NULL;
-		}
-
 		flow_idx = fq_flow_idx(fq, skb);
 		fq_tin_enqueue(fq, tin, flow_idx, skb,
 			       fq_skb_free_func);
@@ -3986,7 +3988,7 @@ static bool ieee80211_txq_ps_tx_ok(const struct txq_info *txqi)
 {
 	struct sta_info *sta;
 
-	if (!txqi->txq.sta || txqi->txq.tid == IEEE80211_NUM_TIDS)
+	if (!txqi->txq.sta)
 		return true;
 
 	sta = container_of(txqi->txq.sta, struct sta_info, sta);
-- 
2.56.0

