Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2102848AA
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 14:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785766408; cv=none; b=W7oc6wjL5vNq29rS3iEz68E85WzDa93kGRwQ9BBo4dNo594OiZkALckQ9LSQJ36vvOjFg89UsS2Y4L3aQL16vLHsknRPd0W6KKl0+q31PrC3kz/L9VuRDStXNcLmL2MRBK7QIkqEwSexO719Bbqzbd7l4nbO78cKymmdew5K4Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785766408; c=relaxed/simple;
	bh=3PYJXZggJz15vfmQ6JQ7hsAp0wQjN4q8A4d8LmgZbmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnObLCzxF+A4Lj29mfEJr3RvF6CMglyDFTIv3hKzsDrIHEwBnfcqjrrEo9FzgfNUbftOfRtaSU4lQilOFVCD5x89Q9yq1Pg/vwbH8W/TrItAOYzy0U//sGcPo7MJxasBoqY8bcdgOlDS+0xz09NU/PVOeYtkKIw+k1ocLqS+8VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=HucgSWou; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="HucgSWou"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=5X9UVxCpmMIoJAklT7niIRxim6EnTxYSpt4kDThgUlY=;
	t=1785766406; x=1786976006; b=HucgSWouXwWcpcjzx7Wn0bFj/GfIsdao9mtjIJsC2uNeaib
	ioLIBnbLeYRl3x9fFqwDwYzNYg8AoEREyDaQpAmgwQbb8ZO7FguZXJRabqYLlcMhy1+HX7+UyxX8K
	fFOoyVStV3wvnjVW41Hd+xo+f6haWLhM3wwRGh+ivpP9x1GCyOD9RA3w6YdssqB64+FbIsmMKxHB1
	bAS36xyfUqywZXxJCeiYwkEhkqC0y54mhMqGkmudEiYB2p1dWP2+nAnI2K0ibCFJjLHD3syAqAIyx
	d6Lhs5GjflAzVjnWeiXRfVZIDUgMDC4wrWreoPJsGxAfL0Ch1676Yp41Jmd8Qqjw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqtPt-0000000G4Ws-1nFl;
	Mon, 03 Aug 2026 16:13:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 7/7] wifi: mac80211: store the ack skb before building the header
Date: Mon,  3 Aug 2026 16:08:43 +0200
Message-ID: <20260803141309.292711-16-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803141309.292711-9-johannes@sipsolutions.net>
References: <20260803141309.292711-9-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The ack skb has to be stored while the frame is still in 802.3
format, since that is what is reported back to userspace. It's
currently done in ieee80211_build_hdr(), but that complicates
it a bit.

Thanks the the previous ieee80211_lookup_ra_sta() change, it's
now known whether or not the frame will be group addressed on
the air, which is needed for this condition.

Also simplify callers of ieee80211_store_ack_skb() by filling
the TX info directly and fix the free in ieee80211_build_hdr()
to use ieee80211_free_txskb(), reporting the drop to userspace
rather than being quiet about it.

This also lets use validate the link ID for control port TX in
that code itself, rather than interleaving it into build_hdr().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 116 ++++++++++++++--------------------------------
 1 file changed, 36 insertions(+), 80 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 96261429a78d..911c4b5700d0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2588,13 +2588,11 @@ static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static u16 ieee80211_store_ack_skb(struct ieee80211_local *local,
-				   struct sk_buff *skb,
-				   u32 *info_flags,
-				   u64 cookie)
+static void ieee80211_store_ack_skb(struct ieee80211_local *local,
+				    struct sk_buff *skb, u64 cookie)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct sk_buff *ack_skb;
-	u16 info_id = 0;
 
 	if (skb->sk)
 		ack_skb = skb_clone_sk(skb);
@@ -2611,28 +2609,15 @@ static u16 ieee80211_store_ack_skb(struct ieee80211_local *local,
 		spin_unlock_irqrestore(&local->ack_status_lock, flags);
 
 		if (id >= 0) {
-			info_id = id;
-			*info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+			info->status_data = id;
+			info->status_data_idr = 1;
+			info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 			if (cookie)
 				IEEE80211_SKB_CB(ack_skb)->ack.cookie = cookie;
 		} else {
 			kfree_skb(ack_skb);
 		}
 	}
-
-	return info_id;
-}
-
-static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
-{
-	struct sk_buff *ack_skb;
-	unsigned long flags;
-
-	spin_lock_irqsave(&local->ack_status_lock, flags);
-	ack_skb = idr_remove(&local->ack_status_frames, info_id);
-	spin_unlock_irqrestore(&local->ack_status_lock, flags);
-
-	kfree_skb(ack_skb);
 }
 
 /**
@@ -2640,7 +2625,6 @@ static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
  * @sdata: virtual interface to build the header for
  * @skb: the skb to build the header in
  * @sta: the station pointer
- * @cookie: cookie pointer to fill (if not %NULL)
  *
  * This function takes the skb with 802.3 header and reformats the header to
  * the appropriate IEEE 802.11 header based on which interface the packet is
@@ -2656,8 +2640,7 @@ static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
  */
 static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb,
-					   struct sta_info *sta,
-					   u64 cookie)
+					   struct sta_info *sta)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_local *local = sdata->local;
@@ -2672,7 +2655,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	bool wme_sta = false, authorized = false;
 	bool tdls_peer;
 	bool multicast;
-	u16 info_id = 0;
 	struct ieee80211_chanctx_conf *chanctx_conf = NULL;
 	enum nl80211_band band;
 	int ret;
@@ -2954,11 +2936,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		goto free;
 	}
 
-	if (unlikely(!multicast &&
-		     (sk_requests_wifi_status(skb->sk) || cookie)))
-		info_id = ieee80211_store_ack_skb(local, skb, &info->flags,
-						  cookie);
-
 	hdr.frame_control = fc;
 	hdr.duration_id = 0;
 	hdr.seq_ctrl = 0;
@@ -2997,8 +2974,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		head_need += local->tx_headroom;
 		head_need = max_t(int, 0, head_need);
 		if (ieee80211_skb_resize(sdata, skb, head_need, ENCRYPT_DATA)) {
-			ieee80211_free_txskb(&local->hw, skb);
-			skb = NULL;
 			ret = -ENOMEM;
 			goto free;
 		}
@@ -3027,44 +3002,14 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 	skb_reset_mac_header(skb);
 
-	if (info_id) {
-		info->status_data = info_id;
-		info->status_data_idr = 1;
-	}
 	info->band = band;
 
-	if (likely(!cookie)) {
-		info->control.flags |=
-			u32_encode_bits(link_id, IEEE80211_TX_CTRL_MLO_LINK);
-	} else {
-		unsigned int pre_conf_link_id;
-
-		/*
-		 * The link ID already has been set by
-		 * ieee80211_tx_control_port(), here
-		 * we just sanity check that
-		 */
-
-		pre_conf_link_id = u32_get_bits(info->control.flags,
-						IEEE80211_TX_CTRL_MLO_LINK);
-
-		if (pre_conf_link_id != link_id &&
-		    link_id != IEEE80211_LINK_UNSPECIFIED) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			net_info_ratelimited("%s: dropped frame to %pM with bad link ID request (%d vs. %d)\n",
-					     sdata->name, hdr.addr1,
-					     pre_conf_link_id, link_id);
-#endif
-			ret = -EINVAL;
-			goto free;
-		}
-	}
-
+	info->control.flags =
+		u32_replace_bits(info->control.flags, link_id,
+				 IEEE80211_TX_CTRL_MLO_LINK);
 	return skb;
  free:
-	if (info_id)
-		ieee80211_remove_ack_skb(local, info_id);
-	kfree_skb(skb);
+	ieee80211_free_txskb(&local->hw, skb);
 	return ERR_PTR(ret);
 }
 
@@ -4369,6 +4314,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	struct ieee80211_tx_info *info;
 	struct sta_info *sta;
 	struct sk_buff *next;
+	bool group_addressed;
 	int len = skb->len;
 
 	if (unlikely(!ieee80211_sdata_running(sdata) || skb->len < ETH_HLEN)) {
@@ -4388,6 +4334,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	if (ieee80211_lookup_ra_sta(sdata, skb, &sta))
 		goto out_free;
 
+	group_addressed = IS_ERR(sta);
 	if (IS_ERR(sta))
 		sta = NULL;
 
@@ -4431,7 +4378,11 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		info->flags = info_flags;
 		info->control.flags = ctrl_flags;
 
-		skb = ieee80211_build_hdr(sdata, skb, sta, 0);
+		if (unlikely(!group_addressed &&
+			     sk_requests_wifi_status(skb->sk)))
+			ieee80211_store_ack_skb(local, skb, 0);
+
+		skb = ieee80211_build_hdr(sdata, skb, sta);
 		if (IS_ERR(skb)) {
 			kfree_skb_list(next);
 			goto out;
@@ -4766,12 +4717,8 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 			memcpy(IEEE80211_SKB_CB(seg), info, sizeof(*info));
 	}
 
-	if (unlikely(sk_requests_wifi_status(skb->sk))) {
-		info->status_data = ieee80211_store_ack_skb(local, skb,
-							    &info->flags, 0);
-		if (info->status_data)
-			info->status_data_idr = 1;
-	}
+	if (unlikely(sk_requests_wifi_status(skb->sk)))
+		ieee80211_store_ack_skb(local, skb, 0);
 
 	dev_sw_netstats_tx_add(dev, skbs, len);
 
@@ -4916,7 +4863,7 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 	info->flags = info_flags;
 	info->control.flags = IEEE80211_TX_CTRL_MLO_LINK_UNSPEC;
 
-	skb = ieee80211_build_hdr(sdata, skb, sta, 0);
+	skb = ieee80211_build_hdr(sdata, skb, sta);
 	if (IS_ERR(skb))
 		goto out;
 
@@ -6537,6 +6484,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
+	bool group_addressed;
 	struct sta_info *sta;
 	struct sk_buff *skb;
 	struct ethhdr *ehdr;
@@ -6577,15 +6525,11 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 
 	/* we may override the SA for MLO STA later */
 	if (link_id < 0) {
-		ctrl_flags |= u32_encode_bits(IEEE80211_LINK_UNSPECIFIED,
-					      IEEE80211_TX_CTRL_MLO_LINK);
+		link_id = IEEE80211_LINK_UNSPECIFIED;
 		memcpy(ehdr->h_source, sdata->vif.addr, ETH_ALEN);
 	} else {
 		struct ieee80211_bss_conf *link_conf;
 
-		ctrl_flags |= u32_encode_bits(link_id,
-					      IEEE80211_TX_CTRL_MLO_LINK);
-
 		rcu_read_lock();
 		link_conf = rcu_dereference(sdata->vif.link_conf[link_id]);
 		if (!link_conf) {
@@ -6616,6 +6560,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 		return err;
 	}
 
+	group_addressed = IS_ERR(sta);
 	if (IS_ERR(sta))
 		sta = NULL;
 
@@ -6631,14 +6576,25 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	info = IEEE80211_SKB_CB(skb);
 	memset(info, 0, sizeof(*info));
 	info->flags = flags;
+	ctrl_flags |= u32_encode_bits(link_id, IEEE80211_TX_CTRL_MLO_LINK);
 	info->control.flags = ctrl_flags;
 
-	skb = ieee80211_build_hdr(sdata, skb, sta, cookie);
+	if (!group_addressed)
+		ieee80211_store_ack_skb(local, skb, cookie);
+
+	skb = ieee80211_build_hdr(sdata, skb, sta);
 	if (IS_ERR(skb)) {
 		rcu_read_unlock();
 		return PTR_ERR(skb);
 	}
 
+	if (link_id != u32_get_bits(info->control.flags,
+				    IEEE80211_TX_CTRL_MLO_LINK)) {
+		ieee80211_free_txskb(&local->hw, skb);
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
 	dev_sw_netstats_tx_add(dev, 1, skb->len);
 	ieee80211_tpt_led_trig_tx(local, skb->len);
 
-- 
2.55.0

