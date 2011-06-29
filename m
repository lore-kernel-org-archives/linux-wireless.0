Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4636 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758027Ab1F2XtI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:08 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 056/119] staging: brcm80211: replaced typedef
 sdioh_info_t by struct sdioh_info
Date: Wed, 29 Jun 2011 16:47:20 -0700
Message-ID: <1309391303-22741-57-git-send-email-frankyl@broadcom.com> (sfid-20110630_015145_486580_7F1C246B)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h      |   65 +++++++++---------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   70 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h  |   16 ++--
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |   12 ++--
 4 files changed, 82 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index 7eb0354..ffe258a 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -38,9 +38,6 @@
 
 typedef int SDIOH_API_RC;
 
-/* SDio Host structure */
-typedef struct sdioh_info sdioh_info_t;
-
 /* callback function, taking one arg */
 typedef void (*sdioh_cb_fn_t) (void *);
 
@@ -48,68 +45,70 @@ typedef void (*sdioh_cb_fn_t) (void *);
  *  The handler shall be provided by all subsequent calls. No local cache
  *  cfghdl points to the starting address of pci device mapped memory
  */
-extern sdioh_info_t *brcmf_sdioh_attach(void *cfghdl, uint irq);
-extern SDIOH_API_RC brcmf_sdioh_detach(sdioh_info_t *si);
-extern SDIOH_API_RC brcmf_sdioh_interrupt_register(sdioh_info_t *si,
+extern struct sdioh_info *brcmf_sdioh_attach(void *cfghdl, uint irq);
+extern SDIOH_API_RC brcmf_sdioh_detach(struct sdioh_info *si);
+extern SDIOH_API_RC brcmf_sdioh_interrupt_register(struct sdioh_info *si,
 					     sdioh_cb_fn_t fn, void *argh);
-extern SDIOH_API_RC brcmf_sdioh_interrupt_deregister(sdioh_info_t *si);
+extern SDIOH_API_RC brcmf_sdioh_interrupt_deregister(struct sdioh_info *si);
 
 /* query whether SD interrupt is enabled or not */
-extern SDIOH_API_RC brcmf_sdioh_interrupt_query(sdioh_info_t *si, bool *onoff);
+extern SDIOH_API_RC
+brcmf_sdioh_interrupt_query(struct sdioh_info *si, bool *onoff);
 
 /* enable or disable SD interrupt */
 extern SDIOH_API_RC
-brcmf_sdioh_interrupt_set(sdioh_info_t *si, bool enable_disable);
+brcmf_sdioh_interrupt_set(struct sdioh_info *si, bool enable_disable);
 
 #if defined(DHD_DEBUG)
-extern bool brcmf_sdioh_interrupt_pending(sdioh_info_t *si);
+extern bool brcmf_sdioh_interrupt_pending(struct sdioh_info *si);
 #endif
 
-extern int brcmf_sdioh_claim_host_and_lock(sdioh_info_t *si);
-extern int brcmf_sdioh_release_host_and_unlock(sdioh_info_t *si);
+extern int brcmf_sdioh_claim_host_and_lock(struct sdioh_info *si);
+extern int brcmf_sdioh_release_host_and_unlock(struct sdioh_info *si);
 
 /* read or write one byte using cmd52 */
 extern SDIOH_API_RC
-brcmf_sdioh_request_byte(sdioh_info_t *si, uint rw, uint fnc, uint addr,
+brcmf_sdioh_request_byte(struct sdioh_info *si, uint rw, uint fnc, uint addr,
 			 u8 *byte);
 
 /* read or write 2/4 bytes using cmd53 */
-extern SDIOH_API_RC brcmf_sdioh_request_word(sdioh_info_t *si, uint cmd_type,
-				       uint rw, uint fnc, uint addr,
-				       u32 *word, uint nbyte);
+extern SDIOH_API_RC
+brcmf_sdioh_request_word(struct sdioh_info *si, uint cmd_type,
+			 uint rw, uint fnc, uint addr,
+			 u32 *word, uint nbyte);
 
 /* read or write any buffer using cmd53 */
-extern SDIOH_API_RC brcmf_sdioh_request_buffer(sdioh_info_t *si, uint pio_dma,
-					 uint fix_inc, uint rw, uint fnc_num,
-					 u32 addr, uint regwidth,
-					 u32 buflen, u8 *buffer,
-					 struct sk_buff *pkt);
+extern SDIOH_API_RC
+brcmf_sdioh_request_buffer(struct sdioh_info *si, uint pio_dma,
+			   uint fix_inc, uint rw, uint fnc_num,
+			   u32 addr, uint regwidth,
+			   u32 buflen, u8 *buffer, struct sk_buff *pkt);
 
 /* get cis data */
-extern SDIOH_API_RC brcmf_sdioh_cis_read(sdioh_info_t *si, uint fuc, u8 *cis,
-				   u32 length);
+extern SDIOH_API_RC
+brcmf_sdioh_cis_read(struct sdioh_info *si, uint fuc, u8 *cis, u32 length);
 
-extern SDIOH_API_RC brcmf_sdioh_cfg_read(sdioh_info_t *si, uint fuc, u32 addr,
-				   u8 *data);
-extern SDIOH_API_RC brcmf_sdioh_cfg_write(sdioh_info_t *si, uint fuc, u32 addr,
-				    u8 *data);
+extern SDIOH_API_RC
+brcmf_sdioh_cfg_read(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
+extern SDIOH_API_RC
+brcmf_sdioh_cfg_write(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
 
 /* query number of io functions */
-extern uint brcmf_sdioh_query_iofnum(sdioh_info_t *si);
+extern uint brcmf_sdioh_query_iofnum(struct sdioh_info *si);
 
 /* handle iovars */
-extern int brcmf_sdioh_iovar_op(sdioh_info_t *si, const char *name,
+extern int brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 			  void *params, int plen, void *arg, int len, bool set);
 
 /* Issue abort to the specified function and clear controller as needed */
-extern int brcmf_sdioh_abort(sdioh_info_t *si, uint fnc);
+extern int brcmf_sdioh_abort(struct sdioh_info *si, uint fnc);
 
 /* Start and Stop SDIO without re-enumerating the SD card. */
-extern int brcmf_sdioh_start(sdioh_info_t *si, int stage);
-extern int brcmf_sdioh_stop(sdioh_info_t *si);
+extern int brcmf_sdioh_start(struct sdioh_info *si, int stage);
+extern int brcmf_sdioh_stop(struct sdioh_info *si);
 
 /* Reset and re-initialize the device */
-extern int brcmf_sdioh_reset(sdioh_info_t *si);
+extern int brcmf_sdioh_reset(struct sdioh_info *si);
 
 /* Helper function */
 void *brcmf_sdcard_get_sdioh(bcmsdh_info_t *sdh);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 59bdfea..df1e8c1 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -39,7 +39,7 @@ extern void brcmf_sdio_function_cleanup(void);
 static void brcmf_sdioh_irqhandler(struct sdio_func *func);
 static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func);
 #endif				/* !defined(OOB_INTR_ONLY) */
-static int brcmf_sdioh_get_cisaddr(sdioh_info_t *sd, u32 regaddr);
+static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr);
 extern int brcmf_sdioh_reset_comm(struct mmc_card *card);
 
 extern PBCMSDH_SDMMC_INSTANCE gInstance;
@@ -54,7 +54,7 @@ DHD_PM_RESUME_WAIT_INIT(sdioh_request_buffer_wait);
 
 #define DMA_ALIGN_MASK	0x03
 
-int brcmf_sdioh_card_regread(sdioh_info_t *sd, int func, u32 regaddr,
+int brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
 			     int regsize, u32 *data);
 
 void brcmf_sdioh_set_host_pm_flags(int flag)
@@ -64,7 +64,7 @@ void brcmf_sdioh_set_host_pm_flags(int flag)
 			 __func__, (unsigned int)flag);
 }
 
-static int brcmf_sdioh_enablefuncs(sdioh_info_t *sd)
+static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 {
 	int err_ret;
 	u32 fbraddr;
@@ -106,9 +106,9 @@ static int brcmf_sdioh_enablefuncs(sdioh_info_t *sd)
 /*
  *	Public entry points & extern's
  */
-sdioh_info_t *brcmf_sdioh_attach(void *bar0, uint irq)
+struct sdioh_info *brcmf_sdioh_attach(void *bar0, uint irq)
 {
-	sdioh_info_t *sd;
+	struct sdioh_info *sd;
 	int err_ret;
 
 	sd_trace(("%s\n", __func__));
@@ -118,7 +118,7 @@ sdioh_info_t *brcmf_sdioh_attach(void *bar0, uint irq)
 		return NULL;
 	}
 
-	sd = kzalloc(sizeof(sdioh_info_t), GFP_ATOMIC);
+	sd = kzalloc(sizeof(struct sdioh_info), GFP_ATOMIC);
 	if (sd == NULL) {
 		sd_err(("sdioh_attach: out of memory\n"));
 		return NULL;
@@ -167,7 +167,7 @@ sdioh_info_t *brcmf_sdioh_attach(void *bar0, uint irq)
 	return sd;
 }
 
-extern SDIOH_API_RC brcmf_sdioh_detach(sdioh_info_t *sd)
+extern SDIOH_API_RC brcmf_sdioh_detach(struct sdioh_info *sd)
 {
 	sd_trace(("%s\n", __func__));
 
@@ -261,7 +261,8 @@ extern SDIOH_API_RC brcmf_sdioh_disable_func_intr(void)
 
 /* Configure callback to client when we receive client interrupt */
 extern SDIOH_API_RC
-brcmf_sdioh_interrupt_register(sdioh_info_t *sd, sdioh_cb_fn_t fn, void *argh)
+brcmf_sdioh_interrupt_register(struct sdioh_info *sd, sdioh_cb_fn_t fn,
+			       void *argh)
 {
 	sd_trace(("%s: Entering\n", __func__));
 	if (fn == NULL) {
@@ -292,7 +293,7 @@ brcmf_sdioh_interrupt_register(sdioh_info_t *sd, sdioh_cb_fn_t fn, void *argh)
 	return SDIOH_API_RC_SUCCESS;
 }
 
-extern SDIOH_API_RC brcmf_sdioh_interrupt_deregister(sdioh_info_t *sd)
+extern SDIOH_API_RC brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 {
 	sd_trace(("%s: Entering\n", __func__));
 
@@ -321,7 +322,8 @@ extern SDIOH_API_RC brcmf_sdioh_interrupt_deregister(sdioh_info_t *sd)
 	return SDIOH_API_RC_SUCCESS;
 }
 
-extern SDIOH_API_RC brcmf_sdioh_interrupt_query(sdioh_info_t *sd, bool *onoff)
+extern SDIOH_API_RC
+brcmf_sdioh_interrupt_query(struct sdioh_info *sd, bool *onoff)
 {
 	sd_trace(("%s: Entering\n", __func__));
 	*onoff = sd->client_intr_enabled;
@@ -329,13 +331,13 @@ extern SDIOH_API_RC brcmf_sdioh_interrupt_query(sdioh_info_t *sd, bool *onoff)
 }
 
 #if defined(DHD_DEBUG)
-extern bool brcmf_sdioh_interrupt_pending(sdioh_info_t *sd)
+extern bool brcmf_sdioh_interrupt_pending(struct sdioh_info *sd)
 {
 	return 0;
 }
 #endif
 
-uint brcmf_sdioh_query_iofnum(sdioh_info_t *sd)
+uint brcmf_sdioh_query_iofnum(struct sdioh_info *sd)
 {
 	return sd->num_funcs;
 }
@@ -365,7 +367,7 @@ const struct brcmu_iovar sdioh_iovars[] = {
 };
 
 int
-brcmf_sdioh_iovar_op(sdioh_info_t *si, const char *name,
+brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 		     void *params, int plen, void *arg, int len, bool set)
 {
 	const struct brcmu_iovar *vi = NULL;
@@ -534,7 +536,7 @@ exit:
 
 #if defined(OOB_INTR_ONLY) && defined(HW_OOB)
 
-SDIOH_API_RC brcmf_sdioh_enable_hw_oob_intr(sdioh_info_t *sd, bool enable)
+SDIOH_API_RC brcmf_sdioh_enable_hw_oob_intr(struct sdioh_info *sd, bool enable)
 {
 	SDIOH_API_RC status;
 	u8 data;
@@ -551,7 +553,7 @@ SDIOH_API_RC brcmf_sdioh_enable_hw_oob_intr(sdioh_info_t *sd, bool enable)
 #endif				/* defined(OOB_INTR_ONLY) && defined(HW_OOB) */
 
 extern SDIOH_API_RC
-brcmf_sdioh_cfg_read(sdioh_info_t *sd, uint fnc_num, u32 addr, u8 *data)
+brcmf_sdioh_cfg_read(struct sdioh_info *sd, uint fnc_num, u32 addr, u8 *data)
 {
 	SDIOH_API_RC status;
 	/* No lock needed since brcmf_sdioh_request_byte does locking */
@@ -560,7 +562,7 @@ brcmf_sdioh_cfg_read(sdioh_info_t *sd, uint fnc_num, u32 addr, u8 *data)
 }
 
 extern SDIOH_API_RC
-brcmf_sdioh_cfg_write(sdioh_info_t *sd, uint fnc_num, u32 addr, u8 *data)
+brcmf_sdioh_cfg_write(struct sdioh_info *sd, uint fnc_num, u32 addr, u8 *data)
 {
 	/* No lock needed since brcmf_sdioh_request_byte does locking */
 	SDIOH_API_RC status;
@@ -568,7 +570,7 @@ brcmf_sdioh_cfg_write(sdioh_info_t *sd, uint fnc_num, u32 addr, u8 *data)
 	return status;
 }
 
-static int brcmf_sdioh_get_cisaddr(sdioh_info_t *sd, u32 regaddr)
+static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr)
 {
 	/* read 24 bits and return valid 17 bit addr */
 	int i;
@@ -590,7 +592,7 @@ static int brcmf_sdioh_get_cisaddr(sdioh_info_t *sd, u32 regaddr)
 }
 
 extern SDIOH_API_RC
-brcmf_sdioh_cis_read(sdioh_info_t *sd, uint func, u8 *cisd, u32 length)
+brcmf_sdioh_cis_read(struct sdioh_info *sd, uint func, u8 *cisd, u32 length)
 {
 	u32 count;
 	int offset;
@@ -624,8 +626,8 @@ brcmf_sdioh_cis_read(sdioh_info_t *sd, uint func, u8 *cisd, u32 length)
 }
 
 extern SDIOH_API_RC
-brcmf_sdioh_request_byte(sdioh_info_t *sd, uint rw, uint func, uint regaddr,
-		   u8 *byte)
+brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
+			 uint regaddr, u8 *byte)
 {
 	int err_ret;
 
@@ -723,8 +725,8 @@ brcmf_sdioh_request_byte(sdioh_info_t *sd, uint rw, uint func, uint regaddr,
 }
 
 extern SDIOH_API_RC
-brcmf_sdioh_request_word(sdioh_info_t *sd, uint cmd_type, uint rw, uint func,
-		   uint addr, u32 *word, uint nbytes)
+brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
+			 uint func, uint addr, u32 *word, uint nbytes)
 {
 	int err_ret = SDIOH_API_RC_FAIL;
 
@@ -776,7 +778,7 @@ brcmf_sdioh_request_word(sdioh_info_t *sd, uint cmd_type, uint rw, uint func,
 }
 
 static SDIOH_API_RC
-brcmf_sdioh_request_packet(sdioh_info_t *sd, uint fix_inc, uint write,
+brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 			   uint func, uint addr, struct sk_buff *pkt)
 {
 	bool fifo = (fix_inc == SDIOH_DATA_FIX);
@@ -872,7 +874,7 @@ brcmf_sdioh_request_packet(sdioh_info_t *sd, uint fix_inc, uint write,
  *
  */
 extern SDIOH_API_RC
-brcmf_sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc,
+brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 			   uint write, uint func, uint addr, uint reg_width,
 			   uint buflen_u, u8 *buffer, struct sk_buff *pkt)
 {
@@ -945,7 +947,7 @@ brcmf_sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc,
 }
 
 /* this function performs "abort" for both of host & device */
-extern int brcmf_sdioh_abort(sdioh_info_t *sd, uint func)
+extern int brcmf_sdioh_abort(struct sdioh_info *sd, uint func)
 {
 #if defined(MMC_SDIO_ABORT)
 	char t_func = (char)func;
@@ -963,7 +965,7 @@ extern int brcmf_sdioh_abort(sdioh_info_t *sd, uint func)
 }
 
 /* Reset and re-initialize the device */
-int brcmf_sdioh_reset(sdioh_info_t *si)
+int brcmf_sdioh_reset(struct sdioh_info *si)
 {
 	sd_trace(("%s: Enter\n", __func__));
 	sd_trace(("%s: Exit\n", __func__));
@@ -971,14 +973,14 @@ int brcmf_sdioh_reset(sdioh_info_t *si)
 }
 
 /* Disable device interrupt */
-void brcmf_sdioh_dev_intr_off(sdioh_info_t *sd)
+void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd)
 {
 	sd_trace(("%s: %d\n", __func__, sd->use_client_ints));
 	sd->intmask &= ~CLIENT_INTR;
 }
 
 /* Enable device interrupt */
-void brcmf_sdioh_dev_intr_on(sdioh_info_t *sd)
+void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd)
 {
 	sd_trace(("%s: %d\n", __func__, sd->use_client_ints));
 	sd->intmask |= CLIENT_INTR;
@@ -986,7 +988,7 @@ void brcmf_sdioh_dev_intr_on(sdioh_info_t *sd)
 
 /* Read client card reg */
 int
-brcmf_sdioh_card_regread(sdioh_info_t *sd, int func, u32 regaddr,
+brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
 			 int regsize, u32 *data)
 {
 
@@ -1013,7 +1015,7 @@ brcmf_sdioh_card_regread(sdioh_info_t *sd, int func, u32 regaddr,
 /* bcmsdh_sdmmc interrupt handler */
 static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
-	sdioh_info_t *sd;
+	struct sdioh_info *sd;
 
 	sd_trace(("bcmsdh_sdmmc: ***IRQHandler\n"));
 	sd = gInstance->sd;
@@ -1039,7 +1041,7 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 /* bcmsdh_sdmmc interrupt handler for F2 (dummy handler) */
 static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func)
 {
-	sdioh_info_t *sd;
+	struct sdioh_info *sd;
 
 	sd_trace(("bcmsdh_sdmmc: ***IRQHandlerF2\n"));
 
@@ -1052,7 +1054,7 @@ static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func)
 #ifdef NOTUSED
 /* Write client card reg */
 static int
-brcmf_sdioh_card_regwrite(sdioh_info_t *sd, int func, u32 regaddr,
+brcmf_sdioh_card_regwrite(struct sdioh_info *sd, int func, u32 regaddr,
 			  int regsize, u32 data)
 {
 
@@ -1076,12 +1078,12 @@ brcmf_sdioh_card_regwrite(sdioh_info_t *sd, int func, u32 regaddr,
 }
 #endif				/* NOTUSED */
 
-int brcmf_sdioh_start(sdioh_info_t *si, int stage)
+int brcmf_sdioh_start(struct sdioh_info *si, int stage)
 {
 	return 0;
 }
 
-int brcmf_sdioh_stop(sdioh_info_t *si)
+int brcmf_sdioh_stop(struct sdioh_info *si)
 {
 	return 0;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
index c7863b1..1a6f68a 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
@@ -62,8 +62,8 @@
 #endif
 
 /* Allocate/init/free per-OS private data */
-extern int brcmf_sdioh_osinit(sdioh_info_t *sd);
-extern void brcmf_sdioh_osfree(sdioh_info_t *sd);
+extern int brcmf_sdioh_osinit(struct sdioh_info *sd);
+extern void brcmf_sdioh_osfree(struct sdioh_info *sd);
 
 #define BLOCK_SIZE_64 64
 #define BLOCK_SIZE_512 512
@@ -109,11 +109,11 @@ struct sdioh_info {
 extern uint sd_msglevel;
 
 /* OS-independent interrupt handler */
-extern bool brcmf_sdioh_check_client_intr(sdioh_info_t *sd);
+extern bool brcmf_sdioh_check_client_intr(struct sdioh_info *sd);
 
 /* Core interrupt enable/disable of device interrupts */
-extern void brcmf_sdioh_dev_intr_on(sdioh_info_t *sd);
-extern void brcmf_sdioh_dev_intr_off(sdioh_info_t *sd);
+extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
+extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
 
 /**************************************************************
  * Internal interfaces: bcmsdh_sdmmc.c references to per-port code
@@ -124,11 +124,11 @@ extern u32 *brcmf_sdioh_reg_map(s32 addr, int size);
 extern void brcmf_sdioh_reg_unmap(s32 addr, int size);
 
 /* Interrupt (de)registration routines */
-extern int brcmf_sdioh_register_irq(sdioh_info_t *sd, uint irq);
-extern void brcmf_sdioh_free_irq(uint irq, sdioh_info_t *sd);
+extern int brcmf_sdioh_register_irq(struct sdioh_info *sd, uint irq);
+extern void brcmf_sdioh_free_irq(uint irq, struct sdioh_info *sd);
 
 typedef struct _BCMSDH_SDMMC_INSTANCE {
-	sdioh_info_t *sd;
+	struct sdioh_info *sd;
 	struct sdio_func *func[SDIOD_MAX_IOFUNCS];
 	u32 host_claimed;
 } BCMSDH_SDMMC_INSTANCE, *PBCMSDH_SDMMC_INSTANCE;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 8f13988..955168f 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -55,8 +55,8 @@
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
 
-extern void brcmf_sdioh_dev_intr_off(sdioh_info_t *sd);
-extern void brcmf_sdioh_dev_intr_on(sdioh_info_t *sd);
+extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
+extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
 
 int brcmf_sdio_function_init(void);
 void brcmf_sdio_function_cleanup(void);
@@ -144,11 +144,11 @@ static struct sdio_driver bcmsdh_sdmmc_driver = {
 };
 
 struct sdos_info {
-	sdioh_info_t *sd;
+	struct sdioh_info *sd;
 	spinlock_t lock;
 };
 
-int brcmf_sdioh_osinit(sdioh_info_t *sd)
+int brcmf_sdioh_osinit(struct sdioh_info *sd)
 {
 	struct sdos_info *sdos;
 
@@ -162,7 +162,7 @@ int brcmf_sdioh_osinit(sdioh_info_t *sd)
 	return 0;
 }
 
-void brcmf_sdioh_osfree(sdioh_info_t *sd)
+void brcmf_sdioh_osfree(struct sdioh_info *sd)
 {
 	struct sdos_info *sdos;
 	ASSERT(sd && sd->sdos_info);
@@ -172,7 +172,7 @@ void brcmf_sdioh_osfree(sdioh_info_t *sd)
 }
 
 /* Interrupt enable/disable */
-SDIOH_API_RC brcmf_sdioh_interrupt_set(sdioh_info_t *sd, bool enable)
+SDIOH_API_RC brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
 {
 	unsigned long flags;
 	struct sdos_info *sdos;
-- 
1.7.1


