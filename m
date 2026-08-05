Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22503E557B
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 09:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785921944; cv=none; b=pGHNJjsDZeOM0s5rXB91thsBcUKE2aoT3IdAXBS0p+2+XyO0BZixYzUA8OKgYWVZ7J7ZQtLT9GHtVW29s5SXzTNJXyKpov22KalQ/g8gKXiFWy27fhKwQYbV31V9gyV63B+bM/fKStkkRBA9wTFeFFV02Q86iD59WTnZMWpa17k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785921944; c=relaxed/simple;
	bh=Bujq8FKQ39zs8CcDZDKNFEgbF6mXvsIpmIzGn6G7HDc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rb+vnHnF7ehOCZX8EE8IPsxS8fxf+JqCbMAbqbweW3LTfxqs/Xb0HfRbR6OhMpTtP5VtDMUiE6356BhmaN/qDSEh270otp3L1HJHRyV6KylaWFZ/+zW3NyBZ8Q0RIUReKAdZ4HxjQ+wPAI0jQCxaFWZvZhpN2VU0U0xsj/2bw/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=lkgb4/o0; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="lkgb4/o0"
X-UUID: 9cc3e8f690af11f18dc8c9802ae25ab1-20260805
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=i5cRPpnl2uXnQ3qW59/XVcsOfY3ZX3H++4K8xmTd6WU=;
	b=lkgb4/o0zDPPYAkbsBfhNT2NaWKgetdoL5NyK2vsaSFTMKePxOn4iUScM4GbuTxTT5tsD0qqAcE0OkFxnZXh7REKA1Z0xBbpgXSqBOboG+eyqlbX4D92NgmPzflsZFMuxE07rs3Zi7Eh6daaCdYTLoxE+J7eSO8fvEk+oKPkfhY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:1363023f-d826-4189-87e6-4d68a34c0f85,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:ab4bd443-e456-4e07-b769-8a7d4c457d3d,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9cc3e8f690af11f18dc8c9802ae25ab1-20260805
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 535384006; Wed, 05 Aug 2026 17:25:34 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 5 Aug 2026 17:25:33 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 5 Aug 2026 17:25:33 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <ck.chang@mediatek.com>,
	<eason.lai@mediatek.com>
Subject: [PATCH v1 1/2] wifi: mt76: mt7925: Fix coredump size not enough issue
Date: Wed, 5 Aug 2026 17:25:30 +0800
Message-ID: <20260805092531.1490746-2-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260805092531.1490746-1-eason.lai@mediatek.com>
References: <20260805092531.1490746-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: "ck.chang" <ck.chang@mediatek.com>

Original allocate coredump file size is not enough to save all coredump content, change the code to dynamic allocate the coredump file size which equal to the actual coredump content size.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: ck.chang <ck.chang@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/mac.c   | 44 +++++++++++++------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 101f571b027f..b5dd1b58618c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1571,11 +1571,14 @@ void mt7925_mac_reset_work(struct work_struct *work)
 
 void mt7925_coredump_work(struct work_struct *work)
 {
+	size_t hdr_len = sizeof(struct mt7925_mcu_rxd) + 8;
+	struct sk_buff_head local_list;
 	struct mt792x_dev *dev;
+	struct sk_buff *skb;
+	size_t total_sz = 0;
 	char *dump, *data;
 
-	dev = (struct mt792x_dev *)container_of(work, struct mt792x_dev,
-						coredump.work.work);
+	dev = (struct mt792x_dev *)container_of(work, struct mt792x_dev, coredump.work.work);
 
 	if (time_is_after_jiffies(dev->coredump.last_activity +
 				  4 * MT76_CONNAC_COREDUMP_TIMEOUT)) {
@@ -1584,35 +1587,48 @@ void mt7925_coredump_work(struct work_struct *work)
 		return;
 	}
 
-	dump = vzalloc(MT76_CONNAC_COREDUMP_SZ);
+	skb_queue_head_init(&local_list);
+	spin_lock_bh(&dev->mt76.lock);
+	skb_queue_splice_init(&dev->coredump.msg_list, &local_list);
+	spin_unlock_bh(&dev->mt76.lock);
+
+	skb_queue_walk(&local_list, skb) {
+		if (skb->len > hdr_len)
+			total_sz += skb->len - hdr_len;
+	}
+
+	if (!total_sz) {
+		skb_queue_purge(&local_list);
+		goto reset;
+	}
+
+	dump = vzalloc(total_sz);
 	data = dump;
 
 	while (true) {
-		struct sk_buff *skb;
-
-		spin_lock_bh(&dev->mt76.lock);
-		skb = __skb_dequeue(&dev->coredump.msg_list);
-		spin_unlock_bh(&dev->mt76.lock);
+		skb = __skb_dequeue(&local_list);
 
 		if (!skb)
 			break;
 
-		skb_pull(skb, sizeof(struct mt7925_mcu_rxd) + 8);
-		if (!dump || data + skb->len - dump > MT76_CONNAC_COREDUMP_SZ) {
+		if (skb->len <= hdr_len) {
 			dev_kfree_skb(skb);
 			continue;
 		}
 
-		memcpy(data, skb->data, skb->len);
-		data += skb->len;
+		skb_pull(skb, hdr_len);
+		if (dump) {
+			memcpy(data, skb->data, skb->len);
+			data += skb->len;
+		}
 
 		dev_kfree_skb(skb);
 	}
 
 	if (dump)
-		dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
-			      GFP_KERNEL);
+		dev_coredumpv(dev->mt76.dev, dump, total_sz, GFP_KERNEL);
 
+reset:
 	mt792x_reset(&dev->mt76);
 }
 
-- 
2.45.2

