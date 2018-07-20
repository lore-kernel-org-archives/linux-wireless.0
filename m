Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:42047 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbeGTMuY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 08:50:24 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linus.walleij@linaro.org>, Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 3/4] staging: wilc1000: change compatible string from atmel to microchip
Date: Fri, 20 Jul 2018 17:31:37 +0530
Message-ID: <1532088098-8483-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180720_140232_303225_61A9874B)
In-Reply-To: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com>
References: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 'microchip' in compatible string instead of 'atmel', also replace '_'
with '-' before the module. Remove 'wilc1000' prefix from device table
name.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 11 +++++++++--
 drivers/staging/wilc1000/wilc_spi.c  | 14 +++++++-------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 07cb8a6..afb91e5 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -199,21 +199,28 @@ static int wilc_sdio_resume(struct device *dev)
 	return 0;
 }
 
+static const struct of_device_id wilc_of_match[] = {
+	{ .compatible = "microchip,wilc1000-sdio", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, wilc_of_match);
+
 static const struct dev_pm_ops wilc_sdio_pm_ops = {
 	.suspend = wilc_sdio_suspend,
 	.resume = wilc_sdio_resume,
 };
 
-static struct sdio_driver wilc1000_sdio_driver = {
+static struct sdio_driver wilc_sdio_driver = {
 	.name		= SDIO_MODALIAS,
 	.id_table	= wilc_sdio_ids,
 	.probe		= linux_sdio_probe,
 	.remove		= linux_sdio_remove,
 	.drv = {
 		.pm = &wilc_sdio_pm_ops,
+		.of_match_table = wilc_of_match,
 	}
 };
-module_driver(wilc1000_sdio_driver,
+module_driver(wilc_sdio_driver,
 	      sdio_register_driver,
 	      sdio_unregister_driver);
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 8cb286b..7d4c7c5 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -130,21 +130,21 @@ static int wilc_bus_remove(struct spi_device *spi)
 	return 0;
 }
 
-static const struct of_device_id wilc1000_of_match[] = {
-	{ .compatible = "atmel,wilc_spi", },
-	{}
+static const struct of_device_id wilc_of_match[] = {
+	{ .compatible = "microchip,wilc1000-spi", },
+	{ /* sentinel */ }
 };
-MODULE_DEVICE_TABLE(of, wilc1000_of_match);
+MODULE_DEVICE_TABLE(of, wilc_of_match);
 
-static struct spi_driver wilc1000_spi_driver = {
+static struct spi_driver wilc_spi_driver = {
 	.driver = {
 		.name = MODALIAS,
-		.of_match_table = wilc1000_of_match,
+		.of_match_table = wilc_of_match,
 	},
 	.probe =  wilc_bus_probe,
 	.remove = wilc_bus_remove,
 };
-module_spi_driver(wilc1000_spi_driver);
+module_spi_driver(wilc_spi_driver);
 MODULE_LICENSE("GPL");
 
 static int wilc_spi_tx(struct wilc *wilc, u8 *b, u32 len)
-- 
2.7.4
