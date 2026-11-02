Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651948;
	b=C/2dl4rMTEI7QTSXc9P9HY/TV80+GslZ47dlgo0wr4qucPybZbw1hJvBmZyJGl9eceIZ
	 +uHpj7bVxcoEdBEeQBc5dcXsxhv8Qz4od+BB9SRrG/pnzC14mo9dEeLDF4ckNZAlzPS//
	 NU33Kdtozb7HOpsAEjH5pl+BF1QWde7HsXhSLJBGnn/CTlOO96N7U/+1RzxrgwpSjMGlX
	 isWWW1FLzkMxymbTY4JGan1C4GGr42C1zqy0Kmb6wbWXqzZj0bWtqYfHFcdFpKavpPQ5o
	 4YPQNdERDFmX3etiq1h6bvfF92qc7I2ggc85fg9UimumBnBI9zVW2sPfpzybrf9y4FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651948;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0KwLCbgabrj7tABSup4JIfw4cz4ImfGPHTDWMn3q4Cw=;
	b=3pmrAcUDgnXTUpcxNNA7s0TyR/vRg5L5bNBx6/cXEBUeB91GVT0JsOacJ2yw7V5TdRy4
	 7WFPsnwL7yJRjuP+gGfVipek4sAWG4qR2TY6lvAcjRzH7mYkMou26lvA6pQC5z55v45iP
	 2RHfIF8ROoT2+4iX6Xcpm3Wpp88Kl3I8pwMo6+8yiAnUfPO/c9eLno2VPnbYVzUXhw0F2
	 6bArtbARhNinq2jvJtwPdXUWPMx0PNiJ8tsqeTE7oZdfNVC09Cn1ntGp/NNLFCzGLPedr
	 Cc9P4ef+8BXir0JO1T/G6ogtuBNkfYCkOBQhWbl6grxuSD8cs6wGJ3IAkspEIK1wQ6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=aXJ3H8vA;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FA3606D807
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=aXJ3H8vA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=0KwLCbgabrj7tABSup4JIfw4cz4ImfGPHTDWMn3q4Cw=;
	t=1793651948; x=1794861548; b=aXJ3H8vAwHxrBoHlEv8MjNAVFor1UL0A5RBeHu0sIgFxuXt
	SM8yBUA/ltnBHI/Mroqfc7db7u7vXW5oaTwmRAP7gs+xcJFHYSqVM/XTxBP8y/K60bDZqVh+VYTaL
	0BOffddpdrXVg9rnHxxf/iZxfQW/WJLMKn9hCElhx6balTTnE8bYPnOj1AoASkAmuaW1mITA3zTeg
	OmOz65czEcjGKn9DbhtLhd8pyosRWAwqVGQvYfEbmN2Yye6xQ2MTgUH74uEn4VXSjMXIytYhLUScB
	Z/3vv4EXLhKESadFpzmP3+ER3ctXcM9EcSRTxkZ5LiAVBkOLJG3CeNOyrVVRiHJQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyo5-00000001vzr-39ZK;
	Mon, 02 Nov 2026 21:39:06 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 28/30] wifi: mac80211: split some TX code into helpers
Date: Mon,  2 Nov 2026 21:23:18 +0100
Message-ID: <20261102203831.1058362-60-johannes@sipsolutions.net>
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

Split the dynamic powersave, control port protocol flags
handling and frame resizing out of the TX code into a few
helper functions to be used later.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 82 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5ab061a010a6..9db16eb96588 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -188,45 +188,44 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 	return cpu_to_le16(dur);
 }
 
-/* tx handlers */
-static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
+static void ieee80211_tx_dynamic_ps(struct ieee80211_sub_if_data *sdata,
+				    struct sk_buff *skb)
 {
-	struct ieee80211_local *local = tx->local;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 
 	/* driver doesn't support power save */
 	if (!ieee80211_hw_check(&local->hw, SUPPORTS_PS))
-		return TX_CONTINUE;
+		return;
 
 	/* hardware does dynamic power save */
 	if (ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS))
-		return TX_CONTINUE;
+		return;
 
 	/* dynamic power save disabled */
 	if (local->hw.conf.dynamic_ps_timeout <= 0)
-		return TX_CONTINUE;
+		return;
 
 	/* we are scanning, don't enable power save */
 	if (local->scanning)
-		return TX_CONTINUE;
+		return;
 
 	if (!local->ps_sdata)
-		return TX_CONTINUE;
+		return;
 
 	/* No point if we're going to suspend */
 	if (local->quiescing)
-		return TX_CONTINUE;
+		return;
 
 	/* dynamic ps is supported only in managed mode */
-	if (tx->sdata->vif.type != NL80211_IFTYPE_STATION)
-		return TX_CONTINUE;
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return;
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_OFFCHAN_TX_OK))
-		return TX_CONTINUE;
+		return;
 
-	ifmgd = &tx->sdata->u.mgd;
+	ifmgd = &sdata->u.mgd;
 
 	/*
 	 * Don't wakeup from power save if u-apsd is enabled, voip ac has
@@ -243,8 +242,8 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	 */
 	if ((ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED) &&
 	    (ifmgd->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO) &&
-	    skb_get_queue_mapping(tx->skb) == IEEE80211_AC_VO)
-		return TX_CONTINUE;
+	    skb_get_queue_mapping(skb) == IEEE80211_AC_VO)
+		return;
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		ieee80211_stop_queues_by_reason(&local->hw,
@@ -258,10 +257,17 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 
 	/* Don't restart the timer if we're not disassociated */
 	if (!ifmgd->associated)
-		return TX_CONTINUE;
+		return;
 
 	mod_timer(&local->dynamic_ps_timer, jiffies +
 		  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+}
+
+/* tx handlers */
+static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
+{
+	ieee80211_tx_dynamic_ps(tx->sdata, tx->skb);
 
 	return TX_CONTINUE;
 }
@@ -588,17 +594,24 @@ ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 		return ieee80211_tx_h_multicast_ps_buf(tx);
 }
 
-static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
+static void
+ieee80211_tx_set_ctrl_port_flags(const struct ieee80211_sub_if_data *sdata,
+				 struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	if (unlikely(tx->sdata->control_port_protocol == tx->skb->protocol)) {
-		if (tx->sdata->control_port_no_encrypt)
+	if (unlikely(sdata->control_port_protocol == skb->protocol)) {
+		if (sdata->control_port_no_encrypt)
 			info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 		info->control.flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
 		info->flags |= IEEE80211_TX_CTL_USE_MINRATE;
 	}
+}
+
+static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
+{
+	ieee80211_tx_set_ctrl_port_flags(tx->sdata, tx->skb);
 
 	return TX_CONTINUE;
 }
@@ -2183,14 +2196,13 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
-		    struct sta_info *sta, struct sk_buff *skb)
+static int ieee80211_tx_resize(struct ieee80211_sub_if_data *sdata,
+			       struct sk_buff *skb)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	int headroom;
 	enum ieee80211_encrypt encrypt;
+	int headroom;
 
 	if (info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)
 		encrypt = ENCRYPT_NO;
@@ -2199,13 +2211,23 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 	else
 		encrypt = ENCRYPT_DATA;
 
-	headroom = local->tx_headroom;
+	headroom = sdata->local->tx_headroom;
 	if (encrypt != ENCRYPT_NO)
 		headroom += IEEE80211_ENCRYPT_HEADROOM;
 	headroom -= skb_headroom(skb);
 	headroom = max_t(int, 0, headroom);
 
-	if (ieee80211_skb_resize(sdata, skb, headroom, encrypt)) {
+	return ieee80211_skb_resize(sdata, skb, headroom, encrypt);
+}
+
+void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
+		    struct sta_info *sta, struct sk_buff *skb)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr;
+
+	if (ieee80211_tx_resize(sdata, skb)) {
 		ieee80211_free_txskb(&local->hw, skb);
 		return;
 	}
-- 
2.56.0

