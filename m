Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1563 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757787Ab2BIUJZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:25 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/15] brcm80211: fmac: only return success in
 brcmf_sdbrcm_bus_init() when true
Date: Thu, 9 Feb 2012 21:09:04 +0100
Message-ID: <1328818149-4826-11-git-send-email-arend@broadcom.com> (sfid-20120209_211026_364645_A38C1BC1)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_sdbrcm_bus_init() always returned success except for
firmware download failure. However, also when enabling SDIO function 2
is failing the function should return failure. This patch fixes that.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index b20029e..47a192d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3467,13 +3467,12 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 
 		/* Set bus state according to enable result */
 		bus_if->state = BRCMF_BUS_DATA;
-	}
-
-	else {
+	} else {
 		/* Disable F2 again */
 		enable = SDIO_FUNC_ENABLE_1;
 		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0,
 				       SDIO_CCCR_IOEx, enable, NULL);
+		ret = -ENODEV;
 	}
 
 	/* Restore previous clock setting */
@@ -3481,7 +3480,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 			       SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
 
 	/* If we didn't come up, turn off backplane clock */
-	if (bus_if->state != BRCMF_BUS_DATA)
+	if (!ret)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 
 exit:
-- 
1.7.5.4


