Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:35462 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaCVRsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 13:48:01 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so2881384eek.21
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 10:48:00 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 1/2] rtl8180: fix DMA register are written two times
Date: Sat, 22 Mar 2014 18:49:08 +0100
Message-Id: <1395510548-17034-1-git-send-email-andrea.merello@gmail.com> (sfid-20140322_184806_976347_AE348CF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hw DMA registers are written in rtl8180_init_hw function.
They are also written again just after calling rtl8180_init_hw.
There is no point in doing this twice.

Remove those redundant register writes from rtl8180_start.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 0b405b8..091eb2e 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -635,12 +635,6 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	if (ret)
 		goto err_free_rings;
 
-	rtl818x_iowrite32(priv, &priv->map->RDSAR, priv->rx_ring_dma);
-	rtl818x_iowrite32(priv, &priv->map->TBDA, priv->tx_ring[3].dma);
-	rtl818x_iowrite32(priv, &priv->map->THPDA, priv->tx_ring[2].dma);
-	rtl818x_iowrite32(priv, &priv->map->TNPDA, priv->tx_ring[1].dma);
-	rtl818x_iowrite32(priv, &priv->map->TLPDA, priv->tx_ring[0].dma);
-
 	ret = request_irq(priv->pdev->irq, rtl8180_interrupt,
 			  IRQF_SHARED, KBUILD_MODNAME, dev);
 	if (ret) {
-- 
1.8.3.2

