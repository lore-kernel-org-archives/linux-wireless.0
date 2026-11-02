Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793663770;
	b=Ow9XK6g4hB5iBri8AlF3ahyPbx1T9ZdBN6zThcp3kqQK5+yFrfYNtvOKV51Zvs94BZ19
	 284udr05SL60UplIIr3OAmV9rAqjdHZEnQcH6VFsjLe4QORm2qtTpmKVmUm9axcrusD1J
	 A3O3eLAUVVvcq333UEbq8U0eikh2QgPQlUvnEN6XwKqFHvRczhPbk1ZGam/7pVbUaopdw
	 XpZoQ7BkFCn3ybO7dY6S3QIso1urUW5YTeRp3cZPN6ugrPyjIZvmcPZYE3sLz5L1no+rI
	 aRToHzwZ/8yIi2A5x+QoAm9CxBRQvR2mNcewB5TvQycDzfS88Qn3ZLM2naF4axws5fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793663770;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=sxdqCLunH6EL4pBotY0PdLv+0XuzHu0j2rSsVnGJ0DE=;
	b=v/I2qzyHumptYNGtZebt4vrmO51Pp4CpfmhKdqrviwWKLG9lYJBGXSkVteSm03F+yTTW
	 V8gsJJArpcJEAoapuoHerE9MPLecxuaQWrNSkwdqDbobXI3xORxIREng76sPhI9WOMRZU
	 St310vb/hD8j9eKD+5m1c7UNjdfyvvLFFyfk6siVbe8wuABr5sXOmrt2LxO0Ry/ICg8H7
	 wCB+YJOAm8f2BD2GAPlgMMO+An1JPrsoDSzuC4YtpTMzF+RAVWawCxHGCDRaemCZ04++S
	 235UqQNOHd2MvldFBbLjxQGQ9MBcUi9A7UrD9GzkUgm2VD3IvkhP5gEMfwAHW+t8hdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ee7RCe+1;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04394606A32C
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 23:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ee7RCe+1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=sxdqCLunH6EL4pBotY0PdLv+0XuzHu0j2rSsVnGJ0DE=;
	t=1793663769; x=1794873369; b=ee7RCe+1cV0+JP5J2vsz34TvAG6rb7fbTly+0rqa4V7wmYK
	ntxXzdMyHq7M0GrDPle7ggIo4lLaDRSs1bvTeI64Oz/qVGDiWCriuf/s8Mt92bQzA55bj4MLOteWE
	tgXEM7eOCpZIhRBlFFmH+FnRb2E1gY8WWco6C479PZp/3jCHnvM17mRXBx8Y9qE+4t4OqrMIfey3T
	qg9yP2und1EUKJDhfoTSU2Luouyi2xEVdrgc4Xsvr+oEylqLOZKASTD2qBbBB8+G/7TXJff/XiQn5
	sQx0TlreiIq6pD0knplIjwap0sfzNFPyMDQRYaWaQ49eL3CturG7abBHMbTUF8yQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO1sl-00000002AZf-0Mfl;
	Tue, 03 Nov 2026 00:56:07 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/7] wifi: mac80211: batch RCU sync when stopping TX BA sessions
Date: Tue,  3 Nov 2026 00:53:58 +0100
Message-ID: <20261102235603.1181883-10-johannes@sipsolutions.net>
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

Stopping a TX BA session requires synchronize_net() between
clearing the OPERATIONAL bit and telling the driver, so the
TX path can't be sending a frame concurrently.

When stopping all sessions for a station, we do that by TID
separately, once for each TID. During rekeying, hostapd may
wait for this to happen.

Optimise this a bit and just do it once for all TIDs.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c      | 104 +++++++++++++++++++++++++------------
 net/mac80211/ht.c          |   3 +-
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/key.c         |   6 +--
 4 files changed, 76 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index f3ecdd8601a0..b49f0b3c0b9c 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -285,18 +285,16 @@ static void ieee80211_remove_tid_tx(struct sta_info *sta, int tid)
 	kfree_rcu(tid_tx, rcu_head);
 }
 
-int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-				   enum ieee80211_agg_stop_reason reason)
+/* returns 1 if the driver must be notified after synchronize_net() */
+static int ieee80211_stop_tx_ba_session_prep(struct sta_info *sta, u16 tid,
+					     enum ieee80211_agg_stop_reason reason)
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_ampdu_params params = {
 		.sta = &sta->sta,
 		.tid = tid,
-		.buf_size = 0,
-		.amsdu = false,
-		.timeout = 0,
-		.ssn = 0,
+		.action = IEEE80211_AMPDU_TX_STOP_FLUSH_CONT,
 	};
 	int ret;
 
@@ -306,10 +304,7 @@ int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	case AGG_STOP_DECLINED:
 	case AGG_STOP_LOCAL_REQUEST:
 	case AGG_STOP_PEER_REQUEST:
-		params.action = IEEE80211_AMPDU_TX_STOP_CONT;
-		break;
 	case AGG_STOP_DESTROY_STA:
-		params.action = IEEE80211_AMPDU_TX_STOP_FLUSH;
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -337,7 +332,6 @@ int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 		spin_unlock_bh(&sta->lock);
 		if (reason != AGG_STOP_DESTROY_STA)
 			return -EALREADY;
-		params.action = IEEE80211_AMPDU_TX_STOP_FLUSH_CONT;
 		ret = drv_ampdu_action(local, sta->sdata, &params);
 		WARN_ON_ONCE(ret);
 		return 0;
@@ -370,35 +364,32 @@ int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	 */
 	clear_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state);
 
-	/*
-	 * There might be a few packets being processed right now (on
-	 * another CPU) that have already gotten past the aggregation
-	 * check when it was still OPERATIONAL and consequently have
-	 * IEEE80211_TX_CTL_AMPDU set. In that case, this code might
-	 * call into the driver at the same time or even before the
-	 * TX paths calls into it, which could confuse the driver.
-	 *
-	 * Wait for all currently running TX paths to finish before
-	 * telling the driver. New packets will not go through since
-	 * the aggregation session is no longer OPERATIONAL.
-	 */
-	if (!local->in_reconfig)
-		synchronize_net();
-
 	tid_tx->stop_initiator = reason == AGG_STOP_PEER_REQUEST ?
 					WLAN_BACK_RECIPIENT :
 					WLAN_BACK_INITIATOR;
 	tid_tx->tx_stop = reason == AGG_STOP_LOCAL_REQUEST;
 
-	ret = drv_ampdu_action(local, sta->sdata, &params);
+	return 1;
+}
 
-	/* HW shall not deny going back to legacy */
-	if (WARN_ON(ret)) {
-		/*
-		 * We may have pending packets get stuck in this case...
-		 * Not bothering with a workaround for now.
-		 */
-	}
+static void ieee80211_stop_tx_ba_session_finish(struct sta_info *sta, u16 tid,
+						enum ieee80211_agg_stop_reason reason)
+{
+	struct ieee80211_ampdu_params params = {
+		.sta = &sta->sta,
+		.tid = tid,
+		.action = reason == AGG_STOP_DESTROY_STA ?
+				IEEE80211_AMPDU_TX_STOP_FLUSH :
+				IEEE80211_AMPDU_TX_STOP_CONT,
+	};
+
+	lockdep_assert_wiphy(sta->local->hw.wiphy);
+
+	/*
+	 * HW shall not deny going back to legacy. If it does, we may have
+	 * pending packets get stuck, not bothering with a workaround for now.
+	 */
+	WARN_ON(drv_ampdu_action(sta->local, sta->sdata, &params));
 
 	/*
 	 * In the case of AGG_STOP_DESTROY_STA, the driver won't
@@ -409,10 +400,57 @@ int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	 * leaving it around ensures that we don't transmit packets
 	 * to the driver on this TID which might confuse it.
 	 */
+}
+
+/*
+ * There might be a few packets being processed right now (on another CPU)
+ * that have already gotten past the aggregation check when it was still
+ * OPERATIONAL and consequently have IEEE80211_TX_CTL_AMPDU set. In that
+ * case, telling the driver might happen at the same time or even before
+ * the TX paths calls into it, which could confuse the driver.
+ *
+ * Therefore, stopping is split into the _prep() part that clears the
+ * OPERATIONAL bit, and the _finish() part that tells the driver, and
+ * all currently running TX paths must have finished in between. New
+ * packets will not go through since the session is no longer OPERATIONAL.
+ */
+int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
+				   enum ieee80211_agg_stop_reason reason)
+{
+	int ret = ieee80211_stop_tx_ba_session_prep(sta, tid, reason);
+
+	if (ret <= 0)
+		return ret;
+
+	if (!sta->local->in_reconfig)
+		synchronize_net();
+
+	ieee80211_stop_tx_ba_session_finish(sta, tid, reason);
 
 	return 0;
 }
 
+void ieee80211_sta_stop_tx_ba_sessions(struct sta_info *sta,
+				       enum ieee80211_agg_stop_reason reason)
+{
+	unsigned long tids = 0;
+	int tid;
+
+	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
+		if (ieee80211_stop_tx_ba_session_prep(sta, tid, reason) > 0)
+			__set_bit(tid, &tids);
+	}
+
+	if (!tids)
+		return;
+
+	if (!sta->local->in_reconfig)
+		synchronize_net();
+
+	for_each_set_bit(tid, &tids, IEEE80211_NUM_TIDS)
+		ieee80211_stop_tx_ba_session_finish(sta, tid, reason);
+}
+
 /*
  * After sending add Block Ack request we activated a timer until
  * add Block Ack response will arrive from the recipient.
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index c5c2113fa4f7..21c1d6e03c1f 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -296,8 +296,7 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 					       reason != AGG_STOP_DESTROY_STA &&
 					       reason != AGG_STOP_PEER_REQUEST);
 
-	for (i = 0; i <  IEEE80211_NUM_TIDS; i++)
-		__ieee80211_stop_tx_ba_session(sta, i, reason);
+	ieee80211_sta_stop_tx_ba_sessions(sta, reason);
 
 	/*
 	 * In case the tear down is part of a reconfigure due to HW restart
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9906a62ee99c..2da93a4b9e8e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2380,6 +2380,8 @@ ieee80211_mgmt_ba(struct sk_buff *skb, const u8 *da,
 
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				   enum ieee80211_agg_stop_reason reason);
+void ieee80211_sta_stop_tx_ba_sessions(struct sta_info *sta,
+				       enum ieee80211_agg_stop_reason reason);
 void ieee80211_start_tx_ba_cb(struct sta_info *sta, int tid,
 			      struct tid_ampdu_tx *tid_tx);
 void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d1e3fe37d2e3..71380c1b3c8c 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -320,7 +320,6 @@ static void ieee80211_pairwise_rekey(struct ieee80211_key *old,
 {
 	struct ieee80211_local *local = new->local;
 	struct sta_info *sta = new->sta;
-	int i;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
@@ -339,9 +338,8 @@ static void ieee80211_pairwise_rekey(struct ieee80211_key *old,
 			 * job done for the few ms we need it.)
 			 */
 			set_sta_flag(sta, WLAN_STA_BLOCK_BA);
-			for (i = 0; i <  IEEE80211_NUM_TIDS; i++)
-				__ieee80211_stop_tx_ba_session(sta, i,
-							       AGG_STOP_LOCAL_REQUEST);
+			ieee80211_sta_stop_tx_ba_sessions(sta,
+							  AGG_STOP_LOCAL_REQUEST);
 		}
 	} else if (old) {
 		/* Rekey without Extended Key ID.
-- 
2.56.0

