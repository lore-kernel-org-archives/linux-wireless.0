Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3702 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab1KDVYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:02 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/16] brcm80211: fmac: remove duplicate regiter set in
 chip attach path
Date: Fri, 4 Nov 2011 22:23:34 +0100
Message-ID: <1320441822-4615-9-git-send-email-arend@broadcom.com> (sfid-20111104_222417_716154_79D17E88)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Same register writes have been done in brcmf_sdbrcm_probe_init
which is earlier in the same code path.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 30187c1..5e7b70e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3872,7 +3872,6 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 {
 	struct chip_info *ci;
 	int err;
-	u8 clkval;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3885,18 +3884,6 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	if (err)
 		goto fail;
 
-	/* Disable F2 to clear any intermediate frame state on the dongle */
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
-		SDIO_FUNC_ENABLE_1, NULL);
-
-	/* WAR: cmd52 backplane read so core HW will drop ALPReq */
-	clkval = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-			0, NULL);
-
-	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
-
 	bus->ci = ci;
 	return 0;
 fail:
-- 
1.7.4.1


