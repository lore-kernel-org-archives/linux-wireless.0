Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:37796 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755175AbeCSBlA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Mar 2018 21:41:00 -0400
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
Subject: [PATCH net-next v2 1/2] brcmfmac: add new dt entries for SG SDIO settings
Date: Mon, 19 Mar 2018 08:40:31 +0700
Message-Id: <20180319014032.9394-2-alexey.roslyakov@gmail.com> (sfid-20180319_024226_405908_FAEFC24B)
In-Reply-To: <20180319014032.9394-1-alexey.roslyakov@gmail.com>
References: <20180319014032.9394-1-alexey.roslyakov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are 3 fields in SDIO settings (quirks) to workaround some of
the SG SDIO host particularities, i.e higher align requirements for
SG items.
All coding is done the long time ago, but there is no way to change the
driver behavior without patching the kernel.
Add missing devicetree entries.

Signed-off-by: Alexey Roslyakov <alexey.roslyakov@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index aee6e5937c41..14135752b659 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -30,14 +30,20 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	struct device_node *np = dev->of_node;
 	int irq;
 	u32 irqf;
-	u32 val;
 
 	if (!np || bus_type != BRCMF_BUSTYPE_SDIO ||
 	    !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
 		return;
 
-	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
-		sdio->drive_strength = val;
+	of_property_read_u32(np, "brcm,drive-strength", &sdio->drive_strength);
+
+	sdio->broken_sg_support =
+		of_property_read_bool(np, "brcm,broken-sg-support");
+
+	of_property_read_u16(np, "brcm,sd-head-align", &sdio->sd_head_align);
+
+	of_property_read_u16(np, "brcm,sd-sgentry-align",
+			     &sdio->sd_sgentry_align);
 
 	/* make sure there are interrupts defined in the node */
 	if (!of_find_property(np, "interrupts", NULL))
-- 
2.16.1
