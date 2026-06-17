Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4A6388374;
	Wed, 17 Jun 2026 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781686740; cv=none; b=uGrBi4QVe+arTiEsxKvo7qCB2iDQOI3ZGYQxZ818tYsJoNNxpLdypAXPJIlz/b0iwzmtbLWAlSaiBaz3LTPlMxyql9jpw7lfbKTFpW5enZnrcVm+biE3/nSJnooeMOn5oD5c9MJKHJe0pkDiPPYUA6ock5hFHVkM88umtQj5T58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781686740; c=relaxed/simple;
	bh=E/8meAqvSmVT7bsSg+nPMnqVHiXD8NNzgHodgoZT0fw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A0YxM4ImF2Tp0UCiiTP0V0wQxl8H/qNsNth46Z3ZngpkIqnHm/3Bj8Oc/4DpfPket2OHD6+LF20eJSksRW9U3b+1rJZeALCaJAv08Ze3adJXmBCDiaUfvAaHp8bvA8HQaFJGqePNdKsYbZbeYQ1VCtxC1XL1nSCO/9qDXgYl11Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c298fa686a2a11f1aa26b74ffac11d73-20260617
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:48cddd83-78a0-4c33-8e81-2cec3d17d329,IP:0,U
	RL:0,TC:0,Content:-25,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-50
X-CID-META: VersionHash:e7bac3a,CLOUDID:9bae865c37f1649eb46bb4b5cb9f6c92,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:2,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c298fa686a2a11f1aa26b74ffac11d73-20260617
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 188936553; Wed, 17 Jun 2026 16:58:51 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	xiong.huang@mediatek.com,
	madhurkumar004@gmail.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH RESEND v3] wifi: mt76: mt7921: fix resource leak in probe error path
Date: Wed, 17 Jun 2026 16:58:45 +0800
Message-Id: <20260617085845.733989-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When pcim_iomap_region() or devm_kmemdup() fail, the code returns
directly without cleaning up previously allocated resources:
  - mt76_device allocated by mt76_alloc_device()
  - pci irq vectors allocated by pci_alloc_irq_vectors()
Fix this by jumping to the existing error cleanup path instead of
returning directly.
To avoid using an uninitialized variable in the error path, move the
dev initialization before the error checks.

Fixes: ee5bb35d2b83 ("wifi: mt76: mt7921: Replace deprecated PCI function")
Fixes: 222606f43b58 ("wifi: mt76: mt7921: handle MT7902 irq_map quirk with mutable copy")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

---
 Change in v3
  - Fix incorrect Fixes: tag as pointed out by Sean
  - Correct tag from unrelated phy/ti-pipe3 commit to the actual mt76 commit
    that introduced the resource leak
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 7a790ddf43bb..49a37185f056 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -343,11 +343,14 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, mdev);
 
+	dev = container_of(mdev, struct mt792x_dev, mt76);
+
 	regs =  pcim_iomap_region(pdev, 0, pci_name(pdev));
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
+	if (IS_ERR(regs)) {
+		ret = PTR_ERR(regs);
+		goto err_free_dev;
+	}
 
-	dev = container_of(mdev, struct mt792x_dev, mt76);
 	dev->fw_features = features;
 	dev->hif_ops = &mt7921_pcie_ops;
 	dev->irq_map = &irq_map;
@@ -359,8 +362,10 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 		/* MT7902 needs a mutable copy because wm2_complete_mask differs */
 		map = devm_kmemdup(&pdev->dev, &irq_map,
 				   sizeof(irq_map), GFP_KERNEL);
-		if (!map)
-			return -ENOMEM;
+		if (!map) {
+			ret = -ENOMEM;
+			goto err_free_dev;
+		}
 
 		map->rx.wm2_complete_mask = 0;
 		dev->irq_map = map;
-- 
2.25.1

