Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35073 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967275AbdLSMr3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 07:47:29 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>
Subject: [PATCH 02/11] brcmfmac: Rename buscore to core for consistency
Date: Tue, 19 Dec 2017 13:47:08 +0100
Message-Id: <1513687637-5555-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171219_134751_770176_50944CB0)
In-Reply-To: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid confusion with unrelated _buscore labels.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
[arend: only do the rename]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 9d3a662..cc409c7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2485,12 +2485,12 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 
 static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 {
-	struct brcmf_core *buscore = bus->sdio_core;
+	struct brcmf_core *core = bus->sdio_core;
 	u32 addr;
 	unsigned long val;
 	int ret;
 
-	addr = buscore->base + SD_REG(intstatus);
+	addr = core->base + SD_REG(intstatus);
 
 	val = brcmf_sdiod_readl(bus->sdiodev, addr, &ret);
 	bus->sdcnt.f1regdata++;
-- 
1.9.1
