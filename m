Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:23392 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbeGTMuU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 08:50:20 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linus.walleij@linaro.org>, Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 2/4] staging: wilc1000: rename variable from 'gpio' to 'gpio_irq'
Date: Fri, 20 Jul 2018 17:31:36 +0530
Message-ID: <1532088098-8483-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180720_140228_809290_ED4FB07B)
In-Reply-To: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com>
References: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename from 'gpio' to 'gpio_irq', so its inlcude the information about
the purpose of GPIO.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 17 +++++++++--------
 drivers/staging/wilc1000/wilc_sdio.c          |  2 +-
 drivers/staging/wilc1000/wilc_spi.c           |  2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8f43a1f..74e7180 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -127,9 +127,9 @@ static int init_irq(struct net_device *dev)
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wl = vif->wilc;
 
-	if ((gpio_request(wl->gpio, "WILC_INTR") == 0) &&
-	    (gpio_direction_input(wl->gpio) == 0)) {
-		wl->dev_irq_num = gpio_to_irq(wl->gpio);
+	if ((gpio_request(wl->gpio_irq, "WILC_INTR") == 0) &&
+	    (gpio_direction_input(wl->gpio_irq) == 0)) {
+		wl->dev_irq_num = gpio_to_irq(wl->gpio_irq);
 	} else {
 		ret = -1;
 		netdev_err(dev, "could not obtain gpio for WILC_INTR\n");
@@ -140,13 +140,14 @@ static int init_irq(struct net_device *dev)
 					      isr_bh_routine,
 					      IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 					      "WILC_IRQ", dev) < 0) {
-		netdev_err(dev, "Failed to request IRQ GPIO: %d\n", wl->gpio);
-		gpio_free(wl->gpio);
+		netdev_err(dev, "Failed to request IRQ GPIO: %d\n",
+			   wl->gpio_irq);
+		gpio_free(wl->gpio_irq);
 		ret = -1;
 	} else {
 		netdev_dbg(dev,
 			   "IRQ request succeeded IRQ-NUM= %d on GPIO: %d\n",
-			   wl->dev_irq_num, wl->gpio);
+			   wl->dev_irq_num, wl->gpio_irq);
 	}
 
 	return ret;
@@ -160,7 +161,7 @@ static void deinit_irq(struct net_device *dev)
 	/* Deinitialize IRQ */
 	if (wilc->dev_irq_num) {
 		free_irq(wilc->dev_irq_num, wilc);
-		gpio_free(wilc->gpio);
+		gpio_free(wilc->gpio_irq);
 	}
 }
 
@@ -651,7 +652,7 @@ static int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif)
 			goto fail_locks;
 		}
 
-		if (wl->gpio >= 0 && init_irq(dev)) {
+		if (wl->gpio_irq >= 0 && init_irq(dev)) {
 			ret = -EIO;
 			goto fail_locks;
 		}
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 7a2fc79..07cb8a6 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -125,7 +125,7 @@ static int linux_sdio_probe(struct sdio_func *func,
 	}
 	sdio_set_drvdata(func, wilc);
 	wilc->dev = &func->dev;
-	wilc->gpio = gpio;
+	wilc->gpio_irq = gpio;
 
 	dev_info(&func->dev, "Driver Initializing success\n");
 	return 0;
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 69b2c3c..8cb286b 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -119,7 +119,7 @@ static int wilc_bus_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, wilc);
 	wilc->dev = &spi->dev;
-	wilc->gpio = gpio;
+	wilc->gpio_irq = gpio;
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index add76c7..74c2a17 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -121,7 +121,7 @@ struct wilc {
 	const struct wilc_hif_func *hif_func;
 	int io_type;
 	int mac_status;
-	int gpio;
+	int gpio_irq;
 	bool initialized;
 	int dev_irq_num;
 	int close;
-- 
2.7.4
