Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1530 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760987Ab1LQChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 19/30] brcm80211: fmac: stop referencing brcmf_pub in
 bus layer
Date: Fri, 16 Dec 2011 18:37:09 -0800
Message-ID: <1324089440-8957-20-git-send-email-frankyl@broadcom.com> (sfid-20111217_035945_085491_29F4006A)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_pub is the data structure for common layer. Since brcmf_bus
should be the only structure shared by common layer and bus layer,
stop referencing brcmf_pub from bus layer. This patch is part of
the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    4 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   15 ++++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   43 +++++++++-----------
 3 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 980bf70..dcb1bb5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -669,8 +669,8 @@ extern uint brcmf_c_mkiovar(char *name, char *data, uint datalen,
  * Returned structure should have bus and prot pointers filled in.
  * bus_hdrlen specifies required headroom for bus module header.
  */
-extern struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus,
-				      uint bus_hdrlen, struct device *dev);
+extern int brcmf_attach(struct brcmf_sdio *bus,
+			uint bus_hdrlen, struct device *dev);
 extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 130cab1..533418e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -922,17 +922,18 @@ void brcmf_del_if(struct brcmf_pub *drvr, int ifidx)
 	}
 }
 
-struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen,
+int brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen,
 			       struct device *dev)
 {
 	struct brcmf_pub *drvr = NULL;
+	int ret = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Allocate primary brcmf_info */
 	drvr = kzalloc(sizeof(struct brcmf_pub), GFP_ATOMIC);
 	if (!drvr)
-		goto fail;
+		return -ENOMEM;
 
 	mutex_init(&drvr->proto_block);
 
@@ -944,7 +945,8 @@ struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen,
 	drvr->dev = dev;
 
 	/* Attach and link in the protocol */
-	if (brcmf_proto_attach(drvr) != 0) {
+	ret = brcmf_proto_attach(drvr);
+	if (ret != 0) {
 		brcmf_dbg(ERROR, "brcmf_prot_attach failed\n");
 		goto fail;
 	}
@@ -952,13 +954,12 @@ struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen,
 	INIT_WORK(&drvr->setmacaddr_work, _brcmf_set_mac_address);
 	INIT_WORK(&drvr->multicast_work, _brcmf_set_multicast_list);
 
-	return drvr;
+	return ret;
 
 fail:
-	if (drvr)
-		brcmf_detach(dev);
+	brcmf_detach(dev);
 
-	return NULL;
+	return ret;
 }
 
 int brcmf_bus_start(struct device *dev)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a7fe00f..399567f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -450,8 +450,6 @@ struct sdpcm_shared_le {
 /* misc chip info needed by some of the routines */
 /* Private data for SDIO bus interaction */
 struct brcmf_sdio {
-	struct brcmf_pub *drvr;
-
 	struct brcmf_sdio_dev *sdiodev;	/* sdio device handler */
 	struct chip_info *ci;	/* Chip info struct */
 	char *vars;		/* Variables (from CIS and/or other) */
@@ -1077,7 +1075,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 
 	/* If we can't reach the device, signal failure */
 	if (err || brcmf_sdcard_regfail(bus->sdiodev))
-		bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
+		bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 }
 
 /* copy a buffer into a pkt buffer chain */
@@ -1724,7 +1722,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 
 	for (rxseq = bus->rx_seq, rxleft = maxframes;
 	     !bus->rxskip && rxleft &&
-	     bus->drvr->bus_if->state != BRCMF_BUS_DOWN;
+	     bus->sdiodev->bus_if->state != BRCMF_BUS_DOWN;
 	     rxseq++, rxleft--) {
 
 		/* Handle glomming separately */
@@ -2259,8 +2257,6 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	uint datalen;
 	u8 tx_prec_map;
 
-	struct brcmf_pub *drvr = bus->drvr;
-
 	brcmf_dbg(TRACE, "Enter\n");
 
 	tx_prec_map = ~bus->flowcontrol;
@@ -2297,8 +2293,8 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	}
 
 	/* Deflow-control stack if needed */
-	if (drvr->bus_if->drvr_up &&
-	    (drvr->bus_if->state == BRCMF_BUS_DATA) &&
+	if (bus->sdiodev->bus_if->drvr_up &&
+	    (bus->sdiodev->bus_if->state == BRCMF_BUS_DATA) &&
 	    bus->txoff && (pktq_len(&bus->txq) < TXLOW)) {
 		bus->txoff = OFF;
 		brcmf_txflowcontrol(bus->sdiodev->dev, 0, OFF);
@@ -2335,7 +2331,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 					       SBSDIO_DEVICE_CTL, &err);
 		if (err) {
 			brcmf_dbg(ERROR, "error reading DEVCTL: %d\n", err);
-			bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
+			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		}
 #endif				/* BCMDBG */
 
@@ -2345,7 +2341,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		if (err) {
 			brcmf_dbg(ERROR, "error reading CSR: %d\n",
 				  err);
-			bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
+			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		}
 
 		brcmf_dbg(INFO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
@@ -2358,7 +2354,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			if (err) {
 				brcmf_dbg(ERROR, "error reading DEVCTL: %d\n",
 					  err);
-				bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
+				bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
@@ -2366,7 +2362,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			if (err) {
 				brcmf_dbg(ERROR, "error writing DEVCTL: %d\n",
 					  err);
-				bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
+				bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 			}
 			bus->clkstate = CLK_AVAIL;
 		} else {
@@ -2522,11 +2518,11 @@ clkwait:
 		 else await next interrupt */
 	/* On failed register access, all bets are off:
 		 no resched or interrupts */
-	if ((bus->drvr->bus_if->state == BRCMF_BUS_DOWN) ||
+	if ((bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) ||
 	    brcmf_sdcard_regfail(bus->sdiodev)) {
 		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting operation %d\n",
 			  brcmf_sdcard_regfail(bus->sdiodev));
-		bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
+		bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
 		brcmf_dbg(INFO, "rescheduled due to CLK_PENDING awaiting I_CHIPACTIVE interrupt\n");
@@ -2563,7 +2559,7 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 		if (!wait_for_completion_interruptible(&bus->dpc_wait)) {
 			/* Call bus dpc unless it indicated down
 			(then clean stop) */
-			if (bus->drvr->bus_if->state != BRCMF_BUS_DOWN) {
+			if (bus->sdiodev->bus_if->state != BRCMF_BUS_DOWN) {
 				if (brcmf_sdbrcm_dpc(bus))
 					complete(&bus->dpc_wait);
 			} else {
@@ -3137,7 +3133,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
 
-		bus->drvr->bus_if->state = BRCMF_BUS_LOAD;
+		bus->sdiodev->bus_if->state = BRCMF_BUS_LOAD;
 	}
 fail:
 	return bcmerror;
@@ -3383,7 +3379,7 @@ void brcmf_sdbrcm_bus_stop(struct device *dev)
 	bus->hostintmask = 0;
 
 	/* Change our idea of bus state */
-	bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
+	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
 	saveclk = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
@@ -3446,7 +3442,7 @@ int brcmf_sdbrcm_bus_init(struct device *dev)
 			return -1;
 	}
 
-	if (!bus->drvr)
+	if (!bus->sdiodev->bus_if->drvr)
 		return 0;
 
 	/* Start the watchdog timer */
@@ -3542,7 +3538,7 @@ void brcmf_sdbrcm_isr(void *arg)
 		return;
 	}
 
-	if (bus->drvr->bus_if->state == BRCMF_BUS_DOWN) {
+	if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) {
 		brcmf_dbg(ERROR, "bus is down. we have nothing to do\n");
 		return;
 	}
@@ -3798,7 +3794,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			       SDIO_FUNC_ENABLE_1, NULL);
 
-	bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
+	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 	bus->sleeping = false;
 	bus->rxflow = false;
 
@@ -3884,7 +3880,6 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 		if (bus->sdiodev->bus_if->drvr) {
 			brcmf_detach(bus->sdiodev->dev);
 			brcmf_sdbrcm_release_dongle(bus);
-			bus->drvr = NULL;
 		}
 
 		brcmf_sdbrcm_release_malloc(bus);
@@ -3958,8 +3953,8 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	}
 
 	/* Attach to the brcmf/OS/network interface */
-	bus->drvr = brcmf_attach(bus, SDPCM_RESERVE, bus->sdiodev->dev);
-	if (!bus->drvr) {
+	ret = brcmf_attach(bus, SDPCM_RESERVE, bus->sdiodev->dev);
+	if (ret != 0) {
 		brcmf_dbg(ERROR, "brcmf_attach failed\n");
 		goto fail;
 	}
@@ -4032,7 +4027,7 @@ brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 	}
 
 	/* don't start the wd until fw is loaded */
-	if (bus->drvr->bus_if->state == BRCMF_BUS_DOWN)
+	if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN)
 		return;
 
 	if (wdtick) {
-- 
1.7.5.4


