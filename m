Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651927;
	b=yDqKdcYZUgVmLd9sED7jrG7PLd442+FgfdnfsBN+lFVZur5xh+Pgui8rsyo0RhqDxUo6
	 Hf7TZzfq8jnZcVOohYTknKNmXrA+TFx4a9MKaYwM3eUfrDD/Njf/nzvssz9xAziTcGcWB
	 0HQs1qmDwSjJMYnlJJ4tBa7FOv+ubTlu49tFE3OI+LyTUh4cBSncD7YXdDqU33G5GK6aR
	 Jm9PFgcCqC4HVsrd8JNPQPsCJcrC5Hv4dEVZtW8riixya5/tXJATgnbMmNP5RDW+i3Dvd
	 EhO0u9xKGIsgpt98YxEIzEItMgdJ6yLhC2JcqNBw2tjQEtJqDSiPyL8+fNrfTV/Yy3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651927;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=OxkP7CVJvMPuMp8jR9Vlrih3KvoJT0iQI6BJIFsdQdE=;
	b=WU4mb/q4bae8cYjuEPy492ar7wSqD2FAQLQvy9UabAAaf4Ez8EWWtL/8nIQOgOvQ7oXQ
	 Xa/ThKTiCX5JSgU7IQckOz4zsLKLUbIZ9BpqlNb/2QYX9jXxNJstgLJl0nUWEYe8j5Hyu
	 6rH0LBxt2Ufoa/w+t/EmK41BOIlSMKawmnXNAt0e2OIn+iixZM4mIMJQksCxY0KlijAl8
	 zhSLHLjHGgNUSKdI+hZFmr77x6/XmqtWSsTrNdT1LPazf3Ck1P+y5JCXksFWv0cojHCxY
	 vQUGTimOybTTjhwLY00p4J8xgG3W0xY1P2jYnQGnqLUn5mZLgZ6qvkTct0RvyiK0wqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ECTBYEp2;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520F7606A33A
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ECTBYEp2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=OxkP7CVJvMPuMp8jR9Vlrih3KvoJT0iQI6BJIFsdQdE=;
	t=1793651926; x=1794861526; b=ECTBYEp2jx5ALTx8G4PPLyQBamZfqI6Dgmf/E/qHbIXgi1R
	b5RS7i9a5O+K/tc6brGXY9ehws0nK/3XwIjjBYPwRiSm5bSVvblSX3vCF68lghosW5kiO1W93hrC7
	DlbFbCko3kPrOPwC2gthy+kDpivWKY/Fjdf60nlSud0evza8ORjoqkkOZAwrpZGPoiGGF1+S9vXkH
	0qGqVDKBZ3l5C2y0qZ1FvD84eF6I2VxRTysq5LHESDATPvZi6c1vrrmjcLy0RH59IH4l2pDjjRq+o
	TLk9hXN6Tr4uPdAI6ou3IqnTlw7H24yLlW0uf2NlYrGTGnkSWOIpJy7/S7sTgndA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynk-00000001vzr-0f7P;
	Mon, 02 Nov 2026 21:38:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/30] wifi: mac80211: release frames from TXQs to PS stations
Date: Mon,  2 Nov 2026 21:23:00 +0100
Message-ID: <20261102203831.1058362-42-johannes@sipsolutions.net>
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

When a station goes to sleep, frames may be on its TXQs.
These are indicated in the TIM but for most drivers are
never released. Since the goal is to buffer frames on
TXQs start here by releasing them when requested by the
station.

Also consider them for the more-data bit, and document this.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  11 +++-
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/sta_info.c    | 116 +++++++++++++++++++++++++++++++------
 net/mac80211/tx.c          |  29 ++++++++--
 4 files changed, 132 insertions(+), 26 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ddaa311f6208..a144f3fd5203 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3771,7 +3771,8 @@ void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
  * the station sends a PS-Poll or a uAPSD trigger frame, mac80211
  * will inform the driver of this with the @allow_buffered_frames
  * callback; this callback is optional. mac80211 will then transmit
- * the frames as usual and set the %IEEE80211_TX_CTL_NO_PS_BUFFER
+ * the frames, including frames it took from the station's TXQs,
+ * via the @tx callback and set the %IEEE80211_TX_CTL_NO_PS_BUFFER
  * on each frame. The last frame in the service period (or the only
  * response to a PS-Poll) also has %IEEE80211_TX_STATUS_EOSP set to
  * indicate that it ends the service period; as this frame must have
@@ -3809,6 +3810,12 @@ void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
  * from are ignored since mac80211 doesn't know how many frames the
  * buffers for those TIDs contain.
  *
+ * If the driver doesn't implement @allow_buffered_frames, the TIDs passed
+ * to @release_buffered_frames also include those with frames on the
+ * station's TXQs, and the driver should release these by dequeuing them
+ * with ieee80211_tx_dequeue(). Otherwise, mac80211 releases the frames
+ * on the TXQs itself, in a separate service period.
+ *
  * If the driver also implement GO mode, where absence periods may
  * shorten service periods (or abort PS-Poll responses), it must
  * filter those response frames except in the case of frames that
@@ -4508,6 +4515,8 @@ struct ieee80211_prep_tx_info {
  *	more-data bit must always be set.
  *	The @tids parameter tells the driver which TIDs to release frames
  *	from, for PS-poll it will always have only a single bit set.
+ *	If @allow_buffered_frames isn't implemented, frames for these TIDs
+ *	may also be on the station's TXQs and should be released from there.
  *	In the case this is used for a PS-poll initiated release, the
  *	@num_frames parameter will always be 1 so code can be shared. In
  *	this case the driver must also set %IEEE80211_TX_STATUS_EOSP flag
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e05eadebbf8f..5045144641a4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2722,6 +2722,8 @@ void ieee80211_txq_teardown_flows(struct ieee80211_local *local);
 void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 			struct sta_info *sta,
 			struct txq_info *txq, int tid);
+struct sk_buff *ieee80211_tx_dequeue_ps_release(struct ieee80211_local *local,
+						struct txq_info *txqi);
 void ieee80211_txq_purge(struct ieee80211_local *local,
 			 struct txq_info *txqi);
 void ieee80211_purge_sta_txqs(struct sta_info *sta);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8e4b506b33a0..78a4c7d7ed1b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2048,6 +2048,7 @@ ieee80211_sta_ps_more_data(struct sta_info *sta, u8 ignored_acs,
 			   enum ieee80211_frame_release_type reason,
 			   unsigned long driver_release_tids)
 {
+	unsigned long buffered_tids;
 	int ac;
 
 	/* If the driver has data on more than one TID then
@@ -2059,26 +2060,99 @@ ieee80211_sta_ps_more_data(struct sta_info *sta, u8 ignored_acs,
 	    hweight16(driver_release_tids) > 1)
 		return true;
 
+	buffered_tids = sta->driver_buffered_tids |
+			ieee80211_sta_txq_buffered_tids(sta);
+	buffered_tids &= ~driver_release_tids;
+
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		if (ignored_acs & ieee80211_ac_to_qos_mask[ac])
 			continue;
 
 		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
-		    !skb_queue_empty(&sta->ps_tx_buf[ac]))
+		    !skb_queue_empty(&sta->ps_tx_buf[ac]) ||
+		    buffered_tids & ieee80211_tids_for_ac(ac))
 			return true;
 	}
 
 	return false;
 }
 
+static bool ieee80211_sta_ps_from_txqs(const struct sta_info *sta)
+{
+	struct ieee80211_local *local = sta->local;
+
+	if (sta->sdata->vif.offload_flags & IEEE80211_OFFLOAD_ENCAP_ENABLED)
+		return false;
+
+	return !local->ops->release_buffered_frames ||
+	       local->ops->allow_buffered_frames;
+}
+
+/* multiple fragments count as a single buffer unit (BU) */
+static bool ieee80211_sta_ps_frame_ends_bu(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+
+	if (IEEE80211_SKB_CB(skb)->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+		return true;
+
+	return !ieee80211_has_morefrags(hdr->frame_control);
+}
+
+static int ieee80211_sta_ps_dequeue_txqs(const struct sta_info *sta,
+					 unsigned long tids, int n_frames,
+					 struct sk_buff_head *frames)
+{
+	struct ieee80211_local *local = sta->local;
+
+	local_bh_disable();
+	rcu_read_lock();
+
+	while (n_frames > 0 && tids) {
+		int tid = find_highest_prio_tid(tids);
+		struct txq_info *txq;
+		struct sk_buff *skb;
+
+		txq = to_txq_info(sta->sta.txq[tid]);
+		skb = ieee80211_tx_dequeue_ps_release(local, txq);
+		if (!skb) {
+			tids &= ~BIT(tid);
+			continue;
+		}
+
+		__skb_queue_tail(frames, skb);
+		if (ieee80211_sta_ps_frame_ends_bu(skb))
+			n_frames--;
+	}
+
+	rcu_read_unlock();
+	local_bh_enable();
+
+	return n_frames;
+}
+
+static int ieee80211_sta_ps_dequeue(struct sk_buff_head *queue, int n_frames,
+				    struct sk_buff_head *frames)
+{
+	struct sk_buff *skb;
+
+	while (n_frames > 0 && (skb = skb_dequeue(queue))) {
+		__skb_queue_tail(frames, skb);
+		n_frames--;
+	}
+
+	return n_frames;
+}
+
 static void
 ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 			    enum ieee80211_frame_release_type reason,
 			    struct sk_buff_head *frames,
-			    unsigned long txq_buffered_tids,
 			    unsigned long *driver_release_tids)
 {
+	unsigned long txq_buffered_tids = ieee80211_sta_txq_buffered_tids(sta);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	bool from_txqs = ieee80211_sta_ps_from_txqs(sta);
 	struct ieee80211_local *local = sdata->local;
 	int ac;
 
@@ -2097,25 +2171,27 @@ ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 		if (skb_queue_empty(frames)) {
 			*driver_release_tids |=
 				sta->driver_buffered_tids & tids;
-			*driver_release_tids |= txq_buffered_tids & tids;
+			if (!from_txqs)
+				*driver_release_tids |= txq_buffered_tids & tids;
 		}
 
 		if (!*driver_release_tids) {
-			struct sk_buff *skb;
+			int remaining;
 
-			while (n_frames > 0) {
-				skb = skb_dequeue(&sta->tx_filtered[ac]);
-				if (!skb) {
-					skb = skb_dequeue(
-						&sta->ps_tx_buf[ac]);
-					if (skb)
-						local->total_ps_buffered--;
-				}
-				if (!skb)
-					break;
-				n_frames--;
-				__skb_queue_tail(frames, skb);
+			n_frames = ieee80211_sta_ps_dequeue(&sta->tx_filtered[ac],
+							    n_frames, frames);
+			if (from_txqs) {
+				unsigned long txq_tids = txq_buffered_tids & tids;
+				n_frames = ieee80211_sta_ps_dequeue_txqs(sta,
+									 txq_tids,
+									 n_frames,
+									 frames);
 			}
+
+			remaining = n_frames;
+			n_frames = ieee80211_sta_ps_dequeue(&sta->ps_tx_buf[ac],
+							    n_frames, frames);
+			local->total_ps_buffered -= remaining - n_frames;
 		}
 
 		/* If we have more frames buffered on this AC, then abort the
@@ -2125,6 +2201,10 @@ ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
 		    !skb_queue_empty(&sta->ps_tx_buf[ac]))
 			break;
+
+		if (from_txqs &&
+		    ieee80211_sta_txq_buffered_tids(sta) & tids)
+			break;
 	}
 }
 
@@ -2145,9 +2225,7 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 	__skb_queue_head_init(&frames);
 
 	ieee80211_sta_ps_get_frames(sta, n_frames, ignored_acs, reason,
-				    &frames,
-				    ieee80211_sta_txq_buffered_tids(sta),
-				    &driver_release_tids);
+				    &frames, &driver_release_tids);
 
 	more_data = ieee80211_sta_ps_more_data(sta, ignored_acs, reason, driver_release_tids);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3304a3a9d144..9c58faf571f4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3903,8 +3903,9 @@ static bool ieee80211_drop_unauth_port(struct ieee80211_tx_data *tx)
 	return true;
 }
 
-struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
-				     struct ieee80211_txq *txq)
+static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
+					      struct ieee80211_txq *txq,
+					      bool ps_release)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct txq_info *txqi = container_of(txq, struct txq_info, txq);
@@ -3922,13 +3923,17 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
-	if (!ieee80211_txq_airtime_check(hw, txq))
+	if (!ps_release && !ieee80211_txq_airtime_check(hw, txq))
 		return NULL;
 
 begin:
-	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	q_stopped = local->queue_stop_reasons[q];
-	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+	if (ps_release) {
+		q_stopped = false;
+	} else {
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		q_stopped = local->queue_stop_reasons[q];
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+	}
 
 	if (unlikely(q_stopped)) {
 		/* mark for waking later */
@@ -4096,8 +4101,20 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
 	return skb;
 }
+
+struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
+				     struct ieee80211_txq *txq)
+{
+	return __ieee80211_tx_dequeue(hw, txq, false);
+}
 EXPORT_SYMBOL(ieee80211_tx_dequeue);
 
+struct sk_buff *ieee80211_tx_dequeue_ps_release(struct ieee80211_local *local,
+						struct txq_info *txqi)
+{
+	return __ieee80211_tx_dequeue(&local->hw, &txqi->txq, true);
+}
+
 static inline s32 ieee80211_sta_deficit(struct sta_info *sta, u8 ac)
 {
 	struct airtime_info *air_info = &sta->airtime[ac];
-- 
2.56.0

