Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3359 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Franky Lin" <frankyl@broadcom.com>, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/29] staging: brcm80211: remove vendor and device id
 check from brcmfmac
Date: Fri, 22 Jul 2011 20:57:03 +0200
Message-ID: <1311361036-3175-17-git-send-email-arend@broadcom.com> (sfid-20110722_205748_267617_603F3442)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

mmc core is handling the vendor/device id check and matching drivers
with devices. No need to do it again in driver.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |   14 +------
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h   |    5 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   53 +++---------------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |    3 -
 4 files changed, 9 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 82d9d2c..3208a11 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -44,7 +44,6 @@
 struct brcmf_sdio_card {
 	bool init_success;	/* underlying driver successfully attached */
 	void *sdioh;		/* handler for sdioh */
-	u32 vendevid;	/* Target Vendor and Device ID on SD bus */
 	bool regfail;		/* Save status of last
 				 reg_read/reg_write call */
 	u32 sbwad;		/* Save backplane window address */
@@ -399,12 +398,6 @@ int brcmf_sdcard_abort(struct brcmf_sdio_card *card, uint fn)
 	return brcmf_sdioh_abort(card->sdioh, fn);
 }
 
-int brcmf_sdcard_query_device(struct brcmf_sdio_card *card)
-{
-	card->vendevid = (PCI_VENDOR_ID_BROADCOM << 16) | 0;
-	return card->vendevid;
-}
-
 u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card)
 {
 	return card->sbwad;
@@ -413,7 +406,6 @@ u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card)
 int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	u32 regs = 0;
-	u32 vendevid;
 	int ret = 0;
 
 	sdiodev->card = kzalloc(sizeof(struct brcmf_sdio_card), GFP_ATOMIC);
@@ -436,12 +428,8 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	/* Report the BAR, to fix if needed */
 	sdiodev->card->sbwad = SI_ENUM_BASE;
 
-	/* Read the vendor/device ID from the CIS */
-	vendevid = brcmf_sdcard_query_device(sdiodev->card);
-
 	/* try to attach to the target device */
-	sdiodev->bus = brcmf_sdbrcm_probe((vendevid >> 16), (vendevid & 0xFFFF),
-				  0, 0, 0, 0, regs, sdiodev->card);
+	sdiodev->bus = brcmf_sdbrcm_probe(0, 0, 0, 0, regs, sdiodev->card);
 	if (!sdiodev->bus) {
 		BRCMF_ERROR(("%s: device attach failed\n", __func__));
 		ret = -ENODEV;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 0fb3250..4521fe5 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -75,8 +75,7 @@ extern void brcmf_bus_clearcounts(struct brcmf_pub *drvr);
 
 extern void brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick);
 
-extern void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
-				u16 slot, u16 func, uint bustype, u32 regsva,
-				void *card);
+extern void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
+				u32 regsva, void *card);
 extern void brcmf_sdbrcm_disconnect(void *ptr);
 #endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 1b84767..bd83da3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -625,8 +625,6 @@ struct brcmf_bus {
 	bool dpc_sched;		/* Indicates DPC schedule (intrpt rcvd) */
 	bool fcstate;		/* State of dongle flow-control */
 
-	u16 cl_devid;	/* cached devid for brcmf_sdio_probe_attach() */
-
 	uint blocksize;		/* Block size of SDIO transfers */
 	uint roundup;		/* Max roundup limit */
 
@@ -964,7 +962,7 @@ static void brcmf_sdbrcm_release(struct brcmf_bus *bus);
 static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus);
 static bool brcmf_sdbrcm_chipmatch(u16 chipid);
 static bool brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card,
-				      u32 regsva, u16 devid);
+				      u32 regsva);
 static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus, void *card);
 static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card);
 static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus);
@@ -5430,9 +5428,8 @@ static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 	return false;
 }
 
-void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
-			   u16 slot, u16 func, uint bustype, u32 regsva,
-			   void *card)
+void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
+			 u32 regsva, void *card)
 {
 	int ret;
 	struct brcmf_bus *bus;
@@ -5459,45 +5456,10 @@ void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	brcmf_c_init();
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
-	BRCMF_INFO(("%s: venid 0x%04x devid 0x%04x\n", __func__, venid, devid));
 
 	/* We make an assumption about address window mappings:
 	 * regsva == SI_ENUM_BASE*/
 
-	/* SDIO car passes venid and devid based on CIS parsing -- but
-	 * low-power start
-	 * means early parse could fail, so here we should get either an ID
-	 * we recognize OR (-1) indicating we must request power first.
-	 */
-	/* Check the Vendor ID */
-	switch (venid) {
-	case 0x0000:
-	case PCI_VENDOR_ID_BROADCOM:
-		break;
-	default:
-		BRCMF_ERROR(("%s: unknown vendor: 0x%04x\n", __func__, venid));
-		return NULL;
-	}
-
-	/* Check the Device ID and make sure it's one that we support */
-	switch (devid) {
-	case BCM4329_D11NDUAL_ID:	/* 4329 802.11n dualband device */
-	case BCM4329_D11N2G_ID:	/* 4329 802.11n 2.4G device */
-	case BCM4329_D11N5G_ID:	/* 4329 802.11n 5G device */
-	case 0x4329:
-		BRCMF_INFO(("%s: found 4329 Dongle\n", __func__));
-		break;
-	case 0:
-		BRCMF_INFO(("%s: allow device id 0, will check chip"
-			    " internals\n", __func__));
-		break;
-
-	default:
-		BRCMF_ERROR(("%s: skipping 0x%04x/0x%04x, not a dongle\n",
-			     __func__, venid, devid));
-		return NULL;
-	}
-
 	/* Allocate private bus interface state */
 	bus = kzalloc(sizeof(struct brcmf_bus), GFP_ATOMIC);
 	if (!bus) {
@@ -5506,14 +5468,13 @@ void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 		goto fail;
 	}
 	bus->card = card;
-	bus->cl_devid = (u16) devid;
 	bus->bus = BRCMF_BUS;
 	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
 	bus->usebufpool = false;	/* Use bufpool if allocated,
 					 else use locally malloced rxbuf */
 
 	/* attempt to attach to the dongle */
-	if (!(brcmf_sdbrcm_probe_attach(bus, card, regsva, devid))) {
+	if (!(brcmf_sdbrcm_probe_attach(bus, card, regsva))) {
 		BRCMF_ERROR(("%s: brcmf_sdbrcm_probe_attach failed\n",
 			     __func__));
 		goto fail;
@@ -5623,8 +5584,7 @@ fail:
 }
 
 static bool
-brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva,
-			  u16 devid)
+brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva)
 {
 	u8 clkctl = 0;
 	int err = 0;
@@ -6170,8 +6130,7 @@ int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 
 			/* Attempt to re-attach & download */
 			if (brcmf_sdbrcm_probe_attach(bus, bus->card,
-						      SI_ENUM_BASE,
-						      bus->cl_devid)) {
+						      SI_ENUM_BASE)) {
 				/* Attempt to download binary to the dongle */
 				if (brcmf_sdbrcm_probe_init(bus, bus->card)) {
 					/* Re-init bus, enable F2 transfer */
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 3d6c261..22441e9 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -268,9 +268,6 @@ extern int brcmf_sdcard_rwdata(struct brcmf_sdio_card *card, uint rw, u32 addr,
 /* Issue an abort to the specified function */
 extern int brcmf_sdcard_abort(struct brcmf_sdio_card *card, uint fn);
 
-/* Returns the "Device ID" of target device on the SDIO bus. */
-extern int brcmf_sdcard_query_device(struct brcmf_sdio_card *card);
-
 /* Miscellaneous knob tweaker. */
 extern int brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
 				 void *params, int plen, void *arg, int len,
-- 
1.7.4.1


