Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3352 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Franky Lin" <frankyl@broadcom.com>, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 19/29] staging: brcm80211: remove dead client interrupt
 code from brcmfmac
Date: Fri, 22 Jul 2011 20:57:06 +0200
Message-ID: <1311361036-3175-20-git-send-email-arend@broadcom.com> (sfid-20110722_205805_832968_776204B6)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

In fullmac, brcmf_sdcard_intr_enable/disable is a legacy layer and
doesn't really enable/disable any interrupt. This patch removes the
corresponding code.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   10 --
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  109 +--------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   53 +----------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |   20 ----
 4 files changed, 3 insertions(+), 189 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 6cabda5..3a6c015 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -53,16 +53,6 @@ brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
 				    len, set);
 }
 
-int brcmf_sdcard_intr_enable(struct brcmf_sdio_dev *sdiodev)
-{
-	return brcmf_sdioh_interrupt_set(sdiodev->sdioh, true);
-}
-
-int brcmf_sdcard_intr_disable(struct brcmf_sdio_dev *sdiodev)
-{
-	return brcmf_sdioh_interrupt_set(sdiodev->sdioh, false);
-}
-
 int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev,
 			  void (*fn)(void *), void *argh)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index edcd98e..db43b09 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -34,8 +34,6 @@
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
 
-#define CLIENT_INTR		0x100	/* Get rid of this! */
-
 #if !defined(SDIO_VENDOR_ID_BROADCOM)
 #define SDIO_VENDOR_ID_BROADCOM		0x02d0
 #endif				/* !defined(SDIO_VENDOR_ID_BROADCOM) */
@@ -46,11 +44,6 @@
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
 #endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
 
-struct sdos_info {
-	struct sdioh_info *sd;
-	spinlock_t lock;
-};
-
 static void brcmf_sdioh_irqhandler(struct sdio_func *func);
 static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func);
 static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr);
@@ -174,14 +167,8 @@ struct sdioh_info *brcmf_sdioh_attach(void *bar0)
 		BRCMF_ERROR(("sdioh_attach: out of memory\n"));
 		return NULL;
 	}
-	if (brcmf_sdioh_osinit(sd) != 0) {
-		BRCMF_ERROR(("%s:sdioh_sdmmc_osinit() failed\n", __func__));
-		kfree(sd);
-		return NULL;
-	}
 
 	sd->num_funcs = 2;
-	sd->use_client_ints = true;
 	sd->client_block_size[0] = 64;
 
 	gInstance->sd = sd;
@@ -234,9 +221,6 @@ extern int brcmf_sdioh_detach(struct sdioh_info *sd)
 		sdio_disable_func(gInstance->func[1]);
 		sdio_release_host(gInstance->func[1]);
 
-		/* deregister irq */
-		brcmf_sdioh_osfree(sd);
-
 		kfree(sd);
 	}
 	return 0;
@@ -304,7 +288,6 @@ extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 enum {
 	IOV_MSGLEVEL = 1,
 	IOV_BLOCKSIZE,
-	IOV_USEINTS,
 	IOV_NUMINTS,
 	IOV_DEVREG,
 	IOV_HCIREGS,
@@ -314,7 +297,6 @@ enum {
 const struct brcmu_iovar sdioh_iovars[] = {
 	{"sd_blocksize", IOV_BLOCKSIZE, 0, IOVT_UINT32, 0},/* ((fn << 16) |
 								 size) */
-	{"sd_ints", IOV_USEINTS, 0, IOVT_BOOL, 0},
 	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
 	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
 	,
@@ -429,20 +411,6 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 		memcpy(arg, &int_val, val_size);
 		break;
 
-	case IOV_GVAL(IOV_USEINTS):
-		int_val = (s32) si->use_client_ints;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_USEINTS):
-		si->use_client_ints = (bool) int_val;
-		if (si->use_client_ints)
-			si->intmask |= CLIENT_INTR;
-		else
-			si->intmask &= ~CLIENT_INTR;
-
-		break;
-
 	case IOV_GVAL(IOV_NUMINTS):
 		int_val = (s32) si->intrcount;
 		memcpy(arg, &int_val, val_size);
@@ -881,20 +849,6 @@ extern int brcmf_sdioh_abort(struct sdioh_info *sd, uint func)
 	return 0;
 }
 
-/* Disable device interrupt */
-void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd)
-{
-	BRCMF_TRACE(("%s: %d\n", __func__, sd->use_client_ints));
-	sd->intmask &= ~CLIENT_INTR;
-}
-
-/* Enable device interrupt */
-void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd)
-{
-	BRCMF_TRACE(("%s: %d\n", __func__, sd->use_client_ints));
-	sd->intmask |= CLIENT_INTR;
-}
-
 /* Read client card reg */
 int
 brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
@@ -929,15 +883,8 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 
 	sdio_release_host(gInstance->func[0]);
 
-	if (sd->use_client_ints) {
-		sd->intrcount++;
-		(sd->intr_handler) (sd->intr_handler_arg);
-	} else {
-		BRCMF_ERROR(("brcmf: ***IRQHandler\n"));
-
-		BRCMF_ERROR(("%s: Not ready for intr: enabled %d, handler %p\n",
-			__func__, sd->client_intr_enabled, sd->intr_handler));
-	}
+	sd->intrcount++;
+	(sd->intr_handler) (sd->intr_handler_arg);
 
 	sdio_claim_host(gInstance->func[0]);
 }
@@ -1060,58 +1007,6 @@ static int brcmf_sdio_resume(struct device *dev)
 }
 #endif		/* CONFIG_PM_SLEEP */
 
-int brcmf_sdioh_osinit(struct sdioh_info *sd)
-{
-	struct sdos_info *sdos;
-
-	sdos = kmalloc(sizeof(struct sdos_info), GFP_ATOMIC);
-	sd->sdos_info = (void *)sdos;
-	if (sdos == NULL)
-		return -ENOMEM;
-
-	sdos->sd = sd;
-	spin_lock_init(&sdos->lock);
-	return 0;
-}
-
-void brcmf_sdioh_osfree(struct sdioh_info *sd)
-{
-	struct sdos_info *sdos;
-
-	sdos = (struct sdos_info *)sd->sdos_info;
-	kfree(sdos);
-}
-
-/* Interrupt enable/disable */
-int brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
-{
-	unsigned long flags;
-	struct sdos_info *sdos;
-
-	BRCMF_TRACE(("%s: %s\n", __func__, enable ? "Enabling" : "Disabling"));
-
-	sdos = (struct sdos_info *)sd->sdos_info;
-
-	if (enable && !(sd->intr_handler && sd->intr_handler_arg)) {
-		BRCMF_ERROR(("%s: no handler registered, will not enable\n",
-			__func__));
-		return -EINVAL;
-	}
-
-	/* Ensure atomicity for enable/disable calls */
-	spin_lock_irqsave(&sdos->lock, flags);
-
-	sd->client_intr_enabled = enable;
-	if (enable)
-		brcmf_sdioh_dev_intr_on(sd);
-	else
-		brcmf_sdioh_dev_intr_off(sd);
-
-	spin_unlock_irqrestore(&sdos->lock, flags);
-
-	return 0;
-}
-
 /*
  * module init
 */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 4fc17f8..126090b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -655,7 +655,6 @@ struct brcmf_bus {
 	bool intr;		/* Use interrupts */
 	bool poll;		/* Use polling */
 	bool ipend;		/* Device interrupt is pending */
-	bool intdis;		/* Interrupts disabled by isr */
 	uint intrcount;		/* Count of device interrupt callbacks */
 	uint lastintrs;		/* Count as of last watchdog timer */
 	uint spurious;		/* Count of spurious interrupts */
@@ -1272,9 +1271,6 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		if (bus->dpc_sched || bus->rxskip || pktq_len(&bus->txq))
 			return -EBUSY;
 
-		/* Disable SDIO interrupts (no longer interested) */
-		brcmf_sdcard_intr_disable(bus->sdiodev);
-
 		/* Make sure the controller has the bus up */
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
@@ -1334,12 +1330,6 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 
 		/* Change state */
 		bus->sleeping = false;
-
-		/* Enable interrupts again */
-		if (bus->intr && (bus->drvr->busstate == BRCMF_BUS_DATA)) {
-			bus->intdis = false;
-			brcmf_sdcard_intr_enable(bus->sdiodev);
-		}
 	}
 
 	return 0;
@@ -2612,15 +2602,6 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 
 	case IOV_SVAL(IOV_INTR):
 		bus->intr = bool_val;
-		bus->intdis = false;
-		if (bus->drvr->up) {
-			BRCMF_INTR(("%s: %s SDIO interrupts\n", __func__,
-				    bus->intr ? "enable" : "disable"));
-			if (bus->intr)
-				brcmf_sdcard_intr_enable(bus->sdiodev);
-			else
-				brcmf_sdcard_intr_disable(bus->sdiodev);
-		}
 		break;
 
 	case IOV_GVAL(IOV_POLLRATE):
@@ -3294,7 +3275,6 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 
 	/* Turn off the bus (F2), free any pending packets */
 	BRCMF_INTR(("%s: disable SDIO interrupts\n", __func__));
-	brcmf_sdcard_intr_disable(bus->sdiodev);
 	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			 SDIO_FUNC_ENABLE_1, NULL);
 
@@ -3411,17 +3391,6 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 
 		/* Set bus state according to enable result */
 		drvr->busstate = BRCMF_BUS_DATA;
-
-		bus->intdis = false;
-		if (bus->intr) {
-			BRCMF_INTR(("%s: enable SDIO device interrupts\n",
-				    __func__));
-			brcmf_sdcard_intr_enable(bus->sdiodev);
-		} else {
-			BRCMF_INTR(("%s: disable SDIO interrupts\n", __func__));
-			brcmf_sdcard_intr_disable(bus->sdiodev);
-		}
-
 	}
 
 	else {
@@ -4854,17 +4823,6 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 	bus->intstatus = intstatus;
 
 clkwait:
-	/* Re-enable interrupts to detect new device events (mailbox, rx frame)
-	 * or clock availability.  (Allows tx loop to check ipend if desired.)
-	 * (Unless register access seems hosed, as we may not be able to ACK...)
-	 */
-	if (bus->intr && bus->intdis && !brcmf_sdcard_regfail(bus->sdiodev)) {
-		BRCMF_INTR(("%s: enable SDIO interrupts, rxdone %d"
-			    " framecnt %d\n", __func__, rxdone, framecnt));
-		bus->intdis = false;
-		brcmf_sdcard_intr_enable(bus->sdiodev);
-	}
-
 	if (DATAOK(bus) && bus->ctrl_frame_stat &&
 		(bus->clkstate == CLK_AVAIL)) {
 		int ret, i;
@@ -4982,14 +4940,9 @@ void brcmf_sdbrcm_isr(void *arg)
 	}
 
 	/* Disable additional interrupts (is this needed now)? */
-	if (bus->intr)
-		BRCMF_INTR(("%s: disable SDIO interrupts\n", __func__));
-	else
+	if (!bus->intr)
 		BRCMF_ERROR(("brcmf_sdbrcm_isr() w/o interrupt configured!\n"));
 
-	brcmf_sdcard_intr_disable(bus->sdiodev);
-	bus->intdis = true;
-
 #if defined(SDIO_ISR_THREAD)
 	BRCMF_TRACE(("Calling brcmf_sdbrcm_dpc() from %s\n", __func__));
 	while (brcmf_sdbrcm_dpc(bus))
@@ -5305,8 +5258,6 @@ extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 			if (intstatus) {
 				bus->pollcnt++;
 				bus->ipend = true;
-				if (bus->intr)
-					brcmf_sdcard_intr_disable(bus->sdiodev);
 
 				bus->dpc_sched = true;
 				brcmf_sdbrcm_sched_dpc(bus);
@@ -5555,7 +5506,6 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	/* Register interrupt callback, but mask it (not operational yet). */
 	BRCMF_INTR(("%s: disable SDIO interrupts (not interested yet)\n",
 		    __func__));
-	brcmf_sdcard_intr_disable(bus->sdiodev);
 	ret = brcmf_sdcard_intr_reg(bus->sdiodev, brcmf_sdbrcm_isr, bus);
 	if (ret != 0) {
 		BRCMF_ERROR(("%s: FAILED: sdcard_intr_reg returned %d\n",
@@ -5804,7 +5754,6 @@ static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
 
 	if (bus) {
 		/* De-register interrupt handler */
-		brcmf_sdcard_intr_disable(bus->sdiodev);
 		brcmf_sdcard_intr_dereg(bus->sdiodev);
 
 		if (bus->drvr) {
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 3c97af4..4fcba2a 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -124,18 +124,14 @@ struct brcmf_sdreg {
 
 struct sdioh_info {
 	struct osl_info *osh;		/* osh handler */
-	bool client_intr_enabled;	/* interrupt connnected flag */
 	bool intr_handler_valid; /* client driver interrupt handler valid */
 	void (*intr_handler)(void *);	/* registered interrupt handler */
 	void *intr_handler_arg;	/* argument to call interrupt handler */
-	u16 intmask;		/* Current active interrupts */
-	void *sdos_info;	/* Pointer to per-OS private data */
 
 	uint irq;		/* Client irq */
 	int intrcount;		/* Client interrupts */
 	bool sd_blockmode;	/* sd_blockmode == false => 64 Byte Cmd 53s. */
 	/*  Must be on for sd_multiblock to be effective */
-	bool use_client_ints;	/* If this is false, make sure to restore */
 	int client_block_size[SDIOD_MAX_IOFUNCS];	/* Blocksize */
 	u8 num_funcs;	/* Supported funcs on client */
 	u32 com_cis_ptr;
@@ -161,10 +157,6 @@ struct brcmf_sdio_dev {
 	void *bus;
 };
 
-/* Enable/disable SD interrupt */
-extern int brcmf_sdcard_intr_enable(struct brcmf_sdio_dev *sdiodev);
-extern int brcmf_sdcard_intr_disable(struct brcmf_sdio_dev *sdiodev);
-
 /* Register/deregister device interrupt handler. */
 extern int
 brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev,
@@ -278,14 +270,6 @@ extern int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev);
 /* Function to return current window addr */
 extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev);
 
-/* Allocate/init/free per-OS private data */
-extern int  brcmf_sdioh_osinit(struct sdioh_info *sd);
-extern void brcmf_sdioh_osfree(struct sdioh_info *sd);
-
-/* Core interrupt enable/disable of device interrupts */
-extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
-extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
-
 /* attach, return handler on success, NULL if failed.
  *  The handler shall be provided by all subsequent calls. No local cache
  *  cfghdl points to the starting address of pci device mapped memory
@@ -299,10 +283,6 @@ brcmf_sdioh_interrupt_register(struct sdioh_info *si,
 
 extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *si);
 
-/* enable or disable SD interrupt */
-extern int
-brcmf_sdioh_interrupt_set(struct sdioh_info *si, bool enable_disable);
-
 /* read or write one byte using cmd52 */
 extern int
 brcmf_sdioh_request_byte(struct sdioh_info *si, uint rw, uint fnc, uint addr,
-- 
1.7.4.1


