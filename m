Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3145 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab1GEUGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 01/21] staging: brcm80211: removed last occurrences
 of bcmsdh/BCMSDH
Date: Tue, 5 Jul 2011 22:05:57 +0200
Message-ID: <1309896377-4425-2-git-send-email-arend@broadcom.com> (sfid-20110705_220700_679485_6AC9D5FD)
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. This was a Broadcom specific acronym.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |  282 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |   14 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   35 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h  |   16 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |   27 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   34 ++--
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |   47 ++--
 7 files changed, 225 insertions(+), 230 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index d785b05..5eb95b2 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -13,7 +13,7 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-/* ****************** BCMSDH Interface Functions *************************** */
+/* ****************** SDIOCARD Interface Functions ***************************/
 
 #include <linux/types.h>
 #include <linux/netdevice.h>
@@ -31,7 +31,7 @@
 #include "dhd.h"
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
-const uint bcmsdh_msglevel = BCMSDH_ERROR_VAL;
+const uint brcmf_sdio_msglevel = BRCMF_SD_ERROR_VAL;
 
 struct brcmf_sdio {
 	bool init_success;	/* underlying driver successfully attached */
@@ -42,49 +42,49 @@ struct brcmf_sdio {
 	u32 sbwad;		/* Save backplane window address */
 };
 /* local copy of bcm sd handler */
-struct brcmf_sdio *l_bcmsdh;
+static struct brcmf_sdio *l_card;
 
 struct brcmf_sdio *brcmf_sdcard_attach(void *cfghdl, void **regsva, uint irq)
 {
-	struct brcmf_sdio *bcmsdh;
+	struct brcmf_sdio *card;
 
-	bcmsdh = kzalloc(sizeof(struct brcmf_sdio), GFP_ATOMIC);
-	if (bcmsdh == NULL) {
-		BCMSDH_ERROR(("bcmsdh_attach: out of memory"));
+	card = kzalloc(sizeof(struct brcmf_sdio), GFP_ATOMIC);
+	if (card == NULL) {
+		BRCMF_SD_ERROR(("sdcard_attach: out of memory"));
 		return NULL;
 	}
 
 	/* save the handler locally */
-	l_bcmsdh = bcmsdh;
+	l_card = card;
 
-	bcmsdh->sdioh = brcmf_sdioh_attach(cfghdl, irq);
-	if (!bcmsdh->sdioh) {
-		brcmf_sdcard_detach(bcmsdh);
+	card->sdioh = brcmf_sdioh_attach(cfghdl, irq);
+	if (!card->sdioh) {
+		brcmf_sdcard_detach(card);
 		return NULL;
 	}
 
-	bcmsdh->init_success = true;
+	card->init_success = true;
 
 	*regsva = (u32 *) SI_ENUM_BASE;
 
 	/* Report the BAR, to fix if needed */
-	bcmsdh->sbwad = SI_ENUM_BASE;
-	return bcmsdh;
+	card->sbwad = SI_ENUM_BASE;
+	return card;
 }
 
 int brcmf_sdcard_detach(void *sdh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 
-	if (bcmsdh != NULL) {
-		if (bcmsdh->sdioh) {
-			brcmf_sdioh_detach(bcmsdh->sdioh);
-			bcmsdh->sdioh = NULL;
+	if (card != NULL) {
+		if (card->sdioh) {
+			brcmf_sdioh_detach(card->sdioh);
+			card->sdioh = NULL;
 		}
-		kfree(bcmsdh);
+		kfree(card);
 	}
 
-	l_bcmsdh = NULL;
+	l_card = NULL;
 	return 0;
 }
 
@@ -92,19 +92,19 @@ int
 brcmf_sdcard_iovar_op(void *sdh, const char *name,
 		void *params, int plen, void *arg, int len, bool set)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	return brcmf_sdioh_iovar_op(bcmsdh->sdioh, name, params, plen, arg,
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
+	return brcmf_sdioh_iovar_op(card->sdioh, name, params, plen, arg,
 				    len, set);
 }
 
 bool brcmf_sdcard_intr_query(void *sdh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 	bool on;
 
-	ASSERT(bcmsdh);
-	status = brcmf_sdioh_interrupt_query(bcmsdh->sdioh, &on);
+	ASSERT(card);
+	status = brcmf_sdioh_interrupt_query(card->sdioh, &on);
 	if (status == 0)
 		return false;
 	else
@@ -113,47 +113,47 @@ bool brcmf_sdcard_intr_query(void *sdh)
 
 int brcmf_sdcard_intr_enable(void *sdh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	ASSERT(bcmsdh);
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
+	ASSERT(card);
 
-	return brcmf_sdioh_interrupt_set(bcmsdh->sdioh, true);
+	return brcmf_sdioh_interrupt_set(card->sdioh, true);
 }
 
 int brcmf_sdcard_intr_disable(void *sdh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	ASSERT(bcmsdh);
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
+	ASSERT(card);
 
-	return brcmf_sdioh_interrupt_set(bcmsdh->sdioh, false);
+	return brcmf_sdioh_interrupt_set(card->sdioh, false);
 }
 
-int brcmf_sdcard_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
+int brcmf_sdcard_intr_reg(void *sdh, brcmf_sdiocard_cb_fn_t fn, void *argh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	ASSERT(bcmsdh);
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
+	ASSERT(card);
 
-	return brcmf_sdioh_interrupt_register(bcmsdh->sdioh, fn, argh);
+	return brcmf_sdioh_interrupt_register(card->sdioh, fn, argh);
 }
 
 int brcmf_sdcard_intr_dereg(void *sdh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	ASSERT(bcmsdh);
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
+	ASSERT(card);
 
-	return brcmf_sdioh_interrupt_deregister(bcmsdh->sdioh);
+	return brcmf_sdioh_interrupt_deregister(card->sdioh);
 }
 
 #if defined(BCMDBG)
 bool brcmf_sdcard_intr_pending(void *sdh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 
 	ASSERT(sdh);
-	return brcmf_sdioh_interrupt_pending(bcmsdh->sdioh);
+	return brcmf_sdioh_interrupt_pending(card->sdioh);
 }
 #endif
 
-int brcmf_sdcard_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
+int brcmf_sdcard_devremove_reg(void *sdh, brcmf_sdiocard_cb_fn_t fn, void *argh)
 {
 	ASSERT(sdh);
 
@@ -163,17 +163,17 @@ int brcmf_sdcard_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 
 u8 brcmf_sdcard_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	s32 retry = 0;
 #endif
 	u8 data = 0;
 
-	if (!bcmsdh)
-		bcmsdh = l_bcmsdh;
+	if (!card)
+		card = l_card;
 
-	ASSERT(bcmsdh->init_success);
+	ASSERT(card->init_success);
 
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	do {
@@ -181,7 +181,7 @@ u8 brcmf_sdcard_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 			udelay(1000);
 #endif
 		status =
-		    brcmf_sdioh_cfg_read(bcmsdh->sdioh, fnc_num, addr,
+		    brcmf_sdioh_cfg_read(card->sdioh, fnc_num, addr,
 				   (u8 *) &data);
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	} while (status != 0
@@ -190,7 +190,7 @@ u8 brcmf_sdcard_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 	if (err)
 		*err = status;
 
-	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
+	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
 
 	return data;
@@ -199,16 +199,16 @@ u8 brcmf_sdcard_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 void
 brcmf_sdcard_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	s32 retry = 0;
 #endif
 
-	if (!bcmsdh)
-		bcmsdh = l_bcmsdh;
+	if (!card)
+		card = l_card;
 
-	ASSERT(bcmsdh->init_success);
+	ASSERT(card->init_success);
 
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	do {
@@ -216,7 +216,7 @@ brcmf_sdcard_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 			udelay(1000);
 #endif
 		status =
-		    brcmf_sdioh_cfg_write(bcmsdh->sdioh, fnc_num, addr,
+		    brcmf_sdioh_cfg_write(card->sdioh, fnc_num, addr,
 				    (u8 *) &data);
 #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
 	} while (status != 0
@@ -225,28 +225,28 @@ brcmf_sdcard_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 	if (err)
 		*err = status;
 
-	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
+	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
 }
 
 u32 brcmf_sdcard_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 	u32 data = 0;
 
-	if (!bcmsdh)
-		bcmsdh = l_bcmsdh;
+	if (!card)
+		card = l_card;
 
-	ASSERT(bcmsdh->init_success);
+	ASSERT(card->init_success);
 
-	status = brcmf_sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	status = brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
 		SDIOH_READ, fnc_num, addr, &data, 4);
 
 	if (err)
 		*err = status;
 
-	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
+	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
 
 	return data;
@@ -256,28 +256,28 @@ void
 brcmf_sdcard_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 		      int *err)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 
-	if (!bcmsdh)
-		bcmsdh = l_bcmsdh;
+	if (!card)
+		card = l_card;
 
-	ASSERT(bcmsdh->init_success);
+	ASSERT(card->init_success);
 
 	status =
-	    brcmf_sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	    brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
 			       SDIOH_WRITE, fnc_num, addr, &data, 4);
 
 	if (err)
 		*err = status;
 
-	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
+	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
 }
 
 int brcmf_sdcard_cis_read(void *sdh, uint func, u8 * cis, uint length)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 
 	u8 *tmp_buf, *tmp_ptr;
@@ -285,21 +285,21 @@ int brcmf_sdcard_cis_read(void *sdh, uint func, u8 * cis, uint length)
 	bool ascii = func & ~0xf;
 	func &= 0x7;
 
-	if (!bcmsdh)
-		bcmsdh = l_bcmsdh;
+	if (!card)
+		card = l_card;
 
-	ASSERT(bcmsdh->init_success);
+	ASSERT(card->init_success);
 	ASSERT(cis);
 	ASSERT(length <= SBSDIO_CIS_SIZE_LIMIT);
 
-	status = brcmf_sdioh_cis_read(bcmsdh->sdioh, func, cis, length);
+	status = brcmf_sdioh_cis_read(card->sdioh, func, cis, length);
 
 	if (ascii) {
 		/* Move binary bits to tmp and format them
 			 into the provided buffer. */
 		tmp_buf = kmalloc(length, GFP_ATOMIC);
 		if (tmp_buf == NULL) {
-			BCMSDH_ERROR(("%s: out of memory\n", __func__));
+			BRCMF_SD_ERROR(("%s: out of memory\n", __func__));
 			return -ENOMEM;
 		}
 		memcpy(tmp_buf, cis, length);
@@ -318,16 +318,16 @@ int brcmf_sdcard_cis_read(void *sdh, uint func, u8 * cis, uint length)
 static int brcmf_sdcard_set_sbaddr_window(void *sdh, u32 address)
 {
 	int err = 0;
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	brcmf_sdcard_cfg_write(bcmsdh, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
+	brcmf_sdcard_cfg_write(card, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
 			 (address >> 8) & SBSDIO_SBADDRLOW_MASK, &err);
 	if (!err)
-		brcmf_sdcard_cfg_write(bcmsdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_SBADDRMID,
 				       (address >> 16) & SBSDIO_SBADDRMID_MASK,
 				       &err);
 	if (!err)
-		brcmf_sdcard_cfg_write(bcmsdh, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_SBADDRHIGH,
 				       (address >> 24) & SBSDIO_SBADDRHIGH_MASK,
 				       &err);
@@ -337,35 +337,35 @@ static int brcmf_sdcard_set_sbaddr_window(void *sdh, u32 address)
 
 u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 	u32 word = 0;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 
-	BCMSDH_INFO(("%s:fun = 1, addr = 0x%x, ", __func__, addr));
+	BRCMF_SD_INFO(("%s:fun = 1, addr = 0x%x, ", __func__, addr));
 
-	if (!bcmsdh)
-		bcmsdh = l_bcmsdh;
+	if (!card)
+		card = l_card;
 
-	ASSERT(bcmsdh->init_success);
+	ASSERT(card->init_success);
 
-	if (bar0 != bcmsdh->sbwad) {
-		if (brcmf_sdcard_set_sbaddr_window(bcmsdh, bar0))
+	if (bar0 != card->sbwad) {
+		if (brcmf_sdcard_set_sbaddr_window(card, bar0))
 			return 0xFFFFFFFF;
 
-		bcmsdh->sbwad = bar0;
+		card->sbwad = bar0;
 	}
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	if (size == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = brcmf_sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	status = brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
 				    SDIOH_READ, SDIO_FUNC_1, addr, &word, size);
 
-	bcmsdh->regfail = (status != 0);
+	card->regfail = (status != 0);
 
-	BCMSDH_INFO(("u32data = 0x%x\n", word));
+	BRCMF_SD_INFO(("u32data = 0x%x\n", word));
 
 	/* if ok, return appropriately masked word */
 	if (status == 0) {
@@ -377,52 +377,52 @@ u32 brcmf_sdcard_reg_read(void *sdh, u32 addr, uint size)
 		case sizeof(u32):
 			return word;
 		default:
-			bcmsdh->regfail = true;
+			card->regfail = true;
 
 		}
 	}
 
 	/* otherwise, bad sdio access or invalid size */
-	BCMSDH_ERROR(("%s: error reading addr 0x%04x size %d\n", __func__,
+	BRCMF_SD_ERROR(("%s: error reading addr 0x%04x size %d\n", __func__,
 		      addr, size));
 	return 0xFFFFFFFF;
 }
 
 u32 brcmf_sdcard_reg_write(void *sdh, u32 addr, uint size, u32 data)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	int status;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	BCMSDH_INFO(("%s:fun = 1, addr = 0x%x, uint%ddata = 0x%x\n",
+	BRCMF_SD_INFO(("%s:fun = 1, addr = 0x%x, uint%ddata = 0x%x\n",
 		     __func__, addr, size * 8, data));
 
-	if (!bcmsdh)
-		bcmsdh = l_bcmsdh;
+	if (!card)
+		card = l_card;
 
-	ASSERT(bcmsdh->init_success);
+	ASSERT(card->init_success);
 
-	if (bar0 != bcmsdh->sbwad) {
-		err = brcmf_sdcard_set_sbaddr_window(bcmsdh, bar0);
+	if (bar0 != card->sbwad) {
+		err = brcmf_sdcard_set_sbaddr_window(card, bar0);
 		if (err)
 			return err;
 
-		bcmsdh->sbwad = bar0;
+		card->sbwad = bar0;
 	}
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	if (size == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 	status =
-	    brcmf_sdioh_request_word(bcmsdh->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	    brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
 			       SDIOH_WRITE, SDIO_FUNC_1, addr, &data, size);
-	bcmsdh->regfail = (status != 0);
+	card->regfail = (status != 0);
 
 	if (status == 0)
 		return 0;
 
-	BCMSDH_ERROR(("%s: error writing 0x%08x to addr 0x%04x size %d\n",
+	BRCMF_SD_ERROR(("%s: error writing 0x%08x to addr 0x%04x size %d\n",
 		      __func__, data, addr, size));
 	return 0xFFFFFFFF;
 }
@@ -433,9 +433,9 @@ bool brcmf_sdcard_regfail(void *sdh)
 }
 
 int
-brcmf_sdcard_recv_buf(struct brcmf_sdio *bcmsdh, u32 addr, uint fn, uint flags,
+brcmf_sdcard_recv_buf(struct brcmf_sdio *card, u32 addr, uint fn, uint flags,
 		u8 *buf, uint nbytes, struct sk_buff *pkt,
-		bcmsdh_cmplt_fn_t complete, void *handle)
+		brcmf_sdio_cmplt_fn_t complete, void *handle)
 {
 	int status;
 	uint incr_fix;
@@ -443,10 +443,10 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio *bcmsdh, u32 addr, uint fn, uint flags,
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	ASSERT(bcmsdh);
-	ASSERT(bcmsdh->init_success);
+	ASSERT(card);
+	ASSERT(card->init_success);
 
-	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
+	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
 		     __func__, fn, addr, nbytes));
 
 	/* Async not implemented yet */
@@ -454,12 +454,12 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio *bcmsdh, u32 addr, uint fn, uint flags,
 	if (flags & SDIO_REQ_ASYNC)
 		return -ENOTSUPP;
 
-	if (bar0 != bcmsdh->sbwad) {
-		err = brcmf_sdcard_set_sbaddr_window(bcmsdh, bar0);
+	if (bar0 != card->sbwad) {
+		err = brcmf_sdcard_set_sbaddr_window(card, bar0);
 		if (err)
 			return err;
 
-		bcmsdh->sbwad = bar0;
+		card->sbwad = bar0;
 	}
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
@@ -469,7 +469,7 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio *bcmsdh, u32 addr, uint fn, uint flags,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = brcmf_sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO,
+	status = brcmf_sdioh_request_buffer(card->sdioh, SDIOH_DATA_PIO,
 		incr_fix, SDIOH_READ, fn, addr, width, nbytes, buf, pkt);
 
 	return status;
@@ -478,18 +478,18 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio *bcmsdh, u32 addr, uint fn, uint flags,
 int
 brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 		u8 *buf, uint nbytes, void *pkt,
-		bcmsdh_cmplt_fn_t complete, void *handle)
+		brcmf_sdio_cmplt_fn_t complete, void *handle)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 	uint incr_fix;
 	uint width;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	ASSERT(bcmsdh);
-	ASSERT(bcmsdh->init_success);
+	ASSERT(card);
+	ASSERT(card->init_success);
 
-	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
+	BRCMF_SD_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
 		     __func__, fn, addr, nbytes));
 
 	/* Async not implemented yet */
@@ -497,12 +497,12 @@ brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 	if (flags & SDIO_REQ_ASYNC)
 		return -ENOTSUPP;
 
-	if (bar0 != bcmsdh->sbwad) {
-		err = brcmf_sdcard_set_sbaddr_window(bcmsdh, bar0);
+	if (bar0 != card->sbwad) {
+		err = brcmf_sdcard_set_sbaddr_window(card, bar0);
 		if (err)
 			return err;
 
-		bcmsdh->sbwad = bar0;
+		card->sbwad = bar0;
 	}
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
@@ -512,69 +512,69 @@ brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return brcmf_sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO,
+	return brcmf_sdioh_request_buffer(card->sdioh, SDIOH_DATA_PIO,
 		incr_fix, SDIOH_WRITE, fn, addr, width, nbytes, buf, pkt);
 }
 
 int brcmf_sdcard_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 
-	ASSERT(bcmsdh);
-	ASSERT(bcmsdh->init_success);
+	ASSERT(card);
+	ASSERT(card->init_success);
 	ASSERT((addr & SBSDIO_SBWINDOW_MASK) == 0);
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return brcmf_sdioh_request_buffer(bcmsdh->sdioh, SDIOH_DATA_PIO,
+	return brcmf_sdioh_request_buffer(card->sdioh, SDIOH_DATA_PIO,
 		SDIOH_DATA_INC, (rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
 		addr, 4, nbytes, buf, NULL);
 }
 
 int brcmf_sdcard_abort(void *sdh, uint fn)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 
-	return brcmf_sdioh_abort(bcmsdh->sdioh, fn);
+	return brcmf_sdioh_abort(card->sdioh, fn);
 }
 
 int brcmf_sdcard_start(void *sdh, int stage)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 
-	return brcmf_sdioh_start(bcmsdh->sdioh, stage);
+	return brcmf_sdioh_start(card->sdioh, stage);
 }
 
 int brcmf_sdcard_stop(void *sdh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 
-	return brcmf_sdioh_stop(bcmsdh->sdioh);
+	return brcmf_sdioh_stop(card->sdioh);
 }
 
 int brcmf_sdcard_query_device(void *sdh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
-	bcmsdh->vendevid = (PCI_VENDOR_ID_BROADCOM << 16) | 0;
-	return bcmsdh->vendevid;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
+	card->vendevid = (PCI_VENDOR_ID_BROADCOM << 16) | 0;
+	return card->vendevid;
 }
 
 uint brcmf_sdcard_query_iofnum(void *sdh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 
-	if (!bcmsdh)
-		bcmsdh = l_bcmsdh;
+	if (!card)
+		card = l_card;
 
-	return brcmf_sdioh_query_iofnum(bcmsdh->sdioh);
+	return brcmf_sdioh_query_iofnum(card->sdioh);
 }
 
 int brcmf_sdcard_reset(struct brcmf_sdio *sdh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 
-	return brcmf_sdioh_reset(bcmsdh->sdioh);
+	return brcmf_sdioh_reset(card->sdioh);
 }
 
 void *brcmf_sdcard_get_sdioh(struct brcmf_sdio *sdh)
@@ -591,12 +591,12 @@ u32 brcmf_sdcard_get_dstatus(void *sdh)
 
 u32 brcmf_sdcard_cur_sbwad(void *sdh)
 {
-	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
+	struct brcmf_sdio *card = (struct brcmf_sdio *) sdh;
 
-	if (!bcmsdh)
-		bcmsdh = l_bcmsdh;
+	if (!card)
+		card = l_card;
 
-	return bcmsdh->sbwad;
+	return card->sbwad;
 }
 
 void brcmf_sdcard_chipinfo(void *sdh, u32 chip, u32 chiprev)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 1198ee6..a3cf05f 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -38,8 +38,8 @@
 /**
  * SDIO Host Controller info
  */
-struct bcmsdh_hc {
-	struct bcmsdh_hc *next;
+struct sdio_hc {
+	struct sdio_hc *next;
 	struct device *dev;	/* platform device handle */
 	void *regs;		/* SDIO Host Controller address */
 	struct brcmf_sdio *sdh;	/* SDIO Host Controller handle */
@@ -49,7 +49,7 @@ struct bcmsdh_hc {
 					as edge and etc */
 	bool oob_irq_registered;
 };
-static struct bcmsdh_hc *sdhcinfo;
+static struct sdio_hc *sdhcinfo;
 
 /* driver info, initialized when brcmf_sdio_register is called */
 static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
@@ -111,7 +111,7 @@ EXPORT_SYMBOL(brcmf_sdio_remove);
 
 int brcmf_sdio_probe(struct device *dev)
 {
-	struct bcmsdh_hc *sdhc = NULL;
+	struct sdio_hc *sdhc = NULL;
 	unsigned long regs = 0;
 	struct brcmf_sdio *sdh = NULL;
 	int irq = 0;
@@ -119,7 +119,7 @@ int brcmf_sdio_probe(struct device *dev)
 	unsigned long irq_flags = 0;
 
 	/* allocate SDIO Host Controller state info */
-	sdhc = kzalloc(sizeof(struct bcmsdh_hc), GFP_ATOMIC);
+	sdhc = kzalloc(sizeof(struct sdio_hc), GFP_ATOMIC);
 	if (!sdhc) {
 		SDLX_MSG(("%s: out of memory\n", __func__));
 		goto err;
@@ -128,7 +128,7 @@ int brcmf_sdio_probe(struct device *dev)
 
 	sdh = brcmf_sdcard_attach((void *)0, (void **)&regs, irq);
 	if (!sdh) {
-		SDLX_MSG(("%s: bcmsdh_attach failed\n", __func__));
+		SDLX_MSG(("%s: attach failed\n", __func__));
 		goto err;
 	}
 
@@ -166,7 +166,7 @@ err:
 
 int brcmf_sdio_remove(struct device *dev)
 {
-	struct bcmsdh_hc *sdhc, *prev;
+	struct sdio_hc *sdhc, *prev;
 
 	sdhc = sdhcinfo;
 	drvinfo.detach(sdhc->ch);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index b7726f2..d0e9b3d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -27,7 +27,7 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include "sdio_host.h"
-#include "bcmsdbus.h"		/* bcmsdh to/from specific controller APIs */
+#include "bcmsdbus.h"
 #include "sdiovar.h"		/* ioctl/iovars */
 #include "dngl_stats.h"
 #include "dhd.h"
@@ -83,8 +83,8 @@ static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 	err_ret = sdio_enable_func(gInstance->func[1]);
 	sdio_release_host(gInstance->func[1]);
 	if (err_ret) {
-		sd_err(("bcmsdh_sdmmc: Failed to enable F1 Err: 0x%08x",
-			err_ret));
+		sd_err(("brcmf_sdioh_enablefuncs: Failed to enable F1 "
+			"Err: 0x%08x", err_ret));
 	}
 
 	return false;
@@ -128,7 +128,7 @@ struct sdioh_info *brcmf_sdioh_attach(void *bar0, uint irq)
 	sd->client_block_size[1] = 64;
 	err_ret = sdio_set_block_size(gInstance->func[1], 64);
 	if (err_ret)
-		sd_err(("bcmsdh_sdmmc: Failed to set F1 blocksize\n"));
+		sd_err(("brcmf_sdioh_attach: Failed to set F1 blocksize\n"));
 
 	/* Release host controller F1 */
 	sdio_release_host(gInstance->func[1]);
@@ -141,8 +141,8 @@ struct sdioh_info *brcmf_sdioh_attach(void *bar0, uint irq)
 		err_ret =
 		    sdio_set_block_size(gInstance->func[2], sd_f2_blocksize);
 		if (err_ret)
-			sd_err(("bcmsdh_sdmmc: Failed to set F2 blocksize "
-				"to %d\n", sd_f2_blocksize));
+			sd_err(("brcmf_sdioh_attach: Failed to set F2 blocksize"
+				" to %d\n", sd_f2_blocksize));
 
 		/* Release host controller F2 */
 		sdio_release_host(gInstance->func[2]);
@@ -549,7 +549,9 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 						    sdio_enable_func
 						    (gInstance->func[2]);
 						if (err_ret)
-							sd_err(("bcmsdh_sdmmc: enable F2 failed:%d",
+							sd_err(("request_byte: "
+								"enable F2 "
+								"failed:%d",
 								 err_ret));
 					} else {
 						/* Disable Function 2 */
@@ -557,7 +559,9 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 						    sdio_disable_func
 						    (gInstance->func[2]);
 						if (err_ret)
-							sd_err(("bcmsdh_sdmmc: Disab F2 failed:%d",
+							sd_err(("request_byte: "
+								"Disab F2 "
+								"failed:%d",
 								 err_ret));
 					}
 					sdio_release_host(gInstance->func[2]);
@@ -577,7 +581,7 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 				sdio_release_host(gInstance->func[func]);
 			}
 			else if (regaddr < 0xF0) {
-				sd_err(("bcmsdh_sdmmc: F0 Wr:0x%02x: write "
+				sd_err(("brcmf: F0 Wr:0x%02x: write "
 					"disallowed\n", regaddr));
 			} else {
 				/* Claim host controller, perform F0 write,
@@ -613,7 +617,7 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 	}
 
 	if (err_ret)
-		sd_err(("bcmsdh_sdmmc: Failed to %s byte F%d:@0x%05x=%02x, "
+		sd_err(("brcmf: Failed to %s byte F%d:@0x%05x=%02x, "
 			"Err: %d\n", rw ? "Write" : "Read", func, regaddr,
 			*byte, err_ret));
 
@@ -666,7 +670,7 @@ brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 	sdio_release_host(gInstance->func[func]);
 
 	if (err_ret) {
-		sd_err(("bcmsdh_sdmmc: Failed to %s word, Err: 0x%08x",
+		sd_err(("brcmf: Failed to %s word, Err: 0x%08x",
 			rw ? "Write" : "Read", err_ret));
 	}
 
@@ -896,12 +900,11 @@ brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
 	return SUCCESS;
 }
 
-/* bcmsdh_sdmmc interrupt handler */
 static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
 	struct sdioh_info *sd;
 
-	sd_trace(("bcmsdh_sdmmc: ***IRQHandler\n"));
+	sd_trace(("brcmf: ***IRQHandler\n"));
 	sd = gInstance->sd;
 
 	ASSERT(sd != NULL);
@@ -913,7 +916,7 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 		ASSERT(sd->intr_handler_arg);
 		(sd->intr_handler) (sd->intr_handler_arg);
 	} else {
-		sd_err(("bcmsdh_sdmmc: ***IRQHandler\n"));
+		sd_err(("brcmf: ***IRQHandler\n"));
 
 		sd_err(("%s: Not ready for intr: enabled %d, handler %p\n",
 			__func__, sd->client_intr_enabled, sd->intr_handler));
@@ -922,12 +925,12 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 	sdio_claim_host(gInstance->func[0]);
 }
 
-/* bcmsdh_sdmmc interrupt handler for F2 (dummy handler) */
+/* interrupt handler for F2 (dummy handler) */
 static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func)
 {
 	struct sdioh_info *sd;
 
-	sd_trace(("bcmsdh_sdmmc: ***IRQHandlerF2\n"));
+	sd_trace(("brcmf: ***IRQHandlerF2\n"));
 
 	sd = gInstance->sd;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
index a0f985c..5eb4c65 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
@@ -15,7 +15,7 @@
  */
 
 /*
- * BCMSDH Function Driver for the native SDIO/MMC driver in the Linux Kernel
+ * BRCMF SDIO Function Driver for the native SDIO/MMC driver in the Linux Kernel
  */
 
 #ifndef __BCMSDH_SDMMC_H__
@@ -97,10 +97,6 @@ struct sdioh_info {
 	/*	SDDMA_DESCRIPTOR	SGList[32]; *//* Scatter/Gather DMA List */
 };
 
-/************************************************************
- * Internal interfaces: per-port references into bcmsdh_sdmmc.c
- */
-
 /* Global message bits */
 extern uint sd_msglevel;
 
@@ -115,10 +111,6 @@ extern bool brcmf_sdioh_check_client_intr(struct sdioh_info *sd);
 extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
 extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
 
-/**************************************************************
- * Internal interfaces: bcmsdh_sdmmc.c references to per-port code
- */
-
 /* Register mapping routines */
 extern u32 *brcmf_sdioh_reg_map(s32 addr, int size);
 extern void brcmf_sdioh_reg_unmap(s32 addr, int size);
@@ -127,12 +119,12 @@ extern void brcmf_sdioh_reg_unmap(s32 addr, int size);
 extern int  brcmf_sdioh_register_irq(struct sdioh_info *sd, uint irq);
 extern void brcmf_sdioh_free_irq(uint irq, struct sdioh_info *sd);
 
-typedef struct _BCMSDH_SDMMC_INSTANCE {
+struct brcmf_sdmmc_instance {
 	struct sdioh_info *sd;
 	struct sdio_func *func[SDIOD_MAX_IOFUNCS];
 	u32 host_claimed;
-} BCMSDH_SDMMC_INSTANCE, *PBCMSDH_SDMMC_INSTANCE;
+};
 
-extern PBCMSDH_SDMMC_INSTANCE gInstance;
+extern struct brcmf_sdmmc_instance *gInstance;
 
 #endif				/* __BCMSDH_SDMMC_H__ */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index b880cf1..145ca09 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -27,7 +27,7 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include "sdio_host.h"
-#include "bcmsdbus.h"		/* bcmsdh to/from specific controller APIs */
+#include "bcmsdbus.h"
 #include "sdiovar.h"		/* to get msglevel bit values */
 #include "dngl_stats.h"
 #include "dhd.h"
@@ -62,10 +62,7 @@ static int clockoverride;
 module_param(clockoverride, int, 0644);
 MODULE_PARM_DESC(clockoverride, "SDIO card clock override");
 
-PBCMSDH_SDMMC_INSTANCE gInstance;
-
-/* Maximum number of bcmsdh_sdmmc devices supported by driver */
-#define BCMSDH_SDMMC_MAX_DEVICES 1
+struct brcmf_sdmmc_instance *gInstance;
 
 struct device sdmmc_dev;
 
@@ -74,8 +71,8 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 {
 	int ret = 0;
 	static struct sdio_func sdio_func_0;
-	sd_trace(("bcmsdh_sdmmc: %s Enter\n", __func__));
-	sd_trace(("sdio_bcmsdh: func->class=%x\n", func->class));
+	sd_trace(("sdio_probe: %s Enter\n", __func__));
+	sd_trace(("sdio_probe: func->class=%x\n", func->class));
 	sd_trace(("sdio_vendor: 0x%04x\n", func->vendor));
 	sd_trace(("sdio_device: 0x%04x\n", func->device));
 	sd_trace(("Function#: 0x%04x\n", func->num));
@@ -117,7 +114,7 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 }
 
 /* devices we support, null terminated */
-static const struct sdio_device_id bcmsdh_sdmmc_ids[] = {
+static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_DEFAULT)},
 	{SDIO_DEVICE
 	 (SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4325_SDGWB)},
@@ -127,7 +124,7 @@ static const struct sdio_device_id bcmsdh_sdmmc_ids[] = {
 	{ /* end: all zeroes */ },
 };
 
-MODULE_DEVICE_TABLE(sdio, bcmsdh_sdmmc_ids);
+MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 
 #ifdef CONFIG_PM
 static int brcmf_sdio_suspend(struct device *dev)
@@ -166,11 +163,11 @@ static const struct dev_pm_ops brcmf_sdio_pm_ops = {
 };
 #endif		/* CONFIG_PM */
 
-static struct sdio_driver bcmsdh_sdmmc_driver = {
+static struct sdio_driver brcmf_sdmmc_driver = {
 	.probe = brcmf_ops_sdio_probe,
 	.remove = brcmf_ops_sdio_remove,
 	.name = "brcmfmac",
-	.id_table = bcmsdh_sdmmc_ids,
+	.id_table = brcmf_sdmmc_ids,
 #ifdef CONFIG_PM
 	.drv = {
 		.pm = &brcmf_sdio_pm_ops,
@@ -243,14 +240,14 @@ int brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
 int brcmf_sdio_function_init(void)
 {
 	int error = 0;
-	sd_trace(("bcmsdh_sdmmc: %s Enter\n", __func__));
+	sd_trace(("brcmf_sdio_function_init: %s Enter\n", __func__));
 
-	gInstance = kzalloc(sizeof(BCMSDH_SDMMC_INSTANCE), GFP_KERNEL);
+	gInstance = kzalloc(sizeof(struct brcmf_sdmmc_instance), GFP_KERNEL);
 	if (!gInstance)
 		return -ENOMEM;
 
 	memset(&sdmmc_dev, 0, sizeof(sdmmc_dev));
-	error = sdio_register_driver(&bcmsdh_sdmmc_driver);
+	error = sdio_register_driver(&brcmf_sdmmc_driver);
 
 	return error;
 }
@@ -262,7 +259,7 @@ void brcmf_sdio_function_cleanup(void)
 {
 	sd_trace(("%s Enter\n", __func__));
 
-	sdio_unregister_driver(&bcmsdh_sdmmc_driver);
+	sdio_unregister_driver(&brcmf_sdmmc_driver);
 
 	kfree(gInstance);
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index da5a2ff..6c7407a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -458,7 +458,7 @@ struct chip_info {
 typedef struct dhd_bus {
 	struct brcmf_pub *dhd;
 
-	struct brcmf_sdio *sdh;	/* Handle for BCMSDH calls */
+	struct brcmf_sdio *sdh;	/* Handle for sdio card calls */
 	struct chip_info *ci;	/* Chip info struct */
 	char *vars;		/* Variables (from CIS and/or other) */
 	uint varsz;		/* Size of variables buffer */
@@ -529,7 +529,7 @@ typedef struct dhd_bus {
 	s32 idletime;		/* Control for activity timeout */
 	s32 idlecount;	/* Activity timeout counter */
 	s32 idleclock;	/* How to set bus driver when idle */
-	s32 sd_rxchain;	/* If bcmsdh api accepts PKT chains */
+	s32 sd_rxchain;
 	bool use_rxchain;	/* If dhd should use PKT chains */
 	bool sleeping;		/* Is SDIO bus sleeping? */
 	bool rxflow_mode;	/* Rx flow control mode */
@@ -805,8 +805,8 @@ static uint brcmf_process_nvram_vars(char *varbuf, uint len);
 static void brcmf_sdbrcm_setmemsize(struct dhd_bus *bus, int mem_size);
 static int brcmf_sdbrcm_send_buf(dhd_bus_t *bus, u32 addr, uint fn,
 			       uint flags, u8 *buf, uint nbytes,
-			       struct sk_buff *pkt, bcmsdh_cmplt_fn_t complete,
-			       void *handle);
+			       struct sk_buff *pkt,
+			       brcmf_sdio_cmplt_fn_t complete, void *handle);
 
 static bool brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *sdh);
 static int  _brcmf_sdbrcm_download_firmware(struct dhd_bus *bus);
@@ -3210,8 +3210,6 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *dhdp, bool enforce_mutex)
 		/* Set bus state according to enable result */
 		dhdp->busstate = DHD_BUS_DATA;
 
-		/* bcmsdh_intr_unmask(bus->sdh); */
-
 		bus->intdis = false;
 		if (bus->intr) {
 			DHD_INTR(("%s: enable SDIO device interrupts\n",
@@ -3844,7 +3842,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 	u16 rdlen;		/* Total number of bytes to read */
 	u8 rxseq;		/* Next sequence number to expect */
 	uint rxleft = 0;	/* Remaining number of frames allowed */
-	int sdret;		/* Return code from bcmsdh calls */
+	int sdret;		/* Return code from calls */
 	u8 txmax;		/* Maximum tx sequence offered */
 	bool len_consistent;	/* Result of comparing readahead len and
 					 len from hw-hdr */
@@ -4857,7 +4855,7 @@ static void brcmf_sdbrcm_pktgen(dhd_bus_t *bus)
 		/* Allocate an appropriate-sized packet */
 		len = bus->pktgen_len;
 		pkt = brcmu_pkt_buf_get_skb(
-			(len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + BRCMF_SDALIGN),
+			len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + BRCMF_SDALIGN,
 			true);
 		if (!pkt) {
 			DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed!\n",
@@ -5268,7 +5266,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	/* We make assumptions about address window mappings */
 	ASSERT((unsigned long)regsva == SI_ENUM_BASE);
 
-	/* BCMSDH passes venid and devid based on CIS parsing -- but
+	/* SDIO car passes venid and devid based on CIS parsing -- but
 	 * low-power start
 	 * means early parse could fail, so here we should get either an ID
 	 * we recognize OR (-1) indicating we must request power first.
@@ -5402,7 +5400,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	brcmf_sdcard_intr_disable(sdh);
 	ret = brcmf_sdcard_intr_reg(sdh, brcmf_sdbrcm_isr, bus);
 	if (ret != 0) {
-		DHD_ERROR(("%s: FAILED: bcmsdh_intr_reg returned %d\n",
+		DHD_ERROR(("%s: FAILED: sdcard_intr_reg returned %d\n",
 			   __func__, ret));
 		goto fail;
 	}
@@ -5510,7 +5508,8 @@ brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
 	/* Locate an appropriately-aligned portion of hdrbuf */
-	bus->rxhdr = (u8 *) roundup((unsigned long)&bus->hdrbuf[0], BRCMF_SDALIGN);
+	bus->rxhdr = (u8 *) roundup((unsigned long)&bus->hdrbuf[0],
+				    BRCMF_SDALIGN);
 
 	/* Set the poll and/or interrupt flags */
 	bus->intr = (bool) brcmf_intr;
@@ -5553,9 +5552,8 @@ static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *sdh)
 
 	/* Align the buffer */
 	if ((unsigned long)bus->databuf % BRCMF_SDALIGN)
-		bus->dataptr =
-		    bus->databuf + (BRCMF_SDALIGN -
-				    ((unsigned long)bus->databuf % BRCMF_SDALIGN));
+		bus->dataptr = bus->databuf + (BRCMF_SDALIGN -
+			       ((unsigned long)bus->databuf % BRCMF_SDALIGN));
 	else
 		bus->dataptr = bus->databuf;
 
@@ -5612,7 +5610,7 @@ static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh)
 			    false) != 0) {
 		bus->sd_rxchain = false;
 	} else {
-		DHD_INFO(("%s: bus module (through bcmsdh API) %s chaining\n",
+		DHD_INFO(("%s: bus module (through sdiocard API) %s chaining\n",
 			  __func__,
 			  (bus->sd_rxchain ? "supports" : "does not support")));
 	}
@@ -5773,8 +5771,8 @@ static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus)
 		goto err;
 	}
 	if ((u32)(unsigned long)memblock % BRCMF_SDALIGN)
-		memptr +=
-		    (BRCMF_SDALIGN - ((u32)(unsigned long)memblock % BRCMF_SDALIGN));
+		memptr += (BRCMF_SDALIGN -
+			   ((u32)(unsigned long)memblock % BRCMF_SDALIGN));
 
 	/* Download image */
 	while ((len =
@@ -5946,7 +5944,7 @@ err:
 static int
 brcmf_sdbrcm_send_buf(dhd_bus_t *bus, u32 addr, uint fn, uint flags,
 		    u8 *buf, uint nbytes, struct sk_buff *pkt,
-		    bcmsdh_cmplt_fn_t complete, void *handle)
+		    brcmf_sdio_cmplt_fn_t complete, void *handle)
 {
 	return brcmf_sdcard_send_buf
 		(bus->sdh, addr, fn, flags, buf, nbytes, pkt, complete,
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 85e3d6a..17ea8b2 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -18,24 +18,26 @@
 #define	_BRCM_SDH_H_
 
 #include <linux/skbuff.h>
-#define BCMSDH_ERROR_VAL	0x0001	/* Error */
-#define BCMSDH_INFO_VAL		0x0002	/* Info */
-extern const uint bcmsdh_msglevel;
+#define BRCMF_SD_ERROR_VAL	0x0001	/* Error */
+#define BRCMF_SD_INFO_VAL		0x0002	/* Info */
+extern const uint brcmf_sdio_msglevel;
 
 #ifdef BCMDBG
-#define BCMSDH_ERROR(x) \
+#define BRCMF_SD_ERROR(x) \
 	do { \
-		if ((bcmsdh_msglevel & BCMSDH_ERROR_VAL) && net_ratelimit()) \
+		if ((brcmf_sdio_msglevel & BRCMF_SD_ERROR_VAL) && \
+		    net_ratelimit()) \
 			printk x; \
 	} while (0)
-#define BCMSDH_INFO(x)	\
+#define BRCMF_SD_INFO(x)	\
 	do { \
-		if ((bcmsdh_msglevel & BCMSDH_INFO_VAL) && net_ratelimit()) \
+		if ((brcmf_sdio_msglevel & BRCMF_SD_INFO_VAL) && \
+		    net_ratelimit()) \
 			printk x; \
 	} while (0)
 #else				/* BCMDBG */
-#define BCMSDH_ERROR(x)
-#define BCMSDH_INFO(x)
+#define BRCMF_SD_ERROR(x)
+#define BRCMF_SD_INFO(x)
 #endif				/* BCMDBG */
 
 #define SDIO_FUNC_0		0
@@ -61,11 +63,12 @@ extern const uint bcmsdh_msglevel;
 
 /* forward declarations */
 struct brcmf_sdio;
-typedef void (*bcmsdh_cb_fn_t) (void *);
+typedef void (*brcmf_sdiocard_cb_fn_t) (void *);
 
 /* Attach and build an interface to the underlying SD host driver.
- *  - Allocates resources (structs, arrays, mem, OS handles, etc) needed by bcmsdh.
- *  - Returns the bcmsdh handle and virtual address base for register access.
+ *  - Allocates resources (structs, arrays, mem, OS handles, etc) needed by
+ *    brcmf_sdcard.
+ *  - Returns the sdio card handle and virtual address base for register access.
  *    The returned handle should be used in all subsequent calls, but the bcmsh
  *    implementation may maintain a single "default" handle (e.g. the first or
  *    most recent one) to enable single-instance implementations to pass NULL.
@@ -84,20 +87,21 @@ extern int brcmf_sdcard_intr_enable(void *sdh);
 extern int brcmf_sdcard_intr_disable(void *sdh);
 
 /* Register/deregister device interrupt handler. */
-extern int brcmf_sdcard_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh);
+extern int
+brcmf_sdcard_intr_reg(void *sdh, brcmf_sdiocard_cb_fn_t fn, void *argh);
+
 extern int brcmf_sdcard_intr_dereg(void *sdh);
 
 #if defined(BCMDBG)
 /* Query pending interrupt status from the host controller */
 extern bool brcmf_sdcard_intr_pending(void *sdh);
 #endif
-extern int bcmsdh_claim_host_and_lock(void *sdh);
-extern int bcmsdh_release_host_and_unlock(void *sdh);
 
-/* Register a callback to be called if and when bcmsdh detects
- * device removal. No-op in the case of non-removable/hardwired devices.
+/* Register a callback to be called on device removal.
+ * No-op in the case of non-removable/hardwired devices.
  */
-extern int brcmf_sdcard_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh);
+extern int
+brcmf_sdcard_devremove_reg(void *sdh, brcmf_sdiocard_cb_fn_t fn, void *argh);
 
 /* Access SDIO address space (e.g. CCCR) using CMD52 (single-byte interface).
  *   fn:   function number
@@ -147,13 +151,14 @@ extern bool brcmf_sdcard_regfail(void *sdh);
  * Returns 0 or error code.
  * NOTE: Async operation is not currently supported.
  */
-typedef void (*bcmsdh_cmplt_fn_t) (void *handle, int status, bool sync_waiting);
+typedef void (*brcmf_sdio_cmplt_fn_t)
+		(void *handle, int status, bool sync_waiting);
 extern int brcmf_sdcard_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 		u8 *buf, uint nbytes, void *pkt,
-		bcmsdh_cmplt_fn_t complete, void *handle);
+		brcmf_sdio_cmplt_fn_t complete, void *handle);
 extern int brcmf_sdcard_recv_buf(struct brcmf_sdio *sdh, u32 addr, uint fn,
 		uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt,
-		bcmsdh_cmplt_fn_t complete, void *handle);
+		brcmf_sdio_cmplt_fn_t complete, void *handle);
 
 /* Flags bits */
 #define SDIO_REQ_4BYTE	0x1	/* Four-byte target (backplane) width (vs. two-byte) */
-- 
1.7.4.1


