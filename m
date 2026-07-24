Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C5A3DD500
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784882881; cv=none; b=BMhG823VJDlfU/paey4zPnUwJT54aWbFV2IRNBorbJUtNykFjyf2b8V56fJwKbrhzhGRpMdAKiCN1W3thvYATGZT0Rfp3DzaapNJKAlExKsJtI26xvuG1YY7PqomVAxw+ebbDhMxI7pjvSbtWw+asXQynTaMKwwYhI/vPpvWkjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784882881; c=relaxed/simple;
	bh=uAe/+Uhl9j83VQYP6zqSD7uS3a1Db1UFyWa8WRR6VLU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mMqXc3GQafsktFLiMq1HjkDuyIDxktGRmLTxg0beow9LRHnGbAsGyiuzj/55QpOuDsqo9sOD4ssTUeaYxtXI4XA9cesin1I4auM64suNQRqvR9sgAZSmtLMw3hAxyXi4msmqljQBNw8iT/419fyUB0TChi8gcR+6G1sUcQkSbGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qPGNf5kJ; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qPGNf5kJ"
X-UUID: 56efdff0873c11f18dc8c9802ae25ab1-20260724
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=eOVR+sd2QVsPchDnrXInGMX9n7ResH6jilnddaFJ3mU=;
	b=qPGNf5kJw+HBhIjlBdRDGD7PrhIu2Lyl8mnRAv+8gx9nvhMtIAtMmPa0guftpHZTXZE7HX30V2u1CCjL/MB9xS5pbBTdrK8u+RK4z+9YJw+8B7hOfo/K90jC2j4YauoLxRPlIXvcD61mN1W0B7h2jwWdO4MplPX2opPWPvmHwDY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:947f21c5-7983-47fa-a010-995b0a32ba47,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:1b084254-ba59-46c6-b844-86065e9edbd3,B
	ulkID:nil,BulkQuantity:0,SF:102|136|836|865|888|898,TC:-5,Content:0|15|50|
	99|100|102|156,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 56efdff0873c11f18dc8c9802ae25ab1-20260724
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 172492752; Fri, 24 Jul 2026 16:47:45 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 24 Jul 2026 16:47:43 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 24 Jul 2026 16:47:43 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: connac2: add CLC regulatory domain support
Date: Fri, 24 Jul 2026 16:47:42 +0800
Message-ID: <20260724084742.3153813-1-jb.tsai@mediatek.com>
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

Add MT7921_CLC_REGD index definition and corresponding hardware
encapsulation type check in CLC loading flow to support regulatory
domain configuration via CLC (Country/Local Configuration) data.

Fixes: 058f274fb55f ("wifi: mt76: mt7921: add regulatory wiphy self manager support")
Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 2e0769d18f87..c6af7f00ca59 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -476,6 +476,10 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 		    u8_get_bits(clc->type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
 			continue;
 
+		if (clc->idx == MT7921_CLC_REGD &&
+		    u8_get_bits(clc->type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
+			continue;
+
 		phy->clc[clc->idx] = devm_kmemdup(mdev->dev, clc,
 						  le32_to_cpu(clc->len),
 						  GFP_KERNEL);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index fb8654b7c5e7..f5628fb6bfbf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -136,6 +136,7 @@ struct mt7921_dma_layout {
 enum {
 	MT7921_CLC_POWER,
 	MT7921_CLC_CHAN,
+	MT7921_CLC_REGD = 3,
 	MT7921_CLC_MAX_NUM,
 };
 
-- 
2.18.0

