Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3395 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab1DYWp2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 18:45:28 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	brudley@broadcom.com, henryp@broadcom.com, hharte@broadcom.com
Subject: [PATCH 5/7] staging: brcm80211: Add dhdsdio_chip_detach in
 dhd_sdio.c
Date: Mon, 25 Apr 2011 15:45:11 -0700
Message-ID: <1303771513-18851-6-git-send-email-frankyl@broadcom.com> (sfid-20110426_004532_574800_62E641FA)
In-Reply-To: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
References: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add dhdsdio_chip_detach to replace si_detach for si/sb utils removal

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 02f6509..ace8909 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -487,6 +487,7 @@ static int dhdsdio_chip_attach(struct dhd_bus *bus, void *regs);
 static void dhdsdio_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase);
 static void dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus,
 					u32 drivestrength);
+static void dhdsdio_chip_detach(struct dhd_bus *bus);
 
 static void dhd_dongle_setmemsize(struct dhd_bus *bus, int mem_size)
 {
@@ -5484,10 +5485,8 @@ static void dhdsdio_release(dhd_bus_t *bus)
 		bcmsdh_intr_dereg(bus->sdh);
 
 		if (bus->dhd) {
-
-			dhdsdio_release_dongle(bus);
-
 			dhd_detach(bus->dhd);
+			dhdsdio_release_dongle(bus);
 			bus->dhd = NULL;
 		}
 
@@ -5530,6 +5529,7 @@ static void dhdsdio_release_dongle(dhd_bus_t *bus)
 #endif				/* !defined(BCMLXSDMMC) */
 		dhdsdio_clkctl(bus, CLK_NONE, false);
 		si_detach(bus->sih);
+		dhdsdio_chip_detach(bus);
 		if (bus->vars && bus->varsz)
 			kfree(bus->vars);
 		bus->vars = NULL;
@@ -6426,3 +6426,12 @@ dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
 			drivestrength, cc_data_temp));
 	}
 }
+
+static void
+dhdsdio_chip_detach(struct dhd_bus *bus)
+{
+	DHD_TRACE(("%s: Enter\n", __func__));
+
+	kfree(bus->ci);
+	bus->ci = NULL;
+}
-- 
1.7.1


