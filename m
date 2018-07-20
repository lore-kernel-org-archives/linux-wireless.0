Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:30576 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbeGTMuQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 08:50:16 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linus.walleij@linaro.org>, Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 1/4] staging: wilc1000: remove gpio parameter from wilc_netdev_init()
Date: Fri, 20 Jul 2018 17:31:35 +0530
Message-ID: <1532088098-8483-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180720_140224_587975_3391487B)
In-Reply-To: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com>
References: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of passing the gpio as parameter to wilc_netdev_init() now
setting its value after finishing wilc_netdev_init() call. Avoided
passing of extra parameter to wilc_netdev_init().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 3 +--
 drivers/staging/wilc1000/wilc_sdio.c          | 4 ++--
 drivers/staging/wilc1000/wilc_spi.c           | 3 ++-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2f4bf8e..8f43a1f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1053,7 +1053,7 @@ static const struct net_device_ops wilc_netdev_ops = {
 };
 
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
-		     int gpio, const struct wilc_hif_func *ops)
+		     const struct wilc_hif_func *ops)
 {
 	int i, ret;
 	struct wilc_vif *vif;
@@ -1066,7 +1066,6 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 	*wilc = wl;
 	wl->io_type = io_type;
-	wl->gpio = gpio;
 	wl->hif_func = ops;
 	INIT_LIST_HEAD(&wl->txq_head.list);
 	INIT_LIST_HEAD(&wl->rxq_head.list);
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 4ab43f9..7a2fc79 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -118,14 +118,14 @@ static int linux_sdio_probe(struct sdio_func *func,
 	}
 
 	dev_dbg(&func->dev, "Initializing netdev\n");
-	ret = wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, gpio,
-			       &wilc_hif_sdio);
+	ret = wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, &wilc_hif_sdio);
 	if (ret) {
 		dev_err(&func->dev, "Couldn't initialize netdev\n");
 		return ret;
 	}
 	sdio_set_drvdata(func, wilc);
 	wilc->dev = &func->dev;
+	wilc->gpio = gpio;
 
 	dev_info(&func->dev, "Driver Initializing success\n");
 	return 0;
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 6475263..69b2c3c 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -113,12 +113,13 @@ static int wilc_bus_probe(struct spi_device *spi)
 	if (gpio < 0)
 		gpio = GPIO_NUM;
 
-	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI, GPIO_NUM, &wilc_hif_spi);
+	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI, &wilc_hif_spi);
 	if (ret)
 		return ret;
 
 	spi_set_drvdata(spi, wilc);
 	wilc->dev = &spi->dev;
+	wilc->gpio = gpio;
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 765681a..add76c7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -174,7 +174,7 @@ void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc);
 void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
-		     int gpio, const struct wilc_hif_func *ops);
+		     const struct wilc_hif_func *ops);
 void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode);
 
-- 
2.7.4
