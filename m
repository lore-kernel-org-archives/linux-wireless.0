Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:58440 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755818AbeDYRTk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:40 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 07/21] staging: wilc1000: simplified if conditions in spi_data_write()
Date: Wed, 25 Apr 2018 22:48:12 +0530
Message-ID: <1524676706-13179-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191944_632492_433F8831)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to simplify the if conditions logic in spi_data_write().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index ac8df38b..2aaa5fd 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -614,28 +614,23 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 	 */
 	ix = 0;
 	do {
-		if (sz <= DATA_PKT_SZ)
+		if (sz <= DATA_PKT_SZ) {
 			nbytes = sz;
-		else
+			order = 0x3;
+		} else {
 			nbytes = DATA_PKT_SZ;
+			if (ix == 0)
+				order = 0x1;
+			else
+				order = 0x02;
+		}
 
 		/*
 		 * Write command
 		 */
 		cmd = 0xf0;
-		if (ix == 0) {
-			if (sz <= DATA_PKT_SZ)
-
-				order = 0x3;
-			else
-				order = 0x1;
-		} else {
-			if (sz <= DATA_PKT_SZ)
-				order = 0x3;
-			else
-				order = 0x2;
-		}
 		cmd |= order;
+
 		if (wilc_spi_tx(wilc, &cmd, 1)) {
 			dev_err(&spi->dev,
 				"Failed data block cmd write, bus error...\n");
-- 
2.7.4
