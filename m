Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190256;
	b=riqhIlQq+kGvA1M5J1n9HX94gTDI/51gxYzvemR67AnpdTcsnyfDDwOMatrH+EIKZ9DL
	 o4n8erNvACXHyXWQeQobqvlaoTNQBbG6RMsbAXbP/XXQ91/SFX+Xb6m/3SUzeIJxrH0Ws
	 h4E7NzvKJw7f5wxYy0sJAOlmCwk/kdvC34C1NjpWhuzq9IdsPrSphLYnqKUMpd342LU/i
	 BAqUrMR/XI2VHIIelNWimgnWzaQ4DXYpiPsWdjRwfmhYPU8qFel4gaWxMnrHAJ84ZvhLo
	 +R967hvtZAFjxW8ZD5Np2B8XKxwo9j0OOHwUR7XRLOO1BZUR2sNlHCDXuob1JnDEjKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9V/cFcr3TiGVLPMnEtDVgT1RmzrlCvBByD2dZrb3/uE=;
	b=nRB3l1v37vYYbCYZAuYex1x9STkYwX+bS0FGcUC8kffWX24ztqgLs1p5XyXHV7iviRuu
	 hbzgpwHVHd0dbAOV882clryA4Hf9qDZczVuP127I5eTaXhgmPzH/RvKeZFWbtQGRSug2j
	 kigDcDsMWcjTuVbSkdY+r9dzmKEpsPNbt0X7HD7/iB7nC0viKwdLnGeSZnrEIFnSOfGiY
	 YKRsHHZGrm3n1cvLhyli7EriTgVgg5RHLzvxo5AKA+hUt6/8NJ4/b7Azp4bFL0y1eFYqw
	 2ikiuvD5/RNXTpExkWxG2bjO+ef2Tj+mHLL3/TImpa6O138PqhVtD7eL9KhEra/NUrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=O7ozGCQH;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABEB606A32F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3ABEB606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=O7ozGCQH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9V/cFcr3TiGVLPMnEtDVgT1RmzrlCvBByD2dZrb3/uE=; b=O7ozGCQHrAfjqP10yyc86BIHFp
	g85TIKooU4JYyH2tN61QwZCBpotiK1PdNN2/LFpa7DElZLnZB0id/t47sSpo1kCS2QyQAx/5LebjC
	LUlrqhLyxa0dnsG0ufRWOFgeirfv8y/kJQBt5tngHxjV2aTndyUf6euwbAB1BnB34LMM=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hL-00C8Bw-20
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:07 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 09/25] wifi: mt76: mt7996: factor the vif link teardown out of remove_interface
Date: Wed, 28 Oct 2026 13:23:47 +0100
Message-ID: <20261028122403.796394-9-nbd@nbd.name>
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

Move the loop that destroys the links of a vif out of
mt7996_remove_interface() into a helper that takes the links to destroy
and, optionally, their link confs. A following change destroys station
links when the vif leaves MLO, where mac80211 still passes the old link
confs.

No functional change.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 47 +++++++++++--------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 3a3441951254..cc8ce83f8b2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -471,6 +471,33 @@ static void mt7996_vif_link_destroy(struct mt7996_phy *phy,
 	}
 }
 
+static void
+mt7996_vif_links_destroy(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+			 unsigned long links,
+			 struct ieee80211_bss_conf **link_confs)
+{
+	unsigned int link_id;
+
+	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct ieee80211_bss_conf *link_conf = NULL;
+		struct mt7996_vif_link *link;
+		struct mt7996_phy *phy;
+
+		link = mt7996_vif_link(dev, vif, link_id);
+		if (!link)
+			continue;
+
+		phy = __mt7996_phy(dev, link->msta_link.wcid.phy_idx);
+		if (!phy)
+			continue;
+
+		if (link_confs)
+			link_conf = link_confs[link_id];
+
+		mt7996_vif_link_destroy(phy, link, vif, link_conf);
+	}
+}
+
 void mt7996_vif_link_remove(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 			    struct ieee80211_bss_conf *link_conf,
 			    struct mt76_vif_link *mlink)
@@ -640,30 +667,12 @@ static void mt7996_remove_interface(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif)
 {
 	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
-	unsigned long rem_links = mvif->mt76.valid_links;
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
 	struct mt7996_radio_data rdata = {};
-	unsigned int link_id;
 	int i;
 
 	mutex_lock(&dev->mt76.mutex);
-
-	/* Remove all active links */
-	for_each_set_bit(link_id, &rem_links, IEEE80211_MLD_MAX_NUM_LINKS) {
-		struct mt7996_vif_link *link;
-		struct mt7996_phy *phy;
-
-		link = mt7996_vif_link(dev, vif, link_id);
-		if (!link)
-			continue;
-
-		phy = __mt7996_phy(dev, link->msta_link.wcid.phy_idx);
-		if (!phy)
-			continue;
-
-		mt7996_vif_link_destroy(phy, link, vif, NULL);
-	}
-
+	mt7996_vif_links_destroy(dev, vif, mvif->mt76.valid_links, NULL);
 	mutex_unlock(&dev->mt76.mutex);
 
 	ieee80211_iterate_active_interfaces_mtx(hw, 0, mt7996_remove_iter,
-- 
2.47.3

