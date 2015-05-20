Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:43046 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbbETMJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 08:09:55 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/6] brcmfmac: allow device tree node without 'interrupts' property
Date: Wed, 20 May 2015 14:09:47 +0200
Message-ID: <1432123792-4155-2-git-send-email-arend@broadcom.com> (sfid-20150520_141000_592090_C97A5D3E)
In-Reply-To: <1432123792-4155-1-git-send-email-arend@broadcom.com>
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As described in the device tree bindings for 'brcm,bcm4329-fmac'
nodes, the interrupts property is optional. So adding a check
for the presence of this property before attempting to parse
and map the interrupt. If not present or parsing fails return
and fallback to in-band sdio interrupt.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/of.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/of.c b/drivers/net/wireless/brcm80211/brcmfmac/of.c
index c824570..03f35e0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/of.c
@@ -39,10 +39,16 @@ void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
 	if (!sdiodev->pdata)
 		return;
 
+	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
+		sdiodev->pdata->drive_strength = val;
+
+	/* make sure there are interrupts defined in the node */
+	if (!of_find_property(np, "interrupts", NULL))
+		return;
+
 	irq = irq_of_parse_and_map(np, 0);
 	if (!irq) {
 		brcmf_err("interrupt could not be mapped\n");
-		devm_kfree(dev, sdiodev->pdata);
 		return;
 	}
 	irqf = irqd_get_trigger_type(irq_get_irq_data(irq));
@@ -50,7 +56,4 @@ void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->pdata->oob_irq_supported = true;
 	sdiodev->pdata->oob_irq_nr = irq;
 	sdiodev->pdata->oob_irq_flags = irqf;
-
-	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
-		sdiodev->pdata->drive_strength = val;
 }
-- 
1.9.1

