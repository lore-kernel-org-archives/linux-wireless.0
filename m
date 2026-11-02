Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651927;
	b=t1ZGRRn6rYjSHg8C4qJ9pDKcOJkW4F9W4QguoiWmqU+T10XaeepG7VAMWx4DL5Bw+flK
	 n6sQcWchzlFvtzrQRgQpI010Wx1+7oCayGHoxYrwtIoOUd7G7GwQml7hJbfRSNm00Ym6y
	 0oWJcTvoV7OwTK94+WK8TE8wvEiN8OvD5+IvQSMXHhqU3C4xq9wKZKN+A7UErK69T9reu
	 TSSY/rQ+2TFeVR+R6qbRjm6j8GF3qWCIxgxxKGP21bTOzZjqVRA47zJdYtVMcR+k2UQWP
	 c+LgGHDEwy5sTKJ1NCdJDTa+pQX9/xIspAZCQ15L8VSghs3klS+jxC1atUkzw6+9Rmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651927;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=szBOZ9GqnU5yWAlkUwt6AjXWTR8mRHGAcUcTI9Jm2NM=;
	b=NEhs716nXUCMDix9FosdLSvt2L5j2P3S992KapAPF/RsbHpvMLeMp7oZ0i4QNJ/DHFl+
	 X0xHcgF2XL9vrjrxGsc67SJQHlkrzSJ1CW7M5dpbDS1EUfFwGSWqS6bC6Fz4xlB/+f6O4
	 GHs2zbx1gre+YyYGIpw97oSK1IUtMU9nSTcjbvQvUuKudVpXn1CzT3t+jbWkYDugvJmUe
	 qdXYvbbRWOxy05Y6UF31FoioA1NfkE440mX1iN3xw5/vcfPFmwkLzuFr6G7Lm4igWX/5i
	 +c08j9lisSviq000y3vecS3xCTSjS2gG8zENFCJsEFR3/5Wn6Y7k9v6nO9mOVwp8Tpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=RpHFB6fA;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52198606EE8C
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=RpHFB6fA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=szBOZ9GqnU5yWAlkUwt6AjXWTR8mRHGAcUcTI9Jm2NM=;
	t=1793651926; x=1794861526; b=RpHFB6fAa1HhY1zX1uXcMDOwP0hzWLzaL8WPFjsf1EH+tEE
	+JWJPD6I9VAu2qxp6eYPm1yqFFuV42h7MWiyzTEY9Qqh+xuG2IZ78jtaeh8KF9A2OcSiw7DzYWOJ+
	hBlWUNuUiY1GJKacNst+M/k9TbUBOVROMQt9inAlnHcbRHP9zVbkTHOFRHRuxDHgbmLCGJMeTMaVy
	OScnTNaQhtDt/fyxLQou9+lxumAW6ObaobzQHBJgTKv+RJQFThcdJf1DStNK3X761E2Pg0z8pUGV2
	mMuOBpQ2bXF0Yglmn0pSjQXiJ4kNFVtceLN7bSe0WQ3B6s4FAWi4+BTHamknE76g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyni-00000001vzr-3zUU;
	Mon, 02 Nov 2026 21:38:43 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/30] wifi: mac80211: stop tracking TXQ-buffered TIDs for PS STAs
Date: Mon,  2 Nov 2026 21:22:59 +0100
Message-ID: <20261102203831.1058362-41-johannes@sipsolutions.net>
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

The txq_buffered_tids bitmap is initialized when the station goes
to sleep, not updated after. Frames are normally not put onto the
TXQs while a station is sleeping, but it might race (and thus get
it wrong), it's not updated when the TXQ is empty (drivers can
release frames from TXQs for PS-Poll etc.), and I want to switch
PS buffering to happen on TXQs.

Remove the bitmap, calculate the information when needed, and
update the TIM when we queue a frame onto a previously empty TXQ
as well as when sending a PS null response (as the TIM bitmap may
have been wrong in that case).

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c       |  2 --
 net/mac80211/sta_info.c | 40 +++++++++++++++++++++++++++++++++++-----
 net/mac80211/sta_info.h |  2 --
 net/mac80211/tx.c       | 12 ++++++++++++
 4 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ee1f33178d26..fede61d606fb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1692,8 +1692,6 @@ static void sta_ps_start(struct sta_info *sta)
 		if (!list_empty(&txqi->schedule_order))
 			list_del_init(&txqi->schedule_order);
 		spin_unlock(&local->active_txq_lock[txq->ac]);
-
-		assign_bit(tid, &sta->txq_buffered_tids, txq_has_queue(txq));
 	}
 
 	sta_info_recalc_tim(sta);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e9ca1f26a6bd..8e4b506b33a0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1099,9 +1099,33 @@ static unsigned long ieee80211_tids_for_ac(int ac)
 	}
 }
 
+static unsigned long ieee80211_sta_txq_buffered_tids(struct sta_info *sta)
+{
+	struct fq *fq = &sta->local->fq;
+	unsigned long tids = 0;
+	int tid;
+
+	if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
+	    !test_sta_flag(sta, WLAN_STA_PS_DRIVER))
+		return 0;
+
+	/* synchronize with enqueue */
+	spin_lock_bh(&fq->lock);
+	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
+		struct ieee80211_txq *txq = sta->sta.txq[tid];
+
+		if (txq && txq_has_queue(txq))
+			tids |= BIT(tid);
+	}
+	spin_unlock_bh(&fq->lock);
+
+	return tids;
+}
+
 static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 {
 	struct ieee80211_local *local = sta->local;
+	unsigned long txq_buffered_tids;
 	struct ps_data *ps;
 	bool indicate_tim = false;
 	u8 ignore_for_tim = sta->sta.uapsd_queues;
@@ -1141,6 +1165,8 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 	if (ignore_pending)
 		ignore_for_tim = BIT(IEEE80211_NUM_ACS) - 1;
 
+	txq_buffered_tids = ieee80211_sta_txq_buffered_tids(sta);
+
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		unsigned long tids;
 
@@ -1156,8 +1182,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 
 		indicate_tim |=
 			sta->driver_buffered_tids & tids;
-		indicate_tim |=
-			sta->txq_buffered_tids & tids;
+		indicate_tim |= txq_buffered_tids & tids;
 	}
 
  done:
@@ -1855,7 +1880,6 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 	BUILD_BUG_ON(BITS_TO_LONGS(IEEE80211_NUM_TIDS) > 1);
 	sta->driver_buffered_tids = 0;
-	sta->txq_buffered_tids = 0;
 
 	if (!ieee80211_hw_check(&local->hw, AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
@@ -2051,6 +2075,7 @@ static void
 ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 			    enum ieee80211_frame_release_type reason,
 			    struct sk_buff_head *frames,
+			    unsigned long txq_buffered_tids,
 			    unsigned long *driver_release_tids)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -2072,7 +2097,7 @@ ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 		if (skb_queue_empty(frames)) {
 			*driver_release_tids |=
 				sta->driver_buffered_tids & tids;
-			*driver_release_tids |= sta->txq_buffered_tids & tids;
+			*driver_release_tids |= txq_buffered_tids & tids;
 		}
 
 		if (!*driver_release_tids) {
@@ -2120,7 +2145,9 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 	__skb_queue_head_init(&frames);
 
 	ieee80211_sta_ps_get_frames(sta, n_frames, ignored_acs, reason,
-				    &frames, &driver_release_tids);
+				    &frames,
+				    ieee80211_sta_txq_buffered_tids(sta),
+				    &driver_release_tids);
 
 	more_data = ieee80211_sta_ps_more_data(sta, ignored_acs, reason, driver_release_tids);
 
@@ -2153,6 +2180,9 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		tid = 7 - 2 * ac;
 
 		ieee80211_send_null_response(sta, tid, reason, true, false);
+
+		/* the TIM bit may have been stale, e.g. due to a TXQ purge */
+		sta_info_recalc_tim(sta);
 	} else if (!driver_release_tids) {
 		struct sk_buff_head pending;
 		struct sk_buff *skb;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ebc70d2ad637..f3c22806cf6c 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -662,7 +662,6 @@ struct ieee80211_sta_removed_link_stats {
  *	entered power saving state, these are also delivered to
  *	the station when it leaves powersave or polls for frames
  * @driver_buffered_tids: bitmap of TIDs the driver has data buffered on
- * @txq_buffered_tids: bitmap of TIDs that mac80211 has txq data buffered on
  * @assoc_at: clock boottime (in ns) of last association
  * @last_connected: time (in seconds) when a station got connected
  * @last_seq_ctrl: last received seq/frag number from this STA (per TID
@@ -749,7 +748,6 @@ struct sta_info {
 	struct sk_buff_head ps_tx_buf[IEEE80211_NUM_ACS];
 	struct sk_buff_head tx_filtered[IEEE80211_NUM_ACS];
 	unsigned long driver_buffered_tids;
-	unsigned long txq_buffered_tids;
 
 	u64 assoc_at;
 	long last_connected;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 25ab54a89235..3304a3a9d144 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1428,6 +1428,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 {
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
+	struct sta_info *sta = NULL;
 	u32 flow_idx;
 
 	ieee80211_set_skb_enqueue_time(skb);
@@ -1444,11 +1445,22 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 			IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 		__skb_queue_tail(&txqi->frags, skb);
 	} else {
+		/* TXQ becomes non-empty, update TIM if STA is sleeping */
+		if (txqi->txq.sta && !txq_has_queue(&txqi->txq)) {
+			sta = container_of(txqi->txq.sta, struct sta_info, sta);
+			if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
+			    !test_sta_flag(sta, WLAN_STA_PS_DRIVER))
+				sta = NULL;
+		}
+
 		flow_idx = fq_flow_idx(fq, skb);
 		fq_tin_enqueue(fq, tin, flow_idx, skb,
 			       fq_skb_free_func);
 	}
 	spin_unlock_bh(&fq->lock);
+
+	if (sta)
+		sta_info_recalc_tim(sta);
 }
 
 static bool fq_vlan_filter_func(struct fq *fq, struct fq_tin *tin,
-- 
2.56.0

