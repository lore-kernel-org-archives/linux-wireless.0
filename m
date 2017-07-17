Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:46196 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdGQQmF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:42:05 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 26/29] brcmfmac: General cleaning up. whitespace and comments fix.
Date: Mon, 17 Jul 2017 17:16:34 +0100
Message-Id: <20170717161637.4652-27-ian@mnementh.co.uk> (sfid-20170717_184209_179075_2BD3B6CE)
In-Reply-To: <20170717161637.4652-1-ian@mnementh.co.uk>
References: <20170717161637.4652-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tidy code, fix whitespace, remove useless debug code.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 24 ++++++++++++++--------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index aa43e3087908..96f4416ad106 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -642,11 +642,13 @@ static struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 
 static void pkt_align(struct sk_buff *p, int len, int align)
 {
-	uint datalign;
-	datalign = (unsigned long)(p->data);
+	uint datalign = (unsigned long)(p->data);
+
 	datalign = roundup(datalign, (align)) - datalign;
+
 	if (datalign)
 		skb_pull(p, datalign);
+
 	__skb_trim(p, len);
 }
 
@@ -2460,10 +2462,9 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 
 static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 {
-	struct brcmf_sdio_dev *sdiodev;
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
 	unsigned long flags;
 
-	sdiodev = bus->sdiodev;
 	if (sdiodev->oob_irq_requested) {
 		spin_lock_irqsave(&sdiodev->irq_en_lock, flags);
 		if (!sdiodev->irq_en && !atomic_read(&bus->ipend)) {
@@ -3754,15 +3755,23 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
 	u32 val, rev;
 
 	val = brcmf_sdiod_readl(sdiodev, addr, NULL);
+
+	/* Force 4339 chips over rev2 to use the same ID */
+	/* This is borderline tolerable whilst there is only two exceptions */
+	/* But could be handled better */
 	if ((sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
-	     sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
-	    addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
+		sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
+		addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
+
 		rev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
+
 		if (rev >= 2) {
 			val &= ~CID_ID_MASK;
 			val |= BRCM_CC_4339_CHIP_ID;
 		}
+
 	}
+
 	return val;
 }
 
@@ -3793,9 +3802,6 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	sdiodev = bus->sdiodev;
 	sdio_claim_host(sdiodev->func[1]);
 
-	pr_debug("F1 signature read @0x18000000=0x%4x\n",
-		 brcmf_sdiod_readl(sdiodev, SI_ENUM_BASE, NULL));
-
 	/*
 	 * Force PLL off until brcmf_chip_attach()
 	 * programs PLL control regs
-- 
2.11.0
