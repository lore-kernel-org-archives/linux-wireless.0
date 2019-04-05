Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E2CAC282DA
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 23:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E6EF20700
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 23:52:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="CbSBObez"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfDEXvq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 19:51:46 -0400
Received: from vps.xff.cz ([195.181.215.36]:53634 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbfDEXvp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 19:51:45 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Apr 2019 19:51:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554507924; bh=PAJuJoAE0FDcTBQGXPNd5/MCZ/q2/gHxAF4V8V3I9ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbSBObezduiQZ/XIzoAZ1UuxDB8PYzyXBrXEFQof9WNFSz188LQbIcA24+iGIUaRD
         wzyN/c4mUiT77uHsFe+PPh8zrCdShbQtb6LqLMlLoZy/Tf8MRjZodHAIcpSb7tMfr/
         NmCsAx0Ev8nvOvcCkdj3e2Cp2VlFaI5k+ukQBs9s=
From:   megous@megous.com
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Ondrej Jirman <megous@megous.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Subject: [PATCH 07/12] arm64: dts: allwinner: orange-pi-3: Enable ethernet
Date:   Sat,  6 Apr 2019 01:45:09 +0200
Message-Id: <20190405234514.6183-8-megous@megous.com>
In-Reply-To: <20190405234514.6183-1-megous@megous.com>
References: <20190405234514.6183-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Orange Pi 3 has two regulators that power the Realtek RTL8211E.
According to the phy datasheet, both regulators need to be enabled
at the same time, but we can only specify a single phy-supply in
the DT.

This can be achieved by making one regulator depedning on the
other via vin-supply. While it's not a technically correct
description of the hardware, it achieves the purpose.

All values of RX/TX delay were tested exhaustively and a middle
one of the working values was chosen.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
index 644946749088..5270142527f5 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
@@ -15,6 +15,7 @@
 
 	aliases {
 		serial0 = &uart0;
+		ethernet0 = &emac;
 	};
 
 	chosen {
@@ -64,6 +65,27 @@
 		regulator-max-microvolt = <5000000>;
 		regulator-always-on;
 	};
+
+	/*
+	 * The board uses 2.5V RGMII signalling. Power sequence
+	 * to enable the phy is to enable GMAC-2V5 and GMAC-3V3 (aldo2)
+	 * power rails at the same time and to wait 100ms.
+	 */
+	reg_gmac_2v5: gmac-2v5 {
+                compatible = "regulator-fixed";
+                regulator-name = "gmac-2v5";
+                regulator-min-microvolt = <2500000>;
+                regulator-max-microvolt = <2500000>;
+                startup-delay-us = <100000>;
+                enable-active-high;
+                gpio = <&pio 3 6 GPIO_ACTIVE_HIGH>; /* PD6 */
+
+                /* The real parent of gmac-2v5 is reg_vcc5v, but we need
+                 * to enable two regulators to power the phy. This is one
+                 * way to achieve that.
+                 */
+                vin-supply = <&reg_aldo2>; /* GMAC-3V3 */
+        };
 };
 
 &cpu0 {
@@ -82,6 +104,17 @@
 	status = "okay";
 };
 
+&emac {
+	pinctrl-names = "default";
+	pinctrl-0 = <&ext_rgmii_pins>;
+	phy-mode = "rgmii";
+	phy-handle = <&ext_rgmii_phy>;
+	phy-supply = <&reg_gmac_2v5>;
+	allwinner,rx-delay-ps = <1500>;
+	allwinner,tx-delay-ps = <700>;
+	status = "okay";
+};
+
 &hdmi {
 	ddc-supply = <&reg_ddc>;
 	status = "okay";
@@ -93,6 +126,17 @@
 	};
 };
 
+&mdio {
+	ext_rgmii_phy: ethernet-phy@1 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <1>;
+
+		reset-gpios = <&pio 3 14 GPIO_ACTIVE_LOW>; /* PD14 */
+		reset-assert-us = <15000>;
+		reset-deassert-us = <40000>;
+	};
+};
+
 &mmc0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc0_pins>;
-- 
2.21.0

