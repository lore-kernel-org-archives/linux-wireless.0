Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:34819 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755201AbeCSBlF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Mar 2018 21:41:05 -0400
From: Alexey Roslyakov <alexey.roslyakov@gmail.com>
To: andrew@lunn.ch, kvalo@codeaurora.org, robh+dt@kernel.org,
        mark.rutland@arm.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Alexey Roslyakov <alexey.roslyakov@gmail.com>
Subject: [PATCH net-next v2 2/2] dt: bindings: add new dt entries for brcmfmac
Date: Mon, 19 Mar 2018 08:40:32 +0700
Message-Id: <20180319014032.9394-3-alexey.roslyakov@gmail.com> (sfid-20180319_024156_697963_77DCBD2B)
In-Reply-To: <20180319014032.9394-1-alexey.roslyakov@gmail.com>
References: <20180319014032.9394-1-alexey.roslyakov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case if the host has higher align requirements for SG items, allow
setting device-specific aligns for scatterlist items.

Signed-off-by: Alexey Roslyakov <alexey.roslyakov@gmail.com>
---
 Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
index 86602f264dce..187b8c1b52a7 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
@@ -17,6 +17,11 @@ Optional properties:
 	When not specified the device will use in-band SDIO interrupts.
  - interrupt-names : name of the out-of-band interrupt, which must be set
 	to "host-wake".
+ - brcm,broken-sg-support : boolean flag to indicate that the SDIO host
+	controller has higher align requirement than 32 bytes for each
+	scatterlist item.
+ - brcm,sd-head-align : alignment requirement for start of data buffer.
+ - brcm,sd-sgentry-align : length alignment requirement for each sg entry.
 
 Example:
 
-- 
2.16.1
