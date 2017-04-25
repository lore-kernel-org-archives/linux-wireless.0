Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49533 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1431350AbdDYSkq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 14:40:46 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH v4 7/9] NFC: trf7970a: Enable pins are active high not active low
Date: Tue, 25 Apr 2017 11:40:34 -0700
Message-Id: <20170425184036.1212-8-mgreer@animalcreek.com> (sfid-20170425_204109_337293_8F9F17CE)
In-Reply-To: <20170425184036.1212-1-mgreer@animalcreek.com>
References: <20170425184036.1212-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The example DTS code for the trf7970a sets the GPIOs for the EN
and EN2 pins to active low when they are really active high so
correct the error.

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 Documentation/devicetree/bindings/net/nfc/trf7970a.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
index 57cb52c94783..a24a93a4b010 100644
--- a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
+++ b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
@@ -36,8 +36,8 @@ Example (for ARM-based BeagleBone with TRF7970A on SPI1):
 		spi-max-frequency = <2000000>;
 		interrupt-parent = <&gpio2>;
 		interrupts = <14 0>;
-		ti,enable-gpios = <&gpio2 2 GPIO_ACTIVE_LOW>,
-				  <&gpio2 5 GPIO_ACTIVE_LOW>;
+		ti,enable-gpios = <&gpio2 2 GPIO_ACTIVE_HIGH>,
+				  <&gpio2 5 GPIO_ACTIVE_HIGH>;
 		vin-supply = <&ldo3_reg>;
 		vdd-io-supply = <&ldo2_reg>;
 		autosuspend-delay = <30000>;
-- 
2.12.0
