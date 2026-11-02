Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793663773;
	b=k8ojSGpEYxWjS/kLQ/pfAVzBgdwzwl9z+pZOK9z/UpNz2cbhBsqp4c/muZZtF8iU8Tfy
	 lnpOr6MrdHSzKywsOhURzWJTNpbavO9ZXz/WKf/GdqFnOhrRruaU5wHwmYhsmBX2bGPBv
	 QBMzPzYJVasVeJOkGbCkyZZ/OmirZ3pplznF13KFwXa41vDFrW6lPBK5Nvc8wjrVYXIpP
	 3cSRKtLsCFOeN3ZRhYgzs8QVJmgbgPDzuryPyPLZHTO0RYqT/XYDqyq521yxEVCTK6vQy
	 d9++Ek5f5bHAnpbJybMpZO0/28+TMQnQyI9qmQn8IZ5dU4FlHbEOs6JwCIUNLTrEMTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793663773;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+gvoldmwYxkPa9VSEY8e9PSr59gp9t25tI57/a1fNIA=;
	b=wjz0/zILWf8+fA8TDhBp+voqbik0y1rM8Rd62sZHS9qCxGT0G+ctbg65b5bF8MRwYY4n
	 0xhxkBUEcRm5OgsUw/NBovSLOqUyozU/iIdT7X3fcehiy0ATu9ybtfwU7kkoWuafvss5L
	 XRYBOC7B1iHkUZnT27RLcmN2MtSMRftiDlC9WjeMM8jfLeyqF3B419Gbt2VzniGPkLA2X
	 YJZw9VLpm3whlB9Jg+L24c40DX9pmvqhWzXHr4bHmmfk1d4acKkWYOk86CvjVEYF97KLT
	 L9syziw8j/2ZoyYOOsIqJ3JEa8HGefJPyKnCA65EDKA8Y5vgAS6u8wKONrsMYqR7OfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=gBmtJixQ;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47429606D805
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 23:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=gBmtJixQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=+gvoldmwYxkPa9VSEY8e9PSr59gp9t25tI57/a1fNIA=;
	t=1793663772; x=1794873372; b=gBmtJixQBgYYAEKMMgJ6Jx+GcxMTwl4fbxB8WNOYlHMaT+I
	1Gf7BE2YARTobq3ybFMNqpkIJm4YsI9MGCV3JJOx4UvtwYZx6lAEbGOxJBE0xeuhMwKkLEyVq16Bc
	UsYam9dYVilnXwu2kZj3vQSR08E/Ns4wzI1f3MvwWFgzQdgyEkvYSoCs83Rxw4ecEFx/51xpYX9Fs
	57isvqAhjO4KRkPfeqnmK4NTTg4Gm67T5ihkZDFpqpDUVViJ9zKKuV+UuiQQeTPvEinumvOacc326
	ylr4cJUgW6zHqJuYmFChUKWEyfISAX9KN1vKs6tmph+IE34vnN8/fR1sGfS+4ICQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO1sn-00000002AZf-1cDZ;
	Tue, 03 Nov 2026 00:56:09 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 5/7] wifi: mac80211: asynchronously start TX BA sessions
Date: Tue,  3 Nov 2026 00:54:02 +0100
Message-ID: <20261102235603.1181883-14-johannes@sipsolutions.net>
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

When starting a TX BA session, mac80211 needs to wait
for an RCU grace period to have disabled fragmentation
and get the correct SSN, and uses synchronize_net() to
achieve that, with the wiphy mutex held.

Use wiphy_rcu_work instead to avoid blocking the mutex
for that. If the session was stopped, then just remove
it when the work runs, nothing cares yet.

Since the RCU work is cancelled and requeued whenever a
session start is deferred, it running implies that the
grace period has elapsed for all deferred sessions, so
only continue starting sessions from the RCU work, not
from the regular BA session work.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c      | 97 +++++++++++++++++++++++++++-----------
 net/mac80211/ht.c          | 35 +++++++++++---
 net/mac80211/ieee80211_i.h |  3 ++
 net/mac80211/sta_info.c    |  2 +
 net/mac80211/sta_info.h    |  5 ++
 5 files changed, 109 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index b49f0b3c0b9c..c56064243550 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -285,6 +285,22 @@ static void ieee80211_remove_tid_tx(struct sta_info *sta, int tid)
 	kfree_rcu(tid_tx, rcu_head);
 }
 
+static void ieee80211_agg_abort_start(struct sta_info *sta, int tid,
+				      struct tid_ampdu_tx *tid_tx)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+
+	spin_lock_bh(&sta->lock);
+	ieee80211_agg_splice_packets(sdata, tid_tx, tid);
+	ieee80211_assign_tid_tx(sta, tid, NULL);
+	ieee80211_agg_splice_finish(sdata, tid);
+	spin_unlock_bh(&sta->lock);
+
+	ieee80211_agg_start_txq(sta, tid, false);
+
+	kfree_rcu(tid_tx, rcu_head);
+}
+
 /* returns 1 if the driver must be notified after synchronize_net() */
 static int ieee80211_stop_tx_ba_session_prep(struct sta_info *sta, u16 tid,
 					     enum ieee80211_agg_stop_reason reason)
@@ -345,6 +361,12 @@ static int ieee80211_stop_tx_ba_session_prep(struct sta_info *sta, u16 tid,
 		return 0;
 	}
 
+	if (test_bit(HT_AGG_STATE_START_RCU, &tid_tx->state)) {
+		spin_unlock_bh(&sta->lock);
+		ieee80211_agg_abort_start(sta, tid, tid_tx);
+		return 0;
+	}
+
 	set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
 
 	ieee80211_agg_stop_txq(sta, tid);
@@ -528,7 +550,36 @@ static void ieee80211_send_addba_with_timeout(struct sta_info *sta,
 
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
-	struct tid_ampdu_tx *tid_tx;
+	struct tid_ampdu_tx *tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+
+	/*
+	 * Start queuing up packets for this aggregation session.
+	 * We're going to release them once the driver is OK with
+	 * that.
+	 */
+	clear_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
+
+	/*
+	 * Make sure no packets are being processed before telling the
+	 * driver. This ensures that we have a valid starting sequence
+	 * number and that in-flight packets have been flushed out and
+	 * no packets for this TID will go into the driver during the
+	 * ampdu_action call.
+	 */
+	set_bit(HT_AGG_STATE_START_RCU, &tid_tx->state);
+
+	/*
+	 * Cancel first so it waits for a new grace period (if already
+	 * queued), that way the RCU work only runs after _all_ TIDs
+	 * have passed a grace period.
+	 */
+	wiphy_rcu_work_cancel(sta->local->hw.wiphy, &sta->ampdu_mlme.rcu_work);
+	wiphy_rcu_work_queue(sta->local->hw.wiphy, &sta->ampdu_mlme.rcu_work);
+}
+
+static void ieee80211_tx_ba_session_start_drv(struct sta_info *sta, int tid,
+					      struct tid_ampdu_tx *tid_tx)
+{
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_ampdu_params params = {
@@ -541,23 +592,6 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	};
 	int ret;
 
-	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
-
-	/*
-	 * Start queuing up packets for this aggregation session.
-	 * We're going to release them once the driver is OK with
-	 * that.
-	 */
-	clear_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
-
-	/*
-	 * Make sure no packets are being processed. This ensures that
-	 * we have a valid starting sequence number and that in-flight
-	 * packets have been flushed out and no packets for this TID
-	 * will go into the driver during the ampdu_action call.
-	 */
-	synchronize_net();
-
 	tid_tx->ndp = ieee80211_s1g_use_ndp_ba(sdata, sta);
 	params.ssn = sta->tid_seq[tid] >> 4;
 	ret = drv_ampdu_action(local, sdata, &params);
@@ -575,21 +609,30 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		ht_dbg(sdata,
 		       "BA request denied - HW unavailable for %pM tid %d\n",
 		       sta->sta.addr, tid);
-		spin_lock_bh(&sta->lock);
-		ieee80211_agg_splice_packets(sdata, tid_tx, tid);
-		ieee80211_assign_tid_tx(sta, tid, NULL);
-		ieee80211_agg_splice_finish(sdata, tid);
-		spin_unlock_bh(&sta->lock);
-
-		ieee80211_agg_start_txq(sta, tid, false);
-
-		kfree_rcu(tid_tx, rcu_head);
+		ieee80211_agg_abort_start(sta, tid, tid_tx);
 		return;
 	}
 
 	ieee80211_send_addba_with_timeout(sta, tid_tx);
 }
 
+void ieee80211_tx_ba_session_handle_rcu(struct sta_info *sta, int tid,
+					bool blocked)
+{
+	struct tid_ampdu_tx *tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+
+	lockdep_assert_wiphy(sta->local->hw.wiphy);
+
+	if (!tid_tx ||
+	    !test_and_clear_bit(HT_AGG_STATE_START_RCU, &tid_tx->state))
+		return;
+
+	if (blocked)
+		ieee80211_agg_abort_start(sta, tid, tid_tx);
+	else
+		ieee80211_tx_ba_session_start_drv(sta, tid, tid_tx);
+}
+
 void ieee80211_refresh_tx_agg_session_timer(struct ieee80211_sta *pubsta,
 					    u16 tid)
 {
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 21c1d6e03c1f..0f918e4bde87 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -305,6 +305,8 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 	 */
 	if(reason == AGG_STOP_DESTROY_STA) {
 		wiphy_work_cancel(sta->local->hw.wiphy, &sta->ampdu_mlme.work);
+		wiphy_rcu_work_cancel(sta->local->hw.wiphy,
+				      &sta->ampdu_mlme.rcu_work);
 
 		for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 			struct tid_ampdu_tx *tid_tx =
@@ -319,10 +321,8 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 	}
 }
 
-void ieee80211_ba_session_work(struct wiphy *wiphy, struct wiphy_work *work)
+static void ieee80211_ba_session_process(struct sta_info *sta, bool rcu_done)
 {
-	struct sta_info *sta =
-		container_of(work, struct sta_info, ampdu_mlme.work);
 	struct tid_ampdu_tx *tid_tx;
 	bool blocked;
 	int tid;
@@ -382,9 +382,8 @@ void ieee80211_ba_session_work(struct wiphy *wiphy, struct wiphy_work *work)
 				/* Give the task working on the txq a chance
 				 * to send out the queued frags
 				 */
-				synchronize_net();
-
-				wiphy_work_queue(sdata->local->hw.wiphy, work);
+				wiphy_rcu_work_queue(sdata->local->hw.wiphy,
+						     &sta->ampdu_mlme.rcu_work);
 				return;
 			}
 
@@ -418,11 +417,35 @@ void ieee80211_ba_session_work(struct wiphy *wiphy, struct wiphy_work *work)
 		if (test_and_clear_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state))
 			__ieee80211_stop_tx_ba_session(sta, tid,
 						       AGG_STOP_LOCAL_REQUEST);
+
+		if (rcu_done) {
+			/* this may free tid_tx */
+			ieee80211_tx_ba_session_handle_rcu(sta, tid, blocked);
+
+			tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+			if (!tid_tx)
+				continue;
+		}
+
 		if (test_and_clear_bit(HT_AGG_STATE_STOP_CB, &tid_tx->state))
 			ieee80211_stop_tx_ba_cb(sta, tid, tid_tx);
 	}
 }
 
+void ieee80211_ba_session_work(struct wiphy *wiphy, struct wiphy_work *work)
+{
+	ieee80211_ba_session_process(container_of(work, struct sta_info,
+						  ampdu_mlme.work),
+				     false);
+}
+
+void ieee80211_ba_session_rcu_work(struct wiphy *wiphy, struct wiphy_work *work)
+{
+	ieee80211_ba_session_process(container_of(work, struct sta_info,
+						  ampdu_mlme.rcu_work.work),
+				     true);
+}
+
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 			  const u8 *da, u16 tid,
 			  u16 initiator, u16 reason_code,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2da93a4b9e8e..94540f6e23dd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2387,7 +2387,10 @@ void ieee80211_start_tx_ba_cb(struct sta_info *sta, int tid,
 void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
 			     struct tid_ampdu_tx *tid_tx);
 void ieee80211_ba_session_work(struct wiphy *wiphy, struct wiphy_work *work);
+void ieee80211_ba_session_rcu_work(struct wiphy *wiphy, struct wiphy_work *work);
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
+void ieee80211_tx_ba_session_handle_rcu(struct sta_info *sta, int tid,
+					bool blocked);
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
 
 u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 23166fc39729..17247ba3209f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -665,6 +665,8 @@ __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	spin_lock_init(&sta->ps_lock);
 	INIT_WORK(&sta->drv_deliver_wk, sta_deliver_ps_frames);
 	wiphy_work_init(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
+	wiphy_rcu_work_init(&sta->ampdu_mlme.rcu_work,
+			    ieee80211_ba_session_rcu_work);
 #ifdef CONFIG_MAC80211_MESH
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		sta->mesh = kzalloc_obj(*sta->mesh, gfp);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8c6a9fee6b29..2d9268db8cc8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -122,6 +122,8 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_START_CB		6
 #define HT_AGG_STATE_STOP_CB		7
 #define HT_AGG_STATE_SENT_ADDBA		8
+/* waiting for an RCU grace period before telling the driver to start */
+#define HT_AGG_STATE_START_RCU		9
 
 DECLARE_EWMA(avg_signal, 10, 8)
 enum ieee80211_agg_stop_reason {
@@ -277,6 +279,8 @@ struct tid_ampdu_rx {
  * @unexpected_agg: bitmap indicating which TID already sent a delBA due to
  *	unexpected aggregation related frames outside a session
  * @work: work struct for starting/stopping aggregation
+ * @rcu_work: work struct for continuing to start TX aggregation
+ *	after an RCU grace period
  * @tid_tx: aggregation info for Tx per TID
  * @tid_start_tx: sessions where start was requested, not just protected
  *	by wiphy mutex but also sta->lock
@@ -295,6 +299,7 @@ struct sta_ampdu_mlme {
 	unsigned long unexpected_agg[BITS_TO_LONGS(IEEE80211_NUM_TIDS)];
 	/* tx */
 	struct wiphy_work work;
+	struct wiphy_rcu_work rcu_work;
 	struct tid_ampdu_tx __rcu *tid_tx[IEEE80211_NUM_TIDS];
 	struct tid_ampdu_tx *tid_start_tx[IEEE80211_NUM_TIDS];
 	unsigned long last_addba_req_time[IEEE80211_NUM_TIDS];
-- 
2.56.0

