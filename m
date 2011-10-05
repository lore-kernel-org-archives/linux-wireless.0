Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3157 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934727Ab1JENU4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/15] staging: brcm80211: remove redundant bus register
 layer from fullmac
Date: Wed, 5 Oct 2011 15:20:02 +0200
Message-ID: <1317820814-7083-4-git-send-email-arend@broadcom.com> (sfid-20111005_152101_933229_CA0C1404)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove some single line functions for bus register/unregister interface

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   10 ----------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   16 ++++------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   14 --------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    4 ----
 4 files changed, 4 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 5906337..bff9dcd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -362,16 +362,6 @@ int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
 }
 EXPORT_SYMBOL(brcmf_sdio_remove);
 
-int brcmf_sdio_register(void)
-{
-	return brcmf_sdio_function_init();
-}
-
-void brcmf_sdio_unregister(void)
-{
-	brcmf_sdio_function_cleanup();
-}
-
 void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev, bool enable)
 {
 	if (enable)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index fc95bb2..e919de2 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -609,23 +609,15 @@ static struct sdio_driver brcmf_sdmmc_driver = {
 #endif	/* CONFIG_PM_SLEEP */
 };
 
-/*
- * module init
-*/
-int brcmf_sdio_function_init(void)
+/* bus register interface */
+int brcmf_bus_register(void)
 {
-	int error = 0;
 	brcmf_dbg(TRACE, "Enter\n");
 
-	error = sdio_register_driver(&brcmf_sdmmc_driver);
-
-	return error;
+	return sdio_register_driver(&brcmf_sdmmc_driver);
 }
 
-/*
- * module cleanup
-*/
-void brcmf_sdio_function_cleanup(void)
+void brcmf_bus_unregister(void)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 0ae8dc0..0f7b80d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -4533,20 +4533,6 @@ void brcmf_sdbrcm_disconnect(void *ptr)
 	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
-int brcmf_bus_register(void)
-{
-	brcmf_dbg(TRACE, "Enter\n");
-
-	return brcmf_sdio_register();
-}
-
-void brcmf_bus_unregister(void)
-{
-	brcmf_dbg(TRACE, "Enter\n");
-
-	brcmf_sdio_unregister();
-}
-
 struct device *brcmf_bus_get_device(struct brcmf_bus *bus)
 {
 	return &bus->sdiodev->func[2]->dev;
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 397ad48..726fa89 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -211,10 +211,6 @@ extern int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw,
 extern int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
 
 /* platform specific/high level functions */
-extern int brcmf_sdio_function_init(void);
-extern int brcmf_sdio_register(void);
-extern void brcmf_sdio_unregister(void);
-extern void brcmf_sdio_function_cleanup(void);
 extern int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
 extern int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev);
 
-- 
1.7.4.1


