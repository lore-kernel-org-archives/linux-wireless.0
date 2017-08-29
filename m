Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39816 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751274AbdH2Vnc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 17:43:32 -0400
From: Antony Antony <antony@phenome.org>
To: Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Icenowy Zheng <icenowy@aosc.io>, devicetree@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Antony Antony <antony@phenome.org>
Subject: [PATCH] Documentation: dt-binding: net: wireless: add bcm43430-fmac
Date: Tue, 29 Aug 2017 23:43:09 +0200
Message-Id: <20170829214309.34466-1-antony@phenome.org> (sfid-20170829_234335_464838_B05AB4A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device tree binding documentation for Broadcom BCM43430
AMPAK AP6212A has this chip.

e.g
compatible = "brcm,bcm43430-fmac";

NanoPi NEO Plus2 has an AMPAK AP6212A WiFi module
with BCM43430 rev=1 inside.
brcmf_chip_recognition found AXI chip: BCM43430, rev=1
brcmf_ops_sdio_probe sdio vendor ID: 0x02d0
brcmf_ops_sdio_probe sdio device ID: 0xa9a6

Signed-off-by: Antony Antony <antony@phenome.org>
---
 Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
 NanoPi Neo Plus2 Kernel DT propsed patch
 https://patchwork.kernel.org/patch/9925387/

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
index 590f622..9107e1a 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
@@ -6,7 +6,9 @@ connects the device to the system.
 
 Required properties:
 
- - compatible : Should be "brcm,bcm4329-fmac".
+ - compatible : should be one of the following:
+	* "brcm,bcm4329-fmac"
+	* "brcm,bcm43430-fmac"
 
 Optional properties:
  - brcm,drive-strength : drive strength used for SDIO pins on device in mA
-- 
2.9.3
