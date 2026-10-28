Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190256;
	b=qXZzDOioO6OlJ+T0I6poni0x41qeAvRS1X9+bUdfTZp66Cp90KNQwkvIIZDb/6ll/fjK
	 KMnncHZ2wInoLCA2m4c5Na30yqKMwm//QDcw0Ymneo/NMzEmpxHmDF7om2xYHnflBpg/S
	 u+z8QfxEpIoml1ixDceTQHl1++hvWerPPlKrhIkRw5q9Zo1Jo9N7k4iXs0xjZxmoWS3R9
	 JJgz8RifX2iyAkBO+ZRECNj0bAdf+Q8mfukCY9OxAKsomb346RMRVRm7PKF6s5AmN074G
	 oXmVOEfXSJd5VUj1uS6U8WOugZRLoFjVTCtwFDl6zopv5SstTegunDIpbUXD27yRgpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZJA692AXyZ6mHi7Bfn3OfmoLZZB5CkyYUbjCrdcDVKg=;
	b=ij2uSP5OAMyLxmS4FfIgPcFPE2/fvWmg6MDkikze1slz5SiMECF8jvtBlJJScb5zeDc8
	 a7jZwyGaTAeHUVJrPBrSCtFP24E+RFFQppY+a2DZjIkoBxWF8NWmkOtVDZkkrb9jC11BI
	 G9lRPNXV0XZ7Y4fkMslmNtBUFa7bZ/nEEoWANJOjrS9Vzd0LnA8ngcZ7NYnld+OwK9EWu
	 iW+7qgHXqomEYUYwvAyHfU0/yU7hqb+1dWZcket9qpk1ihW5lL37QWyJDS1hCldvOvntt
	 L+Tygm6nWJGHQiREfpTZamSkTvyQQJ1CfiGw+CyBhoO786gqmAeNSkD4M52WEHCZaFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b="Q9JFE/3s";
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C7260A260A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21C7260A260A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Q9JFE/3s
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZJA692AXyZ6mHi7Bfn3OfmoLZZB5CkyYUbjCrdcDVKg=; b=Q9JFE/3sn5I/cJOzkGqDEdks2N
	kpXCLcancSGLFXY1MJfXoBQDA0seYwHHMYBn8GKS/WeX32/ZtM+Q5vejd5Ag6HpZi3coM8T4AYfVO
	CdTd373I48LhLHlJCIruIH3f2SN8+C/RMWXu+Gwdhm8lK4kMtBpQK1HeLtelpFNeRwq4=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hL-00C8Bw-2b;
	Wed, 28 Oct 2026 13:24:07 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: Shayne Chen <shayne.chen@mediatek.com>
Subject: [PATCH mt76-next 10/25] wifi: mt76: mt7996: destroy station links before the MLD group is freed
Date: Wed, 28 Oct 2026 13:23:48 +0100
Message-ID: <20261028122403.796394-10-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028122403.796394-1-nbd@nbd.name>
References: <20261028122403.796394-1-nbd@nbd.name>
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

Since the link teardown moved to mt7996_remove_interface(), a station
link stays in the firmware after its chanctx is unassigned. When the
links of the vif go to 0, mt7996_change_vif_links() frees the MLD group
and remap index in the driver, while the firmware BSS of each link
still names them. The firmware has no MLD link removal for a station
link, so the next vif that takes the same index shares it with a stale
BSS until the station vif is removed. That removal then uses
&vif->bss_conf instead of the link conf.

Destroy the station links when the vif leaves MLO, with the link confs
that mac80211 passes, and before the indexes are freed. mac80211
releases the chanctx of each removed link before it calls the driver,
so all links of the vif are unassigned at this point. AP links are not
affected: they leave their group at unassign through the MLD link
operation. First abort a remain-on-channel that holds one of the
destroyed links, since mt76_unassign_vif_chanctx() aborts only a scan
and mac80211 ends a remain-on-channel only when the interface stops.

Fixes: 08813703ac41 ("wifi: mt76: mt7996: Destroy vif active links in mt7996_remove_interface()")
Co-developed-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index cc8ce83f8b2d..1ca4d9e099fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -2995,6 +2995,26 @@ mt7996_net_setup_tc(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 #endif
 
+static void
+mt7996_vif_link_roc_abort(struct mt7996_dev *dev, struct ieee80211_vif *vif)
+{
+	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+	struct mt76_phy *phy = mvif->mt76.roc_phy;
+	struct mt76_vif_link *mlink;
+	bool abort;
+
+	if (!phy)
+		return;
+
+	mutex_lock(&dev->mt76.mutex);
+	mlink = phy->roc_link;
+	abort = phy->roc_vif == vif && mlink && !mlink->offchannel;
+	mutex_unlock(&dev->mt76.mutex);
+
+	if (abort)
+		mt76_abort_roc(phy);
+}
+
 static int
 mt7996_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			u16 old_links, u16 new_links,
@@ -3002,8 +3022,15 @@ mt7996_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
 	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+	bool sta_links_destroy;
 	int ret = 0;
 
+	sta_links_destroy = !vif->valid_links &&
+			    vif->type == NL80211_IFTYPE_STATION;
+	/* a ROC can hold a station link that is destroyed below */
+	if (sta_links_destroy)
+		mt7996_vif_link_roc_abort(dev, vif);
+
 	mutex_lock(&dev->mt76.mutex);
 
 	if (!old_links) {
@@ -3030,6 +3057,13 @@ mt7996_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (new_links)
 		goto out;
 
+	/* the firmware supports no MLD link removal for a station link, so
+	 * remove its BSS before the group and remap index can be reused
+	 */
+	if (sta_links_destroy)
+		mt7996_vif_links_destroy(dev, vif, mvif->mt76.valid_links,
+					 old);
+
 	dev->mld_idx_mask &= ~BIT_ULL(mvif->mld_group_idx);
 	dev->mld_remap_idx_mask &= ~BIT_ULL(mvif->mld_remap_idx);
 
-- 
2.47.3

