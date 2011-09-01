Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1178 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 12/30] staging: brcm80211: replaced fullmac
 BRCMF_PM_RESUME_WAIT macro with function
Date: Thu, 1 Sep 2011 11:17:02 +0200
Message-ID: <1314868640-9425-13-git-send-email-rvossen@broadcom.com> (sfid-20110901_111750_212933_F47CC8B9)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Advantage is more readable code and better type checking.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   26 +++++++++++---------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index d3d3890..be022d2 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -84,14 +84,6 @@ DECLARE_WAIT_QUEUE_HEAD(sdioh_request_byte_wait);
 DECLARE_WAIT_QUEUE_HEAD(sdioh_request_word_wait);
 DECLARE_WAIT_QUEUE_HEAD(sdioh_request_packet_wait);
 DECLARE_WAIT_QUEUE_HEAD(sdioh_request_buffer_wait);
-#define BRCMF_PM_RESUME_WAIT(a, b) do { \
-		int retry = 0; \
-		while (atomic_read(&b->suspend) && retry++ != 30) { \
-			wait_event_timeout(a, false, HZ/100); \
-		} \
-	}	while (0)
-#else
-#define BRCMF_PM_RESUME_WAIT(a, b)
 #endif		/* CONFIG_PM_SLEEP */
 
 static int
@@ -108,6 +100,16 @@ brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
 	return is_err;
 }
 
+static void
+brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev, wait_queue_head_t wq)
+{
+#ifdef CONFIG_PM_SLEEP
+	int retry = 0;
+	while (atomic_read(&sdiodev->suspend) && retry++ != 30)
+		wait_event_timeout(wq, false, HZ/100);
+#endif
+}
+
 static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 {
 	int err_ret;
@@ -255,7 +257,7 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 
 	brcmf_dbg(INFO, "rw=%d, func=%d, addr=0x%05x\n", rw, func, regaddr);
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_byte_wait, sdiodev);
+	brcmf_pm_resume_wait(sdiodev, sdioh_request_byte_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 	if (rw) {		/* CMD52 Write */
@@ -358,7 +360,7 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type, uint rw,
 	brcmf_dbg(INFO, "cmd_type=%d, rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
 		  cmd_type, rw, func, addr, nbytes);
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_word_wait, sdiodev);
+	brcmf_pm_resume_wait(sdiodev, sdioh_request_word_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 	/* Claim host controller */
@@ -408,7 +410,7 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_packet_wait, sdiodev);
+	brcmf_pm_resume_wait(sdiodev, sdioh_request_packet_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 
@@ -486,7 +488,7 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	BRCMF_PM_RESUME_WAIT(sdioh_request_buffer_wait, sdiodev);
+	brcmf_pm_resume_wait(sdiodev, sdioh_request_buffer_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 	/* Case 1: we don't have a packet. */
-- 
1.7.4.1


