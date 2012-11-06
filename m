Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4511 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab2KFAWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:49 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/24] brcmfmac: decrease the range of SDIO access lock
Date: Mon, 5 Nov 2012 16:22:23 -0800
Message-ID: <1352161352-30405-16-git-send-email-frankyl@broadcom.com> (sfid-20121106_013117_505468_E5D3BCD4)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Semaphore sdsem which protects consecutive SDIO bus access is used
to lock down unnecessary wide range. Decrease the locking range
provides the capability of parallel processing.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   62 +++++++++++---------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 1d7a340..e328852 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1274,6 +1274,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		 * read directly into the chained packet, or allocate a large
 		 * packet and and copy into the chain.
 		 */
+		down(&bus->sdsem);
 		if (usechain) {
 			errcode = brcmf_sdcard_recv_chain(bus->sdiodev,
 					bus->sdiodev->sbwad,
@@ -1295,6 +1296,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				  dlen);
 			errcode = -1;
 		}
+		up(&bus->sdsem);
 		bus->sdcnt.f2rxdata++;
 
 		/* On failure, kill the superframe, allow a couple retries */
@@ -1399,11 +1401,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 					   pfirst->prev);
 		}
 		/* sent any remaining packets up */
-		if (bus->glom.qlen) {
-			up(&bus->sdsem);
+		if (bus->glom.qlen)
 			brcmf_rx_frame(bus->sdiodev->dev, ifidx, &bus->glom);
-			down(&bus->sdsem);
-		}
 
 		bus->sdcnt.rxglomframes++;
 		bus->sdcnt.rxglompkts += bus->glom.qlen;
@@ -1586,6 +1585,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 		rd->len_left = rd->len;
 		/* read header first for unknow frame length */
+		down(&bus->sdsem);
 		if (!rd->len) {
 			sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
 						      bus->sdiodev->sbwad,
@@ -1598,6 +1598,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  sdret);
 				bus->sdcnt.rx_hdrfail++;
 				brcmf_sdbrcm_rxfail(bus, true, true);
+				up(&bus->sdsem);
 				continue;
 			}
 
@@ -1607,6 +1608,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 			if (!brcmf_sdio_hdparser(bus, bus->rxhdr, rd,
 						 BRCMF_SDIO_FT_NORMAL)) {
+				up(&bus->sdsem);
 				if (!bus->rxpending)
 					break;
 				else
@@ -1622,6 +1624,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 				rd->len_nxtfrm = 0;
 				/* treat all packet as event if we don't know */
 				rd->channel = SDPCM_EVENT_CHANNEL;
+				up(&bus->sdsem);
 				continue;
 			}
 			rd->len_left = rd->len > BRCMF_FIRSTREAD ?
@@ -1639,6 +1642,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			bus->sdiodev->bus_if->dstats.rx_dropped++;
 			brcmf_sdbrcm_rxfail(bus, false,
 					    RETRYCHAN(rd->channel));
+			up(&bus->sdsem);
 			continue;
 		}
 		skb_pull(pkt, head_read);
@@ -1647,6 +1651,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		sdret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
 					      SDIO_FUNC_2, F2SYNC, pkt);
 		bus->sdcnt.f2rxdata++;
+		up(&bus->sdsem);
 
 		if (sdret < 0) {
 			brcmf_dbg(ERROR, "read %d bytes from channel %d failed: %d\n",
@@ -1749,10 +1754,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			continue;
 		}
 
-		/* Unlock during rx call */
-		up(&bus->sdsem);
 		brcmf_rx_packet(bus->sdiodev->dev, ifidx, pkt);
-		down(&bus->sdsem);
 	}
 
 	rxcount = maxframes - rxleft;
@@ -1772,9 +1774,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 static void
 brcmf_sdbrcm_wait_for_event(struct brcmf_sdio *bus, bool *lockvar)
 {
-	up(&bus->sdsem);
 	wait_event_interruptible_timeout(bus->ctrl_wait, !*lockvar, HZ * 2);
-	down(&bus->sdsem);
 	return;
 }
 
@@ -1879,6 +1879,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 	if (len & (ALIGNMENT - 1))
 			len = roundup(len, ALIGNMENT);
 
+	down(&bus->sdsem);
 	ret = brcmf_sdcard_send_pkt(bus->sdiodev, bus->sdiodev->sbwad,
 				    SDIO_FUNC_2, F2SYNC, pkt);
 	bus->sdcnt.f2txdata++;
@@ -1906,15 +1907,14 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 		}
 
 	}
+	up(&bus->sdsem);
 	if (ret == 0)
 		bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
 done:
 	/* restore pkt buffer pointer before calling tx complete routine */
 	skb_pull(pkt, SDPCM_HDRLEN + pad);
-	up(&bus->sdsem);
 	brcmf_txcomplete(bus->sdiodev->dev, pkt, ret != 0);
-	down(&bus->sdsem);
 
 	if (free_pkt)
 		brcmu_pkt_buf_free_skb(pkt);
@@ -1955,9 +1955,11 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		/* In poll mode, need to check for other events */
 		if (!bus->intr && cnt) {
 			/* Check device status, signal pending interrupt */
+			down(&bus->sdsem);
 			ret = r_sdreg32(bus, &intstatus,
 					offsetof(struct sdpcmd_regs,
 						 intstatus));
+			up(&bus->sdsem);
 			bus->sdcnt.f2txdata++;
 			if (ret != 0)
 				break;
@@ -2028,6 +2030,7 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 
 	/* Turn off the backplane clock (only) */
 	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
+	up(&bus->sdsem);
 
 	/* Clear the data packet queues */
 	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
@@ -2046,8 +2049,6 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	/* Reset some F2 state stuff */
 	bus->rxskip = false;
 	bus->tx_seq = bus->rx_seq = 0;
-
-	up(&bus->sdsem);
 }
 
 #ifdef CONFIG_BRCMFMAC_SDIO_OOB
@@ -2216,6 +2217,8 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		intstatus |= brcmf_sdbrcm_hostmail(bus);
 	}
 
+	up(&bus->sdsem);
+
 	/* Generally don't ask for these, can get CRC errors... */
 	if (intstatus & I_WR_OOSYNC) {
 		brcmf_dbg(ERROR, "Dongle reports WR_OOSYNC\n");
@@ -2262,6 +2265,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		(bus->clkstate == CLK_AVAIL)) {
 		int i;
 
+		down(&bus->sdsem);
 		err = brcmf_sdcard_send_buf(bus->sdiodev, bus->sdiodev->sbwad,
 			SDIO_FUNC_2, F2SYNC, bus->ctrl_frame_buf,
 			(u32) bus->ctrl_frame_len);
@@ -2295,6 +2299,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		} else {
 			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 		}
+		up(&bus->sdsem);
 		bus->ctrl_frame_stat = false;
 		brcmf_sdbrcm_wait_event_wakeup(bus);
 	}
@@ -2326,8 +2331,6 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		bus->activity = false;
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 	}
-
-	up(&bus->sdsem);
 }
 
 static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
@@ -2618,11 +2621,10 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 
 	/* precondition: IS_ALIGNED((unsigned long)frame, 2) */
 
-	/* Need to lock here to protect txseq and SDIO tx calls */
-	down(&bus->sdsem);
-
 	/* Make sure backplane clock is on */
+	down(&bus->sdsem);
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+	up(&bus->sdsem);
 
 	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
 	*(__le16 *) frame = cpu_to_le16((u16) msglen);
@@ -2664,7 +2666,9 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 				   frame, min_t(u16, len, 16), "TxHdr:\n");
 
 		do {
+			down(&bus->sdsem);
 			ret = brcmf_tx_frame(bus, frame, len);
+			up(&bus->sdsem);
 		} while (ret < 0 && retries++ < TXRETRIES);
 	}
 
@@ -2674,13 +2678,13 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 
 		bus->activity = false;
+		down(&bus->sdsem);
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
+		up(&bus->sdsem);
 	} else {
 		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 	}
 
-	up(&bus->sdsem);
-
 	if (ret)
 		bus->sdcnt.tx_ctlerrs++;
 	else
@@ -2710,8 +2714,10 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	 * Read last word in socram to determine
 	 * address of sdpcm_shared structure
 	 */
+	down(&bus->sdsem);
 	rv = brcmf_sdbrcm_membytes(bus, false, shaddr,
 				   (u8 *)&addr_le, 4);
+	up(&bus->sdsem);
 	if (rv < 0)
 		return rv;
 
@@ -2834,12 +2840,14 @@ static int brcmf_sdio_trap_info(struct brcmf_sdio *bus, struct sdpcm_shared *sh,
 	if ((sh->flags & SDPCM_SHARED_TRAP) == 0)
 		return 0;
 
+	down(&bus->sdsem);
 	error = brcmf_sdbrcm_membytes(bus, false, sh->trap_addr, (u8 *)&tr,
 				      sizeof(struct brcmf_trap_info));
 	if (error < 0)
 		return error;
 
 	nbytes = brcmf_sdio_dump_console(bus, sh, data, count);
+	up(&bus->sdsem);
 	if (nbytes < 0)
 		return nbytes;
 
@@ -2885,6 +2893,7 @@ static int brcmf_sdio_assert_info(struct brcmf_sdio *bus,
 		return 0;
 	}
 
+	down(&bus->sdsem);
 	if (sh->assert_file_addr != 0) {
 		error = brcmf_sdbrcm_membytes(bus, false, sh->assert_file_addr,
 					      (u8 *)file, 80);
@@ -2897,6 +2906,7 @@ static int brcmf_sdio_assert_info(struct brcmf_sdio *bus,
 		if (error < 0)
 			return error;
 	}
+	up(&bus->sdsem);
 
 	res = scnprintf(buf, sizeof(buf),
 			"dongle assert: %s:%d: assert(%s)\n",
@@ -2909,9 +2919,7 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_sdio *bus)
 	int error;
 	struct sdpcm_shared sh;
 
-	down(&bus->sdsem);
 	error = brcmf_sdio_readshared(bus, &sh);
-	up(&bus->sdsem);
 
 	if (error < 0)
 		return error;
@@ -2938,7 +2946,6 @@ static int brcmf_sdbrcm_died_dump(struct brcmf_sdio *bus, char __user *data,
 	if (pos != 0)
 		return 0;
 
-	down(&bus->sdsem);
 	error = brcmf_sdio_readshared(bus, &sh);
 	if (error < 0)
 		goto done;
@@ -2955,7 +2962,6 @@ static int brcmf_sdbrcm_died_dump(struct brcmf_sdio *bus, char __user *data,
 	error += nbytes;
 	*ppos += error;
 done:
-	up(&bus->sdsem);
 	return error;
 }
 
@@ -3511,8 +3517,6 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TIMER, "Enter\n");
 
-	down(&bus->sdsem);
-
 	/* Poll period: check device if appropriate. */
 	if (bus->poll && (++bus->polltick >= bus->pollrate)) {
 		u32 intstatus = 0;
@@ -3561,11 +3565,13 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 		bus->console.count += BRCMF_WD_POLL_MS;
 		if (bus->console.count >= bus->console_interval) {
 			bus->console.count -= bus->console_interval;
+			down(&bus->sdsem);
 			/* Make sure backplane clock is on */
 			brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 			if (brcmf_sdbrcm_readconsole(bus) < 0)
 				/* stop on error */
 				bus->console_interval = 0;
+			up(&bus->sdsem);
 		}
 	}
 #endif				/* DEBUG */
@@ -3578,13 +3584,13 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 				bus->activity = false;
 				brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 			} else {
+				down(&bus->sdsem);
 				brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+				up(&bus->sdsem);
 			}
 		}
 	}
 
-	up(&bus->sdsem);
-
 	return (atomic_read(&bus->ipend) > 0);
 }
 
-- 
1.7.9.5


