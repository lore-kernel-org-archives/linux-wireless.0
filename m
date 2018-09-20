Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12437 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731240AbeITMHB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:07:01 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 23/29] staging: wilc1000: remove unnecessary memset in sdio_init() & wilc_spi_init()
Date: Thu, 20 Sep 2018 11:53:34 +0530
Message-ID: <1537424620-6982-24-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_082626_754180_32B0ECA5)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup changes to avoid unnecessary setting 'wilc->bus_data' value to
zero as the buffer was allocated using kzalloc().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 4 +---
 drivers/staging/wilc1000/wilc_spi.c  | 3 ---
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 7ef047c..ca351c9 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -689,10 +689,8 @@ static int sdio_init(struct wilc *wilc, bool resume)
 	int loop, ret;
 	u32 chipid;
 
-	if (!resume) {
-		memset(sdio_priv, 0, sizeof(struct wilc_sdio));
+	if (!resume)
 		sdio_priv->irq_gpio = wilc->dev_irq_num;
-	}
 
 	/**
 	 *      function 0 csa enable
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 2559cf0..cef127b 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -838,12 +838,9 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 		return 1;
 	}
 
-	memset(spi_priv, 0, sizeof(struct wilc_spi));
-
 	/*
 	 * configure protocol
 	 */
-	spi_priv->crc_off = 0;
 
 	/*
 	 * TODO: We can remove the CRC trials if there is a definite
-- 
2.7.4
