Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1713 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab1HHN7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 72/82] staging: brcm80211: remove function pointer of
 interrupt isr in brcmfmac
Date: Mon, 8 Aug 2011 15:58:56 +0200
Message-ID: <1312811946-16713-73-git-send-email-arend@broadcom.com> (sfid-20110808_160009_541140_140CDDB7)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

The use of function pointer of bus interrupt isr is no longer needed
in fullmac as there is only one available isr.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    5 ++---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   19 +++----------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |    3 ++-
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |   10 +++-------
 4 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 3a6c015..c9893e9 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -53,10 +53,9 @@ brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
 				    len, set);
 }
 
-int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev,
-			  void (*fn)(void *), void *argh)
+int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
 {
-	return brcmf_sdioh_interrupt_register(sdiodev->sdioh, fn, argh);
+	return brcmf_sdioh_interrupt_register(sdiodev->sdioh);
 }
 
 int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index db43b09..1256847 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -228,19 +228,9 @@ extern int brcmf_sdioh_detach(struct sdioh_info *sd)
 
 /* Configure callback to client when we receive client interrupt */
 extern int
-brcmf_sdioh_interrupt_register(struct sdioh_info *sd, void (*fn)(void *),
-			       void *argh)
+brcmf_sdioh_interrupt_register(struct sdioh_info *sd)
 {
 	BRCMF_TRACE(("%s: Entering\n", __func__));
-	if (fn == NULL) {
-		BRCMF_ERROR(("%s: interrupt handler is NULL, not registering\n",
-			__func__));
-		return -EINVAL;
-	}
-
-	sd->intr_handler = fn;
-	sd->intr_handler_arg = argh;
-	sd->intr_handler_valid = true;
 
 	/* register and unmask irq */
 	if (gInstance->func[2]) {
@@ -277,10 +267,6 @@ extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 		sdio_release_host(gInstance->func[2]);
 	}
 
-	sd->intr_handler_valid = false;
-	sd->intr_handler = NULL;
-	sd->intr_handler_arg = NULL;
-
 	return 0;
 }
 
@@ -877,6 +863,7 @@ brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
 static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
 	struct sdioh_info *sd;
+	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
 
 	BRCMF_TRACE(("brcmf: ***IRQHandler\n"));
 	sd = gInstance->sd;
@@ -884,7 +871,7 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 	sdio_release_host(gInstance->func[0]);
 
 	sd->intrcount++;
-	(sd->intr_handler) (sd->intr_handler_arg);
+	brcmf_sdbrcm_isr(sdiodev->bus);
 
 	sdio_claim_host(gInstance->func[0]);
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index eb3cf10..74c9d4e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -5424,6 +5424,7 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 		goto fail;
 	}
 	bus->sdiodev = sdiodev;
+	sdiodev->bus = bus;
 	bus->bus = BRCMF_BUS;
 	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
 	bus->usebufpool = false;	/* Use bufpool if allocated,
@@ -5506,7 +5507,7 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	/* Register interrupt callback, but mask it (not operational yet). */
 	BRCMF_INTR(("%s: disable SDIO interrupts (not interested yet)\n",
 		    __func__));
-	ret = brcmf_sdcard_intr_reg(bus->sdiodev, brcmf_sdbrcm_isr, bus);
+	ret = brcmf_sdcard_intr_reg(bus->sdiodev);
 	if (ret != 0) {
 		BRCMF_ERROR(("%s: FAILED: sdcard_intr_reg returned %d\n",
 			     __func__, ret));
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 4fcba2a..c5a68c0 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -124,9 +124,6 @@ struct brcmf_sdreg {
 
 struct sdioh_info {
 	struct osl_info *osh;		/* osh handler */
-	bool intr_handler_valid; /* client driver interrupt handler valid */
-	void (*intr_handler)(void *);	/* registered interrupt handler */
-	void *intr_handler_arg;	/* argument to call interrupt handler */
 
 	uint irq;		/* Client irq */
 	int intrcount;		/* Client interrupts */
@@ -159,8 +156,7 @@ struct brcmf_sdio_dev {
 
 /* Register/deregister device interrupt handler. */
 extern int
-brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev,
-		      void (*fn)(void *), void *argh);
+brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev);
 
 extern int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev);
 
@@ -278,8 +274,7 @@ extern struct sdioh_info *brcmf_sdioh_attach(void *cfghdl);
 extern int brcmf_sdioh_detach(struct sdioh_info *si);
 
 extern int
-brcmf_sdioh_interrupt_register(struct sdioh_info *si,
-			       void (*sdioh_cb_fn)(void *), void *argh);
+brcmf_sdioh_interrupt_register(struct sdioh_info *si);
 
 extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *si);
 
@@ -328,4 +323,5 @@ extern struct brcmf_sdmmc_instance *gInstance;
 extern void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 				u32 regsva, struct brcmf_sdio_dev *sdiodev);
 extern void brcmf_sdbrcm_disconnect(void *ptr);
+extern void brcmf_sdbrcm_isr(void *arg);
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.4.1


