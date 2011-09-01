Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1179 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 17/30] staging: brcm80211: remove unused sdioh command
 type code in fullmac
Date: Thu, 1 Sep 2011 11:17:07 +0200
Message-ID: <1314868640-9425-18-git-send-email-rvossen@broadcom.com> (sfid-20110901_111749_696951_B3E76EF3)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

sdioh command type is not used in brcmf_sdioh_request_word. This patch
removes the related code.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   12 ++++--------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    8 ++++----
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index e0fe7c2..e35c56a 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -37,10 +37,6 @@
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
-#define SDIOH_CMD_TYPE_NORMAL   0	/* Normal command */
-#define SDIOH_CMD_TYPE_APPEND   1	/* Append command */
-#define SDIOH_CMD_TYPE_CUTTHRU  2	/* Cut-through command */
-
 /* Module parameters specific to each host-controller driver */
 
 module_param(sd_f2_blocksize, int, 0);
@@ -311,8 +307,8 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size)
 	if (size == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = brcmf_sdioh_request_word(sdiodev, SDIOH_CMD_TYPE_NORMAL,
-				    SDIOH_READ, SDIO_FUNC_1, addr, &word, size);
+	status = brcmf_sdioh_request_word(sdiodev, SDIOH_READ, SDIO_FUNC_1,
+					  addr, &word, size);
 
 	sdiodev->regfail = (status != 0);
 
@@ -360,8 +356,8 @@ u32 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size,
 	if (size == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 	status =
-	    brcmf_sdioh_request_word(sdiodev, SDIOH_CMD_TYPE_NORMAL,
-			       SDIOH_WRITE, SDIO_FUNC_1, addr, &data, size);
+	    brcmf_sdioh_request_word(sdiodev, SDIOH_WRITE, SDIO_FUNC_1,
+				     addr, &data, size);
 	sdiodev->regfail = (status != 0);
 
 	if (status == 0)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index b316866..ef09a63 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -347,7 +347,7 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 }
 
 extern int
-brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type, uint rw,
+brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint rw,
 			 uint func, uint addr, u32 *word, uint nbytes)
 {
 	int err_ret = -EIO;
@@ -357,8 +357,8 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type, uint rw,
 		return -EINVAL;
 	}
 
-	brcmf_dbg(INFO, "cmd_type=%d, rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
-		  cmd_type, rw, func, addr, nbytes);
+	brcmf_dbg(INFO, "rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
+		  rw, func, addr, nbytes);
 
 	brcmf_pm_resume_wait(sdiodev, sdioh_request_word_wait);
 	if (brcmf_pm_resume_error(sdiodev))
@@ -566,7 +566,7 @@ brcmf_sdioh_card_regread(struct brcmf_sdio_dev *sdiodev, int func, u32 regaddr,
 		*data &= 0xff;
 		brcmf_dbg(DATA, "byte read data=0x%02x\n", *data);
 	} else {
-		brcmf_sdioh_request_word(sdiodev, 0, SDIOH_READ, func, regaddr,
+		brcmf_sdioh_request_word(sdiodev, SDIOH_READ, func, regaddr,
 					 data, regsize);
 		if (regsize == 2)
 			*data &= 0xffff;
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index d0778b3..67368b9 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -247,7 +247,7 @@ extern int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw,
 
 /* read or write 2/4 bytes using cmd53 */
 extern int
-brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type,
+brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 			 uint rw, uint fnc, uint addr,
 			 u32 *word, uint nbyte);
 
-- 
1.7.4.1


