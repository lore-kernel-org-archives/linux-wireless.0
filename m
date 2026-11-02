Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651945;
	b=JrvRdeqLCZp3sTDaGMD6ntFNHyeSdXiGYgLDfx+MnFo/DkchM8oJnVhCiRzu4RBZxvXa
	 iKLCcXgOnqrkdWKeykDMLn+Nf2F8oIn/bU8x9I1Z80DCrMEP9mlka3TmRBMV1SlXskFOk
	 rEiWDVpnSheUOwoYsITos5HeAjfba3rriE2iIFCpK0fThUqGOzYy7C/ZSNDfXFk8splhf
	 f7GzANmu6PQEqNPst+stxk1CF5FGXjADoZu35wh/oOTxb0Wadlq8ZWeFdzQtNKX03DzzX
	 D1PzvPXXth/UG39zBnFPqQPmHvsWn4IFHwzH/1eWjnT86Bd/5bi6hWezySkuDwTzuSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651945;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=GiDZAtmR10DrBVIbyh0VPVw0ezBgBG5rT7Gi6P2smSs=;
	b=3jRP/Pcqfjrv53MDYSW3jGo92bYVHZt5U6mVZAndnBBLE5sAmJcSoPeKyfIJ+3mQCJFf
	 y6dizvXAFgk7Dl7mq03UMJGfiMa8VWsIpiz3awjVsT5k7xHXh/AxyZ5c/l38FPT2cmjpw
	 NXE/dDvKylOj+mAfhVp9bWNpXwf/AchYaD6BQib3c6XlstmcnUThoeSkFqxT9ayBv6NMh
	 xoyE7sqGrM8ook0auhE0k1VpngIZ4K9QMUBztRe/N55cwUMU2tlWGelmmKjFyK/drplaj
	 m/RAABrODBAYWdqo+1HByo6WDTF0IlhbLyWDxhv5vcW4ltCD2k9cOv0PtAhYIwWpx0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Ym3Z8xEL;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF4E6082BE7
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Ym3Z8xEL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=GiDZAtmR10DrBVIbyh0VPVw0ezBgBG5rT7Gi6P2smSs=;
	t=1793651944; x=1794861544; b=Ym3Z8xELTH5wduOiudOVCEeaP8yh96ohMvfOdNi3QNS6AbI
	9tHlKN1x1y9vaj42/OJ2jbWh3oTX6yNwjEt9qVDIMqsONu0ZPtD31/hjFOFI3IhJ0Y2JWGZkJ+Vtm
	rVCZMHI0WXmBKpUZ/f61IYxksK9zvKmittDnsA58vpsuJEthqyjbzj67CrTjFmnljOL09OlS88DXJ
	joHQGK1qSOnPAACiRX4x7clow+6SPPv442k9KlsyD1habN+BuZw+7EwYWvSK4Q4SrFAxA+Y79ciIj
	lRv2XV9KXYnX57mHFtNN3YYFa9Ioh/WKcMfShbeX7MDZuu0gE/vVgEAVCuiQVUhw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyo2-00000001vzr-0pTV;
	Mon, 02 Nov 2026 21:39:02 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 24/30] wifi: mac80211: encapsulate fast-xmit frames at TXQ dequeue
Date: Mon,  2 Nov 2026 21:23:14 +0100
Message-ID: <20261102203831.1058362-56-johannes@sipsolutions.net>
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

Instead of building the 802.11 header using fast-xmit when a
frame is transmitted, keep it on the TXQ in ethernet format,
and build the header on dequeue. For now only for fast-xmit,
but the target is to handle (almost) all frames that way so
we get better reactivity to changes while the frames are on
the queue, and can (eventually) also transfer the queues of
one AP MLD to another during SMD Transition.

For now, this breaks software A-MSDUs (we can't build those
in ethernet format), the next patch creates them at dequeue
instead of enqueue, also improving reactivity.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  7 ++++
 net/mac80211/tx.c          | 82 +++++++++++++++++++++++++++++++++++---
 2 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b498765afa20..f450368c1c6e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -184,6 +184,13 @@ typedef unsigned __bitwise ieee80211_tx_result;
 
 #define IEEE80211_TX_UNICAST		BIT(1)
 
+/*
+ * Internally, use "need encap" since it's the better name, but the
+ * hardware might do it instead of sofwtare, so alias it to the HW
+ * flag - that way don't need to translate.
+ */
+#define IEEE80211_TX_INTFL_NEED_80211_ENCAP	IEEE80211_TX_CTL_HW_80211_ENCAP
+
 struct ieee80211_tx_data {
 	struct sk_buff *skb;
 	struct sk_buff_head skbs;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 683e2e219a8f..7d1d1754d931 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3992,6 +3992,31 @@ void __ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	kfree_skb(skb);
 }
 
+static bool ieee80211_xmit_fast_queue(struct ieee80211_sub_if_data *sdata,
+				      struct sta_info *sta,
+				      const struct ieee80211_fast_tx *fast_tx,
+				      struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	memset(info, 0, sizeof(*info));
+	info->band = fast_tx->band;
+	info->control.vif = &sdata->vif;
+	info->flags = IEEE80211_TX_CTL_FIRST_FRAGMENT |
+		      IEEE80211_TX_CTL_DONTFRAG |
+		      IEEE80211_TX_INTFL_NEED_80211_ENCAP;
+	info->control.flags = IEEE80211_TX_CTRL_FAST_XMIT |
+			      u32_encode_bits(IEEE80211_LINK_UNSPECIFIED,
+					      IEEE80211_TX_CTRL_MLO_LINK);
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	if (sdata->local->force_tx_status)
+		info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+#endif
+
+	return ieee80211_queue_skb(sdata->local, sdata, sta, skb);
+}
+
 static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 				struct sta_info *sta,
 				struct ieee80211_fast_tx *fast_tx,
@@ -4001,8 +4026,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_hdr *hdr = (void *)fast_tx->hdr;
 	struct tid_ampdu_tx *tid_tx = NULL;
 	struct sk_buff *next;
-	struct ethhdr eth;
-	u8 tid = IEEE80211_NUM_TIDS;
+	u8 tid;
 
 	/* control port protocol needs a lot of special handling */
 	if (cpu_to_be16(ethertype) == sdata->control_port_protocol)
@@ -4027,8 +4051,6 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	memcpy(&eth, skb->data, ETH_HLEN - 2);
-
 	/* after this point (skb is modified) we cannot return false */
 	skb = ieee80211_tx_skb_fixup(skb, ieee80211_sdata_netdev_features(sdata));
 	if (!skb)
@@ -4036,8 +4058,14 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 
 	skb_list_walk_safe(skb, skb, next) {
 		skb_mark_not_on_list(skb);
-		__ieee80211_xmit_fast(sdata, sta, fast_tx, skb, tid_tx,
-				      eth.h_dest, eth.h_source);
+
+		skb = skb_share_check(skb, GFP_ATOMIC);
+		if (unlikely(!skb))
+			continue;
+
+		/* can only fail if the station is no longer uploaded */
+		if (!ieee80211_xmit_fast_queue(sdata, sta, fast_tx, skb))
+			ieee80211_free_txskb(&sdata->local->hw, skb);
 	}
 
 	return true;
@@ -4106,6 +4134,39 @@ static void ieee80211_txq_mcast_ps(struct ieee80211_local *local,
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
 }
 
+static int ieee80211_txq_build_hdr(struct ieee80211_tx_data *tx)
+{
+	const struct ieee80211_fast_tx *fast_tx;
+	struct sk_buff *skb = tx->skb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ethhdr eth;
+
+	info->flags &= ~IEEE80211_TX_INTFL_NEED_80211_ENCAP;
+
+	fast_tx = rcu_dereference(tx->sta->fast_tx);
+	if (fast_tx && fast_tx->key == tx->key) {
+		memcpy(&eth, skb->data, ETH_HLEN - 2);
+		if (ieee80211_fast_tx_encap(tx->sdata, fast_tx, skb,
+					    eth.h_dest, eth.h_source)) {
+			ieee80211_free_txskb(&tx->local->hw, skb);
+			return -ENOMEM;
+		}
+		return 0;
+	}
+
+	info->control.flags &= ~IEEE80211_TX_CTRL_FAST_XMIT;
+
+	/* use sta->sdata for VLAN, info->control.vif is the AP */
+	skb = ieee80211_build_hdr(tx->sta->sdata, skb, tx->sta);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	ieee80211_set_qos_hdr(tx->sta->sdata, skb);
+	dev_sw_netstats_tx_add(skb->dev, 1, skb->len);
+	tx->skb = skb;
+	return 0;
+}
+
 static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 					      struct ieee80211_txq *txq,
 					      bool ps_release)
@@ -4213,6 +4274,15 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		info->flags |= (IEEE80211_TX_CTL_AMPDU |
 				IEEE80211_TX_CTL_DONTFRAG);
 
+	/* the fast-xmit check here distinguishes from HW offload */
+	if (info->flags & IEEE80211_TX_INTFL_NEED_80211_ENCAP &&
+	    info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {
+		if (ieee80211_txq_build_hdr(&tx))
+			goto begin;
+		skb = tx.skb;
+		hdr = (struct ieee80211_hdr *)skb->data;
+	}
+
 	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
 		if (!ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
 			r = ieee80211_tx_h_rate_ctrl(&tx);
-- 
2.56.0

