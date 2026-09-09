Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A1E2D3727
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 05:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933484; cv=none; b=S6Lp/qr0kpDuI+keITovp7sKBis+1jN13tc9jbByUqTsrsgimazklBbDZMCO9iLbPVb6U0kWBB5r+sPNjEHhOJ3VnCavtlj1i0aEo/nl0uHzL68/wNXNJXhkz6fdL93Yvh9qleiCA0SBLbTva7EWbvwO+EfBvzDoquWh53gXMH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933484; c=relaxed/simple;
	bh=/EpkuVH0ZDWvsEZuppDcUom8DCCLZP0xfsa8tUUrMOA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oJOKmBz0ODOzM3n82LSnh1cCoCEZLVMyqJNN4jk7gByyHJdUrQGDiRookx5YPABe2bqT2fEDsYKrhQ9hCpkQgYmfmx8/mMVjO95GRhQaDpVwN1zaHDJlv9UK3aMsu6xKMpC6fEs5XGk5c1wMwlIEoSsw/5hyA7tluph6JAB6R44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rKXgeSB3; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rKXgeSB3"
X-UUID: 6518d8e2ac1311f18dc8c9802ae25ab1-20260909
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=UVPcEqdvMw0odJtdzU41jB5q01uD8558jbITbPIqW1c=;
	b=rKXgeSB3BTk+rn1vMYl4yOYOIpvD3VpGu2SeBo1zSCn1Wd2nDBw3IArauOTfcb8xr+QE5A7vhmO2RcDgdUdIvkARxIDgCRhdC/8nhhn8k9AoYJlYJhreiJy37vy1ZZ1GkFARIErRb0ONwt+iKDMdio/ZFYpulqHBSd8D9d3nJj0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:3f377e0f-d97e-4f9d-a1c3-deea4abcdf14,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:447b99e2-72a5-4ba1-af40-18bbd6ea8ffd,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6518d8e2ac1311f18dc8c9802ae25ab1-20260909
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 87215197; Wed, 09 Sep 2026 13:57:52 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 9 Sep 2026 13:57:51 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 9 Sep 2026 13:57:51 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7928: only do CLC hw type sanity check on MT7925
Date: Wed, 9 Sep 2026 13:57:50 +0800
Message-ID: <20260909055750.929102-1-jb.tsai@mediatek.com>
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

From: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>

mt7925_load_clc() is shared by MT7925, MT7927 and MT7928 (0x7935 is
folded into 0x7928 in pci.c). The hw type sanity check it does on every
CLC region is MT7925-specific twice over: the encap bits live at
efuse offset MT_EE_HW_TYPE (0xa71) in the MT7925 layout, and only
MT7925 CLC blobs carry that hw type in their t0/t2 header. On
MT7927/MT7928 the driver therefore reads a byte that means nothing on
those parts and compares it against a header field that was never
populated, so a mismatch silently skips every CLC region and leaves
phy->clc[] empty - no country/regd table gets installed at all.

Gate both the efuse read and the two header checks on is_mt7925(), so
MT7927/MT7928 accept the CLC regions from their own firmware as-is.
No functional change for MT7925: PCIe still reads 0xa71 and filters by
encap type, USB still runs with hw_encap = 0 as before.

Fixes: 356b39285559 ("wifi: mt76: connac3: refactor CLC header type validation logic")

Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c    | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index bd63789ab8f7..bf2cb6172cc8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -855,7 +855,7 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	if (!mt7925_regd_clc_supported(dev))
 		return 0;
 
-	if (mt76_is_mmio(&dev->mt76)) {
+	if (is_mt7925(&dev->mt76) && mt76_is_mmio(&dev->mt76)) {
 		ret = mt7925_mcu_read_eeprom(dev, MT_EE_HW_TYPE, &hw_encap);
 		if (ret)
 			return ret;
@@ -906,14 +906,16 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 		if (phy->clc[clc->idx])
 			continue;
 
-		/* header content sanity */
-		if ((clc->idx == MT792x_CLC_BE_CTRL || clc->idx == MT792x_CLC_REGD) &&
-		    u8_get_bits(clc->t2.type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
-			continue;
+		/* header content sanity, only MT7925 encodes hw type in CLC */
+		if (is_mt7925(&dev->mt76)) {
+			if ((clc->idx == MT792x_CLC_BE_CTRL || clc->idx == MT792x_CLC_REGD) &&
+			    u8_get_bits(clc->t2.type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
+				continue;
 
-		if (clc->idx != MT792x_CLC_BE_CTRL && clc->idx != MT792x_CLC_REGD &&
-		    u8_get_bits(clc->t0.type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
-			continue;
+			if (clc->idx != MT792x_CLC_BE_CTRL && clc->idx != MT792x_CLC_REGD &&
+			    u8_get_bits(clc->t0.type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
+				continue;
+		}
 
 		phy->clc[clc->idx] = devm_kmemdup(mdev->dev, clc,
 						  le32_to_cpu(clc->len),
-- 
2.18.0

