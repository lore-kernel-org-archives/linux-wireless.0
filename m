Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F81395243
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897302; cv=none; b=iJLW+CbYJbce792uNPClRk9K9fDqfDuzv4os+rcUlhjtKCKrENP89lD4xSWkeS8JYkM2GhZRsEGefV1ke5Lk+aPHJkpXbJOZNiWJcVsNzRNcM6DAlTDDkXQZPcuJTj2emZ6RbzTnG05ba0WAEnMmq0qzG5m3rDGtQ7Hfasknwww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897302; c=relaxed/simple;
	bh=kvt9ZHvAYn6VdL0B7U08aHsBbPnk1hoz5BexiesWK/8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYxk5q/ecIl+YO0lWczoL/75JBTnlbpxnD+e8r6nsk8pd3GUrw0Hkr1zYeDWUNkHf7R9QwNdMsNGjXg+dgj/LjP/0VT39Y8UWS3LQs8UM3MmdX0VetiK/WrRcpLTxcpj24Yno/+9g5cvyLMVFj33Ejfa7X0vQ2XkUK3mBa9WNFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=ZibT52eF; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ZibT52eF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0ihwEGGZPAiwVn+yAnd3wLi2mN0MPgT5rdkgrgJsS4c=; b=ZibT52eFWAS/vifeBNMZ8oGYy+
	Q9w/hpXxdshUbYjzeWonhOCfOhX/X2GWgoGbrh2nOwwmnhsc1t21xmWVrWpqlIpTyveeifXPy0+yp
	ffscA5MinteKqzpV3zjrZqAR7aov6bpWTeCrRpmcX+Bi/10nbS4aybHkyaemWxKkvdg8=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK6-006LeO-01
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:18 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 14/29] wifi: mt76: only consume the WO drop bit on WED v2 devices
Date: Fri, 24 Jul 2026 12:47:58 +0000
Message-ID: <20260724124813.3961474-14-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RX path is handled by the WO MCU only on WED v2 hardware. On WED
v3 the same buf1 bit does not carry drop information, so evaluating it
there causes spurious RX drops.

Fixes: e4d2b8bcac11 ("wifi: mt76: drop the incorrect scatter and gather frame")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 1658c37835cf..a67880a9281c 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -547,8 +547,13 @@ mt76_dma_get_buf(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 		t->ptr = NULL;
 
 		mt76_put_rxwi(dev, t);
-		if (drop)
+#ifdef CONFIG_NET_MEDIATEK_SOC_WED
+		/* the WO MCU owns the RX path only on WED v2, on newer
+		 * versions this buf1 bit carries no drop information
+		 */
+		if (drop && dev->mmio.wed.version == 2)
 			*drop |= !!(buf1 & MT_DMA_CTL_WO_DROP);
+#endif
 	} else {
 		dma_sync_single_for_cpu(dev->dma_dev, e->dma_addr[0],
 				SKB_WITH_OVERHEAD(q->buf_size),
-- 
2.53.0

