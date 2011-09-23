Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2134 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab1IWAIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:09 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 09/19] staging: brcm80211: remove fullmac
 module_param brcmf_sdiod_drive_strength
Date: Thu, 22 Sep 2011 17:07:46 -0700
Message-ID: <1316736476-23725-10-git-send-email-frankyl@broadcom.com> (sfid-20110923_020822_694857_A1473AED)
In-Reply-To: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
References: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replaced the global variable with constant

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 7090a36..53de5a7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -759,9 +759,7 @@ static uint brcmf_txminmax;
 int brcmf_idletime = 1;
 module_param(brcmf_idletime, int, 0);
 
-/* SDIO Drive Strength (in milliamps) */
-uint brcmf_sdiod_drive_strength = 6;
-module_param(brcmf_sdiod_drive_strength, uint, 0);
+#define SDIO_DRIVE_STRENGTH	6	/* in milliamps */
 
 /* Use polling */
 uint brcmf_poll;
@@ -4607,7 +4605,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 		goto fail;
 	}
 
-	brcmf_sdbrcm_sdiod_drive_strength_init(bus, brcmf_sdiod_drive_strength);
+	brcmf_sdbrcm_sdiod_drive_strength_init(bus, SDIO_DRIVE_STRENGTH);
 
 	/* Get info on the ARM and SOCRAM cores... */
 	brcmf_sdcard_reg_read(bus->sdiodev,
-- 
1.7.1


