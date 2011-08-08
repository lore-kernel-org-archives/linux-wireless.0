Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3093 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab1HHN7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:35 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 67/82] staging: brcm80211: remove struct
 brcmf_sdioh_driver from brcmfmac
Date: Mon, 8 Aug 2011 15:58:51 +0200
Message-ID: <1312811946-16713-68-git-send-email-arend@broadcom.com> (sfid-20110808_160045_933944_840264DC)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

brcmf_sdioh_driver is a legacy bus driver interface we dont need
any more.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |   11 +++--------
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h   |    4 ++++
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   17 +++--------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |   11 +----------
 4 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 0cd449d..82d9d2c 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -50,9 +50,6 @@ struct brcmf_sdio_card {
 	u32 sbwad;		/* Save backplane window address */
 };
 
-/* driver info, initialized when brcmf_sdio_register is called */
-static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
-
 /* Module parameters specific to each host-controller driver */
 
 module_param(sd_f2_blocksize, int, 0);
@@ -443,7 +440,7 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	vendevid = brcmf_sdcard_query_device(sdiodev->card);
 
 	/* try to attach to the target device */
-	sdiodev->bus = drvinfo.attach((vendevid >> 16), (vendevid & 0xFFFF),
+	sdiodev->bus = brcmf_sdbrcm_probe((vendevid >> 16), (vendevid & 0xFFFF),
 				  0, 0, 0, 0, regs, sdiodev->card);
 	if (!sdiodev->bus) {
 		BRCMF_ERROR(("%s: device attach failed\n", __func__));
@@ -462,7 +459,7 @@ EXPORT_SYMBOL(brcmf_sdio_probe);
 int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
 {
 	if (sdiodev->bus) {
-		drvinfo.detach(sdiodev->bus);
+		brcmf_sdbrcm_disconnect(sdiodev->bus);
 		sdiodev->bus = NULL;
 	}
 
@@ -477,10 +474,8 @@ int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
 }
 EXPORT_SYMBOL(brcmf_sdio_remove);
 
-int brcmf_sdio_register(struct brcmf_sdioh_driver *driver)
+int brcmf_sdio_register(void)
 {
-	drvinfo = *driver;
-
 	return brcmf_sdio_function_init();
 }
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 653cf0d..0fb3250 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -75,4 +75,8 @@ extern void brcmf_bus_clearcounts(struct brcmf_pub *drvr);
 
 extern void brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick);
 
+extern void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
+				u16 slot, u16 func, uint bustype, u32 regsva,
+				void *card);
+extern void brcmf_sdbrcm_disconnect(void *ptr);
 #endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index b9f399f..a02ab90 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -962,7 +962,6 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter);
 
 static void brcmf_sdbrcm_release(struct brcmf_bus *bus);
 static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus);
-static void brcmf_sdbrcm_disconnect(void *ptr);
 static bool brcmf_sdbrcm_chipmatch(u16 chipid);
 static bool brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card,
 				      u32 regsva, u16 devid);
@@ -5431,7 +5430,7 @@ static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 	return false;
 }
 
-static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
+void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 			   u16 slot, u16 func, uint bustype, u32 regsva,
 			   void *card)
 {
@@ -5889,7 +5888,7 @@ static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
 	BRCMF_TRACE(("%s: Disconnected\n", __func__));
 }
 
-static void brcmf_sdbrcm_disconnect(void *ptr)
+void brcmf_sdbrcm_disconnect(void *ptr)
 {
 	struct brcmf_bus *bus = (struct brcmf_bus *)ptr;
 
@@ -5901,16 +5900,6 @@ static void brcmf_sdbrcm_disconnect(void *ptr)
 	BRCMF_TRACE(("%s: Disconnected\n", __func__));
 }
 
-/* Register/Unregister functions are called by the main DHD entry
- * point (e.g. module insertion) to link with the bus driver, in
- * order to look for or await the device.
- */
-
-static struct brcmf_sdioh_driver brcmf_sdio = {
-	brcmf_sdbrcm_probe,
-	brcmf_sdbrcm_disconnect
-};
-
 int brcmf_bus_register(void)
 {
 	BRCMF_TRACE(("%s: Enter\n", __func__));
@@ -5930,7 +5919,7 @@ int brcmf_bus_register(void)
 		return -EINVAL;
 	} while (0);
 
-	return brcmf_sdio_register(&brcmf_sdio);
+	return brcmf_sdio_register();
 }
 
 void brcmf_bus_unregister(void)
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index f4e2329..3d6c261 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -278,20 +278,11 @@ extern int brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
 
 /* helper functions */
 
-/* callback functions */
-struct brcmf_sdioh_driver {
-	/* attach to device */
-	void *(*attach) (u16 vend_id, u16 dev_id, u16 bus, u16 slot,
-			 u16 func, uint bustype, u32 regsva, void *param);
-	/* detach from device */
-	void (*detach) (void *ch);
-};
-
 struct sdioh_info;
 
 /* platform specific/high level functions */
 extern int brcmf_sdio_function_init(void);
-extern int brcmf_sdio_register(struct brcmf_sdioh_driver *driver);
+extern int brcmf_sdio_register(void);
 extern void brcmf_sdio_unregister(void);
 extern void brcmf_sdio_function_cleanup(void);
 extern int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
-- 
1.7.4.1


