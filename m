Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2017 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757607Ab1F2Xsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 059/119] staging: brcm80211: replaced typedef
 SDIOH_API_RC by int
Date: Wed, 29 Jun 2011 16:47:23 -0700
Message-ID: <1309391303-22741-60-git-send-email-frankyl@broadcom.com> (sfid-20110630_014915_282841_9C44CAE0)
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
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h      |   24 ++++++-------
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   30 ++++++++--------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   36 ++++++++++----------
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    2 +-
 4 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index 5d09076..88d0b02 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -36,8 +36,6 @@
 #define SDIOH_DATA_PIO          0	/* PIO mode */
 #define SDIOH_DATA_DMA          1	/* DMA mode */
 
-typedef int SDIOH_API_RC;
-
 /* callback function, taking one arg */
 typedef void (*sdioh_cb_fn_t) (void *);
 
@@ -46,17 +44,17 @@ typedef void (*sdioh_cb_fn_t) (void *);
  *  cfghdl points to the starting address of pci device mapped memory
  */
 extern struct sdioh_info *brcmf_sdioh_attach(void *cfghdl, uint irq);
-extern SDIOH_API_RC brcmf_sdioh_detach(struct sdioh_info *si);
-extern SDIOH_API_RC brcmf_sdioh_interrupt_register(struct sdioh_info *si,
+extern int brcmf_sdioh_detach(struct sdioh_info *si);
+extern int brcmf_sdioh_interrupt_register(struct sdioh_info *si,
 					     sdioh_cb_fn_t fn, void *argh);
-extern SDIOH_API_RC brcmf_sdioh_interrupt_deregister(struct sdioh_info *si);
+extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *si);
 
 /* query whether SD interrupt is enabled or not */
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_interrupt_query(struct sdioh_info *si, bool *onoff);
 
 /* enable or disable SD interrupt */
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_interrupt_set(struct sdioh_info *si, bool enable_disable);
 
 #if defined(DHD_DEBUG)
@@ -67,30 +65,30 @@ extern int brcmf_sdioh_claim_host_and_lock(struct sdioh_info *si);
 extern int brcmf_sdioh_release_host_and_unlock(struct sdioh_info *si);
 
 /* read or write one byte using cmd52 */
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_request_byte(struct sdioh_info *si, uint rw, uint fnc, uint addr,
 			 u8 *byte);
 
 /* read or write 2/4 bytes using cmd53 */
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_request_word(struct sdioh_info *si, uint cmd_type,
 			 uint rw, uint fnc, uint addr,
 			 u32 *word, uint nbyte);
 
 /* read or write any buffer using cmd53 */
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_request_buffer(struct sdioh_info *si, uint pio_dma,
 			   uint fix_inc, uint rw, uint fnc_num,
 			   u32 addr, uint regwidth,
 			   u32 buflen, u8 *buffer, struct sk_buff *pkt);
 
 /* get cis data */
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_cis_read(struct sdioh_info *si, uint fuc, u8 *cis, u32 length);
 
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_cfg_read(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_cfg_write(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
 
 /* query number of io functions */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 0ebca53..733ba96 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -109,7 +109,7 @@ brcmf_sdcard_iovar_op(void *sdh, const char *name,
 bool brcmf_sdcard_intr_query(void *sdh)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 	bool on;
 
 	ASSERT(bcmsdh);
@@ -123,7 +123,7 @@ bool brcmf_sdcard_intr_query(void *sdh)
 int brcmf_sdcard_intr_enable(void *sdh)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 	ASSERT(bcmsdh);
 
 	status = brcmf_sdioh_interrupt_set(bcmsdh->sdioh, true);
@@ -133,7 +133,7 @@ int brcmf_sdcard_intr_enable(void *sdh)
 int brcmf_sdcard_intr_disable(void *sdh)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 	ASSERT(bcmsdh);
 
 	status = brcmf_sdioh_interrupt_set(bcmsdh->sdioh, false);
@@ -143,7 +143,7 @@ int brcmf_sdcard_intr_disable(void *sdh)
 int brcmf_sdcard_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 	ASSERT(bcmsdh);
 
 	status = brcmf_sdioh_interrupt_register(bcmsdh->sdioh, fn, argh);
@@ -153,7 +153,7 @@ int brcmf_sdcard_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 int brcmf_sdcard_intr_dereg(void *sdh)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 	ASSERT(bcmsdh);
 
 	status = brcmf_sdioh_interrupt_deregister(bcmsdh->sdioh);
@@ -181,7 +181,7 @@ int brcmf_sdcard_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 u8 brcmf_sdcard_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	s32 retry = 0;
 #endif
@@ -217,7 +217,7 @@ void
 brcmf_sdcard_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	s32 retry = 0;
 #endif
@@ -249,7 +249,7 @@ brcmf_sdcard_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 u32 brcmf_sdcard_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 	u32 data = 0;
 
 	if (!bcmsdh)
@@ -274,7 +274,7 @@ brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 		      int *err)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 
 	if (!bcmsdh)
 		bcmsdh = l_bcmsdh;
@@ -295,7 +295,7 @@ brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 int brcmf_sdcard_cis_read(void *sdh, uint func, u8 * cis, uint length)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 
 	u8 *tmp_buf, *tmp_ptr;
 	u8 *ptr;
@@ -355,7 +355,7 @@ static int brcmf_sdcard_set_sbaddr_window(void *sdh, u32 address)
 u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 	u32 word = 0;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 
@@ -408,7 +408,7 @@ u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size)
 u32 brcmf_sdcard_reg_write(void *sdh, u32 addr, uint size, u32 data)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
@@ -454,7 +454,7 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio *bcmsdh, u32 addr, uint fn, uint flags,
 		u8 *buf, uint nbytes, struct sk_buff *pkt,
 		bcmsdh_cmplt_fn_t complete, void *handle)
 {
-	SDIOH_API_RC status;
+	int status;
 	uint incr_fix;
 	uint width;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
@@ -498,7 +498,7 @@ brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 		bcmsdh_cmplt_fn_t complete, void *handle)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 	uint incr_fix;
 	uint width;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
@@ -539,7 +539,7 @@ brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 int brcmf_sdcard_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	SDIOH_API_RC status;
+	int status;
 
 	ASSERT(bcmsdh);
 	ASSERT(bcmsdh->init_success);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index df1e8c1..4f7d32a 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -167,7 +167,7 @@ struct sdioh_info *brcmf_sdioh_attach(void *bar0, uint irq)
 	return sd;
 }
 
-extern SDIOH_API_RC brcmf_sdioh_detach(struct sdioh_info *sd)
+extern int brcmf_sdioh_detach(struct sdioh_info *sd)
 {
 	sd_trace(("%s\n", __func__));
 
@@ -193,7 +193,7 @@ extern SDIOH_API_RC brcmf_sdioh_detach(struct sdioh_info *sd)
 
 #if defined(OOB_INTR_ONLY) && defined(HW_OOB)
 
-extern SDIOH_API_RC brcmf_sdioh_enable_func_intr(void)
+extern int brcmf_sdioh_enable_func_intr(void)
 {
 	u8 reg;
 	int err;
@@ -227,7 +227,7 @@ extern SDIOH_API_RC brcmf_sdioh_enable_func_intr(void)
 	return SDIOH_API_RC_SUCCESS;
 }
 
-extern SDIOH_API_RC brcmf_sdioh_disable_func_intr(void)
+extern int brcmf_sdioh_disable_func_intr(void)
 {
 	u8 reg;
 	int err;
@@ -260,7 +260,7 @@ extern SDIOH_API_RC brcmf_sdioh_disable_func_intr(void)
 #endif				/* defined(OOB_INTR_ONLY) && defined(HW_OOB) */
 
 /* Configure callback to client when we receive client interrupt */
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_interrupt_register(struct sdioh_info *sd, sdioh_cb_fn_t fn,
 			       void *argh)
 {
@@ -293,7 +293,7 @@ brcmf_sdioh_interrupt_register(struct sdioh_info *sd, sdioh_cb_fn_t fn,
 	return SDIOH_API_RC_SUCCESS;
 }
 
-extern SDIOH_API_RC brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
+extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 {
 	sd_trace(("%s: Entering\n", __func__));
 
@@ -322,7 +322,7 @@ extern SDIOH_API_RC brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 	return SDIOH_API_RC_SUCCESS;
 }
 
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_interrupt_query(struct sdioh_info *sd, bool *onoff)
 {
 	sd_trace(("%s: Entering\n", __func__));
@@ -536,9 +536,9 @@ exit:
 
 #if defined(OOB_INTR_ONLY) && defined(HW_OOB)
 
-SDIOH_API_RC brcmf_sdioh_enable_hw_oob_intr(struct sdioh_info *sd, bool enable)
+int brcmf_sdioh_enable_hw_oob_intr(struct sdioh_info *sd, bool enable)
 {
-	SDIOH_API_RC status;
+	int status;
 	u8 data;
 
 	if (enable)
@@ -552,20 +552,20 @@ SDIOH_API_RC brcmf_sdioh_enable_hw_oob_intr(struct sdioh_info *sd, bool enable)
 }
 #endif				/* defined(OOB_INTR_ONLY) && defined(HW_OOB) */
 
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_cfg_read(struct sdioh_info *sd, uint fnc_num, u32 addr, u8 *data)
 {
-	SDIOH_API_RC status;
+	int status;
 	/* No lock needed since brcmf_sdioh_request_byte does locking */
 	status = brcmf_sdioh_request_byte(sd, SDIOH_READ, fnc_num, addr, data);
 	return status;
 }
 
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_cfg_write(struct sdioh_info *sd, uint fnc_num, u32 addr, u8 *data)
 {
 	/* No lock needed since brcmf_sdioh_request_byte does locking */
-	SDIOH_API_RC status;
+	int status;
 	status = brcmf_sdioh_request_byte(sd, SDIOH_WRITE, fnc_num, addr, data);
 	return status;
 }
@@ -591,7 +591,7 @@ static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr)
 	return scratch;
 }
 
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_cis_read(struct sdioh_info *sd, uint func, u8 *cisd, u32 length)
 {
 	u32 count;
@@ -625,7 +625,7 @@ brcmf_sdioh_cis_read(struct sdioh_info *sd, uint func, u8 *cisd, u32 length)
 	return SDIOH_API_RC_SUCCESS;
 }
 
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 			 uint regaddr, u8 *byte)
 {
@@ -724,7 +724,7 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 	return ((err_ret == 0) ? SDIOH_API_RC_SUCCESS : SDIOH_API_RC_FAIL);
 }
 
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 			 uint func, uint addr, u32 *word, uint nbytes)
 {
@@ -777,7 +777,7 @@ brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 	return ((err_ret == 0) ? SDIOH_API_RC_SUCCESS : SDIOH_API_RC_FAIL);
 }
 
-static SDIOH_API_RC
+static int
 brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 			   uint func, uint addr, struct sk_buff *pkt)
 {
@@ -873,12 +873,12 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
  * aligned packet.
  *
  */
-extern SDIOH_API_RC
+extern int
 brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 			   uint write, uint func, uint addr, uint reg_width,
 			   uint buflen_u, u8 *buffer, struct sk_buff *pkt)
 {
-	SDIOH_API_RC Status;
+	int Status;
 	struct sk_buff *mypkt = NULL;
 
 	sd_trace(("%s: Enter\n", __func__));
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 955168f..c95112e 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -172,7 +172,7 @@ void brcmf_sdioh_osfree(struct sdioh_info *sd)
 }
 
 /* Interrupt enable/disable */
-SDIOH_API_RC brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
+int brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
 {
 	unsigned long flags;
 	struct sdos_info *sdos;
-- 
1.7.1


