Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3255 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab1HHN7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:35 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 70/82] staging: brcm80211: remove dead code from
 brcmfmac
Date: Mon, 8 Aug 2011 15:58:54 +0200
Message-ID: <1312811946-16713-71-git-send-email-arend@broadcom.com> (sfid-20110808_160052_568780_A64AC500)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

brcmf_sdcrad_cfg_read_word and brcmf_sdcard_cfg_write_word are
not used by anyone.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |   35 ------------------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |    9 ------
 2 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 31e6728..6cabda5 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -120,41 +120,6 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 		     __func__, fnc_num, addr, data));
 }
 
-u32 brcmf_sdcard_cfg_read_word(struct brcmf_sdio_dev *sdiodev, uint fnc_num,
-			       u32 addr, int *err)
-{
-	int status;
-	u32 data = 0;
-
-	status = brcmf_sdioh_request_word(sdiodev->sdioh, SDIOH_CMD_TYPE_NORMAL,
-		SDIOH_READ, fnc_num, addr, &data, 4);
-
-	if (err)
-		*err = status;
-
-	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
-		     __func__, fnc_num, addr, data));
-
-	return data;
-}
-
-void
-brcmf_sdcard_cfg_write_word(struct brcmf_sdio_dev *sdiodev, uint fnc_num,
-			    u32 addr, u32 data, int *err)
-{
-	int status;
-
-	status =
-	    brcmf_sdioh_request_word(sdiodev->sdioh, SDIOH_CMD_TYPE_NORMAL,
-			       SDIOH_WRITE, fnc_num, addr, &data, 4);
-
-	if (err)
-		*err = status;
-
-	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
-		     __func__, fnc_num, addr, data));
-}
-
 int brcmf_sdcard_cis_read(struct brcmf_sdio_dev *sdiodev, uint func, u8 * cis,
 			  uint length)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index b82a462..3c97af4 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -183,15 +183,6 @@ extern u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint func,
 extern void brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint func,
 				   u32 addr, u8 data, int *err);
 
-/* Read/Write 4bytes from/to cfg space */
-extern u32
-brcmf_sdcard_cfg_read_word(struct brcmf_sdio_dev *sdiodev, uint fnc_num,
-			   u32 addr, int *err);
-
-extern void brcmf_sdcard_cfg_write_word(struct brcmf_sdio_dev *sdiodev,
-					uint fnc_num, u32 addr,
-					u32 data, int *err);
-
 /* Read CIS content for specified function.
  *   fn:     function whose CIS is being requested (0 is common CIS)
  *   cis:    pointer to memory location to place results
-- 
1.7.4.1


