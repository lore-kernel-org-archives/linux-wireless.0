Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F17D381E8D
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785292490; cv=none; b=J1w4ooQtS9sloGf3aBtttXt9YfrU5LKhIxEnb6gs1A/wnoTeKPKJdVF6ONmTTDlbn8h01Mf+YKsRgsF+7ux7yKVBWJ9noJo6wVTYlFIGW00GoROFI12oVQdVDLTx/VHLhq4i8BN1LNWQK9OOF45CNAfMLU7NoDAllXGV178Y8Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785292490; c=relaxed/simple;
	bh=gOUp3dYv9qUBB1i7BfKvJcxmhd1ujbzmt8dA3Dnk0vA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gAqUC7LLzs8OWl2IirRv+fV7RfiWseg6tuE5gTxAs0kDwre4lDU2k9VhWDemsvaiOC0/HD8wMWkVHl/aTWf4Zl2753NnI4ukPy4CsIr4qZ1AlTA0MQrJ6w1xssicM8pWjDtjIYiwGLDrBt7I9dmehC12YOaXOJGSle8DWUA0/x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dIhUUKPS; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dIhUUKPS"
X-UUID: 0b2e9db48af611f18dc8c9802ae25ab1-20260729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=9DcD0sSPnp2SiyVg9MsYURsrC7AZd441q9aFWnz0NNY=;
	b=dIhUUKPS7DG/tvCo/0OR0hKr8AFdgbrqfdNh4c9EmdBGjYyhwHYPX1IhnH2naIgxm5otW41eYVmx23hbwhy+J+/dns68v5/20f090ECIpjh0ZNCrkZzE1juwwGvZcB5KQj3b4A7wEVqB+nRcDK3eDT1udXhAOClBaUahXWpDHj8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:c430bc82-4336-467d-82f6-f1d9e65ac91b,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:8a735a6,CLOUDID:06924812-5cba-4950-8af4-18a2a7cd79a4,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0b2e9db48af611f18dc8c9802ae25ab1-20260729
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 294460012; Wed, 29 Jul 2026 10:34:37 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 29 Jul 2026 10:34:36 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 29 Jul 2026 10:34:36 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <eason.lai@mediatek.com>
Subject: [PATCH v2 3/3] wifi: mt76: mt792x: Restrict TX page pool to MT8196  platform
Date: Wed, 29 Jul 2026 10:34:34 +0800
Message-ID: <20260729023434.1105517-4-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260729023434.1105517-1-eason.lai@mediatek.com>
References: <20260709075558.1654164-1-eason.lai@mediatek.com>
 <20260729023434.1105517-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The TX page pool optimization significantly improves performance on
MT8196 when IOMMU is enabled, but this benefit is platform-specific.
Restrict this feature to MT8196 where it has been tested and validated.

On MT8196 with IOMMU enabled, DMA mapping overhead increases
dramatically compared to IOMMU-disabled configurations:

dma_unmap_single() in mt76_connac_txp_skb_unmap_hw() (NAPI context):
- IOMMU disabled: 181.25 ns (avg over 20,000 calls)
- IOMMU enabled:  5216.19 ns (avg over 21,000 calls)

dma_map_single() in mt76_dma_tx_queue_skb() (workqueue context):
- IOMMU disabled: 880.20 ns (avg over 20,000 calls)
- IOMMU enabled:  2106.65 ns (avg over 20,000 calls)

The TX page pool mitigates this overhead by reusing DMA mappings,
but should only be enabled on platforms where it has been verified
to work correctly.

Signed-off-by: Eason Lai <eason.lai@mediatek.com>
--
v2: no change
---
 drivers/net/wireless/mediatek/mt76/mt792x_dma.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
index 9f052c56d1b2..833298b5d497 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
@@ -478,6 +478,7 @@ int mt792x_dma_tx_page_pool_init(struct mt792x_dev *dev)
 {
 	struct mt76_dev *mdev = &dev->mt76;
 	int i, ret, pool_count = 0;
+	bool is_mt8196;
 
 	if (!iommu_get_domain_for_dev(mdev->dma_dev))
 		return 0;
@@ -485,6 +486,13 @@ int mt792x_dma_tx_page_pool_init(struct mt792x_dev *dev)
 	if (!mt76_is_mmio(mdev))
 		return 0;
 
+	is_mt8196 = of_machine_is_compatible("mediatek,mt8196");
+	if (!is_mt8196) {
+		dev_info(mdev->dev, "Not MT8196 platform, TX page pool optimization disabled\n");
+		return 0;
+	}
+
+	dev_info(mdev->dev, "MT8196 platform detected, enabling TX page pool optimization\n");
 	mdev->tx_prealloc_enabled = true;
 
 	for (i = 0; i < ARRAY_SIZE(mdev->phy.q_tx); i++) {
-- 
2.45.2

