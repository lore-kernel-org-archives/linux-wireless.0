Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0111.outbound.protection.outlook.com ([104.47.33.111]:40304
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750957AbdLAH4I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 02:56:08 -0500
Date: Fri, 1 Dec 2017 01:55:50 -0600
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, brcm80211-dev-list@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        Wright Feng <Wright.Feng@cypress.com>,
        Stanley Hsu <Stanley.Hsu@cypress.com>
Subject: [PATCH] brcmfmac: Add sg parameters dts parsing
Message-ID: <20171201075542.GA31376@aremote07.aus.cypress.com> (sfid-20171201_085632_716102_4FAAA70E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

broken_sg_support, sd_head_align, and sd_sgentry_align are used in
brcmfmac code but not configurable in dts file. Add the parsing logic.
Now they can be configured like below in dts:
	brcm,broken_sg_support;
	brcm,sd_head_align = /bits/ 16 <4>;
	brcm,sd_sgentry_align = /bits/ 16 <4>;

Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index aee6e59..023f8ea 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -30,14 +30,22 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	struct device_node *np = dev->of_node;
 	int irq;
 	u32 irqf;
-	u32 val;
+	u32 val32;
+	u16 val16;
 
 	if (!np || bus_type != BRCMF_BUSTYPE_SDIO ||
 	    !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
 		return;
 
-	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
-		sdio->drive_strength = val;
+	if (of_property_read_u32(np, "brcm,drive-strength", &val32) == 0)
+		sdio->drive_strength = val32;
+
+	sdio->broken_sg_support = of_property_read_bool(np,
+							"brcm,broken_sg_support");
+	if (of_property_read_u16(np, "brcm,sd_head_align", &val16) == 0)
+		sdio->sd_head_align = val16;
+	if (of_property_read_u16(np, "brcm,sd_sgentry_align", &val16) == 0)
+		sdio->sd_sgentry_align = val16;
 
 	/* make sure there are interrupts defined in the node */
 	if (!of_find_property(np, "interrupts", NULL))
-- 
2.1.0
