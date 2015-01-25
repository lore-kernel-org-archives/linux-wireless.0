Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34025 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941AbbAYTbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:48 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/14] brcmfmac: use SDIO DPC for control frames.
Date: Sun, 25 Jan 2015 20:31:32 +0100
Message-ID: <1422214303-7816-4-git-send-email-arend@broadcom.com> (sfid-20150125_203159_928841_7FE1DD7C)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Control frames are normally handled outside DPC, but sometimes
within DPC. To simplify code always handle control within DPC.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 87 ++++++++++----------------
 1 file changed, 33 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 2c4f0cc..b4f5fe5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -44,7 +44,8 @@
 #include "chip.h"
 #include "firmware.h"
 
-#define DCMD_RESP_TIMEOUT  2000	/* In milli second */
+#define DCMD_RESP_TIMEOUT	2000	/* In milli second */
+#define CTL_DONE_TIMEOUT	2000	/* In milli second */
 
 #ifdef DEBUG
 
@@ -495,9 +496,9 @@ struct brcmf_sdio {
 	u8 *ctrl_frame_buf;
 	u16 ctrl_frame_len;
 	bool ctrl_frame_stat;
+	int ctrl_frame_err;
 
 	spinlock_t txq_lock;		/* protect bus->txq */
-	struct semaphore tx_seq_lock;	/* protect bus->tx_seq */
 	wait_queue_head_t ctrl_wait;
 	wait_queue_head_t dcmd_resp_wait;
 
@@ -2376,8 +2377,6 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	/* Send frames until the limit or some other event */
 	for (cnt = 0; (cnt < maxframes) && data_ok(bus);) {
 		pkt_num = 1;
-		if (down_interruptible(&bus->tx_seq_lock))
-			return cnt;
 		if (bus->txglom)
 			pkt_num = min_t(u8, bus->tx_max - bus->tx_seq,
 					bus->sdiodev->txglomsz);
@@ -2393,13 +2392,10 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 			__skb_queue_tail(&pktq, pkt);
 		}
 		spin_unlock_bh(&bus->txq_lock);
-		if (i == 0) {
-			up(&bus->tx_seq_lock);
+		if (i == 0)
 			break;
-		}
 
 		ret = brcmf_sdio_txpkt(bus, &pktq, SDPCM_DATA_CHANNEL);
-		up(&bus->tx_seq_lock);
 
 		cnt += i;
 
@@ -2743,17 +2739,14 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	brcmf_sdio_clrintr(bus);
 
 	if (bus->ctrl_frame_stat && (bus->clkstate == CLK_AVAIL) &&
-	    (down_interruptible(&bus->tx_seq_lock) == 0)) {
-		if (data_ok(bus)) {
-			sdio_claim_host(bus->sdiodev->func[1]);
-			err = brcmf_sdio_tx_ctrlframe(bus,  bus->ctrl_frame_buf,
-						      bus->ctrl_frame_len);
-			sdio_release_host(bus->sdiodev->func[1]);
-
-			bus->ctrl_frame_stat = false;
-			brcmf_sdio_wait_event_wakeup(bus);
-		}
-		up(&bus->tx_seq_lock);
+	    data_ok(bus)) {
+		sdio_claim_host(bus->sdiodev->func[1]);
+		err = brcmf_sdio_tx_ctrlframe(bus,  bus->ctrl_frame_buf,
+					      bus->ctrl_frame_len);
+		sdio_release_host(bus->sdiodev->func[1]);
+		bus->ctrl_frame_err = err;
+		bus->ctrl_frame_stat = false;
+		brcmf_sdio_wait_event_wakeup(bus);
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
 	if ((bus->clkstate == CLK_AVAIL) && !atomic_read(&bus->fcstate) &&
@@ -2965,43 +2958,30 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
-	int ret = -1;
+	int ret;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (down_interruptible(&bus->tx_seq_lock))
-		return -EINTR;
-
-	if (!data_ok(bus)) {
-		brcmf_dbg(INFO, "No bus credit bus->tx_max %d, bus->tx_seq %d\n",
-			  bus->tx_max, bus->tx_seq);
-		up(&bus->tx_seq_lock);
-		/* Send from dpc */
-		bus->ctrl_frame_buf = msg;
-		bus->ctrl_frame_len = msglen;
-		bus->ctrl_frame_stat = true;
-
-		wait_event_interruptible_timeout(bus->ctrl_wait,
-						 !bus->ctrl_frame_stat,
-						 msecs_to_jiffies(2000));
-
-		if (!bus->ctrl_frame_stat) {
-			brcmf_dbg(SDIO, "ctrl_frame_stat == false\n");
-			ret = 0;
-		} else {
-			brcmf_dbg(SDIO, "ctrl_frame_stat == true\n");
-			bus->ctrl_frame_stat = false;
-			if (down_interruptible(&bus->tx_seq_lock))
-				return -EINTR;
-			ret = -1;
-		}
+	/* Send from dpc */
+	bus->ctrl_frame_buf = msg;
+	bus->ctrl_frame_len = msglen;
+	bus->ctrl_frame_stat = true;
+	if (atomic_read(&bus->dpc_tskcnt) == 0) {
+		atomic_inc(&bus->dpc_tskcnt);
+		queue_work(bus->brcmf_wq, &bus->datawork);
 	}
-	if (ret == -1) {
-		sdio_claim_host(bus->sdiodev->func[1]);
-		brcmf_sdio_bus_sleep(bus, false, false);
-		ret = brcmf_sdio_tx_ctrlframe(bus, msg, msglen);
-		sdio_release_host(bus->sdiodev->func[1]);
-		up(&bus->tx_seq_lock);
+
+	wait_event_interruptible_timeout(bus->ctrl_wait, !bus->ctrl_frame_stat,
+					 msecs_to_jiffies(CTL_DONE_TIMEOUT));
+
+	if (!bus->ctrl_frame_stat) {
+		brcmf_dbg(SDIO, "ctrl_frame complete, err=%d\n",
+			  bus->ctrl_frame_err);
+		ret = bus->ctrl_frame_err;
+	} else {
+		brcmf_dbg(SDIO, "ctrl_frame timeout\n");
+		bus->ctrl_frame_stat = false;
+		ret = -ETIMEDOUT;
 	}
 
 	if (ret)
@@ -3009,7 +2989,7 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	else
 		bus->sdcnt.tx_ctlpkts++;
 
-	return ret ? -EIO : 0;
+	return ret;
 }
 
 #ifdef DEBUG
@@ -4165,7 +4145,6 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 
 	spin_lock_init(&bus->rxctl_lock);
 	spin_lock_init(&bus->txq_lock);
-	sema_init(&bus->tx_seq_lock, 1);
 	init_waitqueue_head(&bus->ctrl_wait);
 	init_waitqueue_head(&bus->dcmd_resp_wait);
 
-- 
1.9.1

