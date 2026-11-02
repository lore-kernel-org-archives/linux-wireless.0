Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651922;
	b=fukeogTVvzC4Wzz9pW77bP1nUgMcAto/I+akD2+OHclRsENxrh9+0Oftw/o1N17Jc5QE
	 enxA4aCgKZyDNCJZUHTKADFU3OM4CBOOxATnxXp+aWAVKrAmo1+OyUnvhoC2yJeDTYN7N
	 te2f8yb60iutHN+It6zBN+wEcoC3frYy0c32PE7ETBo9ja8JgAxVSAcsnctirnXzbHhmz
	 e6v7asoWhLn/8VQ2iCkpWDAzDCEoPgzznsycriFjI+wy79L1dfyOArscNM7ohBzGBJ87/
	 tAwPRpX4RZfrUM4uQUfI74i/lfksM/OFtvliO02nCOAf9cWXXwzrcwFW1CeFTHBT1uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651922;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Qv1deLo8VS5h77k3CQlSbnwvn0HYiw1uMUTnDdXM7F4=;
	b=Yyxibp6NsHbZS3JXuclywFcjgpQwc4wFH056Yy7OveWokZ7CoYzmINJsg0NTaf5TDQ7X
	 iit4gssAJjYItq+ayuHid3UwYWx1W+MFfij08oB9x93vPl4BMdb7Opz84XlqcGG/eBfuw
	 YFuhQAGLUftaO0uoV9oCnFZ83mMYr5JeB8BZwpo4fCQWd6Sj2E23sjU8qyjIlkocGgdLf
	 uy4tKL4ceUJpy7m8UsYPxrhdqVYZZXch7KyxjkZjo1Vnl8SEZK1pmBXwd6MR84VcxXDwZ
	 J9800yt3sFgmISne8OkpaJnjr/UE0qFwEUDHtwT73fm4sdRfoxNvzVU44BY+cC2XE5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=NH+YdaJz;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42AA606D832
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=NH+YdaJz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Qv1deLo8VS5h77k3CQlSbnwvn0HYiw1uMUTnDdXM7F4=;
	t=1793651921; x=1794861521; b=NH+YdaJz4RVz4LFz7JN64clg5XPh1YShZRP8YRdj3BQdOFt
	A3QrO0TfvRsggCxc4+yPGfnlTv23dmHZaJEq+ipdwEdJh8eWvKldE/EDfjSt7qlBLT+P3RJ5MNcj2
	1iJd18jYt9E44iYkArTH7nWAneYPZ+c9X5akqjKk4xC0FTCJuDeYCkuQ2hbK3lA4Of3LYI11fFbaJ
	IcY8GL3ORwaovMUcIG/xLERXniqMzWq4qlXXeUkiCLXuiCrtQUpzC/t2JukTIVC6OToWe8Up9mbH4
	a4KVzHHhjdPUAxeKtvlGz8trBPJMMkrh3cZWeW8O8zQhkAQW+tVdkoDMj2ThHTTg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynf-00000001vzr-0GDp;
	Mon, 02 Nov 2026 21:38:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/30] wifi: mac80211: remove tid_tx->pending
Date: Mon,  2 Nov 2026 21:22:55 +0100
Message-ID: <20261102203831.1058362-37-johannes@sipsolutions.net>
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

The previous commit removed the last code that put any frames
onto tid_tx->pending, so the remove all associated code now.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c      | 71 ++++----------------------------------
 net/mac80211/debugfs_sta.c |  4 +--
 net/mac80211/sta_info.c    |  7 +---
 net/mac80211/sta_info.h    |  2 --
 4 files changed, 8 insertions(+), 76 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index f3ecdd8601a0..497c0f3a7c35 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -222,40 +222,6 @@ ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
 	local_bh_enable();
 }
 
-/*
- * splice packets from the STA's pending to the local pending,
- * requires a call to ieee80211_agg_splice_finish later
- */
-static void __acquires(agg_queue)
-ieee80211_agg_splice_packets(struct ieee80211_sub_if_data *sdata,
-			     struct tid_ampdu_tx *tid_tx, u16 tid)
-{
-	struct ieee80211_local *local = sdata->local;
-	int queue = sdata->vif.hw_queue[ieee80211_ac_from_tid(tid)];
-	unsigned long flags;
-
-	ieee80211_stop_queue_agg(sdata, tid);
-
-	if (WARN(!tid_tx,
-		 "TID %d gone but expected when splicing aggregates from the pending queue\n",
-		 tid))
-		return;
-
-	if (!skb_queue_empty(&tid_tx->pending)) {
-		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		/* copy over remaining packets */
-		skb_queue_splice_tail_init(&tid_tx->pending,
-					   &local->pending[queue]);
-		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
-	}
-}
-
-static void __releases(agg_queue)
-ieee80211_agg_splice_finish(struct ieee80211_sub_if_data *sdata, u16 tid)
-{
-	ieee80211_wake_queue_agg(sdata, tid);
-}
-
 static void ieee80211_remove_tid_tx(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx;
@@ -265,22 +231,12 @@ static void ieee80211_remove_tid_tx(struct sta_info *sta, int tid)
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
-	/*
-	 * When we get here, the TX path will not be lockless any more wrt.
-	 * aggregation, since the OPERATIONAL bit has long been cleared.
-	 * Thus it will block on getting the lock, if it occurs. So if we
-	 * stop the queue now, we will not get any more packets, and any
-	 * that might be being processed will wait for us here, thereby
-	 * guaranteeing that no packets go to the tid_tx pending queue any
-	 * more.
-	 */
-
-	ieee80211_agg_splice_packets(sta->sdata, tid_tx, tid);
+	ieee80211_stop_queue_agg(sta->sdata, tid);
 
 	/* future packets must not find the tid_tx struct any more */
 	ieee80211_assign_tid_tx(sta, tid, NULL);
 
-	ieee80211_agg_splice_finish(sta->sdata, tid);
+	ieee80211_wake_queue_agg(sta->sdata, tid);
 
 	kfree_rcu(tid_tx, rcu_head);
 }
@@ -363,11 +319,6 @@ int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	timer_delete_sync(&tid_tx->addba_resp_timer);
 	timer_delete_sync(&tid_tx->session_timer);
 
-	/*
-	 * After this packets are no longer handed right through
-	 * to the driver but are put onto tid_tx->pending instead,
-	 * with locking to ensure proper access.
-	 */
 	clear_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state);
 
 	/*
@@ -538,9 +489,9 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		       "BA request denied - HW unavailable for %pM tid %d\n",
 		       sta->sta.addr, tid);
 		spin_lock_bh(&sta->lock);
-		ieee80211_agg_splice_packets(sdata, tid_tx, tid);
+		ieee80211_stop_queue_agg(sdata, tid);
 		ieee80211_assign_tid_tx(sta, tid, NULL);
-		ieee80211_agg_splice_finish(sdata, tid);
+		ieee80211_wake_queue_agg(sdata, tid);
 		spin_unlock_bh(&sta->lock);
 
 		ieee80211_agg_start_txq(sta, tid, false);
@@ -717,7 +668,6 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		goto err_unlock_sta;
 	}
 
-	skb_queue_head_init(&tid_tx->pending);
 	__set_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
 
 	tid_tx->timeout = timeout;
@@ -773,20 +723,11 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 
 	drv_ampdu_action(local, sta->sdata, &params);
 
-	/*
-	 * synchronize with TX path, while splicing the TX path
-	 * should block so it won't put more packets onto pending.
-	 */
 	spin_lock_bh(&sta->lock);
 
-	ieee80211_agg_splice_packets(sta->sdata, tid_tx, tid);
-	/*
-	 * Now mark as operational. This will be visible
-	 * in the TX path, and lets it go lock-free in
-	 * the common case.
-	 */
+	ieee80211_stop_queue_agg(sta->sdata, tid);
 	set_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state);
-	ieee80211_agg_splice_finish(sta->sdata, tid);
+	ieee80211_wake_queue_agg(sta->sdata, tid);
 
 	spin_unlock_bh(&sta->lock);
 
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 690c186e3bb9..203f608eba67 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -314,7 +314,7 @@ static ssize_t sta_agg_status_do_read(struct wiphy *wiphy, struct file *file,
 	p += scnprintf(p, bufsz + buf - p, "next dialog_token: %#02x\n",
 			sta->ampdu_mlme.dialog_token_allocator + 1);
 	p += scnprintf(p, bufsz + buf - p,
-		       "TID\t\tRX\tDTKN\tSSN\t\tTX\tDTKN\tpending\n");
+		       "TID\t\tRX\tDTKN\tSSN\t\tTX\tDTKN\n");
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 		bool tid_rx_valid;
@@ -335,8 +335,6 @@ static ssize_t sta_agg_status_do_read(struct wiphy *wiphy, struct file *file,
 		p += scnprintf(p, bufsz + buf - p, "\t\t%x", !!tid_tx);
 		p += scnprintf(p, bufsz + buf - p, "\t%#.2x",
 				tid_tx ? tid_tx->dialog_token : 0);
-		p += scnprintf(p, bufsz + buf - p, "\t%03d",
-				tid_tx ? skb_queue_len(&tid_tx->pending) : 0);
 		p += scnprintf(p, bufsz + buf - p, "\n");
 	}
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 80341173ae45..e9ca1f26a6bd 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -132,7 +132,6 @@ void ieee80211_purge_sta_txqs(struct sta_info *sta)
 static void __cleanup_single_sta(struct sta_info *sta)
 {
 	int ac, i;
-	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	struct ps_data *ps;
@@ -176,11 +175,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	 */
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 		kfree(sta->ampdu_mlme.tid_start_tx[i]);
-		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
-		if (!tid_tx)
-			continue;
-		ieee80211_purge_tx_queue(&local->hw, &tid_tx->pending);
-		kfree(tid_tx);
+		kfree(rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]));
 	}
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8b64c9b12de0..ebc70d2ad637 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -158,7 +158,6 @@ struct sta_info;
  * @rcu_head: rcu head for freeing structure
  * @session_timer: check if we keep Tx-ing on the TID (by timeout value)
  * @addba_resp_timer: timer for peer's response to addba request
- * @pending: pending frames queue -- use sta's spinlock to protect
  * @sta: station we are attached to
  * @dialog_token: dialog token for aggregation session
  * @timeout: session timeout value to be filled in ADDBA requests
@@ -183,7 +182,6 @@ struct tid_ampdu_tx {
 	struct rcu_head rcu_head;
 	struct timer_list session_timer;
 	struct timer_list addba_resp_timer;
-	struct sk_buff_head pending;
 	struct sta_info *sta;
 	unsigned long state;
 	unsigned long last_tx;
-- 
2.56.0

