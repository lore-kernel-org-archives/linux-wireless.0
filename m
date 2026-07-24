Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF664908C2
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784883097; cv=none; b=W+A3OFxRRVYiqcnmDESYDrE7WxtJdTkqkilFui9RIRAKvuQvTUkCv3O0qGDRNHcOviTgvL3yt/lDpxxfAJY/ip/itFtMf5x6PU2pApXnKts2rqQDkzJzBr1+vY1Mvqs5qI05xmgeBB/qfI7NEGr3LhSXMTggfadoLByyThx0JeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784883097; c=relaxed/simple;
	bh=imaRThPJa2XU97qp9/R2SrYTx9+PUeA864Utxu2Rbm0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AJl5ddG0G6N6va5CQR08qTULORCEWTajA1rBYIUL/GwUhSvGQv3k4TkkohvfcxydKCSqc3nlihWjCME4pNkYmq4YLvmth8pv14JMdXuY9O2RaqOHq/gr17sJvGsDaCynrwGOmkHGq29LCokQRNiC9ADZHC1fqr7fyCC7oCFWTy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rXxQXNAc; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rXxQXNAc"
X-UUID: db2a3f04873c11f18dc8c9802ae25ab1-20260724
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=NoVN4zs7tL3OcBdEPkkFH48P9b0ZAT03ln1vk/rYEpc=;
	b=rXxQXNAc91zSmXxUXpUxoZXwO2iTe/3pFnwhqcTEmTeJmRnQXb2XBbZH/YzjwMm+J8sGZMw9X9+nHjt1WW/+DnWtJ7erTfJ3f4ct8ZZdgxXXAWF8oCZv+P4rpU07u5VdnzCUMH2Chdp0WrnGFR/P4H28R+QTfsqMwkZKmuOK1FQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:2d6b7660-1350-4db0-8125-3ba2a9af05b7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:4d104254-ba59-46c6-b844-86065e9edbd3,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: db2a3f04873c11f18dc8c9802ae25ab1-20260724
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 93193238; Fri, 24 Jul 2026 16:51:26 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 24 Jul 2026 16:51:25 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 24 Jul 2026 16:51:25 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: connac3: refactor CLC header type validation logic
Date: Fri, 24 Jul 2026 16:51:24 +0800
Message-ID: <20260724085124.3156143-1-jb.tsai@mediatek.com>
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

Separate the hardware encapsulation type validation into two distinct
checks based on CLC index type. For BE_CTRL and REGD indices, validate
against the t2 header type, while other indices should validate against
the t0 header type. This ensures proper CLC filtering for different
calibration data structures.

Fixes: 4ce639ea518f ("wifi: mt76: mt7925: add regulatory wiphy self manager support")
Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index a12b939b6123..37502d8a0e7d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -899,8 +899,11 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 			continue;
 
 		/* header content sanity */
-		if ((clc->idx == MT792x_CLC_BE_CTRL &&
-		     u8_get_bits(clc->t2.type, MT_EE_HW_TYPE_ENCAP) != hw_encap) ||
+		if ((clc->idx == MT792x_CLC_BE_CTRL || clc->idx == MT792x_CLC_REGD) &&
+		    u8_get_bits(clc->t2.type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
+			continue;
+
+		if (clc->idx != MT792x_CLC_BE_CTRL && clc->idx != MT792x_CLC_REGD &&
 		    u8_get_bits(clc->t0.type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
 			continue;
 
-- 
2.18.0

