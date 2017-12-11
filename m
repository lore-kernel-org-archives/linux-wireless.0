Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0116.outbound.protection.outlook.com ([104.47.40.116]:59698
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750707AbdLKIG4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 03:06:56 -0500
Date: Mon, 11 Dec 2017 02:06:46 -0600
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, Wright Feng <Wright.Feng@cypress.com>,
        Stanley Hsu <Stanley.Hsu@cypress.com>,
        devicetree@vger.kernel.org
Subject: [PATCH V2] brcmfmac: Add sg parameters dts parsing
Message-ID: <20171211080640.GA132360@aremote07.aus.cypress.com> (sfid-20171211_090700_149359_8C14486B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

broken_sg_support, sd_head_align, and sd_sgentry_align are used in
brcmfmac code but not configurable in dts file. Add the parsing logic.
Now they can be configured like below in dts:
	brcm,broken_sg_support;
	brcm,sd_head_align = <4>;
	brcm,sd_sgentry_align = <4>;

Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index aee6e59..fd028b1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -39,6 +39,13 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
 		sdio->drive_strength = val;
 
+	sdio->broken_sg_support = of_property_read_bool(np,
+							"brcm,broken_sg_support");
+	if (of_property_read_u32(np, "brcm,sd_head_align", &val) == 0)
+		sdio->sd_head_align = (u16)val;
+	if (of_property_read_u32(np, "brcm,sd_sgentry_align", &val) == 0)
+		sdio->sd_sgentry_align = (u16)val;
+
 	/* make sure there are interrupts defined in the node */
 	if (!of_find_property(np, "interrupts", NULL))
 		return;
-- 
2.1.0
