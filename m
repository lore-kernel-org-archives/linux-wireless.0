Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651930;
	b=ZAe0SYDLePDW7byKyUT+xdQYKcjhHflk3UuD9PDWaWKDvcLzObB+9gexWwTq/l5PSvm/
	 hm3/EaQtx6uufpdVh244PcmN9tzzZ0vz2nV403itryfjjRmpXqRLIgb3s3tbxrwRhGMNG
	 Hs4yQo99EMQUtfSTObWgqATPKJOfBfimAydYr9vK8KBDZw5BKeRIp2eN4OBdP55zRjdTC
	 oBxT/Pm9ZlkEw5D4eFlMpoIdDgWvKnxIqCefdTZEXhFoG7Ey6nSiHWp5yeDF4JU6p5Wzd
	 Vx27/9po60A/50WtwMCVCO8pgz7AH6z7vOeEImD3xQqZKBbB6ypZ+RYX5mOgs/LLA3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651930;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=suYWHO+8enuX2QB2OwAivz5FdNkaQKN9TlYyrPh6Dqk=;
	b=FBKRqJZA4B6bMv7s3d0NStNzBOVyeDC9OzMY2+ktIpu9nhLkR1NREDnahuro78EtM+g4
	 tMWx+9uBMrdNotjHXnNYd/RellzR1Ikv/wFIQguB8GW4OGDF76Fj1uw0l+DUXOS3eTJC4
	 lLvM7wfpsuCXVMRlHAeLfyimdfedvbVtoBrxx78m8/d4yIuoP0icoaHj9XVOyBVZMbvxQ
	 tdKau+19/hSrNTe+AXYlVQmgtJ2tX4MGnmo+jyTj5h9kW5cCTyq9ImZpo8604YOpQCeot
	 RVsnR6aKJ5qvxqgDdrXU3b7YrwUja/HshQEK3aVRpW4V686UkNi44gRgbIS0bDMcKJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=grzwWlr+;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B738606A332
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=grzwWlr+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=suYWHO+8enuX2QB2OwAivz5FdNkaQKN9TlYyrPh6Dqk=;
	t=1793651930; x=1794861530; b=grzwWlr+eBq7WJI5TBzwuiwWc0v8seBP82oSM3f2SeBi1Uw
	YAAONmIc4aITvx5cyKf9uey9TgoLdAv1catQzPRT1DyKruZPRtKTSwh9Ew1CSNCTObdquOGCRtACF
	sHqUOiQx848Z9/cPdxtBDtQlMdX1WZeAW8Lg6C9ZpopRE0d56CsZyB0ZHDjnEFPnShyUBX1cQAhfu
	LL4U/3+JTiTfzFSAWiv9ApmRriD9efWnUTz1hfj95izMG+w5npmS0u01PZB+JnNL80w6j8xcWE4rb
	Uwt2TQuLebWX7zsEFaB/0Wk/oB0W0fKLa6FzSr40hOx9gyspoDslbkA4NAVxjWDg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynn-00000001vzr-2G0L;
	Mon, 02 Nov 2026 21:38:48 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 13/30] wifi: mac80211: don't apply CoDel to PS-buffered frames
Date: Mon,  2 Nov 2026 21:23:03 +0100
Message-ID: <20261102203831.1058362-45-johannes@sipsolutions.net>
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

Frames for sleeping stations remain on the TXQs now, applying
CoDel to them would start dropping them due to a long wait on
dequeue, but for PS STAs they will be on the queues for a while.
Bypass CoDel while a STA is sleeping and for a while (10s) or
when the queue drains after it wakes up, and for frames that
were enqueued after the wakeup as well, which really is the
common case.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  7 +++++
 net/mac80211/sta_info.c    |  6 ++++-
 net/mac80211/tx.c          | 52 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5045144641a4..cb947341fee6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -978,6 +978,7 @@ enum txq_info_flags {
 	IEEE80211_TXQ_AMPDU,
 	IEEE80211_TXQ_NO_AMSDU,
 	IEEE80211_TXQ_DIRTY,
+	IEEE80211_TXQ_PS_BACKLOG,
 };
 
 /**
@@ -990,6 +991,9 @@ enum txq_info_flags {
  * @schedule_order: used with ieee80211_local->active_txqs
  * @schedule_round: counter to prevent infinite loops on TXQ scheduling
  * @flags: TXQ flags from &enum txq_info_flags
+ * @ps_backlog_end: with %IEEE80211_TXQ_PS_BACKLOG, indicates when
+ *	the station woke up, i.e. frames before this were just queued
+ *	due to powersave
  * @txq: the driver visible part
  */
 struct txq_info {
@@ -1003,6 +1007,7 @@ struct txq_info {
 	struct sk_buff_head frags;
 
 	unsigned long flags;
+	codel_time_t ps_backlog_end;
 
 	/* keep last! */
 	struct ieee80211_txq txq;
@@ -2724,6 +2729,8 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 			struct txq_info *txq, int tid);
 struct sk_buff *ieee80211_tx_dequeue_ps_release(struct ieee80211_local *local,
 						struct txq_info *txqi);
+void ieee80211_txq_ps_backlog_start(struct ieee80211_local *local,
+				    struct txq_info *txqi);
 void ieee80211_txq_purge(struct ieee80211_local *local,
 			 struct txq_info *txqi);
 void ieee80211_purge_sta_txqs(struct sta_info *sta);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 51504f57128f..8d79e532b109 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1889,10 +1889,14 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	/* this can be called in process context, e.g. for mesh */
 	local_bh_disable();
 	for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
+		struct txq_info *txqi;
+
 		if (!sta->sta.txq[i] || !txq_has_queue(sta->sta.txq[i]))
 			continue;
 
-		schedule_and_wake_txq(local, to_txq_info(sta->sta.txq[i]));
+		txqi = to_txq_info(sta->sta.txq[i]);
+		ieee80211_txq_ps_backlog_start(local, txqi);
+		schedule_and_wake_txq(local, txqi);
 	}
 	local_bh_enable();
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0bd324a4d4cb..856018cdb617 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1380,6 +1380,55 @@ static void codel_drop_func(struct sk_buff *skb,
 	ieee80211_free_txskb(hw, skb);
 }
 
+/* bypass codel since PS can last a long time */
+static bool ieee80211_txq_codel_bypass(struct txq_info *txqi,
+				       const struct fq_flow *flow)
+{
+	struct sta_info *sta;
+	struct sk_buff *skb;
+
+	if (!txqi->txq.sta)
+		return false;
+
+	sta = container_of(txqi->txq.sta, struct sta_info, sta);
+	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
+	    test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
+	    test_sta_flag(sta, WLAN_STA_PS_DELIVER))
+		return true;
+
+	if (likely(!test_bit(IEEE80211_TXQ_PS_BACKLOG, &txqi->flags)))
+		return false;
+
+	/*
+	 * Stop treating as backlog after it cleared or after 1s
+	 * (the latter to avoid time wrap and issues from that).
+	 */
+#define IEEE80211_TXQ_MAX_PS_BACKLOG	MS2TIME(MSEC_PER_SEC)
+
+	if (!txqi->tin.backlog_packets ||
+	    codel_time_after(codel_get_time(),
+			     (codel_time_t)(txqi->ps_backlog_end +
+					    IEEE80211_TXQ_MAX_PS_BACKLOG))) {
+		clear_bit(IEEE80211_TXQ_PS_BACKLOG, &txqi->flags);
+		return false;
+	}
+
+	skb = skb_peek(&flow->queue);
+	return skb && codel_time_before(codel_skb_time_func(skb),
+					txqi->ps_backlog_end);
+}
+
+void ieee80211_txq_ps_backlog_start(struct ieee80211_local *local,
+				    struct txq_info *txqi)
+{
+	spin_lock_bh(&local->fq.lock);
+	if (txqi->tin.backlog_packets) {
+		txqi->ps_backlog_end = codel_get_time();
+		set_bit(IEEE80211_TXQ_PS_BACKLOG, &txqi->flags);
+	}
+	spin_unlock_bh(&local->fq.lock);
+}
+
 static struct sk_buff *fq_tin_dequeue_func(struct fq *fq,
 					   struct fq_tin *tin,
 					   struct fq_flow *flow)
@@ -1395,6 +1444,9 @@ static struct sk_buff *fq_tin_dequeue_func(struct fq *fq,
 	cparams = &local->cparams;
 	cstats = &txqi->cstats;
 
+	if (unlikely(ieee80211_txq_codel_bypass(txqi, flow)))
+		return fq_flow_dequeue(fq, flow);
+
 	if (flow == &tin->default_flow)
 		cvars = &txqi->def_cvars;
 	else
-- 
2.56.0

