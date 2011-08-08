Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1798 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1HHN7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 52/82] staging: brcm80211: absorb brcmf_sdcard_detach
 into brcmf_sdio_remove
Date: Mon, 8 Aug 2011 15:58:36 +0200
Message-ID: <1312811946-16713-53-git-send-email-arend@broadcom.com> (sfid-20110808_160056_507233_C9818F9B)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

To increase code readability of brcmfmac

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |   32 ++++++++++-------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |    3 --
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 6f88bd2..0cd449d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -57,19 +57,6 @@ static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
 
 module_param(sd_f2_blocksize, int, 0);
 
-int brcmf_sdcard_detach(struct brcmf_sdio_card *card)
-{
-	if (card != NULL) {
-		if (card->sdioh) {
-			brcmf_sdioh_detach(card->sdioh);
-			card->sdioh = NULL;
-		}
-		kfree(card);
-	}
-
-	return 0;
-}
-
 int
 brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
 		void *params, int plen, void *arg, int len, bool set)
@@ -441,7 +428,6 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 
 	sdiodev->card->sdioh = brcmf_sdioh_attach((void *)0);
 	if (!sdiodev->card->sdioh) {
-		brcmf_sdcard_detach(sdiodev->card);
 		ret = -ENODEV;
 		goto out;
 	}
@@ -466,8 +452,8 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	}
 
 out:
-	if ((ret) && (sdiodev->card))
-		brcmf_sdcard_detach(sdiodev->card);
+	if (ret)
+		brcmf_sdio_remove(sdiodev);
 
 	return ret;
 }
@@ -475,8 +461,18 @@ EXPORT_SYMBOL(brcmf_sdio_probe);
 
 int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
 {
-	drvinfo.detach(sdiodev->bus);
-	brcmf_sdcard_detach(sdiodev->card);
+	if (sdiodev->bus) {
+		drvinfo.detach(sdiodev->bus);
+		sdiodev->bus = NULL;
+	}
+
+	if (sdiodev->card) {
+		if (sdiodev->card->sdioh)
+			brcmf_sdioh_detach(sdiodev->card->sdioh);
+		kfree(sdiodev->card);
+		sdiodev->card = NULL;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(brcmf_sdio_remove);
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 68b6843..cf3b8fc 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -136,9 +136,6 @@ struct brcmf_sdio_dev {
 	void *bus;
 };
 
-/* Detach - freeup resources allocated in attach */
-extern int brcmf_sdcard_detach(struct brcmf_sdio_card *card);
-
 /* Enable/disable SD interrupt */
 extern int brcmf_sdcard_intr_enable(struct brcmf_sdio_card *card);
 extern int brcmf_sdcard_intr_disable(struct brcmf_sdio_card *card);
-- 
1.7.4.1


