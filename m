Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:53739 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbaCOQSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 12:18:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/5] brcmfmac: Protect tx seq number for data and control
Date: Sat, 15 Mar 2014 17:18:18 +0100
Message-ID: <1394900301-15417-3-git-send-email-arend@broadcom.com> (sfid-20140315_171832_932975_336A1DBA)
In-Reply-To: <1394900301-15417-1-git-send-email-arend@broadcom.com>
References: <1394900301-15417-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

SDIO tx uses a sequence number which is common for data
and control. This requires that access to this sequence number
is protected. A mutex was used to achieve this, but it also
required the reordering of code for tx control.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  214 ++++++++++----------
 1 file changed, 108 insertions(+), 106 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 4aa8678..bcdaf72 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -458,10 +458,11 @@ struct brcmf_sdio {
 	bool alp_only;		/* Don't use HT clock (ALP only) */
 
 	u8 *ctrl_frame_buf;
-	u32 ctrl_frame_len;
+	u16 ctrl_frame_len;
 	bool ctrl_frame_stat;
 
-	spinlock_t txqlock;
+	spinlock_t txq_lock;		/* protect bus->txq */
+	struct semaphore tx_seq_lock;	/* protect bus->tx_seq */
 	wait_queue_head_t ctrl_wait;
 	wait_queue_head_t dcmd_resp_wait;
 
@@ -2316,13 +2317,15 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	/* Send frames until the limit or some other event */
 	for (cnt = 0; (cnt < maxframes) && data_ok(bus);) {
 		pkt_num = 1;
-		__skb_queue_head_init(&pktq);
+		if (down_interruptible(&bus->tx_seq_lock))
+			return cnt;
 		if (bus->txglom)
 			pkt_num = min_t(u8, bus->tx_max - bus->tx_seq,
 					bus->sdiodev->txglomsz);
 		pkt_num = min_t(u32, pkt_num,
 				brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol));
-		spin_lock_bh(&bus->txqlock);
+		__skb_queue_head_init(&pktq);
+		spin_lock_bh(&bus->txq_lock);
 		for (i = 0; i < pkt_num; i++) {
 			pkt = brcmu_pktq_mdeq(&bus->txq, tx_prec_map,
 					      &prec_out);
@@ -2330,11 +2333,15 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 				break;
 			__skb_queue_tail(&pktq, pkt);
 		}
-		spin_unlock_bh(&bus->txqlock);
-		if (i == 0)
+		spin_unlock_bh(&bus->txq_lock);
+		if (i == 0) {
+			up(&bus->tx_seq_lock);
 			break;
+		}
 
 		ret = brcmf_sdio_txpkt(bus, &pktq, SDPCM_DATA_CHANNEL);
+		up(&bus->tx_seq_lock);
+
 		cnt += i;
 
 		/* In poll mode, need to check for other events */
@@ -2363,6 +2370,68 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	return cnt;
 }
 
+static int brcmf_sdio_tx_ctrlframe(struct brcmf_sdio *bus, u8 *frame, u16 len)
+{
+	u8 doff;
+	u16 pad;
+	uint retries = 0;
+	struct brcmf_sdio_hdrinfo hd_info = {0};
+	int ret;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	/* Back the pointer to make room for bus header */
+	frame -= bus->tx_hdrlen;
+	len += bus->tx_hdrlen;
+
+	/* Add alignment padding (optional for ctl frames) */
+	doff = ((unsigned long)frame % bus->head_align);
+	if (doff) {
+		frame -= doff;
+		len += doff;
+		memset(frame + bus->tx_hdrlen, 0, doff);
+	}
+
+	/* Round send length to next SDIO block */
+	pad = 0;
+	if (bus->roundup && bus->blocksize && (len > bus->blocksize)) {
+		pad = bus->blocksize - (len % bus->blocksize);
+		if ((pad > bus->roundup) || (pad >= bus->blocksize))
+			pad = 0;
+	} else if (len % bus->head_align) {
+		pad = bus->head_align - (len % bus->head_align);
+	}
+	len += pad;
+
+	hd_info.len = len - pad;
+	hd_info.channel = SDPCM_CONTROL_CHANNEL;
+	hd_info.dat_offset = doff + bus->tx_hdrlen;
+	hd_info.seq_num = bus->tx_seq;
+	hd_info.lastfrm = true;
+	hd_info.tail_pad = pad;
+	brcmf_sdio_hdpack(bus, frame, &hd_info);
+
+	if (bus->txglom)
+		brcmf_sdio_update_hwhdr(frame, len);
+
+	brcmf_dbg_hex_dump(BRCMF_BYTES_ON() && BRCMF_CTL_ON(),
+			   frame, len, "Tx Frame:\n");
+	brcmf_dbg_hex_dump(!(BRCMF_BYTES_ON() && BRCMF_CTL_ON()) &&
+			   BRCMF_HDRS_ON(),
+			   frame, min_t(u16, len, 16), "TxHdr:\n");
+
+	do {
+		ret = brcmf_sdiod_send_buf(bus->sdiodev, frame, len);
+
+		if (ret < 0)
+			brcmf_sdio_txfail(bus);
+		else
+			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQ_WRAP;
+	} while (ret < 0 && retries++ < TXRETRIES);
+
+	return ret;
+}
+
 static void brcmf_sdio_bus_stop(struct device *dev)
 {
 	u32 local_hostintmask;
@@ -2596,26 +2665,23 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	brcmf_sdio_clrintr(bus);
 
-	if (data_ok(bus) && bus->ctrl_frame_stat &&
-	    (bus->clkstate == CLK_AVAIL)) {
-
-		sdio_claim_host(bus->sdiodev->func[1]);
-		err = brcmf_sdiod_send_buf(bus->sdiodev, bus->ctrl_frame_buf,
-					   (u32)bus->ctrl_frame_len);
-
-		if (err < 0)
-			brcmf_sdio_txfail(bus);
-		else
-			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQ_WRAP;
+	if (bus->ctrl_frame_stat && (bus->clkstate == CLK_AVAIL) &&
+	    (down_interruptible(&bus->tx_seq_lock) == 0)) {
+		if (data_ok(bus)) {
+			sdio_claim_host(bus->sdiodev->func[1]);
+			err = brcmf_sdio_tx_ctrlframe(bus,  bus->ctrl_frame_buf,
+						      bus->ctrl_frame_len);
+			sdio_release_host(bus->sdiodev->func[1]);
 
-		sdio_release_host(bus->sdiodev->func[1]);
-		bus->ctrl_frame_stat = false;
-		brcmf_sdio_wait_event_wakeup(bus);
+			bus->ctrl_frame_stat = false;
+			brcmf_sdio_wait_event_wakeup(bus);
+		}
+		up(&bus->tx_seq_lock);
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
-	else if ((bus->clkstate == CLK_AVAIL) && !atomic_read(&bus->fcstate) &&
-		 brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
-		 && data_ok(bus)) {
+	if ((bus->clkstate == CLK_AVAIL) && !atomic_read(&bus->fcstate) &&
+	    brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit &&
+	    data_ok(bus)) {
 		framecnt = bus->rxpending ? min(txlimit, bus->txminmax) :
 					    txlimit;
 		brcmf_sdio_sendfromq(bus, framecnt);
@@ -2649,7 +2715,6 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
-	ulong flags;
 
 	brcmf_dbg(TRACE, "Enter: pkt: data %p len %d\n", pkt->data, pkt->len);
 
@@ -2665,7 +2730,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	bus->sdcnt.fcqueued++;
 
 	/* Priority based enq */
-	spin_lock_irqsave(&bus->txqlock, flags);
+	spin_lock_bh(&bus->txq_lock);
 	/* reset bus_flags in packet cb */
 	*(u16 *)(pkt->cb) = 0;
 	if (!brcmf_c_prec_enq(bus->sdiodev->dev, &bus->txq, pkt, prec)) {
@@ -2680,7 +2745,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 		bus->txoff = true;
 		brcmf_txflowblock(bus->sdiodev->dev, true);
 	}
-	spin_unlock_irqrestore(&bus->txqlock, flags);
+	spin_unlock_bh(&bus->txq_lock);
 
 #ifdef DEBUG
 	if (pktq_plen(&bus->txq, prec) > qcount[prec])
@@ -2775,87 +2840,27 @@ break2:
 }
 #endif				/* DEBUG */
 
-static int brcmf_sdio_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
-{
-	int ret;
-
-	bus->ctrl_frame_stat = false;
-	ret = brcmf_sdiod_send_buf(bus->sdiodev, frame, len);
-
-	if (ret < 0)
-		brcmf_sdio_txfail(bus);
-	else
-		bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQ_WRAP;
-
-	return ret;
-}
-
 static int
 brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 {
-	u8 *frame;
-	u16 len, pad;
-	uint retries = 0;
-	u8 doff = 0;
-	int ret = -1;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
-	struct brcmf_sdio_hdrinfo hd_info = {0};
+	int ret = -1;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/* Back the pointer to make a room for bus header */
-	frame = msg - bus->tx_hdrlen;
-	len = (msglen += bus->tx_hdrlen);
-
-	/* Add alignment padding (optional for ctl frames) */
-	doff = ((unsigned long)frame % bus->head_align);
-	if (doff) {
-		frame -= doff;
-		len += doff;
-		msglen += doff;
-		memset(frame, 0, doff + bus->tx_hdrlen);
-	}
-	/* precondition: doff < bus->head_align */
-	doff += bus->tx_hdrlen;
-
-	/* Round send length to next SDIO block */
-	pad = 0;
-	if (bus->roundup && bus->blocksize && (len > bus->blocksize)) {
-		pad = bus->blocksize - (len % bus->blocksize);
-		if ((pad > bus->roundup) || (pad >= bus->blocksize))
-			pad = 0;
-	} else if (len % bus->head_align) {
-		pad = bus->head_align - (len % bus->head_align);
-	}
-	len += pad;
-
-	/* precondition: IS_ALIGNED((unsigned long)frame, 2) */
-
-	/* Make sure backplane clock is on */
-	sdio_claim_host(bus->sdiodev->func[1]);
-	brcmf_sdio_bus_sleep(bus, false, false);
-	sdio_release_host(bus->sdiodev->func[1]);
-
-	hd_info.len = (u16)msglen;
-	hd_info.channel = SDPCM_CONTROL_CHANNEL;
-	hd_info.dat_offset = doff;
-	hd_info.seq_num = bus->tx_seq;
-	hd_info.lastfrm = true;
-	hd_info.tail_pad = pad;
-	brcmf_sdio_hdpack(bus, frame, &hd_info);
-
-	if (bus->txglom)
-		brcmf_sdio_update_hwhdr(frame, len);
+	if (down_interruptible(&bus->tx_seq_lock))
+		return -EINTR;
 
 	if (!data_ok(bus)) {
 		brcmf_dbg(INFO, "No bus credit bus->tx_max %d, bus->tx_seq %d\n",
 			  bus->tx_max, bus->tx_seq);
-		bus->ctrl_frame_stat = true;
+		up(&bus->tx_seq_lock);
 		/* Send from dpc */
-		bus->ctrl_frame_buf = frame;
-		bus->ctrl_frame_len = len;
+		bus->ctrl_frame_buf = msg;
+		bus->ctrl_frame_len = msglen;
+		bus->ctrl_frame_stat = true;
 
 		wait_event_interruptible_timeout(bus->ctrl_wait,
 						 !bus->ctrl_frame_stat,
@@ -2866,22 +2871,18 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 			ret = 0;
 		} else {
 			brcmf_dbg(SDIO, "ctrl_frame_stat == true\n");
+			bus->ctrl_frame_stat = false;
+			if (down_interruptible(&bus->tx_seq_lock))
+				return -EINTR;
 			ret = -1;
 		}
 	}
-
 	if (ret == -1) {
-		brcmf_dbg_hex_dump(BRCMF_BYTES_ON() && BRCMF_CTL_ON(),
-				   frame, len, "Tx Frame:\n");
-		brcmf_dbg_hex_dump(!(BRCMF_BYTES_ON() && BRCMF_CTL_ON()) &&
-				   BRCMF_HDRS_ON(),
-				   frame, min_t(u16, len, 16), "TxHdr:\n");
-
-		do {
-			sdio_claim_host(bus->sdiodev->func[1]);
-			ret = brcmf_sdio_tx_frame(bus, frame, len);
-			sdio_release_host(bus->sdiodev->func[1]);
-		} while (ret < 0 && retries++ < TXRETRIES);
+		sdio_claim_host(bus->sdiodev->func[1]);
+		brcmf_sdio_bus_sleep(bus, false, false);
+		ret = brcmf_sdio_tx_ctrlframe(bus, msg, msglen);
+		sdio_release_host(bus->sdiodev->func[1]);
+		up(&bus->tx_seq_lock);
 	}
 
 	if (ret)
@@ -4052,7 +4053,8 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	spin_lock_init(&bus->rxctl_lock);
-	spin_lock_init(&bus->txqlock);
+	spin_lock_init(&bus->txq_lock);
+	sema_init(&bus->tx_seq_lock, 1);
 	init_waitqueue_head(&bus->ctrl_wait);
 	init_waitqueue_head(&bus->dcmd_resp_wait);
 
-- 
1.7.9.5

