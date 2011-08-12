Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1919 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab1HLNfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/14] staging: brcm80211: absorb brcmf_sdioh_abort into
 brcmf_sdcard_abort
Date: Fri, 12 Aug 2011 15:34:56 +0200
Message-ID: <1313156101-16817-10-git-send-email-arend@broadcom.com> (sfid-20110812_153517_042549_B7E7A550)
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
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   11 ++++++++++-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   14 --------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    3 ---
 3 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 6c1b57d..8bb84a9 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -21,6 +21,7 @@
 #include <linux/pci_ids.h>
 #include <linux/sched.h>
 #include <linux/completion.h>
+#include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
 
@@ -476,7 +477,15 @@ int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
 
 int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 {
-	return brcmf_sdioh_abort(sdiodev, fn);
+	char t_func = (char)fn;
+	BRCMF_TRACE(("%s: Enter\n", __func__));
+
+	/* issue abort cmd52 command through F0 */
+	brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, SDIO_FUNC_0,
+				 SDIO_CCCR_ABORT, &t_func);
+
+	BRCMF_TRACE(("%s: Exit\n", __func__));
+	return 0;
 }
 
 u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 1dfad3e..d7648f8 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -576,20 +576,6 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
 	return Status;
 }
 
-/* this function performs "abort" for both of host & device */
-extern int brcmf_sdioh_abort(struct brcmf_sdio_dev *sdiodev, uint func)
-{
-	char t_func = (char)func;
-	BRCMF_TRACE(("%s: Enter\n", __func__));
-
-	/* issue abort cmd52 command through F0 */
-	brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, SDIO_FUNC_0,
-				 SDIO_CCCR_ABORT, &t_func);
-
-	BRCMF_TRACE(("%s: Exit\n", __func__));
-	return 0;
-}
-
 /* Read client card reg */
 int
 brcmf_sdioh_card_regread(struct brcmf_sdio_dev *sdiodev, int func, u32 regaddr,
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index d980307..555f17b 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -273,9 +273,6 @@ extern int brcmf_sdioh_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fuc,
 extern int brcmf_sdioh_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fuc,
 				 u32 addr, u8 *data);
 
-/* Issue abort to the specified function and clear controller as needed */
-extern int brcmf_sdioh_abort(struct brcmf_sdio_dev *sdiodev, uint fnc);
-
 /* Watchdog timer interface for pm ops */
 extern void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev,
 				    bool enable);
-- 
1.7.4.1


