Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651943;
	b=hFyGqveKf1y1ngzJO9w0ZtluFKbBoiNaqbZ2pDBNNNx/pCu20umm7cBZn25uuge538I5
	 6vZIS2TmNROIlL2n4+vPtB/Ir7Jlrdo2AvzT+iKlXcVIPPhht6groZXneNkrn6Gx67o2F
	 lpBJq2Eea6G+vHcjIb+rS19VuVAtgpTAPo0nEXNmTR3y/nAf+7LdNaQDpsM50f31WLbR+
	 7f/USIwsv+fz/kyNCd1+DdyUfii/B418ueN3+yujW0XZy4AyfrBHDEWSZZGnN05u/+iPv
	 cC731k5ItvZmelNfga2249A5KGBMtShfawuGy+0dJjaA4ktTzauFsHi+WDTHS9DjPhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651943;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QuRfVBsYZnG9j1LzwXfe0fQufEkRbmrg4BrBNGx3AVo=;
	b=oCldB4h6FKlBcfHUf3QcyvXeUYhv/XFkdIExfd2F9gGRW+hPxJlToWxfgh240PW7/h8t
	 fXBACKzdc43AZiNza6jlZWNV888f7Hor7ihHykPjjqs5wg4N3wWF60NY2r2+4/8JkhLKe
	 vOaomFiRAkyc19v18wp3xI2Wh+pSSyk4Ps3r9qilyEZETbvpGuWPkegYR2c61YaOYsQzR
	 XnJcUXNH9sXl0RY6EZ3LRjSmRNtjSKkuBLDY5rnJyOS9Ov9+Aio4M1dm6lifU9Q+z1mMf
	 e2+y+pdz1x1S/fXxaP9MjLj/doY2v+o6hsqfbb5cF9J+LLj2gpSST02PdQCER6Kun1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=jffZu5bC;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B4F6082BD2
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=jffZu5bC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=QuRfVBsYZnG9j1LzwXfe0fQufEkRbmrg4BrBNGx3AVo=;
	t=1793651942; x=1794861542; b=jffZu5bCrn8/qvQqPnaF5852ynxBgEN/EXBW3TfzISqTF1f
	Cg1BYsLanDXZ3rhuHXfj0ksRxBpT4ElktazwN22qjQtJvEyKQqHO07kzTxBcTgk8inkQrYChrk7Tf
	2HB4zLDE08NBl9NqUNCd1hb0x781iwLKOoxQBDpjxgpPQlbLjM8395LyPdvpFJl09BYbKpeaENhVG
	m0kDM6umgwY/0a2rFaY24f4FwtNP4R5iVwkoBHyRXgOBk2A5qK2fIRHBCmSMJ93kEiwXI8fsNSO5Y
	8CjiPNJFjIaA4hYLJ2+2M/EPpaGWRibNjV7KWvn17qmZiTyfKH7nvAgjjUNA1fsQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynz-00000001vzr-3U3P;
	Mon, 02 Nov 2026 21:39:00 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 22/30] wifi: mac80211: always use TXQ for mcast data frames
Date: Mon,  2 Nov 2026 21:23:12 +0100
Message-ID: <20261102203831.1058362-54-johannes@sipsolutions.net>
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

For devices without HOST_BROADCAST_PS_BUFFERING, we marked
mcast data frames for AFTER_DTIM on enqueue and bypassed
the TXQ for that frame. Change it to always put such frames
onto the TXQ and mark them with AFTER_DTIM on dequeue for
device buffering (though chances are this isn't needed),
and for host buffering pause the TXQ until DTIM if we see
a sleeping station.

The vif TXQ is then used for all the frames, and doesn't
need to be handled specially for wakeup.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c   | 95 +++++++++++++++++++++++++++++++--------------
 net/mac80211/util.c |  5 ---
 2 files changed, 65 insertions(+), 35 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0361cdfdbb70..8026aa1ff136 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -356,6 +356,43 @@ static struct sk_buff *ieee80211_txq_dequeue_oldest(struct fq *fq,
 	return fq_flow_dequeue(fq, oldest);
 }
 
+static struct ps_data *
+ieee80211_sdata_ps_data(struct ieee80211_sub_if_data *sdata)
+{
+	/* only AP and mesh have PS support now */
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		if (!sdata->bss)
+			return NULL;
+		return &sdata->bss->ps;
+	}
+
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		return &sdata->u.mesh.ps;
+
+	return NULL;
+}
+
+static bool ieee80211_txq_mcast_buffer(struct ieee80211_sub_if_data *sdata,
+				       struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ps_data *ps = ieee80211_sdata_ps_data(sdata);
+
+	if (!ps || !is_multicast_ether_addr(hdr->addr1) ||
+	    ieee80211_has_order(hdr->frame_control))
+		return false;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
+				     u.ap);
+
+	return atomic_read(&ps->num_sta_ps) ||
+	       (sdata->vif.txq &&
+		test_bit(IEEE80211_TXQ_MCAST_PS,
+			 &to_txq_info(sdata->vif.txq)->flags));
+}
+
 static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 				  struct txq_info *txqi,
 				  struct sk_buff *skb)
@@ -397,8 +434,10 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 		}
 	} else {
 		if (unlikely(!txqi->txq.sta &&
-			     IEEE80211_SKB_CB(skb)->flags &
-			     IEEE80211_TX_CTL_SEND_AFTER_DTIM)) {
+			     ieee80211_hw_check(&local->hw,
+						HOST_BROADCAST_PS_BUFFERING) &&
+			     ieee80211_txq_mcast_buffer(
+				     vif_to_sdata(txqi->txq.vif), skb))) {
 			set_bit(IEEE80211_TXQ_MCAST_PS, &txqi->flags);
 			if (tin->backlog_packets >= AP_MAX_BC_BUFFER)
 				drop_oldest = ieee80211_txq_dequeue_oldest(fq,
@@ -436,35 +475,16 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
-	struct ieee80211_sub_if_data *sdata = tx->sdata;
-	struct ps_data *ps;
 
 	/*
 	 * broadcast/multicast frame
 	 *
 	 * If any of the associated/peer stations is in power save mode,
 	 * the frame is buffered to be sent after DTIM beacon frame.
-	 * This is done either by the hardware or us (on the interface TXQ).
+	 * Data frames go on the vif TXQ, other frames are marked
+	 * with IEEE80211_TX_CTL_SEND_AFTER_DTIM here if needed.
 	 */
-
-	/* powersaving STAs currently only in AP/VLAN/mesh mode */
-	if (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
-	    tx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
-		if (!tx->sdata->bss)
-			return TX_CONTINUE;
-
-		ps = &tx->sdata->bss->ps;
-		sdata = container_of(tx->sdata->bss,
-				     struct ieee80211_sub_if_data, u.ap);
-	} else if (ieee80211_vif_is_mesh(&tx->sdata->vif)) {
-		ps = &tx->sdata->u.mesh.ps;
-	} else {
-		return TX_CONTINUE;
-	}
-
-
-	/* no buffering for ordered frames */
-	if (ieee80211_has_order(hdr->frame_control))
+	if (!ieee80211_sdata_ps_data(tx->sdata))
 		return TX_CONTINUE;
 
 	if (ieee80211_is_probe_req(hdr->frame_control))
@@ -473,14 +493,11 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	if (ieee80211_hw_check(&tx->local->hw, QUEUE_CONTROL))
 		info->hw_queue = tx->sdata->vif.cab_queue;
 
-	/* no stations in PS mode and no buffered packets */
-	if (!atomic_read(&ps->num_sta_ps) &&
-	    !(sdata->vif.txq &&
-	      test_bit(IEEE80211_TXQ_MCAST_PS,
-		       &to_txq_info(sdata->vif.txq)->flags)))
+	if (ieee80211_is_data_present(hdr->frame_control))
 		return TX_CONTINUE;
 
-	info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
+	if (ieee80211_txq_mcast_buffer(tx->sdata, tx->skb))
+		info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
 
 	return TX_CONTINUE;
 }
@@ -4061,6 +4078,21 @@ static bool ieee80211_txq_ps_tx_ok(const struct txq_info *txqi)
 	return READ_ONCE(sta->ps_release_tids) & BIT(txqi->txq.tid);
 }
 
+/*
+ * For devices buffering group addressed frames themselves, mark them
+ * for that if there are stations in powersave when they're dequeued.
+ */
+static void ieee80211_txq_mcast_ps(struct ieee80211_local *local,
+				   struct ieee80211_sub_if_data *sdata,
+				   struct sk_buff *skb)
+{
+	if (ieee80211_hw_check(&local->hw, HOST_BROADCAST_PS_BUFFERING))
+		return;
+
+	if (ieee80211_txq_mcast_buffer(sdata, skb))
+		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
+}
+
 static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 					      struct ieee80211_txq *txq,
 					      bool ps_release)
@@ -4208,6 +4240,9 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (!txq->sta)
+		ieee80211_txq_mcast_ps(local, tx.sdata, skb);
+
 	if (skb_has_frag_list(skb) &&
 	    !ieee80211_hw_check(&local->hw, TX_FRAG_LIST)) {
 		if (skb_linearize(skb)) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 181e4d787837..b46302dfdd7e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -327,7 +327,6 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_vif *vif = &sdata->vif;
 	struct fq *fq = &local->fq;
-	struct ps_data *ps = NULL;
 	struct txq_info *txqi = NULL;
 	struct sta_info *sta;
 	int i;
@@ -338,9 +337,6 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 	if (!test_bit(SDATA_STATE_RUNNING, &sdata->state))
 		goto out;
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP)
-		ps = &sdata->bss->ps;
-
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		if (sdata != sta->sdata)
 			continue;
@@ -374,7 +370,6 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 		WARN_ON_ONCE(vif->txq_nan_dw);
 
 		if (!test_and_clear_bit(IEEE80211_TXQ_DIRTY, &txqi->flags) ||
-		    (ps && atomic_read(&ps->num_sta_ps)) ||
 		    ac != vif->txq->ac)
 			txqi = NULL;
 	} else if (vif->txq_nan_dw) {
-- 
2.56.0

