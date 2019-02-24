Return-Path: <SRS0=tIsG=Q7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0D9C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 14:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 472C5206B6
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 14:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbfBXOFN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Feb 2019 09:05:13 -0500
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:52476 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbfBXOFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Feb 2019 09:05:12 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D2D91596;
        Sun, 24 Feb 2019 06:05:12 -0800 (PST)
Received: from why.lan (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3166C3F690;
        Sun, 24 Feb 2019 06:05:09 -0800 (PST)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/4] dt-bindings/marvell-8xxx: Allow wake-up interrupt to be placed in a separate node
Date:   Sun, 24 Feb 2019 14:04:23 +0000
Message-Id: <20190224140426.3267-2-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190224140426.3267-1-marc.zyngier@arm.com>
References: <20190224140426.3267-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The DT binding for the PCI version of the Marvell 8xxx wifi devices
is pretty broken (the fact that a PCI device requires a DT binding
is quite telling on its own).

The binding allows the description of a wake-up interrupt as a sideband
signal, allowing the wifi device to wake-up the system. So far, so good.
Until you realise that placing an interrupt in the PCI device DT node
has a specific meaning, and applies to the actual PCI function, and
not some random sideband stuff. This is of course in total violation
of the OF specification (IEEE Std 1275-1994), but hey, who cares.

Let's thus change the binding to be somewhat compatible with the spec,
by placing the wake-up interrupt in a subnode called "wake-up". This
still is an optional property, but a recommended one for PCI devices.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 .../bindings/net/wireless/marvell-8xxx.txt    | 23 ++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
index 9bf9bbac16e2..f9340ca37047 100644
--- a/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
+++ b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
@@ -33,10 +33,16 @@ Optional properties:
 		 this interrupt number. during system suspend, the irq will be enabled
 		 so that the wifi chip can wakeup host platform under certain condition.
 		 during system resume, the irq will be disabled to make sure
-		 unnecessary interrupt is not received.
+		 unnecessary interrupt is not received. For PCI devices, it
+		 is recommended that this property is placed in a "wake-up"
+		 sub-node in order to limit the ambiguity with PCI legacy
+		 interrupts.
   - vmmc-supply: a phandle of a regulator, supplying VCC to the card
   - mmc-pwrseq:  phandle to the MMC power sequence node. See "mmc-pwrseq-*"
 		 for documentation of MMC power sequence bindings.
+  - wake-up:	 a subnode containing the interrupt specifier for a wake-up
+		 interrupt. This is the recommended configuration for PCI
+		 devices.
 
 Example:
 
@@ -66,3 +72,18 @@ so that firmware can wakeup host using this device side pin.
 		marvell,wakeup-pin = <3>;
 	};
 };
+
+&pci_rootport {
+	mvl_wifi: wifi@0,0 {
+		compatible = "pci1b4b,2b42";
+		reg = <0x83010000 0x0 0x00000000 0x0 0x00100000
+		       0x83010000 0x0 0x00100000 0x0 0x00100000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&wlan_host_wake_l>;
+		wake-up {
+			interrupt-parent = <&gpio0>;
+			interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
+			wakeup-source;
+		};
+	};
+};
-- 
2.20.1

