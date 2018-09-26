Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88AD6C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B4D1214C5
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B4D1214C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbeIZQip (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:38:45 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39495 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbeIZQip (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:38:45 -0400
X-IronPort-AV: E=Sophos;i="5.54,306,1534834800"; 
   d="scan'208";a="21366822"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 26 Sep 2018 03:26:29 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 CHN-SV-EXCH01.mchp-main.com (10.10.76.37) with Microsoft SMTP Server id
 14.3.352.0; Wed, 26 Sep 2018 03:26:28 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 17/19] wilc: updated DT device binding for wilc device
Date:   Wed, 26 Sep 2018 15:55:23 +0530
Message-ID: <1537957525-11467-18-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Added the device tree binding document from '/driver/staging/wilc1000/'
to '/Documentation/devicetree/bindings/net/wireless/' folder.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../net/wireless/microchip,wilc1000,sdio.txt       | 32 ++++++++++++++++++++++
 .../net/wireless/microchip,wilc1000,spi.txt        | 26 ++++++++++++++++++
 2 files changed, 58 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/microchip,wilc1000,sdio.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/microchip,wilc1000,spi.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000,sdio.txt b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000,sdio.txt
new file mode 100644
index 0000000..4f7d1c2
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000,sdio.txt
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
diff --git a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000,spi.txt b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000,spi.txt
new file mode 100644
index 0000000..87db87b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000,spi.txt
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
-- 
2.7.4

