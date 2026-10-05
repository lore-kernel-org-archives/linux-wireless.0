Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5A43AFAEA
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 08:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189555; cv=none; b=Bz97GiCCJsKvZVPte5i4hEYpQ2OBsQ6+6K51sxZZv2inx2gMpZg+kBQyGxqC6juC6PfUVOnCKeRECnOxPj6nHcGEOPu7nCAmibrg2yKeTjz5P+D6okm4naFD/th4iAvA+yNBHzy6F/TvYo6+wP+pabDb/0jQY5MZkn/HJSvccMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189555; c=relaxed/simple;
	bh=lNPiAZn5NpLedczvCV6B2yMeeMaBL4EZzSVIPAkFDfs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MB3dRd6lFq646Q8L8yh+9L9UlZzOhzzJI5DFoqlPuDCtnelsFKgy1JH7OisQ8e/LHUOpmyvHhoZqj2oh9kHdOaCiJR3ivCiKe79Rb9H1PNxLZC4r9AWJC1bOy72RbK3cHoQbYVH/yl4uRDmgBa4jdjqcwHsTs9UInMRlq+mhUuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rPY5myzA; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rPY5myzA"
X-UUID: 3a3db2fcc09811f18dc8c9802ae25ab1-20261005
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=l8ieC+rilEmgPn2tpFeyk5Ca9rP0sqcwbMniIbRuVfc=;
	b=rPY5myzAhIUtqi6lQTf+T8uCifBBBEehkLfQEuBELYBOwxJhEPubpmPqa15c/C21LVQ0EI8o7aAEvjypvrq/Rtyk+G6ZeySBjmPhXAt6XjyIkcb7K4p4G9sC3priqE0CUXtEKXGq2XFjB9CARlNK0sBGyhrqkkHgE0wkJ74MQu4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:1eb430b0-8bd8-4f37-9bc7-1a5d6167601e,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:291e20b,CLOUDID:989beaf7-91c2-4af9-92c0-1f8aa7df6d30,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3a3db2fcc09811f18dc8c9802ae25ab1-20261005
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1834442075; Mon, 05 Oct 2026 16:39:06 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Oct 2026 16:39:05 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 5 Oct 2026 16:39:05 +0800
From: Anthony Liu <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Sean.Wang@mediatek.com>, <Leon.Yen@mediatek.com>,
	<Quan.Zhou@mediatek.com>, <Ryder.lee@mediatek.com>,
	<litien.chang@mediatek.com>, <kun.wu@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, Anthony Liu <anthony.liu@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7928: makes struct beacon_tlv 4-byte aligned.
Date: Mon, 5 Oct 2026 16:39:04 +0800
Message-ID: <20261005083904.107527-1-anthony.liu@mediatek.com>
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

mt76 fails when offloading beacon to MT7928 FW.

This is caused by newly added 4-byte alignment check in MT7928 FW
and works when beacon_tlv is 4-byte aligned. MT7925 is not affected
because it accepts same struct with or without extra padding bytes.

Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 376cc4833242..ff51d8189b46 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2392,10 +2392,13 @@ mt7925_mcu_uni_add_beacon_offload(struct mt792x_dev *dev,
 			u8 pad[3];
 		} __packed hdr;
 		struct bcn_content_tlv {
+			/* DW 0 */
 			__le16 tag;
 			__le16 len;
+			/* DW 1 */
 			__le16 tim_ie_pos;
 			__le16 csa_ie_pos;
+			/* DW 2 */
 			__le16 bcc_ie_pos;
 			/* 0: disable beacon offload
 			 * 1: enable beacon offload
@@ -2406,8 +2409,9 @@ mt7925_mcu_uni_add_beacon_offload(struct mt792x_dev *dev,
 			 * 1: only cap field IE
 			 */
 			u8 type;
+			/* DW 3~130 */
 			__le16 pkt_len;
-			u8 pkt[512];
+			u8 pkt[510];
 		} __packed beacon_tlv;
 	} req = {
 		.hdr = {
-- 
2.45.2

