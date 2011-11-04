Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3675 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1KDVYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:06 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/16] brcm80211: fmac: chip attach code flow clean up
Date: Fri, 4 Nov 2011 22:23:35 +0100
Message-ID: <1320441822-4615-10-git-send-email-arend@broadcom.com> (sfid-20111104_222428_349216_7C7800FC)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Merged brcmf_sdbrcm_chip_attach into brcmf_sdio_chip_attach
for better readability.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   31 ++------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   21 +++++++++++--
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    3 +-
 3 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5e7b70e..868cb9d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3867,31 +3867,6 @@ static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
 	}
 }
 
-static int
-brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
-{
-	struct chip_info *ci;
-	int err;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	/* alloc chip_info_t */
-	ci = kzalloc(sizeof(struct chip_info), GFP_ATOMIC);
-	if (NULL == ci)
-		return -ENOMEM;
-
-	err = brcmf_sdio_chip_attach(bus->sdiodev, ci, regs);
-	if (err)
-		goto fail;
-
-	bus->ci = ci;
-	return 0;
-fail:
-	bus->ci = NULL;
-	kfree(ci);
-	return err;
-}
-
 static bool
 brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 {
@@ -3913,7 +3888,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 #endif				/* BCMDBG */
 
 	/*
-	 * Force PLL off until brcmf_sdbrcm_chip_attach()
+	 * Force PLL off until brcmf_sdio_chip_attach()
 	 * programs PLL control regs
 	 */
 
@@ -3931,8 +3906,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 		goto fail;
 	}
 
-	if (brcmf_sdbrcm_chip_attach(bus, regsva)) {
-		brcmf_dbg(ERROR, "brcmf_sdbrcm_chip_attach failed!\n");
+	if (brcmf_sdio_chip_attach(bus->sdiodev, &bus->ci, regsva)) {
+		brcmf_dbg(ERROR, "brcmf_sdio_chip_attach failed!\n");
 		goto fail;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 002157f..10befbf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -252,17 +252,25 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 }
 
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
-			   struct chip_info *ci, u32 regs)
+			   struct chip_info **ci_ptr, u32 regs)
 {
-	int ret = 0;
+	int ret;
+	struct chip_info *ci;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	/* alloc chip_info_t */
+	ci = kzalloc(sizeof(struct chip_info), GFP_ATOMIC);
+	if (!ci)
+		return -ENOMEM;
 
 	ret = brcmf_sdio_chip_buscoreprep(sdiodev);
 	if (ret != 0)
-		return ret;
+		goto err;
 
 	ret = brcmf_sdio_chip_recognition(sdiodev, ci, regs);
 	if (ret != 0)
-		return ret;
+		goto err;
 
 	brcmf_sdio_chip_buscoresetup(sdiodev, ci);
 
@@ -271,5 +279,10 @@ int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 	brcmf_sdcard_reg_write(sdiodev,
 		CORE_CC_REG(ci->cccorebase, gpiopulldown), 4, 0);
 
+	*ci_ptr = ci;
+	return 0;
+
+err:
+	kfree(ci);
 	return ret;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 17007bd..25ac385 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -137,7 +137,6 @@ struct sbconfig {
 extern void brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev,
 					u32 corebase);
 extern int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
-				  struct chip_info *ci, u32 regs);
-
+				  struct chip_info **ci_ptr, u32 regs);
 
 #endif		/* _BRCMFMAC_SDIO_CHIP_H_ */
-- 
1.7.4.1


