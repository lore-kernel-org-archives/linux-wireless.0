Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36398 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbcEKWHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 18:07:41 -0400
Received: by mail-pa0-f52.google.com with SMTP id bt5so21659112pac.3
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2016 15:07:40 -0700 (PDT)
From: Christian Daudt <csd@broadcom.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Daudt <csd@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: [PATCH v2 2/2] brcmfmac: Fix 'did not remove int handler' warning
Date: Wed, 11 May 2016 15:06:49 -0700
Message-Id: <1463004409-28885-3-git-send-email-csd@broadcom.com> (sfid-20160512_000743_580373_95B8379E)
In-Reply-To: <1463004409-28885-1-git-send-email-csd@broadcom.com>
References: <1463004409-28885-1-git-send-email-csd@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_sdiod_intr_unregister call that removes both func1 and
func2 interrupt handlers only called when brcmf_ops_sdio_remove
is called for func 1 (which is the 2nd call) but sdio is expecting
it to be removed at the end of each sdio_remove call.
This is causing 'rmmod bcmrfmac' on a 4356-sdio chip to complain
with:
WARNING: driver brcmfmac did not remove its interrupt handler!

The modification makes calling brcmf_sdiod_intr_unregister multiple
times harmless by clearing the variables that track if interrupt
handlers have been installed, and then calls it on every
brcmf_ops_sdio_remove call instead of just remove for func 1.

Signed-off-by: Christian Daudt <csd@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c   | 17 +++++++++++------
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h |  2 +-
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 09635a9..590cd41 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -172,7 +172,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 	return 0;
 }
 
-int brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
+void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 {
 
 	brcmf_dbg(SDIO, "Entering oob=%d sd=%d\n",
@@ -195,6 +195,7 @@ int brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 		}
 		free_irq(pdata->oob_irq_nr, &sdiodev->func[1]->dev);
 		sdiodev->irq_en = false;
+		sdiodev->oob_irq_requested = false;
 	}
 
 	if (sdiodev->sd_irq_requested) {
@@ -202,9 +203,8 @@ int brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 		sdio_release_irq(sdiodev->func[2]);
 		sdio_release_irq(sdiodev->func[1]);
 		sdio_release_host(sdiodev->func[1]);
+		sdiodev->sd_irq_requested = false;
 	}
-
-	return 0;
 }
 
 void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
@@ -1200,12 +1200,17 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 	brcmf_dbg(SDIO, "sdio device ID: 0x%04x\n", func->device);
 	brcmf_dbg(SDIO, "Function: %d\n", func->num);
 
-	if (func->num != 1)
-		return;
-
 	bus_if = dev_get_drvdata(&func->dev);
 	if (bus_if) {
 		sdiodev = bus_if->bus_priv.sdio;
+
+		/* start by unregistering irqs */
+		brcmf_sdiod_intr_unregister(sdiodev);
+
+		if (func->num != 1)
+			return;
+
+		/* only proceed with rest of cleanup if func 1 */
 		brcmf_sdiod_remove(sdiodev);
 
 		dev_set_drvdata(&sdiodev->func[1]->dev, NULL);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index c07ad25..f3da32f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -294,7 +294,7 @@ struct sdpcmd_regs {
 
 /* Register/deregister interrupt handler. */
 int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev);
-int brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev);
+void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev);
 
 /* sdio device register access interface */
 u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
-- 
1.9.1

