Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2064 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677Ab1F2XtW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:22 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 035/119] staging: brcm80211: replaced prefix of SDIO
 related functions
Date: Wed, 29 Jun 2011 16:46:59 -0700
Message-ID: <1309391303-22741-36-git-send-email-frankyl@broadcom.com> (sfid-20110630_015235_844255_85B75969)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Prefixed functions with brcmf_ for unique namespace. In addition
to that, prefix has been changed to categorize functions depending on their
place in the drivers SDIO stack.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h      |   48 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |  158 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |   58 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |  146 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h  |   22 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |   52 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h       |   22 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    9 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   26 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   29 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      | 1010 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |   79 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    4 +-
 13 files changed, 855 insertions(+), 808 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index e9da1ce..7eb0354 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -48,68 +48,70 @@ typedef void (*sdioh_cb_fn_t) (void *);
  *  The handler shall be provided by all subsequent calls. No local cache
  *  cfghdl points to the starting address of pci device mapped memory
  */
-extern sdioh_info_t *sdioh_attach(void *cfghdl, uint irq);
-extern SDIOH_API_RC sdioh_detach(sdioh_info_t *si);
-extern SDIOH_API_RC sdioh_interrupt_register(sdioh_info_t *si,
+extern sdioh_info_t *brcmf_sdioh_attach(void *cfghdl, uint irq);
+extern SDIOH_API_RC brcmf_sdioh_detach(sdioh_info_t *si);
+extern SDIOH_API_RC brcmf_sdioh_interrupt_register(sdioh_info_t *si,
 					     sdioh_cb_fn_t fn, void *argh);
-extern SDIOH_API_RC sdioh_interrupt_deregister(sdioh_info_t *si);
+extern SDIOH_API_RC brcmf_sdioh_interrupt_deregister(sdioh_info_t *si);
 
 /* query whether SD interrupt is enabled or not */
-extern SDIOH_API_RC sdioh_interrupt_query(sdioh_info_t *si, bool *onoff);
+extern SDIOH_API_RC brcmf_sdioh_interrupt_query(sdioh_info_t *si, bool *onoff);
 
 /* enable or disable SD interrupt */
-extern SDIOH_API_RC sdioh_interrupt_set(sdioh_info_t *si, bool enable_disable);
+extern SDIOH_API_RC
+brcmf_sdioh_interrupt_set(sdioh_info_t *si, bool enable_disable);
 
 #if defined(DHD_DEBUG)
-extern bool sdioh_interrupt_pending(sdioh_info_t *si);
+extern bool brcmf_sdioh_interrupt_pending(sdioh_info_t *si);
 #endif
 
-extern int sdioh_claim_host_and_lock(sdioh_info_t *si);
-extern int sdioh_release_host_and_unlock(sdioh_info_t *si);
+extern int brcmf_sdioh_claim_host_and_lock(sdioh_info_t *si);
+extern int brcmf_sdioh_release_host_and_unlock(sdioh_info_t *si);
 
 /* read or write one byte using cmd52 */
-extern SDIOH_API_RC sdioh_request_byte(sdioh_info_t *si, uint rw, uint fnc,
-				       uint addr, u8 *byte);
+extern SDIOH_API_RC
+brcmf_sdioh_request_byte(sdioh_info_t *si, uint rw, uint fnc, uint addr,
+			 u8 *byte);
 
 /* read or write 2/4 bytes using cmd53 */
-extern SDIOH_API_RC sdioh_request_word(sdioh_info_t *si, uint cmd_type,
+extern SDIOH_API_RC brcmf_sdioh_request_word(sdioh_info_t *si, uint cmd_type,
 				       uint rw, uint fnc, uint addr,
 				       u32 *word, uint nbyte);
 
 /* read or write any buffer using cmd53 */
-extern SDIOH_API_RC sdioh_request_buffer(sdioh_info_t *si, uint pio_dma,
+extern SDIOH_API_RC brcmf_sdioh_request_buffer(sdioh_info_t *si, uint pio_dma,
 					 uint fix_inc, uint rw, uint fnc_num,
 					 u32 addr, uint regwidth,
 					 u32 buflen, u8 *buffer,
 					 struct sk_buff *pkt);
 
 /* get cis data */
-extern SDIOH_API_RC sdioh_cis_read(sdioh_info_t *si, uint fuc, u8 *cis,
+extern SDIOH_API_RC brcmf_sdioh_cis_read(sdioh_info_t *si, uint fuc, u8 *cis,
 				   u32 length);
 
-extern SDIOH_API_RC sdioh_cfg_read(sdioh_info_t *si, uint fuc, u32 addr,
+extern SDIOH_API_RC brcmf_sdioh_cfg_read(sdioh_info_t *si, uint fuc, u32 addr,
 				   u8 *data);
-extern SDIOH_API_RC sdioh_cfg_write(sdioh_info_t *si, uint fuc, u32 addr,
+extern SDIOH_API_RC brcmf_sdioh_cfg_write(sdioh_info_t *si, uint fuc, u32 addr,
 				    u8 *data);
 
 /* query number of io functions */
-extern uint sdioh_query_iofnum(sdioh_info_t *si);
+extern uint brcmf_sdioh_query_iofnum(sdioh_info_t *si);
 
 /* handle iovars */
-extern int sdioh_iovar_op(sdioh_info_t *si, const char *name,
+extern int brcmf_sdioh_iovar_op(sdioh_info_t *si, const char *name,
 			  void *params, int plen, void *arg, int len, bool set);
 
 /* Issue abort to the specified function and clear controller as needed */
-extern int sdioh_abort(sdioh_info_t *si, uint fnc);
+extern int brcmf_sdioh_abort(sdioh_info_t *si, uint fnc);
 
 /* Start and Stop SDIO without re-enumerating the SD card. */
-extern int sdioh_start(sdioh_info_t *si, int stage);
-extern int sdioh_stop(sdioh_info_t *si);
+extern int brcmf_sdioh_start(sdioh_info_t *si, int stage);
+extern int brcmf_sdioh_stop(sdioh_info_t *si);
 
 /* Reset and re-initialize the device */
-extern int sdioh_sdio_reset(sdioh_info_t *si);
+extern int brcmf_sdioh_reset(sdioh_info_t *si);
 
 /* Helper function */
-void *bcmsdh_get_sdioh(bcmsdh_info_t *sdh);
+void *brcmf_sdcard_get_sdioh(bcmsdh_info_t *sdh);
 
 #endif				/* _sdio_api_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 58dffc0..f41bb1e 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -45,15 +45,15 @@ struct bcmsdh_info {
 bcmsdh_info_t *l_bcmsdh;
 
 #if defined(OOB_INTR_ONLY) && defined(HW_OOB)
-extern int sdioh_enable_hw_oob_intr(void *sdioh, bool enable);
+extern int brcmf_sdioh_enable_hw_oob_intr(void *sdioh, bool enable);
 
-void bcmsdh_enable_hw_oob_intr(bcmsdh_info_t *sdh, bool enable)
+void brcmf_sdcard_enable_hw_oob_intr(bcmsdh_info_t *sdh, bool enable)
 {
-	sdioh_enable_hw_oob_intr(sdh->sdioh, enable);
+	brcmf_sdioh_enable_hw_oob_intr(sdh->sdioh, enable);
 }
 #endif
 
-bcmsdh_info_t *bcmsdh_attach(void *cfghdl, void **regsva, uint irq)
+bcmsdh_info_t *brcmf_sdcard_attach(void *cfghdl, void **regsva, uint irq)
 {
 	bcmsdh_info_t *bcmsdh;
 
@@ -66,9 +66,9 @@ bcmsdh_info_t *bcmsdh_attach(void *cfghdl, void **regsva, uint irq)
 	/* save the handler locally */
 	l_bcmsdh = bcmsdh;
 
-	bcmsdh->sdioh = sdioh_attach(cfghdl, irq);
+	bcmsdh->sdioh = brcmf_sdioh_attach(cfghdl, irq);
 	if (!bcmsdh->sdioh) {
-		bcmsdh_detach(bcmsdh);
+		brcmf_sdcard_detach(bcmsdh);
 		return NULL;
 	}
 
@@ -81,13 +81,13 @@ bcmsdh_info_t *bcmsdh_attach(void *cfghdl, void **regsva, uint irq)
 	return bcmsdh;
 }
 
-int bcmsdh_detach(void *sdh)
+int brcmf_sdcard_detach(void *sdh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 
 	if (bcmsdh != NULL) {
 		if (bcmsdh->sdioh) {
-			sdioh_detach(bcmsdh->sdioh);
+			brcmf_sdioh_detach(bcmsdh->sdioh);
 			bcmsdh->sdioh = NULL;
 		}
 		kfree(bcmsdh);
@@ -98,78 +98,79 @@ int bcmsdh_detach(void *sdh)
 }
 
 int
-bcmsdh_iovar_op(void *sdh, const char *name,
+brcmf_sdcard_iovar_op(void *sdh, const char *name,
 		void *params, int plen, void *arg, int len, bool set)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
-	return sdioh_iovar_op(bcmsdh->sdioh, name, params, plen, arg, len, set);
+	return brcmf_sdioh_iovar_op(bcmsdh->sdioh, name, params, plen, arg,
+				    len, set);
 }
 
-bool bcmsdh_intr_query(void *sdh)
+bool brcmf_sdcard_intr_query(void *sdh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
 	bool on;
 
 	ASSERT(bcmsdh);
-	status = sdioh_interrupt_query(bcmsdh->sdioh, &on);
+	status = brcmf_sdioh_interrupt_query(bcmsdh->sdioh, &on);
 	if (SDIOH_API_SUCCESS(status))
 		return false;
 	else
 		return on;
 }
 
-int bcmsdh_intr_enable(void *sdh)
+int brcmf_sdcard_intr_enable(void *sdh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
 	ASSERT(bcmsdh);
 
-	status = sdioh_interrupt_set(bcmsdh->sdioh, true);
+	status = brcmf_sdioh_interrupt_set(bcmsdh->sdioh, true);
 	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
-int bcmsdh_intr_disable(void *sdh)
+int brcmf_sdcard_intr_disable(void *sdh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
 	ASSERT(bcmsdh);
 
-	status = sdioh_interrupt_set(bcmsdh->sdioh, false);
+	status = brcmf_sdioh_interrupt_set(bcmsdh->sdioh, false);
 	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
-int bcmsdh_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
+int brcmf_sdcard_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
 	ASSERT(bcmsdh);
 
-	status = sdioh_interrupt_register(bcmsdh->sdioh, fn, argh);
+	status = brcmf_sdioh_interrupt_register(bcmsdh->sdioh, fn, argh);
 	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
-int bcmsdh_intr_dereg(void *sdh)
+int brcmf_sdcard_intr_dereg(void *sdh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
 	ASSERT(bcmsdh);
 
-	status = sdioh_interrupt_deregister(bcmsdh->sdioh);
+	status = brcmf_sdioh_interrupt_deregister(bcmsdh->sdioh);
 	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 #if defined(DHD_DEBUG)
-bool bcmsdh_intr_pending(void *sdh)
+bool brcmf_sdcard_intr_pending(void *sdh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 
 	ASSERT(sdh);
-	return sdioh_interrupt_pending(bcmsdh->sdioh);
+	return brcmf_sdioh_interrupt_pending(bcmsdh->sdioh);
 }
 #endif
 
-int bcmsdh_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
+int brcmf_sdcard_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 {
 	ASSERT(sdh);
 
@@ -177,7 +178,7 @@ int bcmsdh_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 	return -ENOTSUPP;
 }
 
-u8 bcmsdh_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
+u8 brcmf_sdcard_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
@@ -197,7 +198,7 @@ u8 bcmsdh_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 			udelay(1000);
 #endif
 		status =
-		    sdioh_cfg_read(bcmsdh->sdioh, fnc_num, addr,
+		    brcmf_sdioh_cfg_read(bcmsdh->sdioh, fnc_num, addr,
 				   (u8 *) &data);
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	} while (!SDIOH_API_SUCCESS(status)
@@ -213,7 +214,7 @@ u8 bcmsdh_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 }
 
 void
-bcmsdh_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
+brcmf_sdcard_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
@@ -232,7 +233,7 @@ bcmsdh_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 			udelay(1000);
 #endif
 		status =
-		    sdioh_cfg_write(bcmsdh->sdioh, fnc_num, addr,
+		    brcmf_sdioh_cfg_write(bcmsdh->sdioh, fnc_num, addr,
 				    (u8 *) &data);
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	} while (!SDIOH_API_SUCCESS(status)
@@ -245,7 +246,7 @@ bcmsdh_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 		     __func__, fnc_num, addr, data));
 }
 
-u32 bcmsdh_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
+u32 brcmf_sdcard_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
@@ -256,9 +257,8 @@ u32 bcmsdh_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
 
 	ASSERT(bcmsdh->init_success);
 
-	status =
-	    sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL, SDIOH_READ,
-			       fnc_num, addr, &data, 4);
+	status = brcmf_sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
+		SDIOH_READ, fnc_num, addr, &data, 4);
 
 	if (err)
 		*err = (SDIOH_API_SUCCESS(status) ? 0 : -EIO);
@@ -270,7 +270,7 @@ u32 bcmsdh_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
 }
 
 void
-bcmsdh_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
+brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 		      int *err)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
@@ -282,7 +282,7 @@ bcmsdh_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 	ASSERT(bcmsdh->init_success);
 
 	status =
-	    sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	    brcmf_sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
 			       SDIOH_WRITE, fnc_num, addr, &data, 4);
 
 	if (err)
@@ -292,7 +292,7 @@ bcmsdh_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 		     __func__, fnc_num, addr, data));
 }
 
-int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
+int brcmf_sdcard_cis_read(void *sdh, uint func, u8 * cis, uint length)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
@@ -309,7 +309,7 @@ int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
 	ASSERT(cis);
 	ASSERT(length <= SBSDIO_CIS_SIZE_LIMIT);
 
-	status = sdioh_cis_read(bcmsdh->sdioh, func, cis, length);
+	status = brcmf_sdioh_cis_read(bcmsdh->sdioh, func, cis, length);
 
 	if (ascii) {
 		/* Move binary bits to tmp and format them
@@ -332,24 +332,27 @@ int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
 	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
-static int bcmsdhsdio_set_sbaddr_window(void *sdh, u32 address)
+static int brcmf_sdcard_set_sbaddr_window(void *sdh, u32 address)
 {
 	int err = 0;
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
-	bcmsdh_cfg_write(bcmsdh, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
+	brcmf_sdcard_cfg_write(bcmsdh, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
 			 (address >> 8) & SBSDIO_SBADDRLOW_MASK, &err);
 	if (!err)
-		bcmsdh_cfg_write(bcmsdh, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRMID,
-				 (address >> 16) & SBSDIO_SBADDRMID_MASK, &err);
+		brcmf_sdcard_cfg_write(bcmsdh, SDIO_FUNC_1,
+				       SBSDIO_FUNC1_SBADDRMID,
+				       (address >> 16) & SBSDIO_SBADDRMID_MASK,
+				       &err);
 	if (!err)
-		bcmsdh_cfg_write(bcmsdh, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRHIGH,
-				 (address >> 24) & SBSDIO_SBADDRHIGH_MASK,
-				 &err);
+		brcmf_sdcard_cfg_write(bcmsdh, SDIO_FUNC_1,
+				       SBSDIO_FUNC1_SBADDRHIGH,
+				       (address >> 24) & SBSDIO_SBADDRHIGH_MASK,
+				       &err);
 
 	return err;
 }
 
-u32 bcmsdh_reg_read(void *sdh, u32 addr, uint size)
+u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
@@ -364,7 +367,7 @@ u32 bcmsdh_reg_read(void *sdh, u32 addr, uint size)
 	ASSERT(bcmsdh->init_success);
 
 	if (bar0 != bcmsdh->sbwad) {
-		if (bcmsdhsdio_set_sbaddr_window(bcmsdh, bar0))
+		if (brcmf_sdcard_set_sbaddr_window(bcmsdh, bar0))
 			return 0xFFFFFFFF;
 
 		bcmsdh->sbwad = bar0;
@@ -374,7 +377,7 @@ u32 bcmsdh_reg_read(void *sdh, u32 addr, uint size)
 	if (size == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	status = brcmf_sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
 				    SDIOH_READ, SDIO_FUNC_1, addr, &word, size);
 
 	bcmsdh->regfail = !(SDIOH_API_SUCCESS(status));
@@ -402,7 +405,7 @@ u32 bcmsdh_reg_read(void *sdh, u32 addr, uint size)
 	return 0xFFFFFFFF;
 }
 
-u32 bcmsdh_reg_write(void *sdh, u32 addr, uint size, u32 data)
+u32 brcmf_sdcard_reg_write(void *sdh, u32 addr, uint size, u32 data)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
@@ -418,7 +421,7 @@ u32 bcmsdh_reg_write(void *sdh, u32 addr, uint size, u32 data)
 	ASSERT(bcmsdh->init_success);
 
 	if (bar0 != bcmsdh->sbwad) {
-		err = bcmsdhsdio_set_sbaddr_window(bcmsdh, bar0);
+		err = brcmf_sdcard_set_sbaddr_window(bcmsdh, bar0);
 		if (err)
 			return err;
 
@@ -429,7 +432,7 @@ u32 bcmsdh_reg_write(void *sdh, u32 addr, uint size, u32 data)
 	if (size == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 	status =
-	    sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	    brcmf_sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
 			       SDIOH_WRITE, SDIO_FUNC_1, addr, &data, size);
 	bcmsdh->regfail = !(SDIOH_API_SUCCESS(status));
 
@@ -441,13 +444,13 @@ u32 bcmsdh_reg_write(void *sdh, u32 addr, uint size, u32 data)
 	return 0xFFFFFFFF;
 }
 
-bool bcmsdh_regfail(void *sdh)
+bool brcmf_sdcard_regfail(void *sdh)
 {
 	return ((bcmsdh_info_t *) sdh)->regfail;
 }
 
 int
-bcmsdh_recv_buf(bcmsdh_info_t *bcmsdh, u32 addr, uint fn, uint flags,
+brcmf_sdcard_recv_buf(bcmsdh_info_t *bcmsdh, u32 addr, uint fn, uint flags,
 		u8 *buf, uint nbytes, struct sk_buff *pkt,
 		bcmsdh_cmplt_fn_t complete, void *handle)
 {
@@ -469,7 +472,7 @@ bcmsdh_recv_buf(bcmsdh_info_t *bcmsdh, u32 addr, uint fn, uint flags,
 		return -ENOTSUPP;
 
 	if (bar0 != bcmsdh->sbwad) {
-		err = bcmsdhsdio_set_sbaddr_window(bcmsdh, bar0);
+		err = brcmf_sdcard_set_sbaddr_window(bcmsdh, bar0);
 		if (err)
 			return err;
 
@@ -483,15 +486,14 @@ bcmsdh_recv_buf(bcmsdh_info_t *bcmsdh, u32 addr, uint fn, uint flags,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO, incr_fix,
-				      SDIOH_READ, fn, addr, width, nbytes, buf,
-				      pkt);
+	status = brcmf_sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO,
+		incr_fix, SDIOH_READ, fn, addr, width, nbytes, buf, pkt);
 
 	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int
-bcmsdh_send_buf(void *sdh, u32 addr, uint fn, uint flags,
+brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 		u8 *buf, uint nbytes, void *pkt,
 		bcmsdh_cmplt_fn_t complete, void *handle)
 {
@@ -514,7 +516,7 @@ bcmsdh_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 		return -ENOTSUPP;
 
 	if (bar0 != bcmsdh->sbwad) {
-		err = bcmsdhsdio_set_sbaddr_window(bcmsdh, bar0);
+		err = brcmf_sdcard_set_sbaddr_window(bcmsdh, bar0);
 		if (err)
 			return err;
 
@@ -528,14 +530,13 @@ bcmsdh_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO, incr_fix,
-				      SDIOH_WRITE, fn, addr, width, nbytes, buf,
-				      pkt);
+	status = brcmf_sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO,
+		incr_fix, SDIOH_WRITE, fn, addr, width, nbytes, buf, pkt);
 
 	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
-int bcmsdh_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
+int brcmf_sdcard_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
@@ -547,72 +548,71 @@ int bcmsdh_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status =
-	    sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO, SDIOH_DATA_INC,
-				 (rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
-				 addr, 4, nbytes, buf, NULL);
+	status = brcmf_sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO,
+		SDIOH_DATA_INC, (rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
+		addr, 4, nbytes, buf, NULL);
 
 	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
-int bcmsdh_abort(void *sdh, uint fn)
+int brcmf_sdcard_abort(void *sdh, uint fn)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 
-	return sdioh_abort(bcmsdh->sdioh, fn);
+	return brcmf_sdioh_abort(bcmsdh->sdioh, fn);
 }
 
-int bcmsdh_start(void *sdh, int stage)
+int brcmf_sdcard_start(void *sdh, int stage)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 
-	return sdioh_start(bcmsdh->sdioh, stage);
+	return brcmf_sdioh_start(bcmsdh->sdioh, stage);
 }
 
-int bcmsdh_stop(void *sdh)
+int brcmf_sdcard_stop(void *sdh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 
-	return sdioh_stop(bcmsdh->sdioh);
+	return brcmf_sdioh_stop(bcmsdh->sdioh);
 }
 
-int bcmsdh_query_device(void *sdh)
+int brcmf_sdcard_query_device(void *sdh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	bcmsdh->vendevid = (PCI_VENDOR_ID_BROADCOM << 16) | 0;
 	return bcmsdh->vendevid;
 }
 
-uint bcmsdh_query_iofnum(void *sdh)
+uint brcmf_sdcard_query_iofnum(void *sdh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 
 	if (!bcmsdh)
 		bcmsdh = l_bcmsdh;
 
-	return sdioh_query_iofnum(bcmsdh->sdioh);
+	return brcmf_sdioh_query_iofnum(bcmsdh->sdioh);
 }
 
-int bcmsdh_reset(bcmsdh_info_t *sdh)
+int brcmf_sdcard_reset(bcmsdh_info_t *sdh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 
-	return sdioh_sdio_reset(bcmsdh->sdioh);
+	return brcmf_sdioh_reset(bcmsdh->sdioh);
 }
 
-void *bcmsdh_get_sdioh(bcmsdh_info_t *sdh)
+void *brcmf_sdcard_get_sdioh(bcmsdh_info_t *sdh)
 {
 	ASSERT(sdh);
 	return sdh->sdioh;
 }
 
 /* Function to pass device-status bits to DHD. */
-u32 bcmsdh_get_dstatus(void *sdh)
+u32 brcmf_sdcard_get_dstatus(void *sdh)
 {
 	return 0;
 }
 
-u32 bcmsdh_cur_sbwad(void *sdh)
+u32 brcmf_sdcard_cur_sbwad(void *sdh)
 {
 	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 
@@ -622,7 +622,7 @@ u32 bcmsdh_cur_sbwad(void *sdh)
 	return bcmsdh->sbwad;
 }
 
-void bcmsdh_chipinfo(void *sdh, u32 chip, u32 chiprev)
+void brcmf_sdcard_chipinfo(void *sdh, u32 chip, u32 chiprev)
 {
 	return;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 71ef23a..8007e90 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -33,7 +33,7 @@
 
 #if defined(OOB_INTR_ONLY)
 #include <linux/irq.h>
-extern void dhdsdio_isr(void *args);
+extern void brcmf_sdbrcm_isr(void *args);
 #endif				/* defined(OOB_INTR_ONLY) */
 #if defined(CONFIG_MACH_SANDGATE2G) || defined(CONFIG_MACH_LOGICPD_PXA270)
 #if !defined(BCMPLATFORM_BUS)
@@ -71,7 +71,7 @@ struct bcmsdh_hc {
 };
 static bcmsdh_hc_t *sdhcinfo;
 
-/* driver info, initialized when bcmsdh_register is called */
+/* driver info, initialized when brcmf_sdio_register is called */
 static bcmsdh_driver_t drvinfo = { NULL, NULL };
 
 /* debugging macros */
@@ -80,7 +80,7 @@ static bcmsdh_driver_t drvinfo = { NULL, NULL };
 /**
  * Checks to see if vendor and device IDs match a supported SDIO Host Controller.
  */
-bool bcmsdh_chipmatch(u16 vendor, u16 device)
+bool brcmf_sdio_chipmatch(u16 vendor, u16 device)
 {
 	/* Add other vendors and devices as required */
 
@@ -125,22 +125,22 @@ bool bcmsdh_chipmatch(u16 vendor, u16 device)
 #if defined(BCMPLATFORM_BUS)
 #if defined(BCMLXSDMMC)
 /* forward declarations */
-int bcmsdh_probe(struct device *dev);
-EXPORT_SYMBOL(bcmsdh_probe);
+int brcmf_sdio_probe(struct device *dev);
+EXPORT_SYMBOL(brcmf_sdio_probe);
 
-int bcmsdh_remove(struct device *dev);
-EXPORT_SYMBOL(bcmsdh_remove);
+int brcmf_sdio_remove(struct device *dev);
+EXPORT_SYMBOL(brcmf_sdio_remove);
 
 #else
 /* forward declarations */
-static int __devinit bcmsdh_probe(struct device *dev);
-static int __devexit bcmsdh_remove(struct device *dev);
+static int __devinit brcmf_sdio_probe(struct device *dev);
+static int __devexit brcmf_sdio_remove(struct device *dev);
 #endif				/* BCMLXSDMMC */
 
 #ifndef BCMLXSDMMC
 static
 #endif				/* BCMLXSDMMC */
-int bcmsdh_probe(struct device *dev)
+int brcmf_sdio_probe(struct device *dev)
 {
 	bcmsdh_hc_t *sdhc = NULL;
 	unsigned long regs = 0;
@@ -184,13 +184,13 @@ int bcmsdh_probe(struct device *dev)
 	sdhc->dev = (void *)dev;
 
 #ifdef BCMLXSDMMC
-	sdh = bcmsdh_attach((void *)0, (void **)&regs, irq);
+	sdh = brcmf_sdcard_attach((void *)0, (void **)&regs, irq);
 	if (!sdh) {
 		SDLX_MSG(("%s: bcmsdh_attach failed\n", __func__));
 		goto err;
 	}
 #else
-	sdh = bcmsdh_attach((void *)r->start, (void **)&regs, irq);
+	sdh = brcmf_sdcard_attach((void *)r->start, (void **)&regs, irq);
 	if (!sdh) {
 		SDLX_MSG(("%s: bcmsdh_attach failed\n", __func__));
 		goto err;
@@ -208,7 +208,7 @@ int bcmsdh_probe(struct device *dev)
 	sdhc->next = sdhcinfo;
 	sdhcinfo = sdhc;
 	/* Read the vendor/device ID from the CIS */
-	vendevid = bcmsdh_query_device(sdh);
+	vendevid = brcmf_sdcard_query_device(sdh);
 
 	/* try to attach to the target device */
 	sdhc->ch = drvinfo.attach((vendevid >> 16), (vendevid & 0xFFFF),
@@ -224,7 +224,7 @@ int bcmsdh_probe(struct device *dev)
 err:
 	if (sdhc) {
 		if (sdhc->sdh)
-			bcmsdh_detach(sdhc->sdh);
+			brcmf_sdcard_detach(sdhc->sdh);
 		kfree(sdhc);
 	}
 
@@ -234,13 +234,13 @@ err:
 #ifndef BCMLXSDMMC
 static
 #endif				/* BCMLXSDMMC */
-int bcmsdh_remove(struct device *dev)
+int brcmf_sdio_remove(struct device *dev)
 {
 	bcmsdh_hc_t *sdhc, *prev;
 
 	sdhc = sdhcinfo;
 	drvinfo.detach(sdhc->ch);
-	bcmsdh_detach(sdhc->sdh);
+	brcmf_sdcard_detach(sdhc->sdh);
 	/* find the SDIO Host Controller state for this pdev
 		 and take it out from the list */
 	for (sdhc = sdhcinfo, prev = NULL; sdhc; sdhc = sdhc->next) {
@@ -269,25 +269,25 @@ int bcmsdh_remove(struct device *dev)
 }
 #endif				/* BCMPLATFORM_BUS */
 
-extern int sdio_function_init(void);
+extern int brcmf_sdio_function_init(void);
 
-int bcmsdh_register(bcmsdh_driver_t *driver)
+int brcmf_sdio_register(bcmsdh_driver_t *driver)
 {
 	drvinfo = *driver;
 
 	SDLX_MSG(("Linux Kernel SDIO/MMC Driver\n"));
-	return sdio_function_init();
+	return brcmf_sdio_function_init();
 }
 
-extern void sdio_function_cleanup(void);
+extern void brcmf_sdio_function_cleanup(void);
 
-void bcmsdh_unregister(void)
+void brcmf_sdio_unregister(void)
 {
-	sdio_function_cleanup();
+	brcmf_sdio_function_cleanup();
 }
 
 #if defined(OOB_INTR_ONLY)
-void bcmsdh_oob_intr_set(bool enable)
+void brcmf_sdio_oob_intr_set(bool enable)
 {
 	static bool curstate = 1;
 	unsigned long flags;
@@ -303,25 +303,25 @@ void bcmsdh_oob_intr_set(bool enable)
 	spin_unlock_irqrestore(&sdhcinfo->irq_lock, flags);
 }
 
-static irqreturn_t wlan_oob_irq(int irq, void *dev_id)
+static irqreturn_t brcmf_sdio_oob_irq(int irq, void *dev_id)
 {
 	dhd_pub_t *dhdp;
 
 	dhdp = (dhd_pub_t *) dev_get_drvdata(sdhcinfo->dev);
 
-	bcmsdh_oob_intr_set(0);
+	brcmf_sdio_oob_intr_set(0);
 
 	if (dhdp == NULL) {
 		SDLX_MSG(("Out of band GPIO interrupt fired way too early\n"));
 		return IRQ_HANDLED;
 	}
 
-	dhdsdio_isr((void *)dhdp->bus);
+	brcmf_sdbrcm_isr((void *)dhdp->bus);
 
 	return IRQ_HANDLED;
 }
 
-int bcmsdh_register_oob_intr(void *dhdp)
+int brcmf_sdio_register_oob_intr(void *dhdp)
 {
 	int error = 0;
 
@@ -338,7 +338,7 @@ int bcmsdh_register_oob_intr(void *dhdp)
 		/* Refer to customer Host IRQ docs about
 			 proper irqflags definition */
 		error =
-		    request_irq(sdhcinfo->oob_irq, wlan_oob_irq,
+		    request_irq(sdhcinfo->oob_irq, brcmf_sdio_oob_irq,
 				sdhcinfo->oob_flags, "bcmsdh_sdmmc", NULL);
 		if (error)
 			return -ENODEV;
@@ -350,7 +350,7 @@ int bcmsdh_register_oob_intr(void *dhdp)
 	return 0;
 }
 
-void bcmsdh_unregister_oob_intr(void)
+void brcmf_sdio_unregister_oob_intr(void)
 {
 	SDLX_MSG(("%s: Enter\n", __func__));
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index b90d7d0..59bdfea 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -32,15 +32,15 @@
 #include "dhd.h"
 #include "bcmsdh_sdmmc.h"
 
-extern int sdio_function_init(void);
-extern void sdio_function_cleanup(void);
+extern int brcmf_sdio_function_init(void);
+extern void brcmf_sdio_function_cleanup(void);
 
 #if !defined(OOB_INTR_ONLY)
-static void IRQHandler(struct sdio_func *func);
-static void IRQHandlerF2(struct sdio_func *func);
+static void brcmf_sdioh_irqhandler(struct sdio_func *func);
+static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func);
 #endif				/* !defined(OOB_INTR_ONLY) */
-static int sdioh_sdmmc_get_cisaddr(sdioh_info_t *sd, u32 regaddr);
-extern int sdio_reset_comm(struct mmc_card *card);
+static int brcmf_sdioh_get_cisaddr(sdioh_info_t *sd, u32 regaddr);
+extern int brcmf_sdioh_reset_comm(struct mmc_card *card);
 
 extern PBCMSDH_SDMMC_INSTANCE gInstance;
 
@@ -54,17 +54,17 @@ DHD_PM_RESUME_WAIT_INIT(sdioh_request_buffer_wait);
 
 #define DMA_ALIGN_MASK	0x03
 
-int sdioh_sdmmc_card_regread(sdioh_info_t *sd, int func, u32 regaddr,
+int brcmf_sdioh_card_regread(sdioh_info_t *sd, int func, u32 regaddr,
 			     int regsize, u32 *data);
 
-void sdioh_sdio_set_host_pm_flags(int flag)
+void brcmf_sdioh_set_host_pm_flags(int flag)
 {
 	if (sdio_set_host_pm_flags(gInstance->func[1], flag))
 		printk(KERN_ERR "%s: Failed to set pm_flags 0x%08x\n",\
 			 __func__, (unsigned int)flag);
 }
 
-static int sdioh_sdmmc_card_enablefuncs(sdioh_info_t *sd)
+static int brcmf_sdioh_enablefuncs(sdioh_info_t *sd)
 {
 	int err_ret;
 	u32 fbraddr;
@@ -73,7 +73,7 @@ static int sdioh_sdmmc_card_enablefuncs(sdioh_info_t *sd)
 	sd_trace(("%s\n", __func__));
 
 	/* Get the Card's common CIS address */
-	sd->com_cis_ptr = sdioh_sdmmc_get_cisaddr(sd, SDIO_CCCR_CIS);
+	sd->com_cis_ptr = brcmf_sdioh_get_cisaddr(sd, SDIO_CCCR_CIS);
 	sd->func_cis_ptr[0] = sd->com_cis_ptr;
 	sd_info(("%s: Card's Common CIS Ptr = 0x%x\n", __func__,
 		 sd->com_cis_ptr));
@@ -82,7 +82,7 @@ static int sdioh_sdmmc_card_enablefuncs(sdioh_info_t *sd)
 	for (fbraddr = SDIO_FBR_BASE(1), func = 1;
 	     func <= sd->num_funcs; func++, fbraddr += SDIOD_FBR_SIZE) {
 		sd->func_cis_ptr[func] =
-		    sdioh_sdmmc_get_cisaddr(sd, SDIO_FBR_CIS + fbraddr);
+		    brcmf_sdioh_get_cisaddr(sd, SDIO_FBR_CIS + fbraddr);
 		sd_info(("%s: Function %d CIS Ptr = 0x%x\n", __func__, func,
 			 sd->func_cis_ptr[func]));
 	}
@@ -106,7 +106,7 @@ static int sdioh_sdmmc_card_enablefuncs(sdioh_info_t *sd)
 /*
  *	Public entry points & extern's
  */
-sdioh_info_t *sdioh_attach(void *bar0, uint irq)
+sdioh_info_t *brcmf_sdioh_attach(void *bar0, uint irq)
 {
 	sdioh_info_t *sd;
 	int err_ret;
@@ -123,7 +123,7 @@ sdioh_info_t *sdioh_attach(void *bar0, uint irq)
 		sd_err(("sdioh_attach: out of memory\n"));
 		return NULL;
 	}
-	if (sdioh_sdmmc_osinit(sd) != 0) {
+	if (brcmf_sdioh_osinit(sd) != 0) {
 		sd_err(("%s:sdioh_sdmmc_osinit() failed\n", __func__));
 		kfree(sd);
 		return NULL;
@@ -161,13 +161,13 @@ sdioh_info_t *sdioh_attach(void *bar0, uint irq)
 		sdio_release_host(gInstance->func[2]);
 	}
 
-	sdioh_sdmmc_card_enablefuncs(sd);
+	brcmf_sdioh_enablefuncs(sd);
 
 	sd_trace(("%s: Done\n", __func__));
 	return sd;
 }
 
-extern SDIOH_API_RC sdioh_detach(sdioh_info_t *sd)
+extern SDIOH_API_RC brcmf_sdioh_detach(sdioh_info_t *sd)
 {
 	sd_trace(("%s\n", __func__));
 
@@ -184,7 +184,7 @@ extern SDIOH_API_RC sdioh_detach(sdioh_info_t *sd)
 		sdio_release_host(gInstance->func[1]);
 
 		/* deregister irq */
-		sdioh_sdmmc_osfree(sd);
+		brcmf_sdioh_osfree(sd);
 
 		kfree(sd);
 	}
@@ -193,7 +193,7 @@ extern SDIOH_API_RC sdioh_detach(sdioh_info_t *sd)
 
 #if defined(OOB_INTR_ONLY) && defined(HW_OOB)
 
-extern SDIOH_API_RC sdioh_enable_func_intr(void)
+extern SDIOH_API_RC brcmf_sdioh_enable_func_intr(void)
 {
 	u8 reg;
 	int err;
@@ -227,7 +227,7 @@ extern SDIOH_API_RC sdioh_enable_func_intr(void)
 	return SDIOH_API_RC_SUCCESS;
 }
 
-extern SDIOH_API_RC sdioh_disable_func_intr(void)
+extern SDIOH_API_RC brcmf_sdioh_disable_func_intr(void)
 {
 	u8 reg;
 	int err;
@@ -261,7 +261,7 @@ extern SDIOH_API_RC sdioh_disable_func_intr(void)
 
 /* Configure callback to client when we receive client interrupt */
 extern SDIOH_API_RC
-sdioh_interrupt_register(sdioh_info_t *sd, sdioh_cb_fn_t fn, void *argh)
+brcmf_sdioh_interrupt_register(sdioh_info_t *sd, sdioh_cb_fn_t fn, void *argh)
 {
 	sd_trace(("%s: Entering\n", __func__));
 	if (fn == NULL) {
@@ -277,22 +277,22 @@ sdioh_interrupt_register(sdioh_info_t *sd, sdioh_cb_fn_t fn, void *argh)
 	/* register and unmask irq */
 	if (gInstance->func[2]) {
 		sdio_claim_host(gInstance->func[2]);
-		sdio_claim_irq(gInstance->func[2], IRQHandlerF2);
+		sdio_claim_irq(gInstance->func[2], brcmf_sdioh_irqhandler_f2);
 		sdio_release_host(gInstance->func[2]);
 	}
 
 	if (gInstance->func[1]) {
 		sdio_claim_host(gInstance->func[1]);
-		sdio_claim_irq(gInstance->func[1], IRQHandler);
+		sdio_claim_irq(gInstance->func[1], brcmf_sdioh_irqhandler);
 		sdio_release_host(gInstance->func[1]);
 	}
 #elif defined(HW_OOB)
-	sdioh_enable_func_intr();
+	brcmf_sdioh_enable_func_intr();
 #endif				/* defined(OOB_INTR_ONLY) */
 	return SDIOH_API_RC_SUCCESS;
 }
 
-extern SDIOH_API_RC sdioh_interrupt_deregister(sdioh_info_t *sd)
+extern SDIOH_API_RC brcmf_sdioh_interrupt_deregister(sdioh_info_t *sd)
 {
 	sd_trace(("%s: Entering\n", __func__));
 
@@ -316,12 +316,12 @@ extern SDIOH_API_RC sdioh_interrupt_deregister(sdioh_info_t *sd)
 	sd->intr_handler = NULL;
 	sd->intr_handler_arg = NULL;
 #elif defined(HW_OOB)
-	sdioh_disable_func_intr();
+	brcmf_sdioh_disable_func_intr();
 #endif				/*  !defined(OOB_INTR_ONLY) */
 	return SDIOH_API_RC_SUCCESS;
 }
 
-extern SDIOH_API_RC sdioh_interrupt_query(sdioh_info_t *sd, bool *onoff)
+extern SDIOH_API_RC brcmf_sdioh_interrupt_query(sdioh_info_t *sd, bool *onoff)
 {
 	sd_trace(("%s: Entering\n", __func__));
 	*onoff = sd->client_intr_enabled;
@@ -329,13 +329,13 @@ extern SDIOH_API_RC sdioh_interrupt_query(sdioh_info_t *sd, bool *onoff)
 }
 
 #if defined(DHD_DEBUG)
-extern bool sdioh_interrupt_pending(sdioh_info_t *sd)
+extern bool brcmf_sdioh_interrupt_pending(sdioh_info_t *sd)
 {
 	return 0;
 }
 #endif
 
-uint sdioh_query_iofnum(sdioh_info_t *sd)
+uint brcmf_sdioh_query_iofnum(sdioh_info_t *sd)
 {
 	return sd->num_funcs;
 }
@@ -365,8 +365,8 @@ const struct brcmu_iovar sdioh_iovars[] = {
 };
 
 int
-sdioh_iovar_op(sdioh_info_t *si, const char *name,
-	       void *params, int plen, void *arg, int len, bool set)
+brcmf_sdioh_iovar_op(sdioh_info_t *si, const char *name,
+		     void *params, int plen, void *arg, int len, bool set)
 {
 	const struct brcmu_iovar *vi = NULL;
 	int bcmerror = 0;
@@ -499,7 +499,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 			sdreg_t *sd_ptr = (sdreg_t *) params;
 			u8 data = 0;
 
-			if (sdioh_cfg_read
+			if (brcmf_sdioh_cfg_read
 			    (si, sd_ptr->func, sd_ptr->offset, &data)) {
 				bcmerror = -EIO;
 				break;
@@ -515,7 +515,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 			sdreg_t *sd_ptr = (sdreg_t *) params;
 			u8 data = (u8) sd_ptr->value;
 
-			if (sdioh_cfg_write
+			if (brcmf_sdioh_cfg_write
 			    (si, sd_ptr->func, sd_ptr->offset, &data)) {
 				bcmerror = -EIO;
 				break;
@@ -534,7 +534,7 @@ exit:
 
 #if defined(OOB_INTR_ONLY) && defined(HW_OOB)
 
-SDIOH_API_RC sdioh_enable_hw_oob_intr(sdioh_info_t *sd, bool enable)
+SDIOH_API_RC brcmf_sdioh_enable_hw_oob_intr(sdioh_info_t *sd, bool enable)
 {
 	SDIOH_API_RC status;
 	u8 data;
@@ -545,37 +545,37 @@ SDIOH_API_RC sdioh_enable_hw_oob_intr(sdioh_info_t *sd, bool enable)
 		data = 4;	/* disable hw oob interrupt */
 	data |= 4;		/* Active HIGH */
 
-	status = sdioh_request_byte(sd, SDIOH_WRITE, 0, 0xf2, &data);
+	status = brcmf_sdioh_request_byte(sd, SDIOH_WRITE, 0, 0xf2, &data);
 	return status;
 }
 #endif				/* defined(OOB_INTR_ONLY) && defined(HW_OOB) */
 
 extern SDIOH_API_RC
-sdioh_cfg_read(sdioh_info_t *sd, uint fnc_num, u32 addr, u8 *data)
+brcmf_sdioh_cfg_read(sdioh_info_t *sd, uint fnc_num, u32 addr, u8 *data)
 {
 	SDIOH_API_RC status;
-	/* No lock needed since sdioh_request_byte does locking */
-	status = sdioh_request_byte(sd, SDIOH_READ, fnc_num, addr, data);
+	/* No lock needed since brcmf_sdioh_request_byte does locking */
+	status = brcmf_sdioh_request_byte(sd, SDIOH_READ, fnc_num, addr, data);
 	return status;
 }
 
 extern SDIOH_API_RC
-sdioh_cfg_write(sdioh_info_t *sd, uint fnc_num, u32 addr, u8 *data)
+brcmf_sdioh_cfg_write(sdioh_info_t *sd, uint fnc_num, u32 addr, u8 *data)
 {
-	/* No lock needed since sdioh_request_byte does locking */
+	/* No lock needed since brcmf_sdioh_request_byte does locking */
 	SDIOH_API_RC status;
-	status = sdioh_request_byte(sd, SDIOH_WRITE, fnc_num, addr, data);
+	status = brcmf_sdioh_request_byte(sd, SDIOH_WRITE, fnc_num, addr, data);
 	return status;
 }
 
-static int sdioh_sdmmc_get_cisaddr(sdioh_info_t *sd, u32 regaddr)
+static int brcmf_sdioh_get_cisaddr(sdioh_info_t *sd, u32 regaddr)
 {
 	/* read 24 bits and return valid 17 bit addr */
 	int i;
 	u32 scratch, regdata;
 	u8 *ptr = (u8 *)&scratch;
 	for (i = 0; i < 3; i++) {
-		if ((sdioh_sdmmc_card_regread(sd, 0, regaddr, 1, &regdata)) !=
+		if ((brcmf_sdioh_card_regread(sd, 0, regaddr, 1, &regdata)) !=
 		    SUCCESS)
 			sd_err(("%s: Can't read!\n", __func__));
 
@@ -590,7 +590,7 @@ static int sdioh_sdmmc_get_cisaddr(sdioh_info_t *sd, u32 regaddr)
 }
 
 extern SDIOH_API_RC
-sdioh_cis_read(sdioh_info_t *sd, uint func, u8 *cisd, u32 length)
+brcmf_sdioh_cis_read(sdioh_info_t *sd, uint func, u8 *cisd, u32 length)
 {
 	u32 count;
 	int offset;
@@ -610,7 +610,7 @@ sdioh_cis_read(sdioh_info_t *sd, uint func, u8 *cisd, u32 length)
 
 	for (count = 0; count < length; count++) {
 		offset = sd->func_cis_ptr[func] + count;
-		if (sdioh_sdmmc_card_regread(sd, 0, offset, 1, &foo) < 0) {
+		if (brcmf_sdioh_card_regread(sd, 0, offset, 1, &foo) < 0) {
 			sd_err(("%s: regread failed: Can't read CIS\n",
 				__func__));
 			return SDIOH_API_RC_FAIL;
@@ -624,7 +624,7 @@ sdioh_cis_read(sdioh_info_t *sd, uint func, u8 *cisd, u32 length)
 }
 
 extern SDIOH_API_RC
-sdioh_request_byte(sdioh_info_t *sd, uint rw, uint func, uint regaddr,
+brcmf_sdioh_request_byte(sdioh_info_t *sd, uint rw, uint func, uint regaddr,
 		   u8 *byte)
 {
 	int err_ret;
@@ -723,7 +723,7 @@ sdioh_request_byte(sdioh_info_t *sd, uint rw, uint func, uint regaddr,
 }
 
 extern SDIOH_API_RC
-sdioh_request_word(sdioh_info_t *sd, uint cmd_type, uint rw, uint func,
+brcmf_sdioh_request_word(sdioh_info_t *sd, uint cmd_type, uint rw, uint func,
 		   uint addr, u32 *word, uint nbytes)
 {
 	int err_ret = SDIOH_API_RC_FAIL;
@@ -776,8 +776,8 @@ sdioh_request_word(sdioh_info_t *sd, uint cmd_type, uint rw, uint func,
 }
 
 static SDIOH_API_RC
-sdioh_request_packet(sdioh_info_t *sd, uint fix_inc, uint write, uint func,
-		     uint addr, struct sk_buff *pkt)
+brcmf_sdioh_request_packet(sdioh_info_t *sd, uint fix_inc, uint write,
+			   uint func, uint addr, struct sk_buff *pkt)
 {
 	bool fifo = (fix_inc == SDIOH_DATA_FIX);
 	u32 SGCount = 0;
@@ -807,7 +807,7 @@ sdioh_request_packet(sdioh_info_t *sd, uint fix_inc, uint write, uint func,
 #endif				/* CONFIG_MMC_MSM7X00A */
 		/* Make sure the packet is aligned properly.
 		 * If it isn't, then this
-		 * is the fault of sdioh_request_buffer() which
+		 * is the fault of brcmf_sdioh_request_buffer() which
 		 * is supposed to give
 		 * us something we can work with.
 		 */
@@ -872,9 +872,9 @@ sdioh_request_packet(sdioh_info_t *sd, uint fix_inc, uint write, uint func,
  *
  */
 extern SDIOH_API_RC
-sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
-		     uint func, uint addr, uint reg_width, uint buflen_u,
-		     u8 *buffer, struct sk_buff *pkt)
+brcmf_sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc,
+			   uint write, uint func, uint addr, uint reg_width,
+			   uint buflen_u, u8 *buffer, struct sk_buff *pkt)
 {
 	SDIOH_API_RC Status;
 	struct sk_buff *mypkt = NULL;
@@ -898,8 +898,8 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 		if (write)
 			memcpy(mypkt->data, buffer, buflen_u);
 
-		Status =
-		    sdioh_request_packet(sd, fix_inc, write, func, addr, mypkt);
+		Status = brcmf_sdioh_request_packet(sd, fix_inc, write, func,
+						    addr, mypkt);
 
 		/* For a read, copy the packet data back to the buffer. */
 		if (!write)
@@ -925,8 +925,8 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 		if (write)
 			memcpy(mypkt->data, pkt->data, pkt->len);
 
-		Status =
-		    sdioh_request_packet(sd, fix_inc, write, func, addr, mypkt);
+		Status = brcmf_sdioh_request_packet(sd, fix_inc, write, func,
+						    addr, mypkt);
 
 		/* For a read, copy the packet data back to the buffer. */
 		if (!write)
@@ -937,15 +937,15 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 				 it is aligned. */
 		sd_data(("%s: Aligned %s Packet, direct DMA\n",
 			 __func__, write ? "Tx" : "Rx"));
-		Status =
-		    sdioh_request_packet(sd, fix_inc, write, func, addr, pkt);
+		Status = brcmf_sdioh_request_packet(sd, fix_inc, write, func,
+						    addr, pkt);
 	}
 
 	return Status;
 }
 
 /* this function performs "abort" for both of host & device */
-extern int sdioh_abort(sdioh_info_t *sd, uint func)
+extern int brcmf_sdioh_abort(sdioh_info_t *sd, uint func)
 {
 #if defined(MMC_SDIO_ABORT)
 	char t_func = (char)func;
@@ -954,7 +954,7 @@ extern int sdioh_abort(sdioh_info_t *sd, uint func)
 
 #if defined(MMC_SDIO_ABORT)
 	/* issue abort cmd52 command through F0 */
-	sdioh_request_byte(sd, SDIOH_WRITE, SDIO_FUNC_0, SDIO_CCCR_ABORT,
+	brcmf_sdioh_request_byte(sd, SDIOH_WRITE, SDIO_FUNC_0, SDIO_CCCR_ABORT,
 			   &t_func);
 #endif				/* defined(MMC_SDIO_ABORT) */
 
@@ -963,7 +963,7 @@ extern int sdioh_abort(sdioh_info_t *sd, uint func)
 }
 
 /* Reset and re-initialize the device */
-int sdioh_sdio_reset(sdioh_info_t *si)
+int brcmf_sdioh_reset(sdioh_info_t *si)
 {
 	sd_trace(("%s: Enter\n", __func__));
 	sd_trace(("%s: Exit\n", __func__));
@@ -971,14 +971,14 @@ int sdioh_sdio_reset(sdioh_info_t *si)
 }
 
 /* Disable device interrupt */
-void sdioh_sdmmc_devintr_off(sdioh_info_t *sd)
+void brcmf_sdioh_dev_intr_off(sdioh_info_t *sd)
 {
 	sd_trace(("%s: %d\n", __func__, sd->use_client_ints));
 	sd->intmask &= ~CLIENT_INTR;
 }
 
 /* Enable device interrupt */
-void sdioh_sdmmc_devintr_on(sdioh_info_t *sd)
+void brcmf_sdioh_dev_intr_on(sdioh_info_t *sd)
 {
 	sd_trace(("%s: %d\n", __func__, sd->use_client_ints));
 	sd->intmask |= CLIENT_INTR;
@@ -986,19 +986,19 @@ void sdioh_sdmmc_devintr_on(sdioh_info_t *sd)
 
 /* Read client card reg */
 int
-sdioh_sdmmc_card_regread(sdioh_info_t *sd, int func, u32 regaddr,
+brcmf_sdioh_card_regread(sdioh_info_t *sd, int func, u32 regaddr,
 			 int regsize, u32 *data)
 {
 
 	if ((func == 0) || (regsize == 1)) {
 		u8 temp = 0;
 
-		sdioh_request_byte(sd, SDIOH_READ, func, regaddr, &temp);
+		brcmf_sdioh_request_byte(sd, SDIOH_READ, func, regaddr, &temp);
 		*data = temp;
 		*data &= 0xff;
 		sd_data(("%s: byte read data=0x%02x\n", __func__, *data));
 	} else {
-		sdioh_request_word(sd, 0, SDIOH_READ, func, regaddr, data,
+		brcmf_sdioh_request_word(sd, 0, SDIOH_READ, func, regaddr, data,
 				   regsize);
 		if (regsize == 2)
 			*data &= 0xffff;
@@ -1011,7 +1011,7 @@ sdioh_sdmmc_card_regread(sdioh_info_t *sd, int func, u32 regaddr,
 
 #if !defined(OOB_INTR_ONLY)
 /* bcmsdh_sdmmc interrupt handler */
-static void IRQHandler(struct sdio_func *func)
+static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
 	sdioh_info_t *sd;
 
@@ -1037,7 +1037,7 @@ static void IRQHandler(struct sdio_func *func)
 }
 
 /* bcmsdh_sdmmc interrupt handler for F2 (dummy handler) */
-static void IRQHandlerF2(struct sdio_func *func)
+static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func)
 {
 	sdioh_info_t *sd;
 
@@ -1052,7 +1052,7 @@ static void IRQHandlerF2(struct sdio_func *func)
 #ifdef NOTUSED
 /* Write client card reg */
 static int
-sdioh_sdmmc_card_regwrite(sdioh_info_t *sd, int func, u32 regaddr,
+brcmf_sdioh_card_regwrite(sdioh_info_t *sd, int func, u32 regaddr,
 			  int regsize, u32 data)
 {
 
@@ -1060,14 +1060,14 @@ sdioh_sdmmc_card_regwrite(sdioh_info_t *sd, int func, u32 regaddr,
 		u8 temp;
 
 		temp = data & 0xff;
-		sdioh_request_byte(sd, SDIOH_READ, func, regaddr, &temp);
+		brcmf_sdioh_request_byte(sd, SDIOH_READ, func, regaddr, &temp);
 		sd_data(("%s: byte write data=0x%02x\n", __func__, data));
 	} else {
 		if (regsize == 2)
 			data &= 0xffff;
 
-		sdioh_request_word(sd, 0, SDIOH_READ, func, regaddr, &data,
-				   regsize);
+		brcmf_sdioh_request_word(sd, 0, SDIOH_READ, func, regaddr,
+					 &data, regsize);
 
 		sd_data(("%s: word write data=0x%08x\n", __func__, data));
 	}
@@ -1076,12 +1076,12 @@ sdioh_sdmmc_card_regwrite(sdioh_info_t *sd, int func, u32 regaddr,
 }
 #endif				/* NOTUSED */
 
-int sdioh_start(sdioh_info_t *si, int stage)
+int brcmf_sdioh_start(sdioh_info_t *si, int stage)
 {
 	return 0;
 }
 
-int sdioh_stop(sdioh_info_t *si)
+int brcmf_sdioh_stop(sdioh_info_t *si)
 {
 	return 0;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
index ff5e09d..c7863b1 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
@@ -14,6 +14,10 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+/*
+ * BCMSDH Function Driver for the native SDIO/MMC driver in the Linux Kernel
+ */
+
 #ifndef __BCMSDH_SDMMC_H__
 #define __BCMSDH_SDMMC_H__
 
@@ -58,8 +62,8 @@
 #endif
 
 /* Allocate/init/free per-OS private data */
-extern int sdioh_sdmmc_osinit(sdioh_info_t *sd);
-extern void sdioh_sdmmc_osfree(sdioh_info_t *sd);
+extern int brcmf_sdioh_osinit(sdioh_info_t *sd);
+extern void brcmf_sdioh_osfree(sdioh_info_t *sd);
 
 #define BLOCK_SIZE_64 64
 #define BLOCK_SIZE_512 512
@@ -105,23 +109,23 @@ struct sdioh_info {
 extern uint sd_msglevel;
 
 /* OS-independent interrupt handler */
-extern bool check_client_intr(sdioh_info_t *sd);
+extern bool brcmf_sdioh_check_client_intr(sdioh_info_t *sd);
 
 /* Core interrupt enable/disable of device interrupts */
-extern void sdioh_sdmmc_devintr_on(sdioh_info_t *sd);
-extern void sdioh_sdmmc_devintr_off(sdioh_info_t *sd);
+extern void brcmf_sdioh_dev_intr_on(sdioh_info_t *sd);
+extern void brcmf_sdioh_dev_intr_off(sdioh_info_t *sd);
 
 /**************************************************************
  * Internal interfaces: bcmsdh_sdmmc.c references to per-port code
  */
 
 /* Register mapping routines */
-extern u32 *sdioh_sdmmc_reg_map(s32 addr, int size);
-extern void sdioh_sdmmc_reg_unmap(s32 addr, int size);
+extern u32 *brcmf_sdioh_reg_map(s32 addr, int size);
+extern void brcmf_sdioh_reg_unmap(s32 addr, int size);
 
 /* Interrupt (de)registration routines */
-extern int sdioh_sdmmc_register_irq(sdioh_info_t *sd, uint irq);
-extern void sdioh_sdmmc_free_irq(uint irq, sdioh_info_t *sd);
+extern int brcmf_sdioh_register_irq(sdioh_info_t *sd, uint irq);
+extern void brcmf_sdioh_free_irq(uint irq, sdioh_info_t *sd);
 
 typedef struct _BCMSDH_SDMMC_INSTANCE {
 	sdioh_info_t *sd;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 5f17b8f..8f13988 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -55,11 +55,11 @@
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
 
-extern void sdioh_sdmmc_devintr_off(sdioh_info_t *sd);
-extern void sdioh_sdmmc_devintr_on(sdioh_info_t *sd);
+extern void brcmf_sdioh_dev_intr_off(sdioh_info_t *sd);
+extern void brcmf_sdioh_dev_intr_on(sdioh_info_t *sd);
 
-int sdio_function_init(void);
-void sdio_function_cleanup(void);
+int brcmf_sdio_function_init(void);
+void brcmf_sdio_function_cleanup(void);
 
 /* module param defaults */
 static int clockoverride;
@@ -72,11 +72,11 @@ PBCMSDH_SDMMC_INSTANCE gInstance;
 /* Maximum number of bcmsdh_sdmmc devices supported by driver */
 #define BCMSDH_SDMMC_MAX_DEVICES 1
 
-extern int bcmsdh_probe(struct device *dev);
-extern int bcmsdh_remove(struct device *dev);
+extern int brcmf_sdio_probe(struct device *dev);
+extern int brcmf_sdio_remove(struct device *dev);
 struct device sdmmc_dev;
 
-static int bcmsdh_sdmmc_probe(struct sdio_func *func,
+static int brcmf_ops_sdio_probe(struct sdio_func *func,
 			      const struct sdio_device_id *id)
 {
 	int ret = 0;
@@ -93,8 +93,8 @@ static int bcmsdh_sdmmc_probe(struct sdio_func *func,
 		gInstance->func[0] = &sdio_func_0;
 		if (func->device == 0x4) {	/* 4318 */
 			gInstance->func[2] = NULL;
-			sd_trace(("NIC found, calling bcmsdh_probe...\n"));
-			ret = bcmsdh_probe(&sdmmc_dev);
+			sd_trace(("NIC found, calling brcmf_sdio_probe...\n"));
+			ret = brcmf_sdio_probe(&sdmmc_dev);
 		}
 	}
 
@@ -102,24 +102,24 @@ static int bcmsdh_sdmmc_probe(struct sdio_func *func,
 
 	if (func->num == 2) {
 		wl_cfg80211_sdio_func(func);
-		sd_trace(("F2 found, calling bcmsdh_probe...\n"));
-		ret = bcmsdh_probe(&sdmmc_dev);
+		sd_trace(("F2 found, calling brcmf_sdio_probe...\n"));
+		ret = brcmf_sdio_probe(&sdmmc_dev);
 	}
 
 	return ret;
 }
 
-static void bcmsdh_sdmmc_remove(struct sdio_func *func)
+static void brcmf_ops_sdio_remove(struct sdio_func *func)
 {
-	sd_trace(("bcmsdh_sdmmc: %s Enter\n", __func__));
-	sd_info(("sdio_bcmsdh: func->class=%x\n", func->class));
+	sd_trace(("%s Enter\n", __func__));
+	sd_info(("func->class=%x\n", func->class));
 	sd_info(("sdio_vendor: 0x%04x\n", func->vendor));
 	sd_info(("sdio_device: 0x%04x\n", func->device));
 	sd_info(("Function#: 0x%04x\n", func->num));
 
 	if (func->num == 2) {
-		sd_trace(("F2 found, calling bcmsdh_remove...\n"));
-		bcmsdh_remove(&sdmmc_dev);
+		sd_trace(("F2 found, calling brcmf_sdio_remove...\n"));
+		brcmf_sdio_remove(&sdmmc_dev);
 	}
 }
 
@@ -137,8 +137,8 @@ static const struct sdio_device_id bcmsdh_sdmmc_ids[] = {
 MODULE_DEVICE_TABLE(sdio, bcmsdh_sdmmc_ids);
 
 static struct sdio_driver bcmsdh_sdmmc_driver = {
-	.probe = bcmsdh_sdmmc_probe,
-	.remove = bcmsdh_sdmmc_remove,
+	.probe = brcmf_ops_sdio_probe,
+	.remove = brcmf_ops_sdio_remove,
 	.name = "brcmfmac",
 	.id_table = bcmsdh_sdmmc_ids,
 };
@@ -148,7 +148,7 @@ struct sdos_info {
 	spinlock_t lock;
 };
 
-int sdioh_sdmmc_osinit(sdioh_info_t *sd)
+int brcmf_sdioh_osinit(sdioh_info_t *sd)
 {
 	struct sdos_info *sdos;
 
@@ -162,7 +162,7 @@ int sdioh_sdmmc_osinit(sdioh_info_t *sd)
 	return 0;
 }
 
-void sdioh_sdmmc_osfree(sdioh_info_t *sd)
+void brcmf_sdioh_osfree(sdioh_info_t *sd)
 {
 	struct sdos_info *sdos;
 	ASSERT(sd && sd->sdos_info);
@@ -172,7 +172,7 @@ void sdioh_sdmmc_osfree(sdioh_info_t *sd)
 }
 
 /* Interrupt enable/disable */
-SDIOH_API_RC sdioh_interrupt_set(sdioh_info_t *sd, bool enable)
+SDIOH_API_RC brcmf_sdioh_interrupt_set(sdioh_info_t *sd, bool enable)
 {
 	unsigned long flags;
 	struct sdos_info *sdos;
@@ -195,9 +195,9 @@ SDIOH_API_RC sdioh_interrupt_set(sdioh_info_t *sd, bool enable)
 
 	sd->client_intr_enabled = enable;
 	if (enable)
-		sdioh_sdmmc_devintr_on(sd);
+		brcmf_sdioh_dev_intr_on(sd);
 	else
-		sdioh_sdmmc_devintr_off(sd);
+		brcmf_sdioh_dev_intr_off(sd);
 
 	spin_unlock_irqrestore(&sdos->lock, flags);
 
@@ -207,7 +207,7 @@ SDIOH_API_RC sdioh_interrupt_set(sdioh_info_t *sd, bool enable)
 /*
  * module init
 */
-int sdio_function_init(void)
+int brcmf_sdio_function_init(void)
 {
 	int error = 0;
 	sd_trace(("bcmsdh_sdmmc: %s Enter\n", __func__));
@@ -225,8 +225,8 @@ int sdio_function_init(void)
 /*
  * module cleanup
 */
-extern int bcmsdh_remove(struct device *dev);
-void sdio_function_cleanup(void)
+extern int brcmf_sdio_remove(struct device *dev);
+void brcmf_sdio_function_cleanup(void)
 {
 	sd_trace(("%s Enter\n", __func__));
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index b1bb04f..128a00d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -30,26 +30,30 @@ extern bool dhd_bus_download_firmware(struct dhd_bus *bus,
 				      char *fw_path, char *nv_path);
 
 /* Stop bus module: clear pending frames, disable data flow */
-extern void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex);
+extern void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex);
 
 /* Initialize bus module: prepare for communication w/dongle */
-extern int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex);
+extern int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex);
 
 /* Send a data frame to the dongle.  Callee disposes of txp. */
-extern int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *txp);
+extern int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *txp);
 
 /* Send/receive a control message to/from the dongle.
  * Expects caller to enforce a single outstanding transaction.
  */
-extern int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
-extern int dhd_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
+extern int
+brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
+
+extern int
+brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
 
 /* Watchdog timer function */
-extern bool dhd_bus_watchdog(dhd_pub_t *dhd);
+extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhd);
 
 #ifdef DHD_DEBUG
 /* Device console input function */
-extern int dhd_bus_console_in(dhd_pub_t *dhd, unsigned char *msg, uint msglen);
+extern int
+brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhd, unsigned char *msg, uint msglen);
 #endif				/* DHD_DEBUG */
 
 /* Deferred processing for the bus, return true requests reschedule */
@@ -58,12 +62,12 @@ extern void dhd_bus_isr(bool *InterruptRecognized,
 			bool *QueueMiniportHandleInterrupt, void *arg);
 
 /* Check for and handle local prot-specific iovar commands */
-extern int dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
+extern int brcmf_sdbrcm_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 			    void *params, int plen, void *arg, int len,
 			    bool set);
 
 /* Add bus dump output to a buffer */
-extern void dhd_bus_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf);
+extern void brcmf_sdbrcm_bus_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf);
 
 /* Clear any bus counters */
 extern void dhd_bus_clearcounts(dhd_pub_t *dhdp);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index bf3fe99..c77c86c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -129,7 +129,8 @@ static int dhdcdc_msg(dhd_pub_t *dhd)
 		len = CDC_MAX_MSG_SIZE;
 
 	/* Send request */
-	return dhd_bus_txctl(dhd->bus, (unsigned char *)&prot->msg, len);
+	return brcmf_sdbrcm_bus_txctl(dhd->bus, (unsigned char *)&prot->msg,
+				      len);
 }
 
 static int dhdcdc_cmplt(dhd_pub_t *dhd, u32 id, u32 len)
@@ -140,9 +141,9 @@ static int dhdcdc_cmplt(dhd_pub_t *dhd, u32 id, u32 len)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	do {
-		ret =
-		    dhd_bus_rxctl(dhd->bus, (unsigned char *)&prot->msg,
-				  len + sizeof(struct cdc_ioctl));
+		ret = brcmf_sdbrcm_bus_rxctl(dhd->bus,
+					     (unsigned char *)&prot->msg,
+					     len + sizeof(struct cdc_ioctl));
 		if (ret < 0)
 			break;
 	} while (CDC_IOC_ID(le32_to_cpu(prot->msg.flags)) != id);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 0a5a1a4..34bd5e9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -210,7 +210,7 @@ static int dhd_dump(dhd_pub_t *dhdp, char *buf, int buflen)
 	brcmu_bprintf(strbuf, "\n");
 
 	/* Add any bus info */
-	dhd_bus_dump(dhdp, strbuf);
+	brcmf_sdbrcm_bus_dump(dhdp, strbuf);
 
 	return !strbuf->size ? -EOVERFLOW : 0;
 }
@@ -287,7 +287,8 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_CONS):
 		if (len > 0)
-			bcmerror = dhd_bus_console_in(dhd_pub, arg, len - 1);
+			bcmerror = brcmf_sdbrcm_bus_console_in(dhd_pub, arg,
+							       len - 1);
 		break;
 #endif
 
@@ -504,13 +505,13 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 
 			/* if still not found, try bus module */
 			if (ioc->cmd == DHD_GET_VAR)
-				bcmerror = dhd_bus_iovar_op(dhd_pub, buf,
-							    arg, arglen, buf,
-							    buflen, IOV_GET);
+				bcmerror = brcmf_sdbrcm_bus_iovar_op(dhd_pub,
+						buf, arg, arglen, buf, buflen,
+						IOV_GET);
 			else
-				bcmerror = dhd_bus_iovar_op(dhd_pub, buf,
-							    NULL, 0, arg,
-							    arglen, IOV_SET);
+				bcmerror = brcmf_sdbrcm_bus_iovar_op(dhd_pub,
+						buf, NULL, 0, arg, arglen,
+						IOV_SET);
 
 			break;
 		}
@@ -1168,7 +1169,8 @@ void dhd_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
 	int retcode;
 
 	brcmu_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
-	retcode = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	retcode = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
+				       sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
 		DHD_TRACE(("%s: failed to set ARP offload mode to 0x%x, "
@@ -1184,7 +1186,8 @@ void dhd_arp_offload_enable(dhd_pub_t *dhd, int arp_enable)
 	int retcode;
 
 	brcmu_mkiovar("arpoe", (char *)&arp_enable, 4, iovbuf, sizeof(iovbuf));
-	retcode = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	retcode = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
+				       sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
 		DHD_TRACE(("%s: failed to enabe ARP offload to %d, "
@@ -1224,7 +1227,8 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 	if (!ret) {
 		brcmu_mkiovar("cur_etheraddr", (void *)ea_addr, ETH_ALEN,
 			    buf, sizeof(buf));
-		ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, sizeof(buf));
+		ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf,
+					   sizeof(buf));
 		if (ret < 0) {
 			DHD_ERROR(("%s: can't set MAC address , error=%d\n",
 				   __func__, ret));
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 48859cd..f80295e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -175,7 +175,7 @@ DECLARE_WAIT_QUEUE_HEAD(dhd_dpc_wait);
 #endif	/*  defined(CONFIG_PM_SLEEP) */
 
 #if defined(OOB_INTR_ONLY)
-extern void dhd_enable_oob_intr(struct dhd_bus *bus, bool enable);
+extern void brcmf_sdbrcm_enable_oob_intr(struct dhd_bus *bus, bool enable);
 #endif	/* defined(OOB_INTR_ONLY) */
 
 MODULE_AUTHOR("Broadcom Corporation");
@@ -995,7 +995,7 @@ int dhd_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 #ifdef BCMDBUS
 	ret = dbus_send_pkt(dhdp->dbus, pktbuf, NULL /* pktinfo */);
 #else
-	ret = dhd_bus_txdata(dhdp->bus, pktbuf);
+	ret = brcmf_sdbrcm_bus_txdata(dhdp->bus, pktbuf);
 #endif				/* BCMDBUS */
 
 	return ret;
@@ -1264,7 +1264,7 @@ static int dhd_watchdog_thread(void *data)
 		if (down_interruptible(&dhd->watchdog_sem) == 0) {
 			if (dhd->pub.dongle_reset == false) {
 				/* Call the bus module watchdog */
-				dhd_bus_watchdog(&dhd->pub);
+				brcmf_sdbrcm_bus_watchdog(&dhd->pub);
 			}
 			/* Count the tick for reference */
 			dhd->pub.tickcnt++;
@@ -1290,7 +1290,7 @@ static void dhd_watchdog(unsigned long data)
 	}
 
 	/* Call the bus module watchdog */
-	dhd_bus_watchdog(&dhd->pub);
+	brcmf_sdbrcm_bus_watchdog(&dhd->pub);
 
 	/* Count the tick for reference */
 	dhd->pub.tickcnt++;
@@ -1330,7 +1330,7 @@ static int dhd_dpc_thread(void *data)
 					up(&dhd->dpc_sem);
 				}
 			} else {
-				dhd_bus_stop(dhd->pub.bus, true);
+				brcmf_sdbrcm_bus_stop(dhd->pub.bus, true);
 			}
 		} else
 			break;
@@ -1349,7 +1349,7 @@ static void dhd_dpc(unsigned long data)
 		if (dhd_bus_dpc(dhd->pub.bus))
 			tasklet_schedule(&dhd->tasklet);
 	} else {
-		dhd_bus_stop(dhd->pub.bus, true);
+		brcmf_sdbrcm_bus_stop(dhd->pub.bus, true);
 	}
 }
 
@@ -1990,7 +1990,7 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 	if (dhd->pub.busstate == DHD_BUS_DOWN) {
 		if (!(dhd_bus_download_firmware(dhd->pub.bus,
 						fw_path, nv_path))) {
-			DHD_ERROR(("%s: dhdsdio_probe_download failed. "
+			DHD_ERROR(("%s: dhd_bus_download_firmware failed. "
 				"firmware = %s nvram = %s\n",
 				__func__, fw_path, nv_path));
 			return -1;
@@ -2002,14 +2002,15 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 	dhd_os_wd_timer(&dhd->pub, dhd_watchdog_ms);
 
 	/* Bring up the bus */
-	ret = dhd_bus_init(&dhd->pub, true);
+	ret = brcmf_sdbrcm_bus_init(&dhd->pub, true);
 	if (ret != 0) {
-		DHD_ERROR(("%s, dhd_bus_init failed %d\n", __func__, ret));
+		DHD_ERROR(("%s, brcmf_sdbrcm_bus_init failed %d\n", __func__,
+			   ret));
 		return ret;
 	}
 #if defined(OOB_INTR_ONLY)
 	/* Host registration for OOB interrupt */
-	if (bcmsdh_register_oob_intr(dhdp)) {
+	if (brcmf_sdio_register_oob_intr(dhdp)) {
 		del_timer_sync(&dhd->timer);
 		dhd->wd_timer_valid = false;
 		DHD_ERROR(("%s Host failed to resgister for OOB\n", __func__));
@@ -2017,7 +2018,7 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 	}
 
 	/* Enable oob at firmware */
-	dhd_enable_oob_intr(dhd->pub.bus, true);
+	brcmf_sdbrcm_enable_oob_intr(dhd->pub.bus, true);
 #endif				/* defined(OOB_INTR_ONLY) */
 
 	/* If bus is not ready, can't come up */
@@ -2173,9 +2174,9 @@ void dhd_bus_detach(dhd_pub_t *dhdp)
 			dhd_prot_stop(&dhd->pub);
 
 			/* Stop the bus module */
-			dhd_bus_stop(dhd->pub.bus, true);
+			brcmf_sdbrcm_bus_stop(dhd->pub.bus, true);
 #if defined(OOB_INTR_ONLY)
-			bcmsdh_unregister_oob_intr();
+			brcmf_sdio_unregister_oob_intr();
 #endif				/* defined(OOB_INTR_ONLY) */
 
 			/* Clear the watchdog timer */
@@ -2305,7 +2306,7 @@ static int __init dhd_module_init(void)
 	error = dhd_bus_register();
 
 	if (error) {
-		DHD_ERROR(("%s: sdio_register_driver failed\n", __func__));
+		DHD_ERROR(("%s: dhd_bus_register failed\n", __func__));
 		goto failed;
 	}
 	return error;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 7e4dfde..e253cb5 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -33,13 +33,13 @@
 #ifndef __BIG_ENDIAN
 #ifndef __mips__
 #define R_REG(r) \
-	bcmsdh_reg_read(NULL, (unsigned long)(r), sizeof(*(r)))
+	brcmf_sdcard_reg_read(NULL, (unsigned long)(r), sizeof(*(r)))
 #else				/* __mips__ */
 #define R_REG(r) \
 	({ \
 		__typeof(*(r)) __osl_v; \
 		__asm__ __volatile__("sync"); \
-		__osl_v = bcmsdh_reg_read(NULL, (unsigned long)(r),\
+		__osl_v = brcmf_sdcard_reg_read(NULL, (unsigned long)(r),\
 					  sizeof(*(r))); \
 		__asm__ __volatile__("sync"); \
 		__osl_v; \
@@ -47,13 +47,15 @@
 #endif				/* __mips__ */
 
 #define W_REG(r, v) do { \
-		bcmsdh_reg_write(NULL, (unsigned long)(r), sizeof(*(r)), (v)); \
+		brcmf_sdcard_reg_write(NULL, (unsigned long)(r), sizeof(*(r)), \
+				       (v)); \
 	} while (0)
 #else				/* __BIG_ENDIAN */
 #define R_REG(r) \
-	bcmsdh_reg_read(NULL, (unsigned long)(r), sizeof(*(r)))
+	brcmf_sdcard_reg_read(NULL, (unsigned long)(r), sizeof(*(r)))
 #define W_REG(r, v) do { \
-		bcmsdh_reg_write(NULL, (unsigned long)(r), sizeof(*(r)), (v)); \
+		brcmf_sdcard_reg_write(NULL, (unsigned long)(r), sizeof(*(r)), \
+				       (v)); \
 	} while (0)
 #endif				/* __BIG_ENDIAN */
 
@@ -479,7 +481,7 @@ typedef struct dhd_bus {
 	bool dpc_sched;		/* Indicates DPC schedule (intrpt rcvd) */
 	bool fcstate;		/* State of dongle flow-control */
 
-	u16 cl_devid;	/* cached devid for dhdsdio_probe_attach() */
+	u16 cl_devid;	/* cached devid for brcmf_sdio_probe_attach() */
 	char *fw_path;		/* module_param: path to firmware image */
 	char *nv_path;		/* module_param: path to nvram vars file */
 	const char *nvram_params;	/* user specified nvram params. */
@@ -685,7 +687,7 @@ static bool forcealign;
 #define ALIGNMENT  4
 
 #if defined(OOB_INTR_ONLY) && defined(HW_OOB)
-extern void bcmsdh_enable_hw_oob_intr(void *sdh, bool enable);
+extern void brcmf_sdcard_enable_hw_oob_intr(void *sdh, bool enable);
 #endif
 
 #if defined(OOB_INTR_ONLY) && defined(SDIO_ISR_THREAD)
@@ -721,7 +723,8 @@ do { \
 	retryvar = 0; \
 	do { \
 		regvar = R_REG(regaddr); \
-	} while (bcmsdh_regfail(bus->sdh) && (++retryvar <= retry_limit)); \
+	} while (brcmf_sdcard_regfail(bus->sdh) && \
+		 (++retryvar <= retry_limit)); \
 	if (retryvar) { \
 		bus->regfails += (retryvar-1); \
 		if (retryvar > retry_limit) { \
@@ -737,7 +740,8 @@ do { \
 	retryvar = 0; \
 	do { \
 		W_REG(regaddr, regval); \
-	} while (bcmsdh_regfail(bus->sdh) && (++retryvar <= retry_limit)); \
+	} while (brcmf_sdcard_regfail(bus->sdh) && \
+		 (++retryvar <= retry_limit)); \
 	if (retryvar) { \
 		bus->regfails += (retryvar-1); \
 		if (retryvar > retry_limit) \
@@ -753,56 +757,57 @@ do { \
 #define HOSTINTMASK		(I_HMB_SW_MASK | I_CHIPACTIVE)
 
 #ifdef SDTEST
-static void dhdsdio_testrcv(dhd_bus_t *bus, void *pkt, uint seq);
-static void dhdsdio_sdtest_set(dhd_bus_t *bus, bool start);
+static void brcmf_sdbrcm_checkdied(dhd_bus_t *bus, void *pkt, uint seq);
+static void brcmf_sdbrcm_sdtest_set(dhd_bus_t *bus, bool start);
 #endif
 
 #ifdef DHD_DEBUG
-static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size);
-static int dhdsdio_mem_dump(dhd_bus_t *bus);
+static int brcmf_sdbrcm_checkdied(dhd_bus_t *bus, u8 *data, uint size);
+static int brcmf_sdbrcm_mem_dump(dhd_bus_t *bus);
 #endif				/* DHD_DEBUG  */
-static int dhdsdio_download_state(dhd_bus_t *bus, bool enter);
+static int brcmf_sdbrcm_download_state(dhd_bus_t *bus, bool enter);
 
-static void dhdsdio_release(dhd_bus_t *bus);
-static void dhdsdio_release_malloc(dhd_bus_t *bus);
-static void dhdsdio_disconnect(void *ptr);
-static bool dhdsdio_chipmatch(u16 chipid);
-static bool dhdsdio_probe_attach(dhd_bus_t *bus, void *sdh,
+static void brcmf_sdbrcm_release(dhd_bus_t *bus);
+static void brcmf_sdbrcm_release_malloc(dhd_bus_t *bus);
+static void brcmf_sdbrcm_disconnect(void *ptr);
+static bool brcmf_sdbrcm_chipmatch(u16 chipid);
+static bool brcmf_sdbrcm_probe_attach(dhd_bus_t *bus, void *sdh,
 				 void *regsva, u16 devid);
-static bool dhdsdio_probe_malloc(dhd_bus_t *bus, void *sdh);
-static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh);
-static void dhdsdio_release_dongle(dhd_bus_t *bus);
+static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *sdh);
+static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh);
+static void brcmf_sdbrcm_release_dongle(dhd_bus_t *bus);
 
-static uint process_nvram_vars(char *varbuf, uint len);
+static uint brcmf_process_nvram_vars(char *varbuf, uint len);
 
-static void dhd_dongle_setmemsize(struct dhd_bus *bus, int mem_size);
-static int dhd_bcmsdh_send_buf(dhd_bus_t *bus, u32 addr, uint fn,
+static void brcmf_sdbrcm_setmemsize(struct dhd_bus *bus, int mem_size);
+static int brcmf_sdbrcm_send_buf(dhd_bus_t *bus, u32 addr, uint fn,
 			       uint flags, u8 *buf, uint nbytes,
 			       struct sk_buff *pkt, bcmsdh_cmplt_fn_t complete,
 			       void *handle);
 
-static bool dhdsdio_download_firmware(struct dhd_bus *bus, void *sdh);
-static int _dhdsdio_download_firmware(struct dhd_bus *bus);
+static bool brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *sdh);
+static int  _brcmf_sdbrcm_download_firmware(struct dhd_bus *bus);
 
-static int dhdsdio_download_code_file(struct dhd_bus *bus, char *image_path);
-static int dhdsdio_download_nvram(struct dhd_bus *bus);
-static void dhdsdio_chip_disablecore(bcmsdh_info_t *sdh, u32 corebase);
-static int dhdsdio_chip_attach(struct dhd_bus *bus, void *regs);
-static void dhdsdio_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase);
-static void dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus,
+static int
+brcmf_sdbrcm_download_code_file(struct dhd_bus *bus, char *image_path);
+static int brcmf_sdbrcm_download_nvram(struct dhd_bus *bus);
+static void brcmf_sdbrcm_chip_disablecore(bcmsdh_info_t *sdh, u32 corebase);
+static int brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs);
+static void brcmf_sdbrcm_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase);
+static void brcmf_sdbrcm_sdiod_drive_strength_init(struct dhd_bus *bus,
 					u32 drivestrength);
-static void dhdsdio_chip_detach(struct dhd_bus *bus);
+static void brcmf_sdbrcm_chip_detach(struct dhd_bus *bus);
 
 /* Packet free applicable unconditionally for sdio and sdspi.
  * Conditional if bufpool was present for gspi bus.
  */
-static void dhdsdio_pktfree2(dhd_bus_t *bus, struct sk_buff *pkt)
+static void brcmf_sdbrcm_pktfree2(dhd_bus_t *bus, struct sk_buff *pkt)
 {
 	if ((bus->bus != SPI_BUS) || bus->usebufpool)
 		brcmu_pkt_buf_free_skb(pkt);
 }
 
-static void dhd_dongle_setmemsize(struct dhd_bus *bus, int mem_size)
+static void brcmf_sdbrcm_setmemsize(struct dhd_bus *bus, int mem_size)
 {
 	s32 min_size = DONGLE_MIN_MEMSIZE;
 	/* Restrict the memsize to user specified limit */
@@ -813,23 +818,25 @@ static void dhd_dongle_setmemsize(struct dhd_bus *bus, int mem_size)
 		bus->ramsize = dhd_dongle_memsize;
 }
 
-static int dhdsdio_set_siaddr_window(dhd_bus_t *bus, u32 address)
+static int brcmf_sdbrcm_set_siaddr_window(dhd_bus_t *bus, u32 address)
 {
 	int err = 0;
-	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
+	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
 			 (address >> 8) & SBSDIO_SBADDRLOW_MASK, &err);
 	if (!err)
-		bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRMID,
+		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1,
+				 SBSDIO_FUNC1_SBADDRMID,
 				 (address >> 16) & SBSDIO_SBADDRMID_MASK, &err);
 	if (!err)
-		bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRHIGH,
-				 (address >> 24) & SBSDIO_SBADDRHIGH_MASK,
-				 &err);
+		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1,
+				       SBSDIO_FUNC1_SBADDRHIGH,
+				       (address >> 24) & SBSDIO_SBADDRHIGH_MASK,
+				       &err);
 	return err;
 }
 
 /* Turn backplane clock on or off */
-static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
+static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 {
 	int err;
 	u8 clkctl, clkreq, devctl;
@@ -852,8 +859,8 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		    && (bus->ci->chiprev == 0))
 			clkreq |= SBSDIO_FORCE_ALP;
 
-		bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-				 clkreq, &err);
+		brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+				       SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		if (err) {
 			DHD_ERROR(("%s: HT Avail request error: %d\n",
 				   __func__, err));
@@ -867,9 +874,8 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		}
 
 		/* Check current status */
-		clkctl =
-		    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-				    &err);
+		clkctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			DHD_ERROR(("%s: HT Avail read error: %d\n",
 				   __func__, err));
@@ -879,9 +885,8 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		/* Go to pending and await interrupt if appropriate */
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only) && pendok) {
 			/* Allow only clock-available interrupt */
-			devctl =
-			    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
-					    &err);
+			devctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+					SBSDIO_DEVICE_CTL, &err);
 			if (err) {
 				DHD_ERROR(("%s: Devctl error setting CA: %d\n",
 					__func__, err));
@@ -889,8 +894,8 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
-			bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
-					 devctl, &err);
+			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+					       SBSDIO_DEVICE_CTL, devctl, &err);
 			DHD_INFO(("CLKCTL: set PENDING\n"));
 			bus->clkstate = CLK_PENDING;
 
@@ -898,18 +903,18 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		} else if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
 			devctl =
-			    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
-					    &err);
+			    brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+						  SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
-					 devctl, &err);
+			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+				SBSDIO_DEVICE_CTL, devctl, &err);
 		}
 
 		/* Otherwise, wait here (polling) for HT Avail */
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
 			SPINWAIT_SLEEP(sdioh_spinwait_sleep,
 				       ((clkctl =
-					 bcmsdh_cfg_read(sdh, SDIO_FUNC_1,
+					 brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
 						 SBSDIO_FUNC1_CHIPCLKCSR,
 							 &err)),
 					!SBSDIO_CLKAV(clkctl, bus->alp_only)),
@@ -952,17 +957,16 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 
 		if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl =
-			    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
-					    &err);
+			devctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+					SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
-					 devctl, &err);
+			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+				SBSDIO_DEVICE_CTL, devctl, &err);
 		}
 
 		bus->clkstate = CLK_SDONLY;
-		bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-				 clkreq, &err);
+		brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+			SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		DHD_INFO(("CLKCTL: turned OFF\n"));
 		if (err) {
 			DHD_ERROR(("%s: Failed access turning clock off: %d\n",
@@ -974,7 +978,7 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 }
 
 /* Change idle/active SD state */
-static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
+static int brcmf_sdbrcm_sdclk(dhd_bus_t *bus, bool on)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -987,7 +991,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 }
 
 /* Transition SD and backplane clock readiness */
-static int dhdsdio_clkctl(dhd_bus_t *bus, uint target, bool pendok)
+static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 {
 #ifdef DHD_DEBUG
 	uint oldstate = bus->clkstate;
@@ -1008,9 +1012,9 @@ static int dhdsdio_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 	case CLK_AVAIL:
 		/* Make sure SD clock is available */
 		if (bus->clkstate == CLK_NONE)
-			dhdsdio_sdclk(bus, true);
+			brcmf_sdbrcm_sdclk(bus, true);
 		/* Now request HT Avail on the backplane */
-		dhdsdio_htclk(bus, true, pendok);
+		brcmf_sdbrcm_htclk(bus, true, pendok);
 		dhd_os_wd_timer(bus->dhd, dhd_watchdog_ms);
 		bus->activity = true;
 		break;
@@ -1018,38 +1022,38 @@ static int dhdsdio_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 	case CLK_SDONLY:
 		/* Remove HT request, or bring up SD clock */
 		if (bus->clkstate == CLK_NONE)
-			dhdsdio_sdclk(bus, true);
+			brcmf_sdbrcm_sdclk(bus, true);
 		else if (bus->clkstate == CLK_AVAIL)
-			dhdsdio_htclk(bus, false, false);
+			brcmf_sdbrcm_htclk(bus, false, false);
 		else
-			DHD_ERROR(("dhdsdio_clkctl: request for %d -> %d\n",
-				   bus->clkstate, target));
+			DHD_ERROR(("brcmf_sdbrcm_clkctl: request for %d -> %d"
+				   "\n", bus->clkstate, target));
 		dhd_os_wd_timer(bus->dhd, dhd_watchdog_ms);
 		break;
 
 	case CLK_NONE:
 		/* Make sure to remove HT request */
 		if (bus->clkstate == CLK_AVAIL)
-			dhdsdio_htclk(bus, false, false);
+			brcmf_sdbrcm_htclk(bus, false, false);
 		/* Now remove the SD clock */
-		dhdsdio_sdclk(bus, false);
+		brcmf_sdbrcm_sdclk(bus, false);
 		dhd_os_wd_timer(bus->dhd, 0);
 		break;
 	}
 #ifdef DHD_DEBUG
-	DHD_INFO(("dhdsdio_clkctl: %d -> %d\n", oldstate, bus->clkstate));
+	DHD_INFO(("brcmf_sdbrcm_clkctl: %d -> %d\n", oldstate, bus->clkstate));
 #endif				/* DHD_DEBUG */
 
 	return 0;
 }
 
-int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
+int brcmf_sdbrcm_bussleep(dhd_bus_t *bus, bool sleep)
 {
 	bcmsdh_info_t *sdh = bus->sdh;
 	struct sdpcmd_regs *regs = bus->regs;
 	uint retries = 0;
 
-	DHD_INFO(("dhdsdio_bussleep: request %s (currently %s)\n",
+	DHD_INFO(("brcmf_sdbrcm_bussleep: request %s (currently %s)\n",
 		  (sleep ? "SLEEP" : "WAKE"),
 		  (bus->sleeping ? "SLEEP" : "WAKE")));
 
@@ -1064,10 +1068,10 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 			return -EBUSY;
 
 		/* Disable SDIO interrupts (no longer interested) */
-		bcmsdh_intr_disable(bus->sdh);
+		brcmf_sdcard_intr_disable(bus->sdh);
 
 		/* Make sure the controller has the bus up */
-		dhdsdio_clkctl(bus, CLK_AVAIL, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 		/* Tell device to start using OOB wakeup */
 		W_SDREG(SMB_USE_OOB, &regs->tosbmailbox, retries);
@@ -1075,16 +1079,18 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 			DHD_ERROR(("CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n"));
 
 		/* Turn off our contribution to the HT clock request */
-		dhdsdio_clkctl(bus, CLK_SDONLY, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
 
-		bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-				 SBSDIO_FORCE_HW_CLKREQ_OFF, NULL);
+		brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+			SBSDIO_FUNC1_CHIPCLKCSR,
+			SBSDIO_FORCE_HW_CLKREQ_OFF, NULL);
 
 		/* Isolate the bus */
 		if (bus->ci->chip != BCM4329_CHIP_ID
 		    && bus->ci->chip != BCM4319_CHIP_ID) {
-			bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
-					 SBSDIO_DEVCTL_PADS_ISO, NULL);
+			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+				SBSDIO_DEVICE_CTL,
+				SBSDIO_DEVCTL_PADS_ISO, NULL);
 		}
 
 		/* Change state */
@@ -1093,18 +1099,18 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 	} else {
 		/* Waking up: bus power up is ok, set local state */
 
-		bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-				 0, NULL);
+		brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+			SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
 		/* Force pad isolation off if possible
 			 (in case power never toggled) */
 		if ((bus->ci->buscoretype == PCMCIA_CORE_ID)
 		    && (bus->ci->buscorerev >= 10))
-			bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL, 0,
-					 NULL);
+			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+				SBSDIO_DEVICE_CTL, 0, NULL);
 
 		/* Make sure the controller has the bus up */
-		dhdsdio_clkctl(bus, CLK_AVAIL, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 		/* Send misc interrupt to indicate OOB not needed */
 		W_SDREG(0, &regs->tosbmailboxdata, retries);
@@ -1115,7 +1121,7 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 			DHD_ERROR(("CANNOT SIGNAL CHIP TO CLEAR OOB!!\n"));
 
 		/* Make sure we have SD bus access */
-		dhdsdio_clkctl(bus, CLK_SDONLY, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
 
 		/* Change state */
 		bus->sleeping = false;
@@ -1123,7 +1129,7 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 		/* Enable interrupts again */
 		if (bus->intr && (bus->dhd->busstate == DHD_BUS_DATA)) {
 			bus->intdis = false;
-			bcmsdh_intr_enable(bus->sdh);
+			brcmf_sdcard_intr_enable(bus->sdh);
 		}
 	}
 
@@ -1131,15 +1137,15 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 }
 
 #if defined(OOB_INTR_ONLY)
-void dhd_enable_oob_intr(struct dhd_bus *bus, bool enable)
+void brcmf_sdbrcm_enable_oob_intr(struct dhd_bus *bus, bool enable)
 {
 #if defined(HW_OOB)
-	bcmsdh_enable_hw_oob_intr(bus->sdh, enable);
+	brcmf_sdcard_enable_hw_oob_intr(bus->sdh, enable);
 #else
 	sdpcmd_regs_t *regs = bus->regs;
 	uint retries = 0;
 
-	dhdsdio_clkctl(bus, CLK_AVAIL, false);
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 	if (enable == true) {
 
 		/* Tell device to start using OOB wakeup */
@@ -1155,7 +1161,7 @@ void dhd_enable_oob_intr(struct dhd_bus *bus, bool enable)
 	}
 
 	/* Turn off our contribution to the HT clock request */
-	dhdsdio_clkctl(bus, CLK_SDONLY, false);
+	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
 #endif				/* !defined(HW_OOB) */
 }
 #endif				/* defined(OOB_INTR_ONLY) */
@@ -1163,12 +1169,12 @@ void dhd_enable_oob_intr(struct dhd_bus *bus, bool enable)
 #define BUS_WAKE(bus) \
 	do { \
 		if ((bus)->sleeping) \
-			dhdsdio_bussleep((bus), false); \
+			brcmf_sdbrcm_bussleep((bus), false); \
 	} while (0);
 
 /* Writes a HW/SW header into the packet and sends it. */
 /* Assumes: (a) header space already there, (b) caller holds lock */
-static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
+static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 			 bool free_pkt)
 {
 	int ret;
@@ -1281,9 +1287,8 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	}
 
 	do {
-		ret =
-		    dhd_bcmsdh_send_buf(bus, bcmsdh_cur_sbwad(sdh), SDIO_FUNC_2,
-					F2SYNC, frame, len, pkt, NULL, NULL);
+		ret = brcmf_sdbrcm_send_buf(bus, brcmf_sdcard_cur_sbwad(sdh),
+			SDIO_FUNC_2, F2SYNC, frame, len, pkt, NULL, NULL);
 		bus->f2txdata++;
 		ASSERT(ret != -BCME_PENDING);
 
@@ -1294,18 +1299,18 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 				"terminate frame.\n", __func__, ret));
 			bus->tx_sderrs++;
 
-			bcmsdh_abort(sdh, SDIO_FUNC_2);
-			bcmsdh_cfg_write(sdh, SDIO_FUNC_1,
+			brcmf_sdcard_abort(sdh, SDIO_FUNC_2);
+			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
 					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
 					 NULL);
 			bus->f1regdata++;
 
 			for (i = 0; i < 3; i++) {
 				u8 hi, lo;
-				hi = bcmsdh_cfg_read(sdh, SDIO_FUNC_1,
+				hi = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCHI,
 						     NULL);
-				lo = bcmsdh_cfg_read(sdh, SDIO_FUNC_1,
+				lo = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCLO,
 						     NULL);
 				bus->f1regdata += 2;
@@ -1332,7 +1337,7 @@ done:
 	return ret;
 }
 
-int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
+int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 {
 	int ret = -EBADE;
 	uint datalen, prec;
@@ -1403,13 +1408,13 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		/* Otherwise, send it now */
 		BUS_WAKE(bus);
 		/* Make sure back plane ht clk is on, no pending allowed */
-		dhdsdio_clkctl(bus, CLK_AVAIL, true);
+		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
 
 #ifndef SDTEST
 		DHD_TRACE(("%s: calling txpkt\n", __func__));
-		ret = dhdsdio_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
+		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
 #else
-		ret = dhdsdio_txpkt(bus, pkt,
+		ret = brcmf_sdbrcm_txpkt(bus, pkt,
 				    (bus->ext_loop ? SDPCM_TEST_CHANNEL :
 				     SDPCM_DATA_CHANNEL), true);
 #endif
@@ -1420,7 +1425,7 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 
 		if ((bus->idletime == DHD_IDLE_IMMEDIATE) && !bus->dpc_sched) {
 			bus->activity = false;
-			dhdsdio_clkctl(bus, CLK_NONE, true);
+			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 		}
 
 		dhd_os_sdunlock(bus->dhd);
@@ -1429,7 +1434,7 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 	return ret;
 }
 
-static uint dhdsdio_sendfromq(dhd_bus_t *bus, uint maxframes)
+static uint brcmf_sdbrcm_sendfromq(dhd_bus_t *bus, uint maxframes)
 {
 	struct sk_buff *pkt;
 	u32 intstatus = 0;
@@ -1458,9 +1463,9 @@ static uint dhdsdio_sendfromq(dhd_bus_t *bus, uint maxframes)
 		datalen = pkt->len - SDPCM_HDRLEN;
 
 #ifndef SDTEST
-		ret = dhdsdio_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
+		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
 #else
-		ret = dhdsdio_txpkt(bus, pkt,
+		ret = brcmf_sdbrcm_txpkt(bus, pkt,
 				    (bus->ext_loop ? SDPCM_TEST_CHANNEL :
 				     SDPCM_DATA_CHANNEL), true);
 #endif
@@ -1474,7 +1479,7 @@ static uint dhdsdio_sendfromq(dhd_bus_t *bus, uint maxframes)
 			/* Check device status, signal pending interrupt */
 			R_SDREG(intstatus, &regs->intstatus, retries);
 			bus->f2txdata++;
-			if (bcmsdh_regfail(bus->sdh))
+			if (brcmf_sdcard_regfail(bus->sdh))
 				break;
 			if (intstatus & bus->hostintmask)
 				bus->ipend = true;
@@ -1489,7 +1494,8 @@ static uint dhdsdio_sendfromq(dhd_bus_t *bus, uint maxframes)
 	return cnt;
 }
 
-int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
+int
+brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 {
 	u8 *frame;
 	u16 len;
@@ -1543,7 +1549,7 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	BUS_WAKE(bus);
 
 	/* Make sure backplane clock is on */
-	dhdsdio_clkctl(bus, CLK_AVAIL, false);
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
 	*(u16 *) frame = cpu_to_le16((u16) msglen);
@@ -1592,10 +1598,9 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 
 		do {
 			bus->ctrl_frame_stat = false;
-			ret =
-			    dhd_bcmsdh_send_buf(bus, bcmsdh_cur_sbwad(sdh),
-						SDIO_FUNC_2, F2SYNC, frame, len,
-						NULL, NULL, NULL);
+			ret = brcmf_sdbrcm_send_buf(bus,
+				brcmf_sdcard_cur_sbwad(sdh), SDIO_FUNC_2,
+				F2SYNC, frame, len, NULL, NULL, NULL);
 
 			ASSERT(ret != -BCME_PENDING);
 
@@ -1606,21 +1611,23 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 					__func__, ret));
 				bus->tx_sderrs++;
 
-				bcmsdh_abort(sdh, SDIO_FUNC_2);
+				brcmf_sdcard_abort(sdh, SDIO_FUNC_2);
 
-				bcmsdh_cfg_write(sdh, SDIO_FUNC_1,
+				brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
 						 SBSDIO_FUNC1_FRAMECTRL,
 						 SFC_WF_TERM, NULL);
 				bus->f1regdata++;
 
 				for (i = 0; i < 3; i++) {
 					u8 hi, lo;
-					hi = bcmsdh_cfg_read(sdh, SDIO_FUNC_1,
+					hi = brcmf_sdcard_cfg_read(sdh,
+					     SDIO_FUNC_1,
 					     SBSDIO_FUNC1_WFRAMEBCHI,
 					     NULL);
-					lo = bcmsdh_cfg_read(sdh, SDIO_FUNC_1,
+					lo = brcmf_sdcard_cfg_read(sdh,
+					     SDIO_FUNC_1,
 					     SBSDIO_FUNC1_WFRAMEBCLO,
-							     NULL);
+					     NULL);
 					bus->f1regdata += 2;
 					if ((hi == 0) && (lo == 0))
 						break;
@@ -1636,7 +1643,7 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 
 	if ((bus->idletime == DHD_IDLE_IMMEDIATE) && !bus->dpc_sched) {
 		bus->activity = false;
-		dhdsdio_clkctl(bus, CLK_NONE, true);
+		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
 
 	dhd_os_sdunlock(bus->dhd);
@@ -1649,7 +1656,7 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	return ret ? -EIO : 0;
 }
 
-int dhd_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
+int brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 {
 	int timeleft;
 	uint rxlen = 0;
@@ -1676,7 +1683,7 @@ int dhd_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		DHD_ERROR(("%s: resumed on timeout\n", __func__));
 #ifdef DHD_DEBUG
 		dhd_os_sdlock(bus->dhd);
-		dhdsdio_checkdied(bus, NULL, 0);
+		brcmf_sdbrcm_checkdied(bus, NULL, 0);
 		dhd_os_sdunlock(bus->dhd);
 #endif				/* DHD_DEBUG */
 	} else if (pending == true) {
@@ -1686,7 +1693,7 @@ int dhd_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		DHD_CTL(("%s: resumed for unknown reason?\n", __func__));
 #ifdef DHD_DEBUG
 		dhd_os_sdlock(bus->dhd);
-		dhdsdio_checkdied(bus, NULL, 0);
+		brcmf_sdbrcm_checkdied(bus, NULL, 0);
 		dhd_os_sdunlock(bus->dhd);
 #endif				/* DHD_DEBUG */
 	}
@@ -1798,7 +1805,7 @@ dhd_dump_pct(struct brcmu_strbuf *strbuf, char *desc, uint num, uint div)
 	}
 }
 
-void dhd_bus_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
+void brcmf_sdbrcm_bus_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
 {
 	dhd_bus_t *bus = dhdp->bus;
 
@@ -1889,7 +1896,7 @@ void dhd_bus_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
 #ifdef DHD_DEBUG
 	brcmu_bprintf(strbuf, "dpc_sched %d host interrupt%spending\n",
 		    bus->dpc_sched,
-		    (bcmsdh_intr_pending(bus->sdh) ? " " : " not "));
+		    (brcmf_sdcard_intr_pending(bus->sdh) ? " " : " not "));
 	brcmu_bprintf(strbuf, "blocksize %d roundup %d\n", bus->blocksize,
 		    bus->roundup);
 #endif				/* DHD_DEBUG */
@@ -1912,7 +1919,7 @@ void dhd_bus_clearcounts(dhd_pub_t *dhdp)
 }
 
 #ifdef SDTEST
-static int dhdsdio_pktgen_get(dhd_bus_t *bus, u8 *arg)
+static int brcmf_sdbrcm_pktgen_get(dhd_bus_t *bus, u8 *arg)
 {
 	dhd_pktgen_t pktgen;
 
@@ -1934,7 +1941,7 @@ static int dhdsdio_pktgen_get(dhd_bus_t *bus, u8 *arg)
 	return 0;
 }
 
-static int dhdsdio_pktgen_set(dhd_bus_t *bus, u8 *arg)
+static int brcmf_sdbrcm_pktgen_set(dhd_bus_t *bus, u8 *arg)
 {
 	dhd_pktgen_t pktgen;
 	uint oldcnt, oldmode;
@@ -1968,7 +1975,7 @@ static int dhdsdio_pktgen_set(dhd_bus_t *bus, u8 *arg)
 #endif				/* SDTEST */
 
 static int
-dhdsdio_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
+brcmf_sdbrcm_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
 		 uint size)
 {
 	int bcmerror = 0;
@@ -1983,7 +1990,7 @@ dhdsdio_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
 		dsize = size;
 
 	/* Set the backplane window to include the start address */
-	bcmerror = dhdsdio_set_siaddr_window(bus, address);
+	bcmerror = brcmf_sdbrcm_set_siaddr_window(bus, address);
 	if (bcmerror) {
 		DHD_ERROR(("%s: window change failed\n", __func__));
 		goto xfer_done;
@@ -1995,7 +2002,7 @@ dhdsdio_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
 			  __func__, (write ? "write" : "read"), dsize,
 			  sdaddr, (address & SBSDIO_SBWINDOW_MASK)));
 		bcmerror =
-		     bcmsdh_rwdata(bus->sdh, write, sdaddr, data, dsize);
+		     brcmf_sdcard_rwdata(bus->sdh, write, sdaddr, data, dsize);
 		if (bcmerror) {
 			DHD_ERROR(("%s: membytes transfer failed\n", __func__));
 			break;
@@ -2006,7 +2013,7 @@ dhdsdio_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
 		if (size) {
 			data += dsize;
 			address += dsize;
-			bcmerror = dhdsdio_set_siaddr_window(bus, address);
+			bcmerror = brcmf_sdbrcm_set_siaddr_window(bus, address);
 			if (bcmerror) {
 				DHD_ERROR(("%s: window change failed\n",
 					   __func__));
@@ -2019,23 +2026,25 @@ dhdsdio_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
 
 xfer_done:
 	/* Return the window to backplane enumeration space for core access */
-	if (dhdsdio_set_siaddr_window(bus, bcmsdh_cur_sbwad(bus->sdh))) {
+	if (brcmf_sdbrcm_set_siaddr_window(bus,
+					   brcmf_sdcard_cur_sbwad(bus->sdh))) {
 		DHD_ERROR(("%s: FAILED to set window back to 0x%x\n",
-			   __func__, bcmsdh_cur_sbwad(bus->sdh)));
+			   __func__, brcmf_sdcard_cur_sbwad(bus->sdh)));
 	}
 
 	return bcmerror;
 }
 
 #ifdef DHD_DEBUG
-static int dhdsdio_readshared(dhd_bus_t *bus, struct sdpcm_shared *sh)
+static int brcmf_sdbrcm_readshared(dhd_bus_t *bus, struct sdpcm_shared *sh)
 {
 	u32 addr;
 	int rv;
 
 	/* Read last word in memory to determine address of
 			 sdpcm_shared structure */
-	rv = dhdsdio_membytes(bus, false, bus->ramsize - 4, (u8 *)&addr, 4);
+	rv = brcmf_sdbrcm_membytes(bus, false, bus->ramsize - 4, (u8 *)&addr,
+				   4);
 	if (rv < 0)
 		return rv;
 
@@ -2054,7 +2063,7 @@ static int dhdsdio_readshared(dhd_bus_t *bus, struct sdpcm_shared *sh)
 	}
 
 	/* Read rte_shared structure */
-	rv = dhdsdio_membytes(bus, false, addr, (u8 *) sh,
+	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *) sh,
 			      sizeof(struct sdpcm_shared));
 	if (rv < 0)
 		return rv;
@@ -2079,7 +2088,7 @@ static int dhdsdio_readshared(dhd_bus_t *bus, struct sdpcm_shared *sh)
 	return 0;
 }
 
-static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
+static int brcmf_sdbrcm_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 {
 	int bcmerror = 0;
 	uint msize = 512;
@@ -2114,7 +2123,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 		goto done;
 	}
 
-	bcmerror = dhdsdio_readshared(bus, &sdpcm_shared);
+	bcmerror = brcmf_sdbrcm_readshared(bus, &sdpcm_shared);
 	if (bcmerror < 0)
 		goto done;
 
@@ -2147,7 +2156,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 			brcmu_bprintf(&strbuf, "Dongle assert");
 			if (sdpcm_shared.assert_exp_addr != 0) {
 				str[0] = '\0';
-				bcmerror = dhdsdio_membytes(bus, false,
+				bcmerror = brcmf_sdbrcm_membytes(bus, false,
 						sdpcm_shared.assert_exp_addr,
 						(u8 *) str, maxstrlen);
 				if (bcmerror < 0)
@@ -2159,7 +2168,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 
 			if (sdpcm_shared.assert_file_addr != 0) {
 				str[0] = '\0';
-				bcmerror = dhdsdio_membytes(bus, false,
+				bcmerror = brcmf_sdbrcm_membytes(bus, false,
 						sdpcm_shared.assert_file_addr,
 						(u8 *) str, maxstrlen);
 				if (bcmerror < 0)
@@ -2174,7 +2183,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 		}
 
 		if (sdpcm_shared.flags & SDPCM_SHARED_TRAP) {
-			bcmerror = dhdsdio_membytes(bus, false,
+			bcmerror = brcmf_sdbrcm_membytes(bus, false,
 					sdpcm_shared.trap_addr, (u8 *)&tr,
 					sizeof(trap_t));
 			if (bcmerror < 0)
@@ -2197,7 +2206,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 #ifdef DHD_DEBUG
 	if (sdpcm_shared.flags & SDPCM_SHARED_TRAP) {
 		/* Mem dump to a file on device */
-		dhdsdio_mem_dump(bus);
+		brcmf_sdbrcm_mem_dump(bus);
 	}
 #endif				/* DHD_DEBUG */
 
@@ -2208,7 +2217,7 @@ done:
 	return bcmerror;
 }
 
-static int dhdsdio_mem_dump(dhd_bus_t *bus)
+static int brcmf_sdbrcm_mem_dump(dhd_bus_t *bus)
 {
 	int ret = 0;
 	int size;		/* Full mem size */
@@ -2229,7 +2238,8 @@ static int dhdsdio_mem_dump(dhd_bus_t *bus)
 	databuf = buf;
 	while (size) {
 		read_size = min(MEMBLOCK, size);
-		ret = dhdsdio_membytes(bus, false, start, databuf, read_size);
+		ret = brcmf_sdbrcm_membytes(bus, false, start, databuf,
+					  read_size);
 		if (ret) {
 			DHD_ERROR(("%s: Error membytes %d\n", __func__, ret));
 			kfree(buf);
@@ -2256,7 +2266,7 @@ static int dhdsdio_mem_dump(dhd_bus_t *bus)
 
 #define CONSOLE_LINE_MAX	192
 
-static int dhdsdio_readconsole(dhd_bus_t *bus)
+static int brcmf_sdbrcm_readconsole(dhd_bus_t *bus)
 {
 	dhd_console_t *c = &bus->console;
 	u8 line[CONSOLE_LINE_MAX], ch;
@@ -2269,7 +2279,7 @@ static int dhdsdio_readconsole(dhd_bus_t *bus)
 
 	/* Read console log struct */
 	addr = bus->console_addr + offsetof(rte_cons_t, log);
-	rv = dhdsdio_membytes(bus, false, addr, (u8 *)&c->log,
+	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *)&c->log,
 				sizeof(c->log));
 	if (rv < 0)
 		return rv;
@@ -2295,7 +2305,7 @@ static int dhdsdio_readconsole(dhd_bus_t *bus)
 
 	/* Read the console buffer */
 	addr = le32_to_cpu(c->log.buf);
-	rv = dhdsdio_membytes(bus, false, addr, c->buf, c->bufsize);
+	rv = brcmf_sdbrcm_membytes(bus, false, addr, c->buf, c->bufsize);
 	if (rv < 0)
 		return rv;
 
@@ -2333,7 +2343,7 @@ break2:
 }
 #endif				/* DHD_DEBUG */
 
-int dhdsdio_downloadvars(dhd_bus_t *bus, void *arg, int len)
+int brcmf_sdbrcm_downloadvars(dhd_bus_t *bus, void *arg, int len)
 {
 	int bcmerror = 0;
 
@@ -2367,7 +2377,7 @@ err:
 }
 
 static int
-dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
+brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		const char *name, void *params, int plen, void *arg, int len,
 		int val_size)
 {
@@ -2401,7 +2411,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 	/* Handle sleep stuff before any clock mucking */
 	if (vi->varid == IOV_SLEEP) {
 		if (IOV_ISSET(actionid)) {
-			bcmerror = dhdsdio_bussleep(bus, bool_val);
+			bcmerror = brcmf_sdbrcm_bussleep(bus, bool_val);
 		} else {
 			int_val = (s32) bus->sleeping;
 			memcpy(arg, &int_val, val_size);
@@ -2412,7 +2422,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 	/* Request clock to allow SDIO accesses */
 	if (!bus->dhd->dongle_reset) {
 		BUS_WAKE(bus);
-		dhdsdio_clkctl(bus, CLK_AVAIL, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 	}
 
 	switch (actionid) {
@@ -2428,11 +2438,11 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 			if (bus->intr) {
 				DHD_INTR(("%s: enable SDIO device interrupts\n",
 					  __func__));
-				bcmsdh_intr_enable(bus->sdh);
+				brcmf_sdcard_intr_enable(bus->sdh);
 			} else {
 				DHD_INTR(("%s: disable SDIO interrupts\n",
 					  __func__));
-				bcmsdh_intr_disable(bus->sdh);
+				brcmf_sdcard_intr_disable(bus->sdh);
 			}
 		}
 		break;
@@ -2525,8 +2535,8 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 			    2 * sizeof(int) : (u8 *) arg;
 
 			/* Call to do the transfer */
-			bcmerror =
-			    dhdsdio_membytes(bus, set, address, data, size);
+			bcmerror = brcmf_sdbrcm_membytes(bus, set, address,
+							 data, size);
 
 			break;
 		}
@@ -2543,16 +2553,16 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_SDIOD_DRIVE):
 		dhd_sdiod_drive_strength = int_val;
-		dhdsdio_sdiod_drive_strength_init(bus,
+		brcmf_sdbrcm_sdiod_drive_strength_init(bus,
 					     dhd_sdiod_drive_strength);
 		break;
 
 	case IOV_SVAL(IOV_DOWNLOAD):
-		bcmerror = dhdsdio_download_state(bus, bool_val);
+		bcmerror = brcmf_sdbrcm_download_state(bus, bool_val);
 		break;
 
 	case IOV_SVAL(IOV_VARS):
-		bcmerror = dhdsdio_downloadvars(bus, arg, len);
+		bcmerror = brcmf_sdbrcm_downloadvars(bus, arg, len);
 		break;
 
 	case IOV_GVAL(IOV_READAHEAD):
@@ -2610,8 +2620,9 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 			addr = (unsigned long)bus->regs + sd_ptr->offset;
 			size = sd_ptr->func;
-			int_val = (s32) bcmsdh_reg_read(bus->sdh, addr, size);
-			if (bcmsdh_regfail(bus->sdh))
+			int_val = (s32) brcmf_sdcard_reg_read(bus->sdh, addr,
+							      size);
+			if (brcmf_sdcard_regfail(bus->sdh))
 				bcmerror = -EIO;
 			memcpy(arg, &int_val, sizeof(s32));
 			break;
@@ -2626,8 +2637,9 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 			addr = (unsigned long)bus->regs + sd_ptr->offset;
 			size = sd_ptr->func;
-			bcmsdh_reg_write(bus->sdh, addr, size, sd_ptr->value);
-			if (bcmsdh_regfail(bus->sdh))
+			brcmf_sdcard_reg_write(bus->sdh, addr, size,
+					       sd_ptr->value);
+			if (brcmf_sdcard_regfail(bus->sdh))
 				bcmerror = -EIO;
 			break;
 		}
@@ -2643,8 +2655,9 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 			addr = SI_ENUM_BASE + sdreg.offset;
 			size = sdreg.func;
-			int_val = (s32) bcmsdh_reg_read(bus->sdh, addr, size);
-			if (bcmsdh_regfail(bus->sdh))
+			int_val = (s32) brcmf_sdcard_reg_read(bus->sdh, addr,
+							      size);
+			if (brcmf_sdcard_regfail(bus->sdh))
 				bcmerror = -EIO;
 			memcpy(arg, &int_val, sizeof(s32));
 			break;
@@ -2659,8 +2672,9 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 			addr = SI_ENUM_BASE + sdreg.offset;
 			size = sdreg.func;
-			bcmsdh_reg_write(bus->sdh, addr, size, sdreg.value);
-			if (bcmsdh_regfail(bus->sdh))
+			brcmf_sdcard_reg_write(bus->sdh, addr, size,
+					       sdreg.value);
+			if (brcmf_sdcard_regfail(bus->sdh))
 				bcmerror = -EIO;
 			break;
 		}
@@ -2670,15 +2684,15 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 			*(char *)arg = 0;
 
 			strcat(arg, "\nFunc 0\n");
-			bcmsdh_cis_read(bus->sdh, 0x10,
+			brcmf_sdcard_cis_read(bus->sdh, 0x10,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
 			strcat(arg, "\nFunc 1\n");
-			bcmsdh_cis_read(bus->sdh, 0x11,
+			brcmf_sdcard_cis_read(bus->sdh, 0x11,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
 			strcat(arg, "\nFunc 2\n");
-			bcmsdh_cis_read(bus->sdh, 0x12,
+			brcmf_sdcard_cis_read(bus->sdh, 0x12,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
 			break;
@@ -2732,11 +2746,11 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		break;
 
 	case IOV_GVAL(IOV_PKTGEN):
-		bcmerror = dhdsdio_pktgen_get(bus, arg);
+		bcmerror = brcmf_sdbrcm_pktgen_get(bus, arg);
 		break;
 
 	case IOV_SVAL(IOV_PKTGEN):
-		bcmerror = dhdsdio_pktgen_set(bus, arg);
+		bcmerror = brcmf_sdbrcm_pktgen_set(bus, arg);
 		break;
 #endif				/* SDTEST */
 
@@ -2767,7 +2781,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 exit:
 	if ((bus->idletime == DHD_IDLE_IMMEDIATE) && !bus->dpc_sched) {
 		bus->activity = false;
-		dhdsdio_clkctl(bus, CLK_NONE, true);
+		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
 
 	dhd_os_sdunlock(bus->dhd);
@@ -2778,7 +2792,7 @@ exit:
 	return bcmerror;
 }
 
-static int dhdsdio_write_vars(dhd_bus_t *bus)
+static int brcmf_sdbrcm_write_vars(dhd_bus_t *bus)
 {
 	int bcmerror = 0;
 	u32 varsize;
@@ -2803,7 +2817,7 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 
 		/* Write the vars list */
 		bcmerror =
-		    dhdsdio_membytes(bus, true, varaddr, vbuffer, varsize);
+		    brcmf_sdbrcm_membytes(bus, true, varaddr, vbuffer, varsize);
 #ifdef DHD_DEBUG
 		/* Verify NVRAM bytes */
 		DHD_INFO(("Compare NVRAM dl & ul; varsize=%d\n", varsize));
@@ -2816,7 +2830,7 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 
 		/* Read the vars list to temp buffer for comparison */
 		bcmerror =
-		    dhdsdio_membytes(bus, false, varaddr, nvram_ularray,
+		    brcmf_sdbrcm_membytes(bus, false, varaddr, nvram_ularray,
 				     varsize);
 		if (bcmerror) {
 			DHD_ERROR(("%s: error %d on reading %d nvram bytes at "
@@ -2859,13 +2873,13 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 		  varsizew));
 
 	/* Write the length token to the last word */
-	bcmerror = dhdsdio_membytes(bus, true, (bus->orig_ramsize - 4),
+	bcmerror = brcmf_sdbrcm_membytes(bus, true, (bus->orig_ramsize - 4),
 				    (u8 *)&varsizew, 4);
 
 	return bcmerror;
 }
 
-static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
+static int brcmf_sdbrcm_download_state(dhd_bus_t *bus, bool enter)
 {
 	uint retries;
 	u32 regdata;
@@ -2877,18 +2891,18 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 	if (enter) {
 		bus->alp_only = true;
 
-		dhdsdio_chip_disablecore(bus->sdh, bus->ci->armcorebase);
+		brcmf_sdbrcm_chip_disablecore(bus->sdh, bus->ci->armcorebase);
 
-		dhdsdio_chip_resetcore(bus->sdh, bus->ci->ramcorebase);
+		brcmf_sdbrcm_chip_resetcore(bus->sdh, bus->ci->ramcorebase);
 
 		/* Clear the top bit of memory */
 		if (bus->ramsize) {
 			u32 zeros = 0;
-			dhdsdio_membytes(bus, true, bus->ramsize - 4,
+			brcmf_sdbrcm_membytes(bus, true, bus->ramsize - 4,
 					 (u8 *)&zeros, 4);
 		}
 	} else {
-		regdata = bcmsdh_reg_read(bus->sdh,
+		regdata = brcmf_sdcard_reg_read(bus->sdh,
 			CORE_SB(bus->ci->ramcorebase, sbtmstatelow), 4);
 		regdata &= (SBTML_RESET | SBTML_REJ_MASK |
 			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
@@ -2899,7 +2913,7 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 			goto fail;
 		}
 
-		bcmerror = dhdsdio_write_vars(bus);
+		bcmerror = brcmf_sdbrcm_write_vars(bus);
 		if (bcmerror) {
 			DHD_ERROR(("%s: no vars written to RAM\n", __func__));
 			bcmerror = 0;
@@ -2907,7 +2921,7 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 
 		W_SDREG(0xFFFFFFFF, &bus->regs->intstatus, retries);
 
-		dhdsdio_chip_resetcore(bus->sdh, bus->ci->armcorebase);
+		brcmf_sdbrcm_chip_resetcore(bus->sdh, bus->ci->armcorebase);
 
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
@@ -2919,8 +2933,8 @@ fail:
 }
 
 int
-dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
-		 void *params, int plen, void *arg, int len, bool set)
+brcmf_sdbrcm_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
+			  void *params, int plen, void *arg, int len, bool set)
 {
 	dhd_bus_t *bus = dhdp->bus;
 	const struct brcmu_iovar *vi = NULL;
@@ -2947,16 +2961,15 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 		BUS_WAKE(bus);
 
 		/* Turn on clock in case SD command needs backplane */
-		dhdsdio_clkctl(bus, CLK_AVAIL, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
-		bcmerror =
-		    bcmsdh_iovar_op(bus->sdh, name, params, plen, arg, len,
-				    set);
+		bcmerror = brcmf_sdcard_iovar_op(bus->sdh, name, params, plen,
+						 arg, len, set);
 
 		/* Similar check for blocksize change */
 		if (set && strcmp(name, "sd_blocksize") == 0) {
 			s32 fnum = 2;
-			if (bcmsdh_iovar_op
+			if (brcmf_sdcard_iovar_op
 			    (bus->sdh, "sd_blocksize", &fnum, sizeof(s32),
 			     &bus->blocksize, sizeof(s32),
 			     false) != 0) {
@@ -2973,7 +2986,7 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 
 		if ((bus->idletime == DHD_IDLE_IMMEDIATE) && !bus->dpc_sched) {
 			bus->activity = false;
-			dhdsdio_clkctl(bus, CLK_NONE, true);
+			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 		}
 
 		dhd_os_sdunlock(bus->dhd);
@@ -3000,15 +3013,14 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 		val_size = sizeof(int);
 
 	actionid = set ? IOV_SVAL(vi->varid) : IOV_GVAL(vi->varid);
-	bcmerror =
-	    dhdsdio_doiovar(bus, vi, actionid, name, params, plen, arg, len,
-			    val_size);
+	bcmerror = brcmf_sdbrcm_doiovar(bus, vi, actionid, name, params, plen,
+					arg, len, val_size);
 
 exit:
 	return bcmerror;
 }
 
-void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
+void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 {
 	u32 local_hostintmask;
 	u8 saveclk;
@@ -3023,7 +3035,7 @@ void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	BUS_WAKE(bus);
 
 	/* Enable clock for device interrupts */
-	dhdsdio_clkctl(bus, CLK_AVAIL, false);
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 	/* Disable and clear interrupts at the chip level also */
 	W_SDREG(0, &bus->regs->hostintmask, retries);
@@ -3034,12 +3046,12 @@ void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	bus->dhd->busstate = DHD_BUS_DOWN;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk =
-	    bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-			    &err);
+	saveclk = brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_1,
+					SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-				 (saveclk | SBSDIO_FORCE_HT), &err);
+		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1,
+				       SBSDIO_FUNC1_CHIPCLKCSR,
+				       (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
 		DHD_ERROR(("%s: Failed to force clock for F2: err %d\n",
@@ -3048,15 +3060,15 @@ void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 
 	/* Turn off the bus (F2), free any pending packets */
 	DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
-	bcmsdh_intr_disable(bus->sdh);
-	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+	brcmf_sdcard_intr_disable(bus->sdh);
+	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			 SDIO_FUNC_ENABLE_1, NULL);
 
 	/* Clear any pending interrupts now that F2 is disabled */
 	W_SDREG(local_hostintmask, &bus->regs->intstatus, retries);
 
 	/* Turn off the backplane clock (only) */
-	dhdsdio_clkctl(bus, CLK_SDONLY, false);
+	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
 
 	/* Clear the data packet queues */
 	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
@@ -3082,7 +3094,7 @@ void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 		dhd_os_sdunlock(bus->dhd);
 }
 
-int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
+int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 {
 	dhd_bus_t *bus = dhdp->bus;
 	dhd_timeout_t tmo;
@@ -3101,17 +3113,18 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 		dhd_os_sdlock(bus->dhd);
 
 	/* Make sure backplane clock is on, needed to generate F2 interrupt */
-	dhdsdio_clkctl(bus, CLK_AVAIL, false);
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 	if (bus->clkstate != CLK_AVAIL)
 		goto exit;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
 	saveclk =
-	    bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-			    &err);
+	    brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_1,
+				  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-				 (saveclk | SBSDIO_FORCE_HT), &err);
+		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1,
+				       SBSDIO_FUNC1_CHIPCLKCSR,
+				       (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
 		DHD_ERROR(("%s: Failed to force clock for F2: err %d\n",
@@ -3124,7 +3137,8 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 		&bus->regs->tosbmailboxdata, retries);
 	enable = (SDIO_FUNC_ENABLE_1 | SDIO_FUNC_ENABLE_2);
 
-	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx, enable, NULL);
+	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx, enable,
+			       NULL);
 
 	/* Give the dongle some time to do its thing and set IOR2 */
 	dhd_timeout_start(&tmo, DHD_WAIT_F2RDY * 1000);
@@ -3132,7 +3146,7 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 	ready = 0;
 	while (ready != enable && !dhd_timeout_expired(&tmo))
 		ready =
-		    bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IORx,
+		    brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IORx,
 				    NULL);
 
 	DHD_INFO(("%s: enable 0x%02x, ready 0x%02x (waited %uus)\n",
@@ -3146,7 +3160,7 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 			(unsigned int *)CORE_BUS_REG(bus->ci->buscorebase,
 			hostintmask), retries);
 
-		bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_WATERMARK,
+		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_WATERMARK,
 				 (u8) watermark, &err);
 
 		/* Set bus state according to enable result */
@@ -3158,10 +3172,10 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 		if (bus->intr) {
 			DHD_INTR(("%s: enable SDIO device interrupts\n",
 				  __func__));
-			bcmsdh_intr_enable(bus->sdh);
+			brcmf_sdcard_intr_enable(bus->sdh);
 		} else {
 			DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
-			bcmsdh_intr_disable(bus->sdh);
+			brcmf_sdcard_intr_disable(bus->sdh);
 		}
 
 	}
@@ -3169,17 +3183,17 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 	else {
 		/* Disable F2 again */
 		enable = SDIO_FUNC_ENABLE_1;
-		bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx, enable,
-				 NULL);
+		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+				       enable, NULL);
 	}
 
 	/* Restore previous clock setting */
-	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
+	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 			 saveclk, &err);
 
 	/* If we didn't come up, turn off backplane clock */
 	if (dhdp->busstate != DHD_BUS_DATA)
-		dhdsdio_clkctl(bus, CLK_NONE, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 
 exit:
 	if (enforce_mutex)
@@ -3188,7 +3202,7 @@ exit:
 	return ret;
 }
 
-static void dhdsdio_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
+static void brcmf_sdbrcm_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 {
 	bcmsdh_info_t *sdh = bus->sdh;
 	struct sdpcmd_regs *regs = bus->regs;
@@ -3202,18 +3216,18 @@ static void dhdsdio_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 		   (rtx ? ", send NAK" : "")));
 
 	if (abort)
-		bcmsdh_abort(sdh, SDIO_FUNC_2);
+		brcmf_sdcard_abort(sdh, SDIO_FUNC_2);
 
-	bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_FRAMECTRL, SFC_RF_TERM,
-			 &err);
+	brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_FRAMECTRL,
+			       SFC_RF_TERM, &err);
 	bus->f1regdata++;
 
 	/* Wait until the packet has been flushed (device/FIFO stable) */
 	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
-		hi = bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_RFRAMEBCHI,
-				     NULL);
-		lo = bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_RFRAMEBCLO,
-				     NULL);
+		hi = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+					   SBSDIO_FUNC1_RFRAMEBCHI, NULL);
+		lo = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+					   SBSDIO_FUNC1_RFRAMEBCLO, NULL);
 		bus->f1regdata += 2;
 
 		if ((hi == 0) && (lo == 0))
@@ -3247,12 +3261,12 @@ static void dhdsdio_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 	bus->nextlen = 0;
 
 	/* If we can't reach the device, signal failure */
-	if (err || bcmsdh_regfail(sdh))
+	if (err || brcmf_sdcard_regfail(sdh))
 		bus->dhd->busstate = DHD_BUS_DOWN;
 }
 
 static void
-dhdsdio_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
+brcmf_sdbrcm_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 {
 	bcmsdh_info_t *sdh = bus->sdh;
 	uint rdlen, pad;
@@ -3308,7 +3322,7 @@ dhdsdio_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 		DHD_ERROR(("%s: %d-byte control read exceeds %d-byte buffer\n",
 			   __func__, rdlen, bus->dhd->maxctl));
 		bus->dhd->rx_errors++;
-		dhdsdio_rxfail(bus, false, false);
+		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
 	}
 
@@ -3318,12 +3332,13 @@ dhdsdio_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 			__func__, len, (len - doff), bus->dhd->maxctl));
 		bus->dhd->rx_errors++;
 		bus->rx_toolong++;
-		dhdsdio_rxfail(bus, false, false);
+		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
 	}
 
 	/* Read remainder of frame body into the rxctl buffer */
-	sdret = bcmsdh_recv_buf(sdh, bcmsdh_cur_sbwad(sdh), SDIO_FUNC_2,
+	sdret = brcmf_sdcard_recv_buf(sdh, brcmf_sdcard_cur_sbwad(sdh),
+				SDIO_FUNC_2,
 				F2SYNC, (bus->rxctl + firstread), rdlen,
 				NULL, NULL, NULL);
 	bus->f2rxdata++;
@@ -3334,7 +3349,7 @@ dhdsdio_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 		DHD_ERROR(("%s: read %d control bytes failed: %d\n",
 			   __func__, rdlen, sdret));
 		bus->rxc_errors++;	/* dhd.rx_ctlerrs is higher level */
-		dhdsdio_rxfail(bus, true, true);
+		brcmf_sdbrcm_rxfail(bus, true, true);
 		goto done;
 	}
 
@@ -3356,7 +3371,7 @@ done:
 	dhd_os_ioctl_resp_wake(bus->dhd);
 }
 
-static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
+static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 {
 	u16 dlen, totlen;
 	u8 *dptr, num = 0;
@@ -3374,7 +3389,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 	/* If packets, issue read(s) and send up packet chain */
 	/* Return sequence numbers consumed? */
 
-	DHD_TRACE(("dhdsdio_rxglom: start: glomd %p glom %p\n", bus->glomd,
+	DHD_TRACE(("brcmf_sdbrcm_rxglom: start: glomd %p glom %p\n", bus->glomd,
 		   bus->glom));
 
 	/* If there's a descriptor, generate the packet chain */
@@ -3485,13 +3500,15 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		 * packet and and copy into the chain.
 		 */
 		if (usechain) {
-			errcode = bcmsdh_recv_buf(bus->sdh,
-					bcmsdh_cur_sbwad(bus->sdh), SDIO_FUNC_2,
+			errcode = brcmf_sdcard_recv_buf(bus->sdh,
+					brcmf_sdcard_cur_sbwad(bus->sdh),
+					SDIO_FUNC_2,
 					F2SYNC, (u8 *) pfirst->data, dlen,
 					pfirst, NULL, NULL);
 		} else if (bus->dataptr) {
-			errcode = bcmsdh_recv_buf(bus->sdh,
-					bcmsdh_cur_sbwad(bus->sdh), SDIO_FUNC_2,
+			errcode = brcmf_sdcard_recv_buf(bus->sdh,
+					brcmf_sdcard_cur_sbwad(bus->sdh),
+					SDIO_FUNC_2,
 					F2SYNC, bus->dataptr, dlen,
 					NULL, NULL, NULL);
 			sublen = (u16) brcmu_pktfrombuf(pfirst, 0, dlen,
@@ -3517,10 +3534,10 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			bus->dhd->rx_errors++;
 
 			if (bus->glomerr++ < 3) {
-				dhdsdio_rxfail(bus, true, true);
+				brcmf_sdbrcm_rxfail(bus, true, true);
 			} else {
 				bus->glomerr = 0;
-				dhdsdio_rxfail(bus, true, false);
+				brcmf_sdbrcm_rxfail(bus, true, false);
 				brcmu_pkt_buf_free_skb(bus->glom);
 				bus->rxglomfail++;
 				bus->glom = NULL;
@@ -3648,10 +3665,10 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			if (bus->glomerr++ < 3) {
 				/* Restore superframe header space */
 				skb_push(pfirst, sfdoff);
-				dhdsdio_rxfail(bus, true, true);
+				brcmf_sdbrcm_rxfail(bus, true, true);
 			} else {
 				bus->glomerr = 0;
-				dhdsdio_rxfail(bus, true, false);
+				brcmf_sdbrcm_rxfail(bus, true, false);
 				brcmu_pkt_buf_free_skb(bus->glom);
 				bus->rxglomfail++;
 				bus->glom = NULL;
@@ -3756,7 +3773,8 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 }
 
 /* Return true if there may be more frames to read */
-static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
+static uint
+brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 {
 	bcmsdh_info_t *sdh = bus->sdh;
 
@@ -3805,7 +3823,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			u8 cnt;
 			DHD_GLOM(("%s: calling rxglom: glomd %p, glom %p\n",
 				  __func__, bus->glomd, bus->glom));
-			cnt = dhdsdio_rxglom(bus, rxseq);
+			cnt = brcmf_sdbrcm_rxglom(bus, rxseq);
 			DHD_GLOM(("%s: rxglom returned %d\n", __func__, cnt));
 			rxseq += cnt - 1;
 			rxleft = (rxleft > cnt) ? (rxleft - cnt) : 1;
@@ -3867,8 +3885,8 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					ASSERT(bus->rxctl >= bus->rxbuf);
 					rxbuf = bus->rxctl;
 					/* Read the entire frame */
-					sdret = bcmsdh_recv_buf(sdh,
-						    bcmsdh_cur_sbwad(sdh),
+					sdret = brcmf_sdcard_recv_buf(sdh,
+						    brcmf_sdcard_cur_sbwad(sdh),
 						    SDIO_FUNC_2, F2SYNC,
 						    rxbuf, rdlen,
 						    NULL, NULL, NULL);
@@ -3883,7 +3901,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 							rdlen, sdret));
 						/* dhd.rx_ctlerrs is higher */
 						bus->rxc_errors++;
-						dhdsdio_rxfail(bus, true,
+						brcmf_sdbrcm_rxfail(bus, true,
 						       (bus->bus ==
 							SPI_BUS) ? false
 						       : true);
@@ -3908,8 +3926,8 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				PKTALIGN(pkt, rdlen, DHD_SDALIGN);
 				rxbuf = (u8 *) (pkt->data);
 				/* Read the entire frame */
-				sdret = bcmsdh_recv_buf(sdh,
-						bcmsdh_cur_sbwad(sdh),
+				sdret = brcmf_sdcard_recv_buf(sdh,
+						brcmf_sdcard_cur_sbwad(sdh),
 						SDIO_FUNC_2, F2SYNC,
 						rxbuf, rdlen,
 						pkt, NULL, NULL);
@@ -3925,7 +3943,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					 * Don't attempt NAK for
 					 * gSPI
 					 */
-					dhdsdio_rxfail(bus, true,
+					brcmf_sdbrcm_rxfail(bus, true,
 						       (bus->bus ==
 							SPI_BUS) ? false :
 						       true);
@@ -3944,7 +3962,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			if (!(len | check)) {
 				DHD_INFO(("%s (nextlen): read zeros in HW "
 					"header???\n", __func__));
-				dhdsdio_pktfree2(bus, pkt);
+				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
 
@@ -3955,8 +3973,8 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					" 0x%04x/0x%04x/0x%04x\n",
 					__func__, nextlen, len, check));
 				bus->rx_badhdr++;
-				dhdsdio_rxfail(bus, false, false);
-				dhdsdio_pktfree2(bus, pkt);
+				brcmf_sdbrcm_rxfail(bus, false, false);
+				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
 
@@ -3964,7 +3982,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			if (len < SDPCM_HDRLEN) {
 				DHD_ERROR(("%s (nextlen): HW hdr length "
 					"invalid: %d\n", __func__, len));
-				dhdsdio_pktfree2(bus, pkt);
+				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
 
@@ -3978,8 +3996,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					"expected rxseq %d\n",
 					__func__, nextlen,
 					len, roundup(len, 16), rxseq));
-				dhdsdio_rxfail(bus, true, (bus->bus != SPI_BUS));
-				dhdsdio_pktfree2(bus, pkt);
+				brcmf_sdbrcm_rxfail(bus, true,
+						  bus->bus != SPI_BUS);
+				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
 
@@ -4050,16 +4069,16 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 			if (chan == SDPCM_CONTROL_CHANNEL) {
 				if (bus->bus == SPI_BUS) {
-					dhdsdio_read_control(bus, rxbuf, len,
-							     doff);
+					brcmf_sdbrcm_read_control(bus, rxbuf,
+								  len, doff);
 				} else {
 					DHD_ERROR(("%s (nextlen): readahead on control" " packet %d?\n",
 						__func__, seq));
 					/* Force retry w/normal header read */
 					bus->nextlen = 0;
-					dhdsdio_rxfail(bus, false, true);
+					brcmf_sdbrcm_rxfail(bus, false, true);
 				}
-				dhdsdio_pktfree2(bus, pkt);
+				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
 
@@ -4073,8 +4092,8 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			if ((doff < SDPCM_HDRLEN) || (doff > len)) {
 				DHD_ERROR(("%s (nextlen): bad data offset %d: HW len %d min %d\n",
 					__func__, doff, len, SDPCM_HDRLEN));
-				dhdsdio_rxfail(bus, false, false);
-				dhdsdio_pktfree2(bus, pkt);
+				brcmf_sdbrcm_rxfail(bus, false, false);
+				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
 
@@ -4086,7 +4105,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			break;
 
 		/* Read frame header (hardware and software) */
-		sdret = bcmsdh_recv_buf(sdh, bcmsdh_cur_sbwad(sdh),
+		sdret = brcmf_sdcard_recv_buf(sdh, brcmf_sdcard_cur_sbwad(sdh),
 				SDIO_FUNC_2, F2SYNC, bus->rxhdr, firstread,
 				NULL, NULL, NULL);
 		bus->f2rxhdrs++;
@@ -4096,7 +4115,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			DHD_ERROR(("%s: RXHEADER FAILED: %d\n", __func__,
 				   sdret));
 			bus->rx_hdrfail++;
-			dhdsdio_rxfail(bus, true, true);
+			brcmf_sdbrcm_rxfail(bus, true, true);
 			continue;
 		}
 #ifdef DHD_DEBUG
@@ -4122,7 +4141,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			DHD_ERROR(("%s: HW hdr err: len/check 0x%04x/0x%04x\n",
 				__func__, len, check));
 			bus->rx_badhdr++;
-			dhdsdio_rxfail(bus, false, false);
+			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
 		}
 
@@ -4146,7 +4165,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				__func__, doff, len, SDPCM_HDRLEN, seq));
 			bus->rx_badhdr++;
 			ASSERT(0);
-			dhdsdio_rxfail(bus, false, false);
+			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
 		}
 
@@ -4192,7 +4211,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 		/* Call a separate function for control frames */
 		if (chan == SDPCM_CONTROL_CHANNEL) {
-			dhdsdio_read_control(bus, bus->rxhdr, len, doff);
+			brcmf_sdbrcm_read_control(bus, bus->rxhdr, len, doff);
 			continue;
 		}
 
@@ -4225,7 +4244,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				   __func__, len, rdlen));
 			bus->dhd->rx_errors++;
 			bus->rx_toolong++;
-			dhdsdio_rxfail(bus, false, false);
+			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
 		}
 
@@ -4235,7 +4254,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed: rdlen %d"
 				   " chan %d\n", __func__, rdlen, chan));
 			bus->dhd->rx_dropped++;
-			dhdsdio_rxfail(bus, false, RETRYCHAN(chan));
+			brcmf_sdbrcm_rxfail(bus, false, RETRYCHAN(chan));
 			continue;
 		}
 
@@ -4247,9 +4266,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		PKTALIGN(pkt, rdlen, DHD_SDALIGN);
 
 		/* Read the remaining frame data */
-		sdret = bcmsdh_recv_buf(sdh, bcmsdh_cur_sbwad(sdh), SDIO_FUNC_2,
-					F2SYNC, ((u8 *) (pkt->data)), rdlen,
-					pkt, NULL, NULL);
+		sdret = brcmf_sdcard_recv_buf(sdh, brcmf_sdcard_cur_sbwad(sdh),
+				SDIO_FUNC_2, F2SYNC, ((u8 *) (pkt->data)),
+				rdlen, pkt, NULL, NULL);
 		bus->f2rxdata++;
 		ASSERT(sdret != -BCME_PENDING);
 
@@ -4263,7 +4282,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				   sdret));
 			brcmu_pkt_buf_free_skb(pkt);
 			bus->dhd->rx_errors++;
-			dhdsdio_rxfail(bus, true, RETRYCHAN(chan));
+			brcmf_sdbrcm_rxfail(bus, true, RETRYCHAN(chan));
 			continue;
 		}
 
@@ -4300,7 +4319,7 @@ deliver:
 			} else {
 				DHD_ERROR(("%s: glom superframe w/o "
 					"descriptor!\n", __func__));
-				dhdsdio_rxfail(bus, false, false);
+				brcmf_sdbrcm_rxfail(bus, false, false);
 			}
 			continue;
 		}
@@ -4312,7 +4331,7 @@ deliver:
 #ifdef SDTEST
 		/* Test channel packets are processed separately */
 		if (chan == SDPCM_TEST_CHANNEL) {
-			dhdsdio_testrcv(bus, pkt, seq);
+			brcmf_sdbrcm_checkdied(bus, pkt, seq);
 			continue;
 		}
 #endif				/* SDTEST */
@@ -4349,7 +4368,7 @@ deliver:
 	return rxcount;
 }
 
-static u32 dhdsdio_hostmail(dhd_bus_t *bus)
+static u32 brcmf_sdbrcm_hostmail(dhd_bus_t *bus)
 {
 	struct sdpcmd_regs *regs = bus->regs;
 	u32 intstatus = 0;
@@ -4423,7 +4442,7 @@ static u32 dhdsdio_hostmail(dhd_bus_t *bus)
 	return intstatus;
 }
 
-bool dhdsdio_dpc(dhd_bus_t *bus)
+bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 {
 	bcmsdh_info_t *sdh = bus->sdh;
 	struct sdpcmd_regs *regs = bus->regs;
@@ -4449,8 +4468,8 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 
 #ifdef DHD_DEBUG
 		/* Check for inconsistent device control */
-		devctl =
-		    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL, &err);
+		devctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+					       SBSDIO_DEVICE_CTL, &err);
 		if (err) {
 			DHD_ERROR(("%s: error reading DEVCTL: %d\n",
 				   __func__, err));
@@ -4461,9 +4480,8 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 #endif				/* DHD_DEBUG */
 
 		/* Read CSR, if clock on switch to AVAIL, else ignore */
-		clkctl =
-		    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-				    &err);
+		clkctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			DHD_ERROR(("%s: error reading CSR: %d\n", __func__,
 				   err));
@@ -4474,17 +4492,16 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 			  clkctl));
 
 		if (SBSDIO_HTAV(clkctl)) {
-			devctl =
-			    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
-					    &err);
+			devctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+						       SBSDIO_DEVICE_CTL, &err);
 			if (err) {
 				DHD_ERROR(("%s: error reading DEVCTL: %d\n",
 					   __func__, err));
 				bus->dhd->busstate = DHD_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
-					 devctl, &err);
+			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+				SBSDIO_DEVICE_CTL, devctl, &err);
 			if (err) {
 				DHD_ERROR(("%s: error writing DEVCTL: %d\n",
 					   __func__, err));
@@ -4499,7 +4516,7 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 	BUS_WAKE(bus);
 
 	/* Make sure backplane clock is on */
-	dhdsdio_clkctl(bus, CLK_AVAIL, true);
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
 	if (bus->clkstate == CLK_PENDING)
 		goto clkwait;
 
@@ -4508,7 +4525,7 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 		bus->ipend = false;
 		R_SDREG(newstatus, &regs->intstatus, retries);
 		bus->f1regdata++;
-		if (bcmsdh_regfail(bus->sdh))
+		if (brcmf_sdcard_regfail(bus->sdh))
 			newstatus = 0;
 		newstatus &= bus->hostintmask;
 		bus->fcstate = !!(newstatus & I_HMB_FC_STATE);
@@ -4539,7 +4556,7 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 	/* Handle host mailbox indication */
 	if (intstatus & I_HMB_HOST_INT) {
 		intstatus &= ~I_HMB_HOST_INT;
-		intstatus |= dhdsdio_hostmail(bus);
+		intstatus |= brcmf_sdbrcm_hostmail(bus);
 	}
 
 	/* Generally don't ask for these, can get CRC errors... */
@@ -4570,7 +4587,7 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 
 	/* On frame indication, read available frames */
 	if (PKT_AVAILABLE()) {
-		framecnt = dhdsdio_readframes(bus, rxlimit, &rxdone);
+		framecnt = brcmf_sdbrcm_readframes(bus, rxlimit, &rxdone);
 		if (rxdone || bus->rxskip)
 			intstatus &= ~I_HMB_FRAME_IND;
 		rxlimit -= min(framecnt, rxlimit);
@@ -4581,28 +4598,26 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 
 clkwait:
 #if defined(OOB_INTR_ONLY)
-	bcmsdh_oob_intr_set(1);
+	brcmf_sdio_oob_intr_set(1);
 #endif				/* (OOB_INTR_ONLY) */
 	/* Re-enable interrupts to detect new device events (mailbox, rx frame)
 	 * or clock availability.  (Allows tx loop to check ipend if desired.)
 	 * (Unless register access seems hosed, as we may not be able to ACK...)
 	 */
-	if (bus->intr && bus->intdis && !bcmsdh_regfail(sdh)) {
+	if (bus->intr && bus->intdis && !brcmf_sdcard_regfail(sdh)) {
 		DHD_INTR(("%s: enable SDIO interrupts, rxdone %d framecnt %d\n",
 			  __func__, rxdone, framecnt));
 		bus->intdis = false;
-		bcmsdh_intr_enable(sdh);
+		brcmf_sdcard_intr_enable(sdh);
 	}
 
 	if (DATAOK(bus) && bus->ctrl_frame_stat &&
 		(bus->clkstate == CLK_AVAIL)) {
 		int ret, i;
 
-		ret =
-		    dhd_bcmsdh_send_buf(bus, bcmsdh_cur_sbwad(sdh), SDIO_FUNC_2,
-					F2SYNC, (u8 *) bus->ctrl_frame_buf,
-					(u32) bus->ctrl_frame_len, NULL,
-					NULL, NULL);
+		ret = brcmf_sdbrcm_send_buf(bus, brcmf_sdcard_cur_sbwad(sdh),
+			SDIO_FUNC_2, F2SYNC, (u8 *) bus->ctrl_frame_buf,
+			(u32) bus->ctrl_frame_len, NULL, NULL, NULL);
 		ASSERT(ret != -BCME_PENDING);
 
 		if (ret < 0) {
@@ -4612,19 +4627,19 @@ clkwait:
 				"terminate frame.\n", __func__, ret));
 			bus->tx_sderrs++;
 
-			bcmsdh_abort(sdh, SDIO_FUNC_2);
+			brcmf_sdcard_abort(sdh, SDIO_FUNC_2);
 
-			bcmsdh_cfg_write(sdh, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
 					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
 					 NULL);
 			bus->f1regdata++;
 
 			for (i = 0; i < 3; i++) {
 				u8 hi, lo;
-				hi = bcmsdh_cfg_read(sdh, SDIO_FUNC_1,
+				hi = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCHI,
 						     NULL);
-				lo = bcmsdh_cfg_read(sdh, SDIO_FUNC_1,
+				lo = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCLO,
 						     NULL);
 				bus->f1regdata += 2;
@@ -4645,7 +4660,7 @@ clkwait:
 		 brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
 		 && DATAOK(bus)) {
 		framecnt = rxdone ? txlimit : min(txlimit, dhd_txminmax);
-		framecnt = dhdsdio_sendfromq(bus, framecnt);
+		framecnt = brcmf_sdbrcm_sendfromq(bus, framecnt);
 		txlimit -= framecnt;
 	}
 
@@ -4653,9 +4668,9 @@ clkwait:
 		 else await next interrupt */
 	/* On failed register access, all bets are off:
 		 no resched or interrupts */
-	if ((bus->dhd->busstate == DHD_BUS_DOWN) || bcmsdh_regfail(sdh)) {
+	if ((bus->dhd->busstate == DHD_BUS_DOWN) || brcmf_sdcard_regfail(sdh)) {
 		DHD_ERROR(("%s: failed backplane access over SDIO, halting "
-			"operation %d\n", __func__, bcmsdh_regfail(sdh)));
+			"operation %d\n", __func__, brcmf_sdcard_regfail(sdh)));
 		bus->dhd->busstate = DHD_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
@@ -4674,7 +4689,7 @@ clkwait:
 	if ((bus->clkstate != CLK_PENDING)
 	    && bus->idletime == DHD_IDLE_IMMEDIATE) {
 		bus->activity = false;
-		dhdsdio_clkctl(bus, CLK_NONE, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 	}
 
 	dhd_os_sdunlock(bus->dhd);
@@ -4687,13 +4702,13 @@ bool dhd_bus_dpc(struct dhd_bus *bus)
 	bool resched;
 
 	/* Call the DPC directly. */
-	DHD_TRACE(("Calling dhdsdio_dpc() from %s\n", __func__));
-	resched = dhdsdio_dpc(bus);
+	DHD_TRACE(("Calling brcmf_sdbrcm_dpc() from %s\n", __func__));
+	resched = brcmf_sdbrcm_dpc(bus);
 
 	return resched;
 }
 
-void dhdsdio_isr(void *arg)
+void brcmf_sdbrcm_isr(void *arg)
 {
 	dhd_bus_t *bus = (dhd_bus_t *) arg;
 	bcmsdh_info_t *sdh;
@@ -4725,14 +4740,14 @@ void dhdsdio_isr(void *arg)
 	if (bus->intr)
 		DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
 	else
-		DHD_ERROR(("dhdsdio_isr() w/o interrupt configured!\n"));
+		DHD_ERROR(("brcmf_sdbrcm_isr() w/o interrupt configured!\n"));
 
-	bcmsdh_intr_disable(sdh);
+	brcmf_sdcard_intr_disable(sdh);
 	bus->intdis = true;
 
 #if defined(SDIO_ISR_THREAD)
-	DHD_TRACE(("Calling dhdsdio_dpc() from %s\n", __func__));
-	while (dhdsdio_dpc(bus))
+	DHD_TRACE(("Calling brcmf_sdbrcm_dpc() from %s\n", __func__));
+	while (brcmf_sdbrcm_dpc(bus))
 		;
 #else
 	bus->dpc_sched = true;
@@ -4742,7 +4757,7 @@ void dhdsdio_isr(void *arg)
 }
 
 #ifdef SDTEST
-static void dhdsdio_pktgen_init(dhd_bus_t *bus)
+static void brcmf_sdbrcm_pktgen_init(dhd_bus_t *bus)
 {
 	/* Default to specified length, or full range */
 	if (dhd_pktgen_len) {
@@ -4764,7 +4779,7 @@ static void dhdsdio_pktgen_init(dhd_bus_t *bus)
 	bus->pktgen_stop = 1;
 }
 
-static void dhdsdio_pktgen(dhd_bus_t *bus)
+static void brcmf_sdbrcm_pktgen(dhd_bus_t *bus)
 {
 	struct sk_buff *pkt;
 	u8 *data;
@@ -4782,7 +4797,7 @@ static void dhdsdio_pktgen(dhd_bus_t *bus)
 	/* For recv mode, just make sure dongle has started sending */
 	if (bus->pktgen_mode == DHD_PKTGEN_RECV) {
 		if (!bus->pktgen_rcvd)
-			dhdsdio_sdtest_set(bus, true);
+			brcmf_sdbrcm_sdtest_set(bus, true);
 		return;
 	}
 
@@ -4847,14 +4862,14 @@ static void dhdsdio_pktgen(dhd_bus_t *bus)
 #ifdef DHD_DEBUG
 		if (DHD_BYTES_ON() && DHD_DATA_ON()) {
 			data = (u8 *) (pkt->data) + SDPCM_HDRLEN;
-			printk(KERN_DEBUG "dhdsdio_pktgen: Tx Data:\n");
+			printk(KERN_DEBUG "brcmf_sdbrcm_pktgen: Tx Data:\n");
 			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, data,
 					     pkt->len - SDPCM_HDRLEN);
 		}
 #endif
 
 		/* Send it */
-		if (dhdsdio_txpkt(bus, pkt, SDPCM_TEST_CHANNEL, true)) {
+		if (brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_TEST_CHANNEL, true)) {
 			bus->pktgen_fail++;
 			if (bus->pktgen_stop
 			    && bus->pktgen_stop == bus->pktgen_fail)
@@ -4872,7 +4887,7 @@ static void dhdsdio_pktgen(dhd_bus_t *bus)
 	}
 }
 
-static void dhdsdio_sdtest_set(dhd_bus_t *bus, bool start)
+static void brcmf_sdbrcm_sdtest_set(dhd_bus_t *bus, bool start)
 {
 	struct sk_buff *pkt;
 	u8 *data;
@@ -4894,11 +4909,12 @@ static void dhdsdio_sdtest_set(dhd_bus_t *bus, bool start)
 	*data++ = (bus->pktgen_maxlen >> 8);
 
 	/* Send it */
-	if (dhdsdio_txpkt(bus, pkt, SDPCM_TEST_CHANNEL, true))
+	if (brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_TEST_CHANNEL, true))
 		bus->pktgen_fail++;
 }
 
-static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
+static void
+brcmf_sdbrcm_checkdied(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 {
 	u8 *data;
 	uint pktlen;
@@ -4911,8 +4927,8 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 	/* Check for min length */
 	pktlen = pkt->len;
 	if (pktlen < SDPCM_TEST_HDRLEN) {
-		DHD_ERROR(("dhdsdio_restrcv: toss runt frame, pktlen %d\n",
-			   pktlen));
+		DHD_ERROR(("brcmf_sdbrcm_checkdied: toss runt frame, pktlen "
+			   "%d\n", pktlen));
 		brcmu_pkt_buf_free_skb(pkt, false);
 		return;
 	}
@@ -4928,8 +4944,9 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 	if (cmd == SDPCM_TEST_DISCARD || cmd == SDPCM_TEST_ECHOREQ
 	    || cmd == SDPCM_TEST_ECHORSP) {
 		if (pktlen != len + SDPCM_TEST_HDRLEN) {
-			DHD_ERROR(("dhdsdio_testrcv: frame length mismatch, "
-				"pktlen %d seq %d" " cmd %d extra %d len %d\n",
+			DHD_ERROR(("brcmf_sdbrcm_checkdied: frame length "
+				"mismatch, pktlen %d seq %d" " cmd %d extra %d "
+				"len %d\n",
 				pktlen, seq, cmd, extra, len));
 			brcmu_pkt_buf_free_skb(pkt, false);
 			return;
@@ -4942,9 +4959,9 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 		/* Rx->Tx turnaround ok (even on NDIS w/current
 			 implementation) */
 		*(u8 *) (pkt->data) = SDPCM_TEST_ECHORSP;
-		if (dhdsdio_txpkt(bus, pkt, SDPCM_TEST_CHANNEL, true) == 0) {
+		if (brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_TEST_CHANNEL, true) == 0)
 			bus->pktgen_sent++;
-		} else {
+		else {
 			bus->pktgen_fail++;
 			brcmu_pkt_buf_free_skb(pkt, false);
 		}
@@ -4960,9 +4977,12 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 
 		for (offset = 0; offset < len; offset++, data++) {
 			if (*data != SDPCM_TEST_FILL(offset, extra)) {
-				DHD_ERROR(("dhdsdio_testrcv: echo data mismatch: " "offset %d (len %d) expect 0x%02x rcvd 0x%02x\n",
-					offset, len,
-					SDPCM_TEST_FILL(offset, extra), *data));
+				DHD_ERROR(("brcmf_sdbrcm_checkdied: echo data "
+					   "mismatch: " "offset %d (len %d) "
+					   "expect 0x%02x rcvd 0x%02x\n",
+					   offset, len,
+					   SDPCM_TEST_FILL(offset, extra),
+					   *data));
 				break;
 			}
 		}
@@ -4978,8 +4998,8 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 	case SDPCM_TEST_BURST:
 	case SDPCM_TEST_SEND:
 	default:
-		DHD_INFO(("dhdsdio_testrcv: unsupported or unknown command, "
-			"pktlen %d seq %d" " cmd %d extra %d len %d\n",
+		DHD_INFO(("brcmf_sdbrcm_checkdied: unsupported or unknown "
+			"command, pktlen %d seq %d" " cmd %d extra %d len %d\n",
 			pktlen, seq, cmd, extra, len));
 		brcmu_pkt_buf_free_skb(pkt, false);
 		break;
@@ -4990,13 +5010,13 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 		if (bus->pktgen_total
 		    && (bus->pktgen_rcvd >= bus->pktgen_total)) {
 			bus->pktgen_count = 0;
-			dhdsdio_sdtest_set(bus, false);
+			brcmf_sdbrcm_sdtest_set(bus, false);
 		}
 	}
 }
 #endif				/* SDTEST */
 
-extern bool dhd_bus_watchdog(dhd_pub_t *dhdp)
+extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 {
 	dhd_bus_t *bus;
 
@@ -5025,9 +5045,9 @@ extern bool dhd_bus_watchdog(dhd_pub_t *dhdp)
 
 			if (!bus->dpc_sched) {
 				u8 devpend;
-				devpend = bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_0,
-							  SDIO_CCCR_INTx,
-							  NULL);
+				devpend = brcmf_sdcard_cfg_read(bus->sdh,
+						SDIO_FUNC_0, SDIO_CCCR_INTx,
+						NULL);
 				intstatus =
 				    devpend & (INTR_STATUS_FUNC1 |
 					       INTR_STATUS_FUNC2);
@@ -5039,7 +5059,7 @@ extern bool dhd_bus_watchdog(dhd_pub_t *dhdp)
 				bus->pollcnt++;
 				bus->ipend = true;
 				if (bus->intr)
-					bcmsdh_intr_disable(bus->sdh);
+					brcmf_sdcard_intr_disable(bus->sdh);
 
 				bus->dpc_sched = true;
 				dhd_sched_dpc(bus->dhd);
@@ -5057,8 +5077,8 @@ extern bool dhd_bus_watchdog(dhd_pub_t *dhdp)
 		if (bus->console.count >= dhd_console_ms) {
 			bus->console.count -= dhd_console_ms;
 			/* Make sure backplane clock is on */
-			dhdsdio_clkctl(bus, CLK_AVAIL, false);
-			if (dhdsdio_readconsole(bus) < 0)
+			brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+			if (brcmf_sdbrcm_readconsole(bus) < 0)
 				dhd_console_ms = 0;	/* On error,
 							 stop trying */
 		}
@@ -5069,9 +5089,9 @@ extern bool dhd_bus_watchdog(dhd_pub_t *dhdp)
 	/* Generate packets if configured */
 	if (bus->pktgen_count && (++bus->pktgen_tick >= bus->pktgen_freq)) {
 		/* Make sure backplane clock is on */
-		dhdsdio_clkctl(bus, CLK_AVAIL, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 		bus->pktgen_tick = 0;
-		dhdsdio_pktgen(bus);
+		brcmf_sdbrcm_pktgen(bus);
 	}
 #endif
 
@@ -5083,7 +5103,7 @@ extern bool dhd_bus_watchdog(dhd_pub_t *dhdp)
 				bus->activity = false;
 				dhd_os_wd_timer(bus->dhd, dhd_watchdog_ms);
 			} else {
-				dhdsdio_clkctl(bus, CLK_NONE, false);
+				brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 			}
 		}
 	}
@@ -5094,7 +5114,8 @@ extern bool dhd_bus_watchdog(dhd_pub_t *dhdp)
 }
 
 #ifdef DHD_DEBUG
-extern int dhd_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg, uint msglen)
+extern int brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg,
+				       uint msglen)
 {
 	dhd_bus_t *bus = dhdp->bus;
 	u32 addr, val;
@@ -5117,25 +5138,25 @@ extern int dhd_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg, uint msglen)
 	/* Request clock to allow SDIO accesses */
 	BUS_WAKE(bus);
 	/* No pend allowed since txpkt is called later, ht clk has to be on */
-	dhdsdio_clkctl(bus, CLK_AVAIL, false);
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 	/* Zero cbuf_index */
 	addr = bus->console_addr + offsetof(rte_cons_t, cbuf_idx);
 	val = cpu_to_le32(0);
-	rv = dhdsdio_membytes(bus, true, addr, (u8 *)&val, sizeof(val));
+	rv = brcmf_sdbrcm_membytes(bus, true, addr, (u8 *)&val, sizeof(val));
 	if (rv < 0)
 		goto done;
 
 	/* Write message into cbuf */
 	addr = bus->console_addr + offsetof(rte_cons_t, cbuf);
-	rv = dhdsdio_membytes(bus, true, addr, (u8 *)msg, msglen);
+	rv = brcmf_sdbrcm_membytes(bus, true, addr, (u8 *)msg, msglen);
 	if (rv < 0)
 		goto done;
 
 	/* Write length into vcons_in */
 	addr = bus->console_addr + offsetof(rte_cons_t, vcons_in);
 	val = cpu_to_le32(msglen);
-	rv = dhdsdio_membytes(bus, true, addr, (u8 *)&val, sizeof(val));
+	rv = brcmf_sdbrcm_membytes(bus, true, addr, (u8 *)&val, sizeof(val));
 	if (rv < 0)
 		goto done;
 
@@ -5144,12 +5165,12 @@ extern int dhd_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg, uint msglen)
 	 */
 	pkt = brcmu_pkt_buf_get_skb(4 + SDPCM_RESERVE);
 	if ((pkt != NULL) && bus->clkstate == CLK_AVAIL)
-		dhdsdio_txpkt(bus, pkt, SDPCM_EVENT_CHANNEL, true);
+		brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_EVENT_CHANNEL, true);
 
 done:
 	if ((bus->idletime == DHD_IDLE_IMMEDIATE) && !bus->dpc_sched) {
 		bus->activity = false;
-		dhdsdio_clkctl(bus, CLK_NONE, true);
+		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
 
 	dhd_os_sdunlock(bus->dhd);
@@ -5158,7 +5179,7 @@ done:
 }
 #endif				/* DHD_DEBUG */
 
-static bool dhdsdio_chipmatch(u16 chipid)
+static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 {
 	if (chipid == BCM4325_CHIP_ID)
 		return true;
@@ -5169,7 +5190,7 @@ static bool dhdsdio_chipmatch(u16 chipid)
 	return false;
 }
 
-static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
+static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 			   u16 slot, u16 func, uint bustype, void *regsva,
 			   void *sdh)
 {
@@ -5261,8 +5282,8 @@ static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
 					 else use locally malloced rxbuf */
 
 	/* attempt to attach to the dongle */
-	if (!(dhdsdio_probe_attach(bus, sdh, regsva, devid))) {
-		DHD_ERROR(("%s: dhdsdio_probe_attach failed\n", __func__));
+	if (!(brcmf_sdbrcm_probe_attach(bus, sdh, regsva, devid))) {
+		DHD_ERROR(("%s: brcmf_sdbrcm_probe_attach failed\n", __func__));
 		goto fail;
 	}
 
@@ -5276,21 +5297,21 @@ static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
 	}
 
 	/* Allocate buffers */
-	if (!(dhdsdio_probe_malloc(bus, sdh))) {
-		DHD_ERROR(("%s: dhdsdio_probe_malloc failed\n", __func__));
+	if (!(brcmf_sdbrcm_probe_malloc(bus, sdh))) {
+		DHD_ERROR(("%s: brcmf_sdbrcm_probe_malloc failed\n", __func__));
 		goto fail;
 	}
 
-	if (!(dhdsdio_probe_init(bus, sdh))) {
-		DHD_ERROR(("%s: dhdsdio_probe_init failed\n", __func__));
+	if (!(brcmf_sdbrcm_probe_init(bus, sdh))) {
+		DHD_ERROR(("%s: brcmf_sdbrcm_probe_init failed\n", __func__));
 		goto fail;
 	}
 
 	/* Register interrupt callback, but mask it (not operational yet). */
 	DHD_INTR(("%s: disable SDIO interrupts (not interested yet)\n",
 		  __func__));
-	bcmsdh_intr_disable(sdh);
-	ret = bcmsdh_intr_reg(sdh, dhdsdio_isr, bus);
+	brcmf_sdcard_intr_disable(sdh);
+	ret = brcmf_sdcard_intr_reg(sdh, brcmf_sdbrcm_isr, bus);
 	if (ret != 0) {
 		DHD_ERROR(("%s: FAILED: bcmsdh_intr_reg returned %d\n",
 			   __func__, ret));
@@ -5317,12 +5338,13 @@ static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
 	return bus;
 
 fail:
-	dhdsdio_release(bus);
+	brcmf_sdbrcm_release(bus);
 	return NULL;
 }
 
 static bool
-dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
+brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
+			  u16 devid)
 {
 	u8 clkctl = 0;
 	int err = 0;
@@ -5330,52 +5352,52 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 	bus->alp_only = true;
 
 	/* Return the window to backplane enumeration space for core access */
-	if (dhdsdio_set_siaddr_window(bus, SI_ENUM_BASE))
+	if (brcmf_sdbrcm_set_siaddr_window(bus, SI_ENUM_BASE))
 		DHD_ERROR(("%s: FAILED to return to SI_ENUM_BASE\n", __func__));
 
 #ifdef DHD_DEBUG
 	printk(KERN_DEBUG "F1 signature read @0x18000000=0x%4x\n",
-	       bcmsdh_reg_read(bus->sdh, SI_ENUM_BASE, 4));
+	       brcmf_sdcard_reg_read(bus->sdh, SI_ENUM_BASE, 4));
 
 #endif				/* DHD_DEBUG */
 
 	/*
-	 * Force PLL off until dhdsdio_chip_attach()
+	 * Force PLL off until brcmf_sdbrcm_chip_attach()
 	 * programs PLL control regs
 	 */
 
-	bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
+	brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 			 DHD_INIT_CLKCTL1, &err);
 	if (!err)
 		clkctl =
-		    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-				    &err);
+		    brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != DHD_INIT_CLKCTL1)) {
-		DHD_ERROR(("dhdsdio_probe: ChipClkCSR access: err %d wrote "
-			"0x%02x read 0x%02x\n",
+		DHD_ERROR(("brcmf_sdbrcm_probe: ChipClkCSR access: err %d wrote"
+			" 0x%02x read 0x%02x\n",
 			err, DHD_INIT_CLKCTL1, clkctl));
 		goto fail;
 	}
 
-	if (dhdsdio_chip_attach(bus, regsva)) {
-		DHD_ERROR(("%s: dhdsdio_chip_attach failed!\n", __func__));
+	if (brcmf_sdbrcm_chip_attach(bus, regsva)) {
+		DHD_ERROR(("%s: brcmf_sdbrcm_chip_attach failed!\n", __func__));
 		goto fail;
 	}
 
-	bcmsdh_chipinfo(sdh, bus->ci->chip, bus->ci->chiprev);
+	brcmf_sdcard_chipinfo(sdh, bus->ci->chip, bus->ci->chiprev);
 
-	if (!dhdsdio_chipmatch((u16) bus->ci->chip)) {
+	if (!brcmf_sdbrcm_chipmatch((u16) bus->ci->chip)) {
 		DHD_ERROR(("%s: unsupported chip: 0x%04x\n",
 			   __func__, bus->ci->chip));
 		goto fail;
 	}
 
-	dhdsdio_sdiod_drive_strength_init(bus, dhd_sdiod_drive_strength);
+	brcmf_sdbrcm_sdiod_drive_strength_init(bus, dhd_sdiod_drive_strength);
 
 	/* Get info on the ARM and SOCRAM cores... */
 	if (!DHD_NOPMU(bus)) {
-		bus->armrev = SBCOREREV(bcmsdh_reg_read(bus->sdh,
+		bus->armrev = SBCOREREV(brcmf_sdcard_reg_read(bus->sdh,
 			CORE_SB(bus->ci->armcorebase, sbidhigh), 4));
 		bus->orig_ramsize = bus->ci->ramsize;
 		if (!(bus->orig_ramsize)) {
@@ -5385,7 +5407,7 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 		}
 		bus->ramsize = bus->orig_ramsize;
 		if (dhd_dongle_memsize)
-			dhd_dongle_setmemsize(bus, dhd_dongle_memsize);
+			brcmf_sdbrcm_setmemsize(bus, dhd_dongle_memsize);
 
 		DHD_ERROR(("DHD: dongle ram size is set to %d(orig %d)\n",
 			   bus->ramsize, bus->orig_ramsize));
@@ -5413,7 +5435,7 @@ fail:
 	return false;
 }
 
-static bool dhdsdio_probe_malloc(dhd_bus_t *bus, void *sdh)
+static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *sdh)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -5454,19 +5476,19 @@ fail:
 	return false;
 }
 
-static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh)
+static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh)
 {
 	s32 fnum;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 #ifdef SDTEST
-	dhdsdio_pktgen_init(bus);
+	brcmf_sdbrcm_pktgen_init(bus);
 #endif				/* SDTEST */
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	bcmsdh_cfg_write(sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx, SDIO_FUNC_ENABLE_1,
-			 NULL);
+	brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+			       SDIO_FUNC_ENABLE_1, NULL);
 
 	bus->dhd->busstate = DHD_BUS_DOWN;
 	bus->sleeping = false;
@@ -5474,7 +5496,8 @@ static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh)
 	bus->prev_rxlim_hit = 0;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-	bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
+	brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR, 0,
+			       NULL);
 
 	/* ...and initialize clock/power states */
 	bus->clkstate = CLK_SDONLY;
@@ -5483,7 +5506,7 @@ static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh)
 
 	/* Query the F2 block size, set roundup accordingly */
 	fnum = 2;
-	if (bcmsdh_iovar_op(sdh, "sd_blocksize", &fnum, sizeof(s32),
+	if (brcmf_sdcard_iovar_op(sdh, "sd_blocksize", &fnum, sizeof(s32),
 			    &bus->blocksize, sizeof(s32), false) != 0) {
 		bus->blocksize = 0;
 		DHD_ERROR(("%s: fail on %s get\n", __func__, "sd_blocksize"));
@@ -5495,7 +5518,7 @@ static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh)
 
 	/* Query if bus module supports packet chaining,
 		 default to use if supported */
-	if (bcmsdh_iovar_op(sdh, "sd_rxchain", NULL, 0,
+	if (brcmf_sdcard_iovar_op(sdh, "sd_rxchain", NULL, 0,
 			    &bus->sd_rxchain, sizeof(s32),
 			    false) != 0) {
 		bus->sd_rxchain = false;
@@ -5516,43 +5539,43 @@ dhd_bus_download_firmware(struct dhd_bus *bus, char *fw_path, char *nv_path)
 	bus->fw_path = fw_path;
 	bus->nv_path = nv_path;
 
-	ret = dhdsdio_download_firmware(bus, bus->sdh);
+	ret = brcmf_sdbrcm_download_firmware(bus, bus->sdh);
 
 	return ret;
 }
 
 static bool
-dhdsdio_download_firmware(struct dhd_bus *bus, void *sdh)
+brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *sdh)
 {
 	bool ret;
 
 	/* Download the firmware */
-	dhdsdio_clkctl(bus, CLK_AVAIL, false);
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
-	ret = _dhdsdio_download_firmware(bus) == 0;
+	ret = _brcmf_sdbrcm_download_firmware(bus) == 0;
 
-	dhdsdio_clkctl(bus, CLK_SDONLY, false);
+	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
 
 	return ret;
 }
 
 /* Detach and free everything */
-static void dhdsdio_release(dhd_bus_t *bus)
+static void brcmf_sdbrcm_release(dhd_bus_t *bus)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	if (bus) {
 		/* De-register interrupt handler */
-		bcmsdh_intr_disable(bus->sdh);
-		bcmsdh_intr_dereg(bus->sdh);
+		brcmf_sdcard_intr_disable(bus->sdh);
+		brcmf_sdcard_intr_dereg(bus->sdh);
 
 		if (bus->dhd) {
 			dhd_detach(bus->dhd);
-			dhdsdio_release_dongle(bus);
+			brcmf_sdbrcm_release_dongle(bus);
 			bus->dhd = NULL;
 		}
 
-		dhdsdio_release_malloc(bus);
+		brcmf_sdbrcm_release_malloc(bus);
 
 		kfree(bus);
 	}
@@ -5560,7 +5583,7 @@ static void dhdsdio_release(dhd_bus_t *bus)
 	DHD_TRACE(("%s: Disconnected\n", __func__));
 }
 
-static void dhdsdio_release_malloc(dhd_bus_t *bus)
+static void brcmf_sdbrcm_release_malloc(dhd_bus_t *bus)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -5575,7 +5598,7 @@ static void dhdsdio_release_malloc(dhd_bus_t *bus)
 	bus->databuf = NULL;
 }
 
-static void dhdsdio_release_dongle(dhd_bus_t *bus)
+static void brcmf_sdbrcm_release_dongle(dhd_bus_t *bus)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -5583,9 +5606,9 @@ static void dhdsdio_release_dongle(dhd_bus_t *bus)
 		return;
 
 	if (bus->ci) {
-		dhdsdio_clkctl(bus, CLK_AVAIL, false);
-		dhdsdio_clkctl(bus, CLK_NONE, false);
-		dhdsdio_chip_detach(bus);
+		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+		brcmf_sdbrcm_chip_detach(bus);
 		if (bus->vars && bus->varsz)
 			kfree(bus->vars);
 		bus->vars = NULL;
@@ -5594,7 +5617,7 @@ static void dhdsdio_release_dongle(dhd_bus_t *bus)
 	DHD_TRACE(("%s: Disconnected\n", __func__));
 }
 
-static void dhdsdio_disconnect(void *ptr)
+static void brcmf_sdbrcm_disconnect(void *ptr)
 {
 	dhd_bus_t *bus = (dhd_bus_t *)ptr;
 
@@ -5602,7 +5625,7 @@ static void dhdsdio_disconnect(void *ptr)
 
 	if (bus) {
 		ASSERT(bus->dhd);
-		dhdsdio_release(bus);
+		brcmf_sdbrcm_release(bus);
 	}
 
 	DHD_TRACE(("%s: Disconnected\n", __func__));
@@ -5614,25 +5637,25 @@ static void dhdsdio_disconnect(void *ptr)
  */
 
 static bcmsdh_driver_t dhd_sdio = {
-	dhdsdio_probe,
-	dhdsdio_disconnect
+	brcmf_sdbrcm_probe,
+	brcmf_sdbrcm_disconnect
 };
 
 int dhd_bus_register(void)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	return bcmsdh_register(&dhd_sdio);
+	return brcmf_sdio_register(&dhd_sdio);
 }
 
 void dhd_bus_unregister(void)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	bcmsdh_unregister();
+	brcmf_sdio_unregister();
 }
 
-static int dhdsdio_download_code_file(struct dhd_bus *bus, char *fw_path)
+static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus, char *fw_path)
 {
 	int bcmerror = -1;
 	int offset = 0;
@@ -5659,7 +5682,8 @@ static int dhdsdio_download_code_file(struct dhd_bus *bus, char *fw_path)
 	/* Download image */
 	while ((len =
 		dhd_os_get_image_block((char *)memptr, MEMBLOCK, image))) {
-		bcmerror = dhdsdio_membytes(bus, true, offset, memptr, len);
+		bcmerror = brcmf_sdbrcm_membytes(bus, true, offset, memptr,
+						 len);
 		if (bcmerror) {
 			DHD_ERROR(("%s: error %d on writing %d membytes at "
 			"0x%08x\n", __func__, bcmerror, MEMBLOCK, offset));
@@ -5687,7 +5711,7 @@ err:
  * by two NULs.
 */
 
-static uint process_nvram_vars(char *varbuf, uint len)
+static uint brcmf_process_nvram_vars(char *varbuf, uint len)
 {
 	char *dp;
 	bool findNewline;
@@ -5750,7 +5774,7 @@ void dhd_bus_set_nvram_params(struct dhd_bus *bus, const char *nvram_params)
 	bus->nvram_params = nvram_params;
 }
 
-static int dhdsdio_download_nvram(struct dhd_bus *bus)
+static int brcmf_sdbrcm_download_nvram(struct dhd_bus *bus)
 {
 	int bcmerror = -1;
 	uint len;
@@ -5793,11 +5817,12 @@ static int dhdsdio_download_nvram(struct dhd_bus *bus)
 	if (len > 0 && len < MEMBLOCK) {
 		bufp = (char *)memblock;
 		bufp[len] = 0;
-		len = process_nvram_vars(bufp, len);
+		len = brcmf_process_nvram_vars(bufp, len);
 		bufp += len;
 		*bufp++ = 0;
 		if (len)
-			bcmerror = dhdsdio_downloadvars(bus, memblock, len + 1);
+			bcmerror = brcmf_sdbrcm_downloadvars(bus, memblock,
+							   len + 1);
 		if (bcmerror) {
 			DHD_ERROR(("%s: error downloading vars: %d\n",
 				   __func__, bcmerror));
@@ -5817,7 +5842,7 @@ err:
 	return bcmerror;
 }
 
-static int _dhdsdio_download_firmware(struct dhd_bus *bus)
+static int _brcmf_sdbrcm_download_firmware(struct dhd_bus *bus)
 {
 	int bcmerror = -1;
 
@@ -5829,14 +5854,14 @@ static int _dhdsdio_download_firmware(struct dhd_bus *bus)
 		return bcmerror;
 
 	/* Keep arm in reset */
-	if (dhdsdio_download_state(bus, true)) {
+	if (brcmf_sdbrcm_download_state(bus, true)) {
 		DHD_ERROR(("%s: error placing ARM core in reset\n", __func__));
 		goto err;
 	}
 
 	/* External image takes precedence if specified */
 	if ((bus->fw_path != NULL) && (bus->fw_path[0] != '\0')) {
-		if (dhdsdio_download_code_file(bus, bus->fw_path)) {
+		if (brcmf_sdbrcm_download_code_file(bus, bus->fw_path)) {
 			DHD_ERROR(("%s: dongle image file download failed\n",
 				   __func__));
 			goto err;
@@ -5856,13 +5881,13 @@ static int _dhdsdio_download_firmware(struct dhd_bus *bus)
 	/* dhd_bus_set_nvram_params(bus, (char *)&nvram_array); */
 
 	/* External nvram takes precedence if specified */
-	if (dhdsdio_download_nvram(bus)) {
+	if (brcmf_sdbrcm_download_nvram(bus)) {
 		DHD_ERROR(("%s: dongle nvram file download failed\n",
 			   __func__));
 	}
 
 	/* Take arm out of reset */
-	if (dhdsdio_download_state(bus, false)) {
+	if (brcmf_sdbrcm_download_state(bus, false)) {
 		DHD_ERROR(("%s: error getting out of ARM core reset\n",
 			   __func__));
 		goto err;
@@ -5876,11 +5901,11 @@ err:
 
 
 static int
-dhd_bcmsdh_send_buf(dhd_bus_t *bus, u32 addr, uint fn, uint flags,
+brcmf_sdbrcm_send_buf(dhd_bus_t *bus, u32 addr, uint fn, uint flags,
 		    u8 *buf, uint nbytes, struct sk_buff *pkt,
 		    bcmsdh_cmplt_fn_t complete, void *handle)
 {
-	return bcmsdh_send_buf
+	return brcmf_sdcard_send_buf
 		(bus->sdh, addr, fn, flags, buf, nbytes, pkt, complete,
 		 handle);
 }
@@ -5918,11 +5943,11 @@ int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 			/* Expect app to have torn down any
 			 connection before calling */
 			/* Stop the bus, disable F2 */
-			dhd_bus_stop(bus, false);
+			brcmf_sdbrcm_bus_stop(bus, false);
 
 			/* Clean tx/rx buffer pointers,
 			 detach from the dongle */
-			dhdsdio_release_dongle(bus);
+			brcmf_sdbrcm_release_dongle(bus);
 
 			bus->dhd->dongle_reset = true;
 			bus->dhd->up = false;
@@ -5939,24 +5964,24 @@ int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 		if (bus->dhd->dongle_reset) {
 			/* Turn on WLAN */
 			/* Reset SD client */
-			bcmsdh_reset(bus->sdh);
+			brcmf_sdcard_reset(bus->sdh);
 
 			/* Attempt to re-attach & download */
-			if (dhdsdio_probe_attach(bus, bus->sdh,
+			if (brcmf_sdbrcm_probe_attach(bus, bus->sdh,
 						 (u32 *) SI_ENUM_BASE,
 						 bus->cl_devid)) {
 				/* Attempt to download binary to the dongle */
-				if (dhdsdio_probe_init
+				if (brcmf_sdbrcm_probe_init
 				    (bus, bus->sdh)
-				    && dhdsdio_download_firmware(bus,
+				    && brcmf_sdbrcm_download_firmware(bus,
 								 bus->sdh)) {
 
 					/* Re-init bus, enable F2 transfer */
-					dhd_bus_init((dhd_pub_t *) bus->dhd,
-						     false);
+					brcmf_sdbrcm_bus_init(
+						(dhd_pub_t *) bus->dhd, false);
 
 #if defined(OOB_INTR_ONLY)
-					dhd_enable_oob_intr(bus, true);
+					brcmf_sdbrcm_enable_oob_intr(bus, true);
 #endif				/* defined(OOB_INTR_ONLY) */
 
 					bus->dhd->dongle_reset = false;
@@ -5979,7 +6004,8 @@ int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 }
 
 static int
-dhdsdio_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci, void *regs)
+brcmf_sdbrcm_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci,
+			    void *regs)
 {
 	u32 regdata;
 
@@ -5990,7 +6016,8 @@ dhdsdio_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci, void *regs)
 	 * other ways of recognition should be added here.
 	 */
 	ci->cccorebase = (u32)regs;
-	regdata = bcmsdh_reg_read(sdh, CORE_CC_REG(ci->cccorebase, chipid), 4);
+	regdata = brcmf_sdcard_reg_read(sdh,
+				CORE_CC_REG(ci->cccorebase, chipid), 4);
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 
@@ -6011,15 +6038,16 @@ dhdsdio_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci, void *regs)
 		return -ENODEV;
 	}
 
-	regdata = bcmsdh_reg_read(sdh,
+	regdata = brcmf_sdcard_reg_read(sdh,
 		CORE_SB(ci->cccorebase, sbidhigh), 4);
 	ci->ccrev = SBCOREREV(regdata);
 
-	regdata = bcmsdh_reg_read(sdh,
+	regdata = brcmf_sdcard_reg_read(sdh,
 		CORE_CC_REG(ci->cccorebase, pmucapabilities), 4);
 	ci->pmurev = regdata & PCAP_REV_MASK;
 
-	regdata = bcmsdh_reg_read(sdh, CORE_SB(ci->buscorebase, sbidhigh), 4);
+	regdata = brcmf_sdcard_reg_read(sdh,
+					CORE_SB(ci->buscorebase, sbidhigh), 4);
 	ci->buscorerev = SBCOREREV(regdata);
 	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
 
@@ -6028,93 +6056,93 @@ dhdsdio_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci, void *regs)
 		ci->buscorerev, ci->buscoretype));
 
 	/* get chipcommon capabilites */
-	ci->cccaps = bcmsdh_reg_read(sdh,
+	ci->cccaps = brcmf_sdcard_reg_read(sdh,
 		CORE_CC_REG(ci->cccorebase, capabilities), 4);
 
 	return 0;
 }
 
 static void
-dhdsdio_chip_disablecore(bcmsdh_info_t *sdh, u32 corebase)
+brcmf_sdbrcm_chip_disablecore(bcmsdh_info_t *sdh, u32 corebase)
 {
 	u32 regdata;
 
-	regdata = bcmsdh_reg_read(sdh,
+	regdata = brcmf_sdcard_reg_read(sdh,
 		CORE_SB(corebase, sbtmstatelow), 4);
 	if (regdata & SBTML_RESET)
 		return;
 
-	regdata = bcmsdh_reg_read(sdh,
+	regdata = brcmf_sdcard_reg_read(sdh,
 		CORE_SB(corebase, sbtmstatelow), 4);
 	if ((regdata & (SICF_CLOCK_EN << SBTML_SICF_SHIFT)) != 0) {
 		/*
 		 * set target reject and spin until busy is clear
 		 * (preserve core-specific bits)
 		 */
-		regdata = bcmsdh_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(sdh,
 			CORE_SB(corebase, sbtmstatelow), 4);
-		bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+		brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
 			regdata | SBTML_REJ);
 
-		regdata = bcmsdh_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(sdh,
 			CORE_SB(corebase, sbtmstatelow), 4);
 		udelay(1);
-		SPINWAIT((bcmsdh_reg_read(sdh,
+		SPINWAIT((brcmf_sdcard_reg_read(sdh,
 			CORE_SB(corebase, sbtmstatehigh), 4) &
 			SBTMH_BUSY), 100000);
 
-		regdata = bcmsdh_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(sdh,
 			CORE_SB(corebase, sbtmstatehigh), 4);
 		if (regdata & SBTMH_BUSY)
 			DHD_ERROR(("%s: ARM core still busy\n", __func__));
 
-		regdata = bcmsdh_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(sdh,
 			CORE_SB(corebase, sbidlow), 4);
 		if (regdata & SBIDL_INIT) {
-			regdata = bcmsdh_reg_read(sdh,
+			regdata = brcmf_sdcard_reg_read(sdh,
 				CORE_SB(corebase, sbimstate), 4) |
 				SBIM_RJ;
-			bcmsdh_reg_write(sdh,
+			brcmf_sdcard_reg_write(sdh,
 				CORE_SB(corebase, sbimstate), 4,
 				regdata);
-			regdata = bcmsdh_reg_read(sdh,
+			regdata = brcmf_sdcard_reg_read(sdh,
 				CORE_SB(corebase, sbimstate), 4);
 			udelay(1);
-			SPINWAIT((bcmsdh_reg_read(sdh,
+			SPINWAIT((brcmf_sdcard_reg_read(sdh,
 				CORE_SB(corebase, sbimstate), 4) &
 				SBIM_BY), 100000);
 		}
 
 		/* set reset and reject while enabling the clocks */
-		bcmsdh_reg_write(sdh,
+		brcmf_sdcard_reg_write(sdh,
 			CORE_SB(corebase, sbtmstatelow), 4,
 			(((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
 			SBTML_REJ | SBTML_RESET));
-		regdata = bcmsdh_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(sdh,
 			CORE_SB(corebase, sbtmstatelow), 4);
 		udelay(10);
 
 		/* clear the initiator reject bit */
-		regdata = bcmsdh_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(sdh,
 			CORE_SB(corebase, sbidlow), 4);
 		if (regdata & SBIDL_INIT) {
-			regdata = bcmsdh_reg_read(sdh,
+			regdata = brcmf_sdcard_reg_read(sdh,
 				CORE_SB(corebase, sbimstate), 4) &
 				~SBIM_RJ;
-			bcmsdh_reg_write(sdh,
+			brcmf_sdcard_reg_write(sdh,
 				CORE_SB(corebase, sbimstate), 4,
 				regdata);
 		}
 	}
 
 	/* leave reset and reject asserted */
-	bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
 		(SBTML_REJ | SBTML_RESET));
 	udelay(1);
 }
 
 static int
-dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
+brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs)
 {
 	struct chip_info *ci;
 	int err;
@@ -6134,7 +6162,7 @@ dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
 	/* bus/core/clk setup for register access */
 	/* Try forcing SDIO core to do ALPAvail request only */
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
-	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
+	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 			clkset, &err);
 	if (err) {
 		DHD_ERROR(("%s: error writing for HT off\n", __func__));
@@ -6143,11 +6171,11 @@ dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
 
 	/* If register supported, wait for ALPAvail and then force ALP */
 	/* This may take up to 15 milliseconds */
-	clkval = bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_1,
+	clkval = brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR, NULL);
 	if ((clkval & ~SBSDIO_AVBITS) == clkset) {
 		SPINWAIT(((clkval =
-				bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_1,
+				brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_1,
 						SBSDIO_FUNC1_CHIPCLKCSR,
 						NULL)),
 				!SBSDIO_ALPAV(clkval)),
@@ -6160,7 +6188,7 @@ dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
 		}
 		clkset = SBSDIO_FORCE_HW_CLKREQ_OFF |
 				SBSDIO_FORCE_ALP;
-		bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1,
 				SBSDIO_FUNC1_CHIPCLKCSR,
 				clkset, &err);
 		udelay(65);
@@ -6172,10 +6200,10 @@ dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
 	}
 
 	/* Also, disable the extra SDIO pull-ups */
-	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_SDIOPULLUP, 0,
-			 NULL);
+	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_SDIOPULLUP,
+			       0, NULL);
 
-	err = dhdsdio_chip_recognition(bus->sdh, ci, regs);
+	err = brcmf_sdbrcm_chip_recognition(bus->sdh, ci, regs);
 	if (err)
 		goto fail;
 
@@ -6183,24 +6211,24 @@ dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
 	 * Make sure any on-chip ARM is off (in case strapping is wrong),
 	 * or downloaded code was already running.
 	 */
-	dhdsdio_chip_disablecore(bus->sdh, ci->armcorebase);
+	brcmf_sdbrcm_chip_disablecore(bus->sdh, ci->armcorebase);
 
-	bcmsdh_reg_write(bus->sdh,
+	brcmf_sdcard_reg_write(bus->sdh,
 		CORE_CC_REG(ci->cccorebase, gpiopullup), 4, 0);
-	bcmsdh_reg_write(bus->sdh,
+	brcmf_sdcard_reg_write(bus->sdh,
 		CORE_CC_REG(ci->cccorebase, gpiopulldown), 4, 0);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 		SDIO_FUNC_ENABLE_1, NULL);
 
 	/* WAR: cmd52 backplane read so core HW will drop ALPReq */
-	clkval = bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_1,
+	clkval = brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_1,
 			0, NULL);
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR, 0,
-			 NULL);
+	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
+			       0, NULL);
 
 	bus->ci = ci;
 	return 0;
@@ -6211,7 +6239,7 @@ fail:
 }
 
 static void
-dhdsdio_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase)
+brcmf_sdbrcm_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase)
 {
 	u32 regdata;
 
@@ -6219,35 +6247,37 @@ dhdsdio_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase)
 	 * Must do the disable sequence first to work for
 	 * arbitrary current core state.
 	 */
-	dhdsdio_chip_disablecore(sdh, corebase);
+	brcmf_sdbrcm_chip_disablecore(sdh, corebase);
 
 	/*
 	 * Now do the initialization sequence.
 	 * set reset while enabling the clock and
 	 * forcing them on throughout the core
 	 */
-	bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
 		((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
 		SBTML_RESET);
 	udelay(1);
 
-	regdata = bcmsdh_reg_read(sdh, CORE_SB(corebase, sbtmstatehigh), 4);
+	regdata = brcmf_sdcard_reg_read(sdh, CORE_SB(corebase, sbtmstatehigh),
+					4);
 	if (regdata & SBTMH_SERR)
-		bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatehigh), 4, 0);
+		brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatehigh),
+				       4, 0);
 
-	regdata = bcmsdh_reg_read(sdh, CORE_SB(corebase, sbimstate), 4);
+	regdata = brcmf_sdcard_reg_read(sdh, CORE_SB(corebase, sbimstate), 4);
 	if (regdata & (SBIM_IBE | SBIM_TO))
-		bcmsdh_reg_write(sdh, CORE_SB(corebase, sbimstate), 4,
+		brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbimstate), 4,
 			regdata & ~(SBIM_IBE | SBIM_TO));
 
 	/* clear reset and allow it to propagate throughout the core */
-	bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
 		(SICF_FGC << SBTML_SICF_SHIFT) |
 		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
 	udelay(1);
 
 	/* leave clock enabled */
-	bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
 		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
 	udelay(1);
 }
@@ -6295,7 +6325,7 @@ static const struct sdiod_drive_str sdiod_drive_strength_tab3[] = {
 #define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
 
 static void
-dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
+brcmf_sdbrcm_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
 	struct sdiod_drive_str *str_tab = NULL;
 	u32 str_mask = 0;
 	u32 str_shift = 0;
@@ -6341,15 +6371,15 @@ dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
 			}
 		}
 
-		bcmsdh_reg_write(bus->sdh,
+		brcmf_sdcard_reg_write(bus->sdh,
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
 			4, 1);
-		cc_data_temp = bcmsdh_reg_read(bus->sdh,
+		cc_data_temp = brcmf_sdcard_reg_read(bus->sdh,
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr), 4);
 		cc_data_temp &= ~str_mask;
 		drivestrength_sel <<= str_shift;
 		cc_data_temp |= drivestrength_sel;
-		bcmsdh_reg_write(bus->sdh,
+		brcmf_sdcard_reg_write(bus->sdh,
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
 			4, cc_data_temp);
 
@@ -6359,7 +6389,7 @@ dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
 }
 
 static void
-dhdsdio_chip_detach(struct dhd_bus *bus)
+brcmf_sdbrcm_chip_detach(struct dhd_bus *bus)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 7fa79d6..4063508 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -70,25 +70,26 @@ typedef void (*bcmsdh_cb_fn_t) (void *);
  *    implementation may maintain a single "default" handle (e.g. the first or
  *    most recent one) to enable single-instance implementations to pass NULL.
  */
-extern bcmsdh_info_t *bcmsdh_attach(void *cfghdl, void **regsva, uint irq);
+extern bcmsdh_info_t *brcmf_sdcard_attach(void *cfghdl, void **regsva,
+					  uint irq);
 
 /* Detach - freeup resources allocated in attach */
-extern int bcmsdh_detach(void *sdh);
+extern int brcmf_sdcard_detach(void *sdh);
 
 /* Query if SD device interrupts are enabled */
-extern bool bcmsdh_intr_query(void *sdh);
+extern bool brcmf_sdcard_intr_query(void *sdh);
 
 /* Enable/disable SD interrupt */
-extern int bcmsdh_intr_enable(void *sdh);
-extern int bcmsdh_intr_disable(void *sdh);
+extern int brcmf_sdcard_intr_enable(void *sdh);
+extern int brcmf_sdcard_intr_disable(void *sdh);
 
 /* Register/deregister device interrupt handler. */
-extern int bcmsdh_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh);
-extern int bcmsdh_intr_dereg(void *sdh);
+extern int brcmf_sdcard_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh);
+extern int brcmf_sdcard_intr_dereg(void *sdh);
 
 #if defined(DHD_DEBUG)
 /* Query pending interrupt status from the host controller */
-extern bool bcmsdh_intr_pending(void *sdh);
+extern bool brcmf_sdcard_intr_pending(void *sdh);
 #endif
 extern int bcmsdh_claim_host_and_lock(void *sdh);
 extern int bcmsdh_release_host_and_unlock(void *sdh);
@@ -96,7 +97,7 @@ extern int bcmsdh_release_host_and_unlock(void *sdh);
 /* Register a callback to be called if and when bcmsdh detects
  * device removal. No-op in the case of non-removable/hardwired devices.
  */
-extern int bcmsdh_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh);
+extern int brcmf_sdcard_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh);
 
 /* Access SDIO address space (e.g. CCCR) using CMD52 (single-byte interface).
  *   fn:   function number
@@ -104,14 +105,14 @@ extern int bcmsdh_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh);
  *   data: data byte to write
  *   err:  pointer to error code (or NULL)
  */
-extern u8 bcmsdh_cfg_read(void *sdh, uint func, u32 addr, int *err);
-extern void bcmsdh_cfg_write(void *sdh, uint func, u32 addr, u8 data,
+extern u8 brcmf_sdcard_cfg_read(void *sdh, uint func, u32 addr, int *err);
+extern void brcmf_sdcard_cfg_write(void *sdh, uint func, u32 addr, u8 data,
 			     int *err);
 
 /* Read/Write 4bytes from/to cfg space */
-extern u32 bcmsdh_cfg_read_word(void *sdh, uint fnc_num, u32 addr,
+extern u32 brcmf_sdcard_cfg_read_word(void *sdh, uint fnc_num, u32 addr,
 				   int *err);
-extern void bcmsdh_cfg_write_word(void *sdh, uint fnc_num, u32 addr,
+extern void brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr,
 				  u32 data, int *err);
 
 /* Read CIS content for specified function.
@@ -121,18 +122,18 @@ extern void bcmsdh_cfg_write_word(void *sdh, uint fnc_num, u32 addr,
  * Internally, this routine uses the values from the cis base regs (0x9-0xB)
  * to form an SDIO-space address to read the data from.
  */
-extern int bcmsdh_cis_read(void *sdh, uint func, u8 *cis, uint length);
+extern int brcmf_sdcard_cis_read(void *sdh, uint func, u8 *cis, uint length);
 
 /* Synchronous access to device (client) core registers via CMD53 to F1.
  *   addr: backplane address (i.e. >= regsva from attach)
  *   size: register width in bytes (2 or 4)
  *   data: data for register write
  */
-extern u32 bcmsdh_reg_read(void *sdh, u32 addr, uint size);
-extern u32 bcmsdh_reg_write(void *sdh, u32 addr, uint size, u32 data);
+extern u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size);
+extern u32 brcmf_sdcard_reg_write(void *sdh, u32 addr, uint size, u32 data);
 
 /* Indicate if last reg read/write failed */
-extern bool bcmsdh_regfail(void *sdh);
+extern bool brcmf_sdcard_regfail(void *sdh);
 
 /* Buffer transfer to/from device (client) core via cmd53.
  *   fn:       function number
@@ -147,12 +148,12 @@ extern bool bcmsdh_regfail(void *sdh);
  * NOTE: Async operation is not currently supported.
  */
 typedef void (*bcmsdh_cmplt_fn_t) (void *handle, int status, bool sync_waiting);
-extern int bcmsdh_send_buf(void *sdh, u32 addr, uint fn, uint flags,
-			   u8 *buf, uint nbytes, void *pkt,
-			   bcmsdh_cmplt_fn_t complete, void *handle);
-extern int bcmsdh_recv_buf(bcmsdh_info_t *sdh, u32 addr, uint fn, uint flags,
-			   u8 *buf, uint nbytes, struct sk_buff *pkt,
-			   bcmsdh_cmplt_fn_t complete, void *handle);
+extern int brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
+		u8 *buf, uint nbytes, void *pkt,
+		bcmsdh_cmplt_fn_t complete, void *handle);
+extern int brcmf_sdcard_recv_buf(bcmsdh_info_t *sdh, u32 addr, uint fn,
+		uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt,
+		bcmsdh_cmplt_fn_t complete, void *handle);
 
 /* Flags bits */
 #define SDIO_REQ_4BYTE	0x1	/* Four-byte target (backplane) width (vs. two-byte) */
@@ -169,35 +170,35 @@ extern int bcmsdh_recv_buf(bcmsdh_info_t *sdh, u32 addr, uint fn, uint flags,
  *   nbytes:   number of bytes to transfer to/from buf
  * Returns 0 or error code.
  */
-extern int bcmsdh_rwdata(void *sdh, uint rw, u32 addr, u8 *buf,
+extern int brcmf_sdcard_rwdata(void *sdh, uint rw, u32 addr, u8 *buf,
 			 uint nbytes);
 
 /* Issue an abort to the specified function */
-extern int bcmsdh_abort(void *sdh, uint fn);
+extern int brcmf_sdcard_abort(void *sdh, uint fn);
 
 /* Start SDIO Host Controller communication */
-extern int bcmsdh_start(void *sdh, int stage);
+extern int brcmf_sdcard_start(void *sdh, int stage);
 
 /* Stop SDIO Host Controller communication */
-extern int bcmsdh_stop(void *sdh);
+extern int brcmf_sdcard_stop(void *sdh);
 
 /* Returns the "Device ID" of target device on the SDIO bus. */
-extern int bcmsdh_query_device(void *sdh);
+extern int brcmf_sdcard_query_device(void *sdh);
 
 /* Returns the number of IO functions reported by the device */
-extern uint bcmsdh_query_iofnum(void *sdh);
+extern uint brcmf_sdcard_query_iofnum(void *sdh);
 
 /* Miscellaneous knob tweaker. */
-extern int bcmsdh_iovar_op(void *sdh, const char *name,
+extern int brcmf_sdcard_iovar_op(void *sdh, const char *name,
 			   void *params, int plen, void *arg, int len,
 			   bool set);
 
 /* Reset and reinitialize the device */
-extern int bcmsdh_reset(bcmsdh_info_t *sdh);
+extern int brcmf_sdcard_reset(bcmsdh_info_t *sdh);
 
 /* helper functions */
 
-extern void *bcmsdh_get_sdioh(bcmsdh_info_t *sdh);
+extern void *brcmf_sdcard_get_sdioh(bcmsdh_info_t *sdh);
 
 /* callback functions */
 typedef struct {
@@ -209,18 +210,18 @@ typedef struct {
 } bcmsdh_driver_t;
 
 /* platform specific/high level functions */
-extern int bcmsdh_register(bcmsdh_driver_t *driver);
-extern void bcmsdh_unregister(void);
-extern bool bcmsdh_chipmatch(u16 vendor, u16 device);
-extern void bcmsdh_device_remove(void *sdh);
+extern int brcmf_sdio_register(bcmsdh_driver_t *driver);
+extern void brcmf_sdio_unregister(void);
+extern bool brcmf_sdio_chipmatch(u16 vendor, u16 device);
+extern void brcmf_sdio_device_remove(void *sdh);
 
 /* Function to pass device-status bits to DHD. */
-extern u32 bcmsdh_get_dstatus(void *sdh);
+extern u32 brcmf_sdcard_get_dstatus(void *sdh);
 
 /* Function to return current window addr */
-extern u32 bcmsdh_cur_sbwad(void *sdh);
+extern u32 brcmf_sdcard_cur_sbwad(void *sdh);
 
 /* Function to pass chipid and rev to lower layers for controlling pr's */
-extern void bcmsdh_chipinfo(void *sdh, u32 chip, u32 chiprev);
+extern void brcmf_sdcard_chipinfo(void *sdh, u32 chip, u32 chiprev);
 
 #endif				/* _BRCM_SDH_H_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 3bccc22..915546c 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -36,7 +36,7 @@
 #include "dhd.h"
 #include "wl_cfg80211.h"
 
-void sdioh_sdio_set_host_pm_flags(int flag);
+void brcmf_sdioh_set_host_pm_flags(int flag);
 
 static struct sdio_func *cfg80211_sdio_func;
 static struct wl_dev *wl_cfg80211_dev;
@@ -2155,7 +2155,7 @@ static s32 wl_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
 	clear_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
 
 	/* Inform SDIO stack not to switch off power to the chip */
-	sdioh_sdio_set_host_pm_flags(MMC_PM_KEEP_POWER);
+	brcmf_sdioh_set_host_pm_flags(MMC_PM_KEEP_POWER);
 
 	/* Turn off watchdog timer */
 	if (test_bit(WL_STATUS_READY, &wl->status)) {
-- 
1.7.1


