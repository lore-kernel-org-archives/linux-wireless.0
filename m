Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1922 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab1HLNfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/14] staging: brcm80211: absorb
 brcmf_sdioh_interrupt_register into brcmf_sdcard_intr_reg
Date: Fri, 12 Aug 2011 15:34:54 +0200
Message-ID: <1313156101-16817-8-git-send-email-arend@broadcom.com> (sfid-20110812_153521_746337_2E5C8F61)
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

brcmfmac wrapper function cleanup

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   22 ++++++++++-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   43 ---------------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    1 -
 3 files changed, 21 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 13b6dbe..e5cf138 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -21,6 +21,7 @@
 #include <linux/pci_ids.h>
 #include <linux/sched.h>
 #include <linux/completion.h>
+#include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
 
 #include <defs.h>
@@ -162,9 +163,28 @@ exit:
 	return bcmerror;
 }
 
+static void brcmf_sdioh_irqhandler(struct sdio_func *func)
+{
+	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
+
+	BRCMF_TRACE(("brcmf: ***IRQHandler\n"));
+
+	sdio_release_host(func);
+
+	brcmf_sdbrcm_isr(sdiodev->bus);
+
+	sdio_claim_host(func);
+}
+
 int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
 {
-	return brcmf_sdioh_interrupt_register(sdiodev);
+	BRCMF_TRACE(("%s: Entering\n", __func__));
+
+	sdio_claim_host(sdiodev->func[1]);
+	sdio_claim_irq(sdiodev->func[1], brcmf_sdioh_irqhandler);
+	sdio_release_host(sdiodev->func[1]);
+
+	return 0;
 }
 
 int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 1bfeec6..2e7d3ce 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -44,8 +44,6 @@
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
 #endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
 
-static void brcmf_sdioh_irqhandler(struct sdio_func *func);
-static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func);
 static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr);
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
 				const struct sdio_device_id *id);
@@ -192,28 +190,6 @@ void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
 
 }
 
-/* Configure callback to client when we receive client interrupt */
-extern int
-brcmf_sdioh_interrupt_register(struct brcmf_sdio_dev *sdiodev)
-{
-	BRCMF_TRACE(("%s: Entering\n", __func__));
-
-	/* register and unmask irq */
-	if (sdiodev->func[2]) {
-		sdio_claim_host(sdiodev->func[2]);
-		sdio_claim_irq(sdiodev->func[2], brcmf_sdioh_irqhandler_f2);
-		sdio_release_host(sdiodev->func[2]);
-	}
-
-	if (sdiodev->func[1]) {
-		sdio_claim_host(sdiodev->func[1]);
-		sdio_claim_irq(sdiodev->func[1], brcmf_sdioh_irqhandler);
-		sdio_release_host(sdiodev->func[1]);
-	}
-
-	return 0;
-}
-
 int brcmf_sdioh_interrupt_deregister(struct brcmf_sdio_dev *sdiodev)
 {
 	BRCMF_TRACE(("%s: Entering\n", __func__));
@@ -662,25 +638,6 @@ brcmf_sdioh_card_regread(struct brcmf_sdio_dev *sdiodev, int func, u32 regaddr,
 	return SUCCESS;
 }
 
-static void brcmf_sdioh_irqhandler(struct sdio_func *func)
-{
-	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
-
-	BRCMF_TRACE(("brcmf: ***IRQHandler\n"));
-
-	sdio_release_host(func);
-
-	brcmf_sdbrcm_isr(sdiodev->bus);
-
-	sdio_claim_host(func);
-}
-
-/* interrupt handler for F2 (dummy handler) */
-static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func)
-{
-	BRCMF_TRACE(("brcmf: ***IRQHandlerF2\n"));
-}
-
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
 			      const struct sdio_device_id *id)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 4a814e5..bdbf411 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -247,7 +247,6 @@ extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev);
 extern int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev);
 extern void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev);
 
-extern int brcmf_sdioh_interrupt_register(struct brcmf_sdio_dev *sdiodev);
 extern int brcmf_sdioh_interrupt_deregister(struct brcmf_sdio_dev *sdiodev);
 
 /* read or write one byte using cmd52 */
-- 
1.7.4.1


