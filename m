Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4627 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758232Ab1F2Xtm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 092/119] staging: brmc80211: cleaned up sdio related
 error codes
Date: Wed, 29 Jun 2011 16:47:56 -0700
Message-ID: <1309391303-22741-93-git-send-email-frankyl@broadcom.com> (sfid-20110630_015303_762868_E4A7A475)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Replaced Broadcom proprietary error codes with Linux native
ones.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h      |    4 --
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   52 +++++++------------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   43 ++++++++--------
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    5 +-
 4 files changed, 44 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index f1d04e0..9359bba 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -19,10 +19,6 @@
 
 #include "sdio_host.h"
 
-#define SDIOH_API_RC_SUCCESS                          (0x00)
-#define SDIOH_API_RC_FAIL	                      (0x01)
-#define SDIOH_API_SUCCESS(status) (status == 0)
-
 #define SDIOH_READ              0	/* Read request */
 #define SDIOH_WRITE             1	/* Write request */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index c8e84d3..d785b05 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -105,7 +105,7 @@ bool brcmf_sdcard_intr_query(void *sdh)
 
 	ASSERT(bcmsdh);
 	status = brcmf_sdioh_interrupt_query(bcmsdh->sdioh, &on);
-	if (SDIOH_API_SUCCESS(status))
+	if (status == 0)
 		return false;
 	else
 		return on;
@@ -114,41 +114,33 @@ bool brcmf_sdcard_intr_query(void *sdh)
 int brcmf_sdcard_intr_enable(void *sdh)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	int status;
 	ASSERT(bcmsdh);
 
-	status = brcmf_sdioh_interrupt_set(bcmsdh->sdioh, true);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
+	return brcmf_sdioh_interrupt_set(bcmsdh->sdioh, true);
 }
 
 int brcmf_sdcard_intr_disable(void *sdh)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	int status;
 	ASSERT(bcmsdh);
 
-	status = brcmf_sdioh_interrupt_set(bcmsdh->sdioh, false);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
+	return brcmf_sdioh_interrupt_set(bcmsdh->sdioh, false);
 }
 
 int brcmf_sdcard_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	int status;
 	ASSERT(bcmsdh);
 
-	status = brcmf_sdioh_interrupt_register(bcmsdh->sdioh, fn, argh);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
+	return brcmf_sdioh_interrupt_register(bcmsdh->sdioh, fn, argh);
 }
 
 int brcmf_sdcard_intr_dereg(void *sdh)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	int status;
 	ASSERT(bcmsdh);
 
-	status = brcmf_sdioh_interrupt_deregister(bcmsdh->sdioh);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
+	return brcmf_sdioh_interrupt_deregister(bcmsdh->sdioh);
 }
 
 #if defined(BCMDBG)
@@ -192,11 +184,11 @@ u8 brcmf_sdcard_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 		    brcmf_sdioh_cfg_read(bcmsdh->sdioh, fnc_num, addr,
 				   (u8 *) &data);
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
-	} while (!SDIOH_API_SUCCESS(status)
+	} while (status != 0
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
 #endif
 	if (err)
-		*err = (SDIOH_API_SUCCESS(status) ? 0 : -EIO);
+		*err = status;
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -227,11 +219,11 @@ brcmf_sdcard_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 		    brcmf_sdioh_cfg_write(bcmsdh->sdioh, fnc_num, addr,
 				    (u8 *) &data);
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
-	} while (!SDIOH_API_SUCCESS(status)
+	} while (status != 0
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
 #endif
 	if (err)
-		*err = SDIOH_API_SUCCESS(status) ? 0 : -EIO;
+		*err = status;
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -252,7 +244,7 @@ u32 brcmf_sdcard_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
 		SDIOH_READ, fnc_num, addr, &data, 4);
 
 	if (err)
-		*err = (SDIOH_API_SUCCESS(status) ? 0 : -EIO);
+		*err = status;
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -277,7 +269,7 @@ brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 			       SDIOH_WRITE, fnc_num, addr, &data, 4);
 
 	if (err)
-		*err = (SDIOH_API_SUCCESS(status) ? 0 : -EIO);
+		*err = status;
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -320,7 +312,7 @@ int brcmf_sdcard_cis_read(void *sdh, uint func, u8 * cis, uint length)
 		kfree(tmp_buf);
 	}
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
+	return status;
 }
 
 static int brcmf_sdcard_set_sbaddr_window(void *sdh, u32 address)
@@ -371,12 +363,12 @@ u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size)
 	status = brcmf_sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
 				    SDIOH_READ, SDIO_FUNC_1, addr, &word, size);
 
-	bcmsdh->regfail = !(SDIOH_API_SUCCESS(status));
+	bcmsdh->regfail = (status != 0);
 
 	BCMSDH_INFO(("u32data = 0x%x\n", word));
 
 	/* if ok, return appropriately masked word */
-	if (SDIOH_API_SUCCESS(status)) {
+	if (status == 0) {
 		switch (size) {
 		case sizeof(u8):
 			return word & 0xff;
@@ -425,9 +417,9 @@ u32 brcmf_sdcard_reg_write(void *sdh, u32 addr, uint size, u32 data)
 	status =
 	    brcmf_sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
 			       SDIOH_WRITE, SDIO_FUNC_1, addr, &data, size);
-	bcmsdh->regfail = !(SDIOH_API_SUCCESS(status));
+	bcmsdh->regfail = (status != 0);
 
-	if (SDIOH_API_SUCCESS(status))
+	if (status == 0)
 		return 0;
 
 	BCMSDH_ERROR(("%s: error writing 0x%08x to addr 0x%04x size %d\n",
@@ -480,7 +472,7 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio *bcmsdh, u32 addr, uint fn, uint flags,
 	status = brcmf_sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO,
 		incr_fix, SDIOH_READ, fn, addr, width, nbytes, buf, pkt);
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
+	return status;
 }
 
 int
@@ -489,7 +481,6 @@ brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 		bcmsdh_cmplt_fn_t complete, void *handle)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	int status;
 	uint incr_fix;
 	uint width;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
@@ -521,16 +512,13 @@ brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = brcmf_sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO,
+	return brcmf_sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO,
 		incr_fix, SDIOH_WRITE, fn, addr, width, nbytes, buf, pkt);
-
-	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int brcmf_sdcard_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	int status;
 
 	ASSERT(bcmsdh);
 	ASSERT(bcmsdh->init_success);
@@ -539,11 +527,9 @@ int brcmf_sdcard_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = brcmf_sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO,
+	return brcmf_sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO,
 		SDIOH_DATA_INC, (rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
 		addr, 4, nbytes, buf, NULL);
-
-	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int brcmf_sdcard_abort(void *sdh, uint fn)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 167181d..0413a59 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -20,6 +20,7 @@
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/suspend.h>
+#include <linux/errno.h>
 
 #include <defs.h>
 #include <brcm_hw_ids.h>
@@ -177,7 +178,7 @@ extern int brcmf_sdioh_detach(struct sdioh_info *sd)
 
 		kfree(sd);
 	}
-	return SDIOH_API_RC_SUCCESS;
+	return 0;
 }
 
 /* Configure callback to client when we receive client interrupt */
@@ -189,7 +190,7 @@ brcmf_sdioh_interrupt_register(struct sdioh_info *sd, sdioh_cb_fn_t fn,
 	if (fn == NULL) {
 		sd_err(("%s: interrupt handler is NULL, not registering\n",
 			__func__));
-		return SDIOH_API_RC_FAIL;
+		return -EINVAL;
 	}
 
 	sd->intr_handler = fn;
@@ -209,7 +210,7 @@ brcmf_sdioh_interrupt_register(struct sdioh_info *sd, sdioh_cb_fn_t fn,
 		sdio_release_host(gInstance->func[1]);
 	}
 
-	return SDIOH_API_RC_SUCCESS;
+	return 0;
 }
 
 extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
@@ -235,7 +236,7 @@ extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 	sd->intr_handler = NULL;
 	sd->intr_handler_arg = NULL;
 
-	return SDIOH_API_RC_SUCCESS;
+	return 0;
 }
 
 extern int
@@ -243,7 +244,7 @@ brcmf_sdioh_interrupt_query(struct sdioh_info *sd, bool *onoff)
 {
 	sd_trace(("%s: Entering\n", __func__));
 	*onoff = sd->client_intr_enabled;
-	return SDIOH_API_RC_SUCCESS;
+	return 0;
 }
 
 #if defined(BCMDBG)
@@ -504,7 +505,7 @@ brcmf_sdioh_cis_read(struct sdioh_info *sd, uint func, u8 *cisd, u32 length)
 	if (!sd->func_cis_ptr[func]) {
 		memset(cis, 0, length);
 		sd_err(("%s: no func_cis_ptr[%d]\n", __func__, func));
-		return SDIOH_API_RC_FAIL;
+		return -ENOTSUPP;
 	}
 
 	sd_err(("%s: func_cis_ptr[%d]=0x%04x\n", __func__, func,
@@ -515,14 +516,14 @@ brcmf_sdioh_cis_read(struct sdioh_info *sd, uint func, u8 *cisd, u32 length)
 		if (brcmf_sdioh_card_regread(sd, 0, offset, 1, &foo) < 0) {
 			sd_err(("%s: regread failed: Can't read CIS\n",
 				__func__));
-			return SDIOH_API_RC_FAIL;
+			return -EIO;
 		}
 
 		*cis = (u8) (foo & 0xff);
 		cis++;
 	}
 
-	return SDIOH_API_RC_SUCCESS;
+	return 0;
 }
 
 extern int
@@ -535,7 +536,7 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 		 regaddr));
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_byte_wait);
-	BRCMF_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO);
 	if (rw) {		/* CMD52 Write */
 		if (func == 0) {
 			/* Can only directly write to some F0 registers.
@@ -619,25 +620,25 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 			"Err: %d\n", rw ? "Write" : "Read", func, regaddr,
 			*byte, err_ret));
 
-	return ((err_ret == 0) ? SDIOH_API_RC_SUCCESS : SDIOH_API_RC_FAIL);
+	return err_ret;
 }
 
 extern int
 brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 			 uint func, uint addr, u32 *word, uint nbytes)
 {
-	int err_ret = SDIOH_API_RC_FAIL;
+	int err_ret = -EIO;
 
 	if (func == 0) {
 		sd_err(("%s: Only CMD52 allowed to F0.\n", __func__));
-		return SDIOH_API_RC_FAIL;
+		return -EINVAL;
 	}
 
 	sd_info(("%s: cmd_type=%d, rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
 		 __func__, cmd_type, rw, func, addr, nbytes));
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_word_wait);
-	BRCMF_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO);
 	/* Claim host controller */
 	sdio_claim_host(gInstance->func[func]);
 
@@ -672,7 +673,7 @@ brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 			rw ? "Write" : "Read", err_ret));
 	}
 
-	return ((err_ret == 0) ? SDIOH_API_RC_SUCCESS : SDIOH_API_RC_FAIL);
+	return err_ret;
 }
 
 static int
@@ -689,7 +690,7 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 
 	ASSERT(pkt);
 	BRCMF_PM_RESUME_WAIT(sdioh_request_packet_wait);
-	BRCMF_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO);
 
 	/* Claim host controller */
 	sdio_claim_host(gInstance->func[func]);
@@ -746,7 +747,7 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 	sdio_release_host(gInstance->func[func]);
 
 	sd_trace(("%s: Exit\n", __func__));
-	return ((err_ret == 0) ? SDIOH_API_RC_SUCCESS : SDIOH_API_RC_FAIL);
+	return err_ret;
 }
 
 /*
@@ -775,7 +776,7 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 	sd_trace(("%s: Enter\n", __func__));
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_buffer_wait);
-	BRCMF_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
+	BRCMF_PM_RESUME_RETURN_ERROR(-EIO);
 	/* Case 1: we don't have a packet. */
 	if (pkt == NULL) {
 		sd_data(("%s: Creating new %s Packet, len=%d\n",
@@ -784,7 +785,7 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 		if (!mypkt) {
 			sd_err(("%s: brcmu_pkt_buf_get_skb failed: len %d\n",
 				__func__, buflen_u));
-			return SDIOH_API_RC_FAIL;
+			return -EIO;
 		}
 
 		/* For a write, copy the buffer data into the packet. */
@@ -811,7 +812,7 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 		if (!mypkt) {
 			sd_err(("%s: brcmu_pkt_buf_get_skb failed: len %d\n",
 				__func__, pkt->len));
-			return SDIOH_API_RC_FAIL;
+			return -EIO;
 		}
 
 		/* For a write, copy the buffer data into the packet. */
@@ -848,7 +849,7 @@ extern int brcmf_sdioh_abort(struct sdioh_info *sd, uint func)
 			   &t_func);
 
 	sd_trace(("%s: Exit\n", __func__));
-	return SDIOH_API_RC_SUCCESS;
+	return 0;
 }
 
 /* Reset and re-initialize the device */
@@ -856,7 +857,7 @@ int brcmf_sdioh_reset(struct sdioh_info *si)
 {
 	sd_trace(("%s: Enter\n", __func__));
 	sd_trace(("%s: Exit\n", __func__));
-	return SDIOH_API_RC_SUCCESS;
+	return 0;
 }
 
 /* Disable device interrupt */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 39b0cbe..f10cddd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -20,6 +20,7 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
+#include <linux/errno.h>
 #include <net/cfg80211.h>
 
 #include <defs.h>
@@ -227,7 +228,7 @@ int brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
 	if (enable && !(sd->intr_handler && sd->intr_handler_arg)) {
 		sd_err(("%s: no handler registered, will not enable\n",
 			__func__));
-		return SDIOH_API_RC_FAIL;
+		return -EINVAL;
 	}
 
 	/* Ensure atomicity for enable/disable calls */
@@ -241,7 +242,7 @@ int brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
 
 	spin_unlock_irqrestore(&sdos->lock, flags);
 
-	return SDIOH_API_RC_SUCCESS;
+	return 0;
 }
 
 /*
-- 
1.7.1


