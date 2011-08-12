Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4840 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab1HLNfR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/14] staging: brcm80211: remove struct sdioh_info from
 brcmfmac
Date: Fri, 12 Aug 2011 15:34:50 +0200
Message-ID: <1313156101-16817-4-git-send-email-arend@broadcom.com> (sfid-20110812_153531_799624_43B9CA9F)
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use brcmf_sdio_dev as the unified structure to store information
of device.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   35 ++---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  186 +++++++++------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |   59 +++-----
 3 files changed, 115 insertions(+), 165 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index c9893e9..6a9ac1d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -49,18 +49,18 @@ int
 brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
 		void *params, int plen, void *arg, int len, bool set)
 {
-	return brcmf_sdioh_iovar_op(sdiodev->sdioh, name, params, plen, arg,
+	return brcmf_sdioh_iovar_op(sdiodev, name, params, plen, arg,
 				    len, set);
 }
 
 int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
 {
-	return brcmf_sdioh_interrupt_register(sdiodev->sdioh);
+	return brcmf_sdioh_interrupt_register();
 }
 
 int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev)
 {
-	return brcmf_sdioh_interrupt_deregister(sdiodev->sdioh);
+	return brcmf_sdioh_interrupt_deregister();
 }
 
 u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
@@ -74,7 +74,7 @@ u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 		if (retry)	/* wait for 1 ms till bus get settled down */
 			udelay(1000);
 		status =
-		    brcmf_sdioh_cfg_read(sdiodev->sdioh, fnc_num, addr,
+		    brcmf_sdioh_cfg_read(sdiodev, fnc_num, addr,
 				   (u8 *) &data);
 	} while (status != 0
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
@@ -98,7 +98,7 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 		if (retry)	/* wait for 1 ms till bus get settled down */
 			udelay(1000);
 		status =
-		    brcmf_sdioh_cfg_write(sdiodev->sdioh, fnc_num, addr,
+		    brcmf_sdioh_cfg_write(sdiodev, fnc_num, addr,
 				    (u8 *) &data);
 	} while (status != 0
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
@@ -119,7 +119,7 @@ int brcmf_sdcard_cis_read(struct brcmf_sdio_dev *sdiodev, uint func, u8 * cis,
 	bool ascii = func & ~0xf;
 	func &= 0x7;
 
-	status = brcmf_sdioh_cis_read(sdiodev->sdioh, func, cis, length);
+	status = brcmf_sdioh_cis_read(sdiodev, func, cis, length);
 
 	if (ascii) {
 		/* Move binary bits to tmp and format them
@@ -181,7 +181,7 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size)
 	if (size == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = brcmf_sdioh_request_word(sdiodev->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	status = brcmf_sdioh_request_word(sdiodev, SDIOH_CMD_TYPE_NORMAL,
 				    SDIOH_READ, SDIO_FUNC_1, addr, &word, size);
 
 	sdiodev->regfail = (status != 0);
@@ -231,7 +231,7 @@ u32 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size,
 	if (size == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 	status =
-	    brcmf_sdioh_request_word(sdiodev->sdioh, SDIOH_CMD_TYPE_NORMAL,
+	    brcmf_sdioh_request_word(sdiodev, SDIOH_CMD_TYPE_NORMAL,
 			       SDIOH_WRITE, SDIO_FUNC_1, addr, &data, size);
 	sdiodev->regfail = (status != 0);
 
@@ -284,7 +284,7 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	status = brcmf_sdioh_request_buffer(sdiodev->sdioh, SDIOH_DATA_PIO,
+	status = brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_PIO,
 		incr_fix, SDIOH_READ, fn, addr, width, nbytes, buf, pkt);
 
 	return status;
@@ -324,7 +324,7 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return brcmf_sdioh_request_buffer(sdiodev->sdioh, SDIOH_DATA_PIO,
+	return brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_PIO,
 		incr_fix, SDIOH_WRITE, fn, addr, width, nbytes, buf, pkt);
 }
 
@@ -334,14 +334,14 @@ int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return brcmf_sdioh_request_buffer(sdiodev->sdioh, SDIOH_DATA_PIO,
+	return brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_PIO,
 		SDIOH_DATA_INC, (rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
 		addr, 4, nbytes, buf, NULL);
 }
 
 int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 {
-	return brcmf_sdioh_abort(sdiodev->sdioh, fn);
+	return brcmf_sdioh_abort(sdiodev, fn);
 }
 
 u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev)
@@ -354,11 +354,9 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	u32 regs = 0;
 	int ret = 0;
 
-	sdiodev->sdioh = brcmf_sdioh_attach((void *)0);
-	if (!sdiodev->sdioh) {
-		ret = -ENODEV;
+	ret = brcmf_sdioh_attach(sdiodev);
+	if (ret)
 		goto out;
-	}
 
 	regs = SI_ENUM_BASE;
 
@@ -388,10 +386,7 @@ int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
 		sdiodev->bus = NULL;
 	}
 
-	if (sdiodev->sdioh) {
-		brcmf_sdioh_detach(sdiodev->sdioh);
-		sdiodev->sdioh = NULL;
-	}
+	brcmf_sdioh_detach(sdiodev);
 
 	sdiodev->sbwad = 0;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index a2fba4f..877428c 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -46,7 +46,7 @@
 
 static void brcmf_sdioh_irqhandler(struct sdio_func *func);
 static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func);
-static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr);
+static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr);
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
 				const struct sdio_device_id *id);
 static void brcmf_ops_sdio_remove(struct sdio_func *func);
@@ -106,10 +106,10 @@ DECLARE_WAIT_QUEUE_HEAD(sdioh_request_buffer_wait);
 #endif		/* CONFIG_PM_SLEEP */
 
 static int
-brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
+brcmf_sdioh_card_regread(struct brcmf_sdio_dev *sdiodev, int func, u32 regaddr,
 			 int regsize, u32 *data);
 
-static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
+static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 {
 	int err_ret;
 	u32 fbraddr;
@@ -118,24 +118,20 @@ static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 	BRCMF_TRACE(("%s\n", __func__));
 
 	/* Get the Card's common CIS address */
-	sd->com_cis_ptr = brcmf_sdioh_get_cisaddr(sd, SDIO_CCCR_CIS);
-	sd->func_cis_ptr[0] = sd->com_cis_ptr;
+	sdiodev->func_cis_ptr[0] = brcmf_sdioh_get_cisaddr(sdiodev,
+							   SDIO_CCCR_CIS);
 	BRCMF_INFO(("%s: Card's Common CIS Ptr = 0x%x\n", __func__,
-		 sd->com_cis_ptr));
+		 sdiodev->func_cis_ptr[0]));
 
 	/* Get the Card's function CIS (for each function) */
 	for (fbraddr = SDIO_FBR_BASE(1), func = 1;
-	     func <= sd->num_funcs; func++, fbraddr += SDIOD_FBR_SIZE) {
-		sd->func_cis_ptr[func] =
-		    brcmf_sdioh_get_cisaddr(sd, SDIO_FBR_CIS + fbraddr);
+	     func <= sdiodev->num_funcs; func++, fbraddr += SDIOD_FBR_SIZE) {
+		sdiodev->func_cis_ptr[func] =
+		    brcmf_sdioh_get_cisaddr(sdiodev, SDIO_FBR_CIS + fbraddr);
 		BRCMF_INFO(("%s: Function %d CIS Ptr = 0x%x\n", __func__, func,
-			 sd->func_cis_ptr[func]));
+			 sdiodev->func_cis_ptr[func]));
 	}
 
-	sd->func_cis_ptr[0] = sd->com_cis_ptr;
-	BRCMF_INFO(("%s: Card's Common CIS Ptr = 0x%x\n", __func__,
-		 sd->com_cis_ptr));
-
 	/* Enable Function 1 */
 	sdio_claim_host(gInstance->func[1]);
 	err_ret = sdio_enable_func(gInstance->func[1]);
@@ -150,82 +146,66 @@ static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 /*
  *	Public entry points & extern's
  */
-struct sdioh_info *brcmf_sdioh_attach(void *bar0)
+int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 {
-	struct sdioh_info *sd;
-	int err_ret;
+	int err_ret = 0;
 
 	BRCMF_TRACE(("%s\n", __func__));
 
 	if (gInstance == NULL) {
 		BRCMF_ERROR(("%s: SDIO Device not present\n", __func__));
-		return NULL;
-	}
-
-	sd = kzalloc(sizeof(struct sdioh_info), GFP_ATOMIC);
-	if (sd == NULL) {
-		BRCMF_ERROR(("sdioh_attach: out of memory\n"));
-		return NULL;
+		err_ret = -ENODEV;
+		goto out;
 	}
 
-	sd->num_funcs = 2;
-
-	gInstance->sd = sd;
+	sdiodev->num_funcs = 2;
 
-	/* Claim host controller */
 	sdio_claim_host(gInstance->func[1]);
-
 	err_ret = sdio_set_block_size(gInstance->func[1], 64);
-	if (err_ret)
-		BRCMF_ERROR(("%s: Failed to set F1 blocksize\n", __func__));
-
-	/* Release host controller F1 */
 	sdio_release_host(gInstance->func[1]);
+	if (err_ret) {
+		BRCMF_ERROR(("%s: Failed to set F1 blocksize\n", __func__));
+		goto out;
+	}
 
 	if (gInstance->func[2]) {
-		/* Claim host controller F2 */
 		sdio_claim_host(gInstance->func[2]);
-
 		err_ret =
 		    sdio_set_block_size(gInstance->func[2], sd_f2_blocksize);
-		if (err_ret)
+		sdio_release_host(gInstance->func[2]);
+		if (err_ret) {
 			BRCMF_ERROR(("%s: Failed to set F2 blocksize"
 				" to %d\n", __func__, sd_f2_blocksize));
-
-		/* Release host controller F2 */
-		sdio_release_host(gInstance->func[2]);
+			goto out;
+		}
 	}
 
-	brcmf_sdioh_enablefuncs(sd);
+	brcmf_sdioh_enablefuncs(sdiodev);
 
+out:
 	BRCMF_TRACE(("%s: Done\n", __func__));
-	return sd;
+	return err_ret;
 }
 
-extern int brcmf_sdioh_detach(struct sdioh_info *sd)
+void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
 {
 	BRCMF_TRACE(("%s\n", __func__));
 
-	if (sd) {
+	/* Disable Function 2 */
+	sdio_claim_host(gInstance->func[2]);
+	sdio_disable_func(gInstance->func[2]);
+	sdio_release_host(gInstance->func[2]);
 
-		/* Disable Function 2 */
-		sdio_claim_host(gInstance->func[2]);
-		sdio_disable_func(gInstance->func[2]);
-		sdio_release_host(gInstance->func[2]);
-
-		/* Disable Function 1 */
-		sdio_claim_host(gInstance->func[1]);
-		sdio_disable_func(gInstance->func[1]);
-		sdio_release_host(gInstance->func[1]);
+	/* Disable Function 1 */
+	sdio_claim_host(gInstance->func[1]);
+	sdio_disable_func(gInstance->func[1]);
+	sdio_release_host(gInstance->func[1]);
 
-		kfree(sd);
-	}
-	return 0;
 }
 
 /* Configure callback to client when we receive client interrupt */
 extern int
-brcmf_sdioh_interrupt_register(struct sdioh_info *sd)
+brcmf_sdioh_interrupt_register(void)
 {
 	BRCMF_TRACE(("%s: Entering\n", __func__));
 
@@ -245,7 +225,7 @@ brcmf_sdioh_interrupt_register(struct sdioh_info *sd)
 	return 0;
 }
 
-extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
+extern int brcmf_sdioh_interrupt_deregister(void)
 {
 	BRCMF_TRACE(("%s: Entering\n", __func__));
 
@@ -270,14 +250,12 @@ extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 /* IOVar table */
 enum {
 	IOV_MSGLEVEL = 1,
-	IOV_NUMINTS,
 	IOV_DEVREG,
 	IOV_HCIREGS,
 	IOV_RXCHAIN
 };
 
 const struct brcmu_iovar sdioh_iovars[] = {
-	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
 	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
 	,
 	{"sd_rxchain", IOV_RXCHAIN, 0, IOVT_BOOL, 0}
@@ -286,7 +264,7 @@ const struct brcmu_iovar sdioh_iovars[] = {
 };
 
 int
-brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
+brcmf_sdioh_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
 		     void *params, int plen, void *arg, int len, bool set)
 {
 	const struct brcmu_iovar *vi = NULL;
@@ -345,11 +323,6 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 		memcpy(arg, &int_val, val_size);
 		break;
 
-	case IOV_GVAL(IOV_NUMINTS):
-		int_val = (s32) si->intrcount;
-		memcpy(arg, &int_val, val_size);
-		break;
-
 	case IOV_GVAL(IOV_DEVREG):
 		{
 			struct brcmf_sdreg *sd_ptr =
@@ -357,7 +330,7 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 			u8 data = 0;
 
 			if (brcmf_sdioh_cfg_read
-			    (si, sd_ptr->func, sd_ptr->offset, &data)) {
+			    (sdiodev, sd_ptr->func, sd_ptr->offset, &data)) {
 				bcmerror = -EIO;
 				break;
 			}
@@ -374,7 +347,7 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 			u8 data = (u8) sd_ptr->value;
 
 			if (brcmf_sdioh_cfg_write
-			    (si, sd_ptr->func, sd_ptr->offset, &data)) {
+			    (sdiodev, sd_ptr->func, sd_ptr->offset, &data)) {
 				bcmerror = -EIO;
 				break;
 			}
@@ -391,32 +364,36 @@ exit:
 }
 
 extern int
-brcmf_sdioh_cfg_read(struct sdioh_info *sd, uint fnc_num, u32 addr, u8 *data)
+brcmf_sdioh_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
+		     u8 *data)
 {
 	int status;
 	/* No lock needed since brcmf_sdioh_request_byte does locking */
-	status = brcmf_sdioh_request_byte(sd, SDIOH_READ, fnc_num, addr, data);
+	status = brcmf_sdioh_request_byte(sdiodev, SDIOH_READ, fnc_num,
+					  addr, data);
 	return status;
 }
 
 extern int
-brcmf_sdioh_cfg_write(struct sdioh_info *sd, uint fnc_num, u32 addr, u8 *data)
+brcmf_sdioh_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
+		      u8 *data)
 {
 	/* No lock needed since brcmf_sdioh_request_byte does locking */
 	int status;
-	status = brcmf_sdioh_request_byte(sd, SDIOH_WRITE, fnc_num, addr, data);
+	status = brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, fnc_num,
+					  addr, data);
 	return status;
 }
 
-static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr)
+static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 {
 	/* read 24 bits and return valid 17 bit addr */
 	int i;
 	u32 scratch, regdata;
 	u8 *ptr = (u8 *)&scratch;
 	for (i = 0; i < 3; i++) {
-		if ((brcmf_sdioh_card_regread(sd, 0, regaddr, 1, &regdata)) !=
-		    SUCCESS)
+		if ((brcmf_sdioh_card_regread(sdiodev, 0, regaddr, 1,
+				&regdata)) != SUCCESS)
 			BRCMF_ERROR(("%s: Can't read!\n", __func__));
 
 		*ptr++ = (u8) regdata;
@@ -430,7 +407,8 @@ static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr)
 }
 
 extern int
-brcmf_sdioh_cis_read(struct sdioh_info *sd, uint func, u8 *cisd, u32 length)
+brcmf_sdioh_cis_read(struct brcmf_sdio_dev *sdiodev, uint func,
+		     u8 *cisd, u32 length)
 {
 	u32 count;
 	int offset;
@@ -439,18 +417,18 @@ brcmf_sdioh_cis_read(struct sdioh_info *sd, uint func, u8 *cisd, u32 length)
 
 	BRCMF_TRACE(("%s: Func = %d\n", __func__, func));
 
-	if (!sd->func_cis_ptr[func]) {
+	if (!sdiodev->func_cis_ptr[func]) {
 		memset(cis, 0, length);
 		BRCMF_ERROR(("%s: no func_cis_ptr[%d]\n", __func__, func));
 		return -ENOTSUPP;
 	}
 
 	BRCMF_ERROR(("%s: func_cis_ptr[%d]=0x%04x\n", __func__, func,
-		sd->func_cis_ptr[func]));
+		sdiodev->func_cis_ptr[func]));
 
 	for (count = 0; count < length; count++) {
-		offset = sd->func_cis_ptr[func] + count;
-		if (brcmf_sdioh_card_regread(sd, 0, offset, 1, &foo) < 0) {
+		offset = sdiodev->func_cis_ptr[func] + count;
+		if (brcmf_sdioh_card_regread(sdiodev, 0, offset, 1, &foo) < 0) {
 			BRCMF_ERROR(("%s: regread failed: Can't read CIS\n",
 				__func__));
 			return -EIO;
@@ -464,7 +442,7 @@ brcmf_sdioh_cis_read(struct sdioh_info *sd, uint func, u8 *cisd, u32 length)
 }
 
 extern int
-brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
+brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 			 uint regaddr, u8 *byte)
 {
 	int err_ret;
@@ -566,7 +544,7 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 }
 
 extern int
-brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
+brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type, uint rw,
 			 uint func, uint addr, u32 *word, uint nbytes)
 {
 	int err_ret = -EIO;
@@ -618,8 +596,9 @@ brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 }
 
 static int
-brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
-			   uint func, uint addr, struct sk_buff *pkt)
+brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
+			   uint write, uint func, uint addr,
+			   struct sk_buff *pkt)
 {
 	bool fifo = (fix_inc == SDIOH_DATA_FIX);
 	u32 SGCount = 0;
@@ -698,9 +677,10 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
  *
  */
 extern int
-brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
-			   uint write, uint func, uint addr, uint reg_width,
-			   uint buflen_u, u8 *buffer, struct sk_buff *pkt)
+brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
+			   uint fix_inc, uint write, uint func, uint addr,
+			   uint reg_width, uint buflen_u, u8 *buffer,
+			   struct sk_buff *pkt)
 {
 	int Status;
 	struct sk_buff *mypkt = NULL;
@@ -724,8 +704,8 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 		if (write)
 			memcpy(mypkt->data, buffer, buflen_u);
 
-		Status = brcmf_sdioh_request_packet(sd, fix_inc, write, func,
-						    addr, mypkt);
+		Status = brcmf_sdioh_request_packet(sdiodev, fix_inc, write,
+						    func, addr, mypkt);
 
 		/* For a read, copy the packet data back to the buffer. */
 		if (!write)
@@ -750,8 +730,8 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 		if (write)
 			memcpy(mypkt->data, pkt->data, pkt->len);
 
-		Status = brcmf_sdioh_request_packet(sd, fix_inc, write, func,
-						    addr, mypkt);
+		Status = brcmf_sdioh_request_packet(sdiodev, fix_inc, write,
+						    func, addr, mypkt);
 
 		/* For a read, copy the packet data back to the buffer. */
 		if (!write)
@@ -762,22 +742,22 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 				 it is aligned. */
 		BRCMF_DATA(("%s: Aligned %s Packet, direct DMA\n",
 			 __func__, write ? "Tx" : "Rx"));
-		Status = brcmf_sdioh_request_packet(sd, fix_inc, write, func,
-						    addr, pkt);
+		Status = brcmf_sdioh_request_packet(sdiodev, fix_inc, write,
+						    func, addr, pkt);
 	}
 
 	return Status;
 }
 
 /* this function performs "abort" for both of host & device */
-extern int brcmf_sdioh_abort(struct sdioh_info *sd, uint func)
+extern int brcmf_sdioh_abort(struct brcmf_sdio_dev *sdiodev, uint func)
 {
 	char t_func = (char)func;
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* issue abort cmd52 command through F0 */
-	brcmf_sdioh_request_byte(sd, SDIOH_WRITE, SDIO_FUNC_0, SDIO_CCCR_ABORT,
-			   &t_func);
+	brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, SDIO_FUNC_0,
+				 SDIO_CCCR_ABORT, &t_func);
 
 	BRCMF_TRACE(("%s: Exit\n", __func__));
 	return 0;
@@ -785,20 +765,21 @@ extern int brcmf_sdioh_abort(struct sdioh_info *sd, uint func)
 
 /* Read client card reg */
 int
-brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
+brcmf_sdioh_card_regread(struct brcmf_sdio_dev *sdiodev, int func, u32 regaddr,
 			 int regsize, u32 *data)
 {
 
 	if ((func == 0) || (regsize == 1)) {
 		u8 temp = 0;
 
-		brcmf_sdioh_request_byte(sd, SDIOH_READ, func, regaddr, &temp);
+		brcmf_sdioh_request_byte(sdiodev, SDIOH_READ, func, regaddr,
+					 &temp);
 		*data = temp;
 		*data &= 0xff;
 		BRCMF_DATA(("%s: byte read data=0x%02x\n", __func__, *data));
 	} else {
-		brcmf_sdioh_request_word(sd, 0, SDIOH_READ, func, regaddr, data,
-				   regsize);
+		brcmf_sdioh_request_word(sdiodev, 0, SDIOH_READ, func, regaddr,
+					 data, regsize);
 		if (regsize == 2)
 			*data &= 0xffff;
 
@@ -810,15 +791,12 @@ brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
 
 static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
-	struct sdioh_info *sd;
 	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
 
 	BRCMF_TRACE(("brcmf: ***IRQHandler\n"));
-	sd = gInstance->sd;
 
 	sdio_release_host(gInstance->func[0]);
 
-	sd->intrcount++;
 	brcmf_sdbrcm_isr(sdiodev->bus);
 
 	sdio_claim_host(gInstance->func[0]);
@@ -827,11 +805,7 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 /* interrupt handler for F2 (dummy handler) */
 static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func)
 {
-	struct sdioh_info *sd;
-
 	BRCMF_TRACE(("brcmf: ***IRQHandlerF2\n"));
-
-	sd = gInstance->sd;
 }
 
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index c61a186..dc95c4d 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -122,23 +122,7 @@ struct brcmf_sdreg {
 	int value;
 };
 
-struct sdioh_info {
-	struct osl_info *osh;		/* osh handler */
-
-	uint irq;		/* Client irq */
-	int intrcount;		/* Client interrupts */
-	bool sd_blockmode;	/* sd_blockmode == false => 64 Byte Cmd 53s. */
-	/*  Must be on for sd_multiblock to be effective */
-	u8 num_funcs;	/* Supported funcs on client */
-	u32 com_cis_ptr;
-	u32 func_cis_ptr[SDIOD_MAX_IOFUNCS];
-	uint max_dma_len;
-	/* DMA Descriptors supported by this controller. */
-	uint max_dma_descriptors;
-};
-
 struct brcmf_sdmmc_instance {
-	struct sdioh_info *sd;
 	struct sdio_func *func[SDIOD_MAX_IOFUNCS];
 	u32 host_claimed;
 	atomic_t suspend;	/* suspend flag */
@@ -147,7 +131,8 @@ struct brcmf_sdmmc_instance {
 struct brcmf_sdio_dev {
 	struct sdio_func *func1;
 	struct sdio_func *func2;
-	void *sdioh;			/* sdioh handler */
+	u8 num_funcs;			/* Supported funcs on client */
+	u32 func_cis_ptr[SDIOD_MAX_IOFUNCS];
 	u32 sbwad;			/* Save backplane window address */
 	bool regfail;			/* status of last reg_r/w call */
 	void *bus;
@@ -250,10 +235,6 @@ extern int brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev,
 				 const char *name, void *params, int plen,
 				 void *arg, int len, bool set);
 
-/* helper functions */
-
-struct sdioh_info;
-
 /* platform specific/high level functions */
 extern int brcmf_sdio_function_init(void);
 extern int brcmf_sdio_register(void);
@@ -269,47 +250,47 @@ extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev);
  *  The handler shall be provided by all subsequent calls. No local cache
  *  cfghdl points to the starting address of pci device mapped memory
  */
-extern struct sdioh_info *brcmf_sdioh_attach(void *cfghdl);
-extern int brcmf_sdioh_detach(struct sdioh_info *si);
+extern int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev);
+extern void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev);
 
 extern int
-brcmf_sdioh_interrupt_register(struct sdioh_info *si);
+brcmf_sdioh_interrupt_register(void);
 
-extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *si);
+extern int brcmf_sdioh_interrupt_deregister(void);
 
 /* read or write one byte using cmd52 */
-extern int
-brcmf_sdioh_request_byte(struct sdioh_info *si, uint rw, uint fnc, uint addr,
-			 u8 *byte);
+extern int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw,
+				    uint fnc, uint addr, u8 *byte);
 
 /* read or write 2/4 bytes using cmd53 */
 extern int
-brcmf_sdioh_request_word(struct sdioh_info *si, uint cmd_type,
+brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type,
 			 uint rw, uint fnc, uint addr,
 			 u32 *word, uint nbyte);
 
 /* read or write any buffer using cmd53 */
 extern int
-brcmf_sdioh_request_buffer(struct sdioh_info *si, uint pio_dma,
+brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
 			   uint fix_inc, uint rw, uint fnc_num,
 			   u32 addr, uint regwidth,
 			   u32 buflen, u8 *buffer, struct sk_buff *pkt);
 
 /* get cis data */
-extern int
-brcmf_sdioh_cis_read(struct sdioh_info *si, uint fuc, u8 *cis, u32 length);
+extern int brcmf_sdioh_cis_read(struct brcmf_sdio_dev *sdiodev, uint fuc,
+				u8 *cis, u32 length);
 
-extern int
-brcmf_sdioh_cfg_read(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
-extern int
-brcmf_sdioh_cfg_write(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
+extern int brcmf_sdioh_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fuc,
+				u32 addr, u8 *data);
+extern int brcmf_sdioh_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fuc,
+				 u32 addr, u8 *data);
 
 /* handle iovars */
-extern int brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
-			  void *params, int plen, void *arg, int len, bool set);
+extern int brcmf_sdioh_iovar_op(struct brcmf_sdio_dev *sdiodev,
+				const char *name, void *params, int plen,
+				void *arg, int len, bool set);
 
 /* Issue abort to the specified function and clear controller as needed */
-extern int brcmf_sdioh_abort(struct sdioh_info *si, uint fnc);
+extern int brcmf_sdioh_abort(struct brcmf_sdio_dev *sdiodev, uint fnc);
 
 /* Watchdog timer interface for pm ops */
 extern void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev,
-- 
1.7.4.1


