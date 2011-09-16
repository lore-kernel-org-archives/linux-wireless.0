Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4647 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab1IPT2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:25 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 17/19] staging: brcm80211: remove global variable from
 bcmsdh_sdmmc.c
Date: Fri, 16 Sep 2011 12:28:06 -0700
Message-ID: <1316201288-29635-18-git-send-email-frankyl@broadcom.com> (sfid-20110916_212855_755028_1E463D27)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The source file contained some static global variables that were
needed per device handled by the driver. They have moved to the
struct brcmf_sdio_dev for that reason.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   21 ++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    5 +++++
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 65cd5d7..443e3a8 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -50,11 +50,6 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 
-static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_byte_wait);
-static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_word_wait);
-static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_packet_wait);
-static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_buffer_wait);
-
 static bool
 brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
 {
@@ -66,12 +61,12 @@ brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
 }
 
 static void
-brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev, wait_queue_head_t wq)
+brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev, wait_queue_head_t *wq)
 {
 #ifdef CONFIG_PM_SLEEP
 	int retry = 0;
 	while (atomic_read(&sdiodev->suspend) && retry++ != 30)
-		wait_event_timeout(wq, false, HZ/100);
+		wait_event_timeout(*wq, false, HZ/100);
 #endif
 }
 
@@ -82,7 +77,7 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 
 	brcmf_dbg(INFO, "rw=%d, func=%d, addr=0x%05x\n", rw, func, regaddr);
 
-	brcmf_pm_resume_wait(sdiodev, sdioh_request_byte_wait);
+	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_byte_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 	if (rw) {		/* CMD52 Write */
@@ -185,7 +180,7 @@ int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 	brcmf_dbg(INFO, "rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
 		  rw, func, addr, nbytes);
 
-	brcmf_pm_resume_wait(sdiodev, sdioh_request_word_wait);
+	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_word_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 	/* Claim host controller */
@@ -235,7 +230,7 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	brcmf_pm_resume_wait(sdiodev, sdioh_request_packet_wait);
+	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_packet_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 
@@ -312,7 +307,7 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	brcmf_pm_resume_wait(sdiodev, sdioh_request_buffer_wait);
+	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 	/* Case 1: we don't have a packet. */
@@ -529,6 +524,10 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		dev_set_drvdata(&func->card->dev, sdiodev);
 
 		atomic_set(&sdiodev->suspend, false);
+		init_waitqueue_head(&sdiodev->request_byte_wait);
+		init_waitqueue_head(&sdiodev->request_word_wait);
+		init_waitqueue_head(&sdiodev->request_packet_wait);
+		init_waitqueue_head(&sdiodev->request_buffer_wait);
 	}
 
 	if (func->num == 2) {
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index fb5f6b5..397ad48 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -130,6 +130,11 @@ struct brcmf_sdio_dev {
 	bool regfail;			/* status of last reg_r/w call */
 	void *bus;
 	atomic_t suspend;		/* suspend flag */
+	wait_queue_head_t request_byte_wait;
+	wait_queue_head_t request_word_wait;
+	wait_queue_head_t request_packet_wait;
+	wait_queue_head_t request_buffer_wait;
+
 };
 
 /* Register/deregister device interrupt handler. */
-- 
1.7.1


