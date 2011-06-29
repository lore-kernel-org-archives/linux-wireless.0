Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4583 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758106Ab1F2XtB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:01 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 057/119] staging: brcm80211: replaced typedef
 bcmsdh_info_t by struct brcmf_sdio
Date: Wed, 29 Jun 2011 16:47:21 -0700
Message-ID: <1309391303-22741-58-git-send-email-frankyl@broadcom.com> (sfid-20110630_015139_230946_065670F7)
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
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h     |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   70 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   30 +++++-----
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |   10 ++--
 5 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index ffe258a..5d09076 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -111,6 +111,6 @@ extern int brcmf_sdioh_stop(struct sdioh_info *si);
 extern int brcmf_sdioh_reset(struct sdioh_info *si);
 
 /* Helper function */
-void *brcmf_sdcard_get_sdioh(bcmsdh_info_t *sdh);
+void *brcmf_sdcard_get_sdioh(struct brcmf_sdio *sdh);
 
 #endif				/* _sdio_api_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index f41bb1e..0ebca53 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -33,7 +33,7 @@
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 const uint bcmsdh_msglevel = BCMSDH_ERROR_VAL;
 
-struct bcmsdh_info {
+struct brcmf_sdio {
 	bool init_success;	/* underlying driver successfully attached */
 	void *sdioh;		/* handler for sdioh */
 	u32 vendevid;	/* Target Vendor and Device ID on SD bus */
@@ -42,22 +42,22 @@ struct bcmsdh_info {
 	u32 sbwad;		/* Save backplane window address */
 };
 /* local copy of bcm sd handler */
-bcmsdh_info_t *l_bcmsdh;
+struct brcmf_sdio *l_bcmsdh;
 
 #if defined(OOB_INTR_ONLY) && defined(HW_OOB)
 extern int brcmf_sdioh_enable_hw_oob_intr(void *sdioh, bool enable);
 
-void brcmf_sdcard_enable_hw_oob_intr(bcmsdh_info_t *sdh, bool enable)
+void brcmf_sdcard_enable_hw_oob_intr(struct brcmf_sdio *sdh, bool enable)
 {
 	brcmf_sdioh_enable_hw_oob_intr(sdh->sdioh, enable);
 }
 #endif
 
-bcmsdh_info_t *brcmf_sdcard_attach(void *cfghdl, void **regsva, uint irq)
+struct brcmf_sdio *brcmf_sdcard_attach(void *cfghdl, void **regsva, uint irq)
 {
-	bcmsdh_info_t *bcmsdh;
+	struct brcmf_sdio *bcmsdh;
 
-	bcmsdh = kzalloc(sizeof(bcmsdh_info_t), GFP_ATOMIC);
+	bcmsdh = kzalloc(sizeof(struct brcmf_sdio), GFP_ATOMIC);
 	if (bcmsdh == NULL) {
 		BCMSDH_ERROR(("bcmsdh_attach: out of memory"));
 		return NULL;
@@ -83,7 +83,7 @@ bcmsdh_info_t *brcmf_sdcard_attach(void *cfghdl, void **regsva, uint irq)
 
 int brcmf_sdcard_detach(void *sdh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 
 	if (bcmsdh != NULL) {
 		if (bcmsdh->sdioh) {
@@ -101,14 +101,14 @@ int
 brcmf_sdcard_iovar_op(void *sdh, const char *name,
 		void *params, int plen, void *arg, int len, bool set)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	return brcmf_sdioh_iovar_op(bcmsdh->sdioh, name, params, plen, arg,
 				    len, set);
 }
 
 bool brcmf_sdcard_intr_query(void *sdh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 	bool on;
 
@@ -122,7 +122,7 @@ bool brcmf_sdcard_intr_query(void *sdh)
 
 int brcmf_sdcard_intr_enable(void *sdh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 	ASSERT(bcmsdh);
 
@@ -132,7 +132,7 @@ int brcmf_sdcard_intr_enable(void *sdh)
 
 int brcmf_sdcard_intr_disable(void *sdh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 	ASSERT(bcmsdh);
 
@@ -142,7 +142,7 @@ int brcmf_sdcard_intr_disable(void *sdh)
 
 int brcmf_sdcard_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 	ASSERT(bcmsdh);
 
@@ -152,7 +152,7 @@ int brcmf_sdcard_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 
 int brcmf_sdcard_intr_dereg(void *sdh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 	ASSERT(bcmsdh);
 
@@ -163,7 +163,7 @@ int brcmf_sdcard_intr_dereg(void *sdh)
 #if defined(DHD_DEBUG)
 bool brcmf_sdcard_intr_pending(void *sdh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 
 	ASSERT(sdh);
 	return brcmf_sdioh_interrupt_pending(bcmsdh->sdioh);
@@ -180,7 +180,7 @@ int brcmf_sdcard_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 
 u8 brcmf_sdcard_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	s32 retry = 0;
@@ -216,7 +216,7 @@ u8 brcmf_sdcard_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 void
 brcmf_sdcard_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	s32 retry = 0;
@@ -248,7 +248,7 @@ brcmf_sdcard_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 
 u32 brcmf_sdcard_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 	u32 data = 0;
 
@@ -273,7 +273,7 @@ void
 brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 		      int *err)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 
 	if (!bcmsdh)
@@ -294,7 +294,7 @@ brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 
 int brcmf_sdcard_cis_read(void *sdh, uint func, u8 * cis, uint length)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 
 	u8 *tmp_buf, *tmp_ptr;
@@ -335,7 +335,7 @@ int brcmf_sdcard_cis_read(void *sdh, uint func, u8 * cis, uint length)
 static int brcmf_sdcard_set_sbaddr_window(void *sdh, u32 address)
 {
 	int err = 0;
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	brcmf_sdcard_cfg_write(bcmsdh, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
 			 (address >> 8) & SBSDIO_SBADDRLOW_MASK, &err);
 	if (!err)
@@ -354,7 +354,7 @@ static int brcmf_sdcard_set_sbaddr_window(void *sdh, u32 address)
 
 u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 	u32 word = 0;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
@@ -407,7 +407,7 @@ u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size)
 
 u32 brcmf_sdcard_reg_write(void *sdh, u32 addr, uint size, u32 data)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
@@ -446,11 +446,11 @@ u32 brcmf_sdcard_reg_write(void *sdh, u32 addr, uint size, u32 data)
 
 bool brcmf_sdcard_regfail(void *sdh)
 {
-	return ((bcmsdh_info_t *) sdh)->regfail;
+	return ((struct brcmf_sdio *) sdh)->regfail;
 }
 
 int
-brcmf_sdcard_recv_buf(bcmsdh_info_t *bcmsdh, u32 addr, uint fn, uint flags,
+brcmf_sdcard_recv_buf(struct brcmf_sdio *bcmsdh, u32 addr, uint fn, uint flags,
 		u8 *buf, uint nbytes, struct sk_buff *pkt,
 		bcmsdh_cmplt_fn_t complete, void *handle)
 {
@@ -497,7 +497,7 @@ brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 		u8 *buf, uint nbytes, void *pkt,
 		bcmsdh_cmplt_fn_t complete, void *handle)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 	uint incr_fix;
 	uint width;
@@ -538,7 +538,7 @@ brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 
 int brcmf_sdcard_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	SDIOH_API_RC status;
 
 	ASSERT(bcmsdh);
@@ -557,35 +557,35 @@ int brcmf_sdcard_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 
 int brcmf_sdcard_abort(void *sdh, uint fn)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 
 	return brcmf_sdioh_abort(bcmsdh->sdioh, fn);
 }
 
 int brcmf_sdcard_start(void *sdh, int stage)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 
 	return brcmf_sdioh_start(bcmsdh->sdioh, stage);
 }
 
 int brcmf_sdcard_stop(void *sdh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 
 	return brcmf_sdioh_stop(bcmsdh->sdioh);
 }
 
 int brcmf_sdcard_query_device(void *sdh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 	bcmsdh->vendevid = (PCI_VENDOR_ID_BROADCOM << 16) | 0;
 	return bcmsdh->vendevid;
 }
 
 uint brcmf_sdcard_query_iofnum(void *sdh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 
 	if (!bcmsdh)
 		bcmsdh = l_bcmsdh;
@@ -593,14 +593,14 @@ uint brcmf_sdcard_query_iofnum(void *sdh)
 	return brcmf_sdioh_query_iofnum(bcmsdh->sdioh);
 }
 
-int brcmf_sdcard_reset(bcmsdh_info_t *sdh)
+int brcmf_sdcard_reset(struct brcmf_sdio *sdh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 
 	return brcmf_sdioh_reset(bcmsdh->sdioh);
 }
 
-void *brcmf_sdcard_get_sdioh(bcmsdh_info_t *sdh)
+void *brcmf_sdcard_get_sdioh(struct brcmf_sdio *sdh)
 {
 	ASSERT(sdh);
 	return sdh->sdioh;
@@ -614,7 +614,7 @@ u32 brcmf_sdcard_get_dstatus(void *sdh)
 
 u32 brcmf_sdcard_cur_sbwad(void *sdh)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
+	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
 
 	if (!bcmsdh)
 		bcmsdh = l_bcmsdh;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 3fabc08..66d81d1 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -59,7 +59,7 @@ struct bcmsdh_hc {
 	struct pci_dev *dev;	/* pci device handle */
 #endif				/* BCMPLATFORM_BUS */
 	void *regs;		/* SDIO Host Controller address */
-	bcmsdh_info_t *sdh;	/* SDIO Host Controller handle */
+	struct brcmf_sdio *sdh;	/* SDIO Host Controller handle */
 	void *ch;
 	unsigned int oob_irq;
 	unsigned long oob_flags;	/* OOB Host specifiction
@@ -144,7 +144,7 @@ int brcmf_sdio_probe(struct device *dev)
 {
 	bcmsdh_hc_t *sdhc = NULL;
 	unsigned long regs = 0;
-	bcmsdh_info_t *sdh = NULL;
+	struct brcmf_sdio *sdh = NULL;
 #if !defined(BCMLXSDMMC) && defined(BCMPLATFORM_BUS)
 	struct platform_device *pdev;
 	struct resource *r;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 003f485..2ede425 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -460,7 +460,7 @@ struct chip_info {
 typedef struct dhd_bus {
 	dhd_pub_t *dhd;
 
-	bcmsdh_info_t *sdh;	/* Handle for BCMSDH calls */
+	struct brcmf_sdio *sdh;	/* Handle for BCMSDH calls */
 	struct chip_info *ci;	/* Chip info struct */
 	char *vars;		/* Variables (from CIS and/or other) */
 	uint varsz;		/* Size of variables buffer */
@@ -786,9 +786,9 @@ static int  _brcmf_sdbrcm_download_firmware(struct dhd_bus *bus);
 static int
 brcmf_sdbrcm_download_code_file(struct dhd_bus *bus, char *image_path);
 static int brcmf_sdbrcm_download_nvram(struct dhd_bus *bus);
-static void brcmf_sdbrcm_chip_disablecore(bcmsdh_info_t *sdh, u32 corebase);
+static void brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio *sdh, u32 corebase);
 static int brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs);
-static void brcmf_sdbrcm_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase);
+static void brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio *sdh, u32 corebase);
 static void brcmf_sdbrcm_sdiod_drive_strength_init(struct dhd_bus *bus,
 					u32 drivestrength);
 static void brcmf_sdbrcm_chip_detach(struct dhd_bus *bus);
@@ -835,7 +835,7 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 {
 	int err;
 	u8 clkctl, clkreq, devctl;
-	bcmsdh_info_t *sdh;
+	struct brcmf_sdio *sdh;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -1044,7 +1044,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 
 int brcmf_sdbrcm_bussleep(dhd_bus_t *bus, bool sleep)
 {
-	bcmsdh_info_t *sdh = bus->sdh;
+	struct brcmf_sdio *sdh = bus->sdh;
 	struct sdpcmd_regs *regs = bus->regs;
 	uint retries = 0;
 
@@ -1177,7 +1177,7 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	u16 len, pad = 0;
 	u32 swheader;
 	uint retries = 0;
-	bcmsdh_info_t *sdh;
+	struct brcmf_sdio *sdh;
 	struct sk_buff *new;
 	int i;
 
@@ -1496,7 +1496,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	u16 len;
 	u32 swheader;
 	uint retries = 0;
-	bcmsdh_info_t *sdh = bus->sdh;
+	struct brcmf_sdio *sdh = bus->sdh;
 	u8 doff = 0;
 	int ret = -1;
 	int i;
@@ -3199,7 +3199,7 @@ exit:
 
 static void brcmf_sdbrcm_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 {
-	bcmsdh_info_t *sdh = bus->sdh;
+	struct brcmf_sdio *sdh = bus->sdh;
 	struct sdpcmd_regs *regs = bus->regs;
 	uint retries = 0;
 	u16 lastrbc;
@@ -3263,7 +3263,7 @@ static void brcmf_sdbrcm_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 static void
 brcmf_sdbrcm_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 {
-	bcmsdh_info_t *sdh = bus->sdh;
+	struct brcmf_sdio *sdh = bus->sdh;
 	uint rdlen, pad;
 
 	int sdret;
@@ -3771,7 +3771,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 static uint
 brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 {
-	bcmsdh_info_t *sdh = bus->sdh;
+	struct brcmf_sdio *sdh = bus->sdh;
 
 	u16 len, check;	/* Extracted hardware header fields */
 	u8 chan, seq, doff;	/* Extracted software header fields */
@@ -4439,7 +4439,7 @@ static u32 brcmf_sdbrcm_hostmail(dhd_bus_t *bus)
 
 bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 {
-	bcmsdh_info_t *sdh = bus->sdh;
+	struct brcmf_sdio *sdh = bus->sdh;
 	struct sdpcmd_regs *regs = bus->regs;
 	u32 intstatus, newstatus = 0;
 	uint retries = 0;
@@ -4706,7 +4706,7 @@ bool dhd_bus_dpc(struct dhd_bus *bus)
 void brcmf_sdbrcm_isr(void *arg)
 {
 	dhd_bus_t *bus = (dhd_bus_t *) arg;
-	bcmsdh_info_t *sdh;
+	struct brcmf_sdio *sdh;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -6000,7 +6000,7 @@ int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 }
 
 static int
-brcmf_sdbrcm_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci,
+brcmf_sdbrcm_chip_recognition(struct brcmf_sdio *sdh, struct chip_info *ci,
 			    void *regs)
 {
 	u32 regdata;
@@ -6059,7 +6059,7 @@ brcmf_sdbrcm_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci,
 }
 
 static void
-brcmf_sdbrcm_chip_disablecore(bcmsdh_info_t *sdh, u32 corebase)
+brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio *sdh, u32 corebase)
 {
 	u32 regdata;
 
@@ -6235,7 +6235,7 @@ fail:
 }
 
 static void
-brcmf_sdbrcm_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase)
+brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio *sdh, u32 corebase)
 {
 	u32 regdata;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 4063508..c7d60ca 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -60,7 +60,7 @@ extern const uint bcmsdh_msglevel;
 #define SDIOD_MAX_IOFUNCS	7
 
 /* forward declarations */
-typedef struct bcmsdh_info bcmsdh_info_t;
+struct brcmf_sdio;
 typedef void (*bcmsdh_cb_fn_t) (void *);
 
 /* Attach and build an interface to the underlying SD host driver.
@@ -70,7 +70,7 @@ typedef void (*bcmsdh_cb_fn_t) (void *);
  *    implementation may maintain a single "default" handle (e.g. the first or
  *    most recent one) to enable single-instance implementations to pass NULL.
  */
-extern bcmsdh_info_t *brcmf_sdcard_attach(void *cfghdl, void **regsva,
+extern struct brcmf_sdio *brcmf_sdcard_attach(void *cfghdl, void **regsva,
 					  uint irq);
 
 /* Detach - freeup resources allocated in attach */
@@ -151,7 +151,7 @@ typedef void (*bcmsdh_cmplt_fn_t) (void *handle, int status, bool sync_waiting);
 extern int brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 		u8 *buf, uint nbytes, void *pkt,
 		bcmsdh_cmplt_fn_t complete, void *handle);
-extern int brcmf_sdcard_recv_buf(bcmsdh_info_t *sdh, u32 addr, uint fn,
+extern int brcmf_sdcard_recv_buf(struct brcmf_sdio *sdh, u32 addr, uint fn,
 		uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt,
 		bcmsdh_cmplt_fn_t complete, void *handle);
 
@@ -194,11 +194,11 @@ extern int brcmf_sdcard_iovar_op(void *sdh, const char *name,
 			   bool set);
 
 /* Reset and reinitialize the device */
-extern int brcmf_sdcard_reset(bcmsdh_info_t *sdh);
+extern int brcmf_sdcard_reset(struct brcmf_sdio *sdh);
 
 /* helper functions */
 
-extern void *brcmf_sdcard_get_sdioh(bcmsdh_info_t *sdh);
+extern void *brcmf_sdcard_get_sdioh(struct brcmf_sdio *sdh);
 
 /* callback functions */
 typedef struct {
-- 
1.7.1


