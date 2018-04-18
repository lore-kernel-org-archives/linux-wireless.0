Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6278 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753919AbeDRLky (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:40:54 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 14/22] staging: wilc1000: remove the use of goto label in spi_cmd_complete()
Date: Wed, 18 Apr 2018 17:09:16 +0530
Message-ID: <1524051564-15497-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134119_307717_E96CFD33)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In spi_cmd_complete() remove the use of goto label '_error_'. Changes
were done to avoid the use of '_' in label name.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 6b392c9..3e3c774 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -527,8 +527,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 			if (wilc_spi_rx(wilc, &b[ix], nbytes)) {
 				dev_err(&spi->dev,
 					"Failed block read, bus err\n");
-				result = N_FAIL;
-				goto _error_;
+				return N_FAIL;
 			}
 
 			/*
@@ -537,8 +536,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 			if (!g_spi.crc_off && wilc_spi_rx(wilc, crc, 2)) {
 				dev_err(&spi->dev,
 					"Failed block crc read, bus err\n");
-				result = N_FAIL;
-				goto _error_;
+				return N_FAIL;
 			}
 
 			ix += nbytes;
@@ -604,7 +602,6 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 			sz -= nbytes;
 		}
 	}
-_error_:
 	return result;
 }
 
-- 
2.7.4
