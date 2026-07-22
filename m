Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CDC472526
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708784; cv=none; b=E1QydFzfhSUDeZZO6sBeX2qR9W7QiMcVd0O8l21ggygpSFNgC5Y9e+VKl045wCjxZoCt2uGJ8X4/b5CU1WeDzVV6Aszgr8bqj6AyBEjunj27gVGf/Ris+lgusPedKuB3SFGGwKJFxLbtJo+x0jhL6ZFbAzH3saM0a70Qzr5QXn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708784; c=relaxed/simple;
	bh=nNLyRsGrcZOKqTfwWVi9KrJwh4PNrVmJgO6yPLtEfcI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9+70mPk+yqiFd0A0WpiZ0sLKN+tdykEAAuAxsR6obn2PD4YFRlhzfWEZSn0W1r4s7SGcKnk2xuwbl5sWWw9cFxiejqQqnP/D6G1hf4AG0fCcoLk1v/WTKoIUNaDqOZxMskshbdrynPC+okkEt86Q76E1GivQH3cIpHQxwDMrEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=KZASe+gd; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="KZASe+gd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0d56eM/xyqT7bQvJRDEFAT69djU8ATwXtPh+UJKu5Xg=; b=KZASe+gdr0EUVfjDBhN9zTfL/n
	aK6Ksfg+IVtlu9l0o04MBR6VPmQrLvwP9aFsfhdQxpKEZvLmdWL4e49MkrgDXPGqWxrxSH8tv+6hC
	itFkInnsMSVAPsgY4/Ff4xJ2k2VO7FnMWxjkGEs4UdSO2uOiekspy8ha+wQaQGfGyj/s=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHR-005AHx-1d
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:17 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 16/18] wifi: mt76: fix uninitialised RXDMAD_C descriptor info
Date: Wed, 22 Jul 2026 08:26:08 +0000
Message-ID: <20260722082610.2699628-16-nbd@nbd.name>
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

Unlike other WED-RRO queues, RXDMAD_C frames continue into the skb build
path, but mt76_dma_get_buf() skips the desc->info read for RRO queues, so
the uninitialised on-stack info was stored into skb->cb and passed to
rx_skb(); initialise it to zero.

Fixes: e50d4d710efd ("wifi: mt76: Add mt76_dma_get_rxdmad_c_buf utility routione")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 8fb40954c60d..ec0acd3ce774 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -1012,7 +1012,7 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 
 	while (done < budget) {
 		bool drop = false;
-		u32 info;
+		u32 info = 0;
 
 		if (check_ddone) {
 			if (q->tail == dma_idx)
-- 
2.53.0

