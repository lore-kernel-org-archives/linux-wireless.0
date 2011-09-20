Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:32884 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752141Ab1ITA7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 20:59:33 -0400
Subject: Re: [PATCH 20/20] staging: brcm80211: reduced checkpatch warnings
 to zero
From: Joe Perches <joe@perches.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Date: Mon, 19 Sep 2011 17:59:32 -0700
In-Reply-To: <1316477060.27998.4.camel@Joe-Laptop>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	 <1316467568-27683-21-git-send-email-frankyl@broadcom.com>
	 <1316477060.27998.4.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1316480372.30319.1.camel@Joe-Laptop> (sfid-20110920_025936_759728_0AF15ACC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-19 at 17:04 -0700, Joe Perches wrote:
> It'd be better if you could find some way
> to reduce the 6 tab indentation rather than
> split 20 char format strings into pieces.

Perhaps something like this:

 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  112 ++++++++++-----------
 1 files changed, 54 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index a15765b..ccba1ce 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -240,6 +240,53 @@ brcmf_sdioh_cis_read(struct brcmf_sdio_dev *sdiodev, uint func,
 	return 0;
 }
 
+static void
+brcmf_sdioh_request_byte_func0(struct brcmf_sdio_dev *sdiodev, uint rw,
+			       uint func, uint regaddr, u8 *byte, int *err_ret)
+{
+	/* Can only directly write to some F0 registers.
+	 * Handle F2 enable as a special case.
+	 */
+	if (regaddr == SDIO_CCCR_IOEx) {
+		if (sdiodev->func[2]) {
+			sdio_claim_host(sdiodev->func[2]);
+			if (*byte & SDIO_FUNC_ENABLE_2) {
+				/* Enable Function 2 */
+				*err_ret = sdio_enable_func(sdiodev->func[2]);
+				if (*err_ret)
+					brcmf_dbg(ERROR,
+						  "enable F2 failed:%d\n",
+						  *err_ret);
+			} else {
+				/* Disable Function 2 */
+				*err_ret = sdio_disable_func(sdiodev->func[2]);
+				if (*err_ret)
+					brcmf_dbg(ERROR,
+						  "Disable F2 failed:%d\n",
+						  *err_ret);
+			}
+			sdio_release_host(sdiodev->func[2]);
+		}
+	} else if (regaddr == SDIO_CCCR_ABORT) {
+		/* to allow abort command through F1 */
+		sdio_claim_host(sdiodev->func[func]);
+		/*
+		 * this sdio_f0_writeb() can be replaced with another api
+		 * depending upon MMC driver change.
+		 * As of this time, this is temporary one
+		 */
+		sdio_writeb(sdiodev->func[func], *byte, regaddr, err_ret);
+		sdio_release_host(sdiodev->func[func]);
+	} else if (regaddr < 0xF0) {
+		brcmf_dbg(ERROR, "F0 Wr:0x%02x: write disallowed\n", regaddr);
+	} else {
+		/* Claim host controller, perform F0 write, and release */
+		sdio_claim_host(sdiodev->func[func]);
+		sdio_f0_writeb(sdiodev->func[func], *byte, regaddr, err_ret);
+		sdio_release_host(sdiodev->func[func]);
+	}
+}
+
 extern int
 brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 			 uint regaddr, u8 *byte)
@@ -252,58 +299,9 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
 	if (rw) {		/* CMD52 Write */
 		if (func == 0) {
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
+			brcmf_sdioh_request_byte_func0(sdiodev, rw, func,
+						       regaddr, byte,
+						       &err_ret);
 		} else {
 			/* Claim host controller, perform Fn write,
 			 and release */
@@ -317,13 +315,11 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 		sdio_claim_host(sdiodev->func[func]);
 
 		if (func == 0) {
-			*byte =
-			    sdio_f0_readb(sdiodev->func[func], regaddr,
-					  &err_ret);
+			*byte = sdio_f0_readb(sdiodev->func[func], regaddr,
+					      &err_ret);
 		} else {
-			*byte =
-			    sdio_readb(sdiodev->func[func], regaddr,
-				       &err_ret);
+			*byte = sdio_readb(sdiodev->func[func], regaddr,
+					   &err_ret);
 		}
 
 		sdio_release_host(sdiodev->func[func]);


