Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651929;
	b=ZMtJC/8U1UvgBIaP4aQjHGDmBr3s6jjEMN7IopMuB/67BaFormtQ/vorsV1p7F2T5klk
	 YE/Xqj33pIRVEbxhyh8easOTRPlf+TVMioSEPLFYUk2rfYr0nvNv0absRCJ3jxZ4lBGp7
	 FWmhPZgmHW1JE/KoCR+9Fa7c2bJFNsrgq8Opnp5aWDjf8tgAUfE3me8o1OM2K0L+T+OhI
	 rb0OSvBPDFMA4shwR1dK/joYn/dwEJJHYtXouA/bqchrY2gRBvTw6LGVwclLA+AmizKwZ
	 J1TaW/2a8H9G0CAkUcpzM9w2bvhj0wIodMotQGdKNNJ0RZcUrFi1K+i834238/aFxhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651929;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=C0f/RPDzUcAVbNgaJkVXrvesc+j3929fG+Ischo5iuc=;
	b=oi3G5GkDQHVaCL0yoOBWtw/MU7r5IVIc0mm4WoImiyttsmLGDzUYxerwxJ+WzwwSihZ4
	 AFRmLluqCnhHi5juefd8I4EJakYa+P7JeLg6dzIBriCPS/eeFwwZAdVheiBppT8No7G7i
	 S9ZhoSWkHpKhFbbTAfXMLQNCsS0KNBhmzIPPjIOnDgdN4JWYIgYlIeteAbzTkcH0LJm4z
	 1FkdIpbsCGrbO1Ow08UtvBE16mUWXvXw8vGWXKOTUTB4JbXaBfyrpP7TNNBBdSUb7f/YX
	 XmwUL5NHXB9mFVvofxX4s4Ae+lSrwAU3dK5TweqOAIDvMs16DjN3en1Z2QKadHV2Jyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=MxVSTKrb;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2DF606A32F
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=MxVSTKrb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=C0f/RPDzUcAVbNgaJkVXrvesc+j3929fG+Ischo5iuc=;
	t=1793651929; x=1794861529; b=MxVSTKrbjzov65nw85d42Kl3UZyHipdwjPhkgCJLgMGMdK6
	yZ5OHfbZkUlZXugLfPNrjsMXxUsz2vAz8O9swQl0qY9Ray7WvefZZ10cQ6e+Y90hOfGKrF9GwI8ZJ
	AfIgKmVewuULY8owR7xTxqYIPM0Ru5gkLWQVKeNEOTcNemVVYPHxjErb3BzoqSgwqfbFIl1rGr+c2
	iiKsc1rZJ270fbRh9g+G7A79mBUZvZhkrQE4jrRdS2mp0/RqzCp7lh6C4bm49BjFo/zto9ct00Rqm
	TqYIINCMY4JUu6dpbSYHt8oLDgj3Z3h46Vcr6lbfUVuElCpD+y5aAdTuuMvfRhyA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynl-00000001vzr-3qnz;
	Mon, 02 Nov 2026 21:38:46 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 12/30] wifi: mac80211: don't TX from TXQs of sleeping STAs
Date: Mon,  2 Nov 2026 21:23:02 +0100
Message-ID: <20261102203831.1058362-44-johannes@sipsolutions.net>
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

While a station is in powersave, frames still on its
TXQs are transmitted if the driver pulls from the TXQ,
but this isn't really right, it should only be done if
the station wakes up or is polling for them.

Disallow pulling from a TXQ when the station is asleep
unless it's a poll response, and document this.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  | 16 ++++++++++++----
 net/mac80211/mesh_ps.c  |  1 +
 net/mac80211/sta_info.c |  8 ++++++++
 net/mac80211/sta_info.h |  3 +++
 net/mac80211/tx.c       | 31 +++++++++++++++++++++++++++++++
 5 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a144f3fd5203..1e8f799193dc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3764,10 +3764,16 @@ void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
  * driver is also notified of powersave transitions by calling its
  * @sta_notify callback.
  *
+ * While the station is asleep (or blocked, see below), frames that are
+ * already on its TXQs remain there: the TXQs aren't scheduled, and
+ * ieee80211_tx_dequeue() doesn't return frames from them, except when
+ * they're released as described below.
+ *
  * When the station is asleep, it has three choices: it can wake up,
  * it can PS-Poll, or it can possibly start a uAPSD service period.
  * Waking up is implemented by simply transmitting all buffered (and
- * filtered) frames to the station. This is the easiest case. When
+ * filtered) frames to the station, and scheduling its TXQs again.
+ * This is the easiest case. When
  * the station sends a PS-Poll or a uAPSD trigger frame, mac80211
  * will inform the driver of this with the @allow_buffered_frames
  * callback; this callback is optional. mac80211 will then transmit
@@ -3812,8 +3818,9 @@ void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
  *
  * If the driver doesn't implement @allow_buffered_frames, the TIDs passed
  * to @release_buffered_frames also include those with frames on the
- * station's TXQs, and the driver should release these by dequeuing them
- * with ieee80211_tx_dequeue(). Otherwise, mac80211 releases the frames
+ * station's TXQs, and the driver must release these by dequeuing them
+ * with ieee80211_tx_dequeue() during that call, it can't dequeue them
+ * at any other time. Otherwise, mac80211 releases the frames
  * on the TXQs itself, in a separate service period.
  *
  * If the driver also implement GO mode, where absence periods may
@@ -4516,7 +4523,8 @@ struct ieee80211_prep_tx_info {
  *	The @tids parameter tells the driver which TIDs to release frames
  *	from, for PS-poll it will always have only a single bit set.
  *	If @allow_buffered_frames isn't implemented, frames for these TIDs
- *	may also be on the station's TXQs and should be released from there.
+ *	may also be on the station's TXQs, and can only be dequeued from
+ *	there during this call.
  *	In the case this is used for a PS-poll initiated release, the
  *	@num_frames parameter will always be 1 so code can be shared. In
  *	this case the driver must also set %IEEE80211_TX_STATUS_EOSP flag
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 0916de33e6a9..ddf35cdd558a 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -525,6 +525,7 @@ static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 		 * exchange.
 		 */
 		info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+		info->control.flags |= IEEE80211_TX_CTRL_PS_RESPONSE;
 
 		if (more_data || !skb_queue_is_last(&frames, skb))
 			hdr->frame_control |=
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7175dfa41b01..51504f57128f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1877,6 +1877,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 		return;
 
 	clear_sta_flag(sta, WLAN_STA_SP);
+	/* ensure flag clearing is visible to scheduled TXQs */
+	smp_mb__after_atomic();
 
 	BUILD_BUG_ON(BITS_TO_LONGS(IEEE80211_NUM_TIDS) > 1);
 	sta->driver_buffered_tids = 0;
@@ -2366,6 +2368,10 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 	} else {
 		int tid;
 
+		/* driver handles - allow it to release ... */
+		if (!ieee80211_sta_ps_from_txqs(sta))
+			WRITE_ONCE(sta->ps_release_tids, driver_release_tids);
+
 		/*
 		 * We need to release a frame that is buffered somewhere in the
 		 * driver ... it'll have to handle that.
@@ -2378,6 +2384,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		 */
 		drv_release_buffered_frames(local, sta, driver_release_tids,
 					    n_frames, reason, more_data);
+		/* ... until here it's not allowed to release any more */
+		WRITE_ONCE(sta->ps_release_tids, 0);
 
 		/*
 		 * Note that we don't recalculate the TIM bit here as it would
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8edb95ccbfab..cd3c89a6a25a 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -662,6 +662,8 @@ struct ieee80211_sta_removed_link_stats {
  *	entered power saving state, these are also delivered to
  *	the station when it leaves powersave or polls for frames
  * @driver_buffered_tids: bitmap of TIDs the driver has data buffered on
+ * @ps_release_tids: TIDs for which the driver can dequeue from TXQs during
+ *	during release_buffered_frames(), only non-zero during that
  * @assoc_at: clock boottime (in ns) of last association
  * @last_connected: time (in seconds) when a station got connected
  * @last_seq_ctrl: last received seq/frag number from this STA (per TID
@@ -748,6 +750,7 @@ struct sta_info {
 	struct sk_buff_head ps_tx_buf[IEEE80211_NUM_ACS];
 	struct sk_buff_head tx_filtered[IEEE80211_NUM_ACS];
 	unsigned long driver_buffered_tids;
+	unsigned long ps_release_tids;
 
 	u64 assoc_at;
 	long last_connected;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9c58faf571f4..0bd324a4d4cb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3903,6 +3903,22 @@ static bool ieee80211_drop_unauth_port(struct ieee80211_tx_data *tx)
 	return true;
 }
 
+static bool ieee80211_txq_ps_tx_ok(const struct txq_info *txqi)
+{
+	struct sta_info *sta;
+
+	if (!txqi->txq.sta || txqi->txq.tid == IEEE80211_NUM_TIDS)
+		return true;
+
+	sta = container_of(txqi->txq.sta, struct sta_info, sta);
+
+	if (likely(!test_sta_flag(sta, WLAN_STA_PS_STA) &&
+		   !test_sta_flag(sta, WLAN_STA_PS_DRIVER)))
+		return true;
+
+	return READ_ONCE(sta->ps_release_tids) & BIT(txqi->txq.tid);
+}
+
 static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 					      struct ieee80211_txq *txq,
 					      bool ps_release)
@@ -3930,6 +3946,9 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	if (ps_release) {
 		q_stopped = false;
 	} else {
+		if (!ieee80211_txq_ps_tx_ok(txqi))
+			return NULL;
+
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		q_stopped = local->queue_stop_reasons[q];
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
@@ -4169,6 +4188,14 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 	if (!txqi)
 		goto out;
 
+	if (!ieee80211_txq_ps_tx_ok(txqi)) {
+		/* reschedule on station wakeup */
+		list_del_init(&txqi->schedule_order);
+		if (txqi == head)
+			head = NULL;
+		goto begin;
+	}
+
 	if (txqi == head) {
 		if (!found_eligible_txq)
 			goto out;
@@ -4226,6 +4253,7 @@ void __ieee80211_schedule_txq(struct ieee80211_hw *hw,
 
 	has_queue = force ||
 		    (!test_bit(IEEE80211_TXQ_STOP, &txqi->flags) &&
+		     ieee80211_txq_ps_tx_ok(txqi) &&
 		     txq_has_queue(txq));
 	if (list_empty(&txqi->schedule_order) &&
 	    (has_queue || ieee80211_txq_keep_active(txqi))) {
@@ -4338,6 +4366,9 @@ bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
 	if (list_empty(&txqi->schedule_order))
 		goto out;
 
+	if (!ieee80211_txq_ps_tx_ok(txqi))
+		goto out;
+
 	if (!ieee80211_txq_schedule_airtime_check(local, ac))
 		goto out;
 
-- 
2.56.0

