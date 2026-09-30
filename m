Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5078C4A2633
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 10:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790765395; cv=none; b=AOL1EheRt2BL7bhg+HZLoSzNDU3ZoX/Y49Ig9aDq/aKicL9RxjMiN+RLSh0ec25oEtbPQAuLl/LsSaBmFwBVJXSPqPeF60p/MUohZHDYTeG6QQLGyI/GT0GUGWa68DVOAXuqvhS+psauFZDTX75OQ0vIJE0odzXCX/omaQxFXic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790765395; c=relaxed/simple;
	bh=iJgdRrWv0oi+TDI6oBoOSmBNi3KM1l8+aTwXNG+Lfhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuHfd7vWf6wndxVQMDx0WtqJwTIwFSM9+WNURkyurraNHBCD30tpgoFHzsutHA3oo67SKXAd6fZkYUizJjv+opRX5rvY6UrZ6RRijR9bXBgNzwwlUi7ofrGVo0QibENs9Nz9QJ8H7gUPN0CJKoV58Gw8U+dQ84GZVrCuDFwtnWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=ZFH8vbgc; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ZFH8vbgc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uqrdEpnk/fdzy7NW5eYel+Qfm/SK9bnEU9DpBunjoYw=; b=ZFH8vbgcrl27/3vTrwgbOtApd7
	L8ySSRypXoQQPCZSspFobto3+1geis8EZpry6HXO/musQvLYYQ/TQmmTXlnumrsrfKs8WMXQB+v/8
	0Rn2+t54X/rC6ChY1aYnKZl+gB8RcBQHvHZKsEESQR4MAmSoq+Z9mZ46odnlcnAUMuvw=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xBrsY-00DUx8-1Q;
	Wed, 30 Sep 2026 12:49:38 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 2/2] wifi: mac80211_hwsim: restore MLD addresses before reporting TX status
Date: Wed, 30 Sep 2026 12:49:36 +0200
Message-ID: <20260930104936.3180629-2-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260930104936.3180629-1-nbd@nbd.name>
References: <20260930104936.3180629-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a frame to an MLO station, mac80211_hwsim_tx() rewrites A1, A2 and
possibly A3 of the frame to link addresses, and then reports the TX
status on the same skb. ieee80211_tx_status_skb() looks up the station
by A1 and A2, which are now link addresses, and finds none. mac80211
then records no ACK, retry, lost frame or last TX rate for the station.

Put the original addresses back before the TX status is reported. For
frames sent via wmediumd, keep them in the driver data of the frame
until the status arrives. An all-zero A1 marks a frame without rewrite.

Fixes: 2ab60f49eb4d ("wifi: mac80211_hwsim: use MLO link ID for TX")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../wireless/virtual/mac80211_hwsim_main.c    | 37 +++++++++++++++----
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 2fb18a3c0667..58d7a023392d 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1645,6 +1645,7 @@ static void mac80211_hwsim_write_tsf(struct mac80211_hwsim_data *data,
 
 struct hwsim_tx_cb {
 	int cookie;
+	u8 orig_addrs[sizeof_field(struct ieee80211_hdr, addrs)];
 	s8 link_id;
 };
 
@@ -1657,6 +1658,16 @@ static struct hwsim_tx_cb *hwsim_tx_cb(struct sk_buff *skb)
 	return (void *)info->rate_driver_data;
 }
 
+static void hwsim_tx_addrs_restore(struct sk_buff *skb, const u8 *orig_addrs)
+{
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+
+	if (is_zero_ether_addr(orig_addrs))
+		return;
+
+	memcpy(&hdr->addrs, orig_addrs, sizeof(hdr->addrs));
+}
+
 static int mac80211_hwsim_get_link_id(struct ieee80211_vif *vif,
 				      struct ieee80211_hdr *hdr)
 {
@@ -1685,7 +1696,8 @@ static int mac80211_hwsim_get_link_id(struct ieee80211_vif *vif,
 static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 				       struct sk_buff *my_skb,
 				       int dst_portid,
-				       struct ieee80211_channel *channel)
+				       struct ieee80211_channel *channel,
+				       const u8 *orig_addrs)
 {
 	struct sk_buff *skb;
 	struct mac80211_hwsim_data *data = hw->priv;
@@ -1777,6 +1789,10 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	cb = hwsim_tx_cb(my_skb);
 	cb->cookie = cookie;
 	cb->link_id = link_id;
+	if (orig_addrs)
+		memcpy(cb->orig_addrs, orig_addrs, sizeof(cb->orig_addrs));
+	else
+		memset(cb->orig_addrs, 0, sizeof(cb->orig_addrs));
 	if (nla_put_u64_64bit(skb, HWSIM_ATTR_COOKIE, cookie, HWSIM_ATTR_PAD))
 		goto nla_put_failure;
 
@@ -2152,6 +2168,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	struct ieee80211_tx_info *txi = IEEE80211_SKB_CB(skb);
+	u8 orig_addrs[sizeof_field(struct ieee80211_hdr, addrs)] = {};
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *channel;
@@ -2239,6 +2256,8 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 		 * probe response).
 		 */
 		if (sta && sta->mlo && link_sta) {
+			memcpy(orig_addrs, &hdr->addrs, sizeof(orig_addrs));
+
 			/* address translation to link addresses on TX */
 			ether_addr_copy(hdr->addr1, link_sta->addr);
 			ether_addr_copy(hdr->addr2, bss_conf->addr);
@@ -2313,7 +2332,8 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	_portid = READ_ONCE(data->wmediumd);
 
 	if (_portid || hwsim_virtio_enabled)
-		return mac80211_hwsim_tx_frame_nl(hw, skb, _portid, channel);
+		return mac80211_hwsim_tx_frame_nl(hw, skb, _portid, channel,
+						  orig_addrs);
 
 	/* NO wmediumd detected, perfect medium simulation */
 	data->tx_pkts++;
@@ -2323,6 +2343,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	if (ack && skb->len >= 16)
 		mac80211_hwsim_monitor_ack(channel, hdr->addr2);
 
+	hwsim_tx_addrs_restore(skb, orig_addrs);
 	ieee80211_tx_info_clear_status(txi);
 
 	/* frame was transmitted at most favorable rate at first attempt */
@@ -2471,7 +2492,7 @@ void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 	}
 
 	if (_portid || hwsim_virtio_enabled)
-		return mac80211_hwsim_tx_frame_nl(hw, skb, _portid, chan);
+		return mac80211_hwsim_tx_frame_nl(hw, skb, _portid, chan, NULL);
 
 	data->tx_pkts++;
 	data->tx_bytes += skb->len;
@@ -6417,8 +6438,9 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	u64 ret_skb_cookie;
 	struct sk_buff *skb, *tmp;
 	const u8 *src;
+	struct hwsim_tx_cb tx_cb;
 	unsigned int hwsim_flags;
-	int i, link_id;
+	int i;
 	unsigned long flags;
 	bool found = false;
 
@@ -6475,7 +6497,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 
 	/* now send back TX status */
 	txi = IEEE80211_SKB_CB(skb);
-	link_id = hwsim_tx_cb(skb)->link_id;
+	tx_cb = *hwsim_tx_cb(skb);
 
 	ieee80211_tx_info_clear_status(txi);
 
@@ -6487,9 +6509,9 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	txi->status.ack_signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	hdr = (struct ieee80211_hdr *)skb->data;
-	if (link_id >= 0) {
+	if (tx_cb.link_id >= 0) {
 		txi->status.link_valid = 1;
-		txi->status.link_id = link_id;
+		txi->status.link_id = tx_cb.link_id;
 	}
 
 	if (!(hwsim_flags & HWSIM_TX_CTL_NO_ACK) &&
@@ -6503,6 +6525,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	if (hwsim_flags & HWSIM_TX_CTL_NO_ACK)
 		txi->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
 
+	hwsim_tx_addrs_restore(skb, tx_cb.orig_addrs);
 	ieee80211_tx_status_irqsafe(data2->hw, skb);
 	return 0;
 out:
-- 
2.47.3

