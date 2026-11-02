Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651947;
	b=qAIabqmMTogqi6cE+LjysyYNVeS/fhc1hMWUdMiHJQAC9gMrE4YBWot2cQm1jYy4XbIz
	 8VJMGOXjOBNwNaWhdS9OmdXTz0IiHtdTgR+GgKeOUwcjIx7pzeGGPlTbQQU+hMPWn+yfi
	 QHqHSY7yy4DiJHyrsJ/hIOyCiDFC/gzx/tIUMIBu9U2LZ3+nA6x0FGu0ijyYbYiHO48mF
	 PzJbZB4TURK4jgb4UEKwNYZxaBv8XVGNKt0MiPVVGD+y812WOkTKyubqiU20J+WI3XMuA
	 crZQCntnv5hpSx6HMEarz6PPrLm+h1+hh4dsvM4aE9uHvvWAkCRgABBsTlJnpPE05lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651947;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=5SGqUBkJFG/l7tmrndJi1moiSQE0IjrFsbA2qkSuXAE=;
	b=DXgxE+SbqCRKqwMCE+8KMmWGj9fHZENUCjkNGBeRq+cMb3yQ9Ka1N0ZzSdXcjiAvXrQb
	 qN5kzfBrCc4S/A+zmDoQ5n2jwbHsAB9zevpIKJ2aWGy5RA5aD4m5YZNZZQdybLNFVupp1
	 ixTi8uO1AyoA++AsNnaVZ+S3njTuhXOTiR8/C6gebjmAl4jEyBoH9BsXEPh37muamE0NE
	 qUWFVUYKEQPyQZPCuxMLixH0j4XDtxRs4FAxzrGMgRyzF7Opfht8HGby9W9Uhrb7IMFeh
	 WN/EJauj3ORPTnJX2aK+aDZN3+kPQTKCHDVWGh2BOAfodlBGoPlmY0AQVSq81HMz8zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=PJbhskOh;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED62F606A333
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=PJbhskOh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=5SGqUBkJFG/l7tmrndJi1moiSQE0IjrFsbA2qkSuXAE=;
	t=1793651946; x=1794861546; b=PJbhskOhi67s8s0bE7qL/J8tQOtfpGYSwg4x89dUKjXo6yY
	X0KsKa3S9DFu2PAG0pK+C3LuXSYr6xGHq2Tu4dPRgEY9rTyrTxk2Y0jSrBdXgPKkLVdulVEeS+TG9
	g0erFA/6TqjWTgWxlzo+H3pDiSMTcMBqGlbDjoHvvppDYqvQ9JMne5JVmDYdaFZZTCdsh1rvIaq2E
	Dye4A/fjDQeJ6UWuBmfObzY0NSywK4fIjn89W6GRGCXQ3Z4x6bR2Z6p7G8uyfvWlTDhjSyzHmXOmS
	OxqPU+DbogccTarLfj66qiokA2P54Ld3u+JgQEH4u92Q/dgk1lw/YQ8w9UdtpbhQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyo4-00000001vzr-3rJn;
	Mon, 02 Nov 2026 21:39:05 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 27/30] wifi: mac80211: handle 802.11 encap at TXQ dequeue
Date: Mon,  2 Nov 2026 21:23:17 +0100
Message-ID: <20261102203831.1058362-59-johannes@sipsolutions.net>
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

Now that fast-xmit and encapsulation offload frames both go
on the TXQ in ethernet format, it's not as relevant whether
or not the device can do it, defer that decision to dequeue
time.

This is mostly preparation work, the next commits change it
so that all (unicast data) frames go onto the TXQs without
conversion first.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |   6 --
 net/mac80211/tx.c       | 140 +++++++++++++++++++++++++++++-----------
 2 files changed, 102 insertions(+), 44 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index ad73a20eddb5..8e044ff5f716 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2078,9 +2078,6 @@ static bool ieee80211_sta_ps_from_txqs(const struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->local;
 
-	if (sta->sdata->vif.offload_flags & IEEE80211_OFFLOAD_ENCAP_ENABLED)
-		return false;
-
 	return !local->ops->release_buffered_frames ||
 	       local->ops->allow_buffered_frames;
 }
@@ -2090,9 +2087,6 @@ static bool ieee80211_sta_ps_frame_ends_bu(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 
-	if (IEEE80211_SKB_CB(skb)->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
-		return true;
-
 	return !ieee80211_has_morefrags(hdr->frame_control);
 }
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 57b67774f527..5ab061a010a6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3854,8 +3854,7 @@ static bool ieee80211_xmit_fast_queue(struct ieee80211_sub_if_data *sdata,
 	info->flags = IEEE80211_TX_CTL_FIRST_FRAGMENT |
 		      IEEE80211_TX_CTL_DONTFRAG |
 		      IEEE80211_TX_INTFL_NEED_80211_ENCAP;
-	info->control.flags = IEEE80211_TX_CTRL_FAST_XMIT |
-			      u32_encode_bits(IEEE80211_LINK_UNSPECIFIED,
+	info->control.flags = u32_encode_bits(IEEE80211_LINK_UNSPECIFIED,
 					      IEEE80211_TX_CTRL_MLO_LINK);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -4008,6 +4007,14 @@ static bool ieee80211_amsdu_subframe(struct ieee80211_local *local,
 	return true;
 }
 
+static bool ieee80211_can_use_fast_xmit(struct sk_buff *skb)
+{
+	u16 ethertype = (skb->data[12] << 8) | skb->data[13];
+
+	/* length "ethertype" doesn't go with RFC 1042 header */
+	return ethertype >= ETH_P_802_3_MIN;
+}
+
 static void ieee80211_tx_build_amsdu(const struct ieee80211_tx_data *tx,
 				     const struct txq_info *txqi,
 				     struct fq_flow *flow,
@@ -4032,6 +4039,10 @@ static void ieee80211_tx_build_amsdu(const struct ieee80211_tx_data *tx,
 	    skb_is_gso(head))
 		return;
 
+	/* don't aggregate frames with status request */
+	if (IEEE80211_SKB_CB(head)->status_data_idr)
+		return;
+
 	if (sta->sta.cur->max_rc_amsdu_len)
 		max_amsdu_len = min_t(int, max_amsdu_len,
 				      sta->sta.cur->max_rc_amsdu_len);
@@ -4067,8 +4078,8 @@ static void ieee80211_tx_build_amsdu(const struct ieee80211_tx_data *tx,
 
 		info = IEEE80211_SKB_CB(skb);
 		if (!(info->flags & IEEE80211_TX_INTFL_NEED_80211_ENCAP) ||
-		    !(info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) ||
-		    skb_is_gso(skb))
+		    !ieee80211_can_use_fast_xmit(skb) ||
+		    info->status_data_idr || skb_is_gso(skb))
 			break;
 
 		if (len + pad + skb->len + sizeof(rfc1042_header) + 2 >
@@ -4109,37 +4120,105 @@ static void ieee80211_tx_build_amsdu(const struct ieee80211_tx_data *tx,
 	spin_unlock_bh(&fq->lock);
 }
 
+static bool ieee80211_hw_can_encap(const struct ieee80211_tx_data *tx,
+				   bool ps_release)
+{
+	struct ieee80211_sub_if_data *sdata = tx->sta ? tx->sta->sdata :
+							tx->sdata;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_sub_if_data *bss = sdata;
+	u32 flags;
+
+	/* PS release has 802.11 header flags we set */
+	if (ps_release ||
+	    (tx->sta && (test_sta_flag(tx->sta, WLAN_STA_PS_STA) ||
+			 test_sta_flag(tx->sta, WLAN_STA_PS_DRIVER))))
+		return false;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		bss = container_of(sdata->bss, struct ieee80211_sub_if_data,
+				   u.ap);
+	flags = bss->vif.offload_flags;
+
+	if (!(flags & IEEE80211_OFFLOAD_ENCAP_ENABLED) ||
+	    (sdata->wdev.use_4addr && !(flags & IEEE80211_OFFLOAD_ENCAP_4ADDR)) ||
+	    (!tx->sta && !(flags & IEEE80211_OFFLOAD_ENCAP_MCAST)))
+		return false;
+
+	if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
+		return false;
+
+	return !tx->key ||
+	       (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+		tx->key->conf.cipher != WLAN_CIPHER_SUITE_TKIP);
+}
+
+static void ieee80211_8023_tx_stats(struct sta_info *sta, struct sk_buff *skb)
+{
+	int ac = skb_get_queue_mapping(skb);
+
+	dev_sw_netstats_tx_add(skb->dev, 1, skb->len);
+	if (sta) {
+		sta->deflink.tx_stats.packets[ac]++;
+		sta->deflink.tx_stats.bytes[ac] += skb->len;
+	}
+}
+
+static void ieee80211_set_hw_encap(struct ieee80211_tx_data *tx,
+				   struct ieee80211_txq *txq)
+{
+	struct sk_buff *skb = tx->skb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	info->control.flags |= IEEE80211_TX_CTRL_MLO_LINK_UNSPEC;
+	info->hw_queue = txq->vif->hw_queue[skb_get_queue_mapping(skb)];
+
+	ieee80211_8023_tx_stats(tx->sta, skb);
+}
+
 static int ieee80211_txq_build_hdr(struct ieee80211_tx_data *tx,
 				   const struct txq_info *txqi,
 				   struct fq_flow *flow)
 {
-	const struct ieee80211_fast_tx *fast_tx;
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sub_if_data *sdata = tx->sdata;
+	const struct ieee80211_fast_tx *fast_tx = NULL;
 	struct ethhdr eth;
 
 	info->flags &= ~IEEE80211_TX_INTFL_NEED_80211_ENCAP;
+	info->control.flags = u32_replace_bits(info->control.flags,
+					       IEEE80211_LINK_UNSPECIFIED,
+					       IEEE80211_TX_CTRL_MLO_LINK);
 
+	if (WARN_ON_ONCE(!tx->sta)) {
+		ieee80211_free_txskb(&tx->local->hw, skb);
+		return -EINVAL;
+	}
+
+	/* use sta->sdata for VLAN, info->control.vif is the AP */
+	sdata = tx->sta->sdata;
 	fast_tx = rcu_dereference(tx->sta->fast_tx);
-	if (fast_tx && fast_tx->key == tx->key) {
+
+	/* if key changed the header template might have changed */
+	if (fast_tx && fast_tx->key == tx->key &&
+	    ieee80211_can_use_fast_xmit(skb)) {
 		memcpy(&eth, skb->data, ETH_HLEN - 2);
 		if (ieee80211_fast_tx_encap(tx->sdata, fast_tx, skb,
 					    eth.h_dest, eth.h_source)) {
 			ieee80211_free_txskb(&tx->local->hw, skb);
 			return -ENOMEM;
 		}
+		info->control.flags |= IEEE80211_TX_CTRL_FAST_XMIT;
 		ieee80211_tx_build_amsdu(tx, txqi, flow, fast_tx);
 		return 0;
 	}
 
-	info->control.flags &= ~IEEE80211_TX_CTRL_FAST_XMIT;
-
-	/* use sta->sdata for VLAN, info->control.vif is the AP */
-	skb = ieee80211_build_hdr(tx->sta->sdata, skb, tx->sta);
+	skb = ieee80211_build_hdr(sdata, skb, tx->sta);
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
-	ieee80211_set_qos_hdr(tx->sta->sdata, skb);
+	ieee80211_set_qos_hdr(sdata, skb);
 	dev_sw_netstats_tx_add(skb->dev, 1, skb->len);
 	tx->skb = skb;
 	return 0;
@@ -4255,12 +4334,13 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		info->flags |= (IEEE80211_TX_CTL_AMPDU |
 				IEEE80211_TX_CTL_DONTFRAG);
 
-	/* the fast-xmit check here distinguishes from HW offload */
-	if (info->flags & IEEE80211_TX_INTFL_NEED_80211_ENCAP &&
-	    info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {
-		if (ieee80211_txq_build_hdr(&tx, txqi, flow))
+	if (info->flags & IEEE80211_TX_INTFL_NEED_80211_ENCAP) {
+		if (ieee80211_hw_can_encap(&tx, ps_release))
+			ieee80211_set_hw_encap(&tx, txq);
+		else if (ieee80211_txq_build_hdr(&tx, txqi, flow))
 			goto begin;
 		skb = tx.skb;
+		info = IEEE80211_SKB_CB(skb);
 		hdr = (struct ieee80211_hdr *)skb->data;
 	}
 
@@ -5029,6 +5109,9 @@ static bool ieee80211_tx_8023(struct ieee80211_sub_if_data *sdata,
 
 	skb_list_walk_safe(skb, skb, next) {
 		skb_mark_not_on_list(skb);
+		/* frames from the pending queue were counted already */
+		if (!txpending)
+			ieee80211_8023_tx_stats(sta, skb);
 		if (!__ieee80211_tx_8023(sdata, skb, sta, txpending))
 			ret = false;
 	}
@@ -5045,7 +5128,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct tid_ampdu_tx *tid_tx = NULL;
 	struct sk_buff *seg, *next;
-	unsigned int skbs = 0, len = 0;
+	unsigned int len = 0;
 	u16 queue;
 	u8 tid;
 
@@ -5062,17 +5145,8 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 
 	if (sta)
 		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
-	if (tid_tx) {
-		if (!test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
-			/* fall back to non-offload slow path */
-			__ieee80211_subif_start_xmit(skb, dev, 0,
-						     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC);
-			return;
-		}
-
-		if (tid_tx->timeout)
-			tid_tx->last_tx = jiffies;
-	}
+	if (tid_tx && tid_tx->timeout)
+		tid_tx->last_tx = jiffies;
 
 	skb = ieee80211_tx_skb_fixup(skb, ieee80211_sdata_netdev_features(sdata));
 	if (!skb)
@@ -5104,7 +5178,6 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 		info->control.hw_key = &key->conf;
 
 	skb_list_walk_safe(skb, seg, next) {
-		skbs++;
 		len += seg->len;
 		if (seg != skb)
 			memcpy(IEEE80211_SKB_CB(seg), info, sizeof(*info));
@@ -5113,13 +5186,6 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	if (unlikely(sk_requests_wifi_status(skb->sk)))
 		ieee80211_store_ack_skb(local, skb, 0);
 
-	dev_sw_netstats_tx_add(dev, skbs, len);
-
-	if (sta) {
-		sta->deflink.tx_stats.packets[queue] += skbs;
-		sta->deflink.tx_stats.bytes[queue] += len;
-	}
-
 	ieee80211_tpt_led_trig_tx(local, len);
 
 	ieee80211_tx_8023(sdata, skb, sta, false);
@@ -6668,9 +6734,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	spin_lock(&local->fq.lock);
 	if (!txq_has_queue(vif->txq)) {
 		clear_bit(IEEE80211_TXQ_MCAST_PS, &txqi->flags);
-	} else if (skb &&
-		   !(IEEE80211_SKB_CB(skb)->flags &
-		     IEEE80211_TX_CTL_HW_80211_ENCAP)) {
+	} else if (skb) {
 		struct ieee80211_hdr *hdr = (void *)skb->data;
 
 		/* inform PS stations about more buffered frames */
-- 
2.56.0

