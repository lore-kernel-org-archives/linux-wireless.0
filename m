Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4657 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161Ab1F2XtK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:10 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 074/119] staging: brcm80211: remove conditional code
 fragments from brcmfmac
Date: Wed, 29 Jun 2011 16:47:38 -0700
Message-ID: <1309391303-22741-75-git-send-email-frankyl@broadcom.com> (sfid-20110630_015154_065332_41D555E1)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The fullmac sources contained a lot of conditional code sections that
are never to be enabled for the fullmac driver. These have been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    9 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |  101 ---------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |  135 +-----------
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    2 -
 drivers/staging/brcm80211/brcmfmac/dhd.h           |    6 -
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    4 -
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |  200 -----------------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |  236 +-------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   58 -----
 9 files changed, 4 insertions(+), 747 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 72a91bd..c8e84d3 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -44,15 +44,6 @@ struct brcmf_sdio {
 /* local copy of bcm sd handler */
 struct brcmf_sdio *l_bcmsdh;
 
-#if defined(OOB_INTR_ONLY) && defined(HW_OOB)
-extern int brcmf_sdioh_enable_hw_oob_intr(void *sdioh, bool enable);
-
-void brcmf_sdcard_enable_hw_oob_intr(struct brcmf_sdio *sdh, bool enable)
-{
-	brcmf_sdioh_enable_hw_oob_intr(sdh->sdioh, enable);
-}
-#endif
-
 struct brcmf_sdio *brcmf_sdcard_attach(void *cfghdl, void **regsva, uint irq)
 {
 	struct brcmf_sdio *bcmsdh;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 5194c59..c4b74ab 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -31,14 +31,7 @@
 #include <brcmu_wifi.h>
 #include "sdio_host.h"
 
-#if defined(OOB_INTR_ONLY)
-#include <linux/irq.h>
 extern void brcmf_sdbrcm_isr(void *args);
-#endif				/* defined(OOB_INTR_ONLY) */
-#if defined(CONFIG_MACH_SANDGATE2G) || defined(CONFIG_MACH_LOGICPD_PXA270)
-
-#include <linux/platform_device.h>
-#endif				/* CONFIG_MACH_SANDGATE2G */
 
 #include "dngl_stats.h"
 #include "dhd.h"
@@ -56,9 +49,6 @@ struct bcmsdh_hc {
 	unsigned long oob_flags;	/* OOB Host specifiction
 					as edge and etc */
 	bool oob_irq_registered;
-#if defined(OOB_INTR_ONLY)
-	spinlock_t irq_lock;
-#endif
 };
 static struct bcmsdh_hc *sdhcinfo;
 
@@ -129,20 +119,6 @@ int brcmf_sdio_probe(struct device *dev)
 	u32 vendevid;
 	unsigned long irq_flags = 0;
 
-#if defined(OOB_INTR_ONLY)
-#ifdef HW_OOB
-	irq_flags =
-	    IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL |
-	    IORESOURCE_IRQ_SHAREABLE;
-#else
-	irq_flags = IRQF_TRIGGER_FALLING;
-#endif				/* HW_OOB */
-	irq = brcmf_customer_oob_irq_map(&irq_flags);
-	if (irq < 0) {
-		SDLX_MSG(("%s: Host irq is not defined\n", __func__));
-		return 1;
-	}
-#endif				/* defined(OOB_INTR_ONLY) */
 	/* allocate SDIO Host Controller state info */
 	sdhc = kzalloc(sizeof(struct bcmsdh_hc), GFP_ATOMIC);
 	if (!sdhc) {
@@ -161,9 +137,6 @@ int brcmf_sdio_probe(struct device *dev)
 	sdhc->oob_irq = irq;
 	sdhc->oob_flags = irq_flags;
 	sdhc->oob_irq_registered = false;	/* to make sure.. */
-#if defined(OOB_INTR_ONLY)
-	spin_lock_init(&sdhc->irq_lock);
-#endif
 
 	/* chain SDIO Host Controller info together */
 	sdhc->next = sdhcinfo;
@@ -238,80 +211,6 @@ void brcmf_sdio_unregister(void)
 	brcmf_sdio_function_cleanup();
 }
 
-#if defined(OOB_INTR_ONLY)
-void brcmf_sdio_oob_intr_set(bool enable)
-{
-	static bool curstate = 1;
-	unsigned long flags;
-
-	spin_lock_irqsave(&sdhcinfo->irq_lock, flags);
-	if (curstate != enable) {
-		if (enable)
-			enable_irq(sdhcinfo->oob_irq);
-		else
-			disable_irq_nosync(sdhcinfo->oob_irq);
-		curstate = enable;
-	}
-	spin_unlock_irqrestore(&sdhcinfo->irq_lock, flags);
-}
-
-static irqreturn_t brcmf_sdio_oob_irq(int irq, void *dev_id)
-{
-	dhd_pub_t *dhdp;
-
-	dhdp = (dhd_pub_t *) dev_get_drvdata(sdhcinfo->dev);
-
-	brcmf_sdio_oob_intr_set(0);
-
-	if (dhdp == NULL) {
-		SDLX_MSG(("Out of band GPIO interrupt fired way too early\n"));
-		return IRQ_HANDLED;
-	}
-
-	brcmf_sdbrcm_isr((void *)dhdp->bus);
-
-	return IRQ_HANDLED;
-}
-
-int brcmf_sdio_register_oob_intr(void *dhdp)
-{
-	int error = 0;
-
-	SDLX_MSG(("%s Enter\n", __func__));
-
-	sdhcinfo->oob_flags =
-	    IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL |
-	    IORESOURCE_IRQ_SHAREABLE;
-	dev_set_drvdata(sdhcinfo->dev, dhdp);
-
-	if (!sdhcinfo->oob_irq_registered) {
-		SDLX_MSG(("%s IRQ=%d Type=%X\n", __func__,
-			  (int)sdhcinfo->oob_irq, (int)sdhcinfo->oob_flags));
-		/* Refer to customer Host IRQ docs about
-			 proper irqflags definition */
-		error =
-		    request_irq(sdhcinfo->oob_irq, brcmf_sdio_oob_irq,
-				sdhcinfo->oob_flags, "bcmsdh_sdmmc", NULL);
-		if (error)
-			return -ENODEV;
-
-		irq_set_irq_wake(sdhcinfo->oob_irq, 1);
-		sdhcinfo->oob_irq_registered = true;
-	}
-
-	return 0;
-}
-
-void brcmf_sdio_unregister_oob_intr(void)
-{
-	SDLX_MSG(("%s: Enter\n", __func__));
-
-	irq_set_irq_wake(sdhcinfo->oob_irq, 0);
-	disable_irq(sdhcinfo->oob_irq);	/* just in case.. */
-	free_irq(sdhcinfo->oob_irq, NULL);
-	sdhcinfo->oob_irq_registered = false;
-}
-#endif				/* defined(OOB_INTR_ONLY) */
 /* Module parameters specific to each host-controller driver */
 
 extern uint sd_msglevel;	/* Debug message level */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 335da48..c1de2cd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -35,10 +35,8 @@
 extern int brcmf_sdio_function_init(void);
 extern void brcmf_sdio_function_cleanup(void);
 
-#if !defined(OOB_INTR_ONLY)
 static void brcmf_sdioh_irqhandler(struct sdio_func *func);
 static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func);
-#endif				/* !defined(OOB_INTR_ONLY) */
 static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr);
 extern int brcmf_sdioh_reset_comm(struct mmc_card *card);
 
@@ -191,74 +189,6 @@ extern int brcmf_sdioh_detach(struct sdioh_info *sd)
 	return SDIOH_API_RC_SUCCESS;
 }
 
-#if defined(OOB_INTR_ONLY) && defined(HW_OOB)
-
-extern int brcmf_sdioh_enable_func_intr(void)
-{
-	u8 reg;
-	int err;
-
-	if (gInstance->func[0]) {
-		sdio_claim_host(gInstance->func[0]);
-
-		reg = sdio_readb(gInstance->func[0], SDIOD_CCCR_INTEN, &err);
-		if (err) {
-			sd_err(("%s: error for read SDIO_CCCR_IENx : 0x%x\n",
-				__func__, err));
-			sdio_release_host(gInstance->func[0]);
-			return SDIOH_API_RC_FAIL;
-		}
-
-		/* Enable F1 and F2 interrupts, set master enable */
-		reg |=
-		    (INTR_CTL_FUNC1_EN | INTR_CTL_FUNC2_EN |
-		     INTR_CTL_MASTER_EN);
-
-		sdio_writeb(gInstance->func[0], reg, SDIOD_CCCR_INTEN, &err);
-		sdio_release_host(gInstance->func[0]);
-
-		if (err) {
-			sd_err(("%s: error for write SDIO_CCCR_IENx : 0x%x\n",
-				__func__, err));
-			return SDIOH_API_RC_FAIL;
-		}
-	}
-
-	return SDIOH_API_RC_SUCCESS;
-}
-
-extern int brcmf_sdioh_disable_func_intr(void)
-{
-	u8 reg;
-	int err;
-
-	if (gInstance->func[0]) {
-		sdio_claim_host(gInstance->func[0]);
-		reg = sdio_readb(gInstance->func[0], SDIOD_CCCR_INTEN, &err);
-		if (err) {
-			sd_err(("%s: error for read SDIO_CCCR_IENx : 0x%x\n",
-				__func__, err));
-			sdio_release_host(gInstance->func[0]);
-			return SDIOH_API_RC_FAIL;
-		}
-
-		reg &= ~(INTR_CTL_FUNC1_EN | INTR_CTL_FUNC2_EN);
-		/* Disable master interrupt with the last function interrupt */
-		if (!(reg & 0xFE))
-			reg = 0;
-		sdio_writeb(gInstance->func[0], reg, SDIOD_CCCR_INTEN, &err);
-
-		sdio_release_host(gInstance->func[0]);
-		if (err) {
-			sd_err(("%s: error for write SDIO_CCCR_IENx : 0x%x\n",
-				__func__, err));
-			return SDIOH_API_RC_FAIL;
-		}
-	}
-	return SDIOH_API_RC_SUCCESS;
-}
-#endif				/* defined(OOB_INTR_ONLY) && defined(HW_OOB) */
-
 /* Configure callback to client when we receive client interrupt */
 extern int
 brcmf_sdioh_interrupt_register(struct sdioh_info *sd, sdioh_cb_fn_t fn,
@@ -270,7 +200,7 @@ brcmf_sdioh_interrupt_register(struct sdioh_info *sd, sdioh_cb_fn_t fn,
 			__func__));
 		return SDIOH_API_RC_FAIL;
 	}
-#if !defined(OOB_INTR_ONLY)
+
 	sd->intr_handler = fn;
 	sd->intr_handler_arg = argh;
 	sd->intr_handler_valid = true;
@@ -287,9 +217,7 @@ brcmf_sdioh_interrupt_register(struct sdioh_info *sd, sdioh_cb_fn_t fn,
 		sdio_claim_irq(gInstance->func[1], brcmf_sdioh_irqhandler);
 		sdio_release_host(gInstance->func[1]);
 	}
-#elif defined(HW_OOB)
-	brcmf_sdioh_enable_func_intr();
-#endif				/* defined(OOB_INTR_ONLY) */
+
 	return SDIOH_API_RC_SUCCESS;
 }
 
@@ -297,7 +225,6 @@ extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 {
 	sd_trace(("%s: Entering\n", __func__));
 
-#if !defined(OOB_INTR_ONLY)
 	if (gInstance->func[1]) {
 		/* register and unmask irq */
 		sdio_claim_host(gInstance->func[1]);
@@ -316,9 +243,7 @@ extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 	sd->intr_handler_valid = false;
 	sd->intr_handler = NULL;
 	sd->intr_handler_arg = NULL;
-#elif defined(HW_OOB)
-	brcmf_sdioh_disable_func_intr();
-#endif				/*  !defined(OOB_INTR_ONLY) */
+
 	return SDIOH_API_RC_SUCCESS;
 }
 
@@ -536,24 +461,6 @@ exit:
 	return bcmerror;
 }
 
-#if defined(OOB_INTR_ONLY) && defined(HW_OOB)
-
-int brcmf_sdioh_enable_hw_oob_intr(struct sdioh_info *sd, bool enable)
-{
-	int status;
-	u8 data;
-
-	if (enable)
-		data = 3;	/* enable hw oob interrupt */
-	else
-		data = 4;	/* disable hw oob interrupt */
-	data |= 4;		/* Active HIGH */
-
-	status = brcmf_sdioh_request_byte(sd, SDIOH_WRITE, 0, 0xf2, &data);
-	return status;
-}
-#endif				/* defined(OOB_INTR_ONLY) && defined(HW_OOB) */
-
 extern int
 brcmf_sdioh_cfg_read(struct sdioh_info *sd, uint fnc_num, u32 addr, u8 *data)
 {
@@ -800,13 +707,6 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 		pkt_len += 3;
 		pkt_len &= 0xFFFFFFFC;
 
-#ifdef CONFIG_MMC_MSM7X00A
-		if ((pkt_len % 64) == 32) {
-			sd_trace(("%s: Rounding up TX packet +=32\n",
-				  __func__));
-			pkt_len += 32;
-		}
-#endif				/* CONFIG_MMC_MSM7X00A */
 		/* Make sure the packet is aligned properly.
 		 * If it isn't, then this
 		 * is the fault of brcmf_sdioh_request_buffer() which
@@ -1007,7 +907,6 @@ brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
 	return SUCCESS;
 }
 
-#if !defined(OOB_INTR_ONLY)
 /* bcmsdh_sdmmc interrupt handler */
 static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
@@ -1045,34 +944,6 @@ static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func)
 
 	ASSERT(sd != NULL);
 }
-#endif				/* !defined(OOB_INTR_ONLY) */
-
-#ifdef NOTUSED
-/* Write client card reg */
-static int
-brcmf_sdioh_card_regwrite(struct sdioh_info *sd, int func, u32 regaddr,
-			  int regsize, u32 data)
-{
-
-	if ((func == 0) || (regsize == 1)) {
-		u8 temp;
-
-		temp = data & 0xff;
-		brcmf_sdioh_request_byte(sd, SDIOH_READ, func, regaddr, &temp);
-		sd_data(("%s: byte write data=0x%02x\n", __func__, data));
-	} else {
-		if (regsize == 2)
-			data &= 0xffff;
-
-		brcmf_sdioh_request_word(sd, 0, SDIOH_READ, func, regaddr,
-					 &data, regsize);
-
-		sd_data(("%s: word write data=0x%08x\n", __func__, data));
-	}
-
-	return SUCCESS;
-}
-#endif				/* NOTUSED */
 
 int brcmf_sdioh_start(struct sdioh_info *si, int stage)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index c95112e..6abd9c0 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -182,13 +182,11 @@ int brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
 	sdos = (struct sdos_info *)sd->sdos_info;
 	ASSERT(sdos);
 
-#if !defined(OOB_INTR_ONLY)
 	if (enable && !(sd->intr_handler && sd->intr_handler_arg)) {
 		sd_err(("%s: no handler registered, will not enable\n",
 			__func__));
 		return SDIOH_API_RC_FAIL;
 	}
-#endif				/* !defined(OOB_INTR_ONLY) */
 
 	/* Ensure atomicity for enable/disable calls */
 	spin_lock_irqsave(&sdos->lock, flags);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index b7ed29c..87c65f1 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -691,9 +691,6 @@ typedef struct dhd_pub {
 	int suspend_disable_flag;	/* "1" to disable all extra powersaving
 					 during suspend */
 	int in_suspend;		/* flag set to 1 when early suspend called */
-#ifdef PNO_SUPPORT
-	int pno_enable;		/* pno status : "1" is pno enable */
-#endif				/* PNO_SUPPORT */
 	int dtim_skip;		/* dtim skip , default 0 means wake each dtim */
 
 	/* Pkt filter defination */
@@ -936,9 +933,6 @@ extern void brcmf_os_sdunlock_eventq(dhd_pub_t *pub);
 #ifdef BCMDBG
 extern int brcmf_write_to_file(dhd_pub_t *dhd, u8 *buf, int size);
 #endif				/* BCMDBG */
-#if defined(OOB_INTR_ONLY)
-extern int brcmf_customer_oob_irq_map(unsigned long *irq_flags_ptr);
-#endif				/* defined(OOB_INTR_ONLY) */
 
 extern void brcmf_timeout_start(dhd_timeout_t *tmo, uint usec);
 extern int brcmf_timeout_expired(dhd_timeout_t *tmo);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index a766707..471869f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -80,10 +80,6 @@ struct brcmf_proto_bdc_header {
 };
 
 
-#ifdef CUSTOMER_HW2
-int wifi_get_mac_addr(unsigned char *buf);
-#endif
-
 #define RETRIES 2	/* # of retries to retrieve matching ioctl response */
 #define BUS_HEADER_LEN	(16+BRCMF_SDALIGN) /* Must be atleast SDPCM_RESERVE
 					 * defined in dhd_sdio.c
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 6c41088..22739f0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -872,11 +872,6 @@ brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 		brcmf_event(dhd, (char *)pvt_data, evlen, *ifidx);
 		break;
 
-#ifdef P2P
-	case BRCMF_E_NDIS_LINK:
-		break;
-#endif
-		/* fall through */
 		/* These are what external supplicant/authenticator wants */
 	case BRCMF_E_LINK:
 	case BRCMF_E_ASSOC_IND:
@@ -1191,35 +1186,9 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	int scan_assoc_time = 40;
 	int scan_unassoc_time = 40;
 	int i;
-#ifdef GET_CUSTOM_MAC_ENABLE
-	int ret = 0;
-	u8 ea_addr[ETH_ALEN];
-#endif				/* GET_CUSTOM_MAC_ENABLE */
 
 	brcmf_os_proto_block(dhd);
 
-#ifdef GET_CUSTOM_MAC_ENABLE
-	/* Read MAC address from external customer place
-	 ** NOTE that default mac address has to be present in
-	 ** otp or nvram file to bring up
-	 ** firmware but unique per board mac address maybe provided by
-	 ** customer code
-	 */
-	ret = brcmf_custom_get_mac_address(ea_addr);
-	if (!ret) {
-		brcmu_mkiovar("cur_etheraddr", (void *)ea_addr, ETH_ALEN,
-			    buf, sizeof(buf));
-		ret = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
-				       buf, sizeof(buf));
-		if (ret < 0) {
-			DHD_ERROR(("%s: can't set MAC address , error=%d\n",
-				   __func__, ret));
-		} else
-			memcpy(dhd->mac.octet, (void *)&ea_addr,
-			       ETH_ALEN);
-	}
-#endif				/* GET_CUSTOM_MAC_ENABLE */
-
 	/* Set Country code */
 	if (dhd->country_code[0] != 0) {
 		if (brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_COUNTRY,
@@ -1305,172 +1274,3 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 
 	return 0;
 }
-
-#ifdef PNO_SUPPORT
-int dhd_pno_clean(dhd_pub_t *dhd)
-{
-	char iovbuf[128];
-	int pfn_enabled = 0;
-	int iov_len = 0;
-	int ret;
-
-	/* Disable pfn */
-	iov_len = brcmu_mkiovar("pfn", (char *)&pfn_enabled, 4, iovbuf,
-				sizeof(iovbuf));
-	ret = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
-					sizeof(iovbuf));
-	if (ret >= 0) {
-		/* clear pfn */
-		iov_len = brcmu_mkiovar("pfnclear", 0, 0, iovbuf,
-					sizeof(iovbuf));
-		if (iov_len) {
-			ret = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
-							iovbuf, iov_len);
-			if (ret < 0) {
-				DHD_ERROR(("%s failed code %d\n", __func__,
-					   ret));
-			}
-		} else {
-			ret = -1;
-			DHD_ERROR(("%s failed code %d\n", __func__, iov_len));
-		}
-	} else
-		DHD_ERROR(("%s failed code %d\n", __func__, ret));
-
-	return ret;
-}
-
-int dhd_pno_enable(dhd_pub_t *dhd, int pfn_enabled)
-{
-	char iovbuf[128];
-	int ret = -1;
-
-	if ((!dhd) && ((pfn_enabled != 0) || (pfn_enabled != 1))) {
-		DHD_ERROR(("%s error exit\n", __func__));
-		return ret;
-	}
-
-	/* Enable/disable PNO */
-	ret = brcmu_mkiovar("pfn", (char *)&pfn_enabled, 4, iovbuf,
-			sizeof(iovbuf));
-	if (ret > 0) {
-		ret = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
-				sizeof(iovbuf));
-		if (ret < 0) {
-			DHD_ERROR(("%s failed for error=%d\n", __func__, ret));
-			return ret;
-		} else {
-			dhd->pno_enable = pfn_enabled;
-			DHD_TRACE(("%s set pno as %d\n", __func__,
-				   dhd->pno_enable));
-		}
-	} else
-		DHD_ERROR(("%s failed err=%d\n", __func__, ret));
-
-	return ret;
-}
-
-/* Function to execute combined scan */
-int
-dhd_pno_set(dhd_pub_t *dhd, wlc_ssid_t *ssids_local, int nssid, unsigned char scan_fr)
-{
-	int err = -1;
-	char iovbuf[128];
-	int k, i;
-	wl_pfn_param_t pfn_param;
-	wl_pfn_t pfn_element;
-
-	DHD_TRACE(("%s nssid=%d nchan=%d\n", __func__, nssid, scan_fr));
-
-	if ((!dhd) && (!ssids_local)) {
-		DHD_ERROR(("%s error exit\n", __func__));
-		err = -1;
-	}
-
-	/* Check for broadcast ssid */
-	for (k = 0; k < nssid; k++) {
-		if (!ssids_local[k].SSID_len) {
-			DHD_ERROR(("%d: Broadcast SSID is ilegal for PNO "
-				"setting\n", k));
-			return err;
-		}
-	}
-/* #define  PNO_DUMP 1 */
-#ifdef PNO_DUMP
-	{
-		int j;
-		for (j = 0; j < nssid; j++) {
-			DHD_ERROR(("%d: scan  for  %s size =%d\n", j,
-				   ssids_local[j].SSID,
-				   ssids_local[j].SSID_len));
-		}
-	}
-#endif				/* PNO_DUMP */
-
-	/* clean up everything */
-	err = dhd_pno_clean(dhd);
-	if (err < 0) {
-		DHD_ERROR(("%s failed error=%d\n", __func__, err));
-		return err;
-	}
-	memset(&pfn_param, 0, sizeof(pfn_param));
-	memset(&pfn_element, 0, sizeof(pfn_element));
-
-	/* set pfn parameters */
-	pfn_param.version = PFN_VERSION;
-	pfn_param.flags = (PFN_LIST_ORDER << SORT_CRITERIA_BIT);
-
-	/* set up pno scan fr */
-	if (scan_fr != 0)
-		pfn_param.scan_freq = scan_fr;
-
-	brcmu_mkiovar("pfn_set", (char *)&pfn_param, sizeof(pfn_param), iovbuf,
-		    sizeof(iovbuf));
-	brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
-				  sizeof(iovbuf));
-
-	/* set all pfn ssid */
-	for (i = 0; i < nssid; i++) {
-
-		pfn_element.bss_type = DOT11_BSSTYPE_INFRASTRUCTURE;
-		pfn_element.auth = WLAN_AUTH_OPEN;
-		pfn_element.wpa_auth = WPA_AUTH_PFN_ANY;
-		pfn_element.wsec = 0;
-		pfn_element.infra = 1;
-
-		memcpy((char *)pfn_element.ssid.SSID, ssids_local[i].SSID,
-		       ssids_local[i].SSID_len);
-		pfn_element.ssid.SSID_len = ssids_local[i].SSID_len;
-
-		err = brcmu_mkiovar("pfn_add", (char *)&pfn_element,
-				sizeof(pfn_element), iovbuf, sizeof(iovbuf));
-		if (err > 0) {
-			err = brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
-							iovbuf, sizeof(iovbuf));
-			if (err < 0) {
-				DHD_ERROR(("%s failed for i=%d error=%d\n",
-					   __func__, i, err));
-				return err;
-			}
-		} else
-			DHD_ERROR(("%s failed err=%d\n", __func__, err));
-	}
-
-	/* Enable PNO */
-	/* dhd_pno_enable(dhd, 1); */
-	return err;
-}
-
-int dhd_pno_get_status(dhd_pub_t *dhd)
-{
-	int ret = -1;
-
-	if (!dhd)
-		return ret;
-	else
-		return dhd->pno_enable;
-}
-
-#endif				/* PNO_SUPPORT */
-
-/* Androd ComboSCAN support */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 5a0bcb2..5327941 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -14,9 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifdef CONFIG_WIFI_CONTROL_FUNC
-#include <linux/platform_device.h>
-#endif
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
@@ -52,135 +49,12 @@
 /* Global ASSERT type flag */
 u32 g_assert_type;
 
-#if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
-#include <linux/wifi_tiwlan.h>
-
-struct semaphore wifi_control_sem;
-
-struct dhd_bus *g_bus;
-
-static struct wifi_platform_data *wifi_control_data;
-static struct resource *wifi_irqres;
-
-int wifi_get_irq_number(unsigned long *irq_flags_ptr)
-{
-	if (wifi_irqres) {
-		*irq_flags_ptr = wifi_irqres->flags & IRQF_TRIGGER_MASK;
-		return (int)wifi_irqres->start;
-	}
-#ifdef CUSTOM_OOB_GPIO_NUM
-	return CUSTOM_OOB_GPIO_NUM;
-#else
-	return -1;
-#endif
-}
-
-int wifi_set_carddetect(int on)
-{
-	printk(KERN_ERR "%s = %d\n", __func__, on);
-	if (wifi_control_data && wifi_control_data->set_carddetect)
-		wifi_control_data->set_carddetect(on);
-	return 0;
-}
-
-int wifi_set_power(int on, unsigned long msec)
-{
-	printk(KERN_ERR "%s = %d\n", __func__, on);
-	if (wifi_control_data && wifi_control_data->set_power)
-		wifi_control_data->set_power(on);
-	if (msec)
-		mdelay(msec);
-	return 0;
-}
-
-int wifi_set_reset(int on, unsigned long msec)
-{
-	printk(KERN_ERR "%s = %d\n", __func__, on);
-	if (wifi_control_data && wifi_control_data->set_reset)
-		wifi_control_data->set_reset(on);
-	if (msec)
-		mdelay(msec);
-	return 0;
-}
-
-static int wifi_probe(struct platform_device *pdev)
-{
-	struct wifi_platform_data *wifi_ctrl =
-	    (struct wifi_platform_data *)(pdev->dev.platform_data);
-
-	printk(KERN_ERR "## %s\n", __func__);
-	wifi_irqres =
-	    platform_get_resource_byname(pdev, IORESOURCE_IRQ,
-					 "bcm4329_wlan_irq");
-	wifi_control_data = wifi_ctrl;
-
-	wifi_set_power(1, 0);	/* Power On */
-	wifi_set_carddetect(1);	/* CardDetect (0->1) */
-
-	up(&wifi_control_sem);
-	return 0;
-}
-
-static int wifi_remove(struct platform_device *pdev)
-{
-	struct wifi_platform_data *wifi_ctrl =
-	    (struct wifi_platform_data *)(pdev->dev.platform_data);
-
-	printk(KERN_ERR "## %s\n", __func__);
-	wifi_control_data = wifi_ctrl;
-
-	wifi_set_carddetect(0);	/* CardDetect (1->0) */
-	wifi_set_power(0, 0);	/* Power Off */
-
-	up(&wifi_control_sem);
-	return 0;
-}
-
-static int wifi_suspend(struct platform_device *pdev, pm_message_t state)
-{
-	DHD_TRACE(("##> %s\n", __func__));
-	return 0;
-}
-
-static int wifi_resume(struct platform_device *pdev)
-{
-	DHD_TRACE(("##> %s\n", __func__));
-	return 0;
-}
-
-static struct platform_driver wifi_device = {
-	.probe = wifi_probe,
-	.remove = wifi_remove,
-	.suspend = wifi_suspend,
-	.resume = wifi_resume,
-	.driver = {
-		   .name = KBUILD_MODNAME,
-		   }
-};
-
-int wifi_add_dev(void)
-{
-	DHD_TRACE(("## Calling platform_driver_register\n"));
-	return platform_driver_register(&wifi_device);
-}
-
-void wifi_del_dev(void)
-{
-	DHD_TRACE(("## Unregister platform_driver_register\n"));
-	platform_driver_unregister(&wifi_device);
-}
-#endif	/* defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC) */
-
 #if defined(CONFIG_PM_SLEEP)
 #include <linux/suspend.h>
 atomic_t brcmf_mmc_suspend;
 DECLARE_WAIT_QUEUE_HEAD(dhd_dpc_wait);
 #endif	/*  defined(CONFIG_PM_SLEEP) */
 
-#if defined(OOB_INTR_ONLY)
-extern void brcmf_sdbrcm_enable_oob_intr(struct dhd_bus *bus, bool enable);
-#endif	/* defined(OOB_INTR_ONLY) */
-
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac driver.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN fullmac cards");
@@ -302,11 +176,7 @@ extern int brcmf_dongle_memsize;
 module_param(brcmf_dongle_memsize, int, 0);
 
 /* Contorl fw roaming */
-#ifdef CUSTOMER_HW2
-uint brcmf_roam;
-#else
 uint brcmf_roam = 1;
-#endif
 
 /* Control radio state */
 uint brcmf_radio_up = 1;
@@ -392,9 +262,6 @@ static int brcmf_set_suspend(int value, dhd_pub_t *dhd)
 	/* wl_pkt_filter_enable_t       enable_parm; */
 	char iovbuf[32];
 	int bcn_li_dtim = 3;
-#ifdef CUSTOMER_HW2
-	uint roamvar = 1;
-#endif				/* CUSTOMER_HW2 */
 
 	DHD_TRACE(("%s: enter, value = %d in_suspend=%d\n",
 		   __func__, value, dhd->in_suspend));
@@ -428,15 +295,6 @@ static int brcmf_set_suspend(int value, dhd_pub_t *dhd)
 				    4, iovbuf, sizeof(iovbuf));
 			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
 						  iovbuf, sizeof(iovbuf));
-#ifdef CUSTOMER_HW2
-			/* Disable build-in roaming to allowed \
-			 * supplicant to take of romaing
-			 */
-			brcmu_mkiovar("roam_off", (char *)&roamvar, 4,
-				    iovbuf, sizeof(iovbuf));
-			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
-						  iovbuf, sizeof(iovbuf));
-#endif				/* CUSTOMER_HW2 */
 		} else {
 
 			/* Kernel resumed  */
@@ -457,13 +315,6 @@ static int brcmf_set_suspend(int value, dhd_pub_t *dhd)
 
 			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
 						  iovbuf, sizeof(iovbuf));
-#ifdef CUSTOMER_HW2
-			roamvar = 0;
-			brcmu_mkiovar("roam_off", (char *)&roamvar, 4, iovbuf,
-				    sizeof(iovbuf));
-			brcmf_proto_cdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
-						  iovbuf, sizeof(iovbuf));
-#endif				/* CUSTOMER_HW2 */
 		}
 	}
 
@@ -950,7 +801,6 @@ static void brcmf_netdev_set_multicast_list(struct net_device *dev)
 
 int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 {
-	int ret;
 	dhd_info_t *dhd = (dhd_info_t *) (dhdp->info);
 
 	/* Reject if down */
@@ -972,13 +822,7 @@ int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 	brcmf_proto_hdrpush(dhdp, ifidx, pktbuf);
 
 	/* Use bus module to send data frame */
-#ifdef BCMDBUS
-	ret = dbus_send_pkt(dhdp->dbus, pktbuf, NULL /* pktinfo */);
-#else
-	ret = brcmf_sdbrcm_bus_txdata(dhdp->bus, pktbuf);
-#endif				/* BCMDBUS */
-
-	return ret;
+	return brcmf_sdbrcm_bus_txdata(dhdp->bus, pktbuf);
 }
 
 static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
@@ -1945,18 +1789,6 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 			   ret));
 		return ret;
 	}
-#if defined(OOB_INTR_ONLY)
-	/* Host registration for OOB interrupt */
-	if (brcmf_sdio_register_oob_intr(dhdp)) {
-		del_timer_sync(&dhd->timer);
-		dhd->wd_timer_valid = false;
-		DHD_ERROR(("%s Host failed to resgister for OOB\n", __func__));
-		return -ENODEV;
-	}
-
-	/* Enable oob at firmware */
-	brcmf_sdbrcm_enable_oob_intr(dhd->pub.bus, true);
-#endif				/* defined(OOB_INTR_ONLY) */
 
 	/* If bus is not ready, can't come up */
 	if (dhd->pub.busstate != DHD_BUS_DATA) {
@@ -1990,9 +1822,6 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 	setbit(dhdp->eventmask, BRCMF_E_TXFAIL);
 	setbit(dhdp->eventmask, BRCMF_E_JOIN_START);
 	setbit(dhdp->eventmask, BRCMF_E_SCAN_COMPLETE);
-#ifdef PNO_SUPPORT
-	setbit(dhdp->eventmask, BRCMF_E_PFN_NET_FOUND);
-#endif				/* PNO_SUPPORT */
 
 /* enable dongle roaming event */
 
@@ -2111,9 +1940,6 @@ static void brcmf_bus_detach(dhd_pub_t *dhdp)
 
 			/* Stop the bus module */
 			brcmf_sdbrcm_bus_stop(dhd->pub.bus, true);
-#if defined(OOB_INTR_ONLY)
-			brcmf_sdio_unregister_oob_intr();
-#endif				/* defined(OOB_INTR_ONLY) */
 
 			/* Clear the watchdog timer */
 			del_timer_sync(&dhd->timer);
@@ -2189,9 +2015,6 @@ static void __exit brcmf_module_cleanup(void)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	dhd_bus_unregister();
-#if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
-	wifi_del_dev();
-#endif
 }
 
 static int __init brcmf_module_init(void)
@@ -2215,26 +2038,6 @@ static int __init brcmf_module_init(void)
 		return -EINVAL;
 	} while (0);
 
-#if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
-	sema_init(&wifi_control_sem, 0);
-
-	error = wifi_add_dev();
-	if (error) {
-		DHD_ERROR(("%s: platform_driver_register failed\n", __func__));
-		goto failed;
-	}
-
-	/* Waiting callback after platform_driver_register is done or
-		 exit with error */
-	if (down_timeout(&wifi_control_sem, msecs_to_jiffies(1000)) != 0) {
-		printk(KERN_ERR "%s: platform_driver_register timeout\n",
-			__func__);
-		/* remove device */
-		wifi_del_dev();
-		goto failed;
-	}
-#endif	/* #if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC) */
-
 	error = dhd_bus_register();
 
 	if (error) {
@@ -2556,43 +2359,6 @@ void brcmf_netdev_init_ioctl(struct net_device *dev)
 	brcmf_c_preinit_ioctls(&dhd->pub);
 }
 
-#ifdef PNO_SUPPORT
-/* Linux wrapper to call common dhd_pno_clean */
-int brcmf_netdev_pno_reset(struct net_device *dev)
-{
-	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
-
-	return dhd_pno_clean(&dhd->pub);
-}
-
-/* Linux wrapper to call common dhd_pno_enable */
-int brcmf_netdev_pno_enable(struct net_device *dev, int pfn_enabled)
-{
-	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
-
-	return dhd_pno_enable(&dhd->pub, pfn_enabled);
-}
-
-/* Linux wrapper to call common dhd_pno_set */
-int
-brcmf_netdev_pno_set(struct net_device *dev, wlc_ssid_t *ssids_local, int nssid,
-		unsigned char scan_fr)
-{
-	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
-
-	return dhd_pno_set(&dhd->pub, ssids_local, nssid, scan_fr);
-}
-
-/* Linux wrapper to get  pno status */
-int brcmf_netdev_get_pno_status(struct net_device *dev)
-{
-	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
-
-	return dhd_pno_get_status(&dhd->pub);
-}
-
-#endif				/* PNO_SUPPORT */
-
 static int brcmf_get_pend_8021x_cnt(dhd_info_t *dhd)
 {
 	return atomic_read(&dhd->pend_8021x_cnt);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 54a0e80..a97fd7c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -673,13 +673,6 @@ static bool forcealign;
 
 #define ALIGNMENT  4
 
-#if defined(OOB_INTR_ONLY) && defined(HW_OOB)
-extern void brcmf_sdcard_enable_hw_oob_intr(void *sdh, bool enable);
-#endif
-
-#if defined(OOB_INTR_ONLY) && defined(SDIO_ISR_THREAD)
-#error OOB_INTR_ONLY is NOT working with SDIO_ISR_THREAD
-#endif	/* defined(OOB_INTR_ONLY) && defined(SDIO_ISR_THREAD) */
 #define PKTALIGN(_p, _len, _align)				\
 	do {								\
 		uint datalign;						\
@@ -831,9 +824,6 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-#if defined(OOB_INTR_ONLY)
-	pendok = false;
-#endif
 	clkctl = 0;
 	sdh = bus->sdh;
 
@@ -1116,36 +1106,6 @@ int brcmf_sdbrcm_bussleep(dhd_bus_t *bus, bool sleep)
 	return 0;
 }
 
-#if defined(OOB_INTR_ONLY)
-void brcmf_sdbrcm_enable_oob_intr(struct dhd_bus *bus, bool enable)
-{
-#if defined(HW_OOB)
-	brcmf_sdcard_enable_hw_oob_intr(bus->sdh, enable);
-#else
-	sdpcmd_regs_t *regs = bus->regs;
-	uint retries = 0;
-
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-	if (enable == true) {
-
-		/* Tell device to start using OOB wakeup */
-		W_SDREG(SMB_USE_OOB, &regs->tosbmailbox, retries);
-		if (retries > retry_limit)
-			DHD_ERROR(("CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n"));
-
-	} else {
-		/* Send misc interrupt to indicate OOB not needed */
-		W_SDREG(0, &regs->tosbmailboxdata, retries);
-		if (retries <= retry_limit)
-			W_SDREG(SMB_DEV_INT, &regs->tosbmailbox, retries);
-	}
-
-	/* Turn off our contribution to the HT clock request */
-	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
-#endif				/* !defined(HW_OOB) */
-}
-#endif				/* defined(OOB_INTR_ONLY) */
-
 #define BUS_WAKE(bus) \
 	do { \
 		if ((bus)->sleeping) \
@@ -1245,9 +1205,6 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	if (bus->roundup && bus->blocksize && (len > bus->blocksize)) {
 		u16 pad = bus->blocksize - (len % bus->blocksize);
 		if ((pad <= bus->roundup) && (pad < bus->blocksize))
-#ifdef NOTUSED
-			if (pad <= skb_tailroom(pkt))
-#endif				/* NOTUSED */
 				len += pad;
 	} else if (len % BRCMF_SDALIGN) {
 		len += BRCMF_SDALIGN - (len % BRCMF_SDALIGN);
@@ -1255,15 +1212,7 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 
 	/* Some controllers have trouble with odd bytes -- round to even */
 	if (forcealign && (len & (ALIGNMENT - 1))) {
-#ifdef NOTUSED
-		if (skb_tailroom(pkt))
-#endif
 			len = roundup(len, ALIGNMENT);
-#ifdef NOTUSED
-		else
-			DHD_ERROR(("%s: sending unrounded %d-byte packet\n",
-				   __func__, len));
-#endif
 	}
 
 	do {
@@ -4575,9 +4524,6 @@ bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 	bus->intstatus = intstatus;
 
 clkwait:
-#if defined(OOB_INTR_ONLY)
-	brcmf_sdio_oob_intr_set(1);
-#endif				/* (OOB_INTR_ONLY) */
 	/* Re-enable interrupts to detect new device events (mailbox, rx frame)
 	 * or clock availability.  (Allows tx loop to check ipend if desired.)
 	 * (Unless register access seems hosed, as we may not be able to ACK...)
@@ -5959,10 +5905,6 @@ int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 					brcmf_sdbrcm_bus_init(
 						(dhd_pub_t *) bus->dhd, false);
 
-#if defined(OOB_INTR_ONLY)
-					brcmf_sdbrcm_enable_oob_intr(bus, true);
-#endif				/* defined(OOB_INTR_ONLY) */
-
 					bus->dhd->dongle_reset = false;
 					bus->dhd->up = true;
 
-- 
1.7.1


