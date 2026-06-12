Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3693E1235
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 07:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250653; cv=none; b=ZQhvLzGFLwuRFnm+8sIwR+n65jApNf9MEI7AnGrrf4hDfHUgKhHKlGj36kTsjaVLDJVUbR5ZoIW048DobYAL1o9ffACHtP9vv2desybFPb8Jk5pIG/C0RAEo1lvTcn8e7iQB5FIMtv1f7xtyR7Umakj5XfUS3knBH1IjIHCSG8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250653; c=relaxed/simple;
	bh=Br84Ghy1WGiL5wQrPBDBfUSzritlgclI2JJbuZnsoPM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lVWIZ4D6+KhGngvbR6eyiY3vpqJb3C0GwDeIjAgTSJzuUcdc8KRIMvFXf/zT/k+RT0kcZ2XxrQ9jTBpsazCVc5zstxqBcOPcMW7DXY4UFQZGwvO3dyLqznltlxKLGuXzVig65MXMb2V1xCELxuk1Qc+cJxOpFKpTmBWm8tKFRr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bkIvKWu2; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bkIvKWu2"
X-UUID: 6b47ad40663311f18dc8c9802ae25ab1-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=78Ug6vEoSPYBuHxW/IGawc2CU9Z+jCIkSbMm+dDEYvg=;
	b=bkIvKWu2RPwoC9m9jbzkOtxK03r0DmbcMknCTSNPBInEBVVjdH70tnz6R0dVQh2rhjmRQaWTdRm+6GYViwJeLaYOeD69guYo7oUvRoY8DGu4ZnKMvL1pNtF8czzQRJswd+hIV+7aspmz7Kj541h8EYUjrUauvf3GvHftaiZFWF8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:ed53c46e-dbeb-4fda-b10f-6cb4521bdfe0,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e276073,CLOUDID:0d4b6397-22d1-4176-b420-d0d82ac3f01a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|865|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6b47ad40663311f18dc8c9802ae25ab1-20260612
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 194431172; Fri, 12 Jun 2026 15:50:45 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 15:50:44 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 15:50:44 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Deren.Wu@mediatek.com>, <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
	<litien.chang@mediatek.com>, <emery.hsin@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH 02/20] wifi: mt76: connac2: apply new rx all_complete_mask
Date: Fri, 12 Jun 2026 15:50:39 +0800
Message-ID: <20260612075042.2577193-2-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260612075042.2577193-1-jb.tsai@mediatek.com>
References: <20260612075042.2577193-1-jb.tsai@mediatek.com>
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

Populate all_complete_mask in MT7921 irq_map and update pci_resume()
and mac_reset() to use irq_map->rx.all_complete_mask instead of the
hardcoded MT_INT_RX_DONE_ALL macro.

This is a preparation patch before enabling MT7928 PCIe support.

Signed-off-by: Emery Hsin <emery.hsin@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c     | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 49a37185f056..067f6b4142b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -292,6 +292,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 			.mcu_complete_mask = MT_INT_TX_DONE_MCU,
 		},
 		.rx = {
+			.all_complete_mask = MT_INT_RX_DONE_ALL,
 			.data_complete_mask = MT_INT_RX_DONE_DATA,
 			.wm_complete_mask = MT_INT_RX_DONE_WM,
 			.wm2_complete_mask = MT_INT_RX_DONE_WM2,
@@ -559,7 +560,8 @@ static int mt7921_pci_resume(struct device *device)
 	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
 	mt76_connac_irq_enable(&dev->mt76,
 			       dev->irq_map->tx.all_complete_mask |
-			       MT_INT_RX_DONE_ALL | MT_INT_MCU_CMD);
+			       dev->irq_map->rx.all_complete_mask |
+			       MT_INT_MCU_CMD);
 	mt76_set(dev, MT_MCU2HOST_SW_INT_ENA, MT_MCU_CMD_WAKE_RX_PCIE);
 
 	/* put dma enabled */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
index 0db7acb3a637..98b3469ac597 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
@@ -96,7 +96,8 @@ int mt7921e_mac_reset(struct mt792x_dev *dev)
 
 	mt76_wr(dev, dev->irq_map->host_irq_enable,
 		dev->irq_map->tx.all_complete_mask |
-		MT_INT_RX_DONE_ALL | MT_INT_MCU_CMD);
+		dev->irq_map->rx.all_complete_mask |
+		MT_INT_MCU_CMD);
 	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
 
 	err = mt7921e_driver_own(dev);
-- 
2.45.2

