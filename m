Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7F0351C2F
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785292487; cv=none; b=EWIHHKpChy/kvNYivtMcgWTQNvC6Nqagu55llODJ+4RGjfEfCc9gTafZyemjvg6sSrQttw7gPx8BGXWsjSqzVvUv2S0OG4g1i3Prkkc4paoMiyDKKXIUUDznVi1uAsGa2F98v+GOwuFyBSj9+sIXsGoXR+fwi1TkJsTL+LI4xi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785292487; c=relaxed/simple;
	bh=ppom0XuBlRxcRQZm4Nfz4mfY3ytaSKM/fh4Azzp8/2U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rBlygUAmgTwzlzMrsfH9Ysc6sDP+YfBBq+91h9qf4vkc6VoJ8uB362OjJACpDCWncvRHOwY9v07XyqApKrWtJ7n+TNCDcHHkeGiWa9jlB1pMn9dMWXWkAmO0w7NWSbD83REnW9oS/ySCE0hAPbDvgRWY4i5QhT5LEJt/bPu7pW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=SNKHEHVS; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SNKHEHVS"
X-UUID: 0af786ee8af611f1b1788b6acf885367-20260729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Jf5mcjTpThnadCWsJSHncu4mJ7hxyVR4N2aX3+blOuo=;
	b=SNKHEHVSctDpN7mPvSR/UWOEn5EASxstqMNIGZ5QAmaQdXLOB43ESF9FCEZF/53yQ6cVcm59utZMcI/afFQCyN0/iwa73A812juMQAp41fTlHZz/kcB2ZdueNAomAsJ5ZQCCOdRbyTnGKbBJLhyXA8faKV5Nyo4G2EStjH80nWc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:a4c7e620-a954-4898-9e74-0b10a4d50758,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:8a735a6,CLOUDID:d65d963b-0769-4b9a-8185-266a4e6c9483,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0af786ee8af611f1b1788b6acf885367-20260729
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1077690302; Wed, 29 Jul 2026 10:34:37 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
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
Subject: [PATCH v2 1/3] wifi: mt76: Separate skb and ptr pointers in mt76_txwi_cache
Date: Wed, 29 Jul 2026 10:34:32 +0800
Message-ID: <20260729023434.1105517-2-eason.lai@mediatek.com>
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

Split the skb/ptr union into separate skb and ptr fields to
support keeping both the SKB pointer and page pool pointer
at the same time.

Also add skip_unmap flag to tx_info.buf to handle cases where DMA
unmapping should be skipped.

Signed-off-by: Eason Lai <eason.lai@mediatek.com>
---
v2: revert to original naming for less intrusive
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 15 +++++++++++----
 drivers/net/wireless/mediatek/mt76/mt76.h |  6 ++----
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 1658c37835cf..57632656eafa 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -43,6 +43,7 @@ mt76_alloc_rxwi(struct mt76_dev *dev)
 	if (!t)
 		return NULL;
 
+	t->skb = NULL;
 	t->ptr = NULL;
 	return t;
 }
@@ -84,8 +85,11 @@ mt76_get_txwi(struct mt76_dev *dev)
 {
 	struct mt76_txwi_cache *t = __mt76_get_txwi(dev);
 
-	if (t)
+	if (t) {
+		t->skb = NULL;
+		t->ptr = NULL;
 		return t;
+	}
 
 	return mt76_alloc_txwi(dev);
 }
@@ -716,6 +720,7 @@ mt76_dma_tx_queue_skb(struct mt76_phy *phy, struct mt76_queue *q,
 			goto unmap;
 
 		tx_info.buf[n].addr = addr;
+		tx_info.buf[n].skip_unmap = false;
 		tx_info.buf[n++].len = iter->len;
 	}
 	tx_info.nbuf = n;
@@ -740,9 +745,11 @@ mt76_dma_tx_queue_skb(struct mt76_phy *phy, struct mt76_queue *q,
 				tx_info.info, tx_info.skb, t);
 
 unmap:
-	for (n--; n > 0; n--)
-		dma_unmap_single(dev->dma_dev, tx_info.buf[n].addr,
-				 tx_info.buf[n].len, DMA_TO_DEVICE);
+	for (n--; n > 0; n--) {
+		if (!tx_info.buf[n].skip_unmap)
+			dma_unmap_single(dev->dma_dev, tx_info.buf[n].addr,
+					 tx_info.buf[n].len, DMA_TO_DEVICE);
+	}
 
 free:
 #ifdef CONFIG_NL80211_TESTMODE
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 0090e16e8f78..ec679d12a2af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -446,10 +446,8 @@ struct mt76_txwi_cache {
 	struct list_head list;
 	dma_addr_t dma_addr;
 
-	union {
-		struct sk_buff *skb;
-		void *ptr;
-	};
+	struct sk_buff *skb;
+	void *ptr;
 
 	u8 qid;
 	u8 phy_idx;
-- 
2.45.2

