Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3004 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab2IMTMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:12:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/10] brcmfmac: streamline SDIO dpc
Date: Thu, 13 Sep 2012 21:12:01 +0200
Message-ID: <1347563526-12513-6-git-send-email-arend@broadcom.com> (sfid-20120913_211237_716044_67EE7A85)
In-Reply-To: <1347563526-12513-1-git-send-email-arend@broadcom.com>
References: <1347563526-12513-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Streamline SDIO dpc by removing some unnecessary code path.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   27 +++++---------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 1d80e05..90a3849 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2330,15 +2330,11 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 				bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 			}
 			bus->clkstate = CLK_AVAIL;
-		} else {
-			goto clkwait;
 		}
 	}
 
 	/* Make sure backplane clock is on */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
-	if (bus->clkstate == CLK_PENDING)
-		goto clkwait;
 
 	/* Pending interrupt indicates new device status */
 	if (atomic_read(&bus->ipend) > 0) {
@@ -2412,7 +2408,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		intstatus &= ~I_HMB_FRAME_IND;
 
 	/* On frame indication, read available frames */
-	if (PKT_AVAILABLE()) {
+	if (PKT_AVAILABLE() && bus->clkstate == CLK_AVAIL) {
 		framecnt = brcmf_sdbrcm_readframes(bus, rxlimit, &rxdone);
 		if (rxdone || bus->rxskip)
 			intstatus &= ~I_HMB_FRAME_IND;
@@ -2422,22 +2418,21 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	/* Keep still-pending events for next scheduling */
 	bus->intstatus = intstatus;
 
-clkwait:
 	brcmf_sdbrcm_clrintr(bus);
 
 	if (data_ok(bus) && bus->ctrl_frame_stat &&
 		(bus->clkstate == CLK_AVAIL)) {
-		int ret, i;
+		int i;
 
-		ret = brcmf_sdcard_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
+		err = brcmf_sdcard_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
 			SDIO_FUNC_2, F2SYNC, bus->ctrl_frame_buf,
 			(u32) bus->ctrl_frame_len);
 
-		if (ret < 0) {
+		if (err < 0) {
 			/* On failure, abort the command and
 				terminate the frame */
 			brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
-				  ret);
+				  err);
 			bus->sdcnt.tx_sderrs++;
 
 			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
@@ -2459,10 +2454,9 @@ clkwait:
 					break;
 			}
 
-		}
-		if (ret == 0)
+		} else {
 			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
-
+		}
 		bus->ctrl_frame_stat = false;
 		brcmf_sdbrcm_wait_event_wakeup(bus);
 	}
@@ -2475,17 +2469,10 @@ clkwait:
 		txlimit -= framecnt;
 	}
 
-	/* Resched if events or tx frames are pending,
-		 else await next interrupt */
-	/* On failed register access, all bets are off:
-		 no resched or interrupts */
 	if ((bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) || (err != 0)) {
 		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting operation\n");
 		bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		bus->intstatus = 0;
-	} else if (bus->clkstate == CLK_PENDING) {
-		brcmf_dbg(INFO, "rescheduled due to CLK_PENDING awaiting I_CHIPACTIVE interrupt\n");
-		brcmf_sdbrcm_adddpctsk(bus);
 	} else if (bus->intstatus || atomic_read(&bus->ipend) > 0 ||
 		(!bus->fcstate && brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol)
 		 && data_ok(bus)) || PKT_AVAILABLE()) {
-- 
1.7.9.5


