Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:40136 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbeGTMu2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 08:50:28 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linus.walleij@linaro.org>, Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 4/4] staging: wilc1000: use descriptor-based interface for GPIO
Date: Fri, 20 Jul 2018 17:31:38 +0530
Message-ID: <1532088098-8483-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180720_140236_373271_C6113619)
In-Reply-To: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com>
References: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now making use of descriptor-based interface instead of integer-based
interface for IRQ GPIO.
Added device tree binding reference for WILC SDIO and SPI interface
module. Also moved the code to free gpio descriptor in module remove
as the reference was fetched in probe function.
Updated the TODO file

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/TODO                      |  4 ---
 drivers/staging/wilc1000/linux_wlan.c              | 40 +++++++++-------------
 .../staging/wilc1000/microchip,wilc1000,sdio.txt   | 32 +++++++++++++++++
 .../staging/wilc1000/microchip,wilc1000,spi.txt    | 26 ++++++++++++++
 drivers/staging/wilc1000/wilc_sdio.c               | 23 +++++++++----
 drivers/staging/wilc1000/wilc_spi.c                | 23 +++++++++----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h      |  3 +-
 7 files changed, 108 insertions(+), 43 deletions(-)
 create mode 100644 drivers/staging/wilc1000/microchip,wilc1000,sdio.txt
 create mode 100644 drivers/staging/wilc1000/microchip,wilc1000,spi.txt

diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
index 725bede..3d82bb0 100644
--- a/drivers/staging/wilc1000/TODO
+++ b/drivers/staging/wilc1000/TODO
@@ -3,7 +3,3 @@ TODO:
 - make spi and sdio components coexist in one build
 - support soft-ap and p2p mode
 - support resume/suspend function
-- convert all uses of the old GPIO API from <linux/gpio.h> to the
-  GPIO descriptor API in <linux/gpio/consumer.h> and look up GPIO
-  lines from device tree, ACPI or board files, board files should
-  use <linux/gpio/machine.h>
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 74e7180..64c5d69 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/irq.h>
-#include <linux/gpio.h>
 #include <linux/kthread.h>
 #include <linux/firmware.h>
 #include <linux/netdevice.h>
@@ -127,28 +126,23 @@ static int init_irq(struct net_device *dev)
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wl = vif->wilc;
 
-	if ((gpio_request(wl->gpio_irq, "WILC_INTR") == 0) &&
-	    (gpio_direction_input(wl->gpio_irq) == 0)) {
-		wl->dev_irq_num = gpio_to_irq(wl->gpio_irq);
-	} else {
-		ret = -1;
+	ret = gpiod_direction_input(wl->gpio_irq);
+	if (ret) {
 		netdev_err(dev, "could not obtain gpio for WILC_INTR\n");
+		return ret;
 	}
 
-	if (ret != -1 && request_threaded_irq(wl->dev_irq_num,
-					      isr_uh_routine,
-					      isr_bh_routine,
-					      IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-					      "WILC_IRQ", dev) < 0) {
-		netdev_err(dev, "Failed to request IRQ GPIO: %d\n",
-			   wl->gpio_irq);
-		gpio_free(wl->gpio_irq);
-		ret = -1;
-	} else {
-		netdev_dbg(dev,
-			   "IRQ request succeeded IRQ-NUM= %d on GPIO: %d\n",
-			   wl->dev_irq_num, wl->gpio_irq);
-	}
+	wl->dev_irq_num = gpiod_to_irq(wl->gpio_irq);
+
+	ret = request_threaded_irq(wl->dev_irq_num, isr_uh_routine,
+				   isr_bh_routine,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   "WILC_IRQ", dev);
+	if (ret < 0)
+		netdev_err(dev, "Failed to request IRQ\n");
+	else
+		netdev_dbg(dev, "IRQ request succeeded IRQ-NUM= %d\n",
+			   wl->dev_irq_num);
 
 	return ret;
 }
@@ -159,10 +153,8 @@ static void deinit_irq(struct net_device *dev)
 	struct wilc *wilc = vif->wilc;
 
 	/* Deinitialize IRQ */
-	if (wilc->dev_irq_num) {
+	if (wilc->dev_irq_num)
 		free_irq(wilc->dev_irq_num, wilc);
-		gpio_free(wilc->gpio_irq);
-	}
 }
 
 void wilc_mac_indicate(struct wilc *wilc)
@@ -652,7 +644,7 @@ static int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif)
 			goto fail_locks;
 		}
 
-		if (wl->gpio_irq >= 0 && init_irq(dev)) {
+		if (wl->gpio_irq && init_irq(dev)) {
 			ret = -EIO;
 			goto fail_locks;
 		}
diff --git a/drivers/staging/wilc1000/microchip,wilc1000,sdio.txt b/drivers/staging/wilc1000/microchip,wilc1000,sdio.txt
new file mode 100644
index 0000000..4f7d1c2
--- /dev/null
+++ b/drivers/staging/wilc1000/microchip,wilc1000,sdio.txt
@@ -0,0 +1,32 @@
+* Microchip WILC wireless SDIO device
+
+The wilc1000 chips can be connected via SDIO. The node is used to specifiy
+child node to the SDIO controller that connects the device to the system.
+
+Required properties:
+- compatible	:	Should be "microchip,wilc1000-spi"
+- irq-gpios	:	Connect to a host IRQ
+- reg		:	Slot ID used in the controller
+
+Optional:
+- bus-width	:	Number of data lines wired up the slot. Default 1 bit.
+
+
+Examples:
+mmc1: mmc@fc000000 {
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_mmc1_clk_cmd_dat0 &pinctrl_mmc1_dat1_3>;
+		non-removable;
+		vmmc-supply = <&vcc_mmc1_reg>;
+		vqmmc-supply = <&vcc_3v3_reg>;
+		status = "okay";
+
+		wilc_sdio@0 {
+			compatible = "microchip,wilc1000-sdio";
+			irq-gpios = <&pioC 27 0>;
+			status = "okay";
+			reg = <0>;
+			bus-width = <4>;
+		}
+	};
+}
diff --git a/drivers/staging/wilc1000/microchip,wilc1000,spi.txt b/drivers/staging/wilc1000/microchip,wilc1000,spi.txt
new file mode 100644
index 0000000..87db87b
--- /dev/null
+++ b/drivers/staging/wilc1000/microchip,wilc1000,spi.txt
@@ -0,0 +1,26 @@
+* Microchip WILC wireless SPI device
+
+The wilc1000 chips can be connected via SPI. This document describes
+the binding for the SPI connected module.
+
+Required properties:
+- compatible		: Should be "microchip,wilc1000-spi"
+- spi-max-frequency	: Maximum SPI clocking speed of device in Hz
+- reg			: Chip select address of device
+- irq-gpios		: Connect to a host IRQ
+
+
+Examples:
+
+spi1: spi@fc018000 {
+		cs-gpios = <&pioB 21 0>;
+		status = "okay";
+
+		wilc_spi@0 {
+			compatible = "microchip,wilc1000-spi";
+			spi-max-frequency = <48000000>;
+			reg = <0>;
+			irq-gpios = <&pioC 27 0>;
+			status = "okay";
+		};
+};
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index afb91e5..8a47147 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -6,7 +6,7 @@
  */
 
 #include <linux/mmc/sdio_func.h>
-#include <linux/of_gpio.h>
+#include <linux/mmc/host.h>
 
 #include "wilc_wfi_netdevice.h"
 
@@ -108,13 +108,17 @@ static int linux_sdio_probe(struct sdio_func *func,
 			    const struct sdio_device_id *id)
 {
 	struct wilc *wilc;
-	int gpio, ret;
+	int ret;
+	struct gpio_desc *gpio = NULL;
 
-	gpio = -1;
 	if (IS_ENABLED(CONFIG_WILC1000_HW_OOB_INTR)) {
-		gpio = of_get_gpio(func->dev.of_node, 0);
-		if (gpio < 0)
-			gpio = GPIO_NUM;
+		gpio = gpiod_get(&func->dev, "irq", GPIOD_IN);
+		if (IS_ERR(gpio)) {
+			/* get the GPIO descriptor from hardcode GPIO number */
+			gpio = gpio_to_desc(GPIO_NUM);
+			if (!gpio)
+				dev_err(&func->dev, "failed to get irq gpio\n");
+		}
 	}
 
 	dev_dbg(&func->dev, "Initializing netdev\n");
@@ -133,7 +137,12 @@ static int linux_sdio_probe(struct sdio_func *func,
 
 static void linux_sdio_remove(struct sdio_func *func)
 {
-	wilc_netdev_cleanup(sdio_get_drvdata(func));
+	struct wilc *wilc = sdio_get_drvdata(func);
+
+	/* free the GPIO in module remove */
+	if (wilc->gpio_irq)
+		gpiod_put(wilc->gpio_irq);
+	wilc_netdev_cleanup(wilc);
 }
 
 static int sdio_reset(struct wilc *wilc)
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 7d4c7c5..fa9371b 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/spi/spi.h>
-#include <linux/of_gpio.h>
 
 #include "wilc_wfi_netdevice.h"
 
@@ -106,12 +105,17 @@ static u8 crc7(u8 crc, const u8 *buffer, u32 len)
 
 static int wilc_bus_probe(struct spi_device *spi)
 {
-	int ret, gpio;
+	int ret;
 	struct wilc *wilc;
-
-	gpio = of_get_gpio(spi->dev.of_node, 0);
-	if (gpio < 0)
-		gpio = GPIO_NUM;
+	struct gpio_desc *gpio;
+
+	gpio = gpiod_get(&spi->dev, "irq", GPIOD_IN);
+	if (IS_ERR(gpio)) {
+		/* get the GPIO descriptor from hardcode GPIO number */
+		gpio = gpio_to_desc(GPIO_NUM);
+		if (!gpio)
+			dev_err(&spi->dev, "failed to get the irq gpio\n");
+	}
 
 	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI, &wilc_hif_spi);
 	if (ret)
@@ -126,7 +130,12 @@ static int wilc_bus_probe(struct spi_device *spi)
 
 static int wilc_bus_remove(struct spi_device *spi)
 {
-	wilc_netdev_cleanup(spi_get_drvdata(spi));
+	struct wilc *wilc = spi_get_drvdata(spi);
+
+	/* free the GPIO in module remove */
+	if (wilc->gpio_irq)
+		gpiod_put(wilc->gpio_irq);
+	wilc_netdev_cleanup(wilc);
 	return 0;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 74c2a17..331a971 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -7,6 +7,7 @@
 #include <net/cfg80211.h>
 #include <net/ieee80211_radiotap.h>
 #include <linux/if_arp.h>
+#include <linux/gpio/consumer.h>
 
 #include "host_interface.h"
 #include "wilc_wlan.h"
@@ -121,7 +122,7 @@ struct wilc {
 	const struct wilc_hif_func *hif_func;
 	int io_type;
 	int mac_status;
-	int gpio_irq;
+	struct gpio_desc *gpio_irq;
 	bool initialized;
 	int dev_irq_num;
 	int close;
-- 
2.7.4
