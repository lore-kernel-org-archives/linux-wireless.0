Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB0F379C4E
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 05:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786945031; cv=none; b=kFyBG9z28649oQL2WKMA05XWcDwQg+xLBCYtb2t1gspgfZ6qHIEP7thOXh+d+ybMXnKEzONmBM4y9YgclqCrw8YsHZj/BWa0aTUUtgW+ZnLdJ6LIY6CUWdpJHSc+BH07qG1JHE9HNg3MWvKZvmYjg985Jg4d1uOA54i5W6qCzsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786945031; c=relaxed/simple;
	bh=dt98ocUAux3K9VgwizS/m5coDULp0+CTjALDulWQdNY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m6hPV5bon96ZTiPTCdSU3LeAugegiAWtc6eMRvehSXFha2Y2fINjReWFFrZ3ZivQmIwsWi3XsiGuxuv9FJ6abzG2bXVAAqz6G8p7CfCsgLN7rBFP0XbPZqFa+Gsnvz4UQW27pQfwmDjd0ZMR9q9vtxfAi4QRXwQ8M5+SAacxyw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DpqkFAUq; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DpqkFAUq"
X-UUID: 8fce3a0c99fb11f18dc8c9802ae25ab1-20260817
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=HTWfwGfzFc2XqVUlWrFEfYproDWYn0hNuxeA+miUg6I=;
	b=DpqkFAUqs7I7mdMXgI8PgbwAUwmeEdktr28XRB47/umK7RaiR544ys63pDt9m5VMq/kcow8WnZgyTQvlrJ5BnULaG3VET+c/VcunBofNiAn7zrLuHFB0PGYMssDJYRSgYxFIZ258byrbIN347ot0t+oa/3i3ew/OffKCp5rAqU4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:44a6bb69-c5a8-4dd3-aa1d-bcb13d3aba0f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:131df2f1-0685-46a3-9cac-19d8f3a05ae7,B
	ulkID:nil,BulkQuantity:0,SF:102|136|836|865|888|898,TC:-5,Content:0|15|50|
	99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8fce3a0c99fb11f18dc8c9802ae25ab1-20260817
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1066881197; Mon, 17 Aug 2026 13:21:55 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 17 Aug 2026 13:21:54 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 17 Aug 2026 13:21:54 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <jeff.hsu@mediatek.com>,
	<eason.lai@mediatek.com>, Jeff Hsu <Jeff.Hsu@mediatek.com>
Subject: [PATCH] Fixes: a01a222ab4aa ("wifi: mt76: mt7928: Fix TX hang due to DMASHDL setting error")
Date: Mon, 17 Aug 2026 13:21:50 +0800
Message-ID: <20260817052151.98079-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Jeff Hsu <Jeff.Hsu@mediatek.com>

Correct the setting for DMASHDL or it will result TX hang,
due to upstream just used one TX data ring but setting DMASHDL
with multiple TX ring

Signed-off-by: Jeff Hsu <Jeff.Hsu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/pci.c   | 29 ++++++++++---------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 154e4372664e..27f27ba2e587 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -401,16 +401,17 @@ static int mt7927_dma_init(struct mt792x_dev *dev)
 
 static void mt7928_dma_shdl_lite_init(struct mt792x_dev *dev)
 {
-	u32 addr, idx, grp1_5_quota, grp15_quota;
+	u32 addr, idx, grp0_quota, grp15_quota;
+	/* Driver only uses TX ring 0, map all queues to group 0 */
 	u32 q2group[8] = {
-		0x04000000, /* AC00->G0,..., AC03->G4 */
-		0x04010101, /* AC10->G1,..., AC13->G4 */
-		0x04020202, /* AC20->G2,..., AC23->G4 */
-		0x04030303, /* AC30->G3,..., AC33->G4 */
-		0x00000005, /* ALTX->G5,BMC->G0,BCN->G0 */
-		0x00000005, /* TGID=1 ALTX->G5 */
-		0x00000000, /* NAF/NBCN/FIXFID -> G0 */
-		0x00000005, /* TGID=2 ALTX->G5 */
+		0x00000000, /* All queues -> G0 */
+		0x00000000, /* All queues -> G0 */
+		0x00000000, /* All queues -> G0 */
+		0x00000000, /* All queues -> G0 */
+		0x00000000, /* All queues -> G0 */
+		0x00000000, /* All queues -> G0 */
+		0x00000000, /* All queues -> G0 */
+		0x00000000, /* All queues -> G0 */
 	};
 
 	/* RST */
@@ -433,18 +434,18 @@ static void mt7928_dma_shdl_lite_init(struct mt792x_dev *dev)
 	     idx < ARRAY_SIZE(q2group);
 	     idx++, addr += 4)
 		mt76_wr(dev, addr, q2group[idx]);
-	/* refill, set 0 to enable group 0,1,2,3,4,5 & 15 */
-	mt76_wr(dev, MT_DMASHDL_LITE_GROUP_DISABLE0, 0xffff7fc0);
+	/* refill, set 0 to enable group 0 & 15 */
+	mt76_wr(dev, MT_DMASHDL_LITE_GROUP_DISABLE0, 0xffff7ffe);
 	mt76_wr(dev, MT_DMASHDL_LITE_GROUP_DISABLE1, 0xffffffff);
 	/* max/min quota */
-	grp1_5_quota = FIELD_PREP(MT_DMASHDL_LITE_GROUP_MAX_QUOTA_MASK, 0x3f0) |
-		       FIELD_PREP(MT_DMASHDL_LITE_GROUP_MIN_QUOTA_MASK, 0x10);
+	grp0_quota = FIELD_PREP(MT_DMASHDL_LITE_GROUP_MAX_QUOTA_MASK, 0x700) |
+		     FIELD_PREP(MT_DMASHDL_LITE_GROUP_MIN_QUOTA_MASK, 0x10);
 	grp15_quota = FIELD_PREP(MT_DMASHDL_LITE_GROUP_MAX_QUOTA_MASK, 0x30);
 
 	for (addr = MT_DMASHDL_LITE_GROUP0_QUOTA, idx = 0;
 	     idx < DMASHDL_LITE_GROUP_NUM;
 	     idx++, addr += 4)
-		mt76_wr(dev, addr, (idx <= 5) ? grp1_5_quota :
+		mt76_wr(dev, addr, (idx == 0) ? grp0_quota :
 			((idx == 15) ? grp15_quota : 0));
 }
 
-- 
2.45.2

