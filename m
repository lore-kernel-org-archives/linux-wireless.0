Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651949;
	b=3NSqCcujHFdRTMzlxALH2OStp/V/8uP6izo0aiEFfnc1AYMm3W37Z0uup2/wxGJhbg7X
	 Bvq4Zz52r0UtgvO/UpY/qnxjHalqqWQ4yDZUiIPDmHDB39OO3+RutkSAebf1JRsJMXBb0
	 usB8TDDHkaNKXpg4hpqR9DA+inKC90STlBndk11UH+pX5m3pKwZeV5Dj84agjCGInPXer
	 jZaJ4mzFHFMrUqKLv7yskZ5nZJrYwrzPSzw++C476wsQ9C3cuStnUSUHKUjiHkBJPcOdY
	 IWzOPwz09gHD+02heV6wfmLN7DX4FBT4U4I2KCaBAJSzcyktmldY2F0r2ZhbcTVbv4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651949;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yZzj+l5/VBBJ5koo+HLC0nJR0UfdQHjA3xv2UKjxJM0=;
	b=iRbelY+T2xjA77OHf072MGOqgvxyC+1kXNqP6P0YKIvVMsjcwNO04T+AHuGbcXj4BGCB
	 exv2UdLW65Fk1Gy8h9TiW1JB7Rbqz9k7xf7cCisa2Qd/jtm+4UAxlwopiJy1IgFOdROe9
	 33FbKx33Af0x95XEsRHSOsoPr7XkM9Zqpdey+9Dn2W+w2u2Q9Ac57eTniqr8ZOrvI06YA
	 boXjm5WpDYyAvPsRekNG7J+mKppSpuV+OIT0dyJjwUtG9ttn6zjMSqDWFBBD9VIOedh6s
	 Y+FL5bjk8N4N5A+MO4iP687oo63EDZa5AIQbfEP6DYJJH3h8mGpJY2xVeXGjwJSS0Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=QpyYo+jf;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3B1606D80A
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=QpyYo+jf
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=yZzj+l5/VBBJ5koo+HLC0nJR0UfdQHjA3xv2UKjxJM0=;
	t=1793651949; x=1794861549; b=QpyYo+jfxwT6NEFazhCH+Ve1DfPpHAV6BU+n4/hya5C9aR0
	yRi5MMRqPqbvfex/zSPHhOpZ902hiU0l5Gz8kr7r9/ZD7MkRV2L/2LePLG8+ezOVuabnBYKmdZGfM
	udZwtVbRF6cbuo7ZGu8MhA57nfVxbAIO6ZuoGo4VhBa2gwmwKKCBT32R6nQDYfhrcbepN0La79MHC
	P0Dr4Ha6prYlGOXRaDig2zcQLC6NwGU2cZ1pEq9ewb4Qmy6pyqLMTnYjpeNreV5GdGYdVFZn6lpE8
	La9+zeynta1zERVbQmq2y3uu04b+ZBNtRc9N3Dh5d7Z+neOUFn7IkLbhKlQh09OA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyo6-00000001vzr-4Bql;
	Mon, 02 Nov 2026 21:39:07 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 29/30] wifi: mac80211: queue unicast data frames as ethernet
Date: Mon,  2 Nov 2026 21:23:19 +0100
Message-ID: <20261102203831.1058362-61-johannes@sipsolutions.net>
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

After the earlier changes, unicast data frames without
fast-xmit were still first converted before being queued.
Except for mesh (it requires path selection) put these
onto the TXQs in ethernet format as well. Encapsulating
them at dequeue time uses the fast-xmit template if it
can, otherwise the regular way.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 145 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 113 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9db16eb96588..8f528ab7ebf3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -673,7 +673,8 @@ ieee80211_select_key_8023(struct ieee80211_tx_data *tx)
 	if (!tx->key)
 		return TX_CONTINUE;
 
-	if (unlikely(tx->key->flags & KEY_FLAG_TAINTED))
+	if (unlikely(tx->key->flags & KEY_FLAG_TAINTED &&
+		     !(info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)))
 		return TX_DROP;
 
 	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
@@ -3887,16 +3888,76 @@ static bool ieee80211_xmit_fast_queue(struct ieee80211_sub_if_data *sdata,
 	return ieee80211_queue_skb(sdata->local, sdata, sta, skb);
 }
 
+static void ieee80211_tx_mark_ba_session_used(const struct sta_info *sta,
+					      struct sk_buff *skb)
+{
+	u8 tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
+	struct tid_ampdu_tx *tid_tx;
+
+	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
+	if (tid_tx && tid_tx->timeout)
+		tid_tx->last_tx = jiffies;
+}
+
+/* full handling, for frames that fast-xmit doesn't apply to */
+static void ieee80211_xmit_queue_full(struct ieee80211_sub_if_data *sdata,
+				      struct sta_info *sta,
+				      struct sk_buff *skb,
+				      u32 info_flags, u32 ctrl_flags)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sub_if_data *ap_sdata = sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+
+	memset(info, 0, sizeof(*info));
+	info->control.vif = &sdata->vif;
+	info->flags = info_flags | IEEE80211_TX_CTL_FIRST_FRAGMENT |
+		      IEEE80211_TX_INTFL_NEED_80211_ENCAP;
+	info->control.flags = ctrl_flags;
+
+	if (sdata->vif.type == NL80211_IFTYPE_NAN_DATA) {
+		/* NAN operates on multiple bands */
+		info->band = NUM_NL80211_BANDS;
+	} else if (!ieee80211_vif_is_mld(&sdata->vif)) {
+		/* MLD transmissions must not rely on the band */
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			ap_sdata = container_of(sdata->bss,
+						struct ieee80211_sub_if_data,
+						u.ap);
+		chanctx_conf =
+			rcu_dereference(ap_sdata->vif.bss_conf.chanctx_conf);
+		if (unlikely(!chanctx_conf))
+			goto free;
+		info->band = chanctx_conf->def.chan->band;
+	}
+
+	ieee80211_tx_set_ctrl_port_flags(sdata, skb);
+
+	if (unlikely(sk_requests_wifi_status(skb->sk)))
+		ieee80211_store_ack_skb(local, skb, 0);
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	if (local->force_tx_status)
+		info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+#endif
+
+	ieee80211_tx_dynamic_ps(sdata, skb);
+	ieee80211_tx_mark_ba_session_used(sta, skb);
+
+	if (ieee80211_queue_skb(local, sdata, sta, skb))
+		return;
+free:
+	ieee80211_free_txskb(&local->hw, skb);
+}
+
 static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 				struct sta_info *sta,
 				struct ieee80211_fast_tx *fast_tx,
 				struct sk_buff *skb)
 {
 	u16 ethertype = (skb->data[12] << 8) | skb->data[13];
-	struct ieee80211_hdr *hdr = (void *)fast_tx->hdr;
-	struct tid_ampdu_tx *tid_tx = NULL;
 	struct sk_buff *next;
-	u8 tid;
 
 	/* control port protocol needs a lot of special handling */
 	if (cpu_to_be16(ethertype) == sdata->control_port_protocol)
@@ -3910,16 +3971,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (sk_requests_wifi_status(skb->sk))
 		return false;
 
-	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
-		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
-		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
-		if (tid_tx) {
-			if (!test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state))
-				return false;
-			if (tid_tx->timeout)
-				tid_tx->last_tx = jiffies;
-		}
-	}
+	ieee80211_tx_mark_ba_session_used(sta, skb);
 
 	/* after this point (skb is modified) we cannot return false */
 	skb = ieee80211_tx_skb_fixup(skb, ieee80211_sdata_netdev_features(sdata));
@@ -4031,10 +4083,23 @@ static bool ieee80211_amsdu_subframe(struct ieee80211_local *local,
 
 static bool ieee80211_can_use_fast_xmit(struct sk_buff *skb)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	u16 ethertype = (skb->data[12] << 8) | skb->data[13];
 
 	/* length "ethertype" doesn't go with RFC 1042 header */
-	return ethertype >= ETH_P_802_3_MIN;
+	if (ethertype < ETH_P_802_3_MIN)
+		return false;
+
+	return !(info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO);
+}
+
+/* don't aggregate frames with status request */
+static bool ieee80211_tx_needs_own_status(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	return info->status_data_idr ||
+	       info->flags & IEEE80211_TX_INTFL_MLME_CONN_TX;
 }
 
 static void ieee80211_tx_build_amsdu(const struct ieee80211_tx_data *tx,
@@ -4058,11 +4123,7 @@ static void ieee80211_tx_build_amsdu(const struct ieee80211_tx_data *tx,
 	if (!flow || !ieee80211_hw_check(&local->hw, TX_AMSDU) ||
 	    !(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) ||
 	    test_bit(IEEE80211_TXQ_NO_AMSDU, &txqi->flags) ||
-	    skb_is_gso(head))
-		return;
-
-	/* don't aggregate frames with status request */
-	if (IEEE80211_SKB_CB(head)->status_data_idr)
+	    skb_is_gso(head) || ieee80211_tx_needs_own_status(head))
 		return;
 
 	if (sta->sta.cur->max_rc_amsdu_len)
@@ -4101,7 +4162,7 @@ static void ieee80211_tx_build_amsdu(const struct ieee80211_tx_data *tx,
 		info = IEEE80211_SKB_CB(skb);
 		if (!(info->flags & IEEE80211_TX_INTFL_NEED_80211_ENCAP) ||
 		    !ieee80211_can_use_fast_xmit(skb) ||
-		    info->status_data_idr || skb_is_gso(skb))
+		    ieee80211_tx_needs_own_status(skb) || skb_is_gso(skb))
 			break;
 
 		if (len + pad + skb->len + sizeof(rfc1042_header) + 2 >
@@ -4186,14 +4247,12 @@ static void ieee80211_8023_tx_stats(struct sta_info *sta, struct sk_buff *skb)
 	}
 }
 
-static void ieee80211_set_hw_encap(struct ieee80211_tx_data *tx,
-				   struct ieee80211_txq *txq)
+static void ieee80211_set_hw_encap(const struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	info->control.flags |= IEEE80211_TX_CTRL_MLO_LINK_UNSPEC;
-	info->hw_queue = txq->vif->hw_queue[skb_get_queue_mapping(skb)];
 
 	ieee80211_8023_tx_stats(tx->sta, skb);
 }
@@ -4233,16 +4292,25 @@ static int ieee80211_txq_build_hdr(struct ieee80211_tx_data *tx,
 		}
 		info->control.flags |= IEEE80211_TX_CTRL_FAST_XMIT;
 		ieee80211_tx_build_amsdu(tx, txqi, flow, fast_tx);
-		return 0;
+	} else {
+		skb = ieee80211_build_hdr(sdata, skb, tx->sta);
+		if (IS_ERR(skb))
+			return PTR_ERR(skb);
+
+		if (ieee80211_tx_resize(sdata, skb)) {
+			ieee80211_free_txskb(&tx->local->hw, skb);
+			return -ENOMEM;
+		}
+
+		ieee80211_set_qos_hdr(sdata, skb);
+		dev_sw_netstats_tx_add(skb->dev, 1, skb->len);
+		tx->skb = skb;
 	}
 
-	skb = ieee80211_build_hdr(sdata, skb, tx->sta);
-	if (IS_ERR(skb))
-		return PTR_ERR(skb);
+	if (!tx->sta ||
+	    skb->len + FCS_LEN <= tx->local->hw.wiphy->frag_threshold)
+		info->flags |= IEEE80211_TX_CTL_DONTFRAG;
 
-	ieee80211_set_qos_hdr(sdata, skb);
-	dev_sw_netstats_tx_add(skb->dev, 1, skb->len);
-	tx->skb = skb;
 	return 0;
 }
 
@@ -4357,8 +4425,10 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				IEEE80211_TX_CTL_DONTFRAG);
 
 	if (info->flags & IEEE80211_TX_INTFL_NEED_80211_ENCAP) {
+		info->hw_queue = vif->hw_queue[skb_get_queue_mapping(skb)];
+
 		if (ieee80211_hw_can_encap(&tx, ps_release))
-			ieee80211_set_hw_encap(&tx, txq);
+			ieee80211_set_hw_encap(&tx);
 		else if (ieee80211_txq_build_hdr(&tx, txqi, flow))
 			goto begin;
 		skb = tx.skb;
@@ -4802,6 +4872,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	struct sta_info *sta;
 	struct sk_buff *next;
 	bool group_addressed;
+	bool queue_ethernet;
 	int len = skb->len;
 
 	if (unlikely(!ieee80211_sdata_running(sdata) || skb->len < ETH_HLEN)) {
@@ -4839,6 +4910,10 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 			goto out;
 	}
 
+	queue_ethernet = sta && sta->uploaded &&
+			 test_sta_flag(sta, WLAN_STA_ASSOC) &&
+			 !ieee80211_vif_is_mesh(&sdata->vif);
+
 	/* the frame could be fragmented, software-encrypted, and other
 	 * things so we cannot really handle checksum or GSO offload.
 	 * fix it up in software before we handle anything else.
@@ -4861,6 +4936,12 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 			goto out;
 		}
 
+		if (queue_ethernet) {
+			ieee80211_xmit_queue_full(sdata, sta, skb, info_flags,
+						  ctrl_flags);
+			continue;
+		}
+
 		info = IEEE80211_SKB_CB(skb);
 		memset(info, 0, sizeof(*info));
 		info->flags = info_flags;
-- 
2.56.0

