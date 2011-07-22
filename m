Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3341 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Franky Lin" <frankyl@broadcom.com>, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/29] staging: brcm80211: placed suspend flag in
 gInstance in brcmfmac
Date: Fri, 22 Jul 2011 20:57:01 +0200
Message-ID: <1311361036-3175-15-git-send-email-arend@broadcom.com> (sfid-20110722_205825_000585_D23CF0B9)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

One of the steps to remove global variable. gInstance will be
replaced by brcmf_sdio_dev in the upcoming patch.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   35 ++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    1 +
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 2a9efc3..edcd98e 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -66,7 +66,6 @@ static int brcmf_sdio_resume(struct device *dev);
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
 struct brcmf_sdmmc_instance *gInstance;
-static atomic_t brcmf_mmc_suspend;
 
 /* devices we support, null terminated */
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
@@ -100,17 +99,17 @@ DECLARE_WAIT_QUEUE_HEAD(sdioh_request_byte_wait);
 DECLARE_WAIT_QUEUE_HEAD(sdioh_request_word_wait);
 DECLARE_WAIT_QUEUE_HEAD(sdioh_request_packet_wait);
 DECLARE_WAIT_QUEUE_HEAD(sdioh_request_buffer_wait);
-#define BRCMF_PM_RESUME_WAIT(a) do { \
+#define BRCMF_PM_RESUME_WAIT(a, b) do { \
 		int retry = 0; \
-		while (atomic_read(&brcmf_mmc_suspend) && retry++ != 30) { \
+		while (atomic_read(&b->suspend) && retry++ != 30) { \
 			wait_event_timeout(a, false, HZ/100); \
 		} \
 	}	while (0)
-#define BRCMF_PM_RESUME_RETURN_ERROR(a)	\
-	do { if (atomic_read(&brcmf_mmc_suspend)) return a; } while (0)
+#define BRCMF_PM_RESUME_RETURN_ERROR(a, b)	\
+	do { if (atomic_read(&b->suspend)) return a; } while (0)
 #else
-#define BRCMF_PM_RESUME_WAIT(a)
-#define BRCMF_PM_RESUME_RETURN_ERROR(a)
+#define BRCMF_PM_RESUME_WAIT(a, b)
+#define BRCMF_PM_RESUME_RETURN_ERROR(a, b)
 #endif		/* CONFIG_PM_SLEEP */
 
 static int
@@ -571,8 +570,8 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 	BRCMF_INFO(("%s: rw=%d, func=%d, addr=0x%05x\n", __func__, rw, func,
 		 regaddr));
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_byte_wait);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_byte_wait, gInstance);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, gInstance);
 	if (rw) {		/* CMD52 Write */
 		if (func == 0) {
 			/* Can only directly write to some F0 registers.
@@ -678,8 +677,8 @@ brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 	BRCMF_INFO(("%s: cmd_type=%d, rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
 		 __func__, cmd_type, rw, func, addr, nbytes));
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_word_wait);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_word_wait, gInstance);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, gInstance);
 	/* Claim host controller */
 	sdio_claim_host(gInstance->func[func]);
 
@@ -728,8 +727,8 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_packet_wait);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_packet_wait, gInstance);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, gInstance);
 
 	/* Claim host controller */
 	sdio_claim_host(gInstance->func[func]);
@@ -806,8 +805,8 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_buffer_wait);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_buffer_wait, gInstance);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, gInstance);
 	/* Case 1: we don't have a packet. */
 	if (pkt == NULL) {
 		BRCMF_DATA(("%s: Creating new %s Packet, len=%d\n",
@@ -981,7 +980,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		sdiodev->func1 = func;
 		dev_set_drvdata(&func->card->dev, sdiodev);
 
-		atomic_set(&brcmf_mmc_suspend, false);
+		atomic_set(&gInstance->suspend, false);
 	}
 
 	gInstance->func[func->num] = func;
@@ -1029,7 +1028,7 @@ static int brcmf_sdio_suspend(struct device *dev)
 
 	BRCMF_TRACE(("%s\n", __func__));
 
-	atomic_set(&brcmf_mmc_suspend, true);
+	atomic_set(&gInstance->suspend, true);
 
 	sdio_flags = sdio_get_host_pm_caps(gInstance->func[1]);
 	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
@@ -1056,7 +1055,7 @@ static int brcmf_sdio_resume(struct device *dev)
 
 	sdiodev = dev_get_drvdata(&func->card->dev);
 	brcmf_sdio_wdtmr_enable(sdiodev, true);
-	atomic_set(&brcmf_mmc_suspend, false);
+	atomic_set(&gInstance->suspend, false);
 	return 0;
 }
 #endif		/* CONFIG_PM_SLEEP */
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index aecc8e3..f4e2329 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -152,6 +152,7 @@ struct brcmf_sdmmc_instance {
 	struct sdioh_info *sd;
 	struct sdio_func *func[SDIOD_MAX_IOFUNCS];
 	u32 host_claimed;
+	atomic_t suspend;	/* suspend flag */
 };
 
 struct brcmf_sdio_dev {
-- 
1.7.4.1


