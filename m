Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651922;
	b=pOqL2PeKHdrDdmDscCjqejn6BVH+udqVj3LWqEf81vQIAFA4XuszxLuF0E1Nmqg0RrNy
	 5MMvlsA+xVHWCZqh/4F73/hyBcGYXOCwnJcTbXHDIHt1Hma+FKhU0LhCDf8ypw4TWg/W1
	 WWs6SIvhs/0G6DR55yrii2ilfJs5Ju06RN2+EzbQR8OHlo3Kw8UEyTboPQjP6JxRDY3m3
	 8XgQMaj+xp+qcIHZ1zcOXG98NaLN2yUK0ircGlJYTQoTRBIKd7vC4AUGq2A5twP1gMLeN
	 1BcI7vAgB8HiiJt0ClkO6QVg/KA1TpGAJGNsdA4oQyhvOJDQSzSL043hQ9lZaEX0eLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651922;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=eJDHo/1f0IBMe6aVx9izsBvcb7pOrbqCUAMp6tabpno=;
	b=u/Ttqf3F2XwBRtQoQ/aj8an/rEEq8LknR7ddH8QfB+OPgYrol4C854BSz+fWrjE3q4CN
	 9qg66boLO1vVZQ7Iz5542j95IfiEvbQWFekkYNTG/oZQLu3wewHy9QIdsDpXz/n4sy345
	 W2W+Jl0FFSFErdQ1kSt9xE8+skslgCsN3p1850QCzCkzLutN7P8RbhL93mLub0EYTewGb
	 7QoHAkZLyj8dgQIBGJeq1Dq0CYlCRZrAlnTvDA98qDiLIRs4nRaPbQL/Z9urPRD0mnQon
	 8R6OdPIyXxVYnxT17I9wp3FZ7INkEqkJb0lwf3i3KKYJpu6vw6Wlp8dmxKTC/56/EUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=kwGS8sLf;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61C0606D82E
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=kwGS8sLf
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=eJDHo/1f0IBMe6aVx9izsBvcb7pOrbqCUAMp6tabpno=;
	t=1793651921; x=1794861521; b=kwGS8sLfE2PqVawOiQd7J3t4S8cdfeyhTOQQYn+E91irtyi
	sL1XyL/Gohd2xbMS1TxQFxd36tqzexvVHtNMG9RjQcUzimGXlUaCVkPCOB6KFoMWijvwPWja6ylG6
	MfCkgKEvYVKEzXAV5VbOF7sN+yGV4BYO054pkm9huh/hGWrqe3aSQqaYFPvJf5hDv85exW515yc0P
	Hv3KGb6cx1RwdOOfUzCT9baKUQ1nLC37UbiqyO5tufZzpSHe4RTaKIwton+52aBMl1f3QwZKkK+SQ
	rGFEGpHwwk7dY0IgIr4crtKTnEjxrhr/T0IeCz2k5ECcsd7mHA8i4bqgIjpbM0zQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynf-00000001vzr-3LWH;
	Mon, 02 Nov 2026 21:38:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/30] wifi: mac80211: remove aggregation queue stop reason
Date: Mon,  2 Nov 2026 21:22:56 +0100
Message-ID: <20261102203831.1058362-38-johannes@sipsolutions.net>
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

Similar to the previous cleanup, the aggregation-related queue
stop reason was only used for splicing packets to/from pending,
so it can go away now. The spinlock was only needed for that,
so remove that too.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c      | 51 --------------------------------------
 net/mac80211/ieee80211_i.h |  3 ---
 net/mac80211/main.c        |  4 +--
 3 files changed, 1 insertion(+), 57 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 497c0f3a7c35..304819e5309c 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -139,45 +139,6 @@ void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
 	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], tid_tx);
 }
 
-/*
- * When multiple aggregation sessions on multiple stations
- * are being created/destroyed simultaneously, we need to
- * refcount the global queue stop caused by that in order
- * to not get into a situation where one of the aggregation
- * setup or teardown re-enables queues before the other is
- * ready to handle that.
- *
- * These two functions take care of this issue by keeping
- * a global "agg_queue_stop" refcount.
- */
-static void __acquires(agg_queue)
-ieee80211_stop_queue_agg(struct ieee80211_sub_if_data *sdata, int tid)
-{
-	int queue = sdata->vif.hw_queue[ieee80211_ac_from_tid(tid)];
-
-	/* we do refcounting here, so don't use the queue reason refcounting */
-
-	if (atomic_inc_return(&sdata->local->agg_queue_stop[queue]) == 1)
-		ieee80211_stop_queue_by_reason(
-			&sdata->local->hw, queue,
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
-			false);
-	__acquire(agg_queue);
-}
-
-static void __releases(agg_queue)
-ieee80211_wake_queue_agg(struct ieee80211_sub_if_data *sdata, int tid)
-{
-	int queue = sdata->vif.hw_queue[ieee80211_ac_from_tid(tid)];
-
-	if (atomic_dec_return(&sdata->local->agg_queue_stop[queue]) == 0)
-		ieee80211_wake_queue_by_reason(
-			&sdata->local->hw, queue,
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
-			false);
-	__release(agg_queue);
-}
-
 static void
 ieee80211_agg_stop_txq(struct sta_info *sta, int tid)
 {
@@ -231,13 +192,9 @@ static void ieee80211_remove_tid_tx(struct sta_info *sta, int tid)
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
-	ieee80211_stop_queue_agg(sta->sdata, tid);
-
 	/* future packets must not find the tid_tx struct any more */
 	ieee80211_assign_tid_tx(sta, tid, NULL);
 
-	ieee80211_wake_queue_agg(sta->sdata, tid);
-
 	kfree_rcu(tid_tx, rcu_head);
 }
 
@@ -489,9 +446,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		       "BA request denied - HW unavailable for %pM tid %d\n",
 		       sta->sta.addr, tid);
 		spin_lock_bh(&sta->lock);
-		ieee80211_stop_queue_agg(sdata, tid);
 		ieee80211_assign_tid_tx(sta, tid, NULL);
-		ieee80211_wake_queue_agg(sdata, tid);
 		spin_unlock_bh(&sta->lock);
 
 		ieee80211_agg_start_txq(sta, tid, false);
@@ -723,13 +678,7 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 
 	drv_ampdu_action(local, sta->sdata, &params);
 
-	spin_lock_bh(&sta->lock);
-
-	ieee80211_stop_queue_agg(sta->sdata, tid);
 	set_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state);
-	ieee80211_wake_queue_agg(sta->sdata, tid);
-
-	spin_unlock_bh(&sta->lock);
 
 	ieee80211_agg_start_txq(sta, tid, true);
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9906a62ee99c..e05eadebbf8f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1406,7 +1406,6 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_DRIVER,
 	IEEE80211_QUEUE_STOP_REASON_PS,
 	IEEE80211_QUEUE_STOP_REASON_CSA,
-	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 	IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
@@ -1628,8 +1627,6 @@ struct ieee80211_local {
 	struct tasklet_struct tx_pending_tasklet;
 	struct tasklet_struct wake_txqs_tasklet;
 
-	atomic_t agg_queue_stop[IEEE80211_MAX_QUEUES];
-
 	/* number of interfaces with allmulti RX */
 	atomic_t iff_allmultis;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6e31076bcc10..1055a6752e27 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1030,10 +1030,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->ack_status_lock);
 	idr_init(&local->ack_status_frames);
 
-	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
+	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
 		skb_queue_head_init(&local->pending[i]);
-		atomic_set(&local->agg_queue_stop[i], 0);
-	}
 	tasklet_setup(&local->tx_pending_tasklet, ieee80211_tx_pending);
 	tasklet_setup(&local->wake_txqs_tasklet, ieee80211_wake_txqs);
 	tasklet_setup(&local->tasklet, ieee80211_tasklet_handler);
-- 
2.56.0

