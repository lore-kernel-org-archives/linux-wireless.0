Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:32931 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbbCRMZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 08:25:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/8] brcmfmac: Add necessary memory barriers for SDIO.
Date: Wed, 18 Mar 2015 13:25:22 +0100
Message-ID: <1426681528-15831-3-git-send-email-arend@broadcom.com> (sfid-20150318_132601_828169_E1984D2D)
In-Reply-To: <1426681528-15831-1-git-send-email-arend@broadcom.com>
References: <1426681528-15831-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

SDIO uses a thread to handle all communication with the device,
for this data is exchanged between threads. This data needs proper
memory barriers to make sure that data "exchange" is going correct.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 57 +++++++++++++++-----------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 17a7212..38fa0e8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -507,8 +507,8 @@ struct brcmf_sdio {
 
 	struct workqueue_struct *brcmf_wq;
 	struct work_struct datawork;
-	atomic_t dpc_tskcnt;
-	atomic_t dpc_running;
+	bool dpc_triggered;
+	bool dpc_running;
 
 	bool txoff;		/* Transmit flow-controlled */
 	struct brcmf_sdio_count sdcnt;
@@ -2713,6 +2713,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 			err = brcmf_sdio_tx_ctrlframe(bus,  bus->ctrl_frame_buf,
 						      bus->ctrl_frame_len);
 			bus->ctrl_frame_err = err;
+			wmb();
 			bus->ctrl_frame_stat = false;
 		}
 		sdio_release_host(bus->sdiodev->func[1]);
@@ -2734,6 +2735,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 			sdio_claim_host(bus->sdiodev->func[1]);
 			if (bus->ctrl_frame_stat) {
 				bus->ctrl_frame_err = -ENODEV;
+				wmb();
 				bus->ctrl_frame_stat = false;
 				brcmf_sdio_wait_event_wakeup(bus);
 			}
@@ -2744,7 +2746,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		   (!atomic_read(&bus->fcstate) &&
 		    brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
 		    data_ok(bus))) {
-		atomic_inc(&bus->dpc_tskcnt);
+		bus->dpc_triggered = true;
 	}
 }
 
@@ -2940,6 +2942,7 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	/* Send from dpc */
 	bus->ctrl_frame_buf = msg;
 	bus->ctrl_frame_len = msglen;
+	wmb();
 	bus->ctrl_frame_stat = true;
 
 	brcmf_sdio_trigger_dpc(bus);
@@ -2958,6 +2961,7 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	if (!ret) {
 		brcmf_dbg(SDIO, "ctrl_frame complete, err=%d\n",
 			  bus->ctrl_frame_err);
+		rmb();
 		ret = bus->ctrl_frame_err;
 	}
 
@@ -3526,8 +3530,8 @@ done:
 
 void brcmf_sdio_trigger_dpc(struct brcmf_sdio *bus)
 {
-	if (atomic_read(&bus->dpc_tskcnt) == 0) {
-		atomic_inc(&bus->dpc_tskcnt);
+	if (!bus->dpc_triggered) {
+		bus->dpc_triggered = true;
 		queue_work(bus->brcmf_wq, &bus->datawork);
 	}
 }
@@ -3558,7 +3562,7 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus)
 	if (!bus->intr)
 		brcmf_err("isr w/o interrupt configured!\n");
 
-	atomic_inc(&bus->dpc_tskcnt);
+	bus->dpc_triggered = true;
 	queue_work(bus->brcmf_wq, &bus->datawork);
 }
 
@@ -3578,7 +3582,7 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 		if (!bus->intr ||
 		    (bus->sdcnt.intrcount == bus->sdcnt.lastintrs)) {
 
-			if (atomic_read(&bus->dpc_tskcnt) == 0) {
+			if (!bus->dpc_triggered) {
 				u8 devpend;
 
 				sdio_claim_host(bus->sdiodev->func[1]);
@@ -3596,7 +3600,7 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 				bus->sdcnt.pollcnt++;
 				atomic_set(&bus->ipend, 1);
 
-				atomic_inc(&bus->dpc_tskcnt);
+				bus->dpc_triggered = true;
 				queue_work(bus->brcmf_wq, &bus->datawork);
 			}
 		}
@@ -3623,17 +3627,21 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 #endif				/* DEBUG */
 
 	/* On idle timeout clear activity flag and/or turn off clock */
-	if ((atomic_read(&bus->dpc_tskcnt) == 0) &&
-	    (atomic_read(&bus->dpc_running) == 0) &&
-	    (bus->idletime > 0) && (bus->clkstate == CLK_AVAIL)) {
-		bus->idlecount++;
-		if (bus->idlecount > bus->idletime) {
-			brcmf_dbg(SDIO, "idle\n");
-			sdio_claim_host(bus->sdiodev->func[1]);
-			brcmf_sdio_wd_timer(bus, 0);
+	if (!bus->dpc_triggered) {
+		rmb();
+		if ((!bus->dpc_running) && (bus->idletime > 0) &&
+		    (bus->clkstate == CLK_AVAIL)) {
+			bus->idlecount++;
+			if (bus->idlecount > bus->idletime) {
+				brcmf_dbg(SDIO, "idle\n");
+				sdio_claim_host(bus->sdiodev->func[1]);
+				brcmf_sdio_wd_timer(bus, 0);
+				bus->idlecount = 0;
+				brcmf_sdio_bus_sleep(bus, true, false);
+				sdio_release_host(bus->sdiodev->func[1]);
+			}
+		} else {
 			bus->idlecount = 0;
-			brcmf_sdio_bus_sleep(bus, true, false);
-			sdio_release_host(bus->sdiodev->func[1]);
 		}
 	} else {
 		bus->idlecount = 0;
@@ -3645,13 +3653,14 @@ static void brcmf_sdio_dataworker(struct work_struct *work)
 	struct brcmf_sdio *bus = container_of(work, struct brcmf_sdio,
 					      datawork);
 
-	while (atomic_read(&bus->dpc_tskcnt)) {
-		atomic_set(&bus->dpc_running, 1);
-		atomic_set(&bus->dpc_tskcnt, 0);
+	bus->dpc_running = true;
+	wmb();
+	while (ACCESS_ONCE(bus->dpc_triggered)) {
+		bus->dpc_triggered = false;
 		brcmf_sdio_dpc(bus);
 		bus->idlecount = 0;
-		atomic_set(&bus->dpc_running, 0);
 	}
+	bus->dpc_running = false;
 	if (brcmf_sdiod_freezing(bus->sdiodev)) {
 		brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DOWN);
 		brcmf_sdiod_try_freeze(bus->sdiodev);
@@ -4144,8 +4153,8 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 		bus->watchdog_tsk = NULL;
 	}
 	/* Initialize DPC thread */
-	atomic_set(&bus->dpc_tskcnt, 0);
-	atomic_set(&bus->dpc_running, 0);
+	bus->dpc_triggered = false;
+	bus->dpc_running = false;
 
 	/* Assign bus interface call back */
 	bus->sdiodev->bus_if->dev = bus->sdiodev->dev;
-- 
1.9.1

