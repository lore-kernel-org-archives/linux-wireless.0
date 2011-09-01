Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2996 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab1IAJRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:48 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 11/30] staging: brcm80211: cleaned up fullmac macro
 BRCMF_PM_RESUME_RETURN_ERROR
Date: Thu, 1 Sep 2011 11:17:01 +0200
Message-ID: <1314868640-9425-12-git-send-email-rvossen@broadcom.com> (sfid-20110901_111817_809847_8808A24C)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Macros impacting the code flow are sort of frowned upon. No other macro's
in the source code impact the code flow. Replaced macro by function.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   25 +++++++++++++++------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index a15765b..d3d3890 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -90,17 +90,24 @@ DECLARE_WAIT_QUEUE_HEAD(sdioh_request_buffer_wait);
 			wait_event_timeout(a, false, HZ/100); \
 		} \
 	}	while (0)
-#define BRCMF_PM_RESUME_RETURN_ERROR(a, b)	\
-	do { if (atomic_read(&b->suspend)) return a; } while (0)
 #else
 #define BRCMF_PM_RESUME_WAIT(a, b)
-#define BRCMF_PM_RESUME_RETURN_ERROR(a, b)
 #endif		/* CONFIG_PM_SLEEP */
 
 static int
 brcmf_sdioh_card_regread(struct brcmf_sdio_dev *sdiodev, int func, u32 regaddr,
 			 int regsize, u32 *data);
 
+static bool
+brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
+{
+	bool is_err = false;
+#ifdef CONFIG_PM_SLEEP
+	is_err = atomic_read(&sdiodev->suspend);
+#endif
+	return is_err;
+}
+
 static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 {
 	int err_ret;
@@ -249,7 +256,8 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 	brcmf_dbg(INFO, "rw=%d, func=%d, addr=0x%05x\n", rw, func, regaddr);
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_byte_wait, sdiodev);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
+	if (brcmf_pm_resume_error(sdiodev))
+		return -EIO;
 	if (rw) {		/* CMD52 Write */
 		if (func == 0) {
 			/* Can only directly write to some F0 registers.
@@ -351,7 +359,8 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type, uint rw,
 		  cmd_type, rw, func, addr, nbytes);
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_word_wait, sdiodev);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
+	if (brcmf_pm_resume_error(sdiodev))
+		return -EIO;
 	/* Claim host controller */
 	sdio_claim_host(sdiodev->func[func]);
 
@@ -400,7 +409,8 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 	brcmf_dbg(TRACE, "Enter\n");
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_packet_wait, sdiodev);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
+	if (brcmf_pm_resume_error(sdiodev))
+		return -EIO;
 
 	/* Claim host controller */
 	sdio_claim_host(sdiodev->func[func]);
@@ -477,7 +487,8 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
 	brcmf_dbg(TRACE, "Enter\n");
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_buffer_wait, sdiodev);
-	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
+	if (brcmf_pm_resume_error(sdiodev))
+		return -EIO;
 	/* Case 1: we don't have a packet. */
 	if (pkt == NULL) {
 		brcmf_dbg(DATA, "Creating new %s Packet, len=%d\n",
-- 
1.7.4.1


