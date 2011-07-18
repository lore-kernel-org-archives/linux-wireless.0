Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4199 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab1GROaX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 10:30:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Franky Lin" <frankyl@broadcom.com>,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/19] staging: brcm80211: get rid of sd debug message
 macro in fullmac
Date: Mon, 18 Jul 2011 16:29:59 +0200
Message-ID: <1310999405-10062-14-git-send-email-arend@broadcom.com> (sfid-20110718_163116_120647_158D3777)
In-Reply-To: <1310999405-10062-1-git-send-email-arend@broadcom.com>
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use BRCMF_* instead of sd_* as debug message interface

Cc: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    2 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  222 ++++++++-------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    1 -
 3 files changed, 82 insertions(+), 143 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 916d41f..310d4fd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -98,8 +98,6 @@ static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
 
 /* Module parameters specific to each host-controller driver */
 
-module_param(sd_msglevel, uint, 0);
-
 module_param(sd_f2_blocksize, int, 0);
 
 struct brcmf_sdio_card*
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 846b6be..4ffd934 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -46,56 +46,6 @@
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
 #endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
 
-/* Common msglevel constants */
-#define SDH_ERROR_VAL		0x0001	/* Error */
-#define SDH_TRACE_VAL		0x0002	/* Trace */
-#define SDH_INFO_VAL		0x0004	/* Info */
-#define SDH_DEBUG_VAL		0x0008	/* Debug */
-#define SDH_DATA_VAL		0x0010	/* Data */
-#define SDH_CTRL_VAL		0x0020	/* Control Regs */
-#define SDH_LOG_VAL		0x0040	/* Enable bcmlog */
-#define SDH_DMA_VAL		0x0080	/* DMA */
-
-#ifdef BCMDBG
-#define sd_err(x)	\
-	do { \
-		if ((sd_msglevel & SDH_ERROR_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define sd_trace(x)	\
-	do { \
-		if ((sd_msglevel & SDH_TRACE_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define sd_info(x)	\
-	do { \
-		if ((sd_msglevel & SDH_INFO_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define sd_debug(x)	\
-	do { \
-		if ((sd_msglevel & SDH_DEBUG_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define sd_data(x)	\
-	do { \
-		if ((sd_msglevel & SDH_DATA_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define sd_ctrl(x)	\
-	do { \
-		if ((sd_msglevel & SDH_CTRL_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#else
-#define sd_err(x)
-#define sd_trace(x)
-#define sd_info(x)
-#define sd_debug(x)
-#define sd_data(x)
-#define sd_ctrl(x)
-#endif
-
 struct sdos_info {
 	struct sdioh_info *sd;
 	spinlock_t lock;
@@ -115,8 +65,6 @@ static int brcmf_sdio_resume(struct device *dev);
 
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
-uint sd_msglevel = 0x01;
-
 struct brcmf_sdmmc_instance *gInstance;
 static atomic_t brcmf_mmc_suspend;
 
@@ -177,12 +125,12 @@ static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 	u32 fbraddr;
 	u8 func;
 
-	sd_trace(("%s\n", __func__));
+	BRCMF_TRACE(("%s\n", __func__));
 
 	/* Get the Card's common CIS address */
 	sd->com_cis_ptr = brcmf_sdioh_get_cisaddr(sd, SDIO_CCCR_CIS);
 	sd->func_cis_ptr[0] = sd->com_cis_ptr;
-	sd_info(("%s: Card's Common CIS Ptr = 0x%x\n", __func__,
+	BRCMF_INFO(("%s: Card's Common CIS Ptr = 0x%x\n", __func__,
 		 sd->com_cis_ptr));
 
 	/* Get the Card's function CIS (for each function) */
@@ -190,12 +138,12 @@ static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 	     func <= sd->num_funcs; func++, fbraddr += SDIOD_FBR_SIZE) {
 		sd->func_cis_ptr[func] =
 		    brcmf_sdioh_get_cisaddr(sd, SDIO_FBR_CIS + fbraddr);
-		sd_info(("%s: Function %d CIS Ptr = 0x%x\n", __func__, func,
+		BRCMF_INFO(("%s: Function %d CIS Ptr = 0x%x\n", __func__, func,
 			 sd->func_cis_ptr[func]));
 	}
 
 	sd->func_cis_ptr[0] = sd->com_cis_ptr;
-	sd_info(("%s: Card's Common CIS Ptr = 0x%x\n", __func__,
+	BRCMF_INFO(("%s: Card's Common CIS Ptr = 0x%x\n", __func__,
 		 sd->com_cis_ptr));
 
 	/* Enable Function 1 */
@@ -203,7 +151,7 @@ static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 	err_ret = sdio_enable_func(gInstance->func[1]);
 	sdio_release_host(gInstance->func[1]);
 	if (err_ret)
-		sd_err(("brcmf_sdioh_enablefuncs: Failed to enable F1 "
+		BRCMF_ERROR(("brcmf_sdioh_enablefuncs: Failed to enable F1 "
 			"Err: 0x%08x\n", err_ret));
 
 	return false;
@@ -217,20 +165,20 @@ struct sdioh_info *brcmf_sdioh_attach(void *bar0, uint irq)
 	struct sdioh_info *sd;
 	int err_ret;
 
-	sd_trace(("%s\n", __func__));
+	BRCMF_TRACE(("%s\n", __func__));
 
 	if (gInstance == NULL) {
-		sd_err(("%s: SDIO Device not present\n", __func__));
+		BRCMF_ERROR(("%s: SDIO Device not present\n", __func__));
 		return NULL;
 	}
 
 	sd = kzalloc(sizeof(struct sdioh_info), GFP_ATOMIC);
 	if (sd == NULL) {
-		sd_err(("sdioh_attach: out of memory\n"));
+		BRCMF_ERROR(("sdioh_attach: out of memory\n"));
 		return NULL;
 	}
 	if (brcmf_sdioh_osinit(sd) != 0) {
-		sd_err(("%s:sdioh_sdmmc_osinit() failed\n", __func__));
+		BRCMF_ERROR(("%s:sdioh_sdmmc_osinit() failed\n", __func__));
 		kfree(sd);
 		return NULL;
 	}
@@ -247,7 +195,7 @@ struct sdioh_info *brcmf_sdioh_attach(void *bar0, uint irq)
 	sd->client_block_size[1] = 64;
 	err_ret = sdio_set_block_size(gInstance->func[1], 64);
 	if (err_ret)
-		sd_err(("brcmf_sdioh_attach: Failed to set F1 blocksize\n"));
+		BRCMF_ERROR(("%s: Failed to set F1 blocksize\n", __func__));
 
 	/* Release host controller F1 */
 	sdio_release_host(gInstance->func[1]);
@@ -260,8 +208,8 @@ struct sdioh_info *brcmf_sdioh_attach(void *bar0, uint irq)
 		err_ret =
 		    sdio_set_block_size(gInstance->func[2], sd_f2_blocksize);
 		if (err_ret)
-			sd_err(("brcmf_sdioh_attach: Failed to set F2 blocksize"
-				" to %d\n", sd_f2_blocksize));
+			BRCMF_ERROR(("%s: Failed to set F2 blocksize"
+				" to %d\n", __func__, sd_f2_blocksize));
 
 		/* Release host controller F2 */
 		sdio_release_host(gInstance->func[2]);
@@ -269,13 +217,13 @@ struct sdioh_info *brcmf_sdioh_attach(void *bar0, uint irq)
 
 	brcmf_sdioh_enablefuncs(sd);
 
-	sd_trace(("%s: Done\n", __func__));
+	BRCMF_TRACE(("%s: Done\n", __func__));
 	return sd;
 }
 
 extern int brcmf_sdioh_detach(struct sdioh_info *sd)
 {
-	sd_trace(("%s\n", __func__));
+	BRCMF_TRACE(("%s\n", __func__));
 
 	if (sd) {
 
@@ -302,9 +250,9 @@ extern int
 brcmf_sdioh_interrupt_register(struct sdioh_info *sd, void (*fn)(void *),
 			       void *argh)
 {
-	sd_trace(("%s: Entering\n", __func__));
+	BRCMF_TRACE(("%s: Entering\n", __func__));
 	if (fn == NULL) {
-		sd_err(("%s: interrupt handler is NULL, not registering\n",
+		BRCMF_ERROR(("%s: interrupt handler is NULL, not registering\n",
 			__func__));
 		return -EINVAL;
 	}
@@ -331,7 +279,7 @@ brcmf_sdioh_interrupt_register(struct sdioh_info *sd, void (*fn)(void *),
 
 extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 {
-	sd_trace(("%s: Entering\n", __func__));
+	BRCMF_TRACE(("%s: Entering\n", __func__));
 
 	if (gInstance->func[1]) {
 		/* register and unmask irq */
@@ -367,7 +315,6 @@ enum {
 };
 
 const struct brcmu_iovar sdioh_iovars[] = {
-	{"sd_msglevel", IOV_MSGLEVEL, 0, IOVT_UINT32, 0},
 	{"sd_blocksize", IOV_BLOCKSIZE, 0, IOVT_UINT32, 0},/* ((fn << 16) |
 								 size) */
 	{"sd_ints", IOV_USEINTS, 0, IOVT_BOOL, 0},
@@ -401,7 +348,7 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 	if (!set && !(arg && len))
 		return -EINVAL;
 
-	sd_trace(("%s: Enter (%s %s)\n", __func__, (set ? "set" : "get"),
+	BRCMF_TRACE(("%s: Enter (%s %s)\n", __func__, (set ? "set" : "get"),
 		  name));
 
 	vi = brcmu_iovar_lookup(sdioh_iovars, name);
@@ -434,15 +381,6 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 
 	actionid = set ? IOV_SVAL(vi->varid) : IOV_GVAL(vi->varid);
 	switch (actionid) {
-	case IOV_GVAL(IOV_MSGLEVEL):
-		int_val = (s32) sd_msglevel;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_MSGLEVEL):
-		sd_msglevel = int_val;
-		break;
-
 	case IOV_GVAL(IOV_BLOCKSIZE):
 		if ((u32) int_val > si->num_funcs) {
 			bcmerror = -EINVAL;
@@ -580,7 +518,7 @@ static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr)
 	for (i = 0; i < 3; i++) {
 		if ((brcmf_sdioh_card_regread(sd, 0, regaddr, 1, &regdata)) !=
 		    SUCCESS)
-			sd_err(("%s: Can't read!\n", __func__));
+			BRCMF_ERROR(("%s: Can't read!\n", __func__));
 
 		*ptr++ = (u8) regdata;
 		regaddr++;
@@ -600,21 +538,21 @@ brcmf_sdioh_cis_read(struct sdioh_info *sd, uint func, u8 *cisd, u32 length)
 	u32 foo;
 	u8 *cis = cisd;
 
-	sd_trace(("%s: Func = %d\n", __func__, func));
+	BRCMF_TRACE(("%s: Func = %d\n", __func__, func));
 
 	if (!sd->func_cis_ptr[func]) {
 		memset(cis, 0, length);
-		sd_err(("%s: no func_cis_ptr[%d]\n", __func__, func));
+		BRCMF_ERROR(("%s: no func_cis_ptr[%d]\n", __func__, func));
 		return -ENOTSUPP;
 	}
 
-	sd_err(("%s: func_cis_ptr[%d]=0x%04x\n", __func__, func,
+	BRCMF_ERROR(("%s: func_cis_ptr[%d]=0x%04x\n", __func__, func,
 		sd->func_cis_ptr[func]));
 
 	for (count = 0; count < length; count++) {
 		offset = sd->func_cis_ptr[func] + count;
 		if (brcmf_sdioh_card_regread(sd, 0, offset, 1, &foo) < 0) {
-			sd_err(("%s: regread failed: Can't read CIS\n",
+			BRCMF_ERROR(("%s: regread failed: Can't read CIS\n",
 				__func__));
 			return -EIO;
 		}
@@ -632,7 +570,7 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 {
 	int err_ret;
 
-	sd_info(("%s: rw=%d, func=%d, addr=0x%05x\n", __func__, rw, func,
+	BRCMF_INFO(("%s: rw=%d, func=%d, addr=0x%05x\n", __func__, rw, func,
 		 regaddr));
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_byte_wait);
@@ -652,7 +590,8 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 						    sdio_enable_func
 						    (gInstance->func[2]);
 						if (err_ret)
-							sd_err(("request_byte: "
+							BRCMF_ERROR((
+								"request_byte: "
 								"enable F2 "
 								"failed:%d\n",
 								 err_ret));
@@ -662,7 +601,8 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 						    sdio_disable_func
 						    (gInstance->func[2]);
 						if (err_ret)
-							sd_err(("request_byte: "
+							BRCMF_ERROR((
+								"request_byte: "
 								"Disab F2 "
 								"failed:%d\n",
 								 err_ret));
@@ -683,7 +623,7 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 					    regaddr, &err_ret);
 				sdio_release_host(gInstance->func[func]);
 			} else if (regaddr < 0xF0) {
-				sd_err(("brcmf: F0 Wr:0x%02x: write "
+				BRCMF_ERROR(("brcmf: F0 Wr:0x%02x: write "
 					"disallowed\n", regaddr));
 			} else {
 				/* Claim host controller, perform F0 write,
@@ -719,7 +659,7 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 	}
 
 	if (err_ret)
-		sd_err(("brcmf: Failed to %s byte F%d:@0x%05x=%02x, "
+		BRCMF_ERROR(("brcmf: Failed to %s byte F%d:@0x%05x=%02x, "
 			"Err: %d\n", rw ? "Write" : "Read", func, regaddr,
 			*byte, err_ret));
 
@@ -733,11 +673,11 @@ brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 	int err_ret = -EIO;
 
 	if (func == 0) {
-		sd_err(("%s: Only CMD52 allowed to F0.\n", __func__));
+		BRCMF_ERROR(("%s: Only CMD52 allowed to F0.\n", __func__));
 		return -EINVAL;
 	}
 
-	sd_info(("%s: cmd_type=%d, rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
+	BRCMF_INFO(("%s: cmd_type=%d, rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
 		 __func__, cmd_type, rw, func, addr, nbytes));
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_word_wait);
@@ -753,7 +693,8 @@ brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 			sdio_writew(gInstance->func[func], (*word & 0xFFFF),
 				    addr, &err_ret);
 		else
-			sd_err(("%s: Invalid nbytes: %d\n", __func__, nbytes));
+			BRCMF_ERROR(("%s: Invalid nbytes: %d\n",
+				     __func__, nbytes));
 	} else {		/* CMD52 Read */
 		if (nbytes == 4)
 			*word =
@@ -763,14 +704,15 @@ brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 			    sdio_readw(gInstance->func[func], addr,
 				       &err_ret) & 0xFFFF;
 		else
-			sd_err(("%s: Invalid nbytes: %d\n", __func__, nbytes));
+			BRCMF_ERROR(("%s: Invalid nbytes: %d\n",
+				     __func__, nbytes));
 	}
 
 	/* Release host controller */
 	sdio_release_host(gInstance->func[func]);
 
 	if (err_ret)
-		sd_err(("brcmf: Failed to %s word, Err: 0x%08x\n",
+		BRCMF_ERROR(("brcmf: Failed to %s word, Err: 0x%08x\n",
 			rw ? "Write" : "Read", err_ret));
 
 	return err_ret;
@@ -786,7 +728,7 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 
 	struct sk_buff *pnext;
 
-	sd_trace(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_packet_wait);
 	BRCMF_PM_RESUME_RETURN_ERROR(-EIO);
@@ -817,15 +759,15 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 		}
 
 		if (err_ret) {
-			sd_err(("%s: %s FAILED %p[%d], addr=0x%05x, pkt_len=%d,"
-				 "ERR=0x%08x\n", __func__,
+			BRCMF_ERROR(("%s: %s FAILED %p[%d], addr=0x%05x, "
+				 "pkt_len=%d, ERR=0x%08x\n", __func__,
 				 (write) ? "TX" : "RX",
 				 pnext, SGCount, addr, pkt_len, err_ret));
 		} else {
-			sd_trace(("%s: %s xfr'd %p[%d], addr=0x%05x, len=%d\n",
-				  __func__,
-				  (write) ? "TX" : "RX",
-				  pnext, SGCount, addr, pkt_len));
+			BRCMF_TRACE(("%s: %s xfr'd %p[%d], addr=0x%05x, "
+				     "len=%d\n", __func__,
+				     (write) ? "TX" : "RX",
+				     pnext, SGCount, addr, pkt_len));
 		}
 
 		if (!fifo)
@@ -837,7 +779,7 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 	/* Release host controller */
 	sdio_release_host(gInstance->func[func]);
 
-	sd_trace(("%s: Exit\n", __func__));
+	BRCMF_TRACE(("%s: Exit\n", __func__));
 	return err_ret;
 }
 
@@ -864,18 +806,18 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 	int Status;
 	struct sk_buff *mypkt = NULL;
 
-	sd_trace(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_buffer_wait);
 	BRCMF_PM_RESUME_RETURN_ERROR(-EIO);
 	/* Case 1: we don't have a packet. */
 	if (pkt == NULL) {
-		sd_data(("%s: Creating new %s Packet, len=%d\n",
+		BRCMF_DATA(("%s: Creating new %s Packet, len=%d\n",
 			 __func__, write ? "TX" : "RX", buflen_u));
 		mypkt = brcmu_pkt_buf_get_skb(buflen_u);
 		if (!mypkt) {
-			sd_err(("%s: brcmu_pkt_buf_get_skb failed: len %d\n",
-				__func__, buflen_u));
+			BRCMF_ERROR(("%s: brcmu_pkt_buf_get_skb failed: "
+				     "len %d\n", __func__, buflen_u));
 			return -EIO;
 		}
 
@@ -896,12 +838,12 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 		 * Case 2: We have a packet, but it is unaligned.
 		 * In this case, we cannot have a chain (pkt->next == NULL)
 		 */
-		sd_data(("%s: Creating aligned %s Packet, len=%d\n",
+		BRCMF_DATA(("%s: Creating aligned %s Packet, len=%d\n",
 			 __func__, write ? "TX" : "RX", pkt->len));
 		mypkt = brcmu_pkt_buf_get_skb(pkt->len);
 		if (!mypkt) {
-			sd_err(("%s: brcmu_pkt_buf_get_skb failed: len %d\n",
-				__func__, pkt->len));
+			BRCMF_ERROR(("%s: brcmu_pkt_buf_get_skb failed: "
+				     "len %d\n", __func__, pkt->len));
 			return -EIO;
 		}
 
@@ -919,7 +861,7 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 		brcmu_pkt_buf_free_skb(mypkt);
 	} else {		/* case 3: We have a packet and
 				 it is aligned. */
-		sd_data(("%s: Aligned %s Packet, direct DMA\n",
+		BRCMF_DATA(("%s: Aligned %s Packet, direct DMA\n",
 			 __func__, write ? "Tx" : "Rx"));
 		Status = brcmf_sdioh_request_packet(sd, fix_inc, write, func,
 						    addr, pkt);
@@ -932,27 +874,27 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 extern int brcmf_sdioh_abort(struct sdioh_info *sd, uint func)
 {
 	char t_func = (char)func;
-	sd_trace(("%s: Enter\n", __func__));
+	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	/* issue abort cmd52 command through F0 */
 	brcmf_sdioh_request_byte(sd, SDIOH_WRITE, SDIO_FUNC_0, SDIO_CCCR_ABORT,
 			   &t_func);
 
-	sd_trace(("%s: Exit\n", __func__));
+	BRCMF_TRACE(("%s: Exit\n", __func__));
 	return 0;
 }
 
 /* Disable device interrupt */
 void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd)
 {
-	sd_trace(("%s: %d\n", __func__, sd->use_client_ints));
+	BRCMF_TRACE(("%s: %d\n", __func__, sd->use_client_ints));
 	sd->intmask &= ~CLIENT_INTR;
 }
 
 /* Enable device interrupt */
 void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd)
 {
-	sd_trace(("%s: %d\n", __func__, sd->use_client_ints));
+	BRCMF_TRACE(("%s: %d\n", __func__, sd->use_client_ints));
 	sd->intmask |= CLIENT_INTR;
 }
 
@@ -968,14 +910,14 @@ brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
 		brcmf_sdioh_request_byte(sd, SDIOH_READ, func, regaddr, &temp);
 		*data = temp;
 		*data &= 0xff;
-		sd_data(("%s: byte read data=0x%02x\n", __func__, *data));
+		BRCMF_DATA(("%s: byte read data=0x%02x\n", __func__, *data));
 	} else {
 		brcmf_sdioh_request_word(sd, 0, SDIOH_READ, func, regaddr, data,
 				   regsize);
 		if (regsize == 2)
 			*data &= 0xffff;
 
-		sd_data(("%s: word read data=0x%08x\n", __func__, *data));
+		BRCMF_DATA(("%s: word read data=0x%08x\n", __func__, *data));
 	}
 
 	return SUCCESS;
@@ -985,7 +927,7 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
 	struct sdioh_info *sd;
 
-	sd_trace(("brcmf: ***IRQHandler\n"));
+	BRCMF_TRACE(("brcmf: ***IRQHandler\n"));
 	sd = gInstance->sd;
 
 	sdio_release_host(gInstance->func[0]);
@@ -994,9 +936,9 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 		sd->intrcount++;
 		(sd->intr_handler) (sd->intr_handler_arg);
 	} else {
-		sd_err(("brcmf: ***IRQHandler\n"));
+		BRCMF_ERROR(("brcmf: ***IRQHandler\n"));
 
-		sd_err(("%s: Not ready for intr: enabled %d, handler %p\n",
+		BRCMF_ERROR(("%s: Not ready for intr: enabled %d, handler %p\n",
 			__func__, sd->client_intr_enabled, sd->intr_handler));
 	}
 
@@ -1008,7 +950,7 @@ static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func)
 {
 	struct sdioh_info *sd;
 
-	sd_trace(("brcmf: ***IRQHandlerF2\n"));
+	BRCMF_TRACE(("brcmf: ***IRQHandlerF2\n"));
 
 	sd = gInstance->sd;
 }
@@ -1018,11 +960,11 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 {
 	int ret = 0;
 	static struct sdio_func sdio_func_0;
-	sd_trace(("sdio_probe: %s Enter\n", __func__));
-	sd_trace(("sdio_probe: func->class=%x\n", func->class));
-	sd_trace(("sdio_vendor: 0x%04x\n", func->vendor));
-	sd_trace(("sdio_device: 0x%04x\n", func->device));
-	sd_trace(("Function#: 0x%04x\n", func->num));
+	BRCMF_TRACE(("sdio_probe: %s Enter\n", __func__));
+	BRCMF_TRACE(("sdio_probe: func->class=%x\n", func->class));
+	BRCMF_TRACE(("sdio_vendor: 0x%04x\n", func->vendor));
+	BRCMF_TRACE(("sdio_device: 0x%04x\n", func->device));
+	BRCMF_TRACE(("Function#: 0x%04x\n", func->num));
 
 	if (func->num == 1) {
 		sdio_func_0.num = 0;
@@ -1034,7 +976,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 
 	if (func->num == 2) {
 		brcmf_cfg80211_sdio_func(func);
-		sd_trace(("F2 found, calling brcmf_sdio_probe...\n"));
+		BRCMF_TRACE(("F2 found, calling brcmf_sdio_probe...\n"));
 		ret = brcmf_sdio_probe(&sdmmc_dev);
 	}
 
@@ -1043,14 +985,14 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 
 static void brcmf_ops_sdio_remove(struct sdio_func *func)
 {
-	sd_trace(("%s Enter\n", __func__));
-	sd_info(("func->class=%x\n", func->class));
-	sd_info(("sdio_vendor: 0x%04x\n", func->vendor));
-	sd_info(("sdio_device: 0x%04x\n", func->device));
-	sd_info(("Function#: 0x%04x\n", func->num));
+	BRCMF_TRACE(("%s Enter\n", __func__));
+	BRCMF_INFO(("func->class=%x\n", func->class));
+	BRCMF_INFO(("sdio_vendor: 0x%04x\n", func->vendor));
+	BRCMF_INFO(("sdio_device: 0x%04x\n", func->device));
+	BRCMF_INFO(("Function#: 0x%04x\n", func->num));
 
 	if (func->num == 2) {
-		sd_trace(("F2 found, calling brcmf_sdio_remove...\n"));
+		BRCMF_TRACE(("F2 found, calling brcmf_sdio_remove...\n"));
 		brcmf_sdio_remove(&sdmmc_dev);
 	}
 }
@@ -1062,19 +1004,19 @@ static int brcmf_sdio_suspend(struct device *dev)
 	mmc_pm_flag_t sdio_flags;
 	int ret = 0;
 
-	sd_trace(("%s\n", __func__));
+	BRCMF_TRACE(("%s\n", __func__));
 
 	atomic_set(&brcmf_mmc_suspend, true);
 
 	sdio_flags = sdio_get_host_pm_caps(gInstance->func[1]);
 	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
-		sd_err(("Host can't keep power while suspended\n"));
+		BRCMF_ERROR(("Host can't keep power while suspended\n"));
 		return -EINVAL;
 	}
 
 	ret = sdio_set_host_pm_flags(gInstance->func[1], MMC_PM_KEEP_POWER);
 	if (ret) {
-		sd_err(("Failed to set pm_flags\n"));
+		BRCMF_ERROR(("Failed to set pm_flags\n"));
 		return ret;
 	}
 
@@ -1119,12 +1061,12 @@ int brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
 	unsigned long flags;
 	struct sdos_info *sdos;
 
-	sd_trace(("%s: %s\n", __func__, enable ? "Enabling" : "Disabling"));
+	BRCMF_TRACE(("%s: %s\n", __func__, enable ? "Enabling" : "Disabling"));
 
 	sdos = (struct sdos_info *)sd->sdos_info;
 
 	if (enable && !(sd->intr_handler && sd->intr_handler_arg)) {
-		sd_err(("%s: no handler registered, will not enable\n",
+		BRCMF_ERROR(("%s: no handler registered, will not enable\n",
 			__func__));
 		return -EINVAL;
 	}
@@ -1149,7 +1091,7 @@ int brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
 int brcmf_sdio_function_init(void)
 {
 	int error = 0;
-	sd_trace(("brcmf_sdio_function_init: %s Enter\n", __func__));
+	BRCMF_TRACE(("brcmf_sdio_function_init: %s Enter\n", __func__));
 
 	gInstance = kzalloc(sizeof(struct brcmf_sdmmc_instance), GFP_KERNEL);
 	if (!gInstance)
@@ -1166,7 +1108,7 @@ int brcmf_sdio_function_init(void)
 */
 void brcmf_sdio_function_cleanup(void)
 {
-	sd_trace(("%s Enter\n", __func__));
+	BRCMF_TRACE(("%s Enter\n", __func__));
 
 	sdio_unregister_driver(&brcmf_sdmmc_driver);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index ad67955..c33720d 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -340,7 +340,6 @@ extern int brcmf_sdioh_abort(struct sdioh_info *si, uint fnc);
 /* Watchdog timer interface for pm ops */
 extern void brcmf_sdio_wdtmr_enable(bool enable);
 
-extern uint sd_msglevel;	/* Debug message level */
 extern uint sd_f2_blocksize;
 
 extern struct brcmf_sdmmc_instance *gInstance;
-- 
1.7.4.1


