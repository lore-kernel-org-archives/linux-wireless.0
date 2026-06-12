Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663C53E1D12
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 07:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250657; cv=none; b=ZQJDvg2B4/rHrDyLFFzWkpqIY7KYGkPlEE/Z/BEiZu0L4FYwUMI0qOHUZhsLdo9Z6eJczFud0oD0TaiHp1J2/OSnfuEz0X2iPPr8S6w1uTFlptFkxGD6Ot8gfAuf1SppeO404WZVvtMAmRl78MCM/LQ0cR9iDkXjvLUx+tOU8fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250657; c=relaxed/simple;
	bh=BhGLfQV2pcaAFkTCutWRcBVZ4/DE6hwpFPTOtPrehCs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TLId5oRAM5p2SxXn/0SRm0lnmI6q8uBmstRWe2SV+PYzJDwfmBDR/XpirNM3cAU8Z/fT+TRuFVuoJxR4ba8skcqeEsnabhw/bNDEJqXvM0oU1W9ra2rQ7Xlkw5pNBDLKBKxrOyMpSgrvyn0ruY9PRSk47pgO6Xb7sbzu6VBDBFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qNjhhWpX; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qNjhhWpX"
X-UUID: 6d3d33f4663311f1b1788b6acf885367-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=b2tRO0L8DcORPbYqGZZCRCNS1AKx5eelxTRhAeYliMY=;
	b=qNjhhWpXLOH1/1yG1AIYW3fs7ar09tJXyFMqovJVpiiBodwbb1bpMkkr6O+LQGpTAJO/kvXgPIHtw7BHkGq/guF0pfd2Yya5r83v8dC/GvnYg2tfipw9wICW6+zDyniatGUoh/PU2h6MLeiOV4MtoAelFalaG3zwgWF+ZLH1kyI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:ec86c380-373f-44c4-8c86-16e6193c1ceb,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:e276073,CLOUDID:9c72b230-7784-4a77-a538-47ed6151d81b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|865|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6d3d33f4663311f1b1788b6acf885367-20260612
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1037779170; Fri, 12 Jun 2026 15:50:48 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 15:50:47 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 15:50:47 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Deren.Wu@mediatek.com>, <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
	<litien.chang@mediatek.com>, <emery.hsin@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH 05/20] wifi: mt76: mt792x: replace shared PCIe MAC macros with per-chip struct
Date: Fri, 12 Jun 2026 15:50:42 +0800
Message-ID: <20260612075042.2577193-5-jb.tsai@mediatek.com>
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

Replace hardcoded MT_PCIE_MAC_INT_ENABLE and MT_PCIE_MAC_PM macros
with a per-chip mt792x_pcie_reg struct. Remove the shared macros
from mt792x_regs.h and update mt792x_wpdma_reinit_cond() to use
dev->pcie_reg.

This is a preparation patch before enabling MT7928 PCIe support.

Signed-off-by: Emery Hsin <emery.hsin@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt792x.h      | 6 ++++++
 drivers/net/wireless/mediatek/mt76/mt792x_dma.c  | 6 ++++--
 drivers/net/wireless/mediatek/mt76/mt792x_regs.h | 4 ----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 83c729f8bb76..eacee63e13f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -238,6 +238,11 @@ struct mt792x_hif_ops {
 	int (*fw_own)(struct mt792x_dev *dev);
 };
 
+struct mt792x_pcie_reg {
+	u32 imask;
+	u32 pm;
+};
+
 struct mt792x_dev {
 	union { /* must be first */
 		struct mt76_dev mt76;
@@ -273,6 +278,7 @@ struct mt792x_dev {
 	struct mt76_connac_coredump coredump;
 	const struct mt792x_hif_ops *hif_ops;
 	const struct mt792x_irq_map *irq_map;
+	const struct mt792x_pcie_reg *pcie_reg;
 
 	struct work_struct ipv6_ns_work;
 	struct delayed_work mlo_pm_work;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
index 946ff6d58954..2947504ef20b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
@@ -345,7 +345,8 @@ int mt792x_wpdma_reinit_cond(struct mt792x_dev *dev)
 	if (mt792x_dma_need_reinit(dev)) {
 		/* disable interrutpts */
 		mt76_wr(dev, dev->irq_map->host_irq_enable, 0);
-		mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0x0);
+		if (dev->pcie_reg)
+			mt76_wr(dev, dev->pcie_reg->imask, 0x0);
 
 		err = mt792x_wpdma_reset(dev, false);
 		if (err) {
@@ -354,7 +355,8 @@ int mt792x_wpdma_reinit_cond(struct mt792x_dev *dev)
 		}
 
 		/* enable interrutpts */
-		mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
+		if (dev->pcie_reg)
+			mt76_wr(dev, dev->pcie_reg->imask, 0xff);
 		pm->stats.lp_wake++;
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_regs.h b/drivers/net/wireless/mediatek/mt76/mt792x_regs.h
index 4cd5b33b640e..6d174b158915 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_regs.h
@@ -415,10 +415,6 @@
 #define MT_HW_EMI_CTL			0x18011100
 #define MT_HW_EMI_CTL_SLPPROT_EN	BIT(1)
 
-#define MT_PCIE_MAC_BASE		0x10000
-#define MT_PCIE_MAC(ofs)		(MT_PCIE_MAC_BASE + (ofs))
-#define MT_PCIE_MAC_INT_ENABLE		MT_PCIE_MAC(0x188)
-#define MT_PCIE_MAC_PM			MT_PCIE_MAC(0x194)
 #define MT_PCIE_MAC_PM_L0S_DIS		BIT(8)
 
 #define MT_DMA_SHDL(ofs)		(0x7c026000 + (ofs))
-- 
2.45.2

