Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1890 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab2IMTMY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:12:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/10] brcmfmac: remove obsolete sdio bus sleep
 mechanism
Date: Thu, 13 Sep 2012 21:11:58 +0200
Message-ID: <1347563526-12513-3-git-send-email-arend@broadcom.com> (sfid-20120913_211236_299847_301AAE2B)
In-Reply-To: <1347563526-12513-1-git-send-email-arend@broadcom.com>
References: <1347563526-12513-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove sdio bus sleep mechanism since it is never invoked.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   93 --------------------
 1 file changed, 93 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 4580ff3..2ca9e8c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -549,7 +549,6 @@ struct brcmf_sdio {
 	s32 idleclock;	/* How to set bus driver when idle */
 	s32 sd_rxchain;
 	bool use_rxchain;	/* If brcmf should use PKT chains */
-	bool sleeping;		/* Is SDIO bus sleeping? */
 	bool rxflow_mode;	/* Rx flow control mode */
 	bool rxflow;		/* Is rx flow control on */
 	bool alp_only;		/* Don't use HT clock (ALP only) */
@@ -853,81 +852,6 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 	return 0;
 }
 
-static int brcmf_sdbrcm_bussleep(struct brcmf_sdio *bus, bool sleep)
-{
-	int ret;
-
-	brcmf_dbg(INFO, "request %s (currently %s)\n",
-		  sleep ? "SLEEP" : "WAKE",
-		  bus->sleeping ? "SLEEP" : "WAKE");
-
-	/* Done if we're already in the requested state */
-	if (sleep == bus->sleeping)
-		return 0;
-
-	/* Going to sleep: set the alarm and turn off the lights... */
-	if (sleep) {
-		/* Don't sleep if something is pending */
-		if (bus->dpc_sched || bus->rxskip || pktq_len(&bus->txq))
-			return -EBUSY;
-
-		/* Make sure the controller has the bus up */
-		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-
-		/* Tell device to start using OOB wakeup */
-		ret = w_sdreg32(bus, SMB_USE_OOB,
-				offsetof(struct sdpcmd_regs, tosbmailbox));
-		if (ret != 0)
-			brcmf_dbg(ERROR, "CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n");
-
-		/* Turn off our contribution to the HT clock request */
-		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
-
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				 SBSDIO_FORCE_HW_CLKREQ_OFF, NULL);
-
-		/* Isolate the bus */
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
-				 SBSDIO_DEVCTL_PADS_ISO, NULL);
-
-		/* Change state */
-		bus->sleeping = true;
-
-	} else {
-		/* Waking up: bus power up is ok, set local state */
-
-		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				 0, NULL);
-
-		/* Make sure the controller has the bus up */
-		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-
-		/* Send misc interrupt to indicate OOB not needed */
-		ret = w_sdreg32(bus, 0,
-				offsetof(struct sdpcmd_regs, tosbmailboxdata));
-		if (ret == 0)
-			ret = w_sdreg32(bus, SMB_DEV_INT,
-				offsetof(struct sdpcmd_regs, tosbmailbox));
-
-		if (ret != 0)
-			brcmf_dbg(ERROR, "CANNOT SIGNAL CHIP TO CLEAR OOB!!\n");
-
-		/* Make sure we have SD bus access */
-		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
-
-		/* Change state */
-		bus->sleeping = false;
-	}
-
-	return 0;
-}
-
-static void bus_wake(struct brcmf_sdio *bus)
-{
-	if (bus->sleeping)
-		brcmf_sdbrcm_bussleep(bus, false);
-}
-
 static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 {
 	u32 intstatus = 0;
@@ -2267,8 +2191,6 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 
 	down(&bus->sdsem);
 
-	bus_wake(bus);
-
 	/* Enable clock for device interrupts */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
@@ -2404,8 +2326,6 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		}
 	}
 
-	bus_wake(bus);
-
 	/* Make sure backplane clock is on */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
 	if (bus->clkstate == CLK_PENDING)
@@ -2918,8 +2838,6 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	/* Need to lock here to protect txseq and SDIO tx calls */
 	down(&bus->sdsem);
 
-	bus_wake(bus);
-
 	/* Make sure backplane clock is on */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
@@ -3776,12 +3694,6 @@ void brcmf_sdbrcm_isr(void *arg)
 	bus->sdcnt.intrcount++;
 	bus->ipend = true;
 
-	/* Shouldn't get this interrupt if we're sleeping? */
-	if (bus->sleeping) {
-		brcmf_dbg(ERROR, "INTERRUPT WHILE SLEEPING??\n");
-		return;
-	}
-
 	/* Disable additional interrupts (is this needed now)? */
 	if (!bus->intr)
 		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
@@ -3801,10 +3713,6 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TIMER, "Enter\n");
 
-	/* Ignore the timer if simulating bus down */
-	if (bus->sleeping)
-		return false;
-
 	down(&bus->sdsem);
 
 	/* Poll period: check device if appropriate. */
@@ -4024,7 +3932,6 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 			 SDIO_FUNC_ENABLE_1, NULL);
 
 	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
-	bus->sleeping = false;
 	bus->rxflow = false;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
-- 
1.7.9.5


