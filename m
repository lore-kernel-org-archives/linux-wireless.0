Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651937;
	b=00PaGgEHXj/4TpTa7kNOjNSB6KpT+5UZCL/kOs9LiW/wUFO0rDn5PGp+3vUICgCGBiok
	 vW2nUfrx3JU61HNkV3DI3aLJ0643xJyui7IOIJnb4h3Tz2oAeT0tDBMfpZOcnt7f+bQEe
	 j3zC6kRHisol/2Efr/Rn1wtkWx33S14inyYDueF2bmNTvACghrroN0jtB/18RHxLTG7xu
	 B+3RSnI6aS7s35mU4CinDTVerTgJ9u9afT4ehAFw9+Z0c6xynMg838UofhTQmLAVUaXix
	 ucDRgH5NipNzErjw/K5jMaDrD4F3Y7Owj69SdlLJKqAnjYwuRPilFqKDVYujlg7Hd2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651937;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bLRE5HiN1ggMyWHzr5g65cBcKs1mRX1Fkp1vppWex6E=;
	b=S0jz/o7kIGYi9VwI+ortUpZiVJtlrRPy9THw77Jv2c4rGq5qu6L+9Gm4xVXjroIz+gxw
	 GTjeU/l/zBv05qWzzBSnFL7cwjO3r/0LcH5V0fBTbv3L0uOf1IuhZ1gYxrXjFeVChevYn
	 JrYeRrlX8XO1W7eX8smdNkzBUo9SiFM624OByawburorOGVlZoAvQbB2rygdpHe9AvVNv
	 ez9YCuSnnl71RKoUHFxP1J+NheP404rtfuf1CPLwARZpPrAUpqoEV1BrnFiN652SqzMIe
	 6cEDGCJCFLY1YXSmEOIgZ6hTQp37Hh3pgNVu9ropi140cipvgNrdmV70f8/ck8lj9gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=L90Ge2JP;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76108606D823
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=L90Ge2JP
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=bLRE5HiN1ggMyWHzr5g65cBcKs1mRX1Fkp1vppWex6E=;
	t=1793651937; x=1794861537; b=L90Ge2JPqGXmOeL5zeZnzKLOvw/xrC+XS9g+RFzUcV20sH9
	AxrWuoDAFHra+YkeYq5rxjJyXea2+RG+5JVfgJc2aOTfBec3WYkZdCQtWx58LaRJp7L3CTLBB4JQu
	0PhIGmoDg6BcjlO3DmmudiYtJJPGTvvbWwpyw4srI3nOyMKlgr7+/SntY78s1QqThL+CDfEhUqrDe
	ftRC0cVU0xzpVIeooO019Qi47+trCVKcCNPID5JF4rr874pb1Q9Aw25tQahkCBbAWJCmQFsqWCaQr
	jstVNTF34j8LA3YHA34uM83uqwXSB8K4ZIQMkDlDlIkxOZ4EIf1ZjccQSC1pF8gw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynv-00000001vzr-1PLX;
	Mon, 02 Nov 2026 21:38:55 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 17/30] wifi: mac80211: move ieee80211_txq_enqueue() up
Date: Mon,  2 Nov 2026 21:23:07 +0100
Message-ID: <20261102203831.1058362-49-johannes@sipsolutions.net>
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

ieee80211_txq_enqueue() will be needed by the powersave buffering
code, so move it and the helpers it uses before that, to avoid a
forward declaration. No functional changes.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 126 +++++++++++++++++++++++-----------------------
 1 file changed, 63 insertions(+), 63 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c29dec9d049d..aca68ab112e0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -308,6 +308,69 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	return TX_CONTINUE;
 }
 
+static void ieee80211_set_skb_enqueue_time(struct sk_buff *skb)
+{
+	struct sk_buff *next;
+	codel_time_t now = codel_get_time();
+
+	skb_list_walk_safe(skb, skb, next)
+		IEEE80211_SKB_CB(skb)->control.enqueue_time = now;
+}
+
+static void fq_skb_free_func(struct fq *fq,
+			     struct fq_tin *tin,
+			     struct fq_flow *flow,
+			     struct sk_buff *skb)
+{
+	struct ieee80211_local *local;
+
+	local = container_of(fq, struct ieee80211_local, fq);
+	ieee80211_free_txskb(&local->hw, skb);
+}
+
+static void ieee80211_txq_enqueue(struct ieee80211_local *local,
+				  struct txq_info *txqi,
+				  struct sk_buff *skb)
+{
+	struct fq *fq = &local->fq;
+	struct fq_tin *tin = &txqi->tin;
+	struct sta_info *sta = NULL;
+	u32 flow_idx;
+
+	ieee80211_set_skb_enqueue_time(skb);
+
+	spin_lock_bh(&fq->lock);
+	/* TXQ becomes non-empty, update TIM if STA is sleeping */
+	if (txqi->txq.sta && !txq_has_queue(&txqi->txq)) {
+		sta = container_of(txqi->txq.sta, struct sta_info, sta);
+		if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
+		    !test_sta_flag(sta, WLAN_STA_PS_DRIVER))
+			sta = NULL;
+	}
+
+	/*
+	 * For management frames, don't really apply codel etc.,
+	 * we don't want to apply any shaping or anything we just
+	 * want to simplify the driver API by having them on the
+	 * txqi.
+	 */
+	if (unlikely(txqi->txq.tid == IEEE80211_NUM_TIDS)) {
+		IEEE80211_SKB_CB(skb)->control.flags |=
+			IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
+		__skb_queue_tail(&txqi->frags, skb);
+	} else {
+		flow_idx = fq_flow_idx(fq, skb);
+		fq_tin_enqueue(fq, tin, flow_idx, skb,
+			       fq_skb_free_func);
+	}
+	spin_unlock_bh(&fq->lock);
+
+	if (sta) {
+		sta_info_recalc_tim(sta);
+		sta_info_schedule_cleanup(local);
+	}
+}
+
 /* This function is called whenever the AP is about to exceed the maximum limit
  * of buffered frames for power saving STAs. This situation should not really
  * happen often during normal operation, so dropping the oldest buffered packet
@@ -1332,15 +1395,6 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	return to_txq_info(txq);
 }
 
-static void ieee80211_set_skb_enqueue_time(struct sk_buff *skb)
-{
-	struct sk_buff *next;
-	codel_time_t now = codel_get_time();
-
-	skb_list_walk_safe(skb, skb, next)
-		IEEE80211_SKB_CB(skb)->control.enqueue_time = now;
-}
-
 static u32 codel_skb_len_func(const struct sk_buff *skb)
 {
 	return skb->len;
@@ -1471,60 +1525,6 @@ static struct sk_buff *fq_tin_dequeue_func(struct fq *fq,
 			     codel_dequeue_func);
 }
 
-static void fq_skb_free_func(struct fq *fq,
-			     struct fq_tin *tin,
-			     struct fq_flow *flow,
-			     struct sk_buff *skb)
-{
-	struct ieee80211_local *local;
-
-	local = container_of(fq, struct ieee80211_local, fq);
-	ieee80211_free_txskb(&local->hw, skb);
-}
-
-static void ieee80211_txq_enqueue(struct ieee80211_local *local,
-				  struct txq_info *txqi,
-				  struct sk_buff *skb)
-{
-	struct fq *fq = &local->fq;
-	struct fq_tin *tin = &txqi->tin;
-	struct sta_info *sta = NULL;
-	u32 flow_idx;
-
-	ieee80211_set_skb_enqueue_time(skb);
-
-	spin_lock_bh(&fq->lock);
-	/* TXQ becomes non-empty, update TIM if STA is sleeping */
-	if (txqi->txq.sta && !txq_has_queue(&txqi->txq)) {
-		sta = container_of(txqi->txq.sta, struct sta_info, sta);
-		if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
-		    !test_sta_flag(sta, WLAN_STA_PS_DRIVER))
-			sta = NULL;
-	}
-
-	/*
-	 * For management frames, don't really apply codel etc.,
-	 * we don't want to apply any shaping or anything we just
-	 * want to simplify the driver API by having them on the
-	 * txqi.
-	 */
-	if (unlikely(txqi->txq.tid == IEEE80211_NUM_TIDS)) {
-		IEEE80211_SKB_CB(skb)->control.flags |=
-			IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
-		__skb_queue_tail(&txqi->frags, skb);
-	} else {
-		flow_idx = fq_flow_idx(fq, skb);
-		fq_tin_enqueue(fq, tin, flow_idx, skb,
-			       fq_skb_free_func);
-	}
-	spin_unlock_bh(&fq->lock);
-
-	if (sta) {
-		sta_info_recalc_tim(sta);
-		sta_info_schedule_cleanup(local);
-	}
-}
-
 bool ieee80211_txq_queue_filtered(struct ieee80211_local *local,
 				  struct txq_info *txqi, struct sk_buff *skb)
 {
-- 
2.56.0

