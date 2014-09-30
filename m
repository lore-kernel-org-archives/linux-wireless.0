Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:50850 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaI3K4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 06:56:00 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
	devicetree@vger.kernel.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V4] bcma: use chipcommon node from DT for SoC GPIO chip
Date: Tue, 30 Sep 2014 12:55:48 +0200
Message-Id: <1412074548-14614-1-git-send-email-zajec5@gmail.com> (sfid-20140930_125605_291796_46A5B13A)
In-Reply-To: <1412072546-3529-1-git-send-email-zajec5@gmail.com>
References: <1412072546-3529-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow us to define GPIO-attached devices (LEDs, buttons) in
the the device tree.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This is based on top of
[PATCH v6] bcma: register bcma as device tree driver
that I hope will reach wireless-next git tree.

V2: Describe axi chilren and make gpio a child of chipcommon core.
V3: Make chipcommon a GPIO controller (avoid extra sub-child)
    Speed up finding OF node in driver_gpio.c
V4: Simplify setting of_node in driver_gpio.c
---
 Documentation/devicetree/bindings/bus/bcma.txt | 12 ++++++++++++
 drivers/bcma/driver_gpio.c                     |  4 ++++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/bus/bcma.txt b/Documentation/devicetree/bindings/bus/bcma.txt
index e9070c1..62a4834 100644
--- a/Documentation/devicetree/bindings/bus/bcma.txt
+++ b/Documentation/devicetree/bindings/bus/bcma.txt
@@ -9,6 +9,11 @@ Required properties:
 The cores on the AXI bus are automatically detected by bcma with the
 memory ranges they are using and they get registered afterwards.
 
+The top-level axi bus may contain children representing attached cores
+(devices). This is needed since some hardware details can't be auto
+detected (e.g. IRQ numbers). Also some of the cores may be responsible
+for extra things, e.g. ChipCommon providing access to the GPIO chip.
+
 Example:
 
 	axi@18000000 {
@@ -17,4 +22,11 @@ Example:
 		ranges = <0x00000000 0x18000000 0x00100000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
+
+		chipcommon {
+			reg = <0x00000000 0x1000>;
+
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
 	};
diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 8ea497c..57ce5fe 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -218,6 +218,10 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 #if IS_BUILTIN(CONFIG_BCM47XX)
 	chip->to_irq		= bcma_gpio_to_irq;
 #endif
+#if IS_BUILTIN(CONFIG_OF)
+	if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
+		chip->of_node	= cc->core->dev.of_node;
+#endif
 	switch (cc->core->bus->chipinfo.id) {
 	case BCMA_CHIP_ID_BCM5357:
 	case BCMA_CHIP_ID_BCM53572:
-- 
1.8.4.5

