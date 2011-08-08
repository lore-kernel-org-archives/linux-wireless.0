Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2825 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab1HHN7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:36 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 50/82] staging: brcm80211: remove BRCMF_SD_* debug
 macros from brcmfmac
Date: Mon, 8 Aug 2011 15:58:34 +0200
Message-ID: <1312811946-16713-51-git-send-email-arend@broadcom.com> (sfid-20110808_160016_201277_DA541D65)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use unified debug macros BRCMF_* in fullmac.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |   50 ++++++-----------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |    1 -
 2 files changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 0953160..53dfecd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -34,28 +34,6 @@
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
-#define BRCMF_SD_ERROR_VAL	0x0001	/* Error */
-#define BRCMF_SD_INFO_VAL		0x0002	/* Info */
-
-
-#ifdef BCMDBG
-#define BRCMF_SD_ERROR(x) \
-	do { \
-		if ((brcmf_sdio_msglevel & BRCMF_SD_ERROR_VAL) && \
-		    net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define BRCMF_SD_INFO(x)	\
-	do { \
-		if ((brcmf_sdio_msglevel & BRCMF_SD_INFO_VAL) && \
-		    net_ratelimit()) \
-			printk x; \
-	} while (0)
-#else				/* BCMDBG */
-#define BRCMF_SD_ERROR(x)
-#define BRCMF_SD_INFO(x)
-#endif				/* BCMDBG */
-
 #define SDIOH_CMD_TYPE_NORMAL   0	/* Normal command */
 #define SDIOH_CMD_TYPE_APPEND   1	/* Append command */
 #define SDIOH_CMD_TYPE_CUTTHRU  2	/* Cut-through command */
@@ -72,8 +50,6 @@ struct brcmf_sdio_card {
 	u32 sbwad;		/* Save backplane window address */
 };
 
-const uint brcmf_sdio_msglevel = BRCMF_SD_ERROR_VAL;
-
 /* driver info, initialized when brcmf_sdio_register is called */
 static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
 
@@ -88,7 +64,7 @@ brcmf_sdcard_attach(void *cfghdl, u32 *regsva)
 
 	card = kzalloc(sizeof(struct brcmf_sdio_card), GFP_ATOMIC);
 	if (card == NULL) {
-		BRCMF_SD_ERROR(("sdcard_attach: out of memory"));
+		BRCMF_ERROR(("sdcard_attach: out of memory"));
 		return NULL;
 	}
 
@@ -167,7 +143,7 @@ u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 	if (err)
 		*err = status;
 
-	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
+	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
 
 	return data;
@@ -191,7 +167,7 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 	if (err)
 		*err = status;
 
-	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
+	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
 }
 
@@ -207,7 +183,7 @@ u32 brcmf_sdcard_cfg_read_word(struct brcmf_sdio_card *card, uint fnc_num,
 	if (err)
 		*err = status;
 
-	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
+	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
 
 	return data;
@@ -226,7 +202,7 @@ brcmf_sdcard_cfg_write_word(struct brcmf_sdio_card *card, uint fnc_num,
 	if (err)
 		*err = status;
 
-	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
+	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
 }
 
@@ -247,7 +223,7 @@ int brcmf_sdcard_cis_read(struct brcmf_sdio_card *card, uint func, u8 * cis,
 			 into the provided buffer. */
 		tmp_buf = kmalloc(length, GFP_ATOMIC);
 		if (tmp_buf == NULL) {
-			BRCMF_SD_ERROR(("%s: out of memory\n", __func__));
+			BRCMF_ERROR(("%s: out of memory\n", __func__));
 			return -ENOMEM;
 		}
 		memcpy(tmp_buf, cis, length);
@@ -289,7 +265,7 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size)
 	u32 word = 0;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 
-	BRCMF_SD_INFO(("%s:fun = 1, addr = 0x%x, ", __func__, addr));
+	BRCMF_INFO(("%s:fun = 1, addr = 0x%x, ", __func__, addr));
 
 	if (bar0 != card->sbwad) {
 		if (brcmf_sdcard_set_sbaddr_window(card, bar0))
@@ -307,7 +283,7 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size)
 
 	card->regfail = (status != 0);
 
-	BRCMF_SD_INFO(("u32data = 0x%x\n", word));
+	BRCMF_INFO(("u32data = 0x%x\n", word));
 
 	/* if ok, return appropriately masked word */
 	if (status == 0) {
@@ -325,7 +301,7 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size)
 	}
 
 	/* otherwise, bad sdio access or invalid size */
-	BRCMF_SD_ERROR(("%s: error reading addr 0x%04x size %d\n", __func__,
+	BRCMF_ERROR(("%s: error reading addr 0x%04x size %d\n", __func__,
 		      addr, size));
 	return 0xFFFFFFFF;
 }
@@ -337,7 +313,7 @@ u32 brcmf_sdcard_reg_write(struct brcmf_sdio_card *card, u32 addr, uint size,
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	BRCMF_SD_INFO(("%s:fun = 1, addr = 0x%x, uint%ddata = 0x%x\n",
+	BRCMF_INFO(("%s:fun = 1, addr = 0x%x, uint%ddata = 0x%x\n",
 		     __func__, addr, size * 8, data));
 
 	if (bar0 != card->sbwad) {
@@ -359,7 +335,7 @@ u32 brcmf_sdcard_reg_write(struct brcmf_sdio_card *card, u32 addr, uint size,
 	if (status == 0)
 		return 0;
 
-	BRCMF_SD_ERROR(("%s: error writing 0x%08x to addr 0x%04x size %d\n",
+	BRCMF_ERROR(("%s: error writing 0x%08x to addr 0x%04x size %d\n",
 		      __func__, data, addr, size));
 	return 0xFFFFFFFF;
 }
@@ -383,7 +359,7 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
+	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
 		     __func__, fn, addr, nbytes));
 
 	/* Async not implemented yet */
@@ -423,7 +399,7 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
+	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
 		     __func__, fn, addr, nbytes));
 
 	/* Async not implemented yet */
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 9853e74..5e7552e 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -18,7 +18,6 @@
 #define	_BRCM_SDH_H_
 
 #include <linux/skbuff.h>
-extern const uint brcmf_sdio_msglevel;
 
 #define SDIO_FUNC_0		0
 #define SDIO_FUNC_1		1
-- 
1.7.4.1


