Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2900B72623
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 07:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250727; cv=none; b=EYfrpWlLnxOaykM8bwAtSLpowyX7uAepS4v1xMn6yZzfG4+y0VH9JTaYB7b6I2pLLIgTYjLP/+intwfcRFNqYxKaYhm3CtkQJ+CIc1p/JPBQNBafMZemGW8euR+E4O1qJGgAgJXiiYtD7fENNwlXUvzrYdT91VRUATgS2Nbmeq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250727; c=relaxed/simple;
	bh=OEbiFow1BCW3hbMeEWhb/P6oAozZPJqgGh2RcJizXRk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qVDI7wH2ammQxGPOLCePC7uquU6T/nZcOtCMUgjK/imNY95Sv4bBQvwHfV4iqIi4QX+GYyo0VcWytz3FTBmGqtmN+rlJzU6mFQOWDEsFzs2Tvt8D5BCirStcSosBK9mZyhfFROThpgQWcHLdCghKrh6M7xDA3fzoE0UQxAIUxIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BImHrCvs; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BImHrCvs"
X-UUID: 96452194663311f1b1788b6acf885367-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=vW9s2uK4yqEEKil/Yz4y+xvIzPhvNufGHRY46xQ6Vk8=;
	b=BImHrCvsofQUfC3aaxvrK7NirDQEOm2bRlnjw8RHhHvuK4GgFRl9eooRmA7Ok7F1z5u+AmzhMmQHaOWgukxjjmNdoaWxXCM/kcxT7buhG5Cy9j0qj3zjrK9ybJrdFzy961IZ30oenPHPz2BZgDmz2MhAfP4wd7Rc31bmyHoRMJU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:4cd84d82-9d38-41d1-bbe4-864570552754,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e276073,CLOUDID:75d57654-902f-47df-afe3-f34f8d753c22,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|136|836|865|888|898,TC:-5,
	Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 96452194663311f1b1788b6acf885367-20260612
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 858183887; Fri, 12 Jun 2026 15:51:57 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 15:51:40 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 15:51:40 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Deren.Wu@mediatek.com>, <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
	<litien.chang@mediatek.com>, <emery.hsin@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH 10/20] wifi: mt76: mt792x: add tx_done ring to common DMA queue allocation
Date: Fri, 12 Jun 2026 15:51:36 +0800
Message-ID: <20260612075136.2577553-5-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260612075136.2577553-1-jb.tsai@mediatek.com>
References: <20260612075136.2577553-1-jb.tsai@mediatek.com>
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

Add a tx_done field to mt792x_dma_layout and extend
mt792x_dma_alloc_queues() to allocate the MT_RXQ_MCU_WA queue when
tx_done.ring_base is configured.

This is a preparation patch before enabling MT7928 PCIe support.

Signed-off-by: Emery Hsin <emery.hsin@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt792x.h     |  1 +
 drivers/net/wireless/mediatek/mt76/mt792x_dma.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index eacee63e13f3..b8dc7ce38c87 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -217,6 +217,7 @@ struct mt792x_dma_layout {
 	struct mt792x_dma_ring tx_data0;
 	struct mt792x_dma_ring tx_mcu;
 	struct mt792x_dma_ring tx_fwdl;
+	struct mt792x_dma_ring tx_done;
 	struct mt792x_dma_ring rx_data;
 	struct mt792x_dma_ring rx_mcu;
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
index b090ba9cd676..4d4c62bb0a77 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
@@ -122,6 +122,17 @@ int mt792x_dma_alloc_queues(struct mt792x_dev *dev,
 	if (ret)
 		return ret;
 
+	/* tx done */
+	if (layout->tx_done.ring_base) {
+		ret = mt76_queue_alloc(dev, &dev->mt76.q_rx[MT_RXQ_MCU_WA],
+				       layout->tx_done.qid,
+				       layout->tx_done.n_desc,
+				       MT_RX_BUF_SIZE,
+				       layout->tx_done.ring_base);
+		if (ret)
+			return ret;
+	}
+
 	/* rx event */
 	ret = mt76_queue_alloc(dev, &dev->mt76.q_rx[MT_RXQ_MCU],
 			       layout->rx_mcu.qid,
-- 
2.45.2

