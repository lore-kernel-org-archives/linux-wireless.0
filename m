Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49954 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdGQQrd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:47:33 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 28/29] brcmfmac: Rename buscore->core for consistency
Date: Mon, 17 Jul 2017 17:16:36 +0100
Message-Id: <20170717161637.4652-29-ian@mnementh.co.uk> (sfid-20170717_184737_986456_CAB8BF20)
In-Reply-To: <20170717161637.4652-1-ian@mnementh.co.uk>
References: <20170717161637.4652-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid confusion with unrelated _buscore labels.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 87eca68d6e4f..15f2acfc626d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2466,14 +2466,12 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 
 static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 {
-	struct brcmf_core *buscore = bus->sdio_core;
+	struct brcmf_core *core = bus->sdio_core;
 	u32 addr;
 	unsigned long val;
 	int ret;
 
-	addr = buscore->base + __sd_reg(intstatus);
-
-	val = brcmf_sdiod_readl(bus->sdiodev, addr, &ret);
+	val = brcmf_sdiod_readl(bus->sdiodev, core->base + __sd_reg(intstatus), &ret);
 	bus->sdcnt.f1regdata++;
 	if (ret != 0)
 		return ret;
@@ -2483,7 +2481,8 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 
 	/* Clear interrupts */
 	if (val) {
-		brcmf_sdiod_writel(bus->sdiodev, addr, val, &ret);
+		brcmf_sdiod_writel(bus->sdiodev, core->base + __sd_reg(intstatus),
+					val, &ret);
 		bus->sdcnt.f1regdata++;
 		atomic_or(val, &bus->intstatus);
 	}
-- 
2.11.0
