Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B6430E85B
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 10:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790765388; cv=none; b=WpZMR2u31W58LFfpNgmOQJevUNI2Jiu+l+8KeP2033Hd3vVioukc77hbxJBWct7SIEeJ4Ya59FZJPoTdmUTA3vcW4bEoNNtA/xk5usapEcDIyMykhJl5/MooSzzuBRkc+GAsapSxIDGliEsXjqXhkDrVAq+4v1uJO8CddDKj6D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790765388; c=relaxed/simple;
	bh=i7CM2ARpFzfLKfuTqCEpLuP6YBi9wOMZhAEg1TWonF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FSclXxL3WaCU71XiG/CDu0aO89O93j5U8CdtyuSuMe26tUHmM7L6Zrc4r0a/2aOouTX1Z2qc0GhW5qLwML5AO9FMHnm39F35qku1IULumEt+6IprOB1TNMDkVaAoJZwY56eVPY6sSGdbg0Znb1GHo1cExrTgNpYFjgLb3iX3CCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=uHCNTjQN; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="uHCNTjQN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nEtez6mVnxfzf/pdPpgHSX7vp+vinZoQ5HX09yhRC4M=; b=uHCNTjQNzKDGBaPjMl6vzwqzUx
	lO8yl/DPPSF9DSYzLS7WEWe6XVZAKj3t6eqWJbi5P6pqFeHxm4716IdKoJ9wUaPZzvlF/1qm6EkBp
	KUquTZJIki6+Yl/vJg631iFa5M8GkE/vvcuPeXOYoU/hFphas8NZtfVXCgRYExDU788w=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xBrsY-00DUx8-0l;
	Wed, 30 Sep 2026 12:49:38 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 1/2] wifi: mac80211_hwsim: report the TX link of frames sent via wmediumd
Date: Wed, 30 Sep 2026 12:49:35 +0200
Message-ID: <20260930104936.3180629-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit f15350104130 ("wifi: mac80211_hwsim: report TX status
link_id"), hwsim_tx_info_frame_received_nl() passes txi->control.vif to
mac80211_hwsim_get_link_id(). It does so after
ieee80211_tx_info_clear_status(), which zeroes that field, and
mac80211_hwsim_tx_frame_nl() already stored the frame cookie in the
same memory. The lookup thus never finds a link, and a TX status from
wmediumd or virtio never carries a link ID.

Look up the link when the frame is handed to wmediumd, and keep it with
the cookie in the driver data of the frame.

Fixes: f15350104130 ("wifi: mac80211_hwsim: report TX status link_id")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../wireless/virtual/mac80211_hwsim_main.c    | 79 ++++++++++++-------
 1 file changed, 51 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index c98c862678a2..2fb18a3c0667 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1643,6 +1643,45 @@ static void mac80211_hwsim_write_tsf(struct mac80211_hwsim_data *data,
 	spin_unlock_bh(&data->tsf_offset_lock);
 }
 
+struct hwsim_tx_cb {
+	int cookie;
+	s8 link_id;
+};
+
+static struct hwsim_tx_cb *hwsim_tx_cb(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	BUILD_BUG_ON(sizeof(struct hwsim_tx_cb) >
+		     sizeof(info->rate_driver_data));
+	return (void *)info->rate_driver_data;
+}
+
+static int mac80211_hwsim_get_link_id(struct ieee80211_vif *vif,
+				      struct ieee80211_hdr *hdr)
+{
+	int i, link_id = -1;
+
+	if (!vif || !ieee80211_vif_is_mld(vif))
+		return -1;
+
+	rcu_read_lock();
+	for (i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
+		struct ieee80211_bss_conf *link_conf;
+
+		link_conf = rcu_dereference(vif->link_conf[i]);
+		if (!link_conf)
+			continue;
+		if (ether_addr_equal(link_conf->addr, hdr->addr2)) {
+			link_id = i;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return link_id;
+}
+
 static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 				       struct sk_buff *my_skb,
 				       int dst_portid,
@@ -1652,6 +1691,8 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	struct mac80211_hwsim_data *data = hw->priv;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) my_skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(my_skb);
+	struct hwsim_tx_cb *cb;
+	int link_id;
 	void *msg_head;
 	unsigned int hwsim_flags = 0;
 	int i;
@@ -1729,9 +1770,13 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 		    tx_attempts_flags))
 		goto nla_put_failure;
 
+	link_id = mac80211_hwsim_get_link_id(info->control.vif, hdr);
+
 	/* We create a cookie to identify this skb */
 	cookie = atomic_inc_return(&data->pending_cookie);
-	info->rate_driver_data[0] = (void *)cookie;
+	cb = hwsim_tx_cb(my_skb);
+	cb->cookie = cookie;
+	cb->link_id = link_id;
 	if (nla_put_u64_64bit(skb, HWSIM_ATTR_COOKIE, cookie, HWSIM_ATTR_PAD))
 		goto nla_put_failure;
 
@@ -6361,27 +6406,6 @@ static void hwsim_register_wmediumd(struct net *net, u32 portid)
 	spin_unlock_bh(&hwsim_radio_lock);
 }
 
-static int mac80211_hwsim_get_link_id(struct ieee80211_vif *vif,
-				      struct ieee80211_hdr *hdr)
-{
-	int i;
-
-	if (!vif || !ieee80211_vif_is_mld(vif))
-		return -1;
-
-	for (i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
-		struct ieee80211_bss_conf *link_conf;
-
-		link_conf = rcu_dereference(vif->link_conf[i]);
-		if (!link_conf)
-			continue;
-		if (ether_addr_equal(link_conf->addr, hdr->addr2))
-			return i;
-	}
-
-	return -1;
-}
-
 static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 					   struct genl_info *info)
 {
@@ -6394,7 +6418,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	struct sk_buff *skb, *tmp;
 	const u8 *src;
 	unsigned int hwsim_flags;
-	int i;
+	int i, link_id;
 	unsigned long flags;
 	bool found = false;
 
@@ -6427,8 +6451,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	skb_queue_walk_safe(&data2->pending, skb, tmp) {
 		uintptr_t skb_cookie;
 
-		txi = IEEE80211_SKB_CB(skb);
-		skb_cookie = (uintptr_t)txi->rate_driver_data[0];
+		skb_cookie = (uintptr_t)hwsim_tx_cb(skb)->cookie;
 
 		if (skb_cookie == ret_skb_cookie) {
 			__skb_unlink(skb, &data2->pending);
@@ -6452,6 +6475,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 
 	/* now send back TX status */
 	txi = IEEE80211_SKB_CB(skb);
+	link_id = hwsim_tx_cb(skb)->link_id;
 
 	ieee80211_tx_info_clear_status(txi);
 
@@ -6463,10 +6487,9 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	txi->status.ack_signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	hdr = (struct ieee80211_hdr *)skb->data;
-	i = mac80211_hwsim_get_link_id(txi->control.vif, hdr);
-	if (i >= 0) {
+	if (link_id >= 0) {
 		txi->status.link_valid = 1;
-		txi->status.link_id = i;
+		txi->status.link_id = link_id;
 	}
 
 	if (!(hwsim_flags & HWSIM_TX_CTL_NO_ACK) &&
-- 
2.47.3

