Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7B733A9CF
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 03:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776285; cv=none; b=crKJtC5Z3wCexbSYu35moYk6FmJXd7JGWSNH/BM9uPKsUT3hFKdhphXArhgeKeA5lpcJbpM0yUbEnUMjx+AiFz7A9q/bPZDdT233Pxj/8U+iBJnqNzVKzAi/TG+PMmkTE6TbskqgCQYYaHX9Py9cJwriotT5+nD9XZKUjqAhjn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776285; c=relaxed/simple;
	bh=LrIj+VI9qdPz4umzDvLg8sj9h5IVD0JQI/aJ3yOF8Nw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B+wTvR2mBWCm4vl6jtOUtnh2e1t99sN6y2UI1yLdGdhfLDR6vlIjJE8QPEdTaLDdPlcwIvWm4GKFz14cHv2RMhZcQud6UzdZTLC7I88m/oMYZWGstDeNSLXjjVpQSJOgYTRacGQJLndeQWtwEWh38VY1RjSvxN85ayh6GIIbiQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kNrvTi7c; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kNrvTi7c"
X-UUID: 27ae83ac864411f1b1788b6acf885367-20260723
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=vXAAn7AG46pDpO/9QgriNaLdYfh06COEGdalmGLYbbY=;
	b=kNrvTi7cvG2xobIAC+YNKXvklhQr+7K/W5GXn83/j9M/50LxAu1w8WeqLK7Aas8cNbEKWuDsWclkOZcxehCvH/RsqL3rybknAjIgJ8eaMF6NsK7nUDWNeY9OW0ot4gaIJdg9xRmXPlaeMMXfcnW4qdnv9EtsbeVGS8cCJLlFWec=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:b5beb589-9eb8-4e98-81f9-245d62544367,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:940e37d6-1078-4cd9-8e6f-a9a3d1715936,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 27ae83ac864411f1b1788b6acf885367-20260723
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 757809576; Thu, 23 Jul 2026 11:11:10 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 23 Jul 2026 11:11:09 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 23 Jul 2026 11:11:09 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<Shengwei.Lu@mediatek.com>, <litien.chang@mediatek.com>,
	<jb.tsai@mediatek.com>, shengwei.lu <shengwei.lu@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7925: Fix EHT Beamformee SS subfields to meet 802.11be minimum
Date: Thu, 23 Jul 2026 11:11:08 +0800
Message-ID: <20260723031108.2017653-1-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: "shengwei.lu" <shengwei.lu@mediatek.com>

Per IEEE 802.11be, the Beamformee SS <= 80/160/320 MHz 3-bit subfields
in the EHT PHY Capabilities are encoded as (Nss - 1) and are required
to be >= 3 (i.e. at least 4 SS receive capability) whenever SU
Beamformee is advertised.

MT7925 is a 2x2 STA (sts = 2), so directly filling (sts - 1) = 1
violates the spec minimum. Clamp the encoded value to 3 when sts <= 3,
otherwise use (sts - 1). This is applied consistently to the
BEAMFORMEE_SS <= 80 MHz (split across phy_cap_info[0]/[1]), <= 160 MHz
and <= 320 MHz (6 GHz only) subfields.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: shengwei.lu <shengwei.lu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index ddb637d6a3c3..dbe67ce2e4a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -188,19 +188,21 @@ mt7925_init_eht_caps(struct mt792x_phy *phy, enum nl80211_band band,
 		eht_cap_elem->phy_cap_info[0] |=
 			IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ;
 
+	val = (sts > 3) ? sts - 1 : 3;
+
 	eht_cap_elem->phy_cap_info[0] |=
-		u8_encode_bits(u8_get_bits(sts - 1, BIT(0)),
+		u8_encode_bits(u8_get_bits(val, BIT(0)),
 			       IEEE80211_EHT_PHY_CAP0_BEAMFORMEE_SS_80MHZ_MASK);
 
 	eht_cap_elem->phy_cap_info[1] =
-		u8_encode_bits(u8_get_bits(sts - 1, GENMASK(2, 1)),
+		u8_encode_bits(u8_get_bits(val, GENMASK(2, 1)),
 			       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_80MHZ_MASK) |
-		u8_encode_bits(sts - 1,
+		u8_encode_bits(val,
 			       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_160MHZ_MASK);
 
 	if (band == NL80211_BAND_6GHZ && is_320mhz_supported(&phy->dev->mt76))
 		eht_cap_elem->phy_cap_info[1] |=
-			u8_encode_bits(sts - 1,
+			u8_encode_bits(val,
 				       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_320MHZ_MASK);
 
 	eht_cap_elem->phy_cap_info[2] =
-- 
2.45.2

