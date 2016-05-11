Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33901 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbcEKWHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 18:07:32 -0400
Received: by mail-pa0-f43.google.com with SMTP id r5so22686569pag.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2016 15:07:32 -0700 (PDT)
From: Christian Daudt <csd@broadcom.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Daudt <csd@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: [PATCH v2 1/2] brcmfmac: Fix kernel oops in failed chip_attach
Date: Wed, 11 May 2016 15:06:48 -0700
Message-Id: <1463004409-28885-2-git-send-email-csd@broadcom.com> (sfid-20160512_000735_443113_340D1DCD)
In-Reply-To: <1463004409-28885-1-git-send-email-csd@broadcom.com>
References: <1463004409-28885-1-git-send-email-csd@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When chip attach fails, brcmf_sdiod_intr_unregister is being called
but that is too early as sdiodev->settings has not been set yet
nor has brcmf_sdiod_intr_register been called.
Change to use oob_irq_requested + newly created sd_irq_requested
to decide on what to unregister at intr_unregister time.

Steps to reproduce problem:
- modprobe brcmfmac using buggy FW
- rmmod brcmfmac
- modprobe brcmfmac again.

If done with a buggy firmware, brcm_chip_attach will fail on the
2nd modprobe triggering the call to intr_unregister and the
kernel oops when attempting to de-reference sdiodev->settings->bus.sdio
which has not yet been set.

Signed-off-by: Christian Daudt <csd@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 30 ++++++++++++----------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  1 +
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index da0cdd3..09635a9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -166,6 +166,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 		sdio_claim_irq(sdiodev->func[1], brcmf_sdiod_ib_irqhandler);
 		sdio_claim_irq(sdiodev->func[2], brcmf_sdiod_dummy_irqhandler);
 		sdio_release_host(sdiodev->func[1]);
+		sdiodev->sd_irq_requested = true;
 	}
 
 	return 0;
@@ -173,27 +174,30 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 int brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 {
-	struct brcmfmac_sdio_pd *pdata;
 
-	brcmf_dbg(SDIO, "Entering\n");
+	brcmf_dbg(SDIO, "Entering oob=%d sd=%d\n",
+		  sdiodev->oob_irq_requested,
+		  sdiodev->sd_irq_requested);
 
-	pdata = &sdiodev->settings->bus.sdio;
-	if (pdata->oob_irq_supported) {
+	if (sdiodev->oob_irq_requested) {
+		struct brcmfmac_sdio_pd *pdata;
+
+		pdata = &sdiodev->settings->bus.sdio;
 		sdio_claim_host(sdiodev->func[1]);
 		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
 		brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
 		sdio_release_host(sdiodev->func[1]);
 
-		if (sdiodev->oob_irq_requested) {
-			sdiodev->oob_irq_requested = false;
-			if (sdiodev->irq_wake) {
-				disable_irq_wake(pdata->oob_irq_nr);
-				sdiodev->irq_wake = false;
-			}
-			free_irq(pdata->oob_irq_nr, &sdiodev->func[1]->dev);
-			sdiodev->irq_en = false;
+		sdiodev->oob_irq_requested = false;
+		if (sdiodev->irq_wake) {
+			disable_irq_wake(pdata->oob_irq_nr);
+			sdiodev->irq_wake = false;
 		}
-	} else {
+		free_irq(pdata->oob_irq_nr, &sdiodev->func[1]->dev);
+		sdiodev->irq_en = false;
+	}
+
+	if (sdiodev->sd_irq_requested) {
 		sdio_claim_host(sdiodev->func[1]);
 		sdio_release_irq(sdiodev->func[2]);
 		sdio_release_irq(sdiodev->func[1]);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index dcf0ce8c..c07ad25 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -186,6 +186,7 @@ struct brcmf_sdio_dev {
 	struct brcmf_bus *bus_if;
 	struct brcmf_mp_device *settings;
 	bool oob_irq_requested;
+	bool sd_irq_requested;
 	bool irq_en;			/* irq enable flags */
 	spinlock_t irq_en_lock;
 	bool irq_wake;			/* irq wake enable flags */
-- 
1.9.1

