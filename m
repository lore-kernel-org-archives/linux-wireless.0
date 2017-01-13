Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34252 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbdAMFWX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 00:22:23 -0500
Received: by mail-pf0-f178.google.com with SMTP id 127so24910540pfg.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2017 21:22:22 -0800 (PST)
From: Matt Ranostay <matt@ranostay.consulting>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Cc: tony@atomide.com, Matt Ranostay <matt@ranostay.consulting>
Subject: [PATCH v2 1/2] devicetree: document vmmc-supply and mmc-pwrseq options
Date: Thu, 12 Jan 2017 21:22:17 -0800
Message-Id: <20170113052218.10534-2-matt@ranostay.consulting> (sfid-20170113_062238_908611_7EA1AC38)
In-Reply-To: <20170113052218.10534-1-matt@ranostay.consulting>
References: <20170113052218.10534-1-matt@ranostay.consulting>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: devicetree@vger.kernel.org
Signed-off-by: Matt Ranostay <matt@ranostay.consulting>
---
 Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
index 980b16df74c3..0854451ff91d 100644
--- a/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
+++ b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
@@ -1,4 +1,4 @@
-Marvell 8897/8997 (sd8897/sd8997/pcie8997) SDIO/PCIE devices
+Marvell 8787/8897/8997 (sd8787/sd8897/sd8997/pcie8997) SDIO/PCIE devices
 ------
 
 This node provides properties for controlling the Marvell SDIO/PCIE wireless device.
@@ -8,6 +8,7 @@ connects the device to the system.
 Required properties:
 
   - compatible : should be one of the following:
+	* "marvell,sd8787"
 	* "marvell,sd8897"
 	* "marvell,sd8997"
 	* "pci11ab,2b42"
@@ -34,6 +35,9 @@ Optional properties:
 		 so that the wifi chip can wakeup host platform under certain condition.
 		 during system resume, the irq will be disabled to make sure
 		 unnecessary interrupt is not received.
+  - vmmc-supply: a phandle of a regulator, supplying VCC to the card
+  - mmc-pwrseq:  phandle to the MMC power sequence node. See "mmc-pwrseq-*"
+		 for documentation of MMC power sequence bindings.
 
 Example:
 
@@ -46,6 +50,7 @@ so that firmware can wakeup host using this device side pin.
 &mmc3 {
 	status = "okay";
 	vmmc-supply = <&wlan_en_reg>;
+	mmc-pwrseq = <&wifi_pwrseq>;
 	bus-width = <4>;
 	cap-power-off-card;
 	keep-power-in-suspend;
-- 
2.10.2
