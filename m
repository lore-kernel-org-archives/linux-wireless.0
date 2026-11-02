Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793663772;
	b=IqxxI9+Z7PMpVkApXDbiEgLtd2axnsQ/CCBeqS6yfpnPTm2O9uvGLHKPu+pynRD8AnDY
	 L2bDDeG0gegw5NkqbEXY+fl+nK4zuUu3x2Og37zRlvIj9yOLaXUL++KBgyagKdGRzyNNv
	 Ge9OkENLhzmhmo1rpWpgD4NrG29wbH7ck+ZRGy57SrsajjITvs63QB4tlNAimDtzt+T3m
	 SMQf5B3PGi/fgo/W0hq67uE0aSJcPlt8SOpQUtRC9xMTVl18sysg5T9XJ91g4oI31K4ZU
	 ARlrGIo9m3AsoNiy/zwAEzO25oKX143VjmHrFiM55isTWAFVc9DMKnK6aKTzmhnLHzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793663772;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=3ERChg+OCR80179qkkAowRsxMZ0NPjEQVEuHkRbaa60=;
	b=e4JcWhWtVxuiRpedvVs0RnUikoMSwN168uF7tYFcyxpFOL0shWCdfdHvE+Q9zK2ho284
	 pSaWnU+p1WR+OkxfE9GnU2vaCkuNXwo7ZKybqfQhjVQ6H7um41aLH/zAbMopM+ldBNPba
	 4ypwH8Oaqod64knVGAxOLdpxwRrRTPmL8MZEhdC2EnBmIU1CrUhe7O+s5kbbq03XlAbNQ
	 IpOmy07TCoqqHNmorufC42JBsu0vYf75AAXL5HcuigoAodQ3CegJTi/tAXX9Ose2m0L7E
	 yk80L5ow6nMl8/vQYuzsDBBRSoT4jsUbQnvMB4Ob4r7NZ+f61SsHhYg+3BAwZ3bli6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=WeMk5ffE;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322A7606D804
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 23:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=WeMk5ffE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=3ERChg+OCR80179qkkAowRsxMZ0NPjEQVEuHkRbaa60=;
	t=1793663772; x=1794873372; b=WeMk5ffERbn+Wnbraa5KeEOJwlHvnFRNs4ZXUKLvaejSs1x
	+W7QxvPwYetciFj2Bs9/4rz4ziQO0d1Nsv76THbMkvBAKtzEtkY+5h/F7udEl5tSzn/76tIn9xS3S
	n1odlWTGMzuqcV/5hueytDk3L4Ciu6+HjeyVaJEvFeDmQeLHmRM/yEhMMzlvZG2Vvch0QPP1KJ67z
	Z6k0E6EA31dX+AP1U+YDFYcaQmN4j+fs5udXLhBmbBmVtctXkz+MW118qJjFwZkHQqKiRWVTxlboo
	n0vx+crX+KRyqZkRHaONCBHFYK01dpOQv0URm02m6X3HEfp4DeIWG7nQYEB8F+9g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO1so-00000002AZf-0Grs;
	Tue, 03 Nov 2026 00:56:10 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 6/7] wifi: mac80211: asynchronously stop TX BA sessions
Date: Tue,  3 Nov 2026 00:54:03 +0100
Message-ID: <20261102235603.1181883-15-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102235603.1181883-9-johannes@sipsolutions.net>
References: <20261102235603.1181883-9-johannes@sipsolutions.net>
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

Similar to starting a session, stopping one requires an RCU
grace period so that the driver doesn't get A-MPDU frames for
a session it was told was stopped.

For these cases, tell the driver after the grace period via
the wiphy_rcu_work instead. If the session is torn down
synchronously (e.g. due to station removal) in the meantime,
the driver is told as part of that.

Keep the synchronous version for ieee80211_reserve_tid(),
where the driver expects the session to be stopped when it
returns.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c      | 59 ++++++++++++++++++++++++++++++++------
 net/mac80211/ht.c          | 22 ++++++++------
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/sta_info.h    |  4 ++-
 4 files changed, 69 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index c56064243550..e7314e2b6759 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -346,6 +346,9 @@ static int ieee80211_stop_tx_ba_session_prep(struct sta_info *sta, u16 tid,
 	 */
 	if (test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
 		spin_unlock_bh(&sta->lock);
+		/* the driver wasn't told yet, the caller can do that now */
+		if (test_and_clear_bit(HT_AGG_STATE_STOP_RCU, &tid_tx->state))
+			return 1;
 		if (reason != AGG_STOP_DESTROY_STA)
 			return -EALREADY;
 		ret = drv_ampdu_action(local, sta->sdata, &params);
@@ -395,14 +398,13 @@ static int ieee80211_stop_tx_ba_session_prep(struct sta_info *sta, u16 tid,
 }
 
 static void ieee80211_stop_tx_ba_session_finish(struct sta_info *sta, u16 tid,
-						enum ieee80211_agg_stop_reason reason)
+						bool destroy)
 {
 	struct ieee80211_ampdu_params params = {
 		.sta = &sta->sta,
 		.tid = tid,
-		.action = reason == AGG_STOP_DESTROY_STA ?
-				IEEE80211_AMPDU_TX_STOP_FLUSH :
-				IEEE80211_AMPDU_TX_STOP_CONT,
+		.action = destroy ? IEEE80211_AMPDU_TX_STOP_FLUSH :
+				    IEEE80211_AMPDU_TX_STOP_CONT,
 	};
 
 	lockdep_assert_wiphy(sta->local->hw.wiphy);
@@ -447,7 +449,37 @@ int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	if (!sta->local->in_reconfig)
 		synchronize_net();
 
-	ieee80211_stop_tx_ba_session_finish(sta, tid, reason);
+	ieee80211_stop_tx_ba_session_finish(sta, tid,
+					    reason == AGG_STOP_DESTROY_STA);
+
+	return 0;
+}
+
+/* like __ieee80211_stop_tx_ba_session() but tell the driver asynchronously */
+int ieee80211_stop_tx_ba_session_deferred(struct sta_info *sta, u16 tid,
+					  enum ieee80211_agg_stop_reason reason)
+{
+	struct tid_ampdu_tx *tid_tx;
+	int ret;
+
+	if (WARN_ON(reason == AGG_STOP_DESTROY_STA))
+		return -EINVAL;
+
+	ret = ieee80211_stop_tx_ba_session_prep(sta, tid, reason);
+	if (ret <= 0)
+		return ret;
+
+	if (sta->local->in_reconfig) {
+		ieee80211_stop_tx_ba_session_finish(sta, tid, false);
+		return 0;
+	}
+
+	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+	set_bit(HT_AGG_STATE_STOP_RCU, &tid_tx->state);
+
+	/* cancel first so it waits for a new grace period, as for start */
+	wiphy_rcu_work_cancel(sta->local->hw.wiphy, &sta->ampdu_mlme.rcu_work);
+	wiphy_rcu_work_queue(sta->local->hw.wiphy, &sta->ampdu_mlme.rcu_work);
 
 	return 0;
 }
@@ -470,7 +502,8 @@ void ieee80211_sta_stop_tx_ba_sessions(struct sta_info *sta,
 		synchronize_net();
 
 	for_each_set_bit(tid, &tids, IEEE80211_NUM_TIDS)
-		ieee80211_stop_tx_ba_session_finish(sta, tid, reason);
+		ieee80211_stop_tx_ba_session_finish(sta, tid,
+						    reason == AGG_STOP_DESTROY_STA);
 }
 
 /*
@@ -623,8 +656,15 @@ void ieee80211_tx_ba_session_handle_rcu(struct sta_info *sta, int tid,
 
 	lockdep_assert_wiphy(sta->local->hw.wiphy);
 
-	if (!tid_tx ||
-	    !test_and_clear_bit(HT_AGG_STATE_START_RCU, &tid_tx->state))
+	if (!tid_tx)
+		return;
+
+	if (test_and_clear_bit(HT_AGG_STATE_STOP_RCU, &tid_tx->state)) {
+		ieee80211_stop_tx_ba_session_finish(sta, tid, false);
+		return;
+	}
+
+	if (!test_and_clear_bit(HT_AGG_STATE_START_RCU, &tid_tx->state))
 		return;
 
 	if (blocked)
@@ -1141,6 +1181,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 		}
 
 	} else {
-		__ieee80211_stop_tx_ba_session(sta, tid, AGG_STOP_DECLINED);
+		ieee80211_stop_tx_ba_session_deferred(sta, tid,
+						      AGG_STOP_DECLINED);
 	}
 }
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 0f918e4bde87..5a881c6f3762 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -411,13 +411,11 @@ static void ieee80211_ba_session_process(struct sta_info *sta, bool rcu_done)
 		if (!tid_tx)
 			continue;
 
-		if (!blocked &&
-		    test_and_clear_bit(HT_AGG_STATE_START_CB, &tid_tx->state))
-			ieee80211_start_tx_ba_cb(sta, tid, tid_tx);
-		if (test_and_clear_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state))
-			__ieee80211_stop_tx_ba_session(sta, tid,
-						       AGG_STOP_LOCAL_REQUEST);
-
+		/*
+		 * Do this before anything that could set the START_RCU or
+		 * STOP_RCU bits (e.g. WANT_STOP handling below), since then
+		 * the grace period hasn't elapsed yet for this TID.
+		 */
 		if (rcu_done) {
 			/* this may free tid_tx */
 			ieee80211_tx_ba_session_handle_rcu(sta, tid, blocked);
@@ -427,6 +425,13 @@ static void ieee80211_ba_session_process(struct sta_info *sta, bool rcu_done)
 				continue;
 		}
 
+		if (!blocked &&
+		    test_and_clear_bit(HT_AGG_STATE_START_CB, &tid_tx->state))
+			ieee80211_start_tx_ba_cb(sta, tid, tid_tx);
+		if (test_and_clear_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state))
+			ieee80211_stop_tx_ba_session_deferred(sta, tid,
+							      AGG_STOP_LOCAL_REQUEST);
+
 		if (test_and_clear_bit(HT_AGG_STATE_STOP_CB, &tid_tx->state))
 			ieee80211_stop_tx_ba_cb(sta, tid, tid_tx);
 	}
@@ -498,7 +503,8 @@ void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_INITIATOR, 0,
 					       true);
 	else
-		__ieee80211_stop_tx_ba_session(sta, tid, AGG_STOP_PEER_REQUEST);
+		ieee80211_stop_tx_ba_session_deferred(sta, tid,
+						      AGG_STOP_PEER_REQUEST);
 }
 
 enum nl80211_smps_mode
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 94540f6e23dd..933336c9c838 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2391,6 +2391,8 @@ void ieee80211_ba_session_rcu_work(struct wiphy *wiphy, struct wiphy_work *work)
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
 void ieee80211_tx_ba_session_handle_rcu(struct sta_info *sta, int tid,
 					bool blocked);
+int ieee80211_stop_tx_ba_session_deferred(struct sta_info *sta, u16 tid,
+					  enum ieee80211_agg_stop_reason reason);
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
 
 u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 2d9268db8cc8..fdb4820755f2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -124,6 +124,8 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_SENT_ADDBA		8
 /* waiting for an RCU grace period before telling the driver to start */
 #define HT_AGG_STATE_START_RCU		9
+/* stopping, waiting for an RCU grace period before telling the driver */
+#define HT_AGG_STATE_STOP_RCU		10
 
 DECLARE_EWMA(avg_signal, 10, 8)
 enum ieee80211_agg_stop_reason {
@@ -279,7 +281,7 @@ struct tid_ampdu_rx {
  * @unexpected_agg: bitmap indicating which TID already sent a delBA due to
  *	unexpected aggregation related frames outside a session
  * @work: work struct for starting/stopping aggregation
- * @rcu_work: work struct for continuing to start TX aggregation
+ * @rcu_work: work struct for continuing to start/stop TX aggregation
  *	after an RCU grace period
  * @tid_tx: aggregation info for Tx per TID
  * @tid_start_tx: sessions where start was requested, not just protected
-- 
2.56.0

