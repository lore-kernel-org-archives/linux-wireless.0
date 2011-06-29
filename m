Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4642 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758234Ab1F2Xtm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 095/119] staging: brcm80211: sdh related code cleanup
Date: Wed, 29 Jun 2011 16:47:59 -0700
Message-ID: <1309391303-22741-96-git-send-email-frankyl@broadcom.com> (sfid-20110630_015310_396083_32CA9C80)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Gave struct brcmf_sdio the more applicable name 'brcmf_sdio_card'. Enforced
stronger type checking by replacing void *sdh by struct brcmf_sdio_card *.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h     |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |  141 +++----
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |   20 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  423 +++++++++++----------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |  101 +++--
 5 files changed, 345 insertions(+), 342 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index 9359bba..ee01e48 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -105,7 +105,7 @@ extern int brcmf_sdioh_stop(struct sdioh_info *si);
 extern int brcmf_sdioh_reset(struct sdioh_info *si);
 
 /* Helper function */
-void *brcmf_sdcard_get_sdioh(struct brcmf_sdio *sdh);
+void *brcmf_sdcard_get_sdioh(struct brcmf_sdio_card *card);
 
 /* Watchdog timer interface for pm ops */
 extern void brcmf_sdio_wdtmr_enable(bool enable);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 5eb95b2..4c7e4a9 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -13,7 +13,7 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-/* ****************** SDIOCARD Interface Functions ***************************/
+/* ****************** SDIO CARD Interface Functions **************************/
 
 #include <linux/types.h>
 #include <linux/netdevice.h>
@@ -33,7 +33,7 @@
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 const uint brcmf_sdio_msglevel = BRCMF_SD_ERROR_VAL;
 
-struct brcmf_sdio {
+struct brcmf_sdio_card {
 	bool init_success;	/* underlying driver successfully attached */
 	void *sdioh;		/* handler for sdioh */
 	u32 vendevid;	/* Target Vendor and Device ID on SD bus */
@@ -42,13 +42,14 @@ struct brcmf_sdio {
 	u32 sbwad;		/* Save backplane window address */
 };
 /* local copy of bcm sd handler */
-static struct brcmf_sdio *l_card;
+static struct brcmf_sdio_card *l_card;
 
-struct brcmf_sdio *brcmf_sdcard_attach(void *cfghdl, void **regsva, uint irq)
+struct brcmf_sdio_card*
+brcmf_sdcard_attach(void *cfghdl, void **regsva, uint irq)
 {
-	struct brcmf_sdio *card;
+	struct brcmf_sdio_card *card;
 
-	card = kzalloc(sizeof(struct brcmf_sdio), GFP_ATOMIC);
+	card = kzalloc(sizeof(struct brcmf_sdio_card), GFP_ATOMIC);
 	if (card == NULL) {
 		BRCMF_SD_ERROR(("sdcard_attach: out of memory"));
 		return NULL;
@@ -72,10 +73,8 @@ struct brcmf_sdio *brcmf_sdcard_attach(void *cfghdl, void **regsva, uint irq)
 	return card;
 }
 
-int brcmf_sdcard_detach(void *sdh)
+int brcmf_sdcard_detach(struct brcmf_sdio_card *card)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
-
 	if (card != NULL) {
 		if (card->sdioh) {
 			brcmf_sdioh_detach(card->sdioh);
@@ -89,17 +88,15 @@ int brcmf_sdcard_detach(void *sdh)
 }
 
 int
-brcmf_sdcard_iovar_op(void *sdh, const char *name,
+brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
 		void *params, int plen, void *arg, int len, bool set)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	return brcmf_sdioh_iovar_op(card->sdioh, name, params, plen, arg,
 				    len, set);
 }
 
-bool brcmf_sdcard_intr_query(void *sdh)
+bool brcmf_sdcard_intr_query(struct brcmf_sdio_card *card)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 	bool on;
 
@@ -111,59 +108,57 @@ bool brcmf_sdcard_intr_query(void *sdh)
 		return on;
 }
 
-int brcmf_sdcard_intr_enable(void *sdh)
+int brcmf_sdcard_intr_enable(struct brcmf_sdio_card *card)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	ASSERT(card);
 
 	return brcmf_sdioh_interrupt_set(card->sdioh, true);
 }
 
-int brcmf_sdcard_intr_disable(void *sdh)
+int brcmf_sdcard_intr_disable(struct brcmf_sdio_card *card)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	ASSERT(card);
 
 	return brcmf_sdioh_interrupt_set(card->sdioh, false);
 }
 
-int brcmf_sdcard_intr_reg(void *sdh, brcmf_sdiocard_cb_fn_t fn, void *argh)
+int brcmf_sdcard_intr_reg(struct brcmf_sdio_card *card,
+			  brcmf_sdiocard_cb_fn_t fn,
+			  void *argh)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	ASSERT(card);
 
 	return brcmf_sdioh_interrupt_register(card->sdioh, fn, argh);
 }
 
-int brcmf_sdcard_intr_dereg(void *sdh)
+int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	ASSERT(card);
 
 	return brcmf_sdioh_interrupt_deregister(card->sdioh);
 }
 
 #if defined(BCMDBG)
-bool brcmf_sdcard_intr_pending(void *sdh)
+bool brcmf_sdcard_intr_pending(struct brcmf_sdio_card *card)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
-
-	ASSERT(sdh);
+	ASSERT(card);
 	return brcmf_sdioh_interrupt_pending(card->sdioh);
 }
 #endif
 
-int brcmf_sdcard_devremove_reg(void *sdh, brcmf_sdiocard_cb_fn_t fn, void *argh)
+int brcmf_sdcard_devremove_reg(struct brcmf_sdio_card *card,
+			       brcmf_sdiocard_cb_fn_t fn,
+			       void *argh)
 {
-	ASSERT(sdh);
+	ASSERT(card);
 
 	/* don't support yet */
 	return -ENOTSUPP;
 }
 
-u8 brcmf_sdcard_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
+u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
+			 int *err)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	s32 retry = 0;
@@ -197,9 +192,9 @@ u8 brcmf_sdcard_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 }
 
 void
-brcmf_sdcard_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
+brcmf_sdcard_cfg_write(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
+		       u8 data, int *err)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	s32 retry = 0;
@@ -229,9 +224,9 @@ brcmf_sdcard_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 		     __func__, fnc_num, addr, data));
 }
 
-u32 brcmf_sdcard_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
+u32 brcmf_sdcard_cfg_read_word(struct brcmf_sdio_card *card, uint fnc_num,
+			       u32 addr, int *err)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 	u32 data = 0;
 
@@ -253,10 +248,9 @@ u32 brcmf_sdcard_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
 }
 
 void
-brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
-		      int *err)
+brcmf_sdcard_cfg_write_word(struct brcmf_sdio_card *card, uint fnc_num,
+			    u32 addr, u32 data, int *err)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 
 	if (!card)
@@ -275,9 +269,9 @@ brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 		     __func__, fnc_num, addr, data));
 }
 
-int brcmf_sdcard_cis_read(void *sdh, uint func, u8 * cis, uint length)
+int brcmf_sdcard_cis_read(struct brcmf_sdio_card *card, uint func, u8 * cis,
+			  uint length)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 
 	u8 *tmp_buf, *tmp_ptr;
@@ -315,10 +309,10 @@ int brcmf_sdcard_cis_read(void *sdh, uint func, u8 * cis, uint length)
 	return status;
 }
 
-static int brcmf_sdcard_set_sbaddr_window(void *sdh, u32 address)
+static int
+brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_card *card, u32 address)
 {
 	int err = 0;
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	brcmf_sdcard_cfg_write(card, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
 			 (address >> 8) & SBSDIO_SBADDRLOW_MASK, &err);
 	if (!err)
@@ -335,9 +329,8 @@ static int brcmf_sdcard_set_sbaddr_window(void *sdh, u32 address)
 	return err;
 }
 
-u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size)
+u32 brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 	u32 word = 0;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
@@ -388,9 +381,9 @@ u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size)
 	return 0xFFFFFFFF;
 }
 
-u32 brcmf_sdcard_reg_write(void *sdh, u32 addr, uint size, u32 data)
+u32 brcmf_sdcard_reg_write(struct brcmf_sdio_card *card, u32 addr, uint size,
+			   u32 data)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
@@ -427,15 +420,16 @@ u32 brcmf_sdcard_reg_write(void *sdh, u32 addr, uint size, u32 data)
 	return 0xFFFFFFFF;
 }
 
-bool brcmf_sdcard_regfail(void *sdh)
+bool brcmf_sdcard_regfail(struct brcmf_sdio_card *card)
 {
-	return ((struct brcmf_sdio *) sdh)->regfail;
+	return card->regfail;
 }
 
 int
-brcmf_sdcard_recv_buf(struct brcmf_sdio *card, u32 addr, uint fn, uint flags,
-		u8 *buf, uint nbytes, struct sk_buff *pkt,
-		brcmf_sdio_cmplt_fn_t complete, void *handle)
+brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
+		      uint flags,
+		      u8 *buf, uint nbytes, struct sk_buff *pkt,
+		      brcmf_sdio_cmplt_fn_t complete, void *handle)
 {
 	int status;
 	uint incr_fix;
@@ -476,11 +470,10 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio *card, u32 addr, uint fn, uint flags,
 }
 
 int
-brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
-		u8 *buf, uint nbytes, void *pkt,
-		brcmf_sdio_cmplt_fn_t complete, void *handle)
+brcmf_sdcard_send_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
+		      uint flags, u8 *buf, uint nbytes, void *pkt,
+		      brcmf_sdio_cmplt_fn_t complete, void *handle)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	uint incr_fix;
 	uint width;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
@@ -516,10 +509,9 @@ brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 		incr_fix, SDIOH_WRITE, fn, addr, width, nbytes, buf, pkt);
 }
 
-int brcmf_sdcard_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
+int brcmf_sdcard_rwdata(struct brcmf_sdio_card *card, uint rw, u32 addr,
+			u8 *buf, uint nbytes)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
-
 	ASSERT(card);
 	ASSERT(card->init_success);
 	ASSERT((addr & SBSDIO_SBWINDOW_MASK) == 0);
@@ -532,74 +524,61 @@ int brcmf_sdcard_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 		addr, 4, nbytes, buf, NULL);
 }
 
-int brcmf_sdcard_abort(void *sdh, uint fn)
+int brcmf_sdcard_abort(struct brcmf_sdio_card *card, uint fn)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
-
 	return brcmf_sdioh_abort(card->sdioh, fn);
 }
 
-int brcmf_sdcard_start(void *sdh, int stage)
+int brcmf_sdcard_start(struct brcmf_sdio_card *card, int stage)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
-
 	return brcmf_sdioh_start(card->sdioh, stage);
 }
 
-int brcmf_sdcard_stop(void *sdh)
+int brcmf_sdcard_stop(struct brcmf_sdio_card *card)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
-
 	return brcmf_sdioh_stop(card->sdioh);
 }
 
-int brcmf_sdcard_query_device(void *sdh)
+int brcmf_sdcard_query_device(struct brcmf_sdio_card *card)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	card->vendevid = (PCI_VENDOR_ID_BROADCOM << 16) | 0;
 	return card->vendevid;
 }
 
-uint brcmf_sdcard_query_iofnum(void *sdh)
+uint brcmf_sdcard_query_iofnum(struct brcmf_sdio_card *card)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
-
 	if (!card)
 		card = l_card;
 
 	return brcmf_sdioh_query_iofnum(card->sdioh);
 }
 
-int brcmf_sdcard_reset(struct brcmf_sdio *sdh)
+int brcmf_sdcard_reset(struct brcmf_sdio_card *card)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
-
 	return brcmf_sdioh_reset(card->sdioh);
 }
 
-void *brcmf_sdcard_get_sdioh(struct brcmf_sdio *sdh)
+void *brcmf_sdcard_get_sdioh(struct brcmf_sdio_card *card)
 {
-	ASSERT(sdh);
-	return sdh->sdioh;
+	ASSERT(card);
+	return card->sdioh;
 }
 
 /* Function to pass device-status bits to DHD. */
-u32 brcmf_sdcard_get_dstatus(void *sdh)
+u32 brcmf_sdcard_get_dstatus(struct brcmf_sdio_card *card)
 {
 	return 0;
 }
 
-u32 brcmf_sdcard_cur_sbwad(void *sdh)
+u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card)
 {
-	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
-
 	if (!card)
 		card = l_card;
 
 	return card->sbwad;
 }
 
-void brcmf_sdcard_chipinfo(void *sdh, u32 chip, u32 chiprev)
+void brcmf_sdcard_chipinfo(struct brcmf_sdio_card *card, u32 chip, u32 chiprev)
 {
 	return;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index a3cf05f..fe875e8 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -42,7 +42,7 @@ struct sdio_hc {
 	struct sdio_hc *next;
 	struct device *dev;	/* platform device handle */
 	void *regs;		/* SDIO Host Controller address */
-	struct brcmf_sdio *sdh;	/* SDIO Host Controller handle */
+	struct brcmf_sdio_card *card;
 	void *ch;
 	unsigned int oob_irq;
 	unsigned long oob_flags;	/* OOB Host specifiction
@@ -113,7 +113,7 @@ int brcmf_sdio_probe(struct device *dev)
 {
 	struct sdio_hc *sdhc = NULL;
 	unsigned long regs = 0;
-	struct brcmf_sdio *sdh = NULL;
+	struct brcmf_sdio_card *card = NULL;
 	int irq = 0;
 	u32 vendevid;
 	unsigned long irq_flags = 0;
@@ -126,13 +126,13 @@ int brcmf_sdio_probe(struct device *dev)
 	}
 	sdhc->dev = (void *)dev;
 
-	sdh = brcmf_sdcard_attach((void *)0, (void **)&regs, irq);
-	if (!sdh) {
+	card = brcmf_sdcard_attach((void *)0, (void **)&regs, irq);
+	if (!card) {
 		SDLX_MSG(("%s: attach failed\n", __func__));
 		goto err;
 	}
 
-	sdhc->sdh = sdh;
+	sdhc->card = card;
 	sdhc->oob_irq = irq;
 	sdhc->oob_flags = irq_flags;
 	sdhc->oob_irq_registered = false;	/* to make sure.. */
@@ -141,11 +141,11 @@ int brcmf_sdio_probe(struct device *dev)
 	sdhc->next = sdhcinfo;
 	sdhcinfo = sdhc;
 	/* Read the vendor/device ID from the CIS */
-	vendevid = brcmf_sdcard_query_device(sdh);
+	vendevid = brcmf_sdcard_query_device(card);
 
 	/* try to attach to the target device */
 	sdhc->ch = drvinfo.attach((vendevid >> 16), (vendevid & 0xFFFF),
-				  0, 0, 0, 0, (void *)regs, sdh);
+				  0, 0, 0, 0, (void *)regs, card);
 	if (!sdhc->ch) {
 		SDLX_MSG(("%s: device attach failed\n", __func__));
 		goto err;
@@ -156,8 +156,8 @@ int brcmf_sdio_probe(struct device *dev)
 	/* error handling */
 err:
 	if (sdhc) {
-		if (sdhc->sdh)
-			brcmf_sdcard_detach(sdhc->sdh);
+		if (sdhc->card)
+			brcmf_sdcard_detach(sdhc->card);
 		kfree(sdhc);
 	}
 
@@ -170,7 +170,7 @@ int brcmf_sdio_remove(struct device *dev)
 
 	sdhc = sdhcinfo;
 	drvinfo.detach(sdhc->ch);
-	brcmf_sdcard_detach(sdhc->sdh);
+	brcmf_sdcard_detach(sdhc->card);
 	/* find the SDIO Host Controller state for this pdev
 		 and take it out from the list */
 	for (sdhc = sdhcinfo, prev = NULL; sdhc; sdhc = sdhc->next) {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 6c7407a..3ed9e12 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -458,7 +458,7 @@ struct chip_info {
 typedef struct dhd_bus {
 	struct brcmf_pub *dhd;
 
-	struct brcmf_sdio *sdh;	/* Handle for sdio card calls */
+	struct brcmf_sdio_card *card;	/* Handle for sdio card calls */
 	struct chip_info *ci;	/* Chip info struct */
 	char *vars;		/* Variables (from CIS and/or other) */
 	uint varsz;		/* Size of variables buffer */
@@ -744,7 +744,7 @@ do { \
 	retryvar = 0; \
 	do { \
 		regvar = R_REG(regaddr); \
-	} while (brcmf_sdcard_regfail(bus->sdh) && \
+	} while (brcmf_sdcard_regfail(bus->card) && \
 		 (++retryvar <= retry_limit)); \
 	if (retryvar) { \
 		bus->regfails += (retryvar-1); \
@@ -761,7 +761,7 @@ do { \
 	retryvar = 0; \
 	do { \
 		W_REG(regaddr, regval); \
-	} while (brcmf_sdcard_regfail(bus->sdh) && \
+	} while (brcmf_sdcard_regfail(bus->card) && \
 		 (++retryvar <= retry_limit)); \
 	if (retryvar) { \
 		bus->regfails += (retryvar-1); \
@@ -794,10 +794,10 @@ static void brcmf_sdbrcm_release(dhd_bus_t *bus);
 static void brcmf_sdbrcm_release_malloc(dhd_bus_t *bus);
 static void brcmf_sdbrcm_disconnect(void *ptr);
 static bool brcmf_sdbrcm_chipmatch(u16 chipid);
-static bool brcmf_sdbrcm_probe_attach(dhd_bus_t *bus, void *sdh,
+static bool brcmf_sdbrcm_probe_attach(dhd_bus_t *bus, void *card,
 				 void *regsva, u16 devid);
-static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *sdh);
-static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh);
+static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *card);
+static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *card);
 static void brcmf_sdbrcm_release_dongle(dhd_bus_t *bus);
 
 static uint brcmf_process_nvram_vars(char *varbuf, uint len);
@@ -808,14 +808,20 @@ static int brcmf_sdbrcm_send_buf(dhd_bus_t *bus, u32 addr, uint fn,
 			       struct sk_buff *pkt,
 			       brcmf_sdio_cmplt_fn_t complete, void *handle);
 
-static bool brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *sdh);
+static bool brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *card);
 static int  _brcmf_sdbrcm_download_firmware(struct dhd_bus *bus);
 
 static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus);
 static int brcmf_sdbrcm_download_nvram(struct dhd_bus *bus);
-static void brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio *sdh, u32 corebase);
+
+static void
+brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_card *card, u32 corebase);
+
 static int brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs);
-static void brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio *sdh, u32 corebase);
+
+static void
+brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_card *card, u32 corebase);
+
 static void brcmf_sdbrcm_sdiod_drive_strength_init(struct dhd_bus *bus,
 					u32 drivestrength);
 static void brcmf_sdbrcm_chip_detach(struct dhd_bus *bus);
@@ -853,14 +859,14 @@ static void brcmf_sdbrcm_setmemsize(struct dhd_bus *bus, int mem_size)
 static int brcmf_sdbrcm_set_siaddr_window(dhd_bus_t *bus, u32 address)
 {
 	int err = 0;
-	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
+	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
 			 (address >> 8) & SBSDIO_SBADDRLOW_MASK, &err);
 	if (!err)
-		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1,
 				 SBSDIO_FUNC1_SBADDRMID,
 				 (address >> 16) & SBSDIO_SBADDRMID_MASK, &err);
 	if (!err)
-		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_SBADDRHIGH,
 				       (address >> 24) & SBSDIO_SBADDRHIGH_MASK,
 				       &err);
@@ -872,12 +878,12 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 {
 	int err;
 	u8 clkctl, clkreq, devctl;
-	struct brcmf_sdio *sdh;
+	struct brcmf_sdio_card *card;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	clkctl = 0;
-	sdh = bus->sdh;
+	card = bus->card;
 
 	if (on) {
 		/* Request HT Avail */
@@ -888,7 +894,7 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		    && (bus->ci->chiprev == 0))
 			clkreq |= SBSDIO_FORCE_ALP;
 
-		brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		if (err) {
 			DHD_ERROR(("%s: HT Avail request error: %d\n",
@@ -903,7 +909,7 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		}
 
 		/* Check current status */
-		clkctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+		clkctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			DHD_ERROR(("%s: HT Avail read error: %d\n",
@@ -914,7 +920,7 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		/* Go to pending and await interrupt if appropriate */
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only) && pendok) {
 			/* Allow only clock-available interrupt */
-			devctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+			devctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					SBSDIO_DEVICE_CTL, &err);
 			if (err) {
 				DHD_ERROR(("%s: Devctl error setting CA: %d\n",
@@ -923,7 +929,7 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 					       SBSDIO_DEVICE_CTL, devctl, &err);
 			DHD_INFO(("CLKCTL: set PENDING\n"));
 			bus->clkstate = CLK_PENDING;
@@ -932,22 +938,22 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		} else if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
 			devctl =
-			    brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+			    brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 						  SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, devctl, &err);
 		}
 
 		/* Otherwise, wait here (polling) for HT Avail */
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
 			BRCMF_SPINWAIT_SLEEP(sdioh_spinwait_sleep,
-				       ((clkctl =
-					 brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
-						 SBSDIO_FUNC1_CHIPCLKCSR,
-							 &err)),
-					!SBSDIO_CLKAV(clkctl, bus->alp_only)),
-				       PMU_MAX_TRANSITION_DLY);
+			       ((clkctl =
+				 brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+					 SBSDIO_FUNC1_CHIPCLKCSR,
+						 &err)),
+				!SBSDIO_CLKAV(clkctl, bus->alp_only)),
+			       PMU_MAX_TRANSITION_DLY);
 		}
 		if (err) {
 			DHD_ERROR(("%s: HT Avail request error: %d\n",
@@ -979,15 +985,15 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 
 		if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+			devctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, devctl, &err);
 		}
 
 		bus->clkstate = CLK_SDONLY;
-		brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		DHD_INFO(("CLKCTL: turned OFF\n"));
 		if (err) {
@@ -1071,7 +1077,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 
 int brcmf_sdbrcm_bussleep(dhd_bus_t *bus, bool sleep)
 {
-	struct brcmf_sdio *sdh = bus->sdh;
+	struct brcmf_sdio_card *card = bus->card;
 	struct sdpcmd_regs *regs = bus->regs;
 	uint retries = 0;
 
@@ -1090,7 +1096,7 @@ int brcmf_sdbrcm_bussleep(dhd_bus_t *bus, bool sleep)
 			return -EBUSY;
 
 		/* Disable SDIO interrupts (no longer interested) */
-		brcmf_sdcard_intr_disable(bus->sdh);
+		brcmf_sdcard_intr_disable(bus->card);
 
 		/* Make sure the controller has the bus up */
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -1103,14 +1109,14 @@ int brcmf_sdbrcm_bussleep(dhd_bus_t *bus, bool sleep)
 		/* Turn off our contribution to the HT clock request */
 		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
 
-		brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR,
 			SBSDIO_FORCE_HW_CLKREQ_OFF, NULL);
 
 		/* Isolate the bus */
 		if (bus->ci->chip != BCM4329_CHIP_ID
 		    && bus->ci->chip != BCM4319_CHIP_ID) {
-			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL,
 				SBSDIO_DEVCTL_PADS_ISO, NULL);
 		}
@@ -1121,14 +1127,14 @@ int brcmf_sdbrcm_bussleep(dhd_bus_t *bus, bool sleep)
 	} else {
 		/* Waking up: bus power up is ok, set local state */
 
-		brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
 		/* Force pad isolation off if possible
 			 (in case power never toggled) */
 		if ((bus->ci->buscoretype == PCMCIA_CORE_ID)
 		    && (bus->ci->buscorerev >= 10))
-			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, 0, NULL);
 
 		/* Make sure the controller has the bus up */
@@ -1151,7 +1157,7 @@ int brcmf_sdbrcm_bussleep(dhd_bus_t *bus, bool sleep)
 		/* Enable interrupts again */
 		if (bus->intr && (bus->dhd->busstate == DHD_BUS_DATA)) {
 			bus->intdis = false;
-			brcmf_sdcard_intr_enable(bus->sdh);
+			brcmf_sdcard_intr_enable(bus->card);
 		}
 	}
 
@@ -1174,13 +1180,13 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	u16 len, pad = 0;
 	u32 swheader;
 	uint retries = 0;
-	struct brcmf_sdio *sdh;
+	struct brcmf_sdio_card *card;
 	struct sk_buff *new;
 	int i;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	sdh = bus->sdh;
+	card = bus->card;
 
 	if (bus->dhd->dongle_reset) {
 		ret = -EPERM;
@@ -1268,7 +1274,7 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	}
 
 	do {
-		ret = brcmf_sdbrcm_send_buf(bus, brcmf_sdcard_cur_sbwad(sdh),
+		ret = brcmf_sdbrcm_send_buf(bus, brcmf_sdcard_cur_sbwad(card),
 			SDIO_FUNC_2, F2SYNC, frame, len, pkt, NULL, NULL);
 		bus->f2txdata++;
 		ASSERT(ret != -BCME_PENDING);
@@ -1280,18 +1286,18 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 				"terminate frame.\n", __func__, ret));
 			bus->tx_sderrs++;
 
-			brcmf_sdcard_abort(sdh, SDIO_FUNC_2);
-			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+			brcmf_sdcard_abort(card, SDIO_FUNC_2);
+			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
 					 NULL);
 			bus->f1regdata++;
 
 			for (i = 0; i < 3; i++) {
 				u8 hi, lo;
-				hi = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+				hi = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCHI,
 						     NULL);
-				lo = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+				lo = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCLO,
 						     NULL);
 				bus->f1regdata += 2;
@@ -1461,7 +1467,7 @@ static uint brcmf_sdbrcm_sendfromq(dhd_bus_t *bus, uint maxframes)
 			/* Check device status, signal pending interrupt */
 			R_SDREG(intstatus, &regs->intstatus, retries);
 			bus->f2txdata++;
-			if (brcmf_sdcard_regfail(bus->sdh))
+			if (brcmf_sdcard_regfail(bus->card))
 				break;
 			if (intstatus & bus->hostintmask)
 				bus->ipend = true;
@@ -1483,7 +1489,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	u16 len;
 	u32 swheader;
 	uint retries = 0;
-	struct brcmf_sdio *sdh = bus->sdh;
+	struct brcmf_sdio_card *card = bus->card;
 	u8 doff = 0;
 	int ret = -1;
 	int i;
@@ -1581,7 +1587,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		do {
 			bus->ctrl_frame_stat = false;
 			ret = brcmf_sdbrcm_send_buf(bus,
-				brcmf_sdcard_cur_sbwad(sdh), SDIO_FUNC_2,
+				brcmf_sdcard_cur_sbwad(card), SDIO_FUNC_2,
 				F2SYNC, frame, len, NULL, NULL, NULL);
 
 			ASSERT(ret != -BCME_PENDING);
@@ -1593,20 +1599,20 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 					__func__, ret));
 				bus->tx_sderrs++;
 
-				brcmf_sdcard_abort(sdh, SDIO_FUNC_2);
+				brcmf_sdcard_abort(card, SDIO_FUNC_2);
 
-				brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+				brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 						 SBSDIO_FUNC1_FRAMECTRL,
 						 SFC_WF_TERM, NULL);
 				bus->f1regdata++;
 
 				for (i = 0; i < 3; i++) {
 					u8 hi, lo;
-					hi = brcmf_sdcard_cfg_read(sdh,
+					hi = brcmf_sdcard_cfg_read(card,
 					     SDIO_FUNC_1,
 					     SBSDIO_FUNC1_WFRAMEBCHI,
 					     NULL);
-					lo = brcmf_sdcard_cfg_read(sdh,
+					lo = brcmf_sdcard_cfg_read(card,
 					     SDIO_FUNC_1,
 					     SBSDIO_FUNC1_WFRAMEBCLO,
 					     NULL);
@@ -1884,7 +1890,7 @@ void brcmf_sdbrcm_bus_dump(struct brcmf_pub *dhdp, struct brcmu_strbuf *strbuf)
 #ifdef BCMDBG
 	brcmu_bprintf(strbuf, "dpc_sched %d host interrupt%spending\n",
 		    bus->dpc_sched,
-		    (brcmf_sdcard_intr_pending(bus->sdh) ? " " : " not "));
+		    (brcmf_sdcard_intr_pending(bus->card) ? " " : " not "));
 	brcmu_bprintf(strbuf, "blocksize %d roundup %d\n", bus->blocksize,
 		    bus->roundup);
 #endif				/* BCMDBG */
@@ -1990,7 +1996,7 @@ brcmf_sdbrcm_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
 			  __func__, (write ? "write" : "read"), dsize,
 			  sdaddr, (address & SBSDIO_SBWINDOW_MASK)));
 		bcmerror =
-		     brcmf_sdcard_rwdata(bus->sdh, write, sdaddr, data, dsize);
+		     brcmf_sdcard_rwdata(bus->card, write, sdaddr, data, dsize);
 		if (bcmerror) {
 			DHD_ERROR(("%s: membytes transfer failed\n", __func__));
 			break;
@@ -2015,9 +2021,9 @@ brcmf_sdbrcm_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
 xfer_done:
 	/* Return the window to backplane enumeration space for core access */
 	if (brcmf_sdbrcm_set_siaddr_window(bus,
-					   brcmf_sdcard_cur_sbwad(bus->sdh))) {
+					   brcmf_sdcard_cur_sbwad(bus->card))) {
 		DHD_ERROR(("%s: FAILED to set window back to 0x%x\n",
-			   __func__, brcmf_sdcard_cur_sbwad(bus->sdh)));
+			   __func__, brcmf_sdcard_cur_sbwad(bus->card)));
 	}
 
 	return bcmerror;
@@ -2426,11 +2432,11 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 			if (bus->intr) {
 				DHD_INTR(("%s: enable SDIO device interrupts\n",
 					  __func__));
-				brcmf_sdcard_intr_enable(bus->sdh);
+				brcmf_sdcard_intr_enable(bus->card);
 			} else {
 				DHD_INTR(("%s: disable SDIO interrupts\n",
 					  __func__));
-				brcmf_sdcard_intr_disable(bus->sdh);
+				brcmf_sdcard_intr_disable(bus->card);
 			}
 		}
 		break;
@@ -2623,9 +2629,9 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 			addr = (unsigned long)bus->regs + sd_ptr->offset;
 			size = sd_ptr->func;
-			int_val = (s32) brcmf_sdcard_reg_read(bus->sdh, addr,
+			int_val = (s32) brcmf_sdcard_reg_read(bus->card, addr,
 							      size);
-			if (brcmf_sdcard_regfail(bus->sdh))
+			if (brcmf_sdcard_regfail(bus->card))
 				bcmerror = -EIO;
 			memcpy(arg, &int_val, sizeof(s32));
 			break;
@@ -2640,9 +2646,9 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 			addr = (unsigned long)bus->regs + sd_ptr->offset;
 			size = sd_ptr->func;
-			brcmf_sdcard_reg_write(bus->sdh, addr, size,
+			brcmf_sdcard_reg_write(bus->card, addr, size,
 					       sd_ptr->value);
-			if (brcmf_sdcard_regfail(bus->sdh))
+			if (brcmf_sdcard_regfail(bus->card))
 				bcmerror = -EIO;
 			break;
 		}
@@ -2658,9 +2664,9 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 			addr = SI_ENUM_BASE + sdreg.offset;
 			size = sdreg.func;
-			int_val = (s32) brcmf_sdcard_reg_read(bus->sdh, addr,
+			int_val = (s32) brcmf_sdcard_reg_read(bus->card, addr,
 							      size);
-			if (brcmf_sdcard_regfail(bus->sdh))
+			if (brcmf_sdcard_regfail(bus->card))
 				bcmerror = -EIO;
 			memcpy(arg, &int_val, sizeof(s32));
 			break;
@@ -2675,9 +2681,9 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 			addr = SI_ENUM_BASE + sdreg.offset;
 			size = sdreg.func;
-			brcmf_sdcard_reg_write(bus->sdh, addr, size,
+			brcmf_sdcard_reg_write(bus->card, addr, size,
 					       sdreg.value);
-			if (brcmf_sdcard_regfail(bus->sdh))
+			if (brcmf_sdcard_regfail(bus->card))
 				bcmerror = -EIO;
 			break;
 		}
@@ -2687,15 +2693,15 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 			*(char *)arg = 0;
 
 			strcat(arg, "\nFunc 0\n");
-			brcmf_sdcard_cis_read(bus->sdh, 0x10,
+			brcmf_sdcard_cis_read(bus->card, 0x10,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
 			strcat(arg, "\nFunc 1\n");
-			brcmf_sdcard_cis_read(bus->sdh, 0x11,
+			brcmf_sdcard_cis_read(bus->card, 0x11,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
 			strcat(arg, "\nFunc 2\n");
-			brcmf_sdcard_cis_read(bus->sdh, 0x12,
+			brcmf_sdcard_cis_read(bus->card, 0x12,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
 			break;
@@ -2907,9 +2913,9 @@ static int brcmf_sdbrcm_download_state(dhd_bus_t *bus, bool enter)
 	if (enter) {
 		bus->alp_only = true;
 
-		brcmf_sdbrcm_chip_disablecore(bus->sdh, bus->ci->armcorebase);
+		brcmf_sdbrcm_chip_disablecore(bus->card, bus->ci->armcorebase);
 
-		brcmf_sdbrcm_chip_resetcore(bus->sdh, bus->ci->ramcorebase);
+		brcmf_sdbrcm_chip_resetcore(bus->card, bus->ci->ramcorebase);
 
 		/* Clear the top bit of memory */
 		if (bus->ramsize) {
@@ -2918,7 +2924,7 @@ static int brcmf_sdbrcm_download_state(dhd_bus_t *bus, bool enter)
 					 (u8 *)&zeros, 4);
 		}
 	} else {
-		regdata = brcmf_sdcard_reg_read(bus->sdh,
+		regdata = brcmf_sdcard_reg_read(bus->card,
 			CORE_SB(bus->ci->ramcorebase, sbtmstatelow), 4);
 		regdata &= (SBTML_RESET | SBTML_REJ_MASK |
 			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
@@ -2937,7 +2943,7 @@ static int brcmf_sdbrcm_download_state(dhd_bus_t *bus, bool enter)
 
 		W_SDREG(0xFFFFFFFF, &bus->regs->intstatus, retries);
 
-		brcmf_sdbrcm_chip_resetcore(bus->sdh, bus->ci->armcorebase);
+		brcmf_sdbrcm_chip_resetcore(bus->card, bus->ci->armcorebase);
 
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
@@ -2979,14 +2985,14 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *dhdp, const char *name,
 		/* Turn on clock in case SD command needs backplane */
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
-		bcmerror = brcmf_sdcard_iovar_op(bus->sdh, name, params, plen,
+		bcmerror = brcmf_sdcard_iovar_op(bus->card, name, params, plen,
 						 arg, len, set);
 
 		/* Similar check for blocksize change */
 		if (set && strcmp(name, "sd_blocksize") == 0) {
 			s32 fnum = 2;
 			if (brcmf_sdcard_iovar_op
-			    (bus->sdh, "sd_blocksize", &fnum, sizeof(s32),
+			    (bus->card, "sd_blocksize", &fnum, sizeof(s32),
 			     &bus->blocksize, sizeof(s32),
 			     false) != 0) {
 				bus->blocksize = 0;
@@ -3076,10 +3082,10 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	bus->dhd->busstate = DHD_BUS_DOWN;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk = brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_1,
+	saveclk = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
 					SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_CHIPCLKCSR,
 				       (saveclk | SBSDIO_FORCE_HT), &err);
 	}
@@ -3090,8 +3096,8 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 
 	/* Turn off the bus (F2), free any pending packets */
 	DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
-	brcmf_sdcard_intr_disable(bus->sdh);
-	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+	brcmf_sdcard_intr_disable(bus->card);
+	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			 SDIO_FUNC_ENABLE_1, NULL);
 
 	/* Clear any pending interrupts now that F2 is disabled */
@@ -3141,7 +3147,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 
 	/* try to download image and nvram to the dongle */
 	if (dhdp->busstate == DHD_BUS_DOWN) {
-		if (!(brcmf_sdbrcm_download_firmware(bus, bus->sdh)))
+		if (!(brcmf_sdbrcm_download_firmware(bus, bus->card)))
 			return -1;
 	}
 
@@ -3163,10 +3169,10 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
 	saveclk =
-	    brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_1,
+	    brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
 				  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_CHIPCLKCSR,
 				       (saveclk | SBSDIO_FORCE_HT), &err);
 	}
@@ -3181,7 +3187,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 		&bus->regs->tosbmailboxdata, retries);
 	enable = (SDIO_FUNC_ENABLE_1 | SDIO_FUNC_ENABLE_2);
 
-	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx, enable,
+	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx, enable,
 			       NULL);
 
 	/* Give the dongle some time to do its thing and set IOR2 */
@@ -3189,9 +3195,8 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 
 	ready = 0;
 	while (ready != enable && !brcmf_timeout_expired(&tmo))
-		ready =
-		    brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IORx,
-				    NULL);
+		ready = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_0,
+					      SDIO_CCCR_IORx, NULL);
 
 	DHD_INFO(("%s: enable 0x%02x, ready 0x%02x (waited %uus)\n",
 		  __func__, enable, ready, tmo.elapsed));
@@ -3204,7 +3209,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 			(unsigned int *)CORE_BUS_REG(bus->ci->buscorebase,
 			hostintmask), retries);
 
-		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_WATERMARK,
+		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_WATERMARK,
 				 (u8) watermark, &err);
 
 		/* Set bus state according to enable result */
@@ -3214,10 +3219,10 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 		if (bus->intr) {
 			DHD_INTR(("%s: enable SDIO device interrupts\n",
 				  __func__));
-			brcmf_sdcard_intr_enable(bus->sdh);
+			brcmf_sdcard_intr_enable(bus->card);
 		} else {
 			DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
-			brcmf_sdcard_intr_disable(bus->sdh);
+			brcmf_sdcard_intr_disable(bus->card);
 		}
 
 	}
@@ -3225,12 +3230,12 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 	else {
 		/* Disable F2 again */
 		enable = SDIO_FUNC_ENABLE_1;
-		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 				       enable, NULL);
 	}
 
 	/* Restore previous clock setting */
-	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
+	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 			 saveclk, &err);
 
 #if defined(OOB_INTR_ONLY)
@@ -3259,7 +3264,7 @@ exit:
 
 static void brcmf_sdbrcm_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 {
-	struct brcmf_sdio *sdh = bus->sdh;
+	struct brcmf_sdio_card *card = bus->card;
 	struct sdpcmd_regs *regs = bus->regs;
 	uint retries = 0;
 	u16 lastrbc;
@@ -3271,17 +3276,17 @@ static void brcmf_sdbrcm_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 		   (rtx ? ", send NAK" : "")));
 
 	if (abort)
-		brcmf_sdcard_abort(sdh, SDIO_FUNC_2);
+		brcmf_sdcard_abort(card, SDIO_FUNC_2);
 
-	brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_FRAMECTRL,
+	brcmf_sdcard_cfg_write(card, SDIO_FUNC_1, SBSDIO_FUNC1_FRAMECTRL,
 			       SFC_RF_TERM, &err);
 	bus->f1regdata++;
 
 	/* Wait until the packet has been flushed (device/FIFO stable) */
 	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
-		hi = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+		hi = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					   SBSDIO_FUNC1_RFRAMEBCHI, NULL);
-		lo = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+		lo = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					   SBSDIO_FUNC1_RFRAMEBCLO, NULL);
 		bus->f1regdata += 2;
 
@@ -3316,14 +3321,14 @@ static void brcmf_sdbrcm_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 	bus->nextlen = 0;
 
 	/* If we can't reach the device, signal failure */
-	if (err || brcmf_sdcard_regfail(sdh))
+	if (err || brcmf_sdcard_regfail(card))
 		bus->dhd->busstate = DHD_BUS_DOWN;
 }
 
 static void
 brcmf_sdbrcm_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 {
-	struct brcmf_sdio *sdh = bus->sdh;
+	struct brcmf_sdio_card *card = bus->card;
 	uint rdlen, pad;
 
 	int sdret;
@@ -3392,7 +3397,7 @@ brcmf_sdbrcm_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 	}
 
 	/* Read remainder of frame body into the rxctl buffer */
-	sdret = brcmf_sdcard_recv_buf(sdh, brcmf_sdcard_cur_sbwad(sdh),
+	sdret = brcmf_sdcard_recv_buf(card, brcmf_sdcard_cur_sbwad(card),
 				SDIO_FUNC_2,
 				F2SYNC, (bus->rxctl + firstread), rdlen,
 				NULL, NULL, NULL);
@@ -3555,14 +3560,14 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 		 * packet and and copy into the chain.
 		 */
 		if (usechain) {
-			errcode = brcmf_sdcard_recv_buf(bus->sdh,
-					brcmf_sdcard_cur_sbwad(bus->sdh),
+			errcode = brcmf_sdcard_recv_buf(bus->card,
+					brcmf_sdcard_cur_sbwad(bus->card),
 					SDIO_FUNC_2,
 					F2SYNC, (u8 *) pfirst->data, dlen,
 					pfirst, NULL, NULL);
 		} else if (bus->dataptr) {
-			errcode = brcmf_sdcard_recv_buf(bus->sdh,
-					brcmf_sdcard_cur_sbwad(bus->sdh),
+			errcode = brcmf_sdcard_recv_buf(bus->card,
+					brcmf_sdcard_cur_sbwad(bus->card),
 					SDIO_FUNC_2,
 					F2SYNC, bus->dataptr, dlen,
 					NULL, NULL, NULL);
@@ -3831,7 +3836,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 static uint
 brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 {
-	struct brcmf_sdio *sdh = bus->sdh;
+	struct brcmf_sdio_card *card = bus->card;
 
 	u16 len, check;	/* Extracted hardware header fields */
 	u8 chan, seq, doff;	/* Extracted software header fields */
@@ -3940,11 +3945,11 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					ASSERT(bus->rxctl >= bus->rxbuf);
 					rxbuf = bus->rxctl;
 					/* Read the entire frame */
-					sdret = brcmf_sdcard_recv_buf(sdh,
-						    brcmf_sdcard_cur_sbwad(sdh),
-						    SDIO_FUNC_2, F2SYNC,
-						    rxbuf, rdlen,
-						    NULL, NULL, NULL);
+					sdret = brcmf_sdcard_recv_buf(card,
+						   brcmf_sdcard_cur_sbwad(card),
+						   SDIO_FUNC_2, F2SYNC,
+						   rxbuf, rdlen,
+						   NULL, NULL, NULL);
 					bus->f2rxdata++;
 					ASSERT(sdret != -BCME_PENDING);
 
@@ -3981,8 +3986,8 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
 				rxbuf = (u8 *) (pkt->data);
 				/* Read the entire frame */
-				sdret = brcmf_sdcard_recv_buf(sdh,
-						brcmf_sdcard_cur_sbwad(sdh),
+				sdret = brcmf_sdcard_recv_buf(card,
+						brcmf_sdcard_cur_sbwad(card),
 						SDIO_FUNC_2, F2SYNC,
 						rxbuf, rdlen,
 						pkt, NULL, NULL);
@@ -4160,7 +4165,8 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			break;
 
 		/* Read frame header (hardware and software) */
-		sdret = brcmf_sdcard_recv_buf(sdh, brcmf_sdcard_cur_sbwad(sdh),
+		sdret = brcmf_sdcard_recv_buf(card,
+				brcmf_sdcard_cur_sbwad(card),
 				SDIO_FUNC_2, F2SYNC, bus->rxhdr, firstread,
 				NULL, NULL, NULL);
 		bus->f2rxhdrs++;
@@ -4321,7 +4327,8 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
 
 		/* Read the remaining frame data */
-		sdret = brcmf_sdcard_recv_buf(sdh, brcmf_sdcard_cur_sbwad(sdh),
+		sdret = brcmf_sdcard_recv_buf(card,
+				brcmf_sdcard_cur_sbwad(card),
 				SDIO_FUNC_2, F2SYNC, ((u8 *) (pkt->data)),
 				rdlen, pkt, NULL, NULL);
 		bus->f2rxdata++;
@@ -4499,7 +4506,7 @@ static u32 brcmf_sdbrcm_hostmail(dhd_bus_t *bus)
 
 static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 {
-	struct brcmf_sdio *sdh = bus->sdh;
+	struct brcmf_sdio_card *card = bus->card;
 	struct sdpcmd_regs *regs = bus->regs;
 	u32 intstatus, newstatus = 0;
 	uint retries = 0;
@@ -4523,7 +4530,7 @@ static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 
 #ifdef BCMDBG
 		/* Check for inconsistent device control */
-		devctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+		devctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					       SBSDIO_DEVICE_CTL, &err);
 		if (err) {
 			DHD_ERROR(("%s: error reading DEVCTL: %d\n",
@@ -4535,7 +4542,7 @@ static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 #endif				/* BCMDBG */
 
 		/* Read CSR, if clock on switch to AVAIL, else ignore */
-		clkctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+		clkctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			DHD_ERROR(("%s: error reading CSR: %d\n", __func__,
@@ -4547,7 +4554,7 @@ static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 			  clkctl));
 
 		if (SBSDIO_HTAV(clkctl)) {
-			devctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+			devctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 						       SBSDIO_DEVICE_CTL, &err);
 			if (err) {
 				DHD_ERROR(("%s: error reading DEVCTL: %d\n",
@@ -4555,7 +4562,7 @@ static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 				bus->dhd->busstate = DHD_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, devctl, &err);
 			if (err) {
 				DHD_ERROR(("%s: error writing DEVCTL: %d\n",
@@ -4580,7 +4587,7 @@ static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 		bus->ipend = false;
 		R_SDREG(newstatus, &regs->intstatus, retries);
 		bus->f1regdata++;
-		if (brcmf_sdcard_regfail(bus->sdh))
+		if (brcmf_sdcard_regfail(bus->card))
 			newstatus = 0;
 		newstatus &= bus->hostintmask;
 		bus->fcstate = !!(newstatus & I_HMB_FC_STATE);
@@ -4656,18 +4663,18 @@ clkwait:
 	 * or clock availability.  (Allows tx loop to check ipend if desired.)
 	 * (Unless register access seems hosed, as we may not be able to ACK...)
 	 */
-	if (bus->intr && bus->intdis && !brcmf_sdcard_regfail(sdh)) {
+	if (bus->intr && bus->intdis && !brcmf_sdcard_regfail(card)) {
 		DHD_INTR(("%s: enable SDIO interrupts, rxdone %d framecnt %d\n",
 			  __func__, rxdone, framecnt));
 		bus->intdis = false;
-		brcmf_sdcard_intr_enable(sdh);
+		brcmf_sdcard_intr_enable(card);
 	}
 
 	if (DATAOK(bus) && bus->ctrl_frame_stat &&
 		(bus->clkstate == CLK_AVAIL)) {
 		int ret, i;
 
-		ret = brcmf_sdbrcm_send_buf(bus, brcmf_sdcard_cur_sbwad(sdh),
+		ret = brcmf_sdbrcm_send_buf(bus, brcmf_sdcard_cur_sbwad(card),
 			SDIO_FUNC_2, F2SYNC, (u8 *) bus->ctrl_frame_buf,
 			(u32) bus->ctrl_frame_len, NULL, NULL, NULL);
 		ASSERT(ret != -BCME_PENDING);
@@ -4679,19 +4686,19 @@ clkwait:
 				"terminate frame.\n", __func__, ret));
 			bus->tx_sderrs++;
 
-			brcmf_sdcard_abort(sdh, SDIO_FUNC_2);
+			brcmf_sdcard_abort(card, SDIO_FUNC_2);
 
-			brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
 					 NULL);
 			bus->f1regdata++;
 
 			for (i = 0; i < 3; i++) {
 				u8 hi, lo;
-				hi = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+				hi = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCHI,
 						     NULL);
-				lo = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+				lo = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCLO,
 						     NULL);
 				bus->f1regdata += 2;
@@ -4720,9 +4727,11 @@ clkwait:
 		 else await next interrupt */
 	/* On failed register access, all bets are off:
 		 no resched or interrupts */
-	if ((bus->dhd->busstate == DHD_BUS_DOWN) || brcmf_sdcard_regfail(sdh)) {
+	if ((bus->dhd->busstate == DHD_BUS_DOWN) ||
+	     brcmf_sdcard_regfail(card)) {
 		DHD_ERROR(("%s: failed backplane access over SDIO, halting "
-			"operation %d\n", __func__, brcmf_sdcard_regfail(sdh)));
+			   "operation %d\n", __func__,
+			  brcmf_sdcard_regfail(card)));
 		bus->dhd->busstate = DHD_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
@@ -4752,7 +4761,7 @@ clkwait:
 void brcmf_sdbrcm_isr(void *arg)
 {
 	dhd_bus_t *bus = (dhd_bus_t *) arg;
-	struct brcmf_sdio *sdh;
+	struct brcmf_sdio_card *card;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -4760,7 +4769,7 @@ void brcmf_sdbrcm_isr(void *arg)
 		DHD_ERROR(("%s : bus is null pointer , exit\n", __func__));
 		return;
 	}
-	sdh = bus->sdh;
+	card = bus->card;
 
 	if (bus->dhd->busstate == DHD_BUS_DOWN) {
 		DHD_ERROR(("%s : bus is down. we have nothing to do\n",
@@ -4783,7 +4792,7 @@ void brcmf_sdbrcm_isr(void *arg)
 	else
 		DHD_ERROR(("brcmf_sdbrcm_isr() w/o interrupt configured!\n"));
 
-	brcmf_sdcard_intr_disable(sdh);
+	brcmf_sdcard_intr_disable(card);
 	bus->intdis = true;
 
 #if defined(SDIO_ISR_THREAD)
@@ -5087,7 +5096,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *dhdp)
 
 			if (!bus->dpc_sched) {
 				u8 devpend;
-				devpend = brcmf_sdcard_cfg_read(bus->sdh,
+				devpend = brcmf_sdcard_cfg_read(bus->card,
 						SDIO_FUNC_0, SDIO_CCCR_INTx,
 						NULL);
 				intstatus =
@@ -5101,7 +5110,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *dhdp)
 				bus->pollcnt++;
 				bus->ipend = true;
 				if (bus->intr)
-					brcmf_sdcard_intr_disable(bus->sdh);
+					brcmf_sdcard_intr_disable(bus->card);
 
 				bus->dpc_sched = true;
 				brcmf_sdbrcm_sched_dpc(bus);
@@ -5234,7 +5243,7 @@ static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 
 static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 			   u16 slot, u16 func, uint bustype, void *regsva,
-			   void *sdh)
+			   void *card)
 {
 	int ret;
 	dhd_bus_t *bus;
@@ -5316,7 +5325,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 		DHD_ERROR(("%s: kmalloc of dhd_bus_t failed\n", __func__));
 		goto fail;
 	}
-	bus->sdh = sdh;
+	bus->card = card;
 	bus->cl_devid = (u16) devid;
 	bus->bus = DHD_BUS;
 	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
@@ -5324,7 +5333,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 					 else use locally malloced rxbuf */
 
 	/* attempt to attach to the dongle */
-	if (!(brcmf_sdbrcm_probe_attach(bus, sdh, regsva, devid))) {
+	if (!(brcmf_sdbrcm_probe_attach(bus, card, regsva, devid))) {
 		DHD_ERROR(("%s: brcmf_sdbrcm_probe_attach failed\n", __func__));
 		goto fail;
 	}
@@ -5384,12 +5393,12 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	}
 
 	/* Allocate buffers */
-	if (!(brcmf_sdbrcm_probe_malloc(bus, sdh))) {
+	if (!(brcmf_sdbrcm_probe_malloc(bus, card))) {
 		DHD_ERROR(("%s: brcmf_sdbrcm_probe_malloc failed\n", __func__));
 		goto fail;
 	}
 
-	if (!(brcmf_sdbrcm_probe_init(bus, sdh))) {
+	if (!(brcmf_sdbrcm_probe_init(bus, card))) {
 		DHD_ERROR(("%s: brcmf_sdbrcm_probe_init failed\n", __func__));
 		goto fail;
 	}
@@ -5397,8 +5406,8 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	/* Register interrupt callback, but mask it (not operational yet). */
 	DHD_INTR(("%s: disable SDIO interrupts (not interested yet)\n",
 		  __func__));
-	brcmf_sdcard_intr_disable(sdh);
-	ret = brcmf_sdcard_intr_reg(sdh, brcmf_sdbrcm_isr, bus);
+	brcmf_sdcard_intr_disable(card);
+	ret = brcmf_sdcard_intr_reg(card, brcmf_sdbrcm_isr, bus);
 	if (ret != 0) {
 		DHD_ERROR(("%s: FAILED: sdcard_intr_reg returned %d\n",
 			   __func__, ret));
@@ -5430,7 +5439,7 @@ fail:
 }
 
 static bool
-brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
+brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *card, void *regsva,
 			  u16 devid)
 {
 	u8 clkctl = 0;
@@ -5444,7 +5453,7 @@ brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
 
 #ifdef BCMDBG
 	printk(KERN_DEBUG "F1 signature read @0x18000000=0x%4x\n",
-	       brcmf_sdcard_reg_read(bus->sdh, SI_ENUM_BASE, 4));
+	       brcmf_sdcard_reg_read(bus->card, SI_ENUM_BASE, 4));
 
 #endif				/* BCMDBG */
 
@@ -5453,11 +5462,11 @@ brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
 	 * programs PLL control regs
 	 */
 
-	brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
+	brcmf_sdcard_cfg_write(card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 			 DHD_INIT_CLKCTL1, &err);
 	if (!err)
 		clkctl =
-		    brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
+		    brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
 					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != DHD_INIT_CLKCTL1)) {
@@ -5472,7 +5481,7 @@ brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
 		goto fail;
 	}
 
-	brcmf_sdcard_chipinfo(sdh, bus->ci->chip, bus->ci->chiprev);
+	brcmf_sdcard_chipinfo(card, bus->ci->chip, bus->ci->chiprev);
 
 	if (!brcmf_sdbrcm_chipmatch((u16) bus->ci->chip)) {
 		DHD_ERROR(("%s: unsupported chip: 0x%04x\n",
@@ -5484,7 +5493,7 @@ brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
 
 	/* Get info on the ARM and SOCRAM cores... */
 	if (!DHD_NOPMU(bus)) {
-		bus->armrev = SBCOREREV(brcmf_sdcard_reg_read(bus->sdh,
+		bus->armrev = SBCOREREV(brcmf_sdcard_reg_read(bus->card,
 			CORE_SB(bus->ci->armcorebase, sbidhigh), 4));
 		bus->orig_ramsize = bus->ci->ramsize;
 		if (!(bus->orig_ramsize)) {
@@ -5523,7 +5532,7 @@ fail:
 	return false;
 }
 
-static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *sdh)
+static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *card)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -5563,7 +5572,7 @@ fail:
 	return false;
 }
 
-static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh)
+static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *card)
 {
 	s32 fnum;
 
@@ -5574,7 +5583,7 @@ static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh)
 #endif				/* SDTEST */
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+	brcmf_sdcard_cfg_write(card, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			       SDIO_FUNC_ENABLE_1, NULL);
 
 	bus->dhd->busstate = DHD_BUS_DOWN;
@@ -5583,7 +5592,7 @@ static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh)
 	bus->prev_rxlim_hit = 0;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdcard_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR, 0,
+	brcmf_sdcard_cfg_write(card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR, 0,
 			       NULL);
 
 	/* ...and initialize clock/power states */
@@ -5593,7 +5602,7 @@ static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh)
 
 	/* Query the F2 block size, set roundup accordingly */
 	fnum = 2;
-	if (brcmf_sdcard_iovar_op(sdh, "sd_blocksize", &fnum, sizeof(s32),
+	if (brcmf_sdcard_iovar_op(card, "sd_blocksize", &fnum, sizeof(s32),
 			    &bus->blocksize, sizeof(s32), false) != 0) {
 		bus->blocksize = 0;
 		DHD_ERROR(("%s: fail on %s get\n", __func__, "sd_blocksize"));
@@ -5605,7 +5614,7 @@ static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh)
 
 	/* Query if bus module supports packet chaining,
 		 default to use if supported */
-	if (brcmf_sdcard_iovar_op(sdh, "sd_rxchain", NULL, 0,
+	if (brcmf_sdcard_iovar_op(card, "sd_rxchain", NULL, 0,
 			    &bus->sd_rxchain, sizeof(s32),
 			    false) != 0) {
 		bus->sd_rxchain = false;
@@ -5620,7 +5629,7 @@ static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh)
 }
 
 static bool
-brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *sdh)
+brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *card)
 {
 	bool ret;
 
@@ -5641,8 +5650,8 @@ static void brcmf_sdbrcm_release(dhd_bus_t *bus)
 
 	if (bus) {
 		/* De-register interrupt handler */
-		brcmf_sdcard_intr_disable(bus->sdh);
-		brcmf_sdcard_intr_dereg(bus->sdh);
+		brcmf_sdcard_intr_disable(bus->card);
+		brcmf_sdcard_intr_dereg(bus->card);
 
 		if (bus->dhd) {
 			brcmf_detach(bus->dhd);
@@ -5947,7 +5956,7 @@ brcmf_sdbrcm_send_buf(dhd_bus_t *bus, u32 addr, uint fn, uint flags,
 		    brcmf_sdio_cmplt_fn_t complete, void *handle)
 {
 	return brcmf_sdcard_send_buf
-		(bus->sdh, addr, fn, flags, buf, nbytes, pkt, complete,
+		(bus->card, addr, fn, flags, buf, nbytes, pkt, complete,
 		 handle);
 }
 
@@ -6006,14 +6015,14 @@ int brcmf_bus_devreset(struct brcmf_pub *dhdp, u8 flag)
 		if (bus->dhd->dongle_reset) {
 			/* Turn on WLAN */
 			/* Reset SD client */
-			brcmf_sdcard_reset(bus->sdh);
+			brcmf_sdcard_reset(bus->card);
 
 			/* Attempt to re-attach & download */
-			if (brcmf_sdbrcm_probe_attach(bus, bus->sdh,
+			if (brcmf_sdbrcm_probe_attach(bus, bus->card,
 						 (u32 *) SI_ENUM_BASE,
 						 bus->cl_devid)) {
 				/* Attempt to download binary to the dongle */
-				if (brcmf_sdbrcm_probe_init(bus, bus->sdh)) {
+				if (brcmf_sdbrcm_probe_init(bus, bus->card)) {
 					/* Re-init bus, enable F2 transfer */
 					brcmf_sdbrcm_bus_init(
 						(struct brcmf_pub *) bus->dhd,
@@ -6040,8 +6049,8 @@ int brcmf_bus_devreset(struct brcmf_pub *dhdp, u8 flag)
 }
 
 static int
-brcmf_sdbrcm_chip_recognition(struct brcmf_sdio *sdh, struct chip_info *ci,
-			    void *regs)
+brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_card *card,
+			      struct chip_info *ci, void *regs)
 {
 	u32 regdata;
 
@@ -6052,7 +6061,7 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio *sdh, struct chip_info *ci,
 	 * other ways of recognition should be added here.
 	 */
 	ci->cccorebase = (u32)regs;
-	regdata = brcmf_sdcard_reg_read(sdh,
+	regdata = brcmf_sdcard_reg_read(card,
 				CORE_CC_REG(ci->cccorebase, chipid), 4);
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
@@ -6074,15 +6083,15 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio *sdh, struct chip_info *ci,
 		return -ENODEV;
 	}
 
-	regdata = brcmf_sdcard_reg_read(sdh,
+	regdata = brcmf_sdcard_reg_read(card,
 		CORE_SB(ci->cccorebase, sbidhigh), 4);
 	ci->ccrev = SBCOREREV(regdata);
 
-	regdata = brcmf_sdcard_reg_read(sdh,
+	regdata = brcmf_sdcard_reg_read(card,
 		CORE_CC_REG(ci->cccorebase, pmucapabilities), 4);
 	ci->pmurev = regdata & PCAP_REV_MASK;
 
-	regdata = brcmf_sdcard_reg_read(sdh,
+	regdata = brcmf_sdcard_reg_read(card,
 					CORE_SB(ci->buscorebase, sbidhigh), 4);
 	ci->buscorerev = SBCOREREV(regdata);
 	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
@@ -6092,87 +6101,87 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio *sdh, struct chip_info *ci,
 		ci->buscorerev, ci->buscoretype));
 
 	/* get chipcommon capabilites */
-	ci->cccaps = brcmf_sdcard_reg_read(sdh,
+	ci->cccaps = brcmf_sdcard_reg_read(card,
 		CORE_CC_REG(ci->cccorebase, capabilities), 4);
 
 	return 0;
 }
 
 static void
-brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio *sdh, u32 corebase)
+brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_card *card, u32 corebase)
 {
 	u32 regdata;
 
-	regdata = brcmf_sdcard_reg_read(sdh,
+	regdata = brcmf_sdcard_reg_read(card,
 		CORE_SB(corebase, sbtmstatelow), 4);
 	if (regdata & SBTML_RESET)
 		return;
 
-	regdata = brcmf_sdcard_reg_read(sdh,
+	regdata = brcmf_sdcard_reg_read(card,
 		CORE_SB(corebase, sbtmstatelow), 4);
 	if ((regdata & (SICF_CLOCK_EN << SBTML_SICF_SHIFT)) != 0) {
 		/*
 		 * set target reject and spin until busy is clear
 		 * (preserve core-specific bits)
 		 */
-		regdata = brcmf_sdcard_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(card,
 			CORE_SB(corebase, sbtmstatelow), 4);
-		brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+		brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatelow), 4,
 			regdata | SBTML_REJ);
 
-		regdata = brcmf_sdcard_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(card,
 			CORE_SB(corebase, sbtmstatelow), 4);
 		udelay(1);
-		SPINWAIT((brcmf_sdcard_reg_read(sdh,
+		SPINWAIT((brcmf_sdcard_reg_read(card,
 			CORE_SB(corebase, sbtmstatehigh), 4) &
 			SBTMH_BUSY), 100000);
 
-		regdata = brcmf_sdcard_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(card,
 			CORE_SB(corebase, sbtmstatehigh), 4);
 		if (regdata & SBTMH_BUSY)
 			DHD_ERROR(("%s: ARM core still busy\n", __func__));
 
-		regdata = brcmf_sdcard_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(card,
 			CORE_SB(corebase, sbidlow), 4);
 		if (regdata & SBIDL_INIT) {
-			regdata = brcmf_sdcard_reg_read(sdh,
+			regdata = brcmf_sdcard_reg_read(card,
 				CORE_SB(corebase, sbimstate), 4) |
 				SBIM_RJ;
-			brcmf_sdcard_reg_write(sdh,
+			brcmf_sdcard_reg_write(card,
 				CORE_SB(corebase, sbimstate), 4,
 				regdata);
-			regdata = brcmf_sdcard_reg_read(sdh,
+			regdata = brcmf_sdcard_reg_read(card,
 				CORE_SB(corebase, sbimstate), 4);
 			udelay(1);
-			SPINWAIT((brcmf_sdcard_reg_read(sdh,
+			SPINWAIT((brcmf_sdcard_reg_read(card,
 				CORE_SB(corebase, sbimstate), 4) &
 				SBIM_BY), 100000);
 		}
 
 		/* set reset and reject while enabling the clocks */
-		brcmf_sdcard_reg_write(sdh,
+		brcmf_sdcard_reg_write(card,
 			CORE_SB(corebase, sbtmstatelow), 4,
 			(((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
 			SBTML_REJ | SBTML_RESET));
-		regdata = brcmf_sdcard_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(card,
 			CORE_SB(corebase, sbtmstatelow), 4);
 		udelay(10);
 
 		/* clear the initiator reject bit */
-		regdata = brcmf_sdcard_reg_read(sdh,
+		regdata = brcmf_sdcard_reg_read(card,
 			CORE_SB(corebase, sbidlow), 4);
 		if (regdata & SBIDL_INIT) {
-			regdata = brcmf_sdcard_reg_read(sdh,
+			regdata = brcmf_sdcard_reg_read(card,
 				CORE_SB(corebase, sbimstate), 4) &
 				~SBIM_RJ;
-			brcmf_sdcard_reg_write(sdh,
+			brcmf_sdcard_reg_write(card,
 				CORE_SB(corebase, sbimstate), 4,
 				regdata);
 		}
 	}
 
 	/* leave reset and reject asserted */
-	brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatelow), 4,
 		(SBTML_REJ | SBTML_RESET));
 	udelay(1);
 }
@@ -6198,7 +6207,7 @@ brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs)
 	/* bus/core/clk setup for register access */
 	/* Try forcing SDIO core to do ALPAvail request only */
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
-	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
+	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 			clkset, &err);
 	if (err) {
 		DHD_ERROR(("%s: error writing for HT off\n", __func__));
@@ -6207,11 +6216,11 @@ brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs)
 
 	/* If register supported, wait for ALPAvail and then force ALP */
 	/* This may take up to 15 milliseconds */
-	clkval = brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_1,
+	clkval = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR, NULL);
 	if ((clkval & ~SBSDIO_AVBITS) == clkset) {
 		SPINWAIT(((clkval =
-				brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_1,
+				brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
 						SBSDIO_FUNC1_CHIPCLKCSR,
 						NULL)),
 				!SBSDIO_ALPAV(clkval)),
@@ -6224,7 +6233,7 @@ brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs)
 		}
 		clkset = SBSDIO_FORCE_HW_CLKREQ_OFF |
 				SBSDIO_FORCE_ALP;
-		brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1,
 				SBSDIO_FUNC1_CHIPCLKCSR,
 				clkset, &err);
 		udelay(65);
@@ -6236,10 +6245,10 @@ brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs)
 	}
 
 	/* Also, disable the extra SDIO pull-ups */
-	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_SDIOPULLUP,
+	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_SDIOPULLUP,
 			       0, NULL);
 
-	err = brcmf_sdbrcm_chip_recognition(bus->sdh, ci, regs);
+	err = brcmf_sdbrcm_chip_recognition(bus->card, ci, regs);
 	if (err)
 		goto fail;
 
@@ -6247,23 +6256,23 @@ brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs)
 	 * Make sure any on-chip ARM is off (in case strapping is wrong),
 	 * or downloaded code was already running.
 	 */
-	brcmf_sdbrcm_chip_disablecore(bus->sdh, ci->armcorebase);
+	brcmf_sdbrcm_chip_disablecore(bus->card, ci->armcorebase);
 
-	brcmf_sdcard_reg_write(bus->sdh,
+	brcmf_sdcard_reg_write(bus->card,
 		CORE_CC_REG(ci->cccorebase, gpiopullup), 4, 0);
-	brcmf_sdcard_reg_write(bus->sdh,
+	brcmf_sdcard_reg_write(bus->card,
 		CORE_CC_REG(ci->cccorebase, gpiopulldown), 4, 0);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 		SDIO_FUNC_ENABLE_1, NULL);
 
 	/* WAR: cmd52 backplane read so core HW will drop ALPReq */
-	clkval = brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_1,
+	clkval = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
 			0, NULL);
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdcard_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
+	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 			       0, NULL);
 
 	bus->ci = ci;
@@ -6275,7 +6284,7 @@ fail:
 }
 
 static void
-brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio *sdh, u32 corebase)
+brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_card *card, u32 corebase)
 {
 	u32 regdata;
 
@@ -6283,37 +6292,37 @@ brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio *sdh, u32 corebase)
 	 * Must do the disable sequence first to work for
 	 * arbitrary current core state.
 	 */
-	brcmf_sdbrcm_chip_disablecore(sdh, corebase);
+	brcmf_sdbrcm_chip_disablecore(card, corebase);
 
 	/*
 	 * Now do the initialization sequence.
 	 * set reset while enabling the clock and
 	 * forcing them on throughout the core
 	 */
-	brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatelow), 4,
 		((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
 		SBTML_RESET);
 	udelay(1);
 
-	regdata = brcmf_sdcard_reg_read(sdh, CORE_SB(corebase, sbtmstatehigh),
+	regdata = brcmf_sdcard_reg_read(card, CORE_SB(corebase, sbtmstatehigh),
 					4);
 	if (regdata & SBTMH_SERR)
-		brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatehigh),
+		brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatehigh),
 				       4, 0);
 
-	regdata = brcmf_sdcard_reg_read(sdh, CORE_SB(corebase, sbimstate), 4);
+	regdata = brcmf_sdcard_reg_read(card, CORE_SB(corebase, sbimstate), 4);
 	if (regdata & (SBIM_IBE | SBIM_TO))
-		brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbimstate), 4,
+		brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbimstate), 4,
 			regdata & ~(SBIM_IBE | SBIM_TO));
 
 	/* clear reset and allow it to propagate throughout the core */
-	brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatelow), 4,
 		(SICF_FGC << SBTML_SICF_SHIFT) |
 		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
 	udelay(1);
 
 	/* leave clock enabled */
-	brcmf_sdcard_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatelow), 4,
 		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
 	udelay(1);
 }
@@ -6407,15 +6416,15 @@ brcmf_sdbrcm_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
 			}
 		}
 
-		brcmf_sdcard_reg_write(bus->sdh,
+		brcmf_sdcard_reg_write(bus->card,
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
 			4, 1);
-		cc_data_temp = brcmf_sdcard_reg_read(bus->sdh,
+		cc_data_temp = brcmf_sdcard_reg_read(bus->card,
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr), 4);
 		cc_data_temp &= ~str_mask;
 		drivestrength_sel <<= str_shift;
 		cc_data_temp |= drivestrength_sel;
-		brcmf_sdcard_reg_write(bus->sdh,
+		brcmf_sdcard_reg_write(bus->card,
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
 			4, cc_data_temp);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 17ea8b2..5c5bbca 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -62,7 +62,7 @@ extern const uint brcmf_sdio_msglevel;
 #define SDIOD_MAX_IOFUNCS	7
 
 /* forward declarations */
-struct brcmf_sdio;
+struct brcmf_sdio_card;
 typedef void (*brcmf_sdiocard_cb_fn_t) (void *);
 
 /* Attach and build an interface to the underlying SD host driver.
@@ -73,35 +73,38 @@ typedef void (*brcmf_sdiocard_cb_fn_t) (void *);
  *    implementation may maintain a single "default" handle (e.g. the first or
  *    most recent one) to enable single-instance implementations to pass NULL.
  */
-extern struct brcmf_sdio *brcmf_sdcard_attach(void *cfghdl, void **regsva,
+extern struct brcmf_sdio_card *brcmf_sdcard_attach(void *cfghdl, void **regsva,
 					  uint irq);
 
 /* Detach - freeup resources allocated in attach */
-extern int brcmf_sdcard_detach(void *sdh);
+extern int brcmf_sdcard_detach(struct brcmf_sdio_card *card);
 
 /* Query if SD device interrupts are enabled */
-extern bool brcmf_sdcard_intr_query(void *sdh);
+extern bool brcmf_sdcard_intr_query(struct brcmf_sdio_card *card);
 
 /* Enable/disable SD interrupt */
-extern int brcmf_sdcard_intr_enable(void *sdh);
-extern int brcmf_sdcard_intr_disable(void *sdh);
+extern int brcmf_sdcard_intr_enable(struct brcmf_sdio_card *card);
+extern int brcmf_sdcard_intr_disable(struct brcmf_sdio_card *card);
 
 /* Register/deregister device interrupt handler. */
 extern int
-brcmf_sdcard_intr_reg(void *sdh, brcmf_sdiocard_cb_fn_t fn, void *argh);
+brcmf_sdcard_intr_reg(struct brcmf_sdio_card *card, brcmf_sdiocard_cb_fn_t fn,
+		      void *argh);
 
-extern int brcmf_sdcard_intr_dereg(void *sdh);
+extern int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card);
 
 #if defined(BCMDBG)
 /* Query pending interrupt status from the host controller */
-extern bool brcmf_sdcard_intr_pending(void *sdh);
+extern bool brcmf_sdcard_intr_pending(struct brcmf_sdio_card *card);
 #endif
 
 /* Register a callback to be called on device removal.
  * No-op in the case of non-removable/hardwired devices.
  */
 extern int
-brcmf_sdcard_devremove_reg(void *sdh, brcmf_sdiocard_cb_fn_t fn, void *argh);
+brcmf_sdcard_devremove_reg(struct brcmf_sdio_card *card,
+			   brcmf_sdiocard_cb_fn_t fn,
+			   void *argh);
 
 /* Access SDIO address space (e.g. CCCR) using CMD52 (single-byte interface).
  *   fn:   function number
@@ -109,15 +112,19 @@ brcmf_sdcard_devremove_reg(void *sdh, brcmf_sdiocard_cb_fn_t fn, void *argh);
  *   data: data byte to write
  *   err:  pointer to error code (or NULL)
  */
-extern u8 brcmf_sdcard_cfg_read(void *sdh, uint func, u32 addr, int *err);
-extern void brcmf_sdcard_cfg_write(void *sdh, uint func, u32 addr, u8 data,
-			     int *err);
+extern u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_card *card, uint func,
+				u32 addr, int *err);
+extern void brcmf_sdcard_cfg_write(struct brcmf_sdio_card *card, uint func,
+				   u32 addr, u8 data, int *err);
 
 /* Read/Write 4bytes from/to cfg space */
-extern u32 brcmf_sdcard_cfg_read_word(void *sdh, uint fnc_num, u32 addr,
-				   int *err);
-extern void brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr,
-				  u32 data, int *err);
+extern u32
+brcmf_sdcard_cfg_read_word(struct brcmf_sdio_card *card, uint fnc_num,
+			   u32 addr, int *err);
+
+extern void brcmf_sdcard_cfg_write_word(struct brcmf_sdio_card *card,
+					uint fnc_num, u32 addr,
+					u32 data, int *err);
 
 /* Read CIS content for specified function.
  *   fn:     function whose CIS is being requested (0 is common CIS)
@@ -126,18 +133,23 @@ extern void brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr,
  * Internally, this routine uses the values from the cis base regs (0x9-0xB)
  * to form an SDIO-space address to read the data from.
  */
-extern int brcmf_sdcard_cis_read(void *sdh, uint func, u8 *cis, uint length);
+extern int brcmf_sdcard_cis_read(struct brcmf_sdio_card *card, uint func,
+				 u8 *cis, uint length);
 
 /* Synchronous access to device (client) core registers via CMD53 to F1.
  *   addr: backplane address (i.e. >= regsva from attach)
  *   size: register width in bytes (2 or 4)
  *   data: data for register write
  */
-extern u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size);
-extern u32 brcmf_sdcard_reg_write(void *sdh, u32 addr, uint size, u32 data);
+extern u32
+brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size);
+
+extern u32
+brcmf_sdcard_reg_write(struct brcmf_sdio_card *card, u32 addr, uint size,
+		       u32 data);
 
 /* Indicate if last reg read/write failed */
-extern bool brcmf_sdcard_regfail(void *sdh);
+extern bool brcmf_sdcard_regfail(struct brcmf_sdio_card *card);
 
 /* Buffer transfer to/from device (client) core via cmd53.
  *   fn:       function number
@@ -153,12 +165,14 @@ extern bool brcmf_sdcard_regfail(void *sdh);
  */
 typedef void (*brcmf_sdio_cmplt_fn_t)
 		(void *handle, int status, bool sync_waiting);
-extern int brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
-		u8 *buf, uint nbytes, void *pkt,
-		brcmf_sdio_cmplt_fn_t complete, void *handle);
-extern int brcmf_sdcard_recv_buf(struct brcmf_sdio *sdh, u32 addr, uint fn,
-		uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt,
-		brcmf_sdio_cmplt_fn_t complete, void *handle);
+extern int
+brcmf_sdcard_send_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
+		      uint flags, u8 *buf, uint nbytes, void *pkt,
+		      brcmf_sdio_cmplt_fn_t complete, void *handle);
+extern int
+brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
+		      uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt,
+		      brcmf_sdio_cmplt_fn_t complete, void *handle);
 
 /* Flags bits */
 #define SDIO_REQ_4BYTE	0x1	/* Four-byte target (backplane) width (vs. two-byte) */
@@ -175,35 +189,35 @@ extern int brcmf_sdcard_recv_buf(struct brcmf_sdio *sdh, u32 addr, uint fn,
  *   nbytes:   number of bytes to transfer to/from buf
  * Returns 0 or error code.
  */
-extern int brcmf_sdcard_rwdata(void *sdh, uint rw, u32 addr, u8 *buf,
-			 uint nbytes);
+extern int brcmf_sdcard_rwdata(struct brcmf_sdio_card *card, uint rw, u32 addr,
+			       u8 *buf, uint nbytes);
 
 /* Issue an abort to the specified function */
-extern int brcmf_sdcard_abort(void *sdh, uint fn);
+extern int brcmf_sdcard_abort(struct brcmf_sdio_card *card, uint fn);
 
 /* Start SDIO Host Controller communication */
-extern int brcmf_sdcard_start(void *sdh, int stage);
+extern int brcmf_sdcard_start(struct brcmf_sdio_card *card, int stage);
 
 /* Stop SDIO Host Controller communication */
-extern int brcmf_sdcard_stop(void *sdh);
+extern int brcmf_sdcard_stop(struct brcmf_sdio_card *card);
 
 /* Returns the "Device ID" of target device on the SDIO bus. */
-extern int brcmf_sdcard_query_device(void *sdh);
+extern int brcmf_sdcard_query_device(struct brcmf_sdio_card *card);
 
 /* Returns the number of IO functions reported by the device */
-extern uint brcmf_sdcard_query_iofnum(void *sdh);
+extern uint brcmf_sdcard_query_iofnum(struct brcmf_sdio_card *card);
 
 /* Miscellaneous knob tweaker. */
-extern int brcmf_sdcard_iovar_op(void *sdh, const char *name,
-			   void *params, int plen, void *arg, int len,
-			   bool set);
+extern int brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
+				 void *params, int plen, void *arg, int len,
+				 bool set);
 
 /* Reset and reinitialize the device */
-extern int brcmf_sdcard_reset(struct brcmf_sdio *sdh);
+extern int brcmf_sdcard_reset(struct brcmf_sdio_card *card);
 
 /* helper functions */
 
-extern void *brcmf_sdcard_get_sdioh(struct brcmf_sdio *sdh);
+extern void *brcmf_sdcard_get_sdioh(struct brcmf_sdio_card *card);
 
 /* callback functions */
 struct brcmf_sdioh_driver {
@@ -221,7 +235,7 @@ extern int brcmf_sdio_function_init(void);
 extern int brcmf_sdio_register(struct brcmf_sdioh_driver *driver);
 extern void brcmf_sdio_unregister(void);
 extern bool brcmf_sdio_chipmatch(u16 vendor, u16 device);
-extern void brcmf_sdio_device_remove(void *sdh);
+extern void brcmf_sdio_device_remove(void *card);
 extern void brcmf_sdio_function_cleanup(void);
 
 extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
@@ -230,12 +244,13 @@ extern int brcmf_sdio_probe(struct device *dev);
 extern int brcmf_sdio_remove(struct device *dev);
 
 /* Function to pass device-status bits to DHD. */
-extern u32 brcmf_sdcard_get_dstatus(void *sdh);
+extern u32 brcmf_sdcard_get_dstatus(struct brcmf_sdio_card *card);
 
 /* Function to return current window addr */
-extern u32 brcmf_sdcard_cur_sbwad(void *sdh);
+extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card);
 
 /* Function to pass chipid and rev to lower layers for controlling pr's */
-extern void brcmf_sdcard_chipinfo(void *sdh, u32 chip, u32 chiprev);
+extern void brcmf_sdcard_chipinfo(struct brcmf_sdio_card *card, u32 chip,
+				  u32 chiprev);
 
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.1


