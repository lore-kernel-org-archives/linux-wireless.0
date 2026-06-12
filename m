Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CA83E16A4
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 07:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250831; cv=none; b=WeL1pGC1FkR8CAkZQbTvXyBeBvrCduFCXGKedumumEonzk3bJWCdopMIT9lo9d0/hrc6eKzHQFibiG6LHJAWeodCmGk6oGxJNFvjUikydA72qoTEoKZ8rnJpCHO38Is4SInbBVceYHWoMLHUvoYiuLb1594xvDazj8iaV69Yicc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250831; c=relaxed/simple;
	bh=i/OGQ72BevReET7NKN04JuNP1UXKWzBUXbiND9KPqaY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAIUOZkjFSa9f7YIiLPwpvIwymgB7MGznqqfjTR21J1lr0GrN8Fl6YrjtZtvJ5Is4i8y+jFQc3UBh7IvrvveqS0Xs2Mfg/UUxa5RcKbzoU05S8Q5amsfqrI2T/X3AaN7X0ya7OVyUPtmIv3j0q6V4WvZuxEd4q6ts8Hh7WLCdY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=mbwkgB/C; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mbwkgB/C"
X-UUID: d528b9a2663311f18dc8c9802ae25ab1-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=WAuAgBwtFEMeA84wPFhPHC34qWIAJbjo492VfCBox9U=;
	b=mbwkgB/CdDbUhlrS/rGyAQFIo3fkpzTgi6npPuDnHCFWmp9vsmPqHYPUYsc/HM5fda9jWxkTUsUcymtWvVr4D3JKNERe2aRIfZTyc3paqgnst+X+8nXPbgadTUHBliMypQyDO68/ITXyjxh7O91/rcowa8yFeTXptuC0wowA6NY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:defe8040-2a3d-4fec-9d03-041346a4e052,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:e276073,CLOUDID:24da7654-902f-47df-afe3-f34f8d753c22,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|865|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d528b9a2663311f18dc8c9802ae25ab1-20260612
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 601486854; Fri, 12 Jun 2026 15:53:43 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 15:53:41 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 15:53:41 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Deren.Wu@mediatek.com>, <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
	<litien.chang@mediatek.com>, <emery.hsin@mediatek.com>,
	<jb.tsai@mediatek.com>, Xiong <xiong.huang@mediatek.com>
Subject: [PATCH 18/20] wifi: mt76: mt7925: align scan IE and EFUSE TLV lengths to 4 bytes for MT7928
Date: Fri, 12 Jun 2026 15:53:37 +0800
Message-ID: <20260612075339.2578327-3-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260612075339.2578327-1-jb.tsai@mediatek.com>
References: <20260612075339.2578327-1-jb.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Emery Hsin <emery.hsin@mediatek.com>

MT7928 firmware requires 4-byte aligned TLV payloads. Round up
UNI_SCAN_IE allocation with ALIGN(..., 4) and track padded length.

Signed-off-by: Xiong <xiong.huang@mediatek.com>
Signed-off-by: Emery Hsin <emery.hsin@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index ffe687afcf6e..e8edc8c1acca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1582,7 +1582,8 @@ int mt7925_mcu_set_eeprom(struct mt792x_dev *dev)
 		.tag = cpu_to_le16(UNI_EFUSE_BUFFER_MODE),
 		.len = cpu_to_le16(sizeof(req) - 4),
 		.buffer_mode = EE_MODE_EFUSE,
-		.format = EE_FORMAT_WHOLE
+		.format = EE_FORMAT_WHOLE,
+		.buf_len = 0
 	};
 
 	return mt76_mcu_send_and_get_msg(&dev->mt76, MCU_UNI_CMD(EFUSE_CTRL),
@@ -3036,11 +3037,11 @@ mt7925_mcu_build_scan_ie_tlv(struct mt76_dev *mdev,
 			     struct ieee80211_scan_ies *scan_ies)
 {
 	u32 max_len = sizeof(struct scan_ie_tlv) + MT76_CONNAC_SCAN_IE_LEN;
+	u32 ies_len, alloc_len;
 	struct scan_ie_tlv *ie;
 	enum nl80211_band i;
 	struct tlv *tlv;
 	const u8 *ies;
-	u16 ies_len;
 
 	for (i = 0; i <= NL80211_BAND_6GHZ; i++) {
 		if (i == NL80211_BAND_60GHZ)
@@ -3052,11 +3053,16 @@ mt7925_mcu_build_scan_ie_tlv(struct mt76_dev *mdev,
 		if (!ies || !ies_len)
 			continue;
 
-		if (ies_len > max_len)
+		if (is_mt7928(mdev))
+			alloc_len = ALIGN(sizeof(*ie) + ies_len, 4);
+		else
+			alloc_len = sizeof(*ie) + ies_len;
+
+		if (alloc_len > max_len)
 			return;
 
 		tlv = mt76_connac_mcu_add_tlv(skb, UNI_SCAN_IE,
-					      sizeof(*ie) + ies_len);
+					      alloc_len);
 		ie = (struct scan_ie_tlv *)tlv;
 
 		memcpy(ie->ies, ies, ies_len);
@@ -3074,7 +3080,7 @@ mt7925_mcu_build_scan_ie_tlv(struct mt76_dev *mdev,
 			break;
 		}
 
-		max_len -= (sizeof(*ie) + ies_len);
+		max_len -= alloc_len;
 	}
 }
 
-- 
2.45.2

