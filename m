Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E51E3D5C2A
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 07:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250829; cv=none; b=UnqV6jkJ512gLa217lEIkr8HVy98svrQFjcBTyof+Zqay2u7oYVgOzz7mfUdoKv3GoXI7d/zhsEI4ybKpn8NI9mmhy28CtKyuZdRxUMZ7jA/2L4XYj+vwdjxrFryDtUDBGOFjljVKIr71t3thRSkjiBQa7RuIMwiKLYmDGqDjw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250829; c=relaxed/simple;
	bh=kP+KLyF+0J2datJA23S76pcGammIqnK3e3GtyjHCiMQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eb9HWywDVOs5FZ0li3iUtGg+/B0TDPsszUf3XqHRkuKLm/UKW1Jk1nZKYKNCXJMfoy7aFzaep/3Poq2mjzmbDhhA51M66KY0kGt/5bDvh9D5Mph6lLM05C6c37km8ezb2oQP+FkydwLYDGvUm30jCd32ePJmrwooy/XX/QQQ0QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=JckucV9k; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JckucV9k"
X-UUID: d52a5f5a663311f18dc8c9802ae25ab1-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=mYrXi9fpXa7s0Qu+ogV+Te6KaCISoc2b1Yw1WPWp/4w=;
	b=JckucV9keq26lG7qgP8v7kLdvzdcPQtT/YZG8t1Kn/rVUmQFqk4DeYgz4gF9zdlvyBomWs+5eFWj8U3QSEmlZ+GdLh0jA36aGbVW6tZDAvOziSa0jVd8gegK9d8VnMNI0haFxsB97dMvLjguWISX9qSi+BFIBBcKQAJH987Z9XI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:a4072c1b-7451-4f76-a24d-d4b5db456342,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e276073,CLOUDID:13536397-22d1-4176-b420-d0d82ac3f01a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|865|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d52a5f5a663311f18dc8c9802ae25ab1-20260612
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2060703113; Fri, 12 Jun 2026 15:53:43 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 15:53:42 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 15:53:42 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Deren.Wu@mediatek.com>, <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
	<litien.chang@mediatek.com>, <emery.hsin@mediatek.com>,
	<jb.tsai@mediatek.com>, Xiong <xiong.huang@mediatek.com>
Subject: [PATCH 19/20] wifi: mt76: mt7925: add MT7928 per-chip PCIe register definitions
Date: Fri, 12 Jun 2026 15:53:38 +0800
Message-ID: <20260612075339.2578327-4-jb.tsai@mediatek.com>
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

MT7928 maps PCIe MAC registers through base 0x74040000. Add
MT7928_PCIE_MAC_{INT_ENABLE,PM} macros and override dev->pcie_reg
at probe time for MT7928 hardware.

Signed-off-by: Xiong <xiong.huang@mediatek.com>
Signed-off-by: Emery Hsin <emery.hsin@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c  | 6 ++++++
 drivers/net/wireless/mediatek/mt76/mt7925/regs.h | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 719f53ddf1eb..1ad5847d4a8c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -473,6 +473,11 @@ static const struct mt792x_pcie_reg mt7925_pcie_reg = {
 	.pm = MT7925_PCIE_MAC_PM,
 };
 
+static const struct mt792x_pcie_reg mt7928_pcie_reg = {
+	.imask = MT7928_PCIE_MAC_INT_ENABLE,
+	.pm = MT7928_PCIE_MAC_PM,
+};
+
 static const struct mt792x_irq_map mt7925_irq_map = {
 	.host_irq_enable = MT_WFDMA0_HOST_INT_ENA,
 	.tx = {
@@ -609,6 +614,7 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
 	dev->pcie_reg = &mt7925_pcie_reg;
 
 	if (is_mt7928_hw) {
+		dev->pcie_reg = &mt7928_pcie_reg;
 		dev->irq_map = &mt7928_irq_map;
 		mdev->rev = 0x7928 << 16;
 	} else if (is_mt7927_hw) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/regs.h b/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
index af6291fc53cd..cb937d565a80 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
@@ -114,6 +114,11 @@
 #define MT7925_PCIE_MAC_INT_ENABLE	MT7925_PCIE_MAC(0x188)
 #define MT7925_PCIE_MAC_PM		MT7925_PCIE_MAC(0x194)
 
+#define MT7928_PCIE_MAC_BASE		0x74040000
+#define MT7928_PCIE_MAC(ofs)		(MT7928_PCIE_MAC_BASE + (ofs))
+#define MT7928_PCIE_MAC_INT_ENABLE	MT7928_PCIE_MAC(0x188)
+#define MT7928_PCIE_MAC_PM		MT7928_PCIE_MAC(0x194)
+
 #define MT_DMASHDL_LITE_BASE			0x20026200
 #define MT_DMASHDL_LITE(ofs)			(MT_DMASHDL_LITE_BASE + (ofs))
 #define MT_DMASHDL_LITE_MAIN_CONTROL		MT_DMASHDL_LITE(0x004)
-- 
2.45.2

