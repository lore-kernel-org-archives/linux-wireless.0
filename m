Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33958352038
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708780; cv=none; b=PLDGxOMg8ow8Qdso3cz7KvcH/gX6m04fGbtqfJFFHrlMFPwkJTnqRA2jMnBaLcfOl+PEbBg7APBLbXf7gwBsCA2IYojwJRiaCr8tMJ7Y2MmZA3b1A3PamXCQzh59Olq93G/gAtWIpApKVNtYA8IzJ7AKgRpQmyZIxiimg8mjiYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708780; c=relaxed/simple;
	bh=UQSKjQyrJxDuhSIlBZAhIPqi4FkF7sJk1v86LcElz9o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc0YtDh+d/Qjg36VOloHHGt64CV0ca7cE9uKver0auXfRrmVGsJmapVs/x0YFNSw1lYrHU8+uKlgCMXEfQDdQS7BXXxiHu8+pTEkfThAHLnnku6+lXlt1ORtoQJhGqBpKAPfhyBK+USKsH+kIBclvRulS+Yd9eH4G0NOXK/Ikp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=UEbv5s57; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="UEbv5s57"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=D4hJEkYFhQ2hat3owAgg7Yjcda2ZOoVNRZ9o63WadLg=; b=UEbv5s57u0ImL/XEYD5XBCdkYF
	/JvoeJludBFVKEr4z/e67Plfthr0FYO17+wOQzpGkwnZAofXO0TH0fqQLwYIVPCqyrVcZEr/xXBbH
	TCVN1qiBFNdAA7QGb3PK+bjxRz1Jm2rGuu3juc+tJsH6JrNOXVpt7s7xCdcBmTrMDdZw=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHP-005AHx-0h
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 02/18] wifi: mt76: check txfree done event on the WED hw path
Date: Wed, 22 Jul 2026 08:25:54 +0000
Message-ID: <20260722082610.2699628-2-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722082610.2699628-1-nbd@nbd.name>
References: <20260722082610.2699628-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rex Lu <rex.lu@mediatek.com>

Check the txfree done event DW1 bit 15 when WED is enabled, to avoid
the driver reading a txfree done event before WED has finished reading
it. No need to check this flag on WED v2, otherwise SER will occur.

The bit position was previously defined as MT_DMA_CTL_BURST, which is
unused; rename it to match its function on the txfree ring.

Fixes: 83eafc9251d6 ("wifi: mt76: mt7996: add wed tx support")
Signed-off-by: Rex Lu <rex.lu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 7 +++++++
 drivers/net/wireless/mediatek/mt76/dma.h | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index e21b91557c8a..8fb40954c60d 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -611,6 +611,13 @@ mt76_dma_dequeue(struct mt76_dev *dev, struct mt76_queue *q, bool flush,
 			q->desc[idx].ctrl |= cpu_to_le32(MT_DMA_CTL_DMA_DONE);
 		else if (!(q->desc[idx].ctrl & cpu_to_le32(MT_DMA_CTL_DMA_DONE)))
 			return NULL;
+		/* on WED v3 the M_DONE bit signals that WED is done reading
+		 * the txfree descriptor; WED v2 does not set it
+		 */
+		else if (dev->mmio.wed.version > 2 &&
+			 mt76_queue_is_wed_tx_free(q) &&
+			 !(q->desc[idx].ctrl & cpu_to_le32(MT_DMA_CTL_M_DONE)))
+			return NULL;
 	}
 done:
 	q->tail = (q->tail + 1) % q->ndesc;
diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index 2a0226c83f3c..a2cf82cfdaaa 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -11,7 +11,7 @@
 
 #define MT_DMA_CTL_SD_LEN1		GENMASK(13, 0)
 #define MT_DMA_CTL_LAST_SEC1		BIT(14)
-#define MT_DMA_CTL_BURST		BIT(15)
+#define MT_DMA_CTL_M_DONE		BIT(15)
 #define MT_DMA_CTL_SD_LEN0		GENMASK(29, 16)
 #define MT_DMA_CTL_LAST_SEC0		BIT(30)
 #define MT_DMA_CTL_DMA_DONE		BIT(31)
-- 
2.53.0

