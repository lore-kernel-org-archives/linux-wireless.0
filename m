Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5722940862D
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164694; cv=none; b=dwr3c1UgtZleGjyr1T4HzvE0OhfmllI7pYEQr8a7elAPbi9P3aBigM+yYD/admSXeM0qKCpbz+j8zZGdSKyCuItJpuFqMTDCO+TWbVo9ISMWDT6PX0AH/VUj0CYoo+NKt97ipoS8eko2LNrrXPek4zWaTtKib9LEoL1aarqgvsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164694; c=relaxed/simple;
	bh=3fhMInGZ6rzm3YKe1fdc5mEixkf89Qhv20ZX6BJuEmI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbcNV2qrrzwjk8hDKpCj/BaCbtwT4/sidy+xyq1aV/dU6HCvLtAok4R71LRNhFo+WB/xkHHQPh4B4CsIq9c+oe7d1Fz+C6HRIfjPra62Oti6cP0Gz8KMmgVgblCfy2oyeVUMEhG+Kxu6/SZy0cfQ2cKkZKibIzjpL5zOpAxLOD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=GNRal+SQ; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="GNRal+SQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=t7L+7AnWlddLXcvMD+wS+9UPFESNdZwkgO39o2nC/OE=; b=GNRal+SQZwGwBlaxWq8dMKKHq2
	Ae2T3XgWUpqw7ol3hgpPgBAmsQT1U1KeJ6lVCxQCnYhwpBdvkAKmZpOmhxO2TNQ3hfw0RP3uZtYvw
	mRui7V6wS1Wl+caolM+lVfuLeQncuUtxRIVK1Qai+EywAq8kmkfZYwy5c8RdmPmPHwWE=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsl-008KN0-04
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:43 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 10/15] wifi: mt76: mt7996: remove repeater muar config
Date: Mon, 27 Jul 2026 15:04:29 +0000
Message-ID: <20260727150434.1778520-10-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727150434.1778520-1-nbd@nbd.name>
References: <20260727150434.1778520-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

Repeater mode is not supported currently, so remove it.
get_omac_idx() only hands out HW_BSSID/EXT_BSSID indices, so the
omac_idx >= REPEATER_BSSID_START call sites are unreachable.

Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 45 -------------------
 1 file changed, 45 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 57117ce69cbb..dcffb61a4d27 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1042,43 +1042,6 @@ mt7996_mcu_bss_sec_tlv(struct sk_buff *skb, struct mt76_vif_link *mlink)
 	sec->cipher = mlink->cipher;
 }
 
-static int
-mt7996_mcu_muar_config(struct mt7996_dev *dev, struct mt76_vif_link *mlink,
-		       const u8 *addr, bool bssid, bool enable)
-{
-#define UNI_MUAR_ENTRY 2
-	u32 idx = mlink->omac_idx - REPEATER_BSSID_START;
-	struct {
-		struct {
-			u8 band;
-			u8 __rsv[3];
-		} hdr;
-
-		__le16 tag;
-		__le16 len;
-
-		bool smesh;
-		u8 bssid;
-		u8 index;
-		u8 entry_add;
-		u8 addr[ETH_ALEN];
-		u8 __rsv[2];
-	} __packed req = {
-		.hdr.band = mlink->band_idx,
-		.tag = cpu_to_le16(UNI_MUAR_ENTRY),
-		.len = cpu_to_le16(sizeof(req) - sizeof(req.hdr)),
-		.smesh = false,
-		.index = idx * 2 + bssid,
-		.entry_add = true,
-	};
-
-	if (enable)
-		memcpy(req.addr, addr, ETH_ALEN);
-
-	return mt76_mcu_send_msg(&dev->mt76, MCU_WM_UNI_CMD(REPT_MUAR), &req,
-				 sizeof(req), true);
-}
-
 static void
 mt7996_mcu_bss_ifs_timing_tlv(struct sk_buff *skb, struct mt7996_phy *phy)
 {
@@ -1208,11 +1171,6 @@ int mt7996_mcu_add_bss_info(struct mt7996_phy *phy, struct ieee80211_vif *vif,
 	struct mt7996_dev *dev = phy->dev;
 	struct sk_buff *skb;
 
-	if (mlink->omac_idx >= REPEATER_BSSID_START) {
-		mt7996_mcu_muar_config(dev, mlink, link_conf->addr, false, enable);
-		mt7996_mcu_muar_config(dev, mlink, link_conf->bssid, true, enable);
-	}
-
 	skb = __mt7996_mcu_alloc_bss_req(&dev->mt76, mlink,
 					 MT7996_BSS_UPDATE_MAX_SIZE);
 	if (IS_ERR(skb))
@@ -2989,9 +2947,6 @@ int mt7996_mcu_add_dev_info(struct mt7996_phy *phy, struct ieee80211_vif *vif,
 		},
 	};
 
-	if (mlink->omac_idx >= REPEATER_BSSID_START)
-		return mt7996_mcu_muar_config(dev, mlink, link_conf->addr, false, enable);
-
 	memcpy(data.tlv.omac_addr, link_conf->addr, ETH_ALEN);
 	return mt76_mcu_send_msg(&dev->mt76, MCU_WMWA_UNI_CMD(DEV_INFO_UPDATE),
 				 &data, sizeof(data), true);
-- 
2.53.0

