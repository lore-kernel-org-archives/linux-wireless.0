Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2412 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab1JBRO7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:14:59 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 13/20] staging: brcm80211: reducing indentation levels
 in bcmsdh_sdmmc.c
Date: Sun, 2 Oct 2011 10:14:38 -0700
Message-ID: <1317575685-3156-14-git-send-email-frankyl@broadcom.com> (sfid-20111002_191512_962779_89808714)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Some functions in the source file had a lot of indentation levels
forcing statements to be spread over multiple lines impairing the
readability of the code.

Reported-by: Joe Perches <joe@perches.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  140 +++++++++-----------
 1 files changed, 63 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 1cbdb80..fc95bb2 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -70,6 +70,54 @@ brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev, wait_queue_head_t *wq)
 #endif
 }
 
+static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
+					    uint regaddr, u8 *byte)
+{
+	struct sdio_func *sdfunc = sdiodev->func[0];
+	int err_ret;
+
+	/*
+	 * Can only directly write to some F0 registers.
+	 * Handle F2 enable/disable and Abort command
+	 * as a special case.
+	 */
+	if (regaddr == SDIO_CCCR_IOEx) {
+		sdfunc = sdiodev->func[2];
+		if (sdfunc) {
+			sdio_claim_host(sdfunc);
+			if (*byte & SDIO_FUNC_ENABLE_2) {
+				/* Enable Function 2 */
+				err_ret = sdio_enable_func(sdfunc);
+				if (err_ret)
+					brcmf_dbg(ERROR,
+						  "enable F2 failed:%d\n",
+						  err_ret);
+			} else {
+				/* Disable Function 2 */
+				err_ret = sdio_disable_func(sdfunc);
+				if (err_ret)
+					brcmf_dbg(ERROR,
+						  "Disable F2 failed:%d\n",
+						  err_ret);
+			}
+			sdio_release_host(sdfunc);
+		}
+	} else if (regaddr == SDIO_CCCR_ABORT) {
+		sdio_claim_host(sdfunc);
+		sdio_writeb(sdfunc, *byte, regaddr, &err_ret);
+		sdio_release_host(sdfunc);
+	} else if (regaddr < 0xF0) {
+		brcmf_dbg(ERROR, "F0 Wr:0x%02x: write disallowed\n", regaddr);
+		err_ret = -EPERM;
+	} else {
+		sdio_claim_host(sdfunc);
+		sdio_f0_writeb(sdfunc, *byte, regaddr, &err_ret);
+		sdio_release_host(sdfunc);
+	}
+
+	return err_ret;
+}
+
 int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 			     uint regaddr, u8 *byte)
 {
@@ -80,82 +128,22 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_byte_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
-	if (rw) {		/* CMD52 Write */
-		if (func == 0) {
-			/* Can only directly write to some F0 registers.
-			 * Handle F2 enable
-			 * as a special case.
-			 */
-			if (regaddr == SDIO_CCCR_IOEx) {
-				if (sdiodev->func[2]) {
-					sdio_claim_host(sdiodev->func[2]);
-					if (*byte & SDIO_FUNC_ENABLE_2) {
-						/* Enable Function 2 */
-						err_ret =
-						    sdio_enable_func
-						    (sdiodev->func[2]);
-						if (err_ret)
-							brcmf_dbg(ERROR,
-								  "enable F2 failed:%d\n",
-								  err_ret);
-					} else {
-						/* Disable Function 2 */
-						err_ret =
-						    sdio_disable_func
-						    (sdiodev->func[2]);
-						if (err_ret)
-							brcmf_dbg(ERROR,
-								  "Disable F2 failed:%d\n",
-								  err_ret);
-					}
-					sdio_release_host(sdiodev->func[2]);
-				}
-			}
-			/* to allow abort command through F1 */
-			else if (regaddr == SDIO_CCCR_ABORT) {
-				sdio_claim_host(sdiodev->func[func]);
-				/*
-				 * this sdio_f0_writeb() can be replaced
-				 * with another api
-				 * depending upon MMC driver change.
-				 * As of this time, this is temporaray one
-				 */
-				sdio_writeb(sdiodev->func[func], *byte,
-					    regaddr, &err_ret);
-				sdio_release_host(sdiodev->func[func]);
-			} else if (regaddr < 0xF0) {
-				brcmf_dbg(ERROR, "F0 Wr:0x%02x: write disallowed\n",
-					  regaddr);
-			} else {
-				/* Claim host controller, perform F0 write,
-				 and release */
-				sdio_claim_host(sdiodev->func[func]);
-				sdio_f0_writeb(sdiodev->func[func], *byte,
-					       regaddr, &err_ret);
-				sdio_release_host(sdiodev->func[func]);
-			}
-		} else {
-			/* Claim host controller, perform Fn write,
-			 and release */
-			sdio_claim_host(sdiodev->func[func]);
+
+	if (rw && func == 0) {
+		/* handle F0 separately */
+		err_ret = brcmf_sdioh_f0_write_byte(sdiodev, regaddr, byte);
+	} else {
+		sdio_claim_host(sdiodev->func[func]);
+		if (rw) /* CMD52 Write */
 			sdio_writeb(sdiodev->func[func], *byte, regaddr,
 				    &err_ret);
-			sdio_release_host(sdiodev->func[func]);
-		}
-	} else {		/* CMD52 Read */
-		/* Claim host controller, perform Fn read, and release */
-		sdio_claim_host(sdiodev->func[func]);
-
-		if (func == 0) {
-			*byte =
-			    sdio_f0_readb(sdiodev->func[func], regaddr,
-					  &err_ret);
+		else if (func == 0) {
+			*byte = sdio_f0_readb(sdiodev->func[func], regaddr,
+					      &err_ret);
 		} else {
-			*byte =
-			    sdio_readb(sdiodev->func[func], regaddr,
-				       &err_ret);
+			*byte = sdio_readb(sdiodev->func[func], regaddr,
+					   &err_ret);
 		}
-
 		sdio_release_host(sdiodev->func[func]);
 	}
 
@@ -197,12 +185,10 @@ int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 			brcmf_dbg(ERROR, "Invalid nbytes: %d\n", nbytes);
 	} else {		/* CMD52 Read */
 		if (nbytes == 4)
-			*word =
-			    sdio_readl(sdiodev->func[func], addr, &err_ret);
+			*word = sdio_readl(sdiodev->func[func], addr, &err_ret);
 		else if (nbytes == 2)
-			*word =
-			    sdio_readw(sdiodev->func[func], addr,
-				       &err_ret) & 0xFFFF;
+			*word = sdio_readw(sdiodev->func[func], addr,
+					   &err_ret) & 0xFFFF;
 		else
 			brcmf_dbg(ERROR, "Invalid nbytes: %d\n", nbytes);
 	}
-- 
1.7.1


