Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4201 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab1GROaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 10:30:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Franky Lin" <frankyl@broadcom.com>,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/19] staging: brcm80211: absorb brcmf_sdcard_attach
 into brcmf_sdio_probe
Date: Mon, 18 Jul 2011 16:30:03 +0200
Message-ID: <1310999405-10062-18-git-send-email-arend@broadcom.com> (sfid-20110718_163041_402182_E5BAC543)
In-Reply-To: <1310999405-10062-1-git-send-email-arend@broadcom.com>
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Increase readability of brcmfmac

Cc: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |   68 +++++++++--------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |   11 ----
 2 files changed, 27 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 53dfecd..6f88bd2 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -57,32 +57,6 @@ static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
 
 module_param(sd_f2_blocksize, int, 0);
 
-struct brcmf_sdio_card*
-brcmf_sdcard_attach(void *cfghdl, u32 *regsva)
-{
-	struct brcmf_sdio_card *card;
-
-	card = kzalloc(sizeof(struct brcmf_sdio_card), GFP_ATOMIC);
-	if (card == NULL) {
-		BRCMF_ERROR(("sdcard_attach: out of memory"));
-		return NULL;
-	}
-
-	card->sdioh = brcmf_sdioh_attach(cfghdl);
-	if (!card->sdioh) {
-		brcmf_sdcard_detach(card);
-		return NULL;
-	}
-
-	card->init_success = true;
-
-	*regsva = SI_ENUM_BASE;
-
-	/* Report the BAR, to fix if needed */
-	card->sbwad = SI_ENUM_BASE;
-	return card;
-}
-
 int brcmf_sdcard_detach(struct brcmf_sdio_card *card)
 {
 	if (card != NULL) {
@@ -455,35 +429,47 @@ u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card)
 int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	u32 regs = 0;
-	struct brcmf_sdio_card *card = NULL;
 	u32 vendevid;
+	int ret = 0;
+
+	sdiodev->card = kzalloc(sizeof(struct brcmf_sdio_card), GFP_ATOMIC);
+	if (sdiodev->card == NULL) {
+		BRCMF_ERROR(("sdcard_attach: out of memory"));
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	card = brcmf_sdcard_attach((void *)0, &regs);
-	if (!card) {
-		BRCMF_ERROR(("%s: attach failed\n", __func__));
-		goto err;
+	sdiodev->card->sdioh = brcmf_sdioh_attach((void *)0);
+	if (!sdiodev->card->sdioh) {
+		brcmf_sdcard_detach(sdiodev->card);
+		ret = -ENODEV;
+		goto out;
 	}
-	sdiodev->card = card;
+
+	sdiodev->card->init_success = true;
+
+	regs = SI_ENUM_BASE;
+
+	/* Report the BAR, to fix if needed */
+	sdiodev->card->sbwad = SI_ENUM_BASE;
 
 	/* Read the vendor/device ID from the CIS */
-	vendevid = brcmf_sdcard_query_device(card);
+	vendevid = brcmf_sdcard_query_device(sdiodev->card);
 
 	/* try to attach to the target device */
 	sdiodev->bus = drvinfo.attach((vendevid >> 16), (vendevid & 0xFFFF),
-				  0, 0, 0, 0, regs, card);
+				  0, 0, 0, 0, regs, sdiodev->card);
 	if (!sdiodev->bus) {
 		BRCMF_ERROR(("%s: device attach failed\n", __func__));
-		goto err;
+		ret = -ENODEV;
+		goto out;
 	}
 
-	return 0;
-
-	/* error handling */
-err:
-	if (sdiodev->card)
+out:
+	if ((ret) && (sdiodev->card))
 		brcmf_sdcard_detach(sdiodev->card);
 
-	return -ENODEV;
+	return ret;
 }
 EXPORT_SYMBOL(brcmf_sdio_probe);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 5e7552e..68b6843 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -136,17 +136,6 @@ struct brcmf_sdio_dev {
 	void *bus;
 };
 
-/* Attach and build an interface to the underlying SD host driver.
- *  - Allocates resources (structs, arrays, mem, OS handles, etc) needed by
- *    brcmf_sdcard.
- *  - Returns the sdio card handle and virtual address base for register access.
- *    The returned handle should be used in all subsequent calls, but the bcmsh
- *    implementation may maintain a single "default" handle (e.g. the first or
- *    most recent one) to enable single-instance implementations to pass NULL.
- */
-extern struct brcmf_sdio_card*
-brcmf_sdcard_attach(void *cfghdl, u32 *regsva);
-
 /* Detach - freeup resources allocated in attach */
 extern int brcmf_sdcard_detach(struct brcmf_sdio_card *card);
 
-- 
1.7.4.1


