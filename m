Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81DF48AE06
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372281; cv=none; b=Mgsw5MvfzuxYzB+Bw2bqrQp/slTv0QwGEbK0icH8LlCThQ1xWqJwDAyjJjx/lj3SJPtWYgBzU6jKiyEAlMjBNdluon7RDFbeF87d6j6dwjwZg3zqJgYCTQp4pSnXbjIZ1ZKfFyuiBgf2OuIEmZzta3j5pqFfKqn7Jv3PCTvOQio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372281; c=relaxed/simple;
	bh=p2xSEWt4QoDZgHC3SpM8+pnGmMBliHPCJrKDNf8p2eI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmpsDRxY/McfzdJR/hxH2uAr6AoZ1aPCUu9P0NfuwYzxC4og5spve9CHH2hO2226hyxD4J7uSArgig1KJnFVsxafgFIcQ1zMOIqjNCjVukAWV82jXgSp4xk4oAtkuVKmAAJUu7ETPwueuq9FsMBebPZl/E8egyFHY6VtfYF88XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=JjQnSWc6; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="JjQnSWc6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aBE7YQuGorDI+ZHlAZ7l4KcvkjKErSiIXbkTUT+wYFg=; b=JjQnSWc6nW1tW5A1Pzx9Roffp5
	5GIdHGRhByDJPPyDVudnYkeBa89PnEOAqDF+9B4qGOYZTyvXOqEW7hksZycByEpn+fAIkC8fnYneC
	oVWIYxvY0b9izTuPFqqtyw3KJBSGVvs2rR8P8aPqkCaRGjhnvW1HQpyT4pxrc8fsaW2g=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xEPl1-00HY5A-2O
	for linux-wireless@vger.kernel.org;
	Wed, 07 Oct 2026 13:24:23 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 6/9] wifi: mt76: mt7996: take the offchannel link of a frame from its wcid
Date: Wed,  7 Oct 2026 13:24:16 +0200
Message-ID: <20261007112419.1277594-6-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007112419.1277594-1-nbd@nbd.name>
References: <20261007112419.1277594-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_mac_write_txwi() and mt7996_tx_prepare_skb() take the own MAC,
WMM and band index of an offchannel frame from mvif->offchannel_link,
which holds one link per vif. mac80211 runs one scan or remain on
channel at a time, so a vif has at most one offchannel link today. A
scan that runs on several radios at the same time needs one offchannel
link per radio, and its frames would then be sent with the indexes of
whichever link was added last.

Each offchannel link has its own wcid, and offchannel frames are sent
on it, so take the link from the wcid of the frame. Drop
offchannel_link, which has no other user.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/channel.c       |  5 -----
 drivers/net/wireless/mediatek/mt76/mt76.h          |  1 -
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h | 12 ++++++++++++
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 243d252e7644..75f0db3bc4f0 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -295,7 +295,6 @@ struct mt76_vif_link *mt76_get_vif_phy_link(struct mt76_phy *phy,
 		kfree(mlink);
 		return ERR_PTR(ret);
 	}
-	rcu_assign_pointer(mvif->offchannel_link, mlink);
 
 	return mlink;
 }
@@ -304,14 +303,10 @@ void mt76_put_vif_phy_link(struct mt76_phy *phy, struct ieee80211_vif *vif,
 			   struct mt76_vif_link *mlink)
 {
 	struct mt76_dev *dev = phy->dev;
-	struct mt76_vif_data *mvif;
 
 	if (IS_ERR_OR_NULL(mlink) || !mlink->offchannel)
 		return;
 
-	mvif = mlink->mvif;
-
-	rcu_assign_pointer(mvif->offchannel_link, NULL);
 	dev->drv->vif_link_remove(phy, vif, &vif->bss_conf, mlink);
 	kfree_rcu(mlink, rcu_head);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 93576472f5af..09b9507250f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -846,7 +846,6 @@ struct mt76_vif_link {
 
 struct mt76_vif_data {
 	struct mt76_vif_link __rcu *link[IEEE80211_MLD_MAX_NUM_LINKS];
-	struct mt76_vif_link __rcu *offchannel_link;
 
 	struct mt76_phy *roc_phy;
 	u16 valid_links;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index ce1e4773bddd..f36da545045b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -915,7 +915,7 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 	mvif = vif ? (struct mt7996_vif *)vif->drv_priv : NULL;
 	if (mvif) {
 		if (wcid->offchannel)
-			mlink = rcu_dereference(mvif->mt76.offchannel_link);
+			mlink = mt7996_offchannel_link(wcid);
 		if (!mlink && link_id != IEEE80211_LINK_UNSPECIFIED)
 			mlink = rcu_dereference(mvif->mt76.link[link_id]);
 	}
@@ -1196,7 +1196,7 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 
 		if (mvif) {
 			if (wcid->offchannel)
-				mlink = rcu_dereference(mvif->mt76.offchannel_link);
+				mlink = mt7996_offchannel_link(wcid);
 			if (!mlink)
 				mlink = rcu_dereference(mvif->mt76.link[wcid->link_id]);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index ae97ca091673..da9958647b54 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -659,6 +659,18 @@ mt7996_vif_conf_link(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 							    link_conf);
 }
 
+static inline struct mt76_vif_link *
+mt7996_offchannel_link(struct mt76_wcid *wcid)
+{
+	struct mt7996_sta_link *msta_link;
+	struct mt7996_vif_link *link;
+
+	msta_link = container_of(wcid, struct mt7996_sta_link, wcid);
+	link = container_of(msta_link, struct mt7996_vif_link, msta_link);
+
+	return &link->mt76;
+}
+
 static inline struct mt7996_sta_link *
 mt7996_sta_link(struct mt7996_sta *msta, u8 link_id)
 {
-- 
2.47.3

