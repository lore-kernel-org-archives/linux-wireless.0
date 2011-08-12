Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1921 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab1HLNfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/14] staging: brcm80211: absorb
 brcmf_sdioh_interrupt_deregister into brcmf_sdcard_intr_dereg
Date: Fri, 12 Aug 2011 15:34:55 +0200
Message-ID: <1313156101-16817-9-git-send-email-arend@broadcom.com> (sfid-20110812_153522_812933_C03953AF)
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
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    8 ++++++-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   22 ---------------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    2 -
 3 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index e5cf138..6c1b57d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -189,7 +189,13 @@ int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
 
 int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev)
 {
-	return brcmf_sdioh_interrupt_deregister(sdiodev);
+	BRCMF_TRACE(("%s: Entering\n", __func__));
+
+	sdio_claim_host(sdiodev->func[1]);
+	sdio_release_irq(sdiodev->func[1]);
+	sdio_release_host(sdiodev->func[1]);
+
+	return 0;
 }
 
 u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 2e7d3ce..1dfad3e 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -190,28 +190,6 @@ void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
 
 }
 
-int brcmf_sdioh_interrupt_deregister(struct brcmf_sdio_dev *sdiodev)
-{
-	BRCMF_TRACE(("%s: Entering\n", __func__));
-
-	if (sdiodev->func[1]) {
-		/* register and unmask irq */
-		sdio_claim_host(sdiodev->func[1]);
-		sdio_release_irq(sdiodev->func[1]);
-		sdio_release_host(sdiodev->func[1]);
-	}
-
-	if (sdiodev->func[2]) {
-		/* Claim host controller F2 */
-		sdio_claim_host(sdiodev->func[2]);
-		sdio_release_irq(sdiodev->func[2]);
-		/* Release host controller F2 */
-		sdio_release_host(sdiodev->func[2]);
-	}
-
-	return 0;
-}
-
 extern int
 brcmf_sdioh_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 		     u8 *data)
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index bdbf411..d980307 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -247,8 +247,6 @@ extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev);
 extern int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev);
 extern void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev);
 
-extern int brcmf_sdioh_interrupt_deregister(struct brcmf_sdio_dev *sdiodev);
-
 /* read or write one byte using cmd52 */
 extern int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw,
 				    uint fnc, uint addr, u8 *byte);
-- 
1.7.4.1


