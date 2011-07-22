Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3356 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Franky Lin" <frankyl@broadcom.com>, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/29] staging: brcm80211: remove struct brcmf_sdio_card
 from brcmfmac
Date: Fri, 22 Jul 2011 20:57:04 +0200
Message-ID: <1311361036-3175-18-git-send-email-arend@broadcom.com> (sfid-20110722_205746_269334_68D99A4B)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use brcmf_sdio_dev as the unified structure to store information
of wifi dongle

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |  145 ++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h   |    3 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |  445 ++++++++++++------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |   52 ++--
 4 files changed, 317 insertions(+), 328 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 3208a11..31e6728 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -41,48 +41,40 @@
 #define SDIOH_DATA_PIO          0	/* PIO mode */
 #define SDIOH_DATA_DMA          1	/* DMA mode */
 
-struct brcmf_sdio_card {
-	bool init_success;	/* underlying driver successfully attached */
-	void *sdioh;		/* handler for sdioh */
-	bool regfail;		/* Save status of last
-				 reg_read/reg_write call */
-	u32 sbwad;		/* Save backplane window address */
-};
-
 /* Module parameters specific to each host-controller driver */
 
 module_param(sd_f2_blocksize, int, 0);
 
 int
-brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
+brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
 		void *params, int plen, void *arg, int len, bool set)
 {
-	return brcmf_sdioh_iovar_op(card->sdioh, name, params, plen, arg,
+	return brcmf_sdioh_iovar_op(sdiodev->sdioh, name, params, plen, arg,
 				    len, set);
 }
 
-int brcmf_sdcard_intr_enable(struct brcmf_sdio_card *card)
+int brcmf_sdcard_intr_enable(struct brcmf_sdio_dev *sdiodev)
 {
-	return brcmf_sdioh_interrupt_set(card->sdioh, true);
+	return brcmf_sdioh_interrupt_set(sdiodev->sdioh, true);
 }
 
-int brcmf_sdcard_intr_disable(struct brcmf_sdio_card *card)
+int brcmf_sdcard_intr_disable(struct brcmf_sdio_dev *sdiodev)
 {
-	return brcmf_sdioh_interrupt_set(card->sdioh, false);
+	return brcmf_sdioh_interrupt_set(sdiodev->sdioh, false);
 }
 
-int brcmf_sdcard_intr_reg(struct brcmf_sdio_card *card,
+int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev,
 			  void (*fn)(void *), void *argh)
 {
-	return brcmf_sdioh_interrupt_register(card->sdioh, fn, argh);
+	return brcmf_sdioh_interrupt_register(sdiodev->sdioh, fn, argh);
 }
 
-int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card)
+int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev)
 {
-	return brcmf_sdioh_interrupt_deregister(card->sdioh);
+	return brcmf_sdioh_interrupt_deregister(sdiodev->sdioh);
 }
 
-u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
+u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 			 int *err)
 {
 	int status;
@@ -93,7 +85,7 @@ u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 		if (retry)	/* wait for 1 ms till bus get settled down */
 			udelay(1000);
 		status =
-		    brcmf_sdioh_cfg_read(card->sdioh, fnc_num, addr,
+		    brcmf_sdioh_cfg_read(sdiodev->sdioh, fnc_num, addr,
 				   (u8 *) &data);
 	} while (status != 0
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
@@ -107,7 +99,7 @@ u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 }
 
 void
-brcmf_sdcard_cfg_write(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
+brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 		       u8 data, int *err)
 {
 	int status;
@@ -117,7 +109,7 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 		if (retry)	/* wait for 1 ms till bus get settled down */
 			udelay(1000);
 		status =
-		    brcmf_sdioh_cfg_write(card->sdioh, fnc_num, addr,
+		    brcmf_sdioh_cfg_write(sdiodev->sdioh, fnc_num, addr,
 				    (u8 *) &data);
 	} while (status != 0
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
@@ -128,13 +120,13 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 		     __func__, fnc_num, addr, data));
 }
 
-u32 brcmf_sdcard_cfg_read_word(struct brcmf_sdio_card *card, uint fnc_num,
+u32 brcmf_sdcard_cfg_read_word(struct brcmf_sdio_dev *sdiodev, uint fnc_num,
 			       u32 addr, int *err)
 {
 	int status;
 	u32 data = 0;
 
-	status = brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	status = brcmf_sdioh_request_word(sdiodev->sdioh, SDIOH_CMD_TYPE_NORMAL,
 		SDIOH_READ, fnc_num, addr, &data, 4);
 
 	if (err)
@@ -147,13 +139,13 @@ u32 brcmf_sdcard_cfg_read_word(struct brcmf_sdio_card *card, uint fnc_num,
 }
 
 void
-brcmf_sdcard_cfg_write_word(struct brcmf_sdio_card *card, uint fnc_num,
+brcmf_sdcard_cfg_write_word(struct brcmf_sdio_dev *sdiodev, uint fnc_num,
 			    u32 addr, u32 data, int *err)
 {
 	int status;
 
 	status =
-	    brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	    brcmf_sdioh_request_word(sdiodev->sdioh, SDIOH_CMD_TYPE_NORMAL,
 			       SDIOH_WRITE, fnc_num, addr, &data, 4);
 
 	if (err)
@@ -163,7 +155,7 @@ brcmf_sdcard_cfg_write_word(struct brcmf_sdio_card *card, uint fnc_num,
 		     __func__, fnc_num, addr, data));
 }
 
-int brcmf_sdcard_cis_read(struct brcmf_sdio_card *card, uint func, u8 * cis,
+int brcmf_sdcard_cis_read(struct brcmf_sdio_dev *sdiodev, uint func, u8 * cis,
 			  uint length)
 {
 	int status;
@@ -173,7 +165,7 @@ int brcmf_sdcard_cis_read(struct brcmf_sdio_card *card, uint func, u8 * cis,
 	bool ascii = func & ~0xf;
 	func &= 0x7;
 
-	status = brcmf_sdioh_cis_read(card->sdioh, func, cis, length);
+	status = brcmf_sdioh_cis_read(sdiodev->sdioh, func, cis, length);
 
 	if (ascii) {
 		/* Move binary bits to tmp and format them
@@ -197,18 +189,18 @@ int brcmf_sdcard_cis_read(struct brcmf_sdio_card *card, uint func, u8 * cis,
 }
 
 static int
-brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_card *card, u32 address)
+brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
 	int err = 0;
-	brcmf_sdcard_cfg_write(card, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
+	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
 			 (address >> 8) & SBSDIO_SBADDRLOW_MASK, &err);
 	if (!err)
-		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_SBADDRMID,
 				       (address >> 16) & SBSDIO_SBADDRMID_MASK,
 				       &err);
 	if (!err)
-		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_SBADDRHIGH,
 				       (address >> 24) & SBSDIO_SBADDRHIGH_MASK,
 				       &err);
@@ -216,7 +208,7 @@ brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_card *card, u32 address)
 	return err;
 }
 
-u32 brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size)
+u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size)
 {
 	int status;
 	u32 word = 0;
@@ -224,21 +216,21 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size)
 
 	BRCMF_INFO(("%s:fun = 1, addr = 0x%x, ", __func__, addr));
 
-	if (bar0 != card->sbwad) {
-		if (brcmf_sdcard_set_sbaddr_window(card, bar0))
+	if (bar0 != sdiodev->sbwad) {
+		if (brcmf_sdcard_set_sbaddr_window(sdiodev, bar0))
 			return 0xFFFFFFFF;
 
-		card->sbwad = bar0;
+		sdiodev->sbwad = bar0;
 	}
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	if (size == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	status = brcmf_sdioh_request_word(sdiodev->sdioh, SDIOH_CMD_TYPE_NORMAL,
 				    SDIOH_READ, SDIO_FUNC_1, addr, &word, size);
 
-	card->regfail = (status != 0);
+	sdiodev->regfail = (status != 0);
 
 	BRCMF_INFO(("u32data = 0x%x\n", word));
 
@@ -252,7 +244,7 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size)
 		case sizeof(u32):
 			return word;
 		default:
-			card->regfail = true;
+			sdiodev->regfail = true;
 
 		}
 	}
@@ -263,7 +255,7 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size)
 	return 0xFFFFFFFF;
 }
 
-u32 brcmf_sdcard_reg_write(struct brcmf_sdio_card *card, u32 addr, uint size,
+u32 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size,
 			   u32 data)
 {
 	int status;
@@ -273,21 +265,21 @@ u32 brcmf_sdcard_reg_write(struct brcmf_sdio_card *card, u32 addr, uint size,
 	BRCMF_INFO(("%s:fun = 1, addr = 0x%x, uint%ddata = 0x%x\n",
 		     __func__, addr, size * 8, data));
 
-	if (bar0 != card->sbwad) {
-		err = brcmf_sdcard_set_sbaddr_window(card, bar0);
+	if (bar0 != sdiodev->sbwad) {
+		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
 		if (err)
 			return err;
 
-		card->sbwad = bar0;
+		sdiodev->sbwad = bar0;
 	}
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	if (size == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 	status =
-	    brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	    brcmf_sdioh_request_word(sdiodev->sdioh, SDIOH_CMD_TYPE_NORMAL,
 			       SDIOH_WRITE, SDIO_FUNC_1, addr, &data, size);
-	card->regfail = (status != 0);
+	sdiodev->regfail = (status != 0);
 
 	if (status == 0)
 		return 0;
@@ -297,13 +289,13 @@ u32 brcmf_sdcard_reg_write(struct brcmf_sdio_card *card, u32 addr, uint size,
 	return 0xFFFFFFFF;
 }
 
-bool brcmf_sdcard_regfail(struct brcmf_sdio_card *card)
+bool brcmf_sdcard_regfail(struct brcmf_sdio_dev *sdiodev)
 {
-	return card->regfail;
+	return sdiodev->regfail;
 }
 
 int
-brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
+brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags,
 		      u8 *buf, uint nbytes, struct sk_buff *pkt,
 		      void (*complete)(void *handle, int status,
@@ -323,12 +315,12 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 	if (flags & SDIO_REQ_ASYNC)
 		return -ENOTSUPP;
 
-	if (bar0 != card->sbwad) {
-		err = brcmf_sdcard_set_sbaddr_window(card, bar0);
+	if (bar0 != sdiodev->sbwad) {
+		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
 		if (err)
 			return err;
 
-		card->sbwad = bar0;
+		sdiodev->sbwad = bar0;
 	}
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
@@ -338,14 +330,14 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = brcmf_sdioh_request_buffer(card->sdioh, SDIOH_DATA_PIO,
+	status = brcmf_sdioh_request_buffer(sdiodev->sdioh, SDIOH_DATA_PIO,
 		incr_fix, SDIOH_READ, fn, addr, width, nbytes, buf, pkt);
 
 	return status;
 }
 
 int
-brcmf_sdcard_send_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
+brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, u8 *buf, uint nbytes, void *pkt,
 		      void (*complete)(void *handle, int status,
 				       bool sync_waiting),
@@ -363,12 +355,12 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 	if (flags & SDIO_REQ_ASYNC)
 		return -ENOTSUPP;
 
-	if (bar0 != card->sbwad) {
-		err = brcmf_sdcard_set_sbaddr_window(card, bar0);
+	if (bar0 != sdiodev->sbwad) {
+		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
 		if (err)
 			return err;
 
-		card->sbwad = bar0;
+		sdiodev->sbwad = bar0;
 	}
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
@@ -378,29 +370,29 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return brcmf_sdioh_request_buffer(card->sdioh, SDIOH_DATA_PIO,
+	return brcmf_sdioh_request_buffer(sdiodev->sdioh, SDIOH_DATA_PIO,
 		incr_fix, SDIOH_WRITE, fn, addr, width, nbytes, buf, pkt);
 }
 
-int brcmf_sdcard_rwdata(struct brcmf_sdio_card *card, uint rw, u32 addr,
+int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
 			u8 *buf, uint nbytes)
 {
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return brcmf_sdioh_request_buffer(card->sdioh, SDIOH_DATA_PIO,
+	return brcmf_sdioh_request_buffer(sdiodev->sdioh, SDIOH_DATA_PIO,
 		SDIOH_DATA_INC, (rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
 		addr, 4, nbytes, buf, NULL);
 }
 
-int brcmf_sdcard_abort(struct brcmf_sdio_card *card, uint fn)
+int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 {
-	return brcmf_sdioh_abort(card->sdioh, fn);
+	return brcmf_sdioh_abort(sdiodev->sdioh, fn);
 }
 
-u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card)
+u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev)
 {
-	return card->sbwad;
+	return sdiodev->sbwad;
 }
 
 int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
@@ -408,28 +400,19 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	u32 regs = 0;
 	int ret = 0;
 
-	sdiodev->card = kzalloc(sizeof(struct brcmf_sdio_card), GFP_ATOMIC);
-	if (sdiodev->card == NULL) {
-		BRCMF_ERROR(("sdcard_attach: out of memory"));
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	sdiodev->card->sdioh = brcmf_sdioh_attach((void *)0);
-	if (!sdiodev->card->sdioh) {
+	sdiodev->sdioh = brcmf_sdioh_attach((void *)0);
+	if (!sdiodev->sdioh) {
 		ret = -ENODEV;
 		goto out;
 	}
 
-	sdiodev->card->init_success = true;
-
 	regs = SI_ENUM_BASE;
 
 	/* Report the BAR, to fix if needed */
-	sdiodev->card->sbwad = SI_ENUM_BASE;
+	sdiodev->sbwad = SI_ENUM_BASE;
 
 	/* try to attach to the target device */
-	sdiodev->bus = brcmf_sdbrcm_probe(0, 0, 0, 0, regs, sdiodev->card);
+	sdiodev->bus = brcmf_sdbrcm_probe(0, 0, 0, 0, regs, sdiodev);
 	if (!sdiodev->bus) {
 		BRCMF_ERROR(("%s: device attach failed\n", __func__));
 		ret = -ENODEV;
@@ -451,13 +434,13 @@ int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
 		sdiodev->bus = NULL;
 	}
 
-	if (sdiodev->card) {
-		if (sdiodev->card->sdioh)
-			brcmf_sdioh_detach(sdiodev->card->sdioh);
-		kfree(sdiodev->card);
-		sdiodev->card = NULL;
+	if (sdiodev->sdioh) {
+		brcmf_sdioh_detach(sdiodev->sdioh);
+		sdiodev->sdioh = NULL;
 	}
 
+	sdiodev->sbwad = 0;
+
 	return 0;
 }
 EXPORT_SYMBOL(brcmf_sdio_remove);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 4521fe5..653cf0d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -75,7 +75,4 @@ extern void brcmf_bus_clearcounts(struct brcmf_pub *drvr);
 
 extern void brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick);
 
-extern void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
-				u32 regsva, void *card);
-extern void brcmf_sdbrcm_disconnect(void *ptr);
 #endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index bd83da3..4fc17f8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -611,7 +611,7 @@ struct chip_info {
 struct brcmf_bus {
 	struct brcmf_pub *drvr;
 
-	struct brcmf_sdio_card *card;	/* Handle for sdio card calls */
+	struct brcmf_sdio_dev *sdiodev;	/* sdio device handler */
 	struct chip_info *ci;	/* Chip info struct */
 	char *vars;		/* Variables (from CIS and/or other) */
 	uint varsz;		/* Size of variables buffer */
@@ -908,9 +908,9 @@ r_sdreg32(struct brcmf_bus *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
 {
 	*retryvar = 0;
 	do {
-		*regvar = brcmf_sdcard_reg_read(bus->card,
+		*regvar = brcmf_sdcard_reg_read(bus->sdiodev,
 				bus->ci->buscorebase + reg_offset, sizeof(u32));
-	} while (brcmf_sdcard_regfail(bus->card) &&
+	} while (brcmf_sdcard_regfail(bus->sdiodev) &&
 		 (++(*retryvar) <= retry_limit));
 	if (*retryvar) {
 		bus->regfails += (*retryvar-1);
@@ -926,10 +926,10 @@ w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 {
 	*retryvar = 0;
 	do {
-		brcmf_sdcard_reg_write(bus->card,
+		brcmf_sdcard_reg_write(bus->sdiodev,
 				       bus->ci->buscorebase + reg_offset,
 				       sizeof(u32), regval);
-	} while (brcmf_sdcard_regfail(bus->card) &&
+	} while (brcmf_sdcard_regfail(bus->sdiodev) &&
 		 (++(*retryvar) <= retry_limit));
 	if (*retryvar) {
 		bus->regfails += (*retryvar-1);
@@ -961,10 +961,9 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter);
 static void brcmf_sdbrcm_release(struct brcmf_bus *bus);
 static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus);
 static bool brcmf_sdbrcm_chipmatch(u16 chipid);
-static bool brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card,
-				      u32 regsva);
-static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus, void *card);
-static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card);
+static bool brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva);
+static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus);
+static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus);
 static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus);
 
 static uint brcmf_process_nvram_vars(char *varbuf, uint len);
@@ -984,12 +983,12 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus);
 static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus);
 
 static void
-brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_card *card, u32 corebase);
+brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_dev *sdiodev, u32 corebase);
 
 static int brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs);
 
 static void
-brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_card *card, u32 corebase);
+brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase);
 
 static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
 					u32 drivestrength);
@@ -1031,14 +1030,15 @@ static void brcmf_sdbrcm_setmemsize(struct brcmf_bus *bus, int mem_size)
 static int brcmf_sdbrcm_set_siaddr_window(struct brcmf_bus *bus, u32 address)
 {
 	int err = 0;
-	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
-			 (address >> 8) & SBSDIO_SBADDRLOW_MASK, &err);
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_SBADDRLOW,
+			       (address >> 8) & SBSDIO_SBADDRLOW_MASK, &err);
 	if (!err)
-		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				 SBSDIO_FUNC1_SBADDRMID,
 				 (address >> 16) & SBSDIO_SBADDRMID_MASK, &err);
 	if (!err)
-		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_SBADDRHIGH,
 				       (address >> 24) & SBSDIO_SBADDRHIGH_MASK,
 				       &err);
@@ -1050,13 +1050,11 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 {
 	int err;
 	u8 clkctl, clkreq, devctl;
-	struct brcmf_sdio_card *card;
 	unsigned long timeout;
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	clkctl = 0;
-	card = bus->card;
 
 	if (on) {
 		/* Request HT Avail */
@@ -1067,7 +1065,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		    && (bus->ci->chiprev == 0))
 			clkreq |= SBSDIO_FORCE_ALP;
 
-		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		if (err) {
 			BRCMF_ERROR(("%s: HT Avail request error: %d\n",
@@ -1084,7 +1082,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		}
 
 		/* Check current status */
-		clkctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+		clkctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			BRCMF_ERROR(("%s: HT Avail read error: %d\n",
@@ -1095,7 +1093,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		/* Go to pending and await interrupt if appropriate */
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only) && pendok) {
 			/* Allow only clock-available interrupt */
-			devctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+			devctl = brcmf_sdcard_cfg_read(bus->sdiodev,
+					SDIO_FUNC_1,
 					SBSDIO_DEVICE_CTL, &err);
 			if (err) {
 				BRCMF_ERROR(("%s: Devctl error setting CA:"
@@ -1104,7 +1103,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 					       SBSDIO_DEVICE_CTL, devctl, &err);
 			BRCMF_INFO(("CLKCTL: set PENDING\n"));
 			bus->clkstate = CLK_PENDING;
@@ -1113,10 +1112,10 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		} else if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
 			devctl =
-			    brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+			    brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 						  SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, devctl, &err);
 		}
 
@@ -1124,7 +1123,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		timeout = jiffies +
 			  msecs_to_jiffies(PMU_MAX_TRANSITION_DLY/1000);
 		while (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			clkctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+			clkctl = brcmf_sdcard_cfg_read(bus->sdiodev,
+						       SDIO_FUNC_1,
 						       SBSDIO_FUNC1_CHIPCLKCSR,
 						       &err);
 			if (time_after(jiffies, timeout))
@@ -1162,15 +1162,16 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 
 		if (bus->clkstate == CLK_PENDING) {
 			/* Cancel CA-only interrupt filter */
-			devctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+			devctl = brcmf_sdcard_cfg_read(bus->sdiodev,
+					SDIO_FUNC_1,
 					SBSDIO_DEVICE_CTL, &err);
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, devctl, &err);
 		}
 
 		bus->clkstate = CLK_SDONLY;
-		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		BRCMF_INFO(("CLKCTL: turned OFF\n"));
 		if (err) {
@@ -1255,7 +1256,6 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 
 int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 {
-	struct brcmf_sdio_card *card = bus->card;
 	uint retries = 0;
 
 	BRCMF_INFO(("brcmf_sdbrcm_bussleep: request %s (currently %s)\n",
@@ -1273,7 +1273,7 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 			return -EBUSY;
 
 		/* Disable SDIO interrupts (no longer interested) */
-		brcmf_sdcard_intr_disable(bus->card);
+		brcmf_sdcard_intr_disable(bus->sdiodev);
 
 		/* Make sure the controller has the bus up */
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -1288,13 +1288,13 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		/* Turn off our contribution to the HT clock request */
 		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
 
-		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR,
 			SBSDIO_FORCE_HW_CLKREQ_OFF, NULL);
 
 		/* Isolate the bus */
 		if (bus->ci->chip != BCM4329_CHIP_ID) {
-			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL,
 				SBSDIO_DEVCTL_PADS_ISO, NULL);
 		}
@@ -1305,14 +1305,14 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 	} else {
 		/* Waking up: bus power up is ok, set local state */
 
-		brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
 		/* Force pad isolation off if possible
 			 (in case power never toggled) */
 		if ((bus->ci->buscoretype == PCMCIA_CORE_ID)
 		    && (bus->ci->buscorerev >= 10))
-			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, 0, NULL);
 
 		/* Make sure the controller has the bus up */
@@ -1338,7 +1338,7 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		/* Enable interrupts again */
 		if (bus->intr && (bus->drvr->busstate == BRCMF_BUS_DATA)) {
 			bus->intdis = false;
-			brcmf_sdcard_intr_enable(bus->card);
+			brcmf_sdcard_intr_enable(bus->sdiodev);
 		}
 	}
 
@@ -1361,14 +1361,11 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 	u16 len, pad = 0;
 	u32 swheader;
 	uint retries = 0;
-	struct brcmf_sdio_card *card;
 	struct sk_buff *new;
 	int i;
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	card = bus->card;
-
 	if (bus->drvr->dongle_reset) {
 		ret = -EPERM;
 		goto done;
@@ -1453,7 +1450,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 			len = roundup(len, ALIGNMENT);
 
 	do {
-		ret = brcmf_sdbrcm_send_buf(bus, brcmf_sdcard_cur_sbwad(card),
+		ret = brcmf_sdbrcm_send_buf(bus,
+			brcmf_sdcard_cur_sbwad(bus->sdiodev),
 			SDIO_FUNC_2, F2SYNC, frame, len, pkt, NULL, NULL);
 		bus->f2txdata++;
 
@@ -1464,18 +1462,20 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 				    "terminate frame.\n", __func__, ret));
 			bus->tx_sderrs++;
 
-			brcmf_sdcard_abort(card, SDIO_FUNC_2);
-			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
+			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
 					 NULL);
 			bus->f1regdata++;
 
 			for (i = 0; i < 3; i++) {
 				u8 hi, lo;
-				hi = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+				hi = brcmf_sdcard_cfg_read(bus->sdiodev,
+						     SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCHI,
 						     NULL);
-				lo = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+				lo = brcmf_sdcard_cfg_read(bus->sdiodev,
+						     SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCLO,
 						     NULL);
 				bus->f1regdata += 2;
@@ -1647,7 +1647,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 				  offsetof(struct sdpcmd_regs, intstatus),
 				  &retries);
 			bus->f2txdata++;
-			if (brcmf_sdcard_regfail(bus->card))
+			if (brcmf_sdcard_regfail(bus->sdiodev))
 				break;
 			if (intstatus & bus->hostintmask)
 				bus->ipend = true;
@@ -1669,7 +1669,6 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	u16 len;
 	u32 swheader;
 	uint retries = 0;
-	struct brcmf_sdio_card *card = bus->card;
 	u8 doff = 0;
 	int ret = -1;
 	int i;
@@ -1769,7 +1768,8 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 		do {
 			bus->ctrl_frame_stat = false;
 			ret = brcmf_sdbrcm_send_buf(bus,
-				brcmf_sdcard_cur_sbwad(card), SDIO_FUNC_2,
+				brcmf_sdcard_cur_sbwad(bus->sdiodev),
+				SDIO_FUNC_2,
 				F2SYNC, frame, len, NULL, NULL, NULL);
 
 			if (ret < 0) {
@@ -1780,20 +1780,21 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 					    __func__, ret));
 				bus->tx_sderrs++;
 
-				brcmf_sdcard_abort(card, SDIO_FUNC_2);
+				brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 
-				brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+				brcmf_sdcard_cfg_write(bus->sdiodev,
+						 SDIO_FUNC_1,
 						 SBSDIO_FUNC1_FRAMECTRL,
 						 SFC_WF_TERM, NULL);
 				bus->f1regdata++;
 
 				for (i = 0; i < 3; i++) {
 					u8 hi, lo;
-					hi = brcmf_sdcard_cfg_read(card,
+					hi = brcmf_sdcard_cfg_read(bus->sdiodev,
 					     SDIO_FUNC_1,
 					     SBSDIO_FUNC1_WFRAMEBCHI,
 					     NULL);
-					lo = brcmf_sdcard_cfg_read(card,
+					lo = brcmf_sdcard_cfg_read(bus->sdiodev,
 					     SDIO_FUNC_1,
 					     SBSDIO_FUNC1_WFRAMEBCLO,
 					     NULL);
@@ -2178,8 +2179,8 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 		BRCMF_INFO(("%s: %s %d bytes at offset 0x%08x in window"
 			    " 0x%08x\n", __func__, (write ? "write" : "read"),
 			    dsize, sdaddr, (address & SBSDIO_SBWINDOW_MASK)));
-		bcmerror =
-		     brcmf_sdcard_rwdata(bus->card, write, sdaddr, data, dsize);
+		bcmerror = brcmf_sdcard_rwdata(bus->sdiodev, write,
+					       sdaddr, data, dsize);
 		if (bcmerror) {
 			BRCMF_ERROR(("%s: membytes transfer failed\n",
 				     __func__));
@@ -2205,9 +2206,10 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 xfer_done:
 	/* Return the window to backplane enumeration space for core access */
 	if (brcmf_sdbrcm_set_siaddr_window(bus,
-					   brcmf_sdcard_cur_sbwad(bus->card)))
+					   brcmf_sdcard_cur_sbwad(
+							bus->sdiodev)))
 		BRCMF_ERROR(("%s: FAILED to set window back to 0x%x\n",
-			     __func__, brcmf_sdcard_cur_sbwad(bus->card)));
+			     __func__, brcmf_sdcard_cur_sbwad(bus->sdiodev)));
 
 	return bcmerror;
 }
@@ -2615,9 +2617,9 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 			BRCMF_INTR(("%s: %s SDIO interrupts\n", __func__,
 				    bus->intr ? "enable" : "disable"));
 			if (bus->intr)
-				brcmf_sdcard_intr_enable(bus->card);
+				brcmf_sdcard_intr_enable(bus->sdiodev);
 			else
-				brcmf_sdcard_intr_disable(bus->card);
+				brcmf_sdcard_intr_disable(bus->sdiodev);
 		}
 		break;
 
@@ -2807,9 +2809,9 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 
 			addr = bus->ci->buscorebase + sd_ptr->offset;
 			size = sd_ptr->func;
-			int_val = (s32) brcmf_sdcard_reg_read(bus->card, addr,
-							      size);
-			if (brcmf_sdcard_regfail(bus->card))
+			int_val = (s32) brcmf_sdcard_reg_read(bus->sdiodev,
+							      addr, size);
+			if (brcmf_sdcard_regfail(bus->sdiodev))
 				bcmerror = -EIO;
 			memcpy(arg, &int_val, sizeof(s32));
 			break;
@@ -2824,9 +2826,9 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 
 			addr = bus->ci->buscorebase + sd_ptr->offset;
 			size = sd_ptr->func;
-			brcmf_sdcard_reg_write(bus->card, addr, size,
+			brcmf_sdcard_reg_write(bus->sdiodev, addr, size,
 					       sd_ptr->value);
-			if (brcmf_sdcard_regfail(bus->card))
+			if (brcmf_sdcard_regfail(bus->sdiodev))
 				bcmerror = -EIO;
 			break;
 		}
@@ -2842,9 +2844,9 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 
 			addr = SI_ENUM_BASE + sdreg.offset;
 			size = sdreg.func;
-			int_val = (s32) brcmf_sdcard_reg_read(bus->card, addr,
-							      size);
-			if (brcmf_sdcard_regfail(bus->card))
+			int_val = (s32) brcmf_sdcard_reg_read(bus->sdiodev,
+							      addr, size);
+			if (brcmf_sdcard_regfail(bus->sdiodev))
 				bcmerror = -EIO;
 			memcpy(arg, &int_val, sizeof(s32));
 			break;
@@ -2859,9 +2861,9 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 
 			addr = SI_ENUM_BASE + sdreg.offset;
 			size = sdreg.func;
-			brcmf_sdcard_reg_write(bus->card, addr, size,
+			brcmf_sdcard_reg_write(bus->sdiodev, addr, size,
 					       sdreg.value);
-			if (brcmf_sdcard_regfail(bus->card))
+			if (brcmf_sdcard_regfail(bus->sdiodev))
 				bcmerror = -EIO;
 			break;
 		}
@@ -2871,15 +2873,15 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 			*(char *)arg = 0;
 
 			strcat(arg, "\nFunc 0\n");
-			brcmf_sdcard_cis_read(bus->card, 0x10,
+			brcmf_sdcard_cis_read(bus->sdiodev, 0x10,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
 			strcat(arg, "\nFunc 1\n");
-			brcmf_sdcard_cis_read(bus->card, 0x11,
+			brcmf_sdcard_cis_read(bus->sdiodev, 0x11,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
 			strcat(arg, "\nFunc 2\n");
-			brcmf_sdcard_cis_read(bus->card, 0x12,
+			brcmf_sdcard_cis_read(bus->sdiodev, 0x12,
 					(u8 *) arg + strlen(arg),
 					SBSDIO_CIS_SIZE_LIMIT);
 			break;
@@ -3106,9 +3108,10 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 	if (enter) {
 		bus->alp_only = true;
 
-		brcmf_sdbrcm_chip_disablecore(bus->card, bus->ci->armcorebase);
+		brcmf_sdbrcm_chip_disablecore(bus->sdiodev,
+					      bus->ci->armcorebase);
 
-		brcmf_sdbrcm_chip_resetcore(bus->card, bus->ci->ramcorebase);
+		brcmf_sdbrcm_chip_resetcore(bus->sdiodev, bus->ci->ramcorebase);
 
 		/* Clear the top bit of memory */
 		if (bus->ramsize) {
@@ -3117,7 +3120,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 					 (u8 *)&zeros, 4);
 		}
 	} else {
-		regdata = brcmf_sdcard_reg_read(bus->card,
+		regdata = brcmf_sdcard_reg_read(bus->sdiodev,
 			CORE_SB(bus->ci->ramcorebase, sbtmstatelow), 4);
 		regdata &= (SBTML_RESET | SBTML_REJ_MASK |
 			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
@@ -3137,7 +3140,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 		w_sdreg32(bus, 0xFFFFFFFF,
 			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 
-		brcmf_sdbrcm_chip_resetcore(bus->card, bus->ci->armcorebase);
+		brcmf_sdbrcm_chip_resetcore(bus->sdiodev, bus->ci->armcorebase);
 
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
@@ -3181,14 +3184,14 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 		/* Turn on clock in case SD command needs backplane */
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
-		bcmerror = brcmf_sdcard_iovar_op(bus->card, name, params, plen,
-						 arg, len, set);
+		bcmerror = brcmf_sdcard_iovar_op(bus->sdiodev, name, params,
+						 plen, arg, len, set);
 
 		/* Similar check for blocksize change */
 		if (set && strcmp(name, "sd_blocksize") == 0) {
 			s32 fnum = 2;
 			if (brcmf_sdcard_iovar_op
-			    (bus->card, "sd_blocksize", &fnum, sizeof(s32),
+			    (bus->sdiodev, "sd_blocksize", &fnum, sizeof(s32),
 			     &bus->blocksize, sizeof(s32),
 			     false) != 0) {
 				bus->blocksize = 0;
@@ -3278,10 +3281,10 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 	bus->drvr->busstate = BRCMF_BUS_DOWN;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
+	saveclk = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 					SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_CHIPCLKCSR,
 				       (saveclk | SBSDIO_FORCE_HT), &err);
 	}
@@ -3291,8 +3294,8 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 
 	/* Turn off the bus (F2), free any pending packets */
 	BRCMF_INTR(("%s: disable SDIO interrupts\n", __func__));
-	brcmf_sdcard_intr_disable(bus->card);
-	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+	brcmf_sdcard_intr_disable(bus->sdiodev);
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			 SDIO_FUNC_ENABLE_1, NULL);
 
 	/* Clear any pending interrupts now that F2 is disabled */
@@ -3339,7 +3342,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 
 	/* try to download image and nvram to the dongle */
 	if (drvr->busstate == BRCMF_BUS_DOWN) {
-		if (!(brcmf_sdbrcm_download_firmware(bus, bus->card)))
+		if (!(brcmf_sdbrcm_download_firmware(bus, bus->sdiodev)))
 			return -1;
 	}
 
@@ -3360,10 +3363,10 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
 	saveclk =
-	    brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
+	    brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 				  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_CHIPCLKCSR,
 				       (saveclk | SBSDIO_FORCE_HT), &err);
 	}
@@ -3378,13 +3381,13 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 		  offsetof(struct sdpcmd_regs, tosbmailboxdata), &retries);
 	enable = (SDIO_FUNC_ENABLE_1 | SDIO_FUNC_ENABLE_2);
 
-	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx, enable,
-			       NULL);
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+			       enable, NULL);
 
 	timeout = jiffies + msecs_to_jiffies(BRCMF_WAIT_F2RDY);
 	ready = 0;
 	while (enable != ready) {
-		ready = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_0,
+		ready = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_0,
 					      SDIO_CCCR_IORx, NULL);
 		if (time_after(jiffies, timeout))
 			break;
@@ -3403,8 +3406,8 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 		w_sdreg32(bus, bus->hostintmask,
 			  offsetof(struct sdpcmd_regs, hostintmask), &retries);
 
-		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_WATERMARK,
-				 (u8) watermark, &err);
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+				       SBSDIO_WATERMARK, (u8) watermark, &err);
 
 		/* Set bus state according to enable result */
 		drvr->busstate = BRCMF_BUS_DATA;
@@ -3413,10 +3416,10 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 		if (bus->intr) {
 			BRCMF_INTR(("%s: enable SDIO device interrupts\n",
 				    __func__));
-			brcmf_sdcard_intr_enable(bus->card);
+			brcmf_sdcard_intr_enable(bus->sdiodev);
 		} else {
 			BRCMF_INTR(("%s: disable SDIO interrupts\n", __func__));
-			brcmf_sdcard_intr_disable(bus->card);
+			brcmf_sdcard_intr_disable(bus->sdiodev);
 		}
 
 	}
@@ -3424,13 +3427,13 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	else {
 		/* Disable F2 again */
 		enable = SDIO_FUNC_ENABLE_1;
-		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx,
-				       enable, NULL);
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0,
+				       SDIO_CCCR_IOEx, enable, NULL);
 	}
 
 	/* Restore previous clock setting */
-	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-			 saveclk, &err);
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
 
 #if defined(OOB_INTR_ONLY)
 	/* Host registration for OOB interrupt */
@@ -3459,7 +3462,6 @@ exit:
 
 static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 {
-	struct brcmf_sdio_card *card = bus->card;
 	uint retries = 0;
 	u16 lastrbc;
 	u8 hi, lo;
@@ -3470,17 +3472,18 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 		     (rtx ? ", send NAK" : "")));
 
 	if (abort)
-		brcmf_sdcard_abort(card, SDIO_FUNC_2);
+		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 
-	brcmf_sdcard_cfg_write(card, SDIO_FUNC_1, SBSDIO_FUNC1_FRAMECTRL,
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_FRAMECTRL,
 			       SFC_RF_TERM, &err);
 	bus->f1regdata++;
 
 	/* Wait until the packet has been flushed (device/FIFO stable) */
 	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
-		hi = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+		hi = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 					   SBSDIO_FUNC1_RFRAMEBCHI, NULL);
-		lo = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+		lo = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 					   SBSDIO_FUNC1_RFRAMEBCLO, NULL);
 		bus->f1regdata += 2;
 
@@ -3516,14 +3519,13 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 	bus->nextlen = 0;
 
 	/* If we can't reach the device, signal failure */
-	if (err || brcmf_sdcard_regfail(card))
+	if (err || brcmf_sdcard_regfail(bus->sdiodev))
 		bus->drvr->busstate = BRCMF_BUS_DOWN;
 }
 
 static void
 brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 {
-	struct brcmf_sdio_card *card = bus->card;
 	uint rdlen, pad;
 
 	int sdret;
@@ -3590,7 +3592,8 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 	}
 
 	/* Read remainder of frame body into the rxctl buffer */
-	sdret = brcmf_sdcard_recv_buf(card, brcmf_sdcard_cur_sbwad(card),
+	sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
+				brcmf_sdcard_cur_sbwad(bus->sdiodev),
 				SDIO_FUNC_2,
 				F2SYNC, (bus->rxctl + firstread), rdlen,
 				NULL, NULL, NULL);
@@ -3753,14 +3756,14 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		 * packet and and copy into the chain.
 		 */
 		if (usechain) {
-			errcode = brcmf_sdcard_recv_buf(bus->card,
-					brcmf_sdcard_cur_sbwad(bus->card),
+			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
+					brcmf_sdcard_cur_sbwad(bus->sdiodev),
 					SDIO_FUNC_2,
 					F2SYNC, (u8 *) pfirst->data, dlen,
 					pfirst, NULL, NULL);
 		} else if (bus->dataptr) {
-			errcode = brcmf_sdcard_recv_buf(bus->card,
-					brcmf_sdcard_cur_sbwad(bus->card),
+			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
+					brcmf_sdcard_cur_sbwad(bus->sdiodev),
 					SDIO_FUNC_2,
 					F2SYNC, bus->dataptr, dlen,
 					NULL, NULL, NULL);
@@ -4029,8 +4032,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 static uint
 brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 {
-	struct brcmf_sdio_card *card = bus->card;
-
 	u16 len, check;	/* Extracted hardware header fields */
 	u8 chan, seq, doff;	/* Extracted software header fields */
 	u8 fcbits;		/* Extracted fcbits from software header */
@@ -4135,8 +4136,10 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 					}
 					rxbuf = bus->rxctl;
 					/* Read the entire frame */
-					sdret = brcmf_sdcard_recv_buf(card,
-						   brcmf_sdcard_cur_sbwad(card),
+					sdret = brcmf_sdcard_recv_buf(
+						   bus->sdiodev,
+						   brcmf_sdcard_cur_sbwad(
+							bus->sdiodev),
 						   SDIO_FUNC_2, F2SYNC,
 						   rxbuf, rdlen,
 						   NULL, NULL, NULL);
@@ -4176,8 +4179,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
 				rxbuf = (u8 *) (pkt->data);
 				/* Read the entire frame */
-				sdret = brcmf_sdcard_recv_buf(card,
-						brcmf_sdcard_cur_sbwad(card),
+				sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
+						brcmf_sdcard_cur_sbwad(
+							bus->sdiodev),
 						SDIO_FUNC_2, F2SYNC,
 						rxbuf, rdlen,
 						pkt, NULL, NULL);
@@ -4360,8 +4364,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			break;
 
 		/* Read frame header (hardware and software) */
-		sdret = brcmf_sdcard_recv_buf(card,
-				brcmf_sdcard_cur_sbwad(card),
+		sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
+				brcmf_sdcard_cur_sbwad(bus->sdiodev),
 				SDIO_FUNC_2, F2SYNC, bus->rxhdr, firstread,
 				NULL, NULL, NULL);
 		bus->f2rxhdrs++;
@@ -4517,8 +4521,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
 
 		/* Read the remaining frame data */
-		sdret = brcmf_sdcard_recv_buf(card,
-				brcmf_sdcard_cur_sbwad(card),
+		sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
+				brcmf_sdcard_cur_sbwad(bus->sdiodev),
 				SDIO_FUNC_2, F2SYNC, ((u8 *) (pkt->data)),
 				rdlen, pkt, NULL, NULL);
 		bus->f2rxdata++;
@@ -4694,7 +4698,6 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 
 static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 {
-	struct brcmf_sdio_card *card = bus->card;
 	u32 intstatus, newstatus = 0;
 	uint retries = 0;
 	uint rxlimit = brcmf_rxbound;	/* Rx frames to read before resched */
@@ -4717,7 +4720,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 
 #ifdef BCMDBG
 		/* Check for inconsistent device control */
-		devctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+		devctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 					       SBSDIO_DEVICE_CTL, &err);
 		if (err) {
 			BRCMF_ERROR(("%s: error reading DEVCTL: %d\n",
@@ -4727,7 +4730,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 #endif				/* BCMDBG */
 
 		/* Read CSR, if clock on switch to AVAIL, else ignore */
-		clkctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+		clkctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
 			BRCMF_ERROR(("%s: error reading CSR: %d\n", __func__,
@@ -4739,7 +4742,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 			    devctl, clkctl));
 
 		if (SBSDIO_HTAV(clkctl)) {
-			devctl = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+			devctl = brcmf_sdcard_cfg_read(bus->sdiodev,
+						       SDIO_FUNC_1,
 						       SBSDIO_DEVICE_CTL, &err);
 			if (err) {
 				BRCMF_ERROR(("%s: error reading DEVCTL: %d\n",
@@ -4747,7 +4751,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 				bus->drvr->busstate = BRCMF_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, devctl, &err);
 			if (err) {
 				BRCMF_ERROR(("%s: error writing DEVCTL: %d\n",
@@ -4773,7 +4777,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 		r_sdreg32(bus, &newstatus,
 			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 		bus->f1regdata++;
-		if (brcmf_sdcard_regfail(bus->card))
+		if (brcmf_sdcard_regfail(bus->sdiodev))
 			newstatus = 0;
 		newstatus &= bus->hostintmask;
 		bus->fcstate = !!(newstatus & I_HMB_FC_STATE);
@@ -4854,18 +4858,19 @@ clkwait:
 	 * or clock availability.  (Allows tx loop to check ipend if desired.)
 	 * (Unless register access seems hosed, as we may not be able to ACK...)
 	 */
-	if (bus->intr && bus->intdis && !brcmf_sdcard_regfail(card)) {
+	if (bus->intr && bus->intdis && !brcmf_sdcard_regfail(bus->sdiodev)) {
 		BRCMF_INTR(("%s: enable SDIO interrupts, rxdone %d"
 			    " framecnt %d\n", __func__, rxdone, framecnt));
 		bus->intdis = false;
-		brcmf_sdcard_intr_enable(card);
+		brcmf_sdcard_intr_enable(bus->sdiodev);
 	}
 
 	if (DATAOK(bus) && bus->ctrl_frame_stat &&
 		(bus->clkstate == CLK_AVAIL)) {
 		int ret, i;
 
-		ret = brcmf_sdbrcm_send_buf(bus, brcmf_sdcard_cur_sbwad(card),
+		ret = brcmf_sdbrcm_send_buf(bus,
+			brcmf_sdcard_cur_sbwad(bus->sdiodev),
 			SDIO_FUNC_2, F2SYNC, (u8 *) bus->ctrl_frame_buf,
 			(u32) bus->ctrl_frame_len, NULL, NULL, NULL);
 
@@ -4876,19 +4881,21 @@ clkwait:
 				    "terminate frame.\n", __func__, ret));
 			bus->tx_sderrs++;
 
-			brcmf_sdcard_abort(card, SDIO_FUNC_2);
+			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 
-			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
+			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
 					 NULL);
 			bus->f1regdata++;
 
 			for (i = 0; i < 3; i++) {
 				u8 hi, lo;
-				hi = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+				hi = brcmf_sdcard_cfg_read(bus->sdiodev,
+						     SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCHI,
 						     NULL);
-				lo = brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+				lo = brcmf_sdcard_cfg_read(bus->sdiodev,
+						     SDIO_FUNC_1,
 						     SBSDIO_FUNC1_WFRAMEBCLO,
 						     NULL);
 				bus->f1regdata += 2;
@@ -4918,10 +4925,10 @@ clkwait:
 	/* On failed register access, all bets are off:
 		 no resched or interrupts */
 	if ((bus->drvr->busstate == BRCMF_BUS_DOWN) ||
-	    brcmf_sdcard_regfail(card)) {
+	    brcmf_sdcard_regfail(bus->sdiodev)) {
 		BRCMF_ERROR(("%s: failed backplane access over SDIO, halting "
 			     "operation %d\n", __func__,
-			     brcmf_sdcard_regfail(card)));
+			     brcmf_sdcard_regfail(bus->sdiodev)));
 		bus->drvr->busstate = BRCMF_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
@@ -4951,7 +4958,6 @@ clkwait:
 void brcmf_sdbrcm_isr(void *arg)
 {
 	struct brcmf_bus *bus = (struct brcmf_bus *) arg;
-	struct brcmf_sdio_card *card;
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
@@ -4959,7 +4965,6 @@ void brcmf_sdbrcm_isr(void *arg)
 		BRCMF_ERROR(("%s : bus is null pointer , exit\n", __func__));
 		return;
 	}
-	card = bus->card;
 
 	if (bus->drvr->busstate == BRCMF_BUS_DOWN) {
 		BRCMF_ERROR(("%s : bus is down. we have nothing to do\n",
@@ -4982,7 +4987,7 @@ void brcmf_sdbrcm_isr(void *arg)
 	else
 		BRCMF_ERROR(("brcmf_sdbrcm_isr() w/o interrupt configured!\n"));
 
-	brcmf_sdcard_intr_disable(card);
+	brcmf_sdcard_intr_disable(bus->sdiodev);
 	bus->intdis = true;
 
 #if defined(SDIO_ISR_THREAD)
@@ -5287,7 +5292,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 
 			if (!bus->dpc_sched) {
 				u8 devpend;
-				devpend = brcmf_sdcard_cfg_read(bus->card,
+				devpend = brcmf_sdcard_cfg_read(bus->sdiodev,
 						SDIO_FUNC_0, SDIO_CCCR_INTx,
 						NULL);
 				intstatus =
@@ -5301,7 +5306,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 				bus->pollcnt++;
 				bus->ipend = true;
 				if (bus->intr)
-					brcmf_sdcard_intr_disable(bus->card);
+					brcmf_sdcard_intr_disable(bus->sdiodev);
 
 				bus->dpc_sched = true;
 				brcmf_sdbrcm_sched_dpc(bus);
@@ -5429,7 +5434,7 @@ static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 }
 
 void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
-			 u32 regsva, void *card)
+			 u32 regsva, struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
 	struct brcmf_bus *bus;
@@ -5467,14 +5472,14 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 			     __func__));
 		goto fail;
 	}
-	bus->card = card;
+	bus->sdiodev = sdiodev;
 	bus->bus = BRCMF_BUS;
 	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
 	bus->usebufpool = false;	/* Use bufpool if allocated,
 					 else use locally malloced rxbuf */
 
 	/* attempt to attach to the dongle */
-	if (!(brcmf_sdbrcm_probe_attach(bus, card, regsva))) {
+	if (!(brcmf_sdbrcm_probe_attach(bus, regsva))) {
 		BRCMF_ERROR(("%s: brcmf_sdbrcm_probe_attach failed\n",
 			     __func__));
 		goto fail;
@@ -5536,13 +5541,13 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	}
 
 	/* Allocate buffers */
-	if (!(brcmf_sdbrcm_probe_malloc(bus, card))) {
+	if (!(brcmf_sdbrcm_probe_malloc(bus))) {
 		BRCMF_ERROR(("%s: brcmf_sdbrcm_probe_malloc failed\n",
 			     __func__));
 		goto fail;
 	}
 
-	if (!(brcmf_sdbrcm_probe_init(bus, card))) {
+	if (!(brcmf_sdbrcm_probe_init(bus))) {
 		BRCMF_ERROR(("%s: brcmf_sdbrcm_probe_init failed\n", __func__));
 		goto fail;
 	}
@@ -5550,8 +5555,8 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	/* Register interrupt callback, but mask it (not operational yet). */
 	BRCMF_INTR(("%s: disable SDIO interrupts (not interested yet)\n",
 		    __func__));
-	brcmf_sdcard_intr_disable(card);
-	ret = brcmf_sdcard_intr_reg(card, brcmf_sdbrcm_isr, bus);
+	brcmf_sdcard_intr_disable(bus->sdiodev);
+	ret = brcmf_sdcard_intr_reg(bus->sdiodev, brcmf_sdbrcm_isr, bus);
 	if (ret != 0) {
 		BRCMF_ERROR(("%s: FAILED: sdcard_intr_reg returned %d\n",
 			     __func__, ret));
@@ -5584,7 +5589,7 @@ fail:
 }
 
 static bool
-brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva)
+brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 {
 	u8 clkctl = 0;
 	int err = 0;
@@ -5600,7 +5605,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva)
 
 #ifdef BCMDBG
 	printk(KERN_DEBUG "F1 signature read @0x18000000=0x%4x\n",
-	       brcmf_sdcard_reg_read(bus->card, SI_ENUM_BASE, 4));
+	       brcmf_sdcard_reg_read(bus->sdiodev, SI_ENUM_BASE, 4));
 
 #endif				/* BCMDBG */
 
@@ -5609,11 +5614,12 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva)
 	 * programs PLL control regs
 	 */
 
-	brcmf_sdcard_cfg_write(card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-			 BRCMF_INIT_CLKCTL1, &err);
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_CHIPCLKCSR,
+			       BRCMF_INIT_CLKCTL1, &err);
 	if (!err)
 		clkctl =
-		    brcmf_sdcard_cfg_read(card, SDIO_FUNC_1,
+		    brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
@@ -5639,7 +5645,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva)
 
 	/* Get info on the ARM and SOCRAM cores... */
 	if (!BRCMF_NOPMU(bus)) {
-		brcmf_sdcard_reg_read(bus->card,
+		brcmf_sdcard_reg_read(bus->sdiodev,
 			  CORE_SB(bus->ci->armcorebase, sbidhigh), 4);
 		bus->orig_ramsize = bus->ci->ramsize;
 		if (!(bus->orig_ramsize)) {
@@ -5658,8 +5664,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva)
 	/* Set core control so an SDIO reset does a backplane reset */
 	reg_addr = bus->ci->buscorebase +
 		   offsetof(struct sdpcmd_regs, corecontrol);
-	reg_val = brcmf_sdcard_reg_read(bus->card, reg_addr, sizeof(u32));
-	brcmf_sdcard_reg_write(bus->card, reg_addr, sizeof(u32),
+	reg_val = brcmf_sdcard_reg_read(bus->sdiodev, reg_addr, sizeof(u32));
+	brcmf_sdcard_reg_write(bus->sdiodev, reg_addr, sizeof(u32),
 			       reg_val | CC_BPRESEN);
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
@@ -5680,7 +5686,7 @@ fail:
 	return false;
 }
 
-static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus, void *card)
+static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus)
 {
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
@@ -5720,7 +5726,7 @@ fail:
 	return false;
 }
 
-static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
+static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
 {
 	s32 fnum;
 
@@ -5731,7 +5737,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
 #endif				/* SDTEST */
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	brcmf_sdcard_cfg_write(card, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			       SDIO_FUNC_ENABLE_1, NULL);
 
 	bus->drvr->busstate = BRCMF_BUS_DOWN;
@@ -5739,8 +5745,8 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
 	bus->rxflow = false;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdcard_cfg_write(card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR, 0,
-			       NULL);
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
 	/* ...and initialize clock/power states */
 	bus->clkstate = CLK_SDONLY;
@@ -5749,8 +5755,9 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
 
 	/* Query the F2 block size, set roundup accordingly */
 	fnum = 2;
-	if (brcmf_sdcard_iovar_op(card, "sd_blocksize", &fnum, sizeof(s32),
-			    &bus->blocksize, sizeof(s32), false) != 0) {
+	if (brcmf_sdcard_iovar_op(bus->sdiodev, "sd_blocksize", &fnum,
+				  sizeof(s32), &bus->blocksize,
+				  sizeof(s32), false) != 0) {
 		bus->blocksize = 0;
 		BRCMF_ERROR(("%s: fail on %s get\n", __func__, "sd_blocksize"));
 	} else {
@@ -5761,7 +5768,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
 
 	/* Query if bus module supports packet chaining,
 		 default to use if supported */
-	if (brcmf_sdcard_iovar_op(card, "sd_rxchain", NULL, 0,
+	if (brcmf_sdcard_iovar_op(bus->sdiodev, "sd_rxchain", NULL, 0,
 			    &bus->sd_rxchain, sizeof(s32),
 			    false) != 0)
 		bus->sd_rxchain = false;
@@ -5797,8 +5804,8 @@ static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
 
 	if (bus) {
 		/* De-register interrupt handler */
-		brcmf_sdcard_intr_disable(bus->card);
-		brcmf_sdcard_intr_dereg(bus->card);
+		brcmf_sdcard_intr_disable(bus->sdiodev);
+		brcmf_sdcard_intr_dereg(bus->sdiodev);
 
 		if (bus->drvr) {
 			brcmf_detach(bus->drvr);
@@ -6090,7 +6097,7 @@ brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn, uint flags,
 		    void *handle)
 {
 	return brcmf_sdcard_send_buf
-		(bus->card, addr, fn, flags, buf, nbytes, pkt, complete,
+		(bus->sdiodev, addr, fn, flags, buf, nbytes, pkt, complete,
 		 handle);
 }
 
@@ -6129,10 +6136,9 @@ int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 			/* Turn on WLAN */
 
 			/* Attempt to re-attach & download */
-			if (brcmf_sdbrcm_probe_attach(bus, bus->card,
-						      SI_ENUM_BASE)) {
+			if (brcmf_sdbrcm_probe_attach(bus, SI_ENUM_BASE)) {
 				/* Attempt to download binary to the dongle */
-				if (brcmf_sdbrcm_probe_init(bus, bus->card)) {
+				if (brcmf_sdbrcm_probe_init(bus)) {
 					/* Re-init bus, enable F2 transfer */
 					brcmf_sdbrcm_bus_init(bus->drvr, false);
 
@@ -6157,7 +6163,7 @@ int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 }
 
 static int
-brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_card *card,
+brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 			      struct chip_info *ci, u32 regs)
 {
 	u32 regdata;
@@ -6169,7 +6175,7 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_card *card,
 	 * other ways of recognition should be added here.
 	 */
 	ci->cccorebase = regs;
-	regdata = brcmf_sdcard_reg_read(card,
+	regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_CC_REG(ci->cccorebase, chipid), 4);
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
@@ -6191,15 +6197,15 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_card *card,
 		return -ENODEV;
 	}
 
-	regdata = brcmf_sdcard_reg_read(card,
+	regdata = brcmf_sdcard_reg_read(sdiodev,
 		CORE_SB(ci->cccorebase, sbidhigh), 4);
 	ci->ccrev = SBCOREREV(regdata);
 
-	regdata = brcmf_sdcard_reg_read(card,
+	regdata = brcmf_sdcard_reg_read(sdiodev,
 		CORE_CC_REG(ci->cccorebase, pmucapabilities), 4);
 	ci->pmurev = regdata & PCAP_REV_MASK;
 
-	regdata = brcmf_sdcard_reg_read(card,
+	regdata = brcmf_sdcard_reg_read(sdiodev,
 					CORE_SB(ci->buscorebase, sbidhigh), 4);
 	ci->buscorerev = SBCOREREV(regdata);
 	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
@@ -6209,87 +6215,87 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_card *card,
 		    ci->buscorerev, ci->buscoretype));
 
 	/* get chipcommon capabilites */
-	ci->cccaps = brcmf_sdcard_reg_read(card,
+	ci->cccaps = brcmf_sdcard_reg_read(sdiodev,
 		CORE_CC_REG(ci->cccorebase, capabilities), 4);
 
 	return 0;
 }
 
 static void
-brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_card *card, u32 corebase)
+brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 {
 	u32 regdata;
 
-	regdata = brcmf_sdcard_reg_read(card,
+	regdata = brcmf_sdcard_reg_read(sdiodev,
 		CORE_SB(corebase, sbtmstatelow), 4);
 	if (regdata & SBTML_RESET)
 		return;
 
-	regdata = brcmf_sdcard_reg_read(card,
+	regdata = brcmf_sdcard_reg_read(sdiodev,
 		CORE_SB(corebase, sbtmstatelow), 4);
 	if ((regdata & (SICF_CLOCK_EN << SBTML_SICF_SHIFT)) != 0) {
 		/*
 		 * set target reject and spin until busy is clear
 		 * (preserve core-specific bits)
 		 */
-		regdata = brcmf_sdcard_reg_read(card,
+		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatelow), 4);
-		brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatelow), 4,
-			regdata | SBTML_REJ);
+		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow),
+				       4, regdata | SBTML_REJ);
 
-		regdata = brcmf_sdcard_reg_read(card,
+		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatelow), 4);
 		udelay(1);
-		SPINWAIT((brcmf_sdcard_reg_read(card,
+		SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatehigh), 4) &
 			SBTMH_BUSY), 100000);
 
-		regdata = brcmf_sdcard_reg_read(card,
+		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatehigh), 4);
 		if (regdata & SBTMH_BUSY)
 			BRCMF_ERROR(("%s: ARM core still busy\n", __func__));
 
-		regdata = brcmf_sdcard_reg_read(card,
+		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbidlow), 4);
 		if (regdata & SBIDL_INIT) {
-			regdata = brcmf_sdcard_reg_read(card,
+			regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(corebase, sbimstate), 4) |
 				SBIM_RJ;
-			brcmf_sdcard_reg_write(card,
+			brcmf_sdcard_reg_write(sdiodev,
 				CORE_SB(corebase, sbimstate), 4,
 				regdata);
-			regdata = brcmf_sdcard_reg_read(card,
+			regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(corebase, sbimstate), 4);
 			udelay(1);
-			SPINWAIT((brcmf_sdcard_reg_read(card,
+			SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(corebase, sbimstate), 4) &
 				SBIM_BY), 100000);
 		}
 
 		/* set reset and reject while enabling the clocks */
-		brcmf_sdcard_reg_write(card,
+		brcmf_sdcard_reg_write(sdiodev,
 			CORE_SB(corebase, sbtmstatelow), 4,
 			(((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
 			SBTML_REJ | SBTML_RESET));
-		regdata = brcmf_sdcard_reg_read(card,
+		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatelow), 4);
 		udelay(10);
 
 		/* clear the initiator reject bit */
-		regdata = brcmf_sdcard_reg_read(card,
+		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbidlow), 4);
 		if (regdata & SBIDL_INIT) {
-			regdata = brcmf_sdcard_reg_read(card,
+			regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(corebase, sbimstate), 4) &
 				~SBIM_RJ;
-			brcmf_sdcard_reg_write(card,
+			brcmf_sdcard_reg_write(sdiodev,
 				CORE_SB(corebase, sbimstate), 4,
 				regdata);
 		}
 	}
 
 	/* leave reset and reject asserted */
-	brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
 		(SBTML_REJ | SBTML_RESET));
 	udelay(1);
 }
@@ -6315,8 +6321,8 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	/* bus/core/clk setup for register access */
 	/* Try forcing SDIO core to do ALPAvail request only */
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
-	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-			clkset, &err);
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_CHIPCLKCSR,	clkset, &err);
 	if (err) {
 		BRCMF_ERROR(("%s: error writing for HT off\n", __func__));
 		goto fail;
@@ -6324,11 +6330,11 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 
 	/* If register supported, wait for ALPAvail and then force ALP */
 	/* This may take up to 15 milliseconds */
-	clkval = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
+	clkval = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR, NULL);
 	if ((clkval & ~SBSDIO_AVBITS) == clkset) {
 		SPINWAIT(((clkval =
-				brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
+				brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 						SBSDIO_FUNC1_CHIPCLKCSR,
 						NULL)),
 				!SBSDIO_ALPAV(clkval)),
@@ -6341,7 +6347,7 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 		}
 		clkset = SBSDIO_FORCE_HW_CLKREQ_OFF |
 				SBSDIO_FORCE_ALP;
-		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1,
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				SBSDIO_FUNC1_CHIPCLKCSR,
 				clkset, &err);
 		udelay(65);
@@ -6353,10 +6359,10 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	}
 
 	/* Also, disable the extra SDIO pull-ups */
-	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_SDIOPULLUP,
-			       0, NULL);
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
 
-	err = brcmf_sdbrcm_chip_recognition(bus->card, ci, regs);
+	err = brcmf_sdbrcm_chip_recognition(bus->sdiodev, ci, regs);
 	if (err)
 		goto fail;
 
@@ -6364,24 +6370,24 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	 * Make sure any on-chip ARM is off (in case strapping is wrong),
 	 * or downloaded code was already running.
 	 */
-	brcmf_sdbrcm_chip_disablecore(bus->card, ci->armcorebase);
+	brcmf_sdbrcm_chip_disablecore(bus->sdiodev, ci->armcorebase);
 
-	brcmf_sdcard_reg_write(bus->card,
+	brcmf_sdcard_reg_write(bus->sdiodev,
 		CORE_CC_REG(ci->cccorebase, gpiopullup), 4, 0);
-	brcmf_sdcard_reg_write(bus->card,
+	brcmf_sdcard_reg_write(bus->sdiodev,
 		CORE_CC_REG(ci->cccorebase, gpiopulldown), 4, 0);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 		SDIO_FUNC_ENABLE_1, NULL);
 
 	/* WAR: cmd52 backplane read so core HW will drop ALPReq */
-	clkval = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_1,
+	clkval = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 			0, NULL);
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-			       0, NULL);
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
 	bus->ci = ci;
 	return 0;
@@ -6392,7 +6398,7 @@ fail:
 }
 
 static void
-brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_card *card, u32 corebase)
+brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 {
 	u32 regdata;
 
@@ -6400,37 +6406,38 @@ brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_card *card, u32 corebase)
 	 * Must do the disable sequence first to work for
 	 * arbitrary current core state.
 	 */
-	brcmf_sdbrcm_chip_disablecore(card, corebase);
+	brcmf_sdbrcm_chip_disablecore(sdiodev, corebase);
 
 	/*
 	 * Now do the initialization sequence.
 	 * set reset while enabling the clock and
 	 * forcing them on throughout the core
 	 */
-	brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
 		((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
 		SBTML_RESET);
 	udelay(1);
 
-	regdata = brcmf_sdcard_reg_read(card, CORE_SB(corebase, sbtmstatehigh),
-					4);
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					CORE_SB(corebase, sbtmstatehigh), 4);
 	if (regdata & SBTMH_SERR)
-		brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatehigh),
-				       4, 0);
+		brcmf_sdcard_reg_write(sdiodev,
+				       CORE_SB(corebase, sbtmstatehigh), 4, 0);
 
-	regdata = brcmf_sdcard_reg_read(card, CORE_SB(corebase, sbimstate), 4);
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					CORE_SB(corebase, sbimstate), 4);
 	if (regdata & (SBIM_IBE | SBIM_TO))
-		brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbimstate), 4,
+		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbimstate), 4,
 			regdata & ~(SBIM_IBE | SBIM_TO));
 
 	/* clear reset and allow it to propagate throughout the core */
-	brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
 		(SICF_FGC << SBTML_SICF_SHIFT) |
 		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
 	udelay(1);
 
 	/* leave clock enabled */
-	brcmf_sdcard_reg_write(card, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
 		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
 	udelay(1);
 }
@@ -6524,15 +6531,15 @@ static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
 			}
 		}
 
-		brcmf_sdcard_reg_write(bus->card,
+		brcmf_sdcard_reg_write(bus->sdiodev,
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
 			4, 1);
-		cc_data_temp = brcmf_sdcard_reg_read(bus->card,
+		cc_data_temp = brcmf_sdcard_reg_read(bus->sdiodev,
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr), 4);
 		cc_data_temp &= ~str_mask;
 		drivestrength_sel <<= str_shift;
 		cc_data_temp |= drivestrength_sel;
-		brcmf_sdcard_reg_write(bus->card,
+		brcmf_sdcard_reg_write(bus->sdiodev,
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
 			4, cc_data_temp);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 22441e9..b82a462 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -116,9 +116,6 @@
 #define SUCCESS	0
 #define ERROR	1
 
-/* forward declarations */
-struct brcmf_sdio_card;
-
 struct brcmf_sdreg {
 	int func;
 	int offset;
@@ -158,20 +155,22 @@ struct brcmf_sdmmc_instance {
 struct brcmf_sdio_dev {
 	struct sdio_func *func1;
 	struct sdio_func *func2;
-	struct brcmf_sdio_card *card;
+	void *sdioh;			/* sdioh handler */
+	u32 sbwad;			/* Save backplane window address */
+	bool regfail;			/* status of last reg_r/w call */
 	void *bus;
 };
 
 /* Enable/disable SD interrupt */
-extern int brcmf_sdcard_intr_enable(struct brcmf_sdio_card *card);
-extern int brcmf_sdcard_intr_disable(struct brcmf_sdio_card *card);
+extern int brcmf_sdcard_intr_enable(struct brcmf_sdio_dev *sdiodev);
+extern int brcmf_sdcard_intr_disable(struct brcmf_sdio_dev *sdiodev);
 
 /* Register/deregister device interrupt handler. */
 extern int
-brcmf_sdcard_intr_reg(struct brcmf_sdio_card *card,
+brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev,
 		      void (*fn)(void *), void *argh);
 
-extern int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card);
+extern int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev);
 
 /* Access SDIO address space (e.g. CCCR) using CMD52 (single-byte interface).
  *   fn:   function number
@@ -179,17 +178,17 @@ extern int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card);
  *   data: data byte to write
  *   err:  pointer to error code (or NULL)
  */
-extern u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_card *card, uint func,
+extern u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint func,
 				u32 addr, int *err);
-extern void brcmf_sdcard_cfg_write(struct brcmf_sdio_card *card, uint func,
+extern void brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint func,
 				   u32 addr, u8 data, int *err);
 
 /* Read/Write 4bytes from/to cfg space */
 extern u32
-brcmf_sdcard_cfg_read_word(struct brcmf_sdio_card *card, uint fnc_num,
+brcmf_sdcard_cfg_read_word(struct brcmf_sdio_dev *sdiodev, uint fnc_num,
 			   u32 addr, int *err);
 
-extern void brcmf_sdcard_cfg_write_word(struct brcmf_sdio_card *card,
+extern void brcmf_sdcard_cfg_write_word(struct brcmf_sdio_dev *sdiodev,
 					uint fnc_num, u32 addr,
 					u32 data, int *err);
 
@@ -200,7 +199,7 @@ extern void brcmf_sdcard_cfg_write_word(struct brcmf_sdio_card *card,
  * Internally, this routine uses the values from the cis base regs (0x9-0xB)
  * to form an SDIO-space address to read the data from.
  */
-extern int brcmf_sdcard_cis_read(struct brcmf_sdio_card *card, uint func,
+extern int brcmf_sdcard_cis_read(struct brcmf_sdio_dev *sdiodev, uint func,
 				 u8 *cis, uint length);
 
 /* Synchronous access to device (client) core registers via CMD53 to F1.
@@ -209,14 +208,14 @@ extern int brcmf_sdcard_cis_read(struct brcmf_sdio_card *card, uint func,
  *   data: data for register write
  */
 extern u32
-brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size);
+brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size);
 
 extern u32
-brcmf_sdcard_reg_write(struct brcmf_sdio_card *card, u32 addr, uint size,
+brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size,
 		       u32 data);
 
 /* Indicate if last reg read/write failed */
-extern bool brcmf_sdcard_regfail(struct brcmf_sdio_card *card);
+extern bool brcmf_sdcard_regfail(struct brcmf_sdio_dev *sdiodev);
 
 /* Buffer transfer to/from device (client) core via cmd53.
  *   fn:       function number
@@ -231,13 +230,13 @@ extern bool brcmf_sdcard_regfail(struct brcmf_sdio_card *card);
  * NOTE: Async operation is not currently supported.
  */
 extern int
-brcmf_sdcard_send_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
+brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, u8 *buf, uint nbytes, void *pkt,
 		      void (*complete)(void *handle, int status,
 				       bool sync_waiting),
 		      void *handle);
 extern int
-brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
+brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt,
 		      void (*complete)(void *handle, int status,
 				       bool sync_waiting),
@@ -262,16 +261,16 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
  *   nbytes:   number of bytes to transfer to/from buf
  * Returns 0 or error code.
  */
-extern int brcmf_sdcard_rwdata(struct brcmf_sdio_card *card, uint rw, u32 addr,
-			       u8 *buf, uint nbytes);
+extern int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw,
+			       u32 addr, u8 *buf, uint nbytes);
 
 /* Issue an abort to the specified function */
-extern int brcmf_sdcard_abort(struct brcmf_sdio_card *card, uint fn);
+extern int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
 
 /* Miscellaneous knob tweaker. */
-extern int brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
-				 void *params, int plen, void *arg, int len,
-				 bool set);
+extern int brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev,
+				 const char *name, void *params, int plen,
+				 void *arg, int len, bool set);
 
 /* helper functions */
 
@@ -286,7 +285,7 @@ extern int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
 extern int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev);
 
 /* Function to return current window addr */
-extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card);
+extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev);
 
 /* Allocate/init/free per-OS private data */
 extern int  brcmf_sdioh_osinit(struct sdioh_info *sd);
@@ -355,4 +354,7 @@ extern uint sd_f2_blocksize;
 
 extern struct brcmf_sdmmc_instance *gInstance;
 
+extern void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
+				u32 regsva, struct brcmf_sdio_dev *sdiodev);
+extern void brcmf_sdbrcm_disconnect(void *ptr);
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.4.1


