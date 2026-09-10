Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DA936C9C0
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 09:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789032548; cv=none; b=pQQimSZTA2sj9XBgv98nKqwOFCl8v0AO7/48zpAo0pa1K4HiiJgatB6yoKWsaoRh73FlaX074UyEaBFzvPEWu7ZyimjOZqhgY9mDr1tdKoEcG3I+qW6iUqG/vOyJjj/xoOkSbdqJAZo5CZj4lz9sdbxVa0UmeuBUdSPAa+Yh0TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789032548; c=relaxed/simple;
	bh=4Nj1IKf6whIuo+lWa6GLVTcE+XJNlwDYbWTeihB8Bvo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kb+kARNRdjHDQQACmoEQgACE4pHOcptIN24BY98FypDhEk7pLIkSGCTM+CnqC0atkmSd6+n7vepNdiGfHm8XCwsM3dJ73CaUGGiVXVjAK6F8uIk6GCnf1IRm3mkGP/ZNwlH5APLolfpOZAHGSjHTeDOwoOEwViY/Sr2F7WVEXMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=S4m9vfeg; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="S4m9vfeg"
X-UUID: 0c9d9f3aacfa11f18dc8c9802ae25ab1-20260910
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=R1y+GM/mCucEyMK20un1qpMmaGRve3ZYZM7wCNj6itM=;
	b=S4m9vfegu4EB3JvdiAcwqxgYOMliqybDRAKUEpOS1BrKwCt2n2NuJXGHTrN2j81W1GNNlC93fgs073xHgBYcn+uqXyvTBRlOpw3WeG1yWKH314KQnpuqS8MAivdNeZRjjvPw0UU5ZN9oYtWpreWNdVNoZy63WnAFFmVMPXCGihI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d1895737-b739-4623-9159-2d1f20f2d4b8,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:cc44a8e2-72a5-4ba1-af40-18bbd6ea8ffd,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0c9d9f3aacfa11f18dc8c9802ae25ab1-20260910
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1208440892; Thu, 10 Sep 2026 17:28:57 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 10 Sep 2026 17:28:56 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 10 Sep 2026 17:28:56 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7922: only check CLC hw encap type on MT7922
Date: Thu, 10 Sep 2026 17:28:55 +0800
Message-ID: <20260910092855.1689679-1-jb.tsai@mediatek.com>
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

The hw type encap field in the CLC header is only populated on MT7922.
On other chips the EEPROM MT_EE_HW_TYPE read is skipped, leaving
hw_encap as 0, so the POWER and REGD entries are compared against a
bogus value and dropped, leaving those CLC tables empty.

Read MT_EE_HW_TYPE and run the header sanity check only on MT7922, and
accept the CLC entries as-is on the other chips.

Fixes: 31bc74e462b1 ("wifi: mt76: mt7921: add CLC regulatory domain support")

Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7921/mcu.c    | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index c6af7f00ca59..0092a90eb7fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -423,7 +423,7 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	if (!mt7921_regd_clc_supported(dev))
 		return 0;
 
-	if (mt76_is_mmio(&dev->mt76)) {
+	if (is_mt7922(&dev->mt76) && mt76_is_mmio(&dev->mt76)) {
 		ret = mt7921_mcu_read_eeprom(dev, MT_EE_HW_TYPE, &hw_encap);
 		if (ret)
 			return ret;
@@ -471,14 +471,16 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 		if (phy->clc[clc->idx])
 			continue;
 
-		/* header content sanity */
-		if (clc->idx == MT7921_CLC_POWER &&
-		    u8_get_bits(clc->type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
-			continue;
+		/* header content sanity, only MT7922 encodes hw type in CLC */
+		if (is_mt7922(&dev->mt76)) {
+			if (clc->idx == MT7921_CLC_POWER &&
+			    u8_get_bits(clc->type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
+				continue;
 
-		if (clc->idx == MT7921_CLC_REGD &&
-		    u8_get_bits(clc->type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
-			continue;
+			if (clc->idx == MT7921_CLC_REGD &&
+			    u8_get_bits(clc->type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
+				continue;
+		}
 
 		phy->clc[clc->idx] = devm_kmemdup(mdev->dev, clc,
 						  le32_to_cpu(clc->len),
-- 
2.18.0

