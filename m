Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1407 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758454Ab2EEB1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/11] brcmfmac: replace brcmf_sdioh_card_regread with
 brcmf_sdio_regrl
Date: Fri, 4 May 2012 18:27:38 -0700
Message-ID: <1336181258-7305-12-git-send-email-frankyl@broadcom.com> (sfid-20120505_032835_353238_F2CC4C79)
In-Reply-To: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
References: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the newly introduced brcmf_sdio_regrl to replace
brcmf_sdioh_card_regread as part of the SDIO WiFi dongle register
access interface clean up.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    4 +--
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   32 ++------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 3 files changed, 6 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index aec1bd6..e2480d1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -196,11 +196,11 @@ brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 
 	/*
 	 * figure out how to read the register based on address range
-	 * 0x00 ~ 0xFF: function 0 CCCR
+	 * 0x00 ~ 0x7FF: function 0 CCCR and FBR
 	 * 0x10000 ~ 0x1FFFF: function 1 miscellaneous registers
 	 * The rest: function 1 silicon backplane core registers
 	 */
-	if ((addr & ~REG_F0_CCCR_MASK) == 0) {
+	if ((addr & ~REG_F0_REG_MASK) == 0) {
 		func_num = SDIO_FUNC_0;
 		reg_size = 1;
 	} else if ((addr & ~REG_F1_MISC_MASK) == 0) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index dd07d33..82f51db 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -346,43 +346,17 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 	return status;
 }
 
-/* Read client card reg */
-static int
-brcmf_sdioh_card_regread(struct brcmf_sdio_dev *sdiodev, int func, u32 regaddr,
-			 int regsize, u32 *data)
-{
-
-	if ((func == 0) || (regsize == 1)) {
-		u8 temp = 0;
-
-		brcmf_sdioh_request_byte(sdiodev, SDIOH_READ, func, regaddr,
-					 &temp);
-		*data = temp;
-		*data &= 0xff;
-		brcmf_dbg(DATA, "byte read data=0x%02x\n", *data);
-	} else {
-		brcmf_sdioh_request_word(sdiodev, SDIOH_READ, func, regaddr,
-					 data, regsize);
-		if (regsize == 2)
-			*data &= 0xffff;
-
-		brcmf_dbg(DATA, "word read data=0x%08x\n", *data);
-	}
-
-	return SUCCESS;
-}
-
 static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 {
 	/* read 24 bits and return valid 17 bit addr */
-	int i;
+	int i, ret;
 	u32 scratch, regdata;
 	__le32 scratch_le;
 	u8 *ptr = (u8 *)&scratch_le;
 
 	for (i = 0; i < 3; i++) {
-		if ((brcmf_sdioh_card_regread(sdiodev, 0, regaddr, 1,
-				&regdata)) != SUCCESS)
+		regdata = brcmf_sdio_regrl(sdiodev, regaddr, &ret);
+		if (ret != 0)
 			brcmf_dbg(ERROR, "Can't read!\n");
 
 		*ptr++ = (u8) regdata;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 6d2e665..29bf78d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -41,7 +41,7 @@
 #define SDIOD_MAX_IOFUNCS	7
 
 /* mask of register map */
-#define REG_F0_CCCR_MASK	0xFF
+#define REG_F0_REG_MASK		0x7FF
 #define REG_F1_MISC_MASK	0x1FFFF
 
 /* as of sdiod rev 0, supports 3 functions */
-- 
1.7.9.5


