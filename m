Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:60098 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932427AbdHVLp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:45:29 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 22/30] brcmfmac: Rename buscore->core for consistency
Date: Tue, 22 Aug 2017 12:25:42 +0100
Message-Id: <20170822112550.60311-23-ian@mnementh.co.uk> (sfid-20170822_134533_042090_BFCAC93B)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid confusion with unrelated _buscore labels.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index c1f3366871e5..09b4db117e0d 100644
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
