Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:42250 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaBYTaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:46 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/14] brcmfmac: Small cleanup of redundant code.
Date: Tue, 25 Feb 2014 20:30:33 +0100
Message-ID: <1393356639-19169-10-git-send-email-arend@broadcom.com> (sfid-20140225_203108_967392_5E1624B4)
In-Reply-To: <1393356639-19169-1-git-send-email-arend@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

In time some of the code got redundant, without being noticed.
This patch does not change any functionality, just removes
redundant code.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 04f5e32c..ac61419 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -770,8 +770,6 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 	return err;
 }
 
-#define PKT_AVAILABLE()		(intstatus & I_HMB_FRAME_IND)
-
 #define HOSTINTMASK		(I_HMB_SW_MASK | I_CHIPACTIVE)
 
 /* Turn backplane clock on or off */
@@ -870,7 +868,6 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		}
 #endif				/* defined (DEBUG) */
 
-		bus->activity = true;
 	} else {
 		clkreq = 0;
 
@@ -2341,7 +2338,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		cnt += i;
 
 		/* In poll mode, need to check for other events */
-		if (!bus->intr && cnt) {
+		if (!bus->intr) {
 			/* Check device status, signal pending interrupt */
 			sdio_claim_host(bus->sdiodev->func[1]);
 			ret = r_sdreg32(bus, &intstatus,
@@ -2485,9 +2482,8 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 {
 	u32 newstatus = 0;
 	unsigned long intstatus;
-	uint rxlimit = bus->rxbound;	/* Rx frames to read before resched */
 	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
-	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
+	uint framecnt;			/* Temporary counter of tx/rx frames */
 	int err = 0, n;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -2585,11 +2581,10 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		intstatus &= ~I_HMB_FRAME_IND;
 
 	/* On frame indication, read available frames */
-	if (PKT_AVAILABLE() && bus->clkstate == CLK_AVAIL) {
-		framecnt = brcmf_sdio_readframes(bus, rxlimit);
+	if ((intstatus & I_HMB_FRAME_IND) && (bus->clkstate == CLK_AVAIL)) {
+		brcmf_sdio_readframes(bus, bus->rxbound);
 		if (!bus->rxpending)
 			intstatus &= ~I_HMB_FRAME_IND;
-		rxlimit -= min(framecnt, rxlimit);
 	}
 
 	/* Keep still-pending events for next scheduling */
@@ -2647,8 +2642,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		 && data_ok(bus)) {
 		framecnt = bus->rxpending ? min(txlimit, bus->txminmax) :
 					    txlimit;
-		framecnt = brcmf_sdio_sendfromq(bus, framecnt);
-		txlimit -= framecnt;
+		brcmf_sdio_sendfromq(bus, framecnt);
 	}
 
 	if (!brcmf_bus_ready(bus->sdiodev->bus_if) || (err != 0)) {
@@ -2658,7 +2652,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		   atomic_read(&bus->ipend) > 0 ||
 		   (!atomic_read(&bus->fcstate) &&
 		    brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
-		    data_ok(bus)) || PKT_AVAILABLE()) {
+		    data_ok(bus))) {
 		atomic_inc(&bus->dpc_tskcnt);
 	}
 }
-- 
1.7.10.4

