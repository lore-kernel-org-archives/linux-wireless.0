Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3982 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab1IWAIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:09 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 11/19] staging: brcm80211: remove fullmac
 module_param brcmf_idletime
Date: Thu, 22 Sep 2011 17:07:48 -0700
Message-ID: <1316736476-23725-12-git-send-email-frankyl@broadcom.com> (sfid-20110923_020817_825836_85ED80B8)
In-Reply-To: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
References: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use constant for idle time setting.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h      |    1 +
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    5 +----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 1e18ad0..7ca9172 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -808,5 +808,6 @@ extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 #define BRCMF_IDLE_IMMEDIATE	(-1)
 #define BRCMF_IDLE_ACTIVE	0	/* Do not request any SD clock change
 				 when idle */
+#define BRCMF_IDLE_INTERVAL	1
 
 #endif				/* _BRCMF_H_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 4033e73..57049ec 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -747,9 +747,6 @@ module_param(brcmf_txbound, uint, 0);
 module_param(brcmf_rxbound, uint, 0);
 static uint brcmf_txminmax;
 
-int brcmf_idletime = 1;
-module_param(brcmf_idletime, int, 0);
-
 #define SDIO_DRIVE_STRENGTH	6	/* in milliamps */
 
 /* Use polling */
@@ -4650,7 +4647,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
 
 	/* ...and initialize clock/power states */
 	bus->clkstate = CLK_SDONLY;
-	bus->idletime = (s32) brcmf_idletime;
+	bus->idletime = BRCMF_IDLE_INTERVAL;
 	bus->idleclock = BRCMF_IDLE_ACTIVE;
 
 	/* Query the F2 block size, set roundup accordingly */
-- 
1.7.1


