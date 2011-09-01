Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4203 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab1IAJRo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:44 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 16/30] staging: brcm80211: remove unused sdioh data mode
 code in fullmac
Date: Thu, 1 Sep 2011 11:17:06 +0200
Message-ID: <1314868640-9425-17-git-send-email-rvossen@broadcom.com> (sfid-20110901_111818_898132_55F4E07A)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

sdioh data mode is not used in brcmf_sdioh_request_buffer. The patch
removes the related code.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   15 ++++++---------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 +-
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index e4c7852..e0fe7c2 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -41,9 +41,6 @@
 #define SDIOH_CMD_TYPE_APPEND   1	/* Append command */
 #define SDIOH_CMD_TYPE_CUTTHRU  2	/* Cut-through command */
 
-#define SDIOH_DATA_PIO          0	/* PIO mode */
-#define SDIOH_DATA_DMA          1	/* DMA mode */
-
 /* Module parameters specific to each host-controller driver */
 
 module_param(sd_f2_blocksize, int, 0);
@@ -412,8 +409,8 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_PIO,
-		incr_fix, SDIOH_READ, fn, addr, width, nbytes, buf, pkt);
+	status = brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_READ,
+					    fn, addr, width, nbytes, buf, pkt);
 
 	return status;
 }
@@ -448,8 +445,8 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_PIO,
-		incr_fix, SDIOH_WRITE, fn, addr, width, nbytes, buf, pkt);
+	return brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_WRITE, fn,
+					  addr, width, nbytes, buf, pkt);
 }
 
 int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
@@ -458,8 +455,8 @@ int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_PIO,
-		SDIOH_DATA_INC, (rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
+	return brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_INC,
+		(rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
 		addr, 4, nbytes, buf, NULL);
 }
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index be022d2..b316866 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -478,7 +478,7 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
  *
  */
 extern int
-brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
+brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			   uint fix_inc, uint write, uint func, uint addr,
 			   uint reg_width, uint buflen_u, u8 *buffer,
 			   struct sk_buff *pkt)
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 4565aef9..d0778b3 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -253,7 +253,7 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type,
 
 /* read or write any buffer using cmd53 */
 extern int
-brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
+brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			   uint fix_inc, uint rw, uint fnc_num,
 			   u32 addr, uint regwidth,
 			   u32 buflen, u8 *buffer, struct sk_buff *pkt);
-- 
1.7.4.1


