Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33887 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1953169AbdDYWoA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 18:44:00 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH v5 6/9] NFC: trf7970a: Remove support for 'vin-voltage-override' DT property
Date: Tue, 25 Apr 2017 15:43:53 -0700
Message-Id: <20170425224356.11498-7-mgreer@animalcreek.com> (sfid-20170426_004426_643399_93AE0125)
In-Reply-To: <20170425224356.11498-1-mgreer@animalcreek.com>
References: <20170425224356.11498-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'vin-voltage-override' DT property is used by the trf7970a
driver to override the voltage presented to the driver by the
regulator subsystem.  This is unnecessary as properly specifying
the regulator chain via DT properties will accomplish the same
thing.  Therefore, remove support for 'vin-voltage-override'.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 Documentation/devicetree/bindings/net/nfc/trf7970a.txt |  2 --
 drivers/nfc/trf7970a.c                                 | 11 +----------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
index c627bbb3009e..57cb52c94783 100644
--- a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
+++ b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
@@ -13,7 +13,6 @@ Optional SoC Specific Properties:
 - pinctrl-names: Contains only one value - "default".
 - pintctrl-0: Specifies the pin control groups used for this controller.
 - autosuspend-delay: Specify autosuspend delay in milliseconds.
-- vin-voltage-override: Specify voltage of VIN pin in microvolts.
 - irq-status-read-quirk: Specify that the trf7970a being used has the
   "IRQ Status Read" erratum.
 - en2-rf-quirk: Specify that the trf7970a being used has the "EN2 RF"
@@ -40,7 +39,6 @@ Example (for ARM-based BeagleBone with TRF7970A on SPI1):
 		ti,enable-gpios = <&gpio2 2 GPIO_ACTIVE_LOW>,
 				  <&gpio2 5 GPIO_ACTIVE_LOW>;
 		vin-supply = <&ldo3_reg>;
-		vin-voltage-override = <5000000>;
 		vdd-io-supply = <&ldo2_reg>;
 		autosuspend-delay = <30000>;
 		irq-status-read-quirk;
diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index b9a90843ea35..5827ad111942 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2005,12 +2005,6 @@ static int trf7970a_get_autosuspend_delay(struct device_node *np)
 	return autosuspend_delay;
 }
 
-static int trf7970a_get_vin_voltage_override(struct device_node *np,
-		u32 *vin_uvolts)
-{
-	return of_property_read_u32(np, "vin-voltage-override", vin_uvolts);
-}
-
 static int trf7970a_probe(struct spi_device *spi)
 {
 	struct device_node *np = spi->dev.of_node;
@@ -2108,10 +2102,7 @@ static int trf7970a_probe(struct spi_device *spi)
 		goto err_destroy_lock;
 	}
 
-	ret = trf7970a_get_vin_voltage_override(np, &uvolts);
-	if (ret)
-		uvolts = regulator_get_voltage(trf->regulator);
-
+	uvolts = regulator_get_voltage(trf->regulator);
 	if (uvolts > 4000000)
 		trf->chip_status_ctrl = TRF7970A_CHIP_STATUS_VRS5_3;
 
-- 
2.12.0
