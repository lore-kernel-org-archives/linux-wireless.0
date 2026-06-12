Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321A23E16B2
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 07:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250654; cv=none; b=ZMvXoyzqziwy5lcLnXRfH9dmV6JWHu5QauPME4wsbQam+oEywvES1J1MK3QFZSWZMJ8ug30Bcfv23X+RJvCC+YJoOU4uGvWoCOkqe12sy7GwGQmf2KBeJ7mPwq6+BZjCLnpSgmxu+d+0kZxBNpPjvBAH6DrMTiD7sOXBYtTO9mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250654; c=relaxed/simple;
	bh=CESv5N/jiOuw6DVqvHPyBeLGjmB8Wd5On77SO4oxG3I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LJwPjGB7e4epiEPVgrte49xUe049Skguwy/0WQu3PY3wEnawY0XAXAMUC1FAZn9H54gxLjCZtUyk7MiGJwrEBN7xggRmd5dPoaVeBpGM6oyRCdKfF4jxcOXq1YU//P2nxd3y/qIV7kpqTV+/PNiIBMtgimuvjtAfmR9kHt9f4mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=r8+N7Nwx; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="r8+N7Nwx"
X-UUID: 6ab86fd6663311f1b1788b6acf885367-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=NiCyq+CPffdcVtL25hX44LNm9f/t32AI0R+VbdCf4do=;
	b=r8+N7NwxdYSbvj8FqQno8IWKzA/1qRahLk8lma6ajsTssX20czq8EWtrzei1RC5OIOaLRCQxC+0x7J/IlrN8UCK1hLV+B4x/IEHP6oewXtwK1xWSxisxjBnXenfhZGIImH9daaxp4JLomPZR6NMfudJ0TycUocUTyhAjSqRfXeI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:6957a030-c0af-4ac4-bf97-a16df9d999fd,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:57d27654-902f-47df-afe3-f34f8d753c22,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|836|865|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6ab86fd6663311f1b1788b6acf885367-20260612
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1343058887; Fri, 12 Jun 2026 15:50:44 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 15:50:43 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 15:50:43 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Deren.Wu@mediatek.com>, <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
	<litien.chang@mediatek.com>, <emery.hsin@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH 01/20] wifi: mt76: mt792x: consolidate rx interrupt masks into all_complete_mask
Date: Fri, 12 Jun 2026 15:50:38 +0800
Message-ID: <20260612075042.2577193-1-jb.tsai@mediatek.com>
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

From: Emery Hsin <emery.hsin@mediatek.com>

Add all_complete_mask to irq_map rx sub-struct and use it in
mt792x_irq_tasklet() and mt792x_dma_enable() to replace individual
per-ring mask OR expressions.

This is a preparation patch before enabling MT7928 PCIe support.

Signed-off-by: Emery Hsin <emery.hsin@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt792x.h     | 1 +
 drivers/net/wireless/mediatek/mt76/mt792x_dma.c | 8 ++------
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 70073b43af54..83c729f8bb76 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -200,6 +200,7 @@ struct mt792x_irq_map {
 		u32 mcu_complete_mask;
 	} tx;
 	struct {
+		u32 all_complete_mask;
 		u32 data_complete_mask;
 		u32 wm_complete_mask;
 		u32 wm2_complete_mask;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
index fc326447c792..946ff6d58954 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
@@ -39,9 +39,7 @@ void mt792x_irq_tasklet(unsigned long data)
 
 	trace_dev_irq(&dev->mt76, intr, dev->mt76.mmio.irqmask);
 
-	mask |= intr & (irq_map->rx.data_complete_mask |
-			irq_map->rx.wm_complete_mask |
-			irq_map->rx.wm2_complete_mask);
+	mask |= intr & irq_map->rx.all_complete_mask;
 	if (intr & dev->irq_map->tx.mcu_complete_mask)
 		mask |= dev->irq_map->tx.mcu_complete_mask;
 
@@ -276,9 +274,7 @@ int mt792x_dma_enable(struct mt792x_dev *dev)
 	/* enable interrupts for TX/RX rings */
 	mt76_connac_irq_enable(&dev->mt76,
 			       dev->irq_map->tx.all_complete_mask |
-			       dev->irq_map->rx.data_complete_mask |
-			       dev->irq_map->rx.wm2_complete_mask |
-			       dev->irq_map->rx.wm_complete_mask |
+			       dev->irq_map->rx.all_complete_mask |
 			       MT_INT_MCU_CMD);
 	mt76_set(dev, MT_MCU2HOST_SW_INT_ENA, MT_MCU_CMD_WAKE_RX_PCIE);
 
-- 
2.45.2

