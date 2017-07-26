Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49540 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751466AbdGZUqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:46:40 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 28/34] brcmfmac: Rename buscore->core for consistency
Date: Wed, 26 Jul 2017 21:25:51 +0100
Message-Id: <20170726202557.15632-29-ian@mnementh.co.uk> (sfid-20170726_230043_301923_8777F865)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid confusion with unrelated _buscore labels.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index bee377fcc48f..b06018e589bb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2475,14 +2475,12 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 
 static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 {
-	struct brcmf_core *buscore = bus->sdio_core;
-	u32 addr;
+	struct brcmf_core *core = bus->sdio_core;
 	unsigned long val;
 	int ret;
 
-	addr = buscore->base + __sd_reg(intstatus);
-
-	val = brcmf_sdiod_readl(bus->sdiodev, addr, &ret);
+	val = brcmf_sdiod_readl(bus->sdiodev, core->base + __sd_reg(intstatus),
+				&ret);
 	bus->sdcnt.f1regdata++;
 	if (ret != 0)
 		return ret;
@@ -2492,7 +2490,8 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 
 	/* Clear interrupts */
 	if (val) {
-		brcmf_sdiod_writel(bus->sdiodev, addr, val, &ret);
+		brcmf_sdiod_writel(bus->sdiodev,
+				   core->base + __sd_reg(intstatus), val, &ret);
 		bus->sdcnt.f1regdata++;
 		atomic_or(val, &bus->intstatus);
 	}
-- 
2.11.0
