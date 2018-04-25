Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:58440 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755236AbeDYRTd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:33 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 04/21] staging: wilc1000: remove 'cmd' variable in wilc_spi functions
Date: Wed, 25 Apr 2018 22:48:09 +0530
Message-ID: <1524676706-13179-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191942_690104_7F6DCF80)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the 'cmd' variable in wilc_spi.c. Instead of
using cmd now passing the command directly.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index c980d3b..ac8df38b 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -742,7 +742,6 @@ static int wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	int result;
-	u8 cmd = CMD_DMA_EXT_WRITE;
 
 	/*
 	 * has to be greated than 4
@@ -750,7 +749,7 @@ static int wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 	if (size <= 4)
 		return 0;
 
-	result = spi_cmd_complete(wilc, cmd, addr, NULL, size, 0);
+	result = spi_cmd_complete(wilc, CMD_DMA_EXT_WRITE, addr, NULL, size, 0);
 	if (result != N_OK) {
 		dev_err(&spi->dev,
 			"Failed cmd, write block (%08x)...\n", addr);
@@ -795,13 +794,12 @@ static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 static int wilc_spi_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
-	u8 cmd = CMD_DMA_EXT_READ;
 	int result;
 
 	if (size <= 4)
 		return 0;
 
-	result = spi_cmd_complete(wilc, cmd, addr, buf, size, 0);
+	result = spi_cmd_complete(wilc, CMD_DMA_EXT_READ, addr, buf, size, 0);
 	if (result != N_OK) {
 		dev_err(&spi->dev, "Failed cmd, read block (%08x)...\n", addr);
 		return 0;
-- 
2.7.4
