Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484D340F74D
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 14:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785766405; cv=none; b=V8zEGrJPVuewaRdyGktBvgM2lj5nX5ZgllhcyXNDfSzWLfoi767wkWERuw/iIJWBQw1PaHWGHoMpKRL1cjmi5iHhkDg+LXCOeQtd+PUSx6TWfJova/serzBUxbtzZVhi1veQ6TiOvKEbk+n5wXgfojXh45b9zN2OidywhLJdaaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785766405; c=relaxed/simple;
	bh=ujnpg3IUJdKHbPodROYdLo96fGvUcNBz2bIfHas67iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRIxf0/HVDcbSQD2XtnJacwNlZVwn6tWUQnP+vRGBKTavRQvMcuIp85keeGn/D/VMUlYYqbNVQ6mCq0GOglI/6tjohkSiu/jjGtpOtEl+u+RklQzfpO6HriiteUKo+C66vSeNUDI+wy9dRRBseFkXtCOM+D89L750xk1ORSDFGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=csIBvS85; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="csIBvS85"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=0lLG0Kx6jbvYhMiZKtcn9+i8PVSWVGslUrLFYEEwz/4=;
	t=1785766403; x=1786976003; b=csIBvS85F5Ka2/zfY/36RV0OYmKsKa4h7gXfrnP4IpLkgZA
	TQYYRBbJ4AQ9LUd8XIqVi/0NG+AD4y/Qw9hFaQnZG26MqtfjwEYfW7K0H2fv8gWwgHSQZejvmrDhC
	PMRFtLL3JHOx2vkMFfLJpryAEVbz96LYkNSBo+VRiEotPts1k3cckmG703QxPOxiOsCqwoCzTWPn7
	e8AOIZGdvD7xFvMn6jFXqA6T/pv+qLyPFBZl82e800g7UiEXNgHq7v/hzkHvCSJ3ULhmT2BIAh/FC
	ir++neU2lNbn70XML6WfsCguH7GwaOuEzamE0cdgxr1JC4Txs0/FDan0DzfP6bhQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqtPq-0000000G4Ws-3xkP;
	Mon, 03 Aug 2026 16:13:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 6/7] wifi: mac80211: set flags/ctrl_flags before ieee80211_build_hdr()
Date: Mon,  3 Aug 2026 16:08:42 +0200
Message-ID: <20260803141309.292711-15-johannes@sipsolutions.net>
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

ieee80211_build_hdr() takes the info and control flags to use as
arguments, but that leads to some messy code and missed cleanup.
Fill them in the SKB before calling ieee80211_build_hdr().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 60 +++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cc0c6b46d19c..96261429a78d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2639,9 +2639,7 @@ static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
  * ieee80211_build_hdr - build 802.11 header in the given frame
  * @sdata: virtual interface to build the header for
  * @skb: the skb to build the header in
- * @info_flags: skb flags to set
  * @sta: the station pointer
- * @ctrl_flags: info control flags to set
  * @cookie: cookie pointer to fill (if not %NULL)
  *
  * This function takes the skb with 802.3 header and reformats the header to
@@ -2649,19 +2647,20 @@ static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
  * being transmitted on.
  *
  * Note that this function also takes care of the TX status request. The skb
- * must not be shared.
+ * must not be shared, and its TX info must already be initialised - this
+ * function only fills in what it determines itself.
  *
  * The function requires the read-side RCU lock held
  *
  * Returns: the (possibly reallocated) skb or an ERR_PTR() code
  */
 static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
-					   struct sk_buff *skb, u32 info_flags,
-					   struct sta_info *sta, u32 ctrl_flags,
+					   struct sk_buff *skb,
+					   struct sta_info *sta,
 					   u64 cookie)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_tx_info *info;
 	int head_need;
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
 	__le16 fc;
@@ -2677,14 +2676,15 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx_conf *chanctx_conf = NULL;
 	enum nl80211_band band;
 	int ret;
-	u8 link_id = u32_get_bits(ctrl_flags, IEEE80211_TX_CTRL_MLO_LINK);
+	u8 link_id = u32_get_bits(info->control.flags,
+				  IEEE80211_TX_CTRL_MLO_LINK);
 
 	if (IS_ERR(sta))
 		sta = NULL;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	if (local->force_tx_status)
-		info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+		info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 #endif
 
 	/* convert Ethernet header to proper 802.11 header (based on
@@ -2825,7 +2825,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		/* For injected frames, fill RA right away as nexthop lookup
 		 * will be skipped.
 		 */
-		if ((ctrl_flags & IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP) &&
+		if ((info->control.flags & IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP) &&
 		    is_zero_ether_addr(hdr.addr1))
 			memcpy(hdr.addr1, skb->data, ETH_ALEN);
 		break;
@@ -2956,7 +2956,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 	if (unlikely(!multicast &&
 		     (sk_requests_wifi_status(skb->sk) || cookie)))
-		info_id = ieee80211_store_ack_skb(local, skb, &info_flags,
+		info_id = ieee80211_store_ack_skb(local, skb, &info->flags,
 						  cookie);
 
 	hdr.frame_control = fc;
@@ -3027,10 +3027,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 	skb_reset_mac_header(skb);
 
-	info = IEEE80211_SKB_CB(skb);
-	memset(info, 0, sizeof(*info));
-
-	info->flags = info_flags;
 	if (info_id) {
 		info->status_data = info_id;
 		info->status_data_idr = 1;
@@ -3038,18 +3034,18 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	info->band = band;
 
 	if (likely(!cookie)) {
-		ctrl_flags |= u32_encode_bits(link_id,
-					      IEEE80211_TX_CTRL_MLO_LINK);
+		info->control.flags |=
+			u32_encode_bits(link_id, IEEE80211_TX_CTRL_MLO_LINK);
 	} else {
 		unsigned int pre_conf_link_id;
 
 		/*
-		 * ctrl_flags already have been set by
+		 * The link ID already has been set by
 		 * ieee80211_tx_control_port(), here
 		 * we just sanity check that
 		 */
 
-		pre_conf_link_id = u32_get_bits(ctrl_flags,
+		pre_conf_link_id = u32_get_bits(info->control.flags,
 						IEEE80211_TX_CTRL_MLO_LINK);
 
 		if (pre_conf_link_id != link_id &&
@@ -3064,8 +3060,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	info->control.flags = ctrl_flags;
-
 	return skb;
  free:
 	if (info_id)
@@ -4372,6 +4366,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_tx_info *info;
 	struct sta_info *sta;
 	struct sk_buff *next;
 	int len = skb->len;
@@ -4431,8 +4426,12 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 			goto out;
 		}
 
-		skb = ieee80211_build_hdr(sdata, skb, info_flags,
-					  sta, ctrl_flags, 0);
+		info = IEEE80211_SKB_CB(skb);
+		memset(info, 0, sizeof(*info));
+		info->flags = info_flags;
+		info->control.flags = ctrl_flags;
+
+		skb = ieee80211_build_hdr(sdata, skb, sta, 0);
 		if (IS_ERR(skb)) {
 			kfree_skb_list(next);
 			goto out;
@@ -4901,6 +4900,7 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 		.local = sdata->local,
 		.sdata = sdata,
 	};
+	struct ieee80211_tx_info *info;
 	struct sta_info *sta;
 
 	rcu_read_lock();
@@ -4911,8 +4911,12 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta,
-				  IEEE80211_TX_CTRL_MLO_LINK_UNSPEC, 0);
+	info = IEEE80211_SKB_CB(skb);
+	memset(info, 0, sizeof(*info));
+	info->flags = info_flags;
+	info->control.flags = IEEE80211_TX_CTRL_MLO_LINK_UNSPEC;
+
+	skb = ieee80211_build_hdr(sdata, skb, sta, 0);
 	if (IS_ERR(skb))
 		goto out;
 
@@ -6532,6 +6536,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_tx_info *info;
 	struct sta_info *sta;
 	struct sk_buff *skb;
 	struct ethhdr *ehdr;
@@ -6623,7 +6628,12 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	if (sta && sta->sta.mlo)
 		memcpy(ehdr->h_source, sdata->vif.addr, ETH_ALEN);
 
-	skb = ieee80211_build_hdr(sdata, skb, flags, sta, ctrl_flags, cookie);
+	info = IEEE80211_SKB_CB(skb);
+	memset(info, 0, sizeof(*info));
+	info->flags = flags;
+	info->control.flags = ctrl_flags;
+
+	skb = ieee80211_build_hdr(sdata, skb, sta, cookie);
 	if (IS_ERR(skb)) {
 		rcu_read_unlock();
 		return PTR_ERR(skb);
-- 
2.55.0

