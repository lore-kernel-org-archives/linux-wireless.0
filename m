Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:61442 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZCYFiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 01:38:09 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1066397muf.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 22:38:05 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 2/2] p54spi: fix p54_upload_firmware
Date: Wed, 25 Mar 2009 08:30:16 +0300
Message-Id: <1237959016-17311-2-git-send-email-jcmvbkbc@gmail.com> (sfid-20090325_063817_048282_7C0E9678)
In-Reply-To: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com>
References: <>
 <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Instead of firmware itself p54_upload_firmware was sending to the device content of struct firmware
 and the following random garbage. Notice '&' before priv->firmware->data at p54spi_spi_write.
 But simple removing of '&' sign triggered BUG_ON at dma_cache_maint. Thus kmemdup - kfree workaround.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/wireless/p54/p54spi.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index d13268f..4ef57c5 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -265,8 +265,15 @@ static int p54spi_upload_firmware(struct ieee80211_hw *dev)
 		p54spi_write32(priv, SPI_ADRS_DMA_WRITE_BASE,
 			       cpu_to_le32(fw_addr));
 
-		p54spi_spi_write(priv, SPI_ADRS_DMA_DATA,
-				 &priv->firmware->data, _fw_len);
+		{
+			void *fw = kmemdup(priv->firmware->data, _fw_len, GFP_KERNEL);
+			if (fw)
+			{
+				p54spi_spi_write(priv, SPI_ADRS_DMA_DATA,
+						 fw, _fw_len);
+				kfree(fw);
+			}
+		}
 
 		fw_len -= _fw_len;
 		fw_addr += _fw_len;
-- 
1.5.4.3

