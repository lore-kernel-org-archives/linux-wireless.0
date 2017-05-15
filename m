Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35233 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934604AbdEOUOP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 16:14:15 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: kvalo@codeaurora.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/1] dt-binding: net: wireless: fix node name in the BCM43xx example
Date: Mon, 15 May 2017 22:13:56 +0200
Message-Id: <20170515201356.26384-2-martin.blumenstingl@googlemail.com> (sfid-20170515_221432_876614_8F1263A8)
In-Reply-To: <20170515201356.26384-1-martin.blumenstingl@googlemail.com>
References: <20170515201356.26384-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The example in the BCM43xx documentation uses "brcmf" as node name.
However, wireless devices should be named "wifi" instead. Fix this to
make sure that .dts authors can simply use the documentation as
reference (or simply copy the node from the documentation and then
adjust only the board specific bits).

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
index 5dbf169cd81c..590f622188de 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
@@ -31,7 +31,7 @@ mmc3: mmc@01c12000 {
 	non-removable;
 	status = "okay";
 
-	brcmf: bcrmf@1 {
+	brcmf: wifi@1 {
 		reg = <1>;
 		compatible = "brcm,bcm4329-fmac";
 		interrupt-parent = <&pio>;
-- 
2.13.0
