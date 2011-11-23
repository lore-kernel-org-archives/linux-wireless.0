Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1652 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759497Ab1KWBWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:11 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 17/24] brcm80211: fmac: move busstate to struct
 brcmf_bus
Date: Tue, 22 Nov 2011 17:21:52 -0800
Message-ID: <1322011319-24863-18-git-send-email-frankyl@broadcom.com> (sfid-20111123_022252_302093_A83E72EE)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

busstate keeps track of the bus (USB/SDIO) status and is used by
both generic layer and bus layer. Move it to brcmf_bus helps to clean
up the interface. This patch is part of fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   18 +++++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   42 ++++++++++---------
 4 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index a557971..a104b74 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -574,6 +574,7 @@ struct brcmf_dcmd {
 struct brcmf_bus {
 	u8 type;		/* bus type */
 	void *bus_priv;		/* pointer to bus private structure */
+	enum brcmf_bus_state state;
 };
 
 /* Forward decls for struct brcmf_pub (see below) */
@@ -586,6 +587,7 @@ struct brcmf_cfg80211_dev; /* cfg80211 device info */
 struct brcmf_pub {
 	/* Linkage ponters */
 	struct brcmf_sdio *bus;
+	struct brcmf_bus *bus_if;
 	struct brcmf_proto *prot;
 	struct brcmf_info *info;
 	struct brcmf_cfg80211_dev *config;
@@ -593,7 +595,6 @@ struct brcmf_pub {
 	/* Internal brcmf items */
 	bool up;		/* Driver up/down (to OS) */
 	bool txoff;		/* Transmit flow-controlled */
-	enum brcmf_bus_state busstate;
 	uint hdrlen;		/* Total BRCMF header length (proto + bus) */
 	uint maxctl;		/* Max size rxctl request from proto to bus */
 	uint rxsz;		/* Rx buffer size bus module should use */
@@ -661,7 +662,6 @@ struct brcmf_pub {
 
 	u8 country_code[BRCM_CNTRY_BUF_SZ];
 	char eventmask[BRCMF_EVENTING_MASK_LEN];
-
 };
 
 struct brcmf_if_event {
@@ -687,7 +687,7 @@ extern uint brcmf_c_mkiovar(char *name, char *data, uint datalen,
  * bus_hdrlen specifies required headroom for bus module header.
  */
 extern struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus,
-				      uint bus_hdrlen);
+				      uint bus_hdrlen, struct device *dev);
 extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index e34c5c3..8e46bc6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -280,7 +280,7 @@ brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx, struct brcmf_dcmd *dcmd,
 	struct brcmf_proto *prot = drvr->prot;
 	int ret = -1;
 
-	if (drvr->busstate == BRCMF_BUS_DOWN) {
+	if (drvr->bus_if->state == BRCMF_BUS_DOWN) {
 		brcmf_dbg(ERROR, "bus is down. we have nothing to do.\n");
 		return ret;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index e8f7f78..c13b30f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -292,7 +292,7 @@ int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
 	struct brcmf_info *drvr_priv = drvr->info;
 
 	/* Reject if down */
-	if (!drvr->up || (drvr->busstate == BRCMF_BUS_DOWN))
+	if (!drvr->up || (drvr->bus_if->state == BRCMF_BUS_DOWN))
 		return -ENODEV;
 
 	/* Update multicast statistic */
@@ -322,9 +322,11 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Reject if down */
-	if (!drvr_priv->pub.up || (drvr_priv->pub.busstate == BRCMF_BUS_DOWN)) {
-		brcmf_dbg(ERROR, "xmit rejected pub.up=%d busstate=%d\n",
-			  drvr_priv->pub.up, drvr_priv->pub.busstate);
+	if (!drvr_priv->pub.up ||
+	    (drvr_priv->pub.bus_if->state == BRCMF_BUS_DOWN)) {
+		brcmf_dbg(ERROR, "xmit rejected pub.up=%d state=%d\n",
+			  drvr_priv->pub.up,
+			  drvr_priv->pub.bus_if->state);
 		netif_stop_queue(ndev);
 		return -ENODEV;
 	}
@@ -761,7 +763,7 @@ s32 brcmf_exec_dcmd(struct net_device *ndev, u32 cmd, void *arg, u32 len)
 		buflen = min_t(uint, dcmd.len, BRCMF_DCMD_MAXLEN);
 
 	/* send to dongle (must be up, and wl) */
-	if ((drvr_priv->pub.busstate != BRCMF_BUS_DATA)) {
+	if ((drvr_priv->pub.bus_if->state != BRCMF_BUS_DATA)) {
 		brcmf_dbg(ERROR, "DONGLE_DOWN\n");
 		err = -EIO;
 		goto done;
@@ -940,7 +942,8 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 	}
 }
 
-struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen)
+struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen,
+			       struct device *dev)
 {
 	struct brcmf_info *drvr_priv = NULL;
 
@@ -959,6 +962,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen)
 	/* Link to bus module */
 	drvr_priv->pub.bus = bus;
 	drvr_priv->pub.hdrlen = bus_hdrlen;
+	drvr_priv->pub.bus_if = dev_get_drvdata(dev);
 
 	/* Attach and link in the protocol */
 	if (brcmf_proto_attach(&drvr_priv->pub) != 0) {
@@ -995,7 +999,7 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 	}
 
 	/* If bus is not ready, can't come up */
-	if (drvr_priv->pub.busstate != BRCMF_BUS_DATA) {
+	if (drvr_priv->pub.bus_if->state != BRCMF_BUS_DATA) {
 		brcmf_dbg(ERROR, "failed bus is not ready\n");
 		return -ENODEV;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 9ab906a..7c8b5f7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1068,7 +1068,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 
 	/* If we can't reach the device, signal failure */
 	if (err || brcmf_sdcard_regfail(bus->sdiodev))
-		bus->drvr->busstate = BRCMF_BUS_DOWN;
+		bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
 }
 
 /* copy a buffer into a pkt buffer chain */
@@ -1714,7 +1714,8 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 	*finished = false;
 
 	for (rxseq = bus->rx_seq, rxleft = maxframes;
-	     !bus->rxskip && rxleft && bus->drvr->busstate != BRCMF_BUS_DOWN;
+	     !bus->rxskip && rxleft &&
+	     bus->drvr->bus_if->state != BRCMF_BUS_DOWN;
 	     rxseq++, rxleft--) {
 
 		/* Handle glomming separately */
@@ -2286,7 +2287,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	}
 
 	/* Deflow-control stack if needed */
-	if (drvr->up && (drvr->busstate == BRCMF_BUS_DATA) &&
+	if (drvr->up && (drvr->bus_if->state == BRCMF_BUS_DATA) &&
 	    drvr->txoff && (pktq_len(&bus->txq) < TXLOW))
 		brcmf_txflowcontrol(drvr, 0, OFF);
 
@@ -2321,7 +2322,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 					       SBSDIO_DEVICE_CTL, &err);
 		if (err) {
 			brcmf_dbg(ERROR, "error reading DEVCTL: %d\n", err);
-			bus->drvr->busstate = BRCMF_BUS_DOWN;
+			bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
 		}
 #endif				/* BCMDBG */
 
@@ -2331,7 +2332,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		if (err) {
 			brcmf_dbg(ERROR, "error reading CSR: %d\n",
 				  err);
-			bus->drvr->busstate = BRCMF_BUS_DOWN;
+			bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
 		}
 
 		brcmf_dbg(INFO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
@@ -2344,7 +2345,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			if (err) {
 				brcmf_dbg(ERROR, "error reading DEVCTL: %d\n",
 					  err);
-				bus->drvr->busstate = BRCMF_BUS_DOWN;
+				bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
@@ -2352,7 +2353,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			if (err) {
 				brcmf_dbg(ERROR, "error writing DEVCTL: %d\n",
 					  err);
-				bus->drvr->busstate = BRCMF_BUS_DOWN;
+				bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
 			}
 			bus->clkstate = CLK_AVAIL;
 		} else {
@@ -2508,11 +2509,11 @@ clkwait:
 		 else await next interrupt */
 	/* On failed register access, all bets are off:
 		 no resched or interrupts */
-	if ((bus->drvr->busstate == BRCMF_BUS_DOWN) ||
+	if ((bus->drvr->bus_if->state == BRCMF_BUS_DOWN) ||
 	    brcmf_sdcard_regfail(bus->sdiodev)) {
 		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting operation %d\n",
 			  brcmf_sdcard_regfail(bus->sdiodev));
-		bus->drvr->busstate = BRCMF_BUS_DOWN;
+		bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
 		brcmf_dbg(INFO, "rescheduled due to CLK_PENDING awaiting I_CHIPACTIVE interrupt\n");
@@ -2549,7 +2550,7 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 		if (!wait_for_completion_interruptible(&bus->dpc_wait)) {
 			/* Call bus dpc unless it indicated down
 			(then clean stop) */
-			if (bus->drvr->busstate != BRCMF_BUS_DOWN) {
+			if (bus->drvr->bus_if->state != BRCMF_BUS_DOWN) {
 				if (brcmf_sdbrcm_dpc(bus))
 					complete(&bus->dpc_wait);
 			} else {
@@ -3111,7 +3112,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
 
-		bus->drvr->busstate = BRCMF_BUS_LOAD;
+		bus->drvr->bus_if->state = BRCMF_BUS_LOAD;
 	}
 fail:
 	return bcmerror;
@@ -3354,7 +3355,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_sdio *bus)
 	bus->hostintmask = 0;
 
 	/* Change our idea of bus state */
-	bus->drvr->busstate = BRCMF_BUS_DOWN;
+	bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
 
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
 	saveclk = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
@@ -3410,7 +3411,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* try to download image and nvram to the dongle */
-	if (drvr->busstate == BRCMF_BUS_DOWN) {
+	if (drvr->bus_if->state == BRCMF_BUS_DOWN) {
 		if (!(brcmf_sdbrcm_download_firmware(bus)))
 			return -1;
 	}
@@ -3476,7 +3477,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr)
 				       SBSDIO_WATERMARK, 8, &err);
 
 		/* Set bus state according to enable result */
-		drvr->busstate = BRCMF_BUS_DATA;
+		drvr->bus_if->state = BRCMF_BUS_DATA;
 	}
 
 	else {
@@ -3491,7 +3492,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr)
 			       SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
 
 	/* If we didn't come up, turn off backplane clock */
-	if (drvr->busstate != BRCMF_BUS_DATA)
+	if (drvr->bus_if->state != BRCMF_BUS_DATA)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 
 exit:
@@ -3511,7 +3512,7 @@ void brcmf_sdbrcm_isr(void *arg)
 		return;
 	}
 
-	if (bus->drvr->busstate == BRCMF_BUS_DOWN) {
+	if (bus->drvr->bus_if->state == BRCMF_BUS_DOWN) {
 		brcmf_dbg(ERROR, "bus is down. we have nothing to do\n");
 		return;
 	}
@@ -3585,7 +3586,8 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 	}
 #ifdef BCMDBG
 	/* Poll for console output periodically */
-	if (drvr->busstate == BRCMF_BUS_DATA && bus->console_interval != 0) {
+	if (drvr->bus_if->state == BRCMF_BUS_DATA &&
+	    bus->console_interval != 0) {
 		bus->console.count += BRCMF_WD_POLL_MS;
 		if (bus->console.count >= bus->console_interval) {
 			bus->console.count -= bus->console_interval;
@@ -3764,7 +3766,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			       SDIO_FUNC_ENABLE_1, NULL);
 
-	bus->drvr->busstate = BRCMF_BUS_DOWN;
+	bus->drvr->bus_if->state = BRCMF_BUS_DOWN;
 	bus->sleeping = false;
 	bus->rxflow = false;
 
@@ -3924,7 +3926,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	}
 
 	/* Attach to the brcmf/OS/network interface */
-	bus->drvr = brcmf_attach(bus, SDPCM_RESERVE);
+	bus->drvr = brcmf_attach(bus, SDPCM_RESERVE, bus->sdiodev->dev);
 	if (!bus->drvr) {
 		brcmf_dbg(ERROR, "brcmf_attach failed\n");
 		goto fail;
@@ -4003,7 +4005,7 @@ brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 	}
 
 	/* don't start the wd until fw is loaded */
-	if (bus->drvr->busstate == BRCMF_BUS_DOWN)
+	if (bus->drvr->bus_if->state == BRCMF_BUS_DOWN)
 		return;
 
 	if (wdtick) {
-- 
1.7.5.4


