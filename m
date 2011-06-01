Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4955 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835Ab1FALqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:32 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 49/83] staging: brcm80211: remove BCMEMBEDIMAGE related
 codes from fullmac
Date: Wed, 1 Jun 2011 13:45:34 +0200
Message-ID: <1306928768-7501-49-git-send-email-rvossen@broadcom.com> (sfid-20110601_134714_116303_6362C2C4)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove BCMEMBEDIMAGE related codes in fullmac driver as we don't
need this in firmware download routine.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  120 +------------------------
 1 files changed, 1 insertions(+), 119 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 835beaa..ad3f0e6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -21,10 +21,6 @@
 #include <bcmdefs.h>
 #include <bcmsdh.h>
 
-#ifdef BCMEMBEDIMAGE
-#include BCMEMBEDIMAGE
-#endif				/* BCMEMBEDIMAGE */
-
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <bcmdevs.h>
@@ -633,9 +629,6 @@ static int _dhdsdio_download_firmware(struct dhd_bus *bus);
 
 static int dhdsdio_download_code_file(struct dhd_bus *bus, char *image_path);
 static int dhdsdio_download_nvram(struct dhd_bus *bus);
-#ifdef BCMEMBEDIMAGE
-static int dhdsdio_download_code_array(struct dhd_bus *bus);
-#endif
 static void dhdsdio_chip_disablecore(bcmsdh_info_t *sdh, u32 corebase);
 static int dhdsdio_chip_attach(struct dhd_bus *bus, void *regs);
 static void dhdsdio_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase);
@@ -5587,97 +5580,6 @@ void dhd_bus_unregister(void)
 	bcmsdh_unregister();
 }
 
-#ifdef BCMEMBEDIMAGE
-static int dhdsdio_download_code_array(struct dhd_bus *bus)
-{
-	int bcmerror = -1;
-	int offset = 0;
-
-	DHD_INFO(("%s: download embedded firmware...\n", __func__));
-
-	/* Download image */
-	while ((offset + MEMBLOCK) < sizeof(dlarray)) {
-		bcmerror =
-		    dhdsdio_membytes(bus, true, offset, dlarray + offset,
-				     MEMBLOCK);
-		if (bcmerror) {
-			DHD_ERROR(("%s: error %d on writing %d membytes at "
-				"0x%08x\n",
-				__func__, bcmerror, MEMBLOCK, offset));
-			goto err;
-		}
-
-		offset += MEMBLOCK;
-	}
-
-	if (offset < sizeof(dlarray)) {
-		bcmerror = dhdsdio_membytes(bus, true, offset,
-					    dlarray + offset,
-					    sizeof(dlarray) - offset);
-		if (bcmerror) {
-			DHD_ERROR(("%s: error %d on writing %d membytes at "
-				"0x%08x\n", __func__, bcmerror,
-				sizeof(dlarray) - offset, offset));
-			goto err;
-		}
-	}
-#ifdef DHD_DEBUG
-	/* Upload and compare the downloaded code */
-	{
-		unsigned char *ularray;
-
-		ularray = kmalloc(bus->ramsize, GFP_ATOMIC);
-		if (!ularray) {
-			bcmerror = -ENOMEM;
-			goto err;
-		}
-		/* Upload image to verify downloaded contents. */
-		offset = 0;
-		memset(ularray, 0xaa, bus->ramsize);
-		while ((offset + MEMBLOCK) < sizeof(dlarray)) {
-			bcmerror =
-			    dhdsdio_membytes(bus, false, offset,
-					     ularray + offset, MEMBLOCK);
-			if (bcmerror) {
-				DHD_ERROR(("%s: error %d on reading %d membytes"
-					" at 0x%08x\n",
-					__func__, bcmerror, MEMBLOCK, offset));
-				goto free;
-			}
-
-			offset += MEMBLOCK;
-		}
-
-		if (offset < sizeof(dlarray)) {
-			bcmerror = dhdsdio_membytes(bus, false, offset,
-						    ularray + offset,
-						    sizeof(dlarray) - offset);
-			if (bcmerror) {
-				DHD_ERROR(("%s: error %d on reading %d membytes at 0x%08x\n",
-				__func__, bcmerror,
-				sizeof(dlarray) - offset, offset));
-				goto free;
-			}
-		}
-
-		if (memcmp(dlarray, ularray, sizeof(dlarray))) {
-			DHD_ERROR(("%s: Downloaded image is corrupted.\n",
-				   __func__));
-			ASSERT(0);
-			goto free;
-		} else
-			DHD_ERROR(("%s: Download/Upload/Compare succeeded.\n",
-				__func__));
-free:
-		kfree(ularray);
-	}
-#endif				/* DHD_DEBUG */
-
-err:
-	return bcmerror;
-}
-#endif				/* BCMEMBEDIMAGE */
-
 static int dhdsdio_download_code_file(struct dhd_bus *bus, char *fw_path)
 {
 	int bcmerror = -1;
@@ -5871,13 +5773,8 @@ static int _dhdsdio_download_firmware(struct dhd_bus *bus)
 	bool dlok = false;	/* download firmware succeeded */
 
 	/* Out immediately if no image to download */
-	if ((bus->fw_path == NULL) || (bus->fw_path[0] == '\0')) {
-#ifdef BCMEMBEDIMAGE
-		embed = true;
-#else
+	if ((bus->fw_path == NULL) || (bus->fw_path[0] == '\0'))
 		return bcmerror;
-#endif
-	}
 
 	/* Keep arm in reset */
 	if (dhdsdio_download_state(bus, true)) {
@@ -5890,27 +5787,12 @@ static int _dhdsdio_download_firmware(struct dhd_bus *bus)
 		if (dhdsdio_download_code_file(bus, bus->fw_path)) {
 			DHD_ERROR(("%s: dongle image file download failed\n",
 				   __func__));
-#ifdef BCMEMBEDIMAGE
-			embed = true;
-#else
 			goto err;
-#endif
 		} else {
 			embed = false;
 			dlok = true;
 		}
 	}
-#ifdef BCMEMBEDIMAGE
-	if (embed) {
-		if (dhdsdio_download_code_array(bus)) {
-			DHD_ERROR(("%s: dongle image array download failed\n",
-				   __func__));
-			goto err;
-		} else {
-			dlok = true;
-		}
-	}
-#endif
 	if (!dlok) {
 		DHD_ERROR(("%s: dongle image download failed\n", __func__));
 		goto err;
-- 
1.7.4.1


