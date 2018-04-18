Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6278 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753727AbeDRLk7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:40:59 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 16/22] staging: wilc1000: remove the use of goto label in wilc_spi_read_int()
Date: Wed, 18 Apr 2018 17:09:18 +0530
Message-ID: <1524051564-15497-17-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134101_796868_94DC9344)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In wilc_spi_read_int() remove the use of goto label '_fail_'. Changes
are done to avoid the use of '_' in label name.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 57e4f11..1db2814 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -946,7 +946,7 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 	if (!ret) {
 		dev_err(&spi->dev,
 			"Failed read WILC_VMM_TO_HOST_SIZE ...\n");
-		goto _fail_;
+		return ret;
 	}
 	tmp = (byte_cnt >> 2) & IRQ_DMA_WD_CNT_MASK;
 
@@ -976,7 +976,6 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 
 	*int_status = tmp;
 
-_fail_:
 	return ret;
 }
 
-- 
2.7.4
