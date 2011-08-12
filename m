Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3119 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab1HLNfO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:14 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/14] staging: brcm80211: remove wrapper functions in
 bcmsdh_sdmmc.c
Date: Fri, 12 Aug 2011 15:34:58 +0200
Message-ID: <1313156101-16817-12-git-send-email-arend@broadcom.com> (sfid-20110812_153539_951246_AEA7F6AD)
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use brcmf_sdioh_request_byte directly instead of calling
brcmf_sdioh_cfg_read and brcmf_sdioh_cfg_write in brcmfmac

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   18 +++++++---------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   22 ---------------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    5 ----
 3 files changed, 8 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 8bb84a9..824208f 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -130,8 +130,8 @@ brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
 					(struct brcmf_sdreg *) params;
 			u8 data = 0;
 
-			if (brcmf_sdioh_cfg_read
-			    (sdiodev, sd_ptr->func, sd_ptr->offset, &data)) {
+			if (brcmf_sdioh_request_byte(sdiodev, SDIOH_READ,
+					sd_ptr->func, sd_ptr->offset, &data)) {
 				bcmerror = -EIO;
 				break;
 			}
@@ -147,8 +147,8 @@ brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
 					(struct brcmf_sdreg *) params;
 			u8 data = (u8) sd_ptr->value;
 
-			if (brcmf_sdioh_cfg_write
-			    (sdiodev, sd_ptr->func, sd_ptr->offset, &data)) {
+			if (brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE,
+					sd_ptr->func, sd_ptr->offset, &data)) {
 				bcmerror = -EIO;
 				break;
 			}
@@ -209,9 +209,8 @@ u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 	do {
 		if (retry)	/* wait for 1 ms till bus get settled down */
 			udelay(1000);
-		status =
-		    brcmf_sdioh_cfg_read(sdiodev, fnc_num, addr,
-				   (u8 *) &data);
+		status = brcmf_sdioh_request_byte(sdiodev, SDIOH_READ, fnc_num,
+						  addr, (u8 *) &data);
 	} while (status != 0
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
 	if (err)
@@ -233,9 +232,8 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 	do {
 		if (retry)	/* wait for 1 ms till bus get settled down */
 			udelay(1000);
-		status =
-		    brcmf_sdioh_cfg_write(sdiodev, fnc_num, addr,
-				    (u8 *) &data);
+		status = brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, fnc_num,
+						  addr, (u8 *) &data);
 	} while (status != 0
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
 	if (err)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index d7648f8..fca966c 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -190,28 +190,6 @@ void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
 
 }
 
-extern int
-brcmf_sdioh_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
-		     u8 *data)
-{
-	int status;
-	/* No lock needed since brcmf_sdioh_request_byte does locking */
-	status = brcmf_sdioh_request_byte(sdiodev, SDIOH_READ, fnc_num,
-					  addr, data);
-	return status;
-}
-
-extern int
-brcmf_sdioh_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
-		      u8 *data)
-{
-	/* No lock needed since brcmf_sdioh_request_byte does locking */
-	int status;
-	status = brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, fnc_num,
-					  addr, data);
-	return status;
-}
-
 static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 {
 	/* read 24 bits and return valid 17 bit addr */
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 555f17b..dc588e7 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -268,11 +268,6 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
 extern int brcmf_sdioh_cis_read(struct brcmf_sdio_dev *sdiodev, uint fuc,
 				u8 *cis, u32 length);
 
-extern int brcmf_sdioh_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fuc,
-				u32 addr, u8 *data);
-extern int brcmf_sdioh_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fuc,
-				 u32 addr, u8 *data);
-
 /* Watchdog timer interface for pm ops */
 extern void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev,
 				    bool enable);
-- 
1.7.4.1


