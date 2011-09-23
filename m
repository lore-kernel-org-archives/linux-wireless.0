Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2435 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab1IWAIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:15 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 12/19] staging: brcm80211: remove global variables
 for data frame boundary
Date: Thu, 22 Sep 2011 17:07:49 -0700
Message-ID: <1316736476-23725-13-git-send-email-frankyl@broadcom.com> (sfid-20110923_020828_023807_4C5C5E59)
In-Reply-To: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
References: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put boundary settings in brcmf_bus structure

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h  |    4 ----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   24 ++++++++++--------------
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 104c0e7..a5064f5 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -27,10 +27,6 @@
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
 
-/* Tx/Rx bounds module parameters */
-extern uint brcmf_txbound;
-extern uint brcmf_rxbound;
-
 /* Indicate (dis)interest in finding dongles. */
 extern int brcmf_bus_register(void);
 extern void brcmf_bus_unregister(void);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 57049ec..66ab752 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -588,6 +588,10 @@ struct brcmf_bus {
 	u8 rx_seq;		/* Receive sequence number (expected) */
 	bool rxskip;		/* Skip receive (awaiting NAK ACK) */
 
+	uint rxbound;		/* Rx frames to read before resched */
+	uint txbound;		/* Tx frames to send before resched */
+	uint txminmax;
+
 	struct sk_buff *glomd;	/* Packet containing glomming descriptor */
 	struct sk_buff *glom;	/* Packet chain for glommed superframe */
 	uint glomerr;		/* Glom packet read errors */
@@ -740,13 +744,6 @@ module_param(brcmf_watchdog_prio, int, 0);
 int brcmf_dpc_prio = 98;
 module_param(brcmf_dpc_prio, int, 0);
 
-/* Tx/Rx bounds */
-uint brcmf_txbound;
-uint brcmf_rxbound;
-module_param(brcmf_txbound, uint, 0);
-module_param(brcmf_rxbound, uint, 0);
-static uint brcmf_txminmax;
-
 #define SDIO_DRIVE_STRENGTH	6	/* in milliamps */
 
 /* Use polling */
@@ -2488,8 +2485,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 {
 	u32 intstatus, newstatus = 0;
 	uint retries = 0;
-	uint rxlimit = brcmf_rxbound;	/* Rx frames to read before resched */
-	uint txlimit = brcmf_txbound;	/* Tx frames to send before resched */
+	uint rxlimit = bus->rxbound;	/* Rx frames to read before resched */
+	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
 	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
 	bool rxdone = true;	/* Flag for no more read data */
 	bool resched = false;	/* Flag indicating resched wanted */
@@ -2690,7 +2687,7 @@ clkwait:
 	else if ((bus->clkstate == CLK_AVAIL) && !bus->fcstate &&
 		 brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
 		 && data_ok(bus)) {
-		framecnt = rxdone ? txlimit : min(txlimit, brcmf_txminmax);
+		framecnt = rxdone ? txlimit : min(txlimit, bus->txminmax);
 		framecnt = brcmf_sdbrcm_sendfromq(bus, framecnt);
 		txlimit -= framecnt;
 	}
@@ -4779,10 +4776,6 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	 * first time that the driver is initialized vs subsequent
 	 * initializations.
 	 */
-	brcmf_txbound = BRCMF_TXBOUND;
-	brcmf_rxbound = BRCMF_RXBOUND;
-	brcmf_txminmax = BRCMF_TXMINMAX;
-
 	brcmf_c_init();
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -4798,6 +4791,9 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	}
 	bus->sdiodev = sdiodev;
 	sdiodev->bus = bus;
+	bus->txbound = BRCMF_TXBOUND;
+	bus->rxbound = BRCMF_RXBOUND;
+	bus->txminmax = BRCMF_TXMINMAX;
 	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
 	bus->usebufpool = false;	/* Use bufpool if allocated,
 					 else use locally malloced rxbuf */
-- 
1.7.1


