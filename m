Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3988 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab1IMHuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/17] staging: brcm80211: remove static function
 declaration in dhd_sdio
Date: Tue, 13 Sep 2011 09:49:41 +0200
Message-ID: <1315900197-7260-2-git-send-email-rvossen@broadcom.com> (sfid-20110913_095027_546225_E5DB76DC)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Reshuffle function order in dhd_sdio of fullmac to get rid of
static function declaration

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c | 6392 ++++++++++++-------------
 1 files changed, 3169 insertions(+), 3223 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 0de4dc6..680b232 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -855,58 +855,6 @@ w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 
 #define HOSTINTMASK		(I_HMB_SW_MASK | I_CHIPACTIVE)
 
-#ifdef BCMDBG
-static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size);
-static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus);
-#endif				/* BCMDBG  */
-static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter);
-
-static void brcmf_sdbrcm_release(struct brcmf_bus *bus);
-static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus);
-static bool brcmf_sdbrcm_chipmatch(u16 chipid);
-static bool brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva);
-static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus);
-static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus);
-static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus);
-
-static uint brcmf_process_nvram_vars(char *varbuf, uint len);
-
-static void brcmf_sdbrcm_setmemsize(struct brcmf_bus *bus, int mem_size);
-static int brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn,
-			       uint flags, u8 *buf, uint nbytes,
-			       struct sk_buff *pkt);
-
-static bool brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus);
-static int  _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus);
-
-static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus);
-static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus);
-
-static void
-brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_dev *sdiodev, u32 corebase);
-
-static int brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs);
-
-static void
-brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase);
-
-static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
-					u32 drivestrength);
-static void brcmf_sdbrcm_chip_detach(struct brcmf_bus *bus);
-static void brcmf_sdbrcm_wait_for_event(struct brcmf_bus *bus, bool *lockvar);
-static void brcmf_sdbrcm_wait_event_wakeup(struct brcmf_bus *bus);
-static void brcmf_sdbrcm_watchdog(unsigned long data);
-static int brcmf_sdbrcm_watchdog_thread(void *data);
-static int brcmf_sdbrcm_dpc_thread(void *data);
-static void brcmf_sdbrcm_dpc_tasklet(unsigned long data);
-static void brcmf_sdbrcm_sched_dpc(struct brcmf_bus *bus);
-static void brcmf_sdbrcm_sdlock(struct brcmf_bus *bus);
-static void brcmf_sdbrcm_sdunlock(struct brcmf_bus *bus);
-static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus);
-static int brcmf_sdbrcm_ioctl_resp_wait(struct brcmf_bus *bus, uint *condition,
-					bool *pending);
-static int brcmf_sdbrcm_ioctl_resp_wake(struct brcmf_bus *bus);
-
 /* Packet free applicable unconditionally for sdio and sdspi.
  * Conditional if bufpool was present for gspi bus.
  */
@@ -927,6 +875,22 @@ static void brcmf_sdbrcm_setmemsize(struct brcmf_bus *bus, int mem_size)
 		bus->ramsize = brcmf_dongle_memsize;
 }
 
+static void brcmf_sdbrcm_sdlock(struct brcmf_bus *bus)
+{
+	if (bus->threads_only)
+		down(&bus->sdsem);
+	else
+		spin_lock_bh(&bus->sdlock);
+}
+
+static void brcmf_sdbrcm_sdunlock(struct brcmf_bus *bus)
+{
+	if (bus->threads_only)
+		up(&bus->sdsem);
+	else
+		spin_unlock_bh(&bus->sdlock);
+}
+
 /* Turn backplane clock on or off */
 static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 {
@@ -1217,2991 +1181,2799 @@ static void bus_wake(struct brcmf_bus *bus)
 		brcmf_sdbrcm_bussleep(bus, false);
 }
 
-/* Writes a HW/SW header into the packet and sends it. */
-/* Assumes: (a) header space already there, (b) caller holds lock */
-static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
-			      uint chan, bool free_pkt)
+static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 {
-	int ret;
-	u8 *frame;
-	u16 len, pad = 0;
-	u32 swheader;
+	u32 intstatus = 0;
+	u32 hmb_data;
+	u8 fcbits;
 	uint retries = 0;
-	struct sk_buff *new;
-	int i;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (bus->drvr->dongle_reset) {
-		ret = -EPERM;
-		goto done;
-	}
+	/* Read mailbox data and ack that we did so */
+	r_sdreg32(bus, &hmb_data,
+		  offsetof(struct sdpcmd_regs, tohostmailboxdata), &retries);
 
-	frame = (u8 *) (pkt->data);
+	if (retries <= retry_limit)
+		w_sdreg32(bus, SMB_INT_ACK,
+			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
+	bus->f1regdata += 2;
 
-	/* Add alignment padding, allocate new packet if needed */
-	pad = ((unsigned long)frame % BRCMF_SDALIGN);
-	if (pad) {
-		if (skb_headroom(pkt) < pad) {
-			brcmf_dbg(INFO, "insufficient headroom %d for %d pad\n",
-				  skb_headroom(pkt), pad);
-			bus->drvr->tx_realloc++;
-			new = brcmu_pkt_buf_get_skb(pkt->len + BRCMF_SDALIGN);
-			if (!new) {
-				brcmf_dbg(ERROR, "couldn't allocate new %d-byte packet\n",
-					  pkt->len + BRCMF_SDALIGN);
-				ret = -ENOMEM;
-				goto done;
-			}
+	/* Dongle recomposed rx frames, accept them again */
+	if (hmb_data & HMB_DATA_NAKHANDLED) {
+		brcmf_dbg(INFO, "Dongle reports NAK handled, expect rtx of %d\n",
+			  bus->rx_seq);
+		if (!bus->rxskip)
+			brcmf_dbg(ERROR, "unexpected NAKHANDLED!\n");
 
-			pkt_align(new, pkt->len, BRCMF_SDALIGN);
-			memcpy(new->data, pkt->data, pkt->len);
-			if (free_pkt)
-				brcmu_pkt_buf_free_skb(pkt);
-			/* free the pkt if canned one is not used */
-			free_pkt = true;
-			pkt = new;
-			frame = (u8 *) (pkt->data);
-			/* precondition: (frame % BRCMF_SDALIGN) == 0) */
-			pad = 0;
-		} else {
-			skb_push(pkt, pad);
-			frame = (u8 *) (pkt->data);
-			/* precondition: pad + SDPCM_HDRLEN <= pkt->len */
-			memset(frame, 0, pad + SDPCM_HDRLEN);
-		}
+		bus->rxskip = false;
+		intstatus |= I_HMB_FRAME_IND;
 	}
-	/* precondition: pad < BRCMF_SDALIGN */
 
-	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
-	len = (u16) (pkt->len);
-	*(u16 *) frame = cpu_to_le16(len);
-	*(((u16 *) frame) + 1) = cpu_to_le16(~len);
+	/*
+	 * DEVREADY does not occur with gSPI.
+	 */
+	if (hmb_data & (HMB_DATA_DEVREADY | HMB_DATA_FWREADY)) {
+		bus->sdpcm_ver =
+		    (hmb_data & HMB_DATA_VERSION_MASK) >>
+		    HMB_DATA_VERSION_SHIFT;
+		if (bus->sdpcm_ver != SDPCM_PROT_VERSION)
+			brcmf_dbg(ERROR, "Version mismatch, dongle reports %d, "
+				  "expecting %d\n",
+				  bus->sdpcm_ver, SDPCM_PROT_VERSION);
+		else
+			brcmf_dbg(INFO, "Dongle ready, protocol version %d\n",
+				  bus->sdpcm_ver);
+	}
 
-	/* Software tag: channel, sequence number, data offset */
-	swheader =
-	    ((chan << SDPCM_CHANNEL_SHIFT) & SDPCM_CHANNEL_MASK) | bus->tx_seq |
-	    (((pad +
-	       SDPCM_HDRLEN) << SDPCM_DOFFSET_SHIFT) & SDPCM_DOFFSET_MASK);
+	/*
+	 * Flow Control has been moved into the RX headers and this out of band
+	 * method isn't used any more.
+	 * remaining backward compatible with older dongles.
+	 */
+	if (hmb_data & HMB_DATA_FC) {
+		fcbits = (hmb_data & HMB_DATA_FCDATA_MASK) >>
+							HMB_DATA_FCDATA_SHIFT;
 
-	put_unaligned_le32(swheader, frame + SDPCM_FRAMETAG_LEN);
-	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
+		if (fcbits & ~bus->flowcontrol)
+			bus->fc_xoff++;
 
-#ifdef BCMDBG
-	tx_packets[pkt->priority]++;
-	if (BRCMF_BYTES_ON() &&
-	    (((BRCMF_CTL_ON() && (chan == SDPCM_CONTROL_CHANNEL)) ||
-	      (BRCMF_DATA_ON() && (chan != SDPCM_CONTROL_CHANNEL))))) {
-		printk(KERN_DEBUG "Tx Frame:\n");
-		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, frame, len);
-	} else if (BRCMF_HDRS_ON()) {
-		printk(KERN_DEBUG "TxHdr:\n");
-		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-				     frame, min_t(u16, len, 16));
-	}
-#endif
+		if (bus->flowcontrol & ~fcbits)
+			bus->fc_xon++;
 
-	/* Raise len to next SDIO block to eliminate tail command */
-	if (bus->roundup && bus->blocksize && (len > bus->blocksize)) {
-		u16 pad = bus->blocksize - (len % bus->blocksize);
-		if ((pad <= bus->roundup) && (pad < bus->blocksize))
-				len += pad;
-	} else if (len % BRCMF_SDALIGN) {
-		len += BRCMF_SDALIGN - (len % BRCMF_SDALIGN);
+		bus->fc_rcvd++;
+		bus->flowcontrol = fcbits;
 	}
 
-	/* Some controllers have trouble with odd bytes -- round to even */
-	if (forcealign && (len & (ALIGNMENT - 1)))
-			len = roundup(len, ALIGNMENT);
+	/* Shouldn't be any others */
+	if (hmb_data & ~(HMB_DATA_DEVREADY |
+			 HMB_DATA_NAKHANDLED |
+			 HMB_DATA_FC |
+			 HMB_DATA_FWREADY |
+			 HMB_DATA_FCDATA_MASK | HMB_DATA_VERSION_MASK))
+		brcmf_dbg(ERROR, "Unknown mailbox data content: 0x%02x\n",
+			  hmb_data);
 
-	do {
-		ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
-					    SDIO_FUNC_2, F2SYNC, frame,
-					    len, pkt);
-		bus->f2txdata++;
+	return intstatus;
+}
 
-		if (ret < 0) {
-			/* On failure, abort the command
-			 and terminate the frame */
-			brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
-				  ret);
-			bus->tx_sderrs++;
+static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
+{
+	uint retries = 0;
+	u16 lastrbc;
+	u8 hi, lo;
+	int err;
 
-			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
-			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
-					 NULL);
-			bus->f1regdata++;
+	brcmf_dbg(ERROR, "%sterminate frame%s\n",
+		  abort ? "abort command, " : "",
+		  rtx ? ", send NAK" : "");
 
-			for (i = 0; i < 3; i++) {
-				u8 hi, lo;
-				hi = brcmf_sdcard_cfg_read(bus->sdiodev,
-						     SDIO_FUNC_1,
-						     SBSDIO_FUNC1_WFRAMEBCHI,
-						     NULL);
-				lo = brcmf_sdcard_cfg_read(bus->sdiodev,
-						     SDIO_FUNC_1,
-						     SBSDIO_FUNC1_WFRAMEBCLO,
-						     NULL);
-				bus->f1regdata += 2;
-				if ((hi == 0) && (lo == 0))
-					break;
-			}
+	if (abort)
+		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 
-		}
-		if (ret == 0)
-			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_FRAMECTRL,
+			       SFC_RF_TERM, &err);
+	bus->f1regdata++;
 
-	} while ((ret < 0) && retrydata && retries++ < TXRETRIES);
+	/* Wait until the packet has been flushed (device/FIFO stable) */
+	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
+		hi = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+					   SBSDIO_FUNC1_RFRAMEBCHI, NULL);
+		lo = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+					   SBSDIO_FUNC1_RFRAMEBCLO, NULL);
+		bus->f1regdata += 2;
 
-done:
-	/* restore pkt buffer pointer before calling tx complete routine */
-	skb_pull(pkt, SDPCM_HDRLEN + pad);
-	brcmf_sdbrcm_sdunlock(bus);
-	brcmf_txcomplete(bus->drvr, pkt, ret != 0);
-	brcmf_sdbrcm_sdlock(bus);
+		if ((hi == 0) && (lo == 0))
+			break;
 
-	if (free_pkt)
-		brcmu_pkt_buf_free_skb(pkt);
+		if ((hi > (lastrbc >> 8)) && (lo > (lastrbc & 0x00ff))) {
+			brcmf_dbg(ERROR, "count growing: last 0x%04x now 0x%04x\n",
+				  lastrbc, (hi << 8) + lo);
+		}
+		lastrbc = (hi << 8) + lo;
+	}
 
-	return ret;
-}
+	if (!retries)
+		brcmf_dbg(ERROR, "count never zeroed: last 0x%04x\n", lastrbc);
+	else
+		brcmf_dbg(INFO, "flush took %d iterations\n", 0xffff - retries);
 
-int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
-{
-	int ret = -EBADE;
-	uint datalen, prec;
+	if (rtx) {
+		bus->rxrtx++;
+		w_sdreg32(bus, SMB_NAK,
+			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
 
-	brcmf_dbg(TRACE, "Enter\n");
-
-	datalen = pkt->len;
+		bus->f1regdata++;
+		if (retries <= retry_limit)
+			bus->rxskip = true;
+	}
 
-	/* Add space for the header */
-	skb_push(pkt, SDPCM_HDRLEN);
-	/* precondition: IS_ALIGNED((unsigned long)(pkt->data), 2) */
+	/* Clear partial in any case */
+	bus->nextlen = 0;
 
-	prec = prio2prec((pkt->priority & PRIOMASK));
+	/* If we can't reach the device, signal failure */
+	if (err || brcmf_sdcard_regfail(bus->sdiodev))
+		bus->drvr->busstate = BRCMF_BUS_DOWN;
+}
 
-	/* Check for existing queue, current flow-control,
-			 pending event, or pending clock */
-	if (brcmf_deferred_tx || bus->fcstate || pktq_len(&bus->txq)
-	    || bus->dpc_sched || (!data_ok(bus))
-	    || (bus->flowcontrol & NBITVAL(prec))
-	    || (bus->clkstate != CLK_AVAIL)) {
-		brcmf_dbg(TRACE, "deferring pktq len %d\n",
-			  pktq_len(&bus->txq));
-		bus->fcqueued++;
+static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
+{
+	u16 dlen, totlen;
+	u8 *dptr, num = 0;
 
-		/* Priority based enq */
-		spin_lock_bh(&bus->txqlock);
-		if (brcmf_c_prec_enq(bus->drvr, &bus->txq, pkt, prec) ==
-		    false) {
-			skb_pull(pkt, SDPCM_HDRLEN);
-			brcmf_txcomplete(bus->drvr, pkt, false);
-			brcmu_pkt_buf_free_skb(pkt);
-			brcmf_dbg(ERROR, "out of bus->txq !!!\n");
-			ret = -ENOSR;
-		} else {
-			ret = 0;
-		}
-		spin_unlock_bh(&bus->txqlock);
+	u16 sublen, check;
+	struct sk_buff *pfirst, *plast, *pnext, *save_pfirst;
 
-		if (pktq_len(&bus->txq) >= TXHI)
-			brcmf_txflowcontrol(bus->drvr, 0, ON);
+	int errcode;
+	u8 chan, seq, doff, sfdoff;
+	u8 txmax;
 
-#ifdef BCMDBG
-		if (pktq_plen(&bus->txq, prec) > qcount[prec])
-			qcount[prec] = pktq_plen(&bus->txq, prec);
-#endif
-		/* Schedule DPC if needed to send queued packet(s) */
-		if (brcmf_deferred_tx && !bus->dpc_sched) {
-			bus->dpc_sched = true;
-			brcmf_sdbrcm_sched_dpc(bus);
-		}
-	} else {
-		/* Lock: we're about to use shared data/code (and SDIO) */
-		brcmf_sdbrcm_sdlock(bus);
+	int ifidx = 0;
+	bool usechain = bus->use_rxchain;
 
-		/* Otherwise, send it now */
-		bus_wake(bus);
-		/* Make sure back plane ht clk is on, no pending allowed */
-		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
+	/* If packets, issue read(s) and send up packet chain */
+	/* Return sequence numbers consumed? */
 
-		brcmf_dbg(TRACE, "calling txpkt\n");
-		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
-		if (ret)
-			bus->drvr->tx_errors++;
-		else
-			bus->drvr->dstats.tx_bytes += datalen;
+	brcmf_dbg(TRACE, "start: glomd %p glom %p\n", bus->glomd, bus->glom);
 
-		if (bus->idletime == BRCMF_IDLE_IMMEDIATE &&
-		    !bus->dpc_sched) {
-			bus->activity = false;
-			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
+	/* If there's a descriptor, generate the packet chain */
+	if (bus->glomd) {
+		pfirst = plast = pnext = NULL;
+		dlen = (u16) (bus->glomd->len);
+		dptr = bus->glomd->data;
+		if (!dlen || (dlen & 1)) {
+			brcmf_dbg(ERROR, "bad glomd len(%d), ignore descriptor\n",
+				  dlen);
+			dlen = 0;
 		}
 
-		brcmf_sdbrcm_sdunlock(bus);
-	}
+		for (totlen = num = 0; dlen; num++) {
+			/* Get (and move past) next length */
+			sublen = get_unaligned_le16(dptr);
+			dlen -= sizeof(u16);
+			dptr += sizeof(u16);
+			if ((sublen < SDPCM_HDRLEN) ||
+			    ((num == 0) && (sublen < (2 * SDPCM_HDRLEN)))) {
+				brcmf_dbg(ERROR, "descriptor len %d bad: %d\n",
+					  num, sublen);
+				pnext = NULL;
+				break;
+			}
+			if (sublen % BRCMF_SDALIGN) {
+				brcmf_dbg(ERROR, "sublen %d not multiple of %d\n",
+					  sublen, BRCMF_SDALIGN);
+				usechain = false;
+			}
+			totlen += sublen;
 
-	return ret;
-}
+			/* For last frame, adjust read len so total
+				 is a block multiple */
+			if (!dlen) {
+				sublen +=
+				    (roundup(totlen, bus->blocksize) - totlen);
+				totlen = roundup(totlen, bus->blocksize);
+			}
 
-static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
-{
-	struct sk_buff *pkt;
-	u32 intstatus = 0;
-	uint retries = 0;
-	int ret = 0, prec_out;
-	uint cnt = 0;
-	uint datalen;
-	u8 tx_prec_map;
+			/* Allocate/chain packet for next subframe */
+			pnext = brcmu_pkt_buf_get_skb(sublen + BRCMF_SDALIGN);
+			if (pnext == NULL) {
+				brcmf_dbg(ERROR, "bcm_pkt_buf_get_skb failed, num %d len %d\n",
+					  num, sublen);
+				break;
+			}
+			if (!pfirst) {
+				pfirst = plast = pnext;
+			} else {
+				plast->next = pnext;
+				plast = pnext;
+			}
 
-	struct brcmf_pub *drvr = bus->drvr;
+			/* Adhere to start alignment requirements */
+			pkt_align(pnext, sublen, BRCMF_SDALIGN);
+		}
 
-	brcmf_dbg(TRACE, "Enter\n");
+		/* If all allocations succeeded, save packet chain
+			 in bus structure */
+		if (pnext) {
+			brcmf_dbg(GLOM, "allocated %d-byte packet chain for %d subframes\n",
+				  totlen, num);
+			if (BRCMF_GLOM_ON() && bus->nextlen) {
+				if (totlen != bus->nextlen) {
+					brcmf_dbg(GLOM, "glomdesc mismatch: nextlen %d glomdesc %d rxseq %d\n",
+						  bus->nextlen, totlen, rxseq);
+				}
+			}
+			bus->glom = pfirst;
+			pfirst = pnext = NULL;
+		} else {
+			if (pfirst)
+				brcmu_pkt_buf_free_skb(pfirst);
+			bus->glom = NULL;
+			num = 0;
+		}
 
-	tx_prec_map = ~bus->flowcontrol;
+		/* Done with descriptor packet */
+		brcmu_pkt_buf_free_skb(bus->glomd);
+		bus->glomd = NULL;
+		bus->nextlen = 0;
+	}
 
-	/* Send frames until the limit or some other event */
-	for (cnt = 0; (cnt < maxframes) && data_ok(bus); cnt++) {
-		spin_lock_bh(&bus->txqlock);
-		pkt = brcmu_pktq_mdeq(&bus->txq, tx_prec_map, &prec_out);
-		if (pkt == NULL) {
-			spin_unlock_bh(&bus->txqlock);
-			break;
+	/* Ok -- either we just generated a packet chain,
+		 or had one from before */
+	if (bus->glom) {
+		if (BRCMF_GLOM_ON()) {
+			brcmf_dbg(GLOM, "try superframe read, packet chain:\n");
+			for (pnext = bus->glom; pnext; pnext = pnext->next) {
+				brcmf_dbg(GLOM, "    %p: %p len 0x%04x (%d)\n",
+					  pnext, (u8 *) (pnext->data),
+					  pnext->len, pnext->len);
+			}
 		}
-		spin_unlock_bh(&bus->txqlock);
-		datalen = pkt->len - SDPCM_HDRLEN;
 
-		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
-		if (ret)
-			bus->drvr->tx_errors++;
-		else
-			bus->drvr->dstats.tx_bytes += datalen;
+		pfirst = bus->glom;
+		dlen = (u16) brcmu_pkttotlen(pfirst);
 
-		/* In poll mode, need to check for other events */
-		if (!bus->intr && cnt) {
-			/* Check device status, signal pending interrupt */
-			r_sdreg32(bus, &intstatus,
-				  offsetof(struct sdpcmd_regs, intstatus),
-				  &retries);
-			bus->f2txdata++;
-			if (brcmf_sdcard_regfail(bus->sdiodev))
-				break;
-			if (intstatus & bus->hostintmask)
-				bus->ipend = true;
+		/* Do an SDIO read for the superframe.  Configurable iovar to
+		 * read directly into the chained packet, or allocate a large
+		 * packet and and copy into the chain.
+		 */
+		if (usechain) {
+			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
+					bus->sdiodev->sbwad,
+					SDIO_FUNC_2,
+					F2SYNC, (u8 *) pfirst->data, dlen,
+					pfirst);
+		} else if (bus->dataptr) {
+			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
+					bus->sdiodev->sbwad,
+					SDIO_FUNC_2,
+					F2SYNC, bus->dataptr, dlen,
+					NULL);
+			sublen = (u16) brcmu_pktfrombuf(pfirst, 0, dlen,
+						bus->dataptr);
+			if (sublen != dlen) {
+				brcmf_dbg(ERROR, "FAILED TO COPY, dlen %d sublen %d\n",
+					  dlen, sublen);
+				errcode = -1;
+			}
+			pnext = NULL;
+		} else {
+			brcmf_dbg(ERROR, "COULDN'T ALLOC %d-BYTE GLOM, FORCE FAILURE\n",
+				  dlen);
+			errcode = -1;
 		}
-	}
-
-	/* Deflow-control stack if needed */
-	if (drvr->up && (drvr->busstate == BRCMF_BUS_DATA) &&
-	    drvr->txoff && (pktq_len(&bus->txq) < TXLOW))
-		brcmf_txflowcontrol(drvr, 0, OFF);
+		bus->f2rxdata++;
 
-	return cnt;
-}
+		/* On failure, kill the superframe, allow a couple retries */
+		if (errcode < 0) {
+			brcmf_dbg(ERROR, "glom read of %d bytes failed: %d\n",
+				  dlen, errcode);
+			bus->drvr->rx_errors++;
 
-int
-brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
-{
-	u8 *frame;
-	u16 len;
-	u32 swheader;
-	uint retries = 0;
-	u8 doff = 0;
-	int ret = -1;
-	int i;
-
-	brcmf_dbg(TRACE, "Enter\n");
+			if (bus->glomerr++ < 3) {
+				brcmf_sdbrcm_rxfail(bus, true, true);
+			} else {
+				bus->glomerr = 0;
+				brcmf_sdbrcm_rxfail(bus, true, false);
+				brcmu_pkt_buf_free_skb(bus->glom);
+				bus->rxglomfail++;
+				bus->glom = NULL;
+			}
+			return 0;
+		}
+#ifdef BCMDBG
+		if (BRCMF_GLOM_ON()) {
+			printk(KERN_DEBUG "SUPERFRAME:\n");
+			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+				pfirst->data, min_t(int, pfirst->len, 48));
+		}
+#endif
 
-	if (bus->drvr->dongle_reset)
-		return -EIO;
+		/* Validate the superframe header */
+		dptr = (u8 *) (pfirst->data);
+		sublen = get_unaligned_le16(dptr);
+		check = get_unaligned_le16(dptr + sizeof(u16));
 
-	/* Back the pointer to make a room for bus header */
-	frame = msg - SDPCM_HDRLEN;
-	len = (msglen += SDPCM_HDRLEN);
+		chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
+		seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
+		bus->nextlen = dptr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
+		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
+			brcmf_dbg(INFO, "nextlen too large (%d) seq %d\n",
+				  bus->nextlen, seq);
+			bus->nextlen = 0;
+		}
+		doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
+		txmax = SDPCM_WINDOW_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 
-	/* Add alignment padding (optional for ctl frames) */
-	if (brcmf_alignctl) {
-		doff = ((unsigned long)frame % BRCMF_SDALIGN);
-		if (doff) {
-			frame -= doff;
-			len += doff;
-			msglen += doff;
-			memset(frame, 0, doff + SDPCM_HDRLEN);
+		errcode = 0;
+		if ((u16)~(sublen ^ check)) {
+			brcmf_dbg(ERROR, "(superframe): HW hdr error: len/check 0x%04x/0x%04x\n",
+				  sublen, check);
+			errcode = -1;
+		} else if (roundup(sublen, bus->blocksize) != dlen) {
+			brcmf_dbg(ERROR, "(superframe): len 0x%04x, rounded 0x%04x, expect 0x%04x\n",
+				  sublen, roundup(sublen, bus->blocksize),
+				  dlen);
+			errcode = -1;
+		} else if (SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]) !=
+			   SDPCM_GLOM_CHANNEL) {
+			brcmf_dbg(ERROR, "(superframe): bad channel %d\n",
+				  SDPCM_PACKET_CHANNEL(
+					  &dptr[SDPCM_FRAMETAG_LEN]));
+			errcode = -1;
+		} else if (SDPCM_GLOMDESC(&dptr[SDPCM_FRAMETAG_LEN])) {
+			brcmf_dbg(ERROR, "(superframe): got 2nd descriptor?\n");
+			errcode = -1;
+		} else if ((doff < SDPCM_HDRLEN) ||
+			   (doff > (pfirst->len - SDPCM_HDRLEN))) {
+			brcmf_dbg(ERROR, "(superframe): Bad data offset %d: HW %d pkt %d min %d\n",
+				  doff, sublen, pfirst->len, SDPCM_HDRLEN);
+			errcode = -1;
 		}
-		/* precondition: doff < BRCMF_SDALIGN */
-	}
-	doff += SDPCM_HDRLEN;
 
-	/* Round send length to next SDIO block */
-	if (bus->roundup && bus->blocksize && (len > bus->blocksize)) {
-		u16 pad = bus->blocksize - (len % bus->blocksize);
-		if ((pad <= bus->roundup) && (pad < bus->blocksize))
-			len += pad;
-	} else if (len % BRCMF_SDALIGN) {
-		len += BRCMF_SDALIGN - (len % BRCMF_SDALIGN);
-	}
+		/* Check sequence number of superframe SW header */
+		if (rxseq != seq) {
+			brcmf_dbg(INFO, "(superframe) rx_seq %d, expected %d\n",
+				  seq, rxseq);
+			bus->rx_badseq++;
+			rxseq = seq;
+		}
 
-	/* Satisfy length-alignment requirements */
-	if (forcealign && (len & (ALIGNMENT - 1)))
-		len = roundup(len, ALIGNMENT);
+		/* Check window for sanity */
+		if ((u8) (txmax - bus->tx_seq) > 0x40) {
+			brcmf_dbg(ERROR, "unlikely tx max %d with tx_seq %d\n",
+				  txmax, bus->tx_seq);
+			txmax = bus->tx_seq + 2;
+		}
+		bus->tx_max = txmax;
 
-	/* precondition: IS_ALIGNED((unsigned long)frame, 2) */
+		/* Remove superframe header, remember offset */
+		skb_pull(pfirst, doff);
+		sfdoff = doff;
 
-	/* Need to lock here to protect txseq and SDIO tx calls */
-	brcmf_sdbrcm_sdlock(bus);
+		/* Validate all the subframe headers */
+		for (num = 0, pnext = pfirst; pnext && !errcode;
+		     num++, pnext = pnext->next) {
+			dptr = (u8 *) (pnext->data);
+			dlen = (u16) (pnext->len);
+			sublen = get_unaligned_le16(dptr);
+			check = get_unaligned_le16(dptr + sizeof(u16));
+			chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
+			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
+#ifdef BCMDBG
+			if (BRCMF_GLOM_ON()) {
+				printk(KERN_DEBUG "subframe:\n");
+				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+						     dptr, 32);
+			}
+#endif
 
-	bus_wake(bus);
+			if ((u16)~(sublen ^ check)) {
+				brcmf_dbg(ERROR, "(subframe %d): HW hdr error: len/check 0x%04x/0x%04x\n",
+					  num, sublen, check);
+				errcode = -1;
+			} else if ((sublen > dlen) || (sublen < SDPCM_HDRLEN)) {
+				brcmf_dbg(ERROR, "(subframe %d): length mismatch: len 0x%04x, expect 0x%04x\n",
+					  num, sublen, dlen);
+				errcode = -1;
+			} else if ((chan != SDPCM_DATA_CHANNEL) &&
+				   (chan != SDPCM_EVENT_CHANNEL)) {
+				brcmf_dbg(ERROR, "(subframe %d): bad channel %d\n",
+					  num, chan);
+				errcode = -1;
+			} else if ((doff < SDPCM_HDRLEN) || (doff > sublen)) {
+				brcmf_dbg(ERROR, "(subframe %d): Bad data offset %d: HW %d min %d\n",
+					  num, doff, sublen, SDPCM_HDRLEN);
+				errcode = -1;
+			}
+		}
 
-	/* Make sure backplane clock is on */
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+		if (errcode) {
+			/* Terminate frame on error, request
+				 a couple retries */
+			if (bus->glomerr++ < 3) {
+				/* Restore superframe header space */
+				skb_push(pfirst, sfdoff);
+				brcmf_sdbrcm_rxfail(bus, true, true);
+			} else {
+				bus->glomerr = 0;
+				brcmf_sdbrcm_rxfail(bus, true, false);
+				brcmu_pkt_buf_free_skb(bus->glom);
+				bus->rxglomfail++;
+				bus->glom = NULL;
+			}
+			bus->nextlen = 0;
+			return 0;
+		}
 
-	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
-	*(u16 *) frame = cpu_to_le16((u16) msglen);
-	*(((u16 *) frame) + 1) = cpu_to_le16(~msglen);
+		/* Basic SD framing looks ok - process each packet (header) */
+		save_pfirst = pfirst;
+		bus->glom = NULL;
+		plast = NULL;
 
-	/* Software tag: channel, sequence number, data offset */
-	swheader =
-	    ((SDPCM_CONTROL_CHANNEL << SDPCM_CHANNEL_SHIFT) &
-	     SDPCM_CHANNEL_MASK)
-	    | bus->tx_seq | ((doff << SDPCM_DOFFSET_SHIFT) &
-			     SDPCM_DOFFSET_MASK);
-	put_unaligned_le32(swheader, frame + SDPCM_FRAMETAG_LEN);
-	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
+		for (num = 0; pfirst; rxseq++, pfirst = pnext) {
+			pnext = pfirst->next;
+			pfirst->next = NULL;
 
-	if (!data_ok(bus)) {
-		brcmf_dbg(INFO, "No bus credit bus->tx_max %d, bus->tx_seq %d\n",
-			  bus->tx_max, bus->tx_seq);
-		bus->ctrl_frame_stat = true;
-		/* Send from dpc */
-		bus->ctrl_frame_buf = frame;
-		bus->ctrl_frame_len = len;
+			dptr = (u8 *) (pfirst->data);
+			sublen = get_unaligned_le16(dptr);
+			chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
+			seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
+			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 
-		brcmf_sdbrcm_wait_for_event(bus, &bus->ctrl_frame_stat);
+			brcmf_dbg(GLOM, "Get subframe %d, %p(%p/%d), sublen %d chan %d seq %d\n",
+				  num, pfirst, pfirst->data,
+				  pfirst->len, sublen, chan, seq);
 
-		if (bus->ctrl_frame_stat == false) {
-			brcmf_dbg(INFO, "ctrl_frame_stat == false\n");
-			ret = 0;
-		} else {
-			brcmf_dbg(INFO, "ctrl_frame_stat == true\n");
-			ret = -1;
-		}
-	}
+			/* precondition: chan == SDPCM_DATA_CHANNEL ||
+					 chan == SDPCM_EVENT_CHANNEL */
 
-	if (ret == -1) {
+			if (rxseq != seq) {
+				brcmf_dbg(GLOM, "rx_seq %d, expected %d\n",
+					  seq, rxseq);
+				bus->rx_badseq++;
+				rxseq = seq;
+			}
 #ifdef BCMDBG
-		if (BRCMF_BYTES_ON() && BRCMF_CTL_ON()) {
-			printk(KERN_DEBUG "Tx Frame:\n");
-			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-					     frame, len);
-		} else if (BRCMF_HDRS_ON()) {
-			printk(KERN_DEBUG "TxHdr:\n");
-			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-					     frame, min_t(u16, len, 16));
-		}
+			if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
+				printk(KERN_DEBUG "Rx Subframe Data:\n");
+				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+						     dptr, dlen);
+			}
 #endif
 
-		do {
-			bus->ctrl_frame_stat = false;
-			ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
-					SDIO_FUNC_2, F2SYNC, frame, len, NULL);
-
-			if (ret < 0) {
-				/* On failure, abort the command and
-				 terminate the frame */
-				brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
-					  ret);
-				bus->tx_sderrs++;
-
-				brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
+			__skb_trim(pfirst, sublen);
+			skb_pull(pfirst, doff);
 
-				brcmf_sdcard_cfg_write(bus->sdiodev,
-						 SDIO_FUNC_1,
-						 SBSDIO_FUNC1_FRAMECTRL,
-						 SFC_WF_TERM, NULL);
-				bus->f1regdata++;
+			if (pfirst->len == 0) {
+				brcmu_pkt_buf_free_skb(pfirst);
+				if (plast)
+					plast->next = pnext;
+				else
+					save_pfirst = pnext;
 
-				for (i = 0; i < 3; i++) {
-					u8 hi, lo;
-					hi = brcmf_sdcard_cfg_read(bus->sdiodev,
-					     SDIO_FUNC_1,
-					     SBSDIO_FUNC1_WFRAMEBCHI,
-					     NULL);
-					lo = brcmf_sdcard_cfg_read(bus->sdiodev,
-					     SDIO_FUNC_1,
-					     SBSDIO_FUNC1_WFRAMEBCLO,
-					     NULL);
-					bus->f1regdata += 2;
-					if ((hi == 0) && (lo == 0))
-						break;
-				}
+				continue;
+			} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx,
+						       pfirst) != 0) {
+				brcmf_dbg(ERROR, "rx protocol error\n");
+				bus->drvr->rx_errors++;
+				brcmu_pkt_buf_free_skb(pfirst);
+				if (plast)
+					plast->next = pnext;
+				else
+					save_pfirst = pnext;
 
+				continue;
 			}
-			if (ret == 0)
-				bus->tx_seq =
-				    (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
-
-		} while ((ret < 0) && retries++ < TXRETRIES);
-	}
-
-	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) && !bus->dpc_sched) {
-		bus->activity = false;
-		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
-	}
 
-	brcmf_sdbrcm_sdunlock(bus);
+			/* this packet will go up, link back into
+				 chain and count it */
+			pfirst->next = pnext;
+			plast = pfirst;
+			num++;
 
-	if (ret)
-		bus->drvr->tx_ctlerrs++;
-	else
-		bus->drvr->tx_ctlpkts++;
+#ifdef BCMDBG
+			if (BRCMF_GLOM_ON()) {
+				brcmf_dbg(GLOM, "subframe %d to stack, %p (%p/%d) nxt/lnk %p/%p\n",
+					  num, pfirst, pfirst->data,
+					  pfirst->len, pfirst->next,
+					  pfirst->prev);
+				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+						pfirst->data,
+						min_t(int, pfirst->len, 32));
+			}
+#endif				/* BCMDBG */
+		}
+		if (num) {
+			brcmf_sdbrcm_sdunlock(bus);
+			brcmf_rx_frame(bus->drvr, ifidx, save_pfirst, num);
+			brcmf_sdbrcm_sdlock(bus);
+		}
 
-	return ret ? -EIO : 0;
+		bus->rxglomframes++;
+		bus->rxglompkts += num;
+	}
+	return num;
 }
 
-int
-brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
+static int brcmf_sdbrcm_ioctl_resp_wait(struct brcmf_bus *bus, uint *condition,
+					bool *pending)
 {
-	int timeleft;
-	uint rxlen = 0;
-	bool pending;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	if (bus->drvr->dongle_reset)
-		return -EIO;
+	DECLARE_WAITQUEUE(wait, current);
+	int timeout = msecs_to_jiffies(brcmf_ioctl_timeout_msec);
 
 	/* Wait until control frame is available */
-	timeleft = brcmf_sdbrcm_ioctl_resp_wait(bus, &bus->rxlen, &pending);
+	add_wait_queue(&bus->ioctl_resp_wait, &wait);
+	set_current_state(TASK_INTERRUPTIBLE);
 
-	brcmf_sdbrcm_sdlock(bus);
-	rxlen = bus->rxlen;
-	memcpy(msg, bus->rxctl, min(msglen, rxlen));
-	bus->rxlen = 0;
-	brcmf_sdbrcm_sdunlock(bus);
+	while (!(*condition) && (!signal_pending(current) && timeout))
+		timeout = schedule_timeout(timeout);
 
-	if (rxlen) {
-		brcmf_dbg(CTL, "resumed on rxctl frame, got %d expected %d\n",
-			  rxlen, msglen);
-	} else if (timeleft == 0) {
-		brcmf_dbg(ERROR, "resumed on timeout\n");
-#ifdef BCMDBG
-		brcmf_sdbrcm_sdlock(bus);
-		brcmf_sdbrcm_checkdied(bus, NULL, 0);
-		brcmf_sdbrcm_sdunlock(bus);
-#endif				/* BCMDBG */
-	} else if (pending == true) {
-		brcmf_dbg(CTL, "cancelled\n");
-		return -ERESTARTSYS;
-	} else {
-		brcmf_dbg(CTL, "resumed for unknown reason?\n");
-#ifdef BCMDBG
-		brcmf_sdbrcm_sdlock(bus);
-		brcmf_sdbrcm_checkdied(bus, NULL, 0);
-		brcmf_sdbrcm_sdunlock(bus);
-#endif				/* BCMDBG */
-	}
+	if (signal_pending(current))
+		*pending = true;
 
-	if (rxlen)
-		bus->drvr->rx_ctlpkts++;
-	else
-		bus->drvr->rx_ctlerrs++;
+	set_current_state(TASK_RUNNING);
+	remove_wait_queue(&bus->ioctl_resp_wait, &wait);
 
-	return rxlen ? (int)rxlen : -ETIMEDOUT;
+	return timeout;
 }
 
-static int
-brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
-		 uint size)
+static int brcmf_sdbrcm_ioctl_resp_wake(struct brcmf_bus *bus)
 {
-	int bcmerror = 0;
-	u32 sdaddr;
-	uint dsize;
+	if (waitqueue_active(&bus->ioctl_resp_wait))
+		wake_up_interruptible(&bus->ioctl_resp_wait);
 
-	/* Determine initial transfer parameters */
-	sdaddr = address & SBSDIO_SB_OFT_ADDR_MASK;
-	if ((sdaddr + size) & SBSDIO_SBWINDOW_MASK)
-		dsize = (SBSDIO_SB_OFT_ADDR_LIMIT - sdaddr);
-	else
-		dsize = size;
+	return 0;
+}
+static void
+brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
+{
+	uint rdlen, pad;
 
-	/* Set the backplane window to include the start address */
-	bcmerror = brcmf_sdcard_set_sbaddr_window(bus->sdiodev, address);
-	if (bcmerror) {
-		brcmf_dbg(ERROR, "window change failed\n");
-		goto xfer_done;
+	int sdret;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	/* Set rxctl for frame (w/optional alignment) */
+	bus->rxctl = bus->rxbuf;
+	if (brcmf_alignctl) {
+		bus->rxctl += firstread;
+		pad = ((unsigned long)bus->rxctl % BRCMF_SDALIGN);
+		if (pad)
+			bus->rxctl += (BRCMF_SDALIGN - pad);
+		bus->rxctl -= firstread;
 	}
 
-	/* Do the transfer(s) */
-	while (size) {
-		brcmf_dbg(INFO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
-			  write ? "write" : "read", dsize,
-			  sdaddr, address & SBSDIO_SBWINDOW_MASK);
-		bcmerror = brcmf_sdcard_rwdata(bus->sdiodev, write,
-					       sdaddr, data, dsize);
-		if (bcmerror) {
-			brcmf_dbg(ERROR, "membytes transfer failed\n");
-			break;
-		}
+	/* Copy the already-read portion over */
+	memcpy(bus->rxctl, hdr, firstread);
+	if (len <= firstread)
+		goto gotpkt;
 
-		/* Adjust for next transfer (if any) */
-		size -= dsize;
-		if (size) {
-			data += dsize;
-			address += dsize;
-			bcmerror = brcmf_sdcard_set_sbaddr_window(bus->sdiodev,
-								  address);
-			if (bcmerror) {
-				brcmf_dbg(ERROR, "window change failed\n");
-				break;
-			}
-			sdaddr = 0;
-			dsize = min_t(uint, SBSDIO_SB_OFT_ADDR_LIMIT, size);
-		}
+	/* Raise rdlen to next SDIO block to avoid tail command */
+	rdlen = len - firstread;
+	if (bus->roundup && bus->blocksize && (rdlen > bus->blocksize)) {
+		pad = bus->blocksize - (rdlen % bus->blocksize);
+		if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
+		    ((len + pad) < bus->drvr->maxctl))
+			rdlen += pad;
+	} else if (rdlen % BRCMF_SDALIGN) {
+		rdlen += BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
 	}
 
-xfer_done:
-	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdcard_set_sbaddr_window(bus->sdiodev, bus->sdiodev->sbwad))
-		brcmf_dbg(ERROR, "FAILED to set window back to 0x%x\n",
-			  bus->sdiodev->sbwad);
+	/* Satisfy length-alignment requirements */
+	if (forcealign && (rdlen & (ALIGNMENT - 1)))
+		rdlen = roundup(rdlen, ALIGNMENT);
 
-	return bcmerror;
-}
+	/* Drop if the read is too big or it exceeds our maximum */
+	if ((rdlen + firstread) > bus->drvr->maxctl) {
+		brcmf_dbg(ERROR, "%d-byte control read exceeds %d-byte buffer\n",
+			  rdlen, bus->drvr->maxctl);
+		bus->drvr->rx_errors++;
+		brcmf_sdbrcm_rxfail(bus, false, false);
+		goto done;
+	}
 
-#ifdef BCMDBG
-static int
-brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
-{
-	u32 addr;
-	int rv;
+	if ((len - doff) > bus->drvr->maxctl) {
+		brcmf_dbg(ERROR, "%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
+			  len, len - doff, bus->drvr->maxctl);
+		bus->drvr->rx_errors++;
+		bus->rx_toolong++;
+		brcmf_sdbrcm_rxfail(bus, false, false);
+		goto done;
+	}
 
-	/* Read last word in memory to determine address of
-			 sdpcm_shared structure */
-	rv = brcmf_sdbrcm_membytes(bus, false, bus->ramsize - 4, (u8 *)&addr,
-				   4);
-	if (rv < 0)
-		return rv;
+	/* Read remainder of frame body into the rxctl buffer */
+	sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
+				bus->sdiodev->sbwad,
+				SDIO_FUNC_2,
+				F2SYNC, (bus->rxctl + firstread), rdlen,
+				NULL);
+	bus->f2rxdata++;
 
-	addr = le32_to_cpu(addr);
+	/* Control frame failures need retransmission */
+	if (sdret < 0) {
+		brcmf_dbg(ERROR, "read %d control bytes failed: %d\n",
+			  rdlen, sdret);
+		bus->rxc_errors++;
+		brcmf_sdbrcm_rxfail(bus, true, true);
+		goto done;
+	}
 
-	brcmf_dbg(INFO, "sdpcm_shared address 0x%08X\n", addr);
+gotpkt:
 
-	/*
-	 * Check if addr is valid.
-	 * NVRAM length at the end of memory should have been overwritten.
-	 */
-	if (addr == 0 || ((~addr >> 16) & 0xffff) == (addr & 0xffff)) {
-		brcmf_dbg(ERROR, "address (0x%08x) of sdpcm_shared invalid\n",
-			  addr);
-		return -EBADE;
+#ifdef BCMDBG
+	if (BRCMF_BYTES_ON() && BRCMF_CTL_ON()) {
+		printk(KERN_DEBUG "RxCtrl:\n");
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, bus->rxctl, len);
 	}
+#endif
 
-	/* Read rte_shared structure */
-	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *) sh,
-			      sizeof(struct sdpcm_shared));
-	if (rv < 0)
-		return rv;
-
-	/* Endianness */
-	sh->flags = le32_to_cpu(sh->flags);
-	sh->trap_addr = le32_to_cpu(sh->trap_addr);
-	sh->assert_exp_addr = le32_to_cpu(sh->assert_exp_addr);
-	sh->assert_file_addr = le32_to_cpu(sh->assert_file_addr);
-	sh->assert_line = le32_to_cpu(sh->assert_line);
-	sh->console_addr = le32_to_cpu(sh->console_addr);
-	sh->msgtrace_addr = le32_to_cpu(sh->msgtrace_addr);
-
-	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
-		brcmf_dbg(ERROR, "sdpcm_shared version %d in brcmf is different than sdpcm_shared version %d in dongle\n",
-			  SDPCM_SHARED_VERSION,
-			  sh->flags & SDPCM_SHARED_VERSION_MASK);
-		return -EBADE;
-	}
+	/* Point to valid data and indicate its length */
+	bus->rxctl += doff;
+	bus->rxlen = len - doff;
 
-	return 0;
+done:
+	/* Awake any waiters */
+	brcmf_sdbrcm_ioctl_resp_wake(bus);
 }
 
-static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
+/* Return true if there may be more frames to read */
+static uint
+brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 {
-	int bcmerror = 0;
-	uint msize = 512;
-	char *mbuffer = NULL;
-	uint maxstrlen = 256;
-	char *str = NULL;
-	struct brcmf_trap tr;
-	struct sdpcm_shared sdpcm_shared;
-	struct brcmu_strbuf strbuf;
-
-	brcmf_dbg(TRACE, "Enter\n");
+	u16 len, check;	/* Extracted hardware header fields */
+	u8 chan, seq, doff;	/* Extracted software header fields */
+	u8 fcbits;		/* Extracted fcbits from software header */
 
-	if (data == NULL) {
-		/*
-		 * Called after a rx ctrl timeout. "data" is NULL.
-		 * allocate memory to trace the trap or assert.
-		 */
-		size = msize;
-		mbuffer = data = kmalloc(msize, GFP_ATOMIC);
-		if (mbuffer == NULL) {
-			brcmf_dbg(ERROR, "kmalloc(%d) failed\n", msize);
-			bcmerror = -ENOMEM;
-			goto done;
-		}
-	}
+	struct sk_buff *pkt;		/* Packet for event or data frames */
+	u16 pad;		/* Number of pad bytes to read */
+	u16 rdlen;		/* Total number of bytes to read */
+	u8 rxseq;		/* Next sequence number to expect */
+	uint rxleft = 0;	/* Remaining number of frames allowed */
+	int sdret;		/* Return code from calls */
+	u8 txmax;		/* Maximum tx sequence offered */
+	bool len_consistent;	/* Result of comparing readahead len and
+					 len from hw-hdr */
+	u8 *rxbuf;
+	int ifidx = 0;
+	uint rxcount = 0;	/* Total frames read */
 
-	str = kmalloc(maxstrlen, GFP_ATOMIC);
-	if (str == NULL) {
-		brcmf_dbg(ERROR, "kmalloc(%d) failed\n", maxstrlen);
-		bcmerror = -ENOMEM;
-		goto done;
-	}
+	brcmf_dbg(TRACE, "Enter\n");
 
-	bcmerror = brcmf_sdbrcm_readshared(bus, &sdpcm_shared);
-	if (bcmerror < 0)
-		goto done;
+	/* Not finished unless we encounter no more frames indication */
+	*finished = false;
 
-	brcmu_binit(&strbuf, data, size);
+	for (rxseq = bus->rx_seq, rxleft = maxframes;
+	     !bus->rxskip && rxleft && bus->drvr->busstate != BRCMF_BUS_DOWN;
+	     rxseq++, rxleft--) {
 
-	brcmu_bprintf(&strbuf,
-		    "msgtrace address : 0x%08X\nconsole address  : 0x%08X\n",
-		    sdpcm_shared.msgtrace_addr, sdpcm_shared.console_addr);
+		/* Handle glomming separately */
+		if (bus->glom || bus->glomd) {
+			u8 cnt;
+			brcmf_dbg(GLOM, "calling rxglom: glomd %p, glom %p\n",
+				  bus->glomd, bus->glom);
+			cnt = brcmf_sdbrcm_rxglom(bus, rxseq);
+			brcmf_dbg(GLOM, "rxglom returned %d\n", cnt);
+			rxseq += cnt - 1;
+			rxleft = (rxleft > cnt) ? (rxleft - cnt) : 1;
+			continue;
+		}
 
-	if ((sdpcm_shared.flags & SDPCM_SHARED_ASSERT_BUILT) == 0)
-		/* NOTE: Misspelled assert is intentional - DO NOT FIX.
-		 * (Avoids conflict with real asserts for programmatic
-		 * parsing of output.)
-		 */
-		brcmu_bprintf(&strbuf, "Assrt not built in dongle\n");
+		/* Try doing single read if we can */
+		if (brcmf_readahead && bus->nextlen) {
+			u16 nextlen = bus->nextlen;
+			bus->nextlen = 0;
 
-	if ((sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP)) ==
-	    0) {
-		/* NOTE: Misspelled assert is intentional - DO NOT FIX.
-		 * (Avoids conflict with real asserts for programmatic
-		 * parsing of output.)
-		 */
-		brcmu_bprintf(&strbuf, "No trap%s in dongle",
-			    (sdpcm_shared.flags & SDPCM_SHARED_ASSERT_BUILT)
-			    ? "/assrt" : "");
-	} else {
-		if (sdpcm_shared.flags & SDPCM_SHARED_ASSERT) {
-			/* Download assert */
-			brcmu_bprintf(&strbuf, "Dongle assert");
-			if (sdpcm_shared.assert_exp_addr != 0) {
-				str[0] = '\0';
-				bcmerror = brcmf_sdbrcm_membytes(bus, false,
-						sdpcm_shared.assert_exp_addr,
-						(u8 *) str, maxstrlen);
-				if (bcmerror < 0)
-					goto done;
+			rdlen = len = nextlen << 4;
 
-				str[maxstrlen - 1] = '\0';
-				brcmu_bprintf(&strbuf, " expr \"%s\"", str);
+			/* Pad read to blocksize for efficiency */
+			if (bus->roundup && bus->blocksize
+			    && (rdlen > bus->blocksize)) {
+				pad =
+				    bus->blocksize -
+				    (rdlen % bus->blocksize);
+				if ((pad <= bus->roundup)
+				    && (pad < bus->blocksize)
+				    && ((rdlen + pad + firstread) <
+					MAX_RX_DATASZ))
+					rdlen += pad;
+			} else if (rdlen % BRCMF_SDALIGN) {
+				rdlen += BRCMF_SDALIGN -
+					 (rdlen % BRCMF_SDALIGN);
 			}
 
-			if (sdpcm_shared.assert_file_addr != 0) {
-				str[0] = '\0';
-				bcmerror = brcmf_sdbrcm_membytes(bus, false,
-						sdpcm_shared.assert_file_addr,
-						(u8 *) str, maxstrlen);
-				if (bcmerror < 0)
-					goto done;
+			/* We use bus->rxctl buffer in WinXP for initial
+			 * control pkt receives.
+			 * Later we use buffer-poll for data as well
+			 * as control packets.
+			 * This is required because dhd receives full
+			 * frame in gSPI unlike SDIO.
+			 * After the frame is received we have to
+			 * distinguish whether it is data
+			 * or non-data frame.
+			 */
+			/* Allocate a packet buffer */
+			pkt = brcmu_pkt_buf_get_skb(rdlen + BRCMF_SDALIGN);
+			if (!pkt) {
+				/* Give up on data, request rtx of events */
+				brcmf_dbg(ERROR, "(nextlen): brcmu_pkt_buf_get_skb failed: len %d rdlen %d expected rxseq %d\n",
+					  len, rdlen, rxseq);
+				continue;
+			} else {
+				pkt_align(pkt, rdlen, BRCMF_SDALIGN);
+				rxbuf = (u8 *) (pkt->data);
+				/* Read the entire frame */
+				sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
+						bus->sdiodev->sbwad,
+						SDIO_FUNC_2, F2SYNC,
+						rxbuf, rdlen,
+						pkt);
+				bus->f2rxdata++;
 
-				str[maxstrlen - 1] = '\0';
-				brcmu_bprintf(&strbuf, " file \"%s\"", str);
+				if (sdret < 0) {
+					brcmf_dbg(ERROR, "(nextlen): read %d bytes failed: %d\n",
+						  rdlen, sdret);
+					brcmu_pkt_buf_free_skb(pkt);
+					bus->drvr->rx_errors++;
+					/* Force retry w/normal header read.
+					 * Don't attempt NAK for
+					 * gSPI
+					 */
+					brcmf_sdbrcm_rxfail(bus, true, true);
+					continue;
+				}
 			}
 
-			brcmu_bprintf(&strbuf, " line %d ",
-				    sdpcm_shared.assert_line);
-		}
-
-		if (sdpcm_shared.flags & SDPCM_SHARED_TRAP) {
-			bcmerror = brcmf_sdbrcm_membytes(bus, false,
-					sdpcm_shared.trap_addr, (u8 *)&tr,
-					sizeof(struct brcmf_trap));
-			if (bcmerror < 0)
-				goto done;
-
-			brcmu_bprintf(&strbuf,
-				    "Dongle trap type 0x%x @ epc 0x%x, cpsr 0x%x, spsr 0x%x, sp 0x%x,"
-				    "lp 0x%x, rpc 0x%x Trap offset 0x%x, "
-				    "r0 0x%x, r1 0x%x, r2 0x%x, r3 0x%x, r4 0x%x, r5 0x%x, r6 0x%x, r7 0x%x\n",
-				    tr.type, tr.epc, tr.cpsr, tr.spsr, tr.r13,
-				    tr.r14, tr.pc, sdpcm_shared.trap_addr,
-				    tr.r0, tr.r1, tr.r2, tr.r3, tr.r4, tr.r5,
-				    tr.r6, tr.r7);
-		}
-	}
+			/* Now check the header */
+			memcpy(bus->rxhdr, rxbuf, SDPCM_HDRLEN);
 
-	if (sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP))
-		brcmf_dbg(ERROR, "%s\n", strbuf.origbuf);
+			/* Extract hardware header fields */
+			len = get_unaligned_le16(bus->rxhdr);
+			check = get_unaligned_le16(bus->rxhdr + sizeof(u16));
 
-#ifdef BCMDBG
-	if (sdpcm_shared.flags & SDPCM_SHARED_TRAP)
-		/* Mem dump to a file on device */
-		brcmf_sdbrcm_mem_dump(bus);
+			/* All zeros means readahead info was bad */
+			if (!(len | check)) {
+				brcmf_dbg(INFO, "(nextlen): read zeros in HW header???\n");
+				brcmf_sdbrcm_pktfree2(bus, pkt);
+				continue;
+			}
 
-#endif				/* BCMDBG */
+			/* Validate check bytes */
+			if ((u16)~(len ^ check)) {
+				brcmf_dbg(ERROR, "(nextlen): HW hdr error: nextlen/len/check 0x%04x/0x%04x/0x%04x\n",
+					  nextlen, len, check);
+				bus->rx_badhdr++;
+				brcmf_sdbrcm_rxfail(bus, false, false);
+				brcmf_sdbrcm_pktfree2(bus, pkt);
+				continue;
+			}
 
-done:
-	kfree(mbuffer);
-	kfree(str);
+			/* Validate frame length */
+			if (len < SDPCM_HDRLEN) {
+				brcmf_dbg(ERROR, "(nextlen): HW hdr length invalid: %d\n",
+					  len);
+				brcmf_sdbrcm_pktfree2(bus, pkt);
+				continue;
+			}
 
-	return bcmerror;
-}
+			/* Check for consistency withreadahead info */
+			len_consistent = (nextlen != (roundup(len, 16) >> 4));
+			if (len_consistent) {
+				/* Mismatch, force retry w/normal
+					header (may be >4K) */
+				brcmf_dbg(ERROR, "(nextlen): mismatch, nextlen %d len %d rnd %d; expected rxseq %d\n",
+					  nextlen, len, roundup(len, 16),
+					  rxseq);
+				brcmf_sdbrcm_rxfail(bus, true, true);
+				brcmf_sdbrcm_pktfree2(bus, pkt);
+				continue;
+			}
 
-static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
-{
-	int ret = 0;
-	int size;		/* Full mem size */
-	int start = 0;		/* Start address */
-	int read_size = 0;	/* Read size of each iteration */
-	u8 *buf = NULL, *databuf = NULL;
+			/* Extract software header fields */
+			chan = SDPCM_PACKET_CHANNEL(
+					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
+			seq = SDPCM_PACKET_SEQUENCE(
+					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
+			doff = SDPCM_DOFFSET_VALUE(
+					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
+			txmax = SDPCM_WINDOW_VALUE(
+					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
 
-	/* Get full mem size */
-	size = bus->ramsize;
-	buf = kmalloc(size, GFP_ATOMIC);
-	if (!buf) {
-		brcmf_dbg(ERROR, "Out of memory (%d bytes)\n", size);
-		return -1;
-	}
+			bus->nextlen =
+			    bus->rxhdr[SDPCM_FRAMETAG_LEN +
+				       SDPCM_NEXTLEN_OFFSET];
+			if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
+				brcmf_dbg(INFO, "(nextlen): got frame w/nextlen too large (%d), seq %d\n",
+					  bus->nextlen, seq);
+				bus->nextlen = 0;
+			}
 
-	/* Read mem content */
-	printk(KERN_DEBUG "Dump dongle memory");
-	databuf = buf;
-	while (size) {
-		read_size = min(MEMBLOCK, size);
-		ret = brcmf_sdbrcm_membytes(bus, false, start, databuf,
-					  read_size);
-		if (ret) {
-			brcmf_dbg(ERROR, "Error membytes %d\n", ret);
-			kfree(buf);
-			return -1;
-		}
-		printk(".");
+			bus->drvr->rx_readahead_cnt++;
 
-		/* Decrement size and increment start address */
-		size -= read_size;
-		start += read_size;
-		databuf += read_size;
-	}
-	printk(KERN_DEBUG "Done\n");
+			/* Handle Flow Control */
+			fcbits = SDPCM_FCMASK_VALUE(
+					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
 
-	/* free buf before return !!! */
-	if (brcmf_write_to_file(bus->drvr, buf, bus->ramsize)) {
-		brcmf_dbg(ERROR, "Error writing to files\n");
-		return -1;
-	}
+			if (bus->flowcontrol != fcbits) {
+				if (~bus->flowcontrol & fcbits)
+					bus->fc_xoff++;
 
-	/* buf free handled in brcmf_write_to_file, not here */
-	return 0;
-}
+				if (bus->flowcontrol & ~fcbits)
+					bus->fc_xon++;
 
-#define CONSOLE_LINE_MAX	192
+				bus->fc_rcvd++;
+				bus->flowcontrol = fcbits;
+			}
 
-static int brcmf_sdbrcm_readconsole(struct brcmf_bus *bus)
-{
-	struct brcmf_console *c = &bus->console;
-	u8 line[CONSOLE_LINE_MAX], ch;
-	u32 n, idx, addr;
-	int rv;
+			/* Check and update sequence number */
+			if (rxseq != seq) {
+				brcmf_dbg(INFO, "(nextlen): rx_seq %d, expected %d\n",
+					  seq, rxseq);
+				bus->rx_badseq++;
+				rxseq = seq;
+			}
 
-	/* Don't do anything until FWREADY updates console address */
-	if (bus->console_addr == 0)
-		return 0;
+			/* Check window for sanity */
+			if ((u8) (txmax - bus->tx_seq) > 0x40) {
+				brcmf_dbg(ERROR, "got unlikely tx max %d with tx_seq %d\n",
+					  txmax, bus->tx_seq);
+				txmax = bus->tx_seq + 2;
+			}
+			bus->tx_max = txmax;
 
-	/* Read console log struct */
-	addr = bus->console_addr + offsetof(struct rte_console, log);
-	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *)&c->log,
-				sizeof(c->log));
-	if (rv < 0)
-		return rv;
+#ifdef BCMDBG
+			if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
+				printk(KERN_DEBUG "Rx Data:\n");
+				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+						     rxbuf, len);
+			} else if (BRCMF_HDRS_ON()) {
+				printk(KERN_DEBUG "RxHdr:\n");
+				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+						     bus->rxhdr, SDPCM_HDRLEN);
+			}
+#endif
 
-	/* Allocate console buffer (one time only) */
-	if (c->buf == NULL) {
-		c->bufsize = le32_to_cpu(c->log.buf_size);
-		c->buf = kmalloc(c->bufsize, GFP_ATOMIC);
-		if (c->buf == NULL)
-			return -ENOMEM;
-	}
+			if (chan == SDPCM_CONTROL_CHANNEL) {
+				brcmf_dbg(ERROR, "(nextlen): readahead on control packet %d?\n",
+					  seq);
+				/* Force retry w/normal header read */
+				bus->nextlen = 0;
+				brcmf_sdbrcm_rxfail(bus, false, true);
+				brcmf_sdbrcm_pktfree2(bus, pkt);
+				continue;
+			}
 
-	idx = le32_to_cpu(c->log.idx);
+			/* Validate data offset */
+			if ((doff < SDPCM_HDRLEN) || (doff > len)) {
+				brcmf_dbg(ERROR, "(nextlen): bad data offset %d: HW len %d min %d\n",
+					  doff, len, SDPCM_HDRLEN);
+				brcmf_sdbrcm_rxfail(bus, false, false);
+				brcmf_sdbrcm_pktfree2(bus, pkt);
+				continue;
+			}
 
-	/* Protect against corrupt value */
-	if (idx > c->bufsize)
-		return -EBADE;
+			/* All done with this one -- now deliver the packet */
+			goto deliver;
+		}
 
-	/* Skip reading the console buffer if the index pointer
-	 has not moved */
-	if (idx == c->last)
-		return 0;
+		/* Read frame header (hardware and software) */
+		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
+				SDIO_FUNC_2, F2SYNC, bus->rxhdr, firstread,
+				NULL);
+		bus->f2rxhdrs++;
 
-	/* Read the console buffer */
-	addr = le32_to_cpu(c->log.buf);
-	rv = brcmf_sdbrcm_membytes(bus, false, addr, c->buf, c->bufsize);
-	if (rv < 0)
-		return rv;
+		if (sdret < 0) {
+			brcmf_dbg(ERROR, "RXHEADER FAILED: %d\n", sdret);
+			bus->rx_hdrfail++;
+			brcmf_sdbrcm_rxfail(bus, true, true);
+			continue;
+		}
+#ifdef BCMDBG
+		if (BRCMF_BYTES_ON() || BRCMF_HDRS_ON()) {
+			printk(KERN_DEBUG "RxHdr:\n");
+			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+					     bus->rxhdr, SDPCM_HDRLEN);
+		}
+#endif
 
-	while (c->last != idx) {
-		for (n = 0; n < CONSOLE_LINE_MAX - 2; n++) {
-			if (c->last == idx) {
-				/* This would output a partial line.
-				 * Instead, back up
-				 * the buffer pointer and output this
-				 * line next time around.
-				 */
-				if (c->last >= n)
-					c->last -= n;
-				else
-					c->last = c->bufsize - n;
-				goto break2;
-			}
-			ch = c->buf[c->last];
-			c->last = (c->last + 1) % c->bufsize;
-			if (ch == '\n')
-				break;
-			line[n] = ch;
+		/* Extract hardware header fields */
+		len = get_unaligned_le16(bus->rxhdr);
+		check = get_unaligned_le16(bus->rxhdr + sizeof(u16));
+
+		/* All zeros means no more frames */
+		if (!(len | check)) {
+			*finished = true;
+			break;
 		}
 
-		if (n > 0) {
-			if (line[n - 1] == '\r')
-				n--;
-			line[n] = 0;
-			printk(KERN_DEBUG "CONSOLE: %s\n", line);
+		/* Validate check bytes */
+		if ((u16) ~(len ^ check)) {
+			brcmf_dbg(ERROR, "HW hdr err: len/check 0x%04x/0x%04x\n",
+				  len, check);
+			bus->rx_badhdr++;
+			brcmf_sdbrcm_rxfail(bus, false, false);
+			continue;
 		}
-	}
-break2:
 
-	return 0;
-}
-#endif				/* BCMDBG */
+		/* Validate frame length */
+		if (len < SDPCM_HDRLEN) {
+			brcmf_dbg(ERROR, "HW hdr length invalid: %d\n", len);
+			continue;
+		}
 
-static int brcmf_sdbrcm_downloadvars(struct brcmf_bus *bus, void *arg, int len)
-{
-	int bcmerror = 0;
+		/* Extract software header fields */
+		chan = SDPCM_PACKET_CHANNEL(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
+		seq = SDPCM_PACKET_SEQUENCE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
+		doff = SDPCM_DOFFSET_VALUE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
+		txmax = SDPCM_WINDOW_VALUE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
 
-	brcmf_dbg(TRACE, "Enter\n");
+		/* Validate data offset */
+		if ((doff < SDPCM_HDRLEN) || (doff > len)) {
+			brcmf_dbg(ERROR, "Bad data offset %d: HW len %d, min %d seq %d\n",
+				  doff, len, SDPCM_HDRLEN, seq);
+			bus->rx_badhdr++;
+			brcmf_sdbrcm_rxfail(bus, false, false);
+			continue;
+		}
 
-	/* Basic sanity checks */
-	if (bus->drvr->up) {
-		bcmerror = -EISCONN;
-		goto err;
-	}
-	if (!len) {
-		bcmerror = -EOVERFLOW;
-		goto err;
-	}
-
-	/* Free the old ones and replace with passed variables */
-	kfree(bus->vars);
-
-	bus->vars = kmalloc(len, GFP_ATOMIC);
-	bus->varsz = bus->vars ? len : 0;
-	if (bus->vars == NULL) {
-		bcmerror = -ENOMEM;
-		goto err;
-	}
-
-	/* Copy the passed variables, which should include the
-		 terminating double-null */
-	memcpy(bus->vars, arg, bus->varsz);
-err:
-	return bcmerror;
-}
-
-static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
-{
-	int bcmerror = 0;
-	u32 varsize;
-	u32 varaddr;
-	u8 *vbuffer;
-	u32 varsizew;
-#ifdef BCMDBG
-	char *nvram_ularray;
-#endif				/* BCMDBG */
+		/* Save the readahead length if there is one */
+		bus->nextlen =
+		    bus->rxhdr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
+		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
+			brcmf_dbg(INFO, "(nextlen): got frame w/nextlen too large (%d), seq %d\n",
+				  bus->nextlen, seq);
+			bus->nextlen = 0;
+		}
 
-	/* Even if there are no vars are to be written, we still
-		 need to set the ramsize. */
-	varsize = bus->varsz ? roundup(bus->varsz, 4) : 0;
-	varaddr = (bus->ramsize - 4) - varsize;
+		/* Handle Flow Control */
+		fcbits = SDPCM_FCMASK_VALUE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
 
-	if (bus->vars) {
-		vbuffer = kzalloc(varsize, GFP_ATOMIC);
-		if (!vbuffer)
-			return -ENOMEM;
+		if (bus->flowcontrol != fcbits) {
+			if (~bus->flowcontrol & fcbits)
+				bus->fc_xoff++;
 
-		memcpy(vbuffer, bus->vars, bus->varsz);
+			if (bus->flowcontrol & ~fcbits)
+				bus->fc_xon++;
 
-		/* Write the vars list */
-		bcmerror =
-		    brcmf_sdbrcm_membytes(bus, true, varaddr, vbuffer, varsize);
-#ifdef BCMDBG
-		/* Verify NVRAM bytes */
-		brcmf_dbg(INFO, "Compare NVRAM dl & ul; varsize=%d\n", varsize);
-		nvram_ularray = kmalloc(varsize, GFP_ATOMIC);
-		if (!nvram_ularray)
-			return -ENOMEM;
+			bus->fc_rcvd++;
+			bus->flowcontrol = fcbits;
+		}
 
-		/* Upload image to verify downloaded contents. */
-		memset(nvram_ularray, 0xaa, varsize);
+		/* Check and update sequence number */
+		if (rxseq != seq) {
+			brcmf_dbg(INFO, "rx_seq %d, expected %d\n", seq, rxseq);
+			bus->rx_badseq++;
+			rxseq = seq;
+		}
 
-		/* Read the vars list to temp buffer for comparison */
-		bcmerror =
-		    brcmf_sdbrcm_membytes(bus, false, varaddr, nvram_ularray,
-				     varsize);
-		if (bcmerror) {
-			brcmf_dbg(ERROR, "error %d on reading %d nvram bytes at 0x%08x\n",
-				  bcmerror, varsize, varaddr);
+		/* Check window for sanity */
+		if ((u8) (txmax - bus->tx_seq) > 0x40) {
+			brcmf_dbg(ERROR, "unlikely tx max %d with tx_seq %d\n",
+				  txmax, bus->tx_seq);
+			txmax = bus->tx_seq + 2;
 		}
-		/* Compare the org NVRAM with the one read from RAM */
-		if (memcmp(vbuffer, nvram_ularray, varsize))
-			brcmf_dbg(ERROR, "Downloaded NVRAM image is corrupted\n");
-		else
-			brcmf_dbg(ERROR, "Download/Upload/Compare of NVRAM ok\n");
+		bus->tx_max = txmax;
 
-		kfree(nvram_ularray);
-#endif				/* BCMDBG */
+		/* Call a separate function for control frames */
+		if (chan == SDPCM_CONTROL_CHANNEL) {
+			brcmf_sdbrcm_read_control(bus, bus->rxhdr, len, doff);
+			continue;
+		}
 
-		kfree(vbuffer);
-	}
+		/* precondition: chan is either SDPCM_DATA_CHANNEL,
+		   SDPCM_EVENT_CHANNEL, SDPCM_TEST_CHANNEL or
+		   SDPCM_GLOM_CHANNEL */
 
-	/* adjust to the user specified RAM */
-	brcmf_dbg(INFO, "Physical memory size: %d, usable memory size: %d\n",
-		  bus->orig_ramsize, bus->ramsize);
-	brcmf_dbg(INFO, "Vars are at %d, orig varsize is %d\n",
-		  varaddr, varsize);
-	varsize = ((bus->orig_ramsize - 4) - varaddr);
+		/* Length to read */
+		rdlen = (len > firstread) ? (len - firstread) : 0;
 
-	/*
-	 * Determine the length token:
-	 * Varsize, converted to words, in lower 16-bits, checksum
-	 * in upper 16-bits.
-	 */
-	if (bcmerror) {
-		varsizew = 0;
-	} else {
-		varsizew = varsize / 4;
-		varsizew = (~varsizew << 16) | (varsizew & 0x0000FFFF);
-		varsizew = cpu_to_le32(varsizew);
-	}
+		/* May pad read to blocksize for efficiency */
+		if (bus->roundup && bus->blocksize &&
+			(rdlen > bus->blocksize)) {
+			pad = bus->blocksize - (rdlen % bus->blocksize);
+			if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
+			    ((rdlen + pad + firstread) < MAX_RX_DATASZ))
+				rdlen += pad;
+		} else if (rdlen % BRCMF_SDALIGN) {
+			rdlen += BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
+		}
 
-	brcmf_dbg(INFO, "New varsize is %d, length token=0x%08x\n",
-		  varsize, varsizew);
+		/* Satisfy length-alignment requirements */
+		if (forcealign && (rdlen & (ALIGNMENT - 1)))
+			rdlen = roundup(rdlen, ALIGNMENT);
 
-	/* Write the length token to the last word */
-	bcmerror = brcmf_sdbrcm_membytes(bus, true, (bus->orig_ramsize - 4),
-				    (u8 *)&varsizew, 4);
+		if ((rdlen + firstread) > MAX_RX_DATASZ) {
+			/* Too long -- skip this frame */
+			brcmf_dbg(ERROR, "too long: len %d rdlen %d\n",
+				  len, rdlen);
+			bus->drvr->rx_errors++;
+			bus->rx_toolong++;
+			brcmf_sdbrcm_rxfail(bus, false, false);
+			continue;
+		}
 
-	return bcmerror;
-}
+		pkt = brcmu_pkt_buf_get_skb(rdlen + firstread + BRCMF_SDALIGN);
+		if (!pkt) {
+			/* Give up on data, request rtx of events */
+			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: rdlen %d chan %d\n",
+				  rdlen, chan);
+			bus->drvr->rx_dropped++;
+			brcmf_sdbrcm_rxfail(bus, false, RETRYCHAN(chan));
+			continue;
+		}
 
-static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
-{
-	uint retries;
-	u32 regdata;
-	int bcmerror = 0;
+		/* Leave room for what we already read, and align remainder */
+		skb_pull(pkt, firstread);
+		pkt_align(pkt, rdlen, BRCMF_SDALIGN);
 
-	/* To enter download state, disable ARM and reset SOCRAM.
-	 * To exit download state, simply reset ARM (default is RAM boot).
-	 */
-	if (enter) {
-		bus->alp_only = true;
+		/* Read the remaining frame data */
+		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
+				SDIO_FUNC_2, F2SYNC, ((u8 *) (pkt->data)),
+				rdlen, pkt);
+		bus->f2rxdata++;
 
-		brcmf_sdbrcm_chip_disablecore(bus->sdiodev,
-					      bus->ci->armcorebase);
+		if (sdret < 0) {
+			brcmf_dbg(ERROR, "read %d %s bytes failed: %d\n", rdlen,
+				  ((chan == SDPCM_EVENT_CHANNEL) ? "event"
+				   : ((chan == SDPCM_DATA_CHANNEL) ? "data"
+				      : "test")), sdret);
+			brcmu_pkt_buf_free_skb(pkt);
+			bus->drvr->rx_errors++;
+			brcmf_sdbrcm_rxfail(bus, true, RETRYCHAN(chan));
+			continue;
+		}
 
-		brcmf_sdbrcm_chip_resetcore(bus->sdiodev, bus->ci->ramcorebase);
+		/* Copy the already-read portion */
+		skb_push(pkt, firstread);
+		memcpy(pkt->data, bus->rxhdr, firstread);
 
-		/* Clear the top bit of memory */
-		if (bus->ramsize) {
-			u32 zeros = 0;
-			brcmf_sdbrcm_membytes(bus, true, bus->ramsize - 4,
-					 (u8 *)&zeros, 4);
-		}
-	} else {
-		regdata = brcmf_sdcard_reg_read(bus->sdiodev,
-			CORE_SB(bus->ci->ramcorebase, sbtmstatelow), 4);
-		regdata &= (SBTML_RESET | SBTML_REJ_MASK |
-			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
-		if ((SICF_CLOCK_EN << SBTML_SICF_SHIFT) != regdata) {
-			brcmf_dbg(ERROR, "SOCRAM core is down after reset?\n");
-			bcmerror = -EBADE;
-			goto fail;
+#ifdef BCMDBG
+		if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
+			printk(KERN_DEBUG "Rx Data:\n");
+			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+					     pkt->data, len);
 		}
+#endif
 
-		bcmerror = brcmf_sdbrcm_write_vars(bus);
-		if (bcmerror) {
-			brcmf_dbg(ERROR, "no vars written to RAM\n");
-			bcmerror = 0;
+deliver:
+		/* Save superframe descriptor and allocate packet frame */
+		if (chan == SDPCM_GLOM_CHANNEL) {
+			if (SDPCM_GLOMDESC(&bus->rxhdr[SDPCM_FRAMETAG_LEN])) {
+				brcmf_dbg(GLOM, "glom descriptor, %d bytes:\n",
+					  len);
+#ifdef BCMDBG
+				if (BRCMF_GLOM_ON()) {
+					printk(KERN_DEBUG "Glom Data:\n");
+					print_hex_dump_bytes("",
+							     DUMP_PREFIX_OFFSET,
+							     pkt->data, len);
+				}
+#endif
+				__skb_trim(pkt, len);
+				skb_pull(pkt, SDPCM_HDRLEN);
+				bus->glomd = pkt;
+			} else {
+				brcmf_dbg(ERROR, "%s: glom superframe w/o "
+					  "descriptor!\n", __func__);
+				brcmf_sdbrcm_rxfail(bus, false, false);
+			}
+			continue;
 		}
 
-		w_sdreg32(bus, 0xFFFFFFFF,
-			  offsetof(struct sdpcmd_regs, intstatus), &retries);
+		/* Fill in packet len and prio, deliver upward */
+		__skb_trim(pkt, len);
+		skb_pull(pkt, doff);
 
-		brcmf_sdbrcm_chip_resetcore(bus->sdiodev, bus->ci->armcorebase);
-
-		/* Allow HT Clock now that the ARM is running. */
-		bus->alp_only = false;
+		if (pkt->len == 0) {
+			brcmu_pkt_buf_free_skb(pkt);
+			continue;
+		} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx, pkt) != 0) {
+			brcmf_dbg(ERROR, "rx protocol error\n");
+			brcmu_pkt_buf_free_skb(pkt);
+			bus->drvr->rx_errors++;
+			continue;
+		}
 
-		bus->drvr->busstate = BRCMF_BUS_LOAD;
+		/* Unlock during rx call */
+		brcmf_sdbrcm_sdunlock(bus);
+		brcmf_rx_frame(bus->drvr, ifidx, pkt, 1);
+		brcmf_sdbrcm_sdlock(bus);
 	}
-fail:
-	return bcmerror;
+	rxcount = maxframes - rxleft;
+#ifdef BCMDBG
+	/* Message if we hit the limit */
+	if (!rxleft)
+		brcmf_dbg(DATA, "hit rx limit of %d frames\n",
+			  maxframes);
+	else
+#endif				/* BCMDBG */
+		brcmf_dbg(DATA, "processed %d frames\n", rxcount);
+	/* Back off rxseq if awaiting rtx, update rx_seq */
+	if (bus->rxskip)
+		rxseq--;
+	bus->rx_seq = rxseq;
+
+	return rxcount;
 }
 
-void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
+static int
+brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn, uint flags,
+		    u8 *buf, uint nbytes, struct sk_buff *pkt)
 {
-	u32 local_hostintmask;
-	u8 saveclk;
-	uint retries;
-	int err;
+	return brcmf_sdcard_send_buf
+		(bus->sdiodev, addr, fn, flags, buf, nbytes, pkt);
+}
+
+static void
+brcmf_sdbrcm_wait_for_event(struct brcmf_bus *bus, bool *lockvar)
+{
+	brcmf_sdbrcm_sdunlock(bus);
+	wait_event_interruptible_timeout(bus->ctrl_wait,
+					 (*lockvar == false), HZ * 2);
+	brcmf_sdbrcm_sdlock(bus);
+	return;
+}
+
+static void
+brcmf_sdbrcm_wait_event_wakeup(struct brcmf_bus *bus)
+{
+	if (waitqueue_active(&bus->ctrl_wait))
+		wake_up_interruptible(&bus->ctrl_wait);
+	return;
+}
+
+/* Writes a HW/SW header into the packet and sends it. */
+/* Assumes: (a) header space already there, (b) caller holds lock */
+static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
+			      uint chan, bool free_pkt)
+{
+	int ret;
+	u8 *frame;
+	u16 len, pad = 0;
+	u32 swheader;
+	uint retries = 0;
+	struct sk_buff *new;
+	int i;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (enforce_mutex)
-		brcmf_sdbrcm_sdlock(bus);
+	if (bus->drvr->dongle_reset) {
+		ret = -EPERM;
+		goto done;
+	}
 
-	bus_wake(bus);
+	frame = (u8 *) (pkt->data);
 
-	/* Enable clock for device interrupts */
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+	/* Add alignment padding, allocate new packet if needed */
+	pad = ((unsigned long)frame % BRCMF_SDALIGN);
+	if (pad) {
+		if (skb_headroom(pkt) < pad) {
+			brcmf_dbg(INFO, "insufficient headroom %d for %d pad\n",
+				  skb_headroom(pkt), pad);
+			bus->drvr->tx_realloc++;
+			new = brcmu_pkt_buf_get_skb(pkt->len + BRCMF_SDALIGN);
+			if (!new) {
+				brcmf_dbg(ERROR, "couldn't allocate new %d-byte packet\n",
+					  pkt->len + BRCMF_SDALIGN);
+				ret = -ENOMEM;
+				goto done;
+			}
 
-	if (bus->watchdog_tsk) {
-		send_sig(SIGTERM, bus->watchdog_tsk, 1);
-		kthread_stop(bus->watchdog_tsk);
-		bus->watchdog_tsk = NULL;
+			pkt_align(new, pkt->len, BRCMF_SDALIGN);
+			memcpy(new->data, pkt->data, pkt->len);
+			if (free_pkt)
+				brcmu_pkt_buf_free_skb(pkt);
+			/* free the pkt if canned one is not used */
+			free_pkt = true;
+			pkt = new;
+			frame = (u8 *) (pkt->data);
+			/* precondition: (frame % BRCMF_SDALIGN) == 0) */
+			pad = 0;
+		} else {
+			skb_push(pkt, pad);
+			frame = (u8 *) (pkt->data);
+			/* precondition: pad + SDPCM_HDRLEN <= pkt->len */
+			memset(frame, 0, pad + SDPCM_HDRLEN);
+		}
 	}
+	/* precondition: pad < BRCMF_SDALIGN */
 
-	if (bus->dpc_tsk) {
-		send_sig(SIGTERM, bus->dpc_tsk, 1);
-		kthread_stop(bus->dpc_tsk);
-		bus->dpc_tsk = NULL;
-	} else
-		tasklet_kill(&bus->tasklet);
+	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
+	len = (u16) (pkt->len);
+	*(u16 *) frame = cpu_to_le16(len);
+	*(((u16 *) frame) + 1) = cpu_to_le16(~len);
 
-	/* Disable and clear interrupts at the chip level also */
-	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask), &retries);
-	local_hostintmask = bus->hostintmask;
-	bus->hostintmask = 0;
+	/* Software tag: channel, sequence number, data offset */
+	swheader =
+	    ((chan << SDPCM_CHANNEL_SHIFT) & SDPCM_CHANNEL_MASK) | bus->tx_seq |
+	    (((pad +
+	       SDPCM_HDRLEN) << SDPCM_DOFFSET_SHIFT) & SDPCM_DOFFSET_MASK);
 
-	/* Change our idea of bus state */
-	bus->drvr->busstate = BRCMF_BUS_DOWN;
+	put_unaligned_le32(swheader, frame + SDPCM_FRAMETAG_LEN);
+	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
 
-	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					SBSDIO_FUNC1_CHIPCLKCSR, &err);
-	if (!err) {
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				       SBSDIO_FUNC1_CHIPCLKCSR,
-				       (saveclk | SBSDIO_FORCE_HT), &err);
+#ifdef BCMDBG
+	tx_packets[pkt->priority]++;
+	if (BRCMF_BYTES_ON() &&
+	    (((BRCMF_CTL_ON() && (chan == SDPCM_CONTROL_CHANNEL)) ||
+	      (BRCMF_DATA_ON() && (chan != SDPCM_CONTROL_CHANNEL))))) {
+		printk(KERN_DEBUG "Tx Frame:\n");
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, frame, len);
+	} else if (BRCMF_HDRS_ON()) {
+		printk(KERN_DEBUG "TxHdr:\n");
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+				     frame, min_t(u16, len, 16));
 	}
-	if (err)
-		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
+#endif
 
-	/* Turn off the bus (F2), free any pending packets */
-	brcmf_dbg(INTR, "disable SDIO interrupts\n");
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
-			 SDIO_FUNC_ENABLE_1, NULL);
+	/* Raise len to next SDIO block to eliminate tail command */
+	if (bus->roundup && bus->blocksize && (len > bus->blocksize)) {
+		u16 pad = bus->blocksize - (len % bus->blocksize);
+		if ((pad <= bus->roundup) && (pad < bus->blocksize))
+				len += pad;
+	} else if (len % BRCMF_SDALIGN) {
+		len += BRCMF_SDALIGN - (len % BRCMF_SDALIGN);
+	}
 
-	/* Clear any pending interrupts now that F2 is disabled */
-	w_sdreg32(bus, local_hostintmask,
-		  offsetof(struct sdpcmd_regs, intstatus), &retries);
+	/* Some controllers have trouble with odd bytes -- round to even */
+	if (forcealign && (len & (ALIGNMENT - 1)))
+			len = roundup(len, ALIGNMENT);
 
-	/* Turn off the backplane clock (only) */
-	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
+	do {
+		ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
+					    SDIO_FUNC_2, F2SYNC, frame,
+					    len, pkt);
+		bus->f2txdata++;
 
-	/* Clear the data packet queues */
-	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
+		if (ret < 0) {
+			/* On failure, abort the command
+			 and terminate the frame */
+			brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
+				  ret);
+			bus->tx_sderrs++;
 
-	/* Clear any held glomming stuff */
-	if (bus->glomd)
-		brcmu_pkt_buf_free_skb(bus->glomd);
+			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
+			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
+					 NULL);
+			bus->f1regdata++;
 
-	if (bus->glom)
-		brcmu_pkt_buf_free_skb(bus->glom);
+			for (i = 0; i < 3; i++) {
+				u8 hi, lo;
+				hi = brcmf_sdcard_cfg_read(bus->sdiodev,
+						     SDIO_FUNC_1,
+						     SBSDIO_FUNC1_WFRAMEBCHI,
+						     NULL);
+				lo = brcmf_sdcard_cfg_read(bus->sdiodev,
+						     SDIO_FUNC_1,
+						     SBSDIO_FUNC1_WFRAMEBCLO,
+						     NULL);
+				bus->f1regdata += 2;
+				if ((hi == 0) && (lo == 0))
+					break;
+			}
 
-	bus->glom = bus->glomd = NULL;
+		}
+		if (ret == 0)
+			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
-	/* Clear rx control and wake any waiters */
-	bus->rxlen = 0;
-	brcmf_sdbrcm_ioctl_resp_wake(bus);
+	} while ((ret < 0) && retrydata && retries++ < TXRETRIES);
 
-	/* Reset some F2 state stuff */
-	bus->rxskip = false;
-	bus->tx_seq = bus->rx_seq = 0;
+done:
+	/* restore pkt buffer pointer before calling tx complete routine */
+	skb_pull(pkt, SDPCM_HDRLEN + pad);
+	brcmf_sdbrcm_sdunlock(bus);
+	brcmf_txcomplete(bus->drvr, pkt, ret != 0);
+	brcmf_sdbrcm_sdlock(bus);
 
-	if (enforce_mutex)
-		brcmf_sdbrcm_sdunlock(bus);
+	if (free_pkt)
+		brcmu_pkt_buf_free_skb(pkt);
+
+	return ret;
 }
 
-int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
+static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 {
-	struct brcmf_bus *bus = drvr->bus;
-	unsigned long timeout;
+	struct sk_buff *pkt;
+	u32 intstatus = 0;
 	uint retries = 0;
-	u8 ready, enable;
-	int err, ret = 0;
-	u8 saveclk;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	/* try to download image and nvram to the dongle */
-	if (drvr->busstate == BRCMF_BUS_DOWN) {
-		if (!(brcmf_sdbrcm_download_firmware(bus)))
-			return -1;
-	}
-
-	if (!bus->drvr)
-		return 0;
-
-	/* Start the watchdog timer */
-	bus->drvr->tickcnt = 0;
-	brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
-
-	if (enforce_mutex)
-		brcmf_sdbrcm_sdlock(bus);
-
-	/* Make sure backplane clock is on, needed to generate F2 interrupt */
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-	if (bus->clkstate != CLK_AVAIL)
-		goto exit;
+	int ret = 0, prec_out;
+	uint cnt = 0;
+	uint datalen;
+	u8 tx_prec_map;
 
-	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk =
-	    brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-				  SBSDIO_FUNC1_CHIPCLKCSR, &err);
-	if (!err) {
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				       SBSDIO_FUNC1_CHIPCLKCSR,
-				       (saveclk | SBSDIO_FORCE_HT), &err);
-	}
-	if (err) {
-		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
-		goto exit;
-	}
+	struct brcmf_pub *drvr = bus->drvr;
 
-	/* Enable function 2 (frame transfers) */
-	w_sdreg32(bus, SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT,
-		  offsetof(struct sdpcmd_regs, tosbmailboxdata), &retries);
-	enable = (SDIO_FUNC_ENABLE_1 | SDIO_FUNC_ENABLE_2);
+	brcmf_dbg(TRACE, "Enter\n");
 
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
-			       enable, NULL);
+	tx_prec_map = ~bus->flowcontrol;
 
-	timeout = jiffies + msecs_to_jiffies(BRCMF_WAIT_F2RDY);
-	ready = 0;
-	while (enable != ready) {
-		ready = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_0,
-					      SDIO_CCCR_IORx, NULL);
-		if (time_after(jiffies, timeout))
+	/* Send frames until the limit or some other event */
+	for (cnt = 0; (cnt < maxframes) && data_ok(bus); cnt++) {
+		spin_lock_bh(&bus->txqlock);
+		pkt = brcmu_pktq_mdeq(&bus->txq, tx_prec_map, &prec_out);
+		if (pkt == NULL) {
+			spin_unlock_bh(&bus->txqlock);
 			break;
-		else if (time_after(jiffies, timeout - BRCMF_WAIT_F2RDY + 50))
-			/* prevent busy waiting if it takes too long */
-			msleep_interruptible(20);
-	}
-
-	brcmf_dbg(INFO, "enable 0x%02x, ready 0x%02x\n", enable, ready);
-
-	/* If F2 successfully enabled, set core and enable interrupts */
-	if (ready == enable) {
-		/* Set up the interrupt mask and enable interrupts */
-		bus->hostintmask = HOSTINTMASK;
-		w_sdreg32(bus, bus->hostintmask,
-			  offsetof(struct sdpcmd_regs, hostintmask), &retries);
-
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				       SBSDIO_WATERMARK, 8, &err);
+		}
+		spin_unlock_bh(&bus->txqlock);
+		datalen = pkt->len - SDPCM_HDRLEN;
 
-		/* Set bus state according to enable result */
-		drvr->busstate = BRCMF_BUS_DATA;
-	}
+		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
+		if (ret)
+			bus->drvr->tx_errors++;
+		else
+			bus->drvr->dstats.tx_bytes += datalen;
 
-	else {
-		/* Disable F2 again */
-		enable = SDIO_FUNC_ENABLE_1;
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0,
-				       SDIO_CCCR_IOEx, enable, NULL);
+		/* In poll mode, need to check for other events */
+		if (!bus->intr && cnt) {
+			/* Check device status, signal pending interrupt */
+			r_sdreg32(bus, &intstatus,
+				  offsetof(struct sdpcmd_regs, intstatus),
+				  &retries);
+			bus->f2txdata++;
+			if (brcmf_sdcard_regfail(bus->sdiodev))
+				break;
+			if (intstatus & bus->hostintmask)
+				bus->ipend = true;
+		}
 	}
 
-	/* Restore previous clock setting */
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
-
-	/* If we didn't come up, turn off backplane clock */
-	if (drvr->busstate != BRCMF_BUS_DATA)
-		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
-
-exit:
-	if (enforce_mutex)
-		brcmf_sdbrcm_sdunlock(bus);
+	/* Deflow-control stack if needed */
+	if (drvr->up && (drvr->busstate == BRCMF_BUS_DATA) &&
+	    drvr->txoff && (pktq_len(&bus->txq) < TXLOW))
+		brcmf_txflowcontrol(drvr, 0, OFF);
 
-	return ret;
+	return cnt;
 }
 
-static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
+static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 {
+	u32 intstatus, newstatus = 0;
 	uint retries = 0;
-	u16 lastrbc;
-	u8 hi, lo;
-	int err;
+	uint rxlimit = brcmf_rxbound;	/* Rx frames to read before resched */
+	uint txlimit = brcmf_txbound;	/* Tx frames to send before resched */
+	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
+	bool rxdone = true;	/* Flag for no more read data */
+	bool resched = false;	/* Flag indicating resched wanted */
 
-	brcmf_dbg(ERROR, "%sterminate frame%s\n",
-		  abort ? "abort command, " : "",
-		  rtx ? ", send NAK" : "");
+	brcmf_dbg(TRACE, "Enter\n");
 
-	if (abort)
-		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
+	/* Start with leftover status bits */
+	intstatus = bus->intstatus;
 
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_FRAMECTRL,
-			       SFC_RF_TERM, &err);
-	bus->f1regdata++;
+	brcmf_sdbrcm_sdlock(bus);
 
-	/* Wait until the packet has been flushed (device/FIFO stable) */
-	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
-		hi = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					   SBSDIO_FUNC1_RFRAMEBCHI, NULL);
-		lo = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					   SBSDIO_FUNC1_RFRAMEBCLO, NULL);
-		bus->f1regdata += 2;
+	/* If waiting for HTAVAIL, check status */
+	if (bus->clkstate == CLK_PENDING) {
+		int err;
+		u8 clkctl, devctl = 0;
 
-		if ((hi == 0) && (lo == 0))
-			break;
+#ifdef BCMDBG
+		/* Check for inconsistent device control */
+		devctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+					       SBSDIO_DEVICE_CTL, &err);
+		if (err) {
+			brcmf_dbg(ERROR, "error reading DEVCTL: %d\n", err);
+			bus->drvr->busstate = BRCMF_BUS_DOWN;
+		}
+#endif				/* BCMDBG */
 
-		if ((hi > (lastrbc >> 8)) && (lo > (lastrbc & 0x00ff))) {
-			brcmf_dbg(ERROR, "count growing: last 0x%04x now 0x%04x\n",
-				  lastrbc, (hi << 8) + lo);
+		/* Read CSR, if clock on switch to AVAIL, else ignore */
+		clkctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
+		if (err) {
+			brcmf_dbg(ERROR, "error reading CSR: %d\n",
+				  err);
+			bus->drvr->busstate = BRCMF_BUS_DOWN;
+		}
+
+		brcmf_dbg(INFO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
+			  devctl, clkctl);
+
+		if (SBSDIO_HTAV(clkctl)) {
+			devctl = brcmf_sdcard_cfg_read(bus->sdiodev,
+						       SDIO_FUNC_1,
+						       SBSDIO_DEVICE_CTL, &err);
+			if (err) {
+				brcmf_dbg(ERROR, "error reading DEVCTL: %d\n",
+					  err);
+				bus->drvr->busstate = BRCMF_BUS_DOWN;
+			}
+			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
+			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+				SBSDIO_DEVICE_CTL, devctl, &err);
+			if (err) {
+				brcmf_dbg(ERROR, "error writing DEVCTL: %d\n",
+					  err);
+				bus->drvr->busstate = BRCMF_BUS_DOWN;
+			}
+			bus->clkstate = CLK_AVAIL;
+		} else {
+			goto clkwait;
 		}
-		lastrbc = (hi << 8) + lo;
 	}
 
-	if (!retries)
-		brcmf_dbg(ERROR, "count never zeroed: last 0x%04x\n", lastrbc);
-	else
-		brcmf_dbg(INFO, "flush took %d iterations\n", 0xffff - retries);
+	bus_wake(bus);
 
-	if (rtx) {
-		bus->rxrtx++;
-		w_sdreg32(bus, SMB_NAK,
-			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
+	/* Make sure backplane clock is on */
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
+	if (bus->clkstate == CLK_PENDING)
+		goto clkwait;
 
+	/* Pending interrupt indicates new device status */
+	if (bus->ipend) {
+		bus->ipend = false;
+		r_sdreg32(bus, &newstatus,
+			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 		bus->f1regdata++;
-		if (retries <= retry_limit)
-			bus->rxskip = true;
+		if (brcmf_sdcard_regfail(bus->sdiodev))
+			newstatus = 0;
+		newstatus &= bus->hostintmask;
+		bus->fcstate = !!(newstatus & I_HMB_FC_STATE);
+		if (newstatus) {
+			w_sdreg32(bus, newstatus,
+				  offsetof(struct sdpcmd_regs, intstatus),
+				  &retries);
+			bus->f1regdata++;
+		}
 	}
 
-	/* Clear partial in any case */
-	bus->nextlen = 0;
-
-	/* If we can't reach the device, signal failure */
-	if (err || brcmf_sdcard_regfail(bus->sdiodev))
-		bus->drvr->busstate = BRCMF_BUS_DOWN;
-}
+	/* Merge new bits with previous */
+	intstatus |= newstatus;
+	bus->intstatus = 0;
 
-static void
-brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
-{
-	uint rdlen, pad;
+	/* Handle flow-control change: read new state in case our ack
+	 * crossed another change interrupt.  If change still set, assume
+	 * FC ON for safety, let next loop through do the debounce.
+	 */
+	if (intstatus & I_HMB_FC_CHANGE) {
+		intstatus &= ~I_HMB_FC_CHANGE;
+		w_sdreg32(bus, I_HMB_FC_CHANGE,
+			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 
-	int sdret;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	/* Set rxctl for frame (w/optional alignment) */
-	bus->rxctl = bus->rxbuf;
-	if (brcmf_alignctl) {
-		bus->rxctl += firstread;
-		pad = ((unsigned long)bus->rxctl % BRCMF_SDALIGN);
-		if (pad)
-			bus->rxctl += (BRCMF_SDALIGN - pad);
-		bus->rxctl -= firstread;
-	}
-
-	/* Copy the already-read portion over */
-	memcpy(bus->rxctl, hdr, firstread);
-	if (len <= firstread)
-		goto gotpkt;
-
-	/* Raise rdlen to next SDIO block to avoid tail command */
-	rdlen = len - firstread;
-	if (bus->roundup && bus->blocksize && (rdlen > bus->blocksize)) {
-		pad = bus->blocksize - (rdlen % bus->blocksize);
-		if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
-		    ((len + pad) < bus->drvr->maxctl))
-			rdlen += pad;
-	} else if (rdlen % BRCMF_SDALIGN) {
-		rdlen += BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
-	}
-
-	/* Satisfy length-alignment requirements */
-	if (forcealign && (rdlen & (ALIGNMENT - 1)))
-		rdlen = roundup(rdlen, ALIGNMENT);
-
-	/* Drop if the read is too big or it exceeds our maximum */
-	if ((rdlen + firstread) > bus->drvr->maxctl) {
-		brcmf_dbg(ERROR, "%d-byte control read exceeds %d-byte buffer\n",
-			  rdlen, bus->drvr->maxctl);
-		bus->drvr->rx_errors++;
-		brcmf_sdbrcm_rxfail(bus, false, false);
-		goto done;
-	}
-
-	if ((len - doff) > bus->drvr->maxctl) {
-		brcmf_dbg(ERROR, "%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
-			  len, len - doff, bus->drvr->maxctl);
-		bus->drvr->rx_errors++;
-		bus->rx_toolong++;
-		brcmf_sdbrcm_rxfail(bus, false, false);
-		goto done;
-	}
-
-	/* Read remainder of frame body into the rxctl buffer */
-	sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
-				bus->sdiodev->sbwad,
-				SDIO_FUNC_2,
-				F2SYNC, (bus->rxctl + firstread), rdlen,
-				NULL);
-	bus->f2rxdata++;
-
-	/* Control frame failures need retransmission */
-	if (sdret < 0) {
-		brcmf_dbg(ERROR, "read %d control bytes failed: %d\n",
-			  rdlen, sdret);
-		bus->rxc_errors++;
-		brcmf_sdbrcm_rxfail(bus, true, true);
-		goto done;
-	}
-
-gotpkt:
-
-#ifdef BCMDBG
-	if (BRCMF_BYTES_ON() && BRCMF_CTL_ON()) {
-		printk(KERN_DEBUG "RxCtrl:\n");
-		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, bus->rxctl, len);
-	}
-#endif
-
-	/* Point to valid data and indicate its length */
-	bus->rxctl += doff;
-	bus->rxlen = len - doff;
-
-done:
-	/* Awake any waiters */
-	brcmf_sdbrcm_ioctl_resp_wake(bus);
-}
-
-static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
-{
-	u16 dlen, totlen;
-	u8 *dptr, num = 0;
-
-	u16 sublen, check;
-	struct sk_buff *pfirst, *plast, *pnext, *save_pfirst;
-
-	int errcode;
-	u8 chan, seq, doff, sfdoff;
-	u8 txmax;
-
-	int ifidx = 0;
-	bool usechain = bus->use_rxchain;
-
-	/* If packets, issue read(s) and send up packet chain */
-	/* Return sequence numbers consumed? */
-
-	brcmf_dbg(TRACE, "start: glomd %p glom %p\n", bus->glomd, bus->glom);
-
-	/* If there's a descriptor, generate the packet chain */
-	if (bus->glomd) {
-		pfirst = plast = pnext = NULL;
-		dlen = (u16) (bus->glomd->len);
-		dptr = bus->glomd->data;
-		if (!dlen || (dlen & 1)) {
-			brcmf_dbg(ERROR, "bad glomd len(%d), ignore descriptor\n",
-				  dlen);
-			dlen = 0;
-		}
-
-		for (totlen = num = 0; dlen; num++) {
-			/* Get (and move past) next length */
-			sublen = get_unaligned_le16(dptr);
-			dlen -= sizeof(u16);
-			dptr += sizeof(u16);
-			if ((sublen < SDPCM_HDRLEN) ||
-			    ((num == 0) && (sublen < (2 * SDPCM_HDRLEN)))) {
-				brcmf_dbg(ERROR, "descriptor len %d bad: %d\n",
-					  num, sublen);
-				pnext = NULL;
-				break;
-			}
-			if (sublen % BRCMF_SDALIGN) {
-				brcmf_dbg(ERROR, "sublen %d not multiple of %d\n",
-					  sublen, BRCMF_SDALIGN);
-				usechain = false;
-			}
-			totlen += sublen;
-
-			/* For last frame, adjust read len so total
-				 is a block multiple */
-			if (!dlen) {
-				sublen +=
-				    (roundup(totlen, bus->blocksize) - totlen);
-				totlen = roundup(totlen, bus->blocksize);
-			}
-
-			/* Allocate/chain packet for next subframe */
-			pnext = brcmu_pkt_buf_get_skb(sublen + BRCMF_SDALIGN);
-			if (pnext == NULL) {
-				brcmf_dbg(ERROR, "bcm_pkt_buf_get_skb failed, num %d len %d\n",
-					  num, sublen);
-				break;
-			}
-			if (!pfirst) {
-				pfirst = plast = pnext;
-			} else {
-				plast->next = pnext;
-				plast = pnext;
-			}
-
-			/* Adhere to start alignment requirements */
-			pkt_align(pnext, sublen, BRCMF_SDALIGN);
-		}
-
-		/* If all allocations succeeded, save packet chain
-			 in bus structure */
-		if (pnext) {
-			brcmf_dbg(GLOM, "allocated %d-byte packet chain for %d subframes\n",
-				  totlen, num);
-			if (BRCMF_GLOM_ON() && bus->nextlen) {
-				if (totlen != bus->nextlen) {
-					brcmf_dbg(GLOM, "glomdesc mismatch: nextlen %d glomdesc %d rxseq %d\n",
-						  bus->nextlen, totlen, rxseq);
-				}
-			}
-			bus->glom = pfirst;
-			pfirst = pnext = NULL;
-		} else {
-			if (pfirst)
-				brcmu_pkt_buf_free_skb(pfirst);
-			bus->glom = NULL;
-			num = 0;
-		}
-
-		/* Done with descriptor packet */
-		brcmu_pkt_buf_free_skb(bus->glomd);
-		bus->glomd = NULL;
-		bus->nextlen = 0;
+		r_sdreg32(bus, &newstatus,
+			  offsetof(struct sdpcmd_regs, intstatus), &retries);
+		bus->f1regdata += 2;
+		bus->fcstate =
+		    !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE));
+		intstatus |= (newstatus & bus->hostintmask);
 	}
 
-	/* Ok -- either we just generated a packet chain,
-		 or had one from before */
-	if (bus->glom) {
-		if (BRCMF_GLOM_ON()) {
-			brcmf_dbg(GLOM, "try superframe read, packet chain:\n");
-			for (pnext = bus->glom; pnext; pnext = pnext->next) {
-				brcmf_dbg(GLOM, "    %p: %p len 0x%04x (%d)\n",
-					  pnext, (u8 *) (pnext->data),
-					  pnext->len, pnext->len);
-			}
-		}
-
-		pfirst = bus->glom;
-		dlen = (u16) brcmu_pkttotlen(pfirst);
-
-		/* Do an SDIO read for the superframe.  Configurable iovar to
-		 * read directly into the chained packet, or allocate a large
-		 * packet and and copy into the chain.
-		 */
-		if (usechain) {
-			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
-					bus->sdiodev->sbwad,
-					SDIO_FUNC_2,
-					F2SYNC, (u8 *) pfirst->data, dlen,
-					pfirst);
-		} else if (bus->dataptr) {
-			errcode = brcmf_sdcard_recv_buf(bus->sdiodev,
-					bus->sdiodev->sbwad,
-					SDIO_FUNC_2,
-					F2SYNC, bus->dataptr, dlen,
-					NULL);
-			sublen = (u16) brcmu_pktfrombuf(pfirst, 0, dlen,
-						bus->dataptr);
-			if (sublen != dlen) {
-				brcmf_dbg(ERROR, "FAILED TO COPY, dlen %d sublen %d\n",
-					  dlen, sublen);
-				errcode = -1;
-			}
-			pnext = NULL;
-		} else {
-			brcmf_dbg(ERROR, "COULDN'T ALLOC %d-BYTE GLOM, FORCE FAILURE\n",
-				  dlen);
-			errcode = -1;
-		}
-		bus->f2rxdata++;
-
-		/* On failure, kill the superframe, allow a couple retries */
-		if (errcode < 0) {
-			brcmf_dbg(ERROR, "glom read of %d bytes failed: %d\n",
-				  dlen, errcode);
-			bus->drvr->rx_errors++;
-
-			if (bus->glomerr++ < 3) {
-				brcmf_sdbrcm_rxfail(bus, true, true);
-			} else {
-				bus->glomerr = 0;
-				brcmf_sdbrcm_rxfail(bus, true, false);
-				brcmu_pkt_buf_free_skb(bus->glom);
-				bus->rxglomfail++;
-				bus->glom = NULL;
-			}
-			return 0;
-		}
-#ifdef BCMDBG
-		if (BRCMF_GLOM_ON()) {
-			printk(KERN_DEBUG "SUPERFRAME:\n");
-			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-				pfirst->data, min_t(int, pfirst->len, 48));
-		}
-#endif
-
-		/* Validate the superframe header */
-		dptr = (u8 *) (pfirst->data);
-		sublen = get_unaligned_le16(dptr);
-		check = get_unaligned_le16(dptr + sizeof(u16));
-
-		chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
-		seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
-		bus->nextlen = dptr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
-		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-			brcmf_dbg(INFO, "nextlen too large (%d) seq %d\n",
-				  bus->nextlen, seq);
-			bus->nextlen = 0;
-		}
-		doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
-		txmax = SDPCM_WINDOW_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
-
-		errcode = 0;
-		if ((u16)~(sublen ^ check)) {
-			brcmf_dbg(ERROR, "(superframe): HW hdr error: len/check 0x%04x/0x%04x\n",
-				  sublen, check);
-			errcode = -1;
-		} else if (roundup(sublen, bus->blocksize) != dlen) {
-			brcmf_dbg(ERROR, "(superframe): len 0x%04x, rounded 0x%04x, expect 0x%04x\n",
-				  sublen, roundup(sublen, bus->blocksize),
-				  dlen);
-			errcode = -1;
-		} else if (SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]) !=
-			   SDPCM_GLOM_CHANNEL) {
-			brcmf_dbg(ERROR, "(superframe): bad channel %d\n",
-				  SDPCM_PACKET_CHANNEL(
-					  &dptr[SDPCM_FRAMETAG_LEN]));
-			errcode = -1;
-		} else if (SDPCM_GLOMDESC(&dptr[SDPCM_FRAMETAG_LEN])) {
-			brcmf_dbg(ERROR, "(superframe): got 2nd descriptor?\n");
-			errcode = -1;
-		} else if ((doff < SDPCM_HDRLEN) ||
-			   (doff > (pfirst->len - SDPCM_HDRLEN))) {
-			brcmf_dbg(ERROR, "(superframe): Bad data offset %d: HW %d pkt %d min %d\n",
-				  doff, sublen, pfirst->len, SDPCM_HDRLEN);
-			errcode = -1;
-		}
-
-		/* Check sequence number of superframe SW header */
-		if (rxseq != seq) {
-			brcmf_dbg(INFO, "(superframe) rx_seq %d, expected %d\n",
-				  seq, rxseq);
-			bus->rx_badseq++;
-			rxseq = seq;
-		}
-
-		/* Check window for sanity */
-		if ((u8) (txmax - bus->tx_seq) > 0x40) {
-			brcmf_dbg(ERROR, "unlikely tx max %d with tx_seq %d\n",
-				  txmax, bus->tx_seq);
-			txmax = bus->tx_seq + 2;
-		}
-		bus->tx_max = txmax;
-
-		/* Remove superframe header, remember offset */
-		skb_pull(pfirst, doff);
-		sfdoff = doff;
-
-		/* Validate all the subframe headers */
-		for (num = 0, pnext = pfirst; pnext && !errcode;
-		     num++, pnext = pnext->next) {
-			dptr = (u8 *) (pnext->data);
-			dlen = (u16) (pnext->len);
-			sublen = get_unaligned_le16(dptr);
-			check = get_unaligned_le16(dptr + sizeof(u16));
-			chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
-			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
-#ifdef BCMDBG
-			if (BRCMF_GLOM_ON()) {
-				printk(KERN_DEBUG "subframe:\n");
-				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-						     dptr, 32);
-			}
-#endif
-
-			if ((u16)~(sublen ^ check)) {
-				brcmf_dbg(ERROR, "(subframe %d): HW hdr error: len/check 0x%04x/0x%04x\n",
-					  num, sublen, check);
-				errcode = -1;
-			} else if ((sublen > dlen) || (sublen < SDPCM_HDRLEN)) {
-				brcmf_dbg(ERROR, "(subframe %d): length mismatch: len 0x%04x, expect 0x%04x\n",
-					  num, sublen, dlen);
-				errcode = -1;
-			} else if ((chan != SDPCM_DATA_CHANNEL) &&
-				   (chan != SDPCM_EVENT_CHANNEL)) {
-				brcmf_dbg(ERROR, "(subframe %d): bad channel %d\n",
-					  num, chan);
-				errcode = -1;
-			} else if ((doff < SDPCM_HDRLEN) || (doff > sublen)) {
-				brcmf_dbg(ERROR, "(subframe %d): Bad data offset %d: HW %d min %d\n",
-					  num, doff, sublen, SDPCM_HDRLEN);
-				errcode = -1;
-			}
-		}
-
-		if (errcode) {
-			/* Terminate frame on error, request
-				 a couple retries */
-			if (bus->glomerr++ < 3) {
-				/* Restore superframe header space */
-				skb_push(pfirst, sfdoff);
-				brcmf_sdbrcm_rxfail(bus, true, true);
-			} else {
-				bus->glomerr = 0;
-				brcmf_sdbrcm_rxfail(bus, true, false);
-				brcmu_pkt_buf_free_skb(bus->glom);
-				bus->rxglomfail++;
-				bus->glom = NULL;
-			}
-			bus->nextlen = 0;
-			return 0;
-		}
-
-		/* Basic SD framing looks ok - process each packet (header) */
-		save_pfirst = pfirst;
-		bus->glom = NULL;
-		plast = NULL;
-
-		for (num = 0; pfirst; rxseq++, pfirst = pnext) {
-			pnext = pfirst->next;
-			pfirst->next = NULL;
-
-			dptr = (u8 *) (pfirst->data);
-			sublen = get_unaligned_le16(dptr);
-			chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
-			seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
-			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
-
-			brcmf_dbg(GLOM, "Get subframe %d, %p(%p/%d), sublen %d chan %d seq %d\n",
-				  num, pfirst, pfirst->data,
-				  pfirst->len, sublen, chan, seq);
-
-			/* precondition: chan == SDPCM_DATA_CHANNEL ||
-					 chan == SDPCM_EVENT_CHANNEL */
-
-			if (rxseq != seq) {
-				brcmf_dbg(GLOM, "rx_seq %d, expected %d\n",
-					  seq, rxseq);
-				bus->rx_badseq++;
-				rxseq = seq;
-			}
-#ifdef BCMDBG
-			if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
-				printk(KERN_DEBUG "Rx Subframe Data:\n");
-				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-						     dptr, dlen);
-			}
-#endif
-
-			__skb_trim(pfirst, sublen);
-			skb_pull(pfirst, doff);
-
-			if (pfirst->len == 0) {
-				brcmu_pkt_buf_free_skb(pfirst);
-				if (plast)
-					plast->next = pnext;
-				else
-					save_pfirst = pnext;
-
-				continue;
-			} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx,
-						       pfirst) != 0) {
-				brcmf_dbg(ERROR, "rx protocol error\n");
-				bus->drvr->rx_errors++;
-				brcmu_pkt_buf_free_skb(pfirst);
-				if (plast)
-					plast->next = pnext;
-				else
-					save_pfirst = pnext;
-
-				continue;
-			}
-
-			/* this packet will go up, link back into
-				 chain and count it */
-			pfirst->next = pnext;
-			plast = pfirst;
-			num++;
-
-#ifdef BCMDBG
-			if (BRCMF_GLOM_ON()) {
-				brcmf_dbg(GLOM, "subframe %d to stack, %p (%p/%d) nxt/lnk %p/%p\n",
-					  num, pfirst, pfirst->data,
-					  pfirst->len, pfirst->next,
-					  pfirst->prev);
-				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-						pfirst->data,
-						min_t(int, pfirst->len, 32));
-			}
-#endif				/* BCMDBG */
-		}
-		if (num) {
-			brcmf_sdbrcm_sdunlock(bus);
-			brcmf_rx_frame(bus->drvr, ifidx, save_pfirst, num);
-			brcmf_sdbrcm_sdlock(bus);
-		}
+	/* Handle host mailbox indication */
+	if (intstatus & I_HMB_HOST_INT) {
+		intstatus &= ~I_HMB_HOST_INT;
+		intstatus |= brcmf_sdbrcm_hostmail(bus);
+	}
 
-		bus->rxglomframes++;
-		bus->rxglompkts += num;
+	/* Generally don't ask for these, can get CRC errors... */
+	if (intstatus & I_WR_OOSYNC) {
+		brcmf_dbg(ERROR, "Dongle reports WR_OOSYNC\n");
+		intstatus &= ~I_WR_OOSYNC;
 	}
-	return num;
-}
 
-/* Return true if there may be more frames to read */
-static uint
-brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
-{
-	u16 len, check;	/* Extracted hardware header fields */
-	u8 chan, seq, doff;	/* Extracted software header fields */
-	u8 fcbits;		/* Extracted fcbits from software header */
+	if (intstatus & I_RD_OOSYNC) {
+		brcmf_dbg(ERROR, "Dongle reports RD_OOSYNC\n");
+		intstatus &= ~I_RD_OOSYNC;
+	}
 
-	struct sk_buff *pkt;		/* Packet for event or data frames */
-	u16 pad;		/* Number of pad bytes to read */
-	u16 rdlen;		/* Total number of bytes to read */
-	u8 rxseq;		/* Next sequence number to expect */
-	uint rxleft = 0;	/* Remaining number of frames allowed */
-	int sdret;		/* Return code from calls */
-	u8 txmax;		/* Maximum tx sequence offered */
-	bool len_consistent;	/* Result of comparing readahead len and
-					 len from hw-hdr */
-	u8 *rxbuf;
-	int ifidx = 0;
-	uint rxcount = 0;	/* Total frames read */
+	if (intstatus & I_SBINT) {
+		brcmf_dbg(ERROR, "Dongle reports SBINT\n");
+		intstatus &= ~I_SBINT;
+	}
 
-	brcmf_dbg(TRACE, "Enter\n");
+	/* Would be active due to wake-wlan in gSPI */
+	if (intstatus & I_CHIPACTIVE) {
+		brcmf_dbg(INFO, "Dongle reports CHIPACTIVE\n");
+		intstatus &= ~I_CHIPACTIVE;
+	}
 
-	/* Not finished unless we encounter no more frames indication */
-	*finished = false;
+	/* Ignore frame indications if rxskip is set */
+	if (bus->rxskip)
+		intstatus &= ~I_HMB_FRAME_IND;
 
-	for (rxseq = bus->rx_seq, rxleft = maxframes;
-	     !bus->rxskip && rxleft && bus->drvr->busstate != BRCMF_BUS_DOWN;
-	     rxseq++, rxleft--) {
+	/* On frame indication, read available frames */
+	if (PKT_AVAILABLE()) {
+		framecnt = brcmf_sdbrcm_readframes(bus, rxlimit, &rxdone);
+		if (rxdone || bus->rxskip)
+			intstatus &= ~I_HMB_FRAME_IND;
+		rxlimit -= min(framecnt, rxlimit);
+	}
 
-		/* Handle glomming separately */
-		if (bus->glom || bus->glomd) {
-			u8 cnt;
-			brcmf_dbg(GLOM, "calling rxglom: glomd %p, glom %p\n",
-				  bus->glomd, bus->glom);
-			cnt = brcmf_sdbrcm_rxglom(bus, rxseq);
-			brcmf_dbg(GLOM, "rxglom returned %d\n", cnt);
-			rxseq += cnt - 1;
-			rxleft = (rxleft > cnt) ? (rxleft - cnt) : 1;
-			continue;
-		}
+	/* Keep still-pending events for next scheduling */
+	bus->intstatus = intstatus;
 
-		/* Try doing single read if we can */
-		if (brcmf_readahead && bus->nextlen) {
-			u16 nextlen = bus->nextlen;
-			bus->nextlen = 0;
+clkwait:
+	if (data_ok(bus) && bus->ctrl_frame_stat &&
+		(bus->clkstate == CLK_AVAIL)) {
+		int ret, i;
 
-			rdlen = len = nextlen << 4;
+		ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
+			SDIO_FUNC_2, F2SYNC, (u8 *) bus->ctrl_frame_buf,
+			(u32) bus->ctrl_frame_len, NULL);
 
-			/* Pad read to blocksize for efficiency */
-			if (bus->roundup && bus->blocksize
-			    && (rdlen > bus->blocksize)) {
-				pad =
-				    bus->blocksize -
-				    (rdlen % bus->blocksize);
-				if ((pad <= bus->roundup)
-				    && (pad < bus->blocksize)
-				    && ((rdlen + pad + firstread) <
-					MAX_RX_DATASZ))
-					rdlen += pad;
-			} else if (rdlen % BRCMF_SDALIGN) {
-				rdlen += BRCMF_SDALIGN -
-					 (rdlen % BRCMF_SDALIGN);
-			}
+		if (ret < 0) {
+			/* On failure, abort the command and
+				terminate the frame */
+			brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
+				  ret);
+			bus->tx_sderrs++;
 
-			/* We use bus->rxctl buffer in WinXP for initial
-			 * control pkt receives.
-			 * Later we use buffer-poll for data as well
-			 * as control packets.
-			 * This is required because dhd receives full
-			 * frame in gSPI unlike SDIO.
-			 * After the frame is received we have to
-			 * distinguish whether it is data
-			 * or non-data frame.
-			 */
-			/* Allocate a packet buffer */
-			pkt = brcmu_pkt_buf_get_skb(rdlen + BRCMF_SDALIGN);
-			if (!pkt) {
-				/* Give up on data, request rtx of events */
-				brcmf_dbg(ERROR, "(nextlen): brcmu_pkt_buf_get_skb failed: len %d rdlen %d expected rxseq %d\n",
-					  len, rdlen, rxseq);
-				continue;
-			} else {
-				pkt_align(pkt, rdlen, BRCMF_SDALIGN);
-				rxbuf = (u8 *) (pkt->data);
-				/* Read the entire frame */
-				sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
-						bus->sdiodev->sbwad,
-						SDIO_FUNC_2, F2SYNC,
-						rxbuf, rdlen,
-						pkt);
-				bus->f2rxdata++;
+			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 
-				if (sdret < 0) {
-					brcmf_dbg(ERROR, "(nextlen): read %d bytes failed: %d\n",
-						  rdlen, sdret);
-					brcmu_pkt_buf_free_skb(pkt);
-					bus->drvr->rx_errors++;
-					/* Force retry w/normal header read.
-					 * Don't attempt NAK for
-					 * gSPI
-					 */
-					brcmf_sdbrcm_rxfail(bus, true, true);
-					continue;
-				}
+			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
+					 NULL);
+			bus->f1regdata++;
+
+			for (i = 0; i < 3; i++) {
+				u8 hi, lo;
+				hi = brcmf_sdcard_cfg_read(bus->sdiodev,
+						     SDIO_FUNC_1,
+						     SBSDIO_FUNC1_WFRAMEBCHI,
+						     NULL);
+				lo = brcmf_sdcard_cfg_read(bus->sdiodev,
+						     SDIO_FUNC_1,
+						     SBSDIO_FUNC1_WFRAMEBCLO,
+						     NULL);
+				bus->f1regdata += 2;
+				if ((hi == 0) && (lo == 0))
+					break;
 			}
 
-			/* Now check the header */
-			memcpy(bus->rxhdr, rxbuf, SDPCM_HDRLEN);
+		}
+		if (ret == 0)
+			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
-			/* Extract hardware header fields */
-			len = get_unaligned_le16(bus->rxhdr);
-			check = get_unaligned_le16(bus->rxhdr + sizeof(u16));
+		brcmf_dbg(INFO, "Return_dpc value is : %d\n", ret);
+		bus->ctrl_frame_stat = false;
+		brcmf_sdbrcm_wait_event_wakeup(bus);
+	}
+	/* Send queued frames (limit 1 if rx may still be pending) */
+	else if ((bus->clkstate == CLK_AVAIL) && !bus->fcstate &&
+		 brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
+		 && data_ok(bus)) {
+		framecnt = rxdone ? txlimit : min(txlimit, brcmf_txminmax);
+		framecnt = brcmf_sdbrcm_sendfromq(bus, framecnt);
+		txlimit -= framecnt;
+	}
 
-			/* All zeros means readahead info was bad */
-			if (!(len | check)) {
-				brcmf_dbg(INFO, "(nextlen): read zeros in HW header???\n");
-				brcmf_sdbrcm_pktfree2(bus, pkt);
-				continue;
-			}
+	/* Resched if events or tx frames are pending,
+		 else await next interrupt */
+	/* On failed register access, all bets are off:
+		 no resched or interrupts */
+	if ((bus->drvr->busstate == BRCMF_BUS_DOWN) ||
+	    brcmf_sdcard_regfail(bus->sdiodev)) {
+		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting operation %d\n",
+			  brcmf_sdcard_regfail(bus->sdiodev));
+		bus->drvr->busstate = BRCMF_BUS_DOWN;
+		bus->intstatus = 0;
+	} else if (bus->clkstate == CLK_PENDING) {
+		brcmf_dbg(INFO, "rescheduled due to CLK_PENDING awaiting I_CHIPACTIVE interrupt\n");
+		resched = true;
+	} else if (bus->intstatus || bus->ipend ||
+		(!bus->fcstate && brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol)
+		 && data_ok(bus)) || PKT_AVAILABLE()) {
+		resched = true;
+	}
 
-			/* Validate check bytes */
-			if ((u16)~(len ^ check)) {
-				brcmf_dbg(ERROR, "(nextlen): HW hdr error: nextlen/len/check 0x%04x/0x%04x/0x%04x\n",
-					  nextlen, len, check);
-				bus->rx_badhdr++;
-				brcmf_sdbrcm_rxfail(bus, false, false);
-				brcmf_sdbrcm_pktfree2(bus, pkt);
-				continue;
-			}
+	bus->dpc_sched = resched;
 
-			/* Validate frame length */
-			if (len < SDPCM_HDRLEN) {
-				brcmf_dbg(ERROR, "(nextlen): HW hdr length invalid: %d\n",
-					  len);
-				brcmf_sdbrcm_pktfree2(bus, pkt);
-				continue;
-			}
+	/* If we're done for now, turn off clock request. */
+	if ((bus->clkstate != CLK_PENDING)
+	    && bus->idletime == BRCMF_IDLE_IMMEDIATE) {
+		bus->activity = false;
+		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+	}
 
-			/* Check for consistency withreadahead info */
-			len_consistent = (nextlen != (roundup(len, 16) >> 4));
-			if (len_consistent) {
-				/* Mismatch, force retry w/normal
-					header (may be >4K) */
-				brcmf_dbg(ERROR, "(nextlen): mismatch, nextlen %d len %d rnd %d; expected rxseq %d\n",
-					  nextlen, len, roundup(len, 16),
-					  rxseq);
-				brcmf_sdbrcm_rxfail(bus, true, true);
-				brcmf_sdbrcm_pktfree2(bus, pkt);
-				continue;
-			}
+	brcmf_sdbrcm_sdunlock(bus);
 
-			/* Extract software header fields */
-			chan = SDPCM_PACKET_CHANNEL(
-					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-			seq = SDPCM_PACKET_SEQUENCE(
-					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-			doff = SDPCM_DOFFSET_VALUE(
-					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-			txmax = SDPCM_WINDOW_VALUE(
-					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
+	return resched;
+}
+
+static int brcmf_sdbrcm_dpc_thread(void *data)
+{
+	struct brcmf_bus *bus = (struct brcmf_bus *) data;
 
-			bus->nextlen =
-			    bus->rxhdr[SDPCM_FRAMETAG_LEN +
-				       SDPCM_NEXTLEN_OFFSET];
-			if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-				brcmf_dbg(INFO, "(nextlen): got frame w/nextlen too large (%d), seq %d\n",
-					  bus->nextlen, seq);
-				bus->nextlen = 0;
+	/* This thread doesn't need any user-level access,
+	 * so get rid of all our resources
+	 */
+	if (brcmf_dpc_prio > 0) {
+		struct sched_param param;
+		param.sched_priority = (brcmf_dpc_prio < MAX_RT_PRIO) ?
+				       brcmf_dpc_prio : (MAX_RT_PRIO - 1);
+		sched_setscheduler(current, SCHED_FIFO, &param);
+	}
+
+	allow_signal(SIGTERM);
+	/* Run until signal received */
+	while (1) {
+		if (kthread_should_stop())
+			break;
+		if (!wait_for_completion_interruptible(&bus->dpc_wait)) {
+			/* Call bus dpc unless it indicated down
+			(then clean stop) */
+			if (bus->drvr->busstate != BRCMF_BUS_DOWN) {
+				if (brcmf_sdbrcm_dpc(bus))
+					complete(&bus->dpc_wait);
+			} else {
+				brcmf_sdbrcm_bus_stop(bus, true);
 			}
+		} else
+			break;
+	}
+	return 0;
+}
 
-			bus->drvr->rx_readahead_cnt++;
+static void brcmf_sdbrcm_dpc_tasklet(unsigned long data)
+{
+	struct brcmf_bus *bus = (struct brcmf_bus *) data;
 
-			/* Handle Flow Control */
-			fcbits = SDPCM_FCMASK_VALUE(
-					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
+	/* Call bus dpc unless it indicated down (then clean stop) */
+	if (bus->drvr->busstate != BRCMF_BUS_DOWN) {
+		if (brcmf_sdbrcm_dpc(bus))
+			tasklet_schedule(&bus->tasklet);
+	} else
+		brcmf_sdbrcm_bus_stop(bus, true);
+}
 
-			if (bus->flowcontrol != fcbits) {
-				if (~bus->flowcontrol & fcbits)
-					bus->fc_xoff++;
+static void brcmf_sdbrcm_sched_dpc(struct brcmf_bus *bus)
+{
+	if (bus->dpc_tsk) {
+		complete(&bus->dpc_wait);
+		return;
+	}
 
-				if (bus->flowcontrol & ~fcbits)
-					bus->fc_xon++;
+	tasklet_schedule(&bus->tasklet);
+}
 
-				bus->fc_rcvd++;
-				bus->flowcontrol = fcbits;
-			}
+int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
+{
+	int ret = -EBADE;
+	uint datalen, prec;
 
-			/* Check and update sequence number */
-			if (rxseq != seq) {
-				brcmf_dbg(INFO, "(nextlen): rx_seq %d, expected %d\n",
-					  seq, rxseq);
-				bus->rx_badseq++;
-				rxseq = seq;
-			}
+	brcmf_dbg(TRACE, "Enter\n");
 
-			/* Check window for sanity */
-			if ((u8) (txmax - bus->tx_seq) > 0x40) {
-				brcmf_dbg(ERROR, "got unlikely tx max %d with tx_seq %d\n",
-					  txmax, bus->tx_seq);
-				txmax = bus->tx_seq + 2;
-			}
-			bus->tx_max = txmax;
+	datalen = pkt->len;
 
-#ifdef BCMDBG
-			if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
-				printk(KERN_DEBUG "Rx Data:\n");
-				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-						     rxbuf, len);
-			} else if (BRCMF_HDRS_ON()) {
-				printk(KERN_DEBUG "RxHdr:\n");
-				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-						     bus->rxhdr, SDPCM_HDRLEN);
-			}
-#endif
+	/* Add space for the header */
+	skb_push(pkt, SDPCM_HDRLEN);
+	/* precondition: IS_ALIGNED((unsigned long)(pkt->data), 2) */
 
-			if (chan == SDPCM_CONTROL_CHANNEL) {
-				brcmf_dbg(ERROR, "(nextlen): readahead on control packet %d?\n",
-					  seq);
-				/* Force retry w/normal header read */
-				bus->nextlen = 0;
-				brcmf_sdbrcm_rxfail(bus, false, true);
-				brcmf_sdbrcm_pktfree2(bus, pkt);
-				continue;
-			}
+	prec = prio2prec((pkt->priority & PRIOMASK));
 
-			/* Validate data offset */
-			if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-				brcmf_dbg(ERROR, "(nextlen): bad data offset %d: HW len %d min %d\n",
-					  doff, len, SDPCM_HDRLEN);
-				brcmf_sdbrcm_rxfail(bus, false, false);
-				brcmf_sdbrcm_pktfree2(bus, pkt);
-				continue;
-			}
+	/* Check for existing queue, current flow-control,
+			 pending event, or pending clock */
+	if (brcmf_deferred_tx || bus->fcstate || pktq_len(&bus->txq)
+	    || bus->dpc_sched || (!data_ok(bus))
+	    || (bus->flowcontrol & NBITVAL(prec))
+	    || (bus->clkstate != CLK_AVAIL)) {
+		brcmf_dbg(TRACE, "deferring pktq len %d\n",
+			  pktq_len(&bus->txq));
+		bus->fcqueued++;
 
-			/* All done with this one -- now deliver the packet */
-			goto deliver;
+		/* Priority based enq */
+		spin_lock_bh(&bus->txqlock);
+		if (brcmf_c_prec_enq(bus->drvr, &bus->txq, pkt, prec) ==
+		    false) {
+			skb_pull(pkt, SDPCM_HDRLEN);
+			brcmf_txcomplete(bus->drvr, pkt, false);
+			brcmu_pkt_buf_free_skb(pkt);
+			brcmf_dbg(ERROR, "out of bus->txq !!!\n");
+			ret = -ENOSR;
+		} else {
+			ret = 0;
 		}
+		spin_unlock_bh(&bus->txqlock);
 
-		/* Read frame header (hardware and software) */
-		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
-				SDIO_FUNC_2, F2SYNC, bus->rxhdr, firstread,
-				NULL);
-		bus->f2rxhdrs++;
+		if (pktq_len(&bus->txq) >= TXHI)
+			brcmf_txflowcontrol(bus->drvr, 0, ON);
 
-		if (sdret < 0) {
-			brcmf_dbg(ERROR, "RXHEADER FAILED: %d\n", sdret);
-			bus->rx_hdrfail++;
-			brcmf_sdbrcm_rxfail(bus, true, true);
-			continue;
-		}
 #ifdef BCMDBG
-		if (BRCMF_BYTES_ON() || BRCMF_HDRS_ON()) {
-			printk(KERN_DEBUG "RxHdr:\n");
-			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-					     bus->rxhdr, SDPCM_HDRLEN);
-		}
+		if (pktq_plen(&bus->txq, prec) > qcount[prec])
+			qcount[prec] = pktq_plen(&bus->txq, prec);
 #endif
+		/* Schedule DPC if needed to send queued packet(s) */
+		if (brcmf_deferred_tx && !bus->dpc_sched) {
+			bus->dpc_sched = true;
+			brcmf_sdbrcm_sched_dpc(bus);
+		}
+	} else {
+		/* Lock: we're about to use shared data/code (and SDIO) */
+		brcmf_sdbrcm_sdlock(bus);
 
-		/* Extract hardware header fields */
-		len = get_unaligned_le16(bus->rxhdr);
-		check = get_unaligned_le16(bus->rxhdr + sizeof(u16));
+		/* Otherwise, send it now */
+		bus_wake(bus);
+		/* Make sure back plane ht clk is on, no pending allowed */
+		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
 
-		/* All zeros means no more frames */
-		if (!(len | check)) {
-			*finished = true;
-			break;
-		}
+		brcmf_dbg(TRACE, "calling txpkt\n");
+		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
+		if (ret)
+			bus->drvr->tx_errors++;
+		else
+			bus->drvr->dstats.tx_bytes += datalen;
 
-		/* Validate check bytes */
-		if ((u16) ~(len ^ check)) {
-			brcmf_dbg(ERROR, "HW hdr err: len/check 0x%04x/0x%04x\n",
-				  len, check);
-			bus->rx_badhdr++;
-			brcmf_sdbrcm_rxfail(bus, false, false);
-			continue;
+		if (bus->idletime == BRCMF_IDLE_IMMEDIATE &&
+		    !bus->dpc_sched) {
+			bus->activity = false;
+			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 		}
 
-		/* Validate frame length */
-		if (len < SDPCM_HDRLEN) {
-			brcmf_dbg(ERROR, "HW hdr length invalid: %d\n", len);
-			continue;
-		}
+		brcmf_sdbrcm_sdunlock(bus);
+	}
 
-		/* Extract software header fields */
-		chan = SDPCM_PACKET_CHANNEL(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-		seq = SDPCM_PACKET_SEQUENCE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-		doff = SDPCM_DOFFSET_VALUE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-		txmax = SDPCM_WINDOW_VALUE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
+	return ret;
+}
 
-		/* Validate data offset */
-		if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-			brcmf_dbg(ERROR, "Bad data offset %d: HW len %d, min %d seq %d\n",
-				  doff, len, SDPCM_HDRLEN, seq);
-			bus->rx_badhdr++;
-			brcmf_sdbrcm_rxfail(bus, false, false);
-			continue;
-		}
+static int
+brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
+		 uint size)
+{
+	int bcmerror = 0;
+	u32 sdaddr;
+	uint dsize;
 
-		/* Save the readahead length if there is one */
-		bus->nextlen =
-		    bus->rxhdr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
-		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-			brcmf_dbg(INFO, "(nextlen): got frame w/nextlen too large (%d), seq %d\n",
-				  bus->nextlen, seq);
-			bus->nextlen = 0;
+	/* Determine initial transfer parameters */
+	sdaddr = address & SBSDIO_SB_OFT_ADDR_MASK;
+	if ((sdaddr + size) & SBSDIO_SBWINDOW_MASK)
+		dsize = (SBSDIO_SB_OFT_ADDR_LIMIT - sdaddr);
+	else
+		dsize = size;
+
+	/* Set the backplane window to include the start address */
+	bcmerror = brcmf_sdcard_set_sbaddr_window(bus->sdiodev, address);
+	if (bcmerror) {
+		brcmf_dbg(ERROR, "window change failed\n");
+		goto xfer_done;
+	}
+
+	/* Do the transfer(s) */
+	while (size) {
+		brcmf_dbg(INFO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
+			  write ? "write" : "read", dsize,
+			  sdaddr, address & SBSDIO_SBWINDOW_MASK);
+		bcmerror = brcmf_sdcard_rwdata(bus->sdiodev, write,
+					       sdaddr, data, dsize);
+		if (bcmerror) {
+			brcmf_dbg(ERROR, "membytes transfer failed\n");
+			break;
 		}
 
-		/* Handle Flow Control */
-		fcbits = SDPCM_FCMASK_VALUE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-
-		if (bus->flowcontrol != fcbits) {
-			if (~bus->flowcontrol & fcbits)
-				bus->fc_xoff++;
+		/* Adjust for next transfer (if any) */
+		size -= dsize;
+		if (size) {
+			data += dsize;
+			address += dsize;
+			bcmerror = brcmf_sdcard_set_sbaddr_window(bus->sdiodev,
+								  address);
+			if (bcmerror) {
+				brcmf_dbg(ERROR, "window change failed\n");
+				break;
+			}
+			sdaddr = 0;
+			dsize = min_t(uint, SBSDIO_SB_OFT_ADDR_LIMIT, size);
+		}
+	}
 
-			if (bus->flowcontrol & ~fcbits)
-				bus->fc_xon++;
+xfer_done:
+	/* Return the window to backplane enumeration space for core access */
+	if (brcmf_sdcard_set_sbaddr_window(bus->sdiodev, bus->sdiodev->sbwad))
+		brcmf_dbg(ERROR, "FAILED to set window back to 0x%x\n",
+			  bus->sdiodev->sbwad);
 
-			bus->fc_rcvd++;
-			bus->flowcontrol = fcbits;
-		}
+	return bcmerror;
+}
 
-		/* Check and update sequence number */
-		if (rxseq != seq) {
-			brcmf_dbg(INFO, "rx_seq %d, expected %d\n", seq, rxseq);
-			bus->rx_badseq++;
-			rxseq = seq;
-		}
+#ifdef BCMDBG
+static int
+brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
+{
+	u32 addr;
+	int rv;
 
-		/* Check window for sanity */
-		if ((u8) (txmax - bus->tx_seq) > 0x40) {
-			brcmf_dbg(ERROR, "unlikely tx max %d with tx_seq %d\n",
-				  txmax, bus->tx_seq);
-			txmax = bus->tx_seq + 2;
-		}
-		bus->tx_max = txmax;
+	/* Read last word in memory to determine address of
+			 sdpcm_shared structure */
+	rv = brcmf_sdbrcm_membytes(bus, false, bus->ramsize - 4, (u8 *)&addr,
+				   4);
+	if (rv < 0)
+		return rv;
 
-		/* Call a separate function for control frames */
-		if (chan == SDPCM_CONTROL_CHANNEL) {
-			brcmf_sdbrcm_read_control(bus, bus->rxhdr, len, doff);
-			continue;
-		}
+	addr = le32_to_cpu(addr);
 
-		/* precondition: chan is either SDPCM_DATA_CHANNEL,
-		   SDPCM_EVENT_CHANNEL, SDPCM_TEST_CHANNEL or
-		   SDPCM_GLOM_CHANNEL */
+	brcmf_dbg(INFO, "sdpcm_shared address 0x%08X\n", addr);
 
-		/* Length to read */
-		rdlen = (len > firstread) ? (len - firstread) : 0;
+	/*
+	 * Check if addr is valid.
+	 * NVRAM length at the end of memory should have been overwritten.
+	 */
+	if (addr == 0 || ((~addr >> 16) & 0xffff) == (addr & 0xffff)) {
+		brcmf_dbg(ERROR, "address (0x%08x) of sdpcm_shared invalid\n",
+			  addr);
+		return -EBADE;
+	}
 
-		/* May pad read to blocksize for efficiency */
-		if (bus->roundup && bus->blocksize &&
-			(rdlen > bus->blocksize)) {
-			pad = bus->blocksize - (rdlen % bus->blocksize);
-			if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
-			    ((rdlen + pad + firstread) < MAX_RX_DATASZ))
-				rdlen += pad;
-		} else if (rdlen % BRCMF_SDALIGN) {
-			rdlen += BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
-		}
+	/* Read rte_shared structure */
+	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *) sh,
+			      sizeof(struct sdpcm_shared));
+	if (rv < 0)
+		return rv;
 
-		/* Satisfy length-alignment requirements */
-		if (forcealign && (rdlen & (ALIGNMENT - 1)))
-			rdlen = roundup(rdlen, ALIGNMENT);
+	/* Endianness */
+	sh->flags = le32_to_cpu(sh->flags);
+	sh->trap_addr = le32_to_cpu(sh->trap_addr);
+	sh->assert_exp_addr = le32_to_cpu(sh->assert_exp_addr);
+	sh->assert_file_addr = le32_to_cpu(sh->assert_file_addr);
+	sh->assert_line = le32_to_cpu(sh->assert_line);
+	sh->console_addr = le32_to_cpu(sh->console_addr);
+	sh->msgtrace_addr = le32_to_cpu(sh->msgtrace_addr);
 
-		if ((rdlen + firstread) > MAX_RX_DATASZ) {
-			/* Too long -- skip this frame */
-			brcmf_dbg(ERROR, "too long: len %d rdlen %d\n",
-				  len, rdlen);
-			bus->drvr->rx_errors++;
-			bus->rx_toolong++;
-			brcmf_sdbrcm_rxfail(bus, false, false);
-			continue;
-		}
+	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
+		brcmf_dbg(ERROR, "sdpcm_shared version %d in brcmf is different than sdpcm_shared version %d in dongle\n",
+			  SDPCM_SHARED_VERSION,
+			  sh->flags & SDPCM_SHARED_VERSION_MASK);
+		return -EBADE;
+	}
 
-		pkt = brcmu_pkt_buf_get_skb(rdlen + firstread + BRCMF_SDALIGN);
-		if (!pkt) {
-			/* Give up on data, request rtx of events */
-			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: rdlen %d chan %d\n",
-				  rdlen, chan);
-			bus->drvr->rx_dropped++;
-			brcmf_sdbrcm_rxfail(bus, false, RETRYCHAN(chan));
-			continue;
-		}
+	return 0;
+}
 
-		/* Leave room for what we already read, and align remainder */
-		skb_pull(pkt, firstread);
-		pkt_align(pkt, rdlen, BRCMF_SDALIGN);
+static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
+{
+	int ret = 0;
+	int size;		/* Full mem size */
+	int start = 0;		/* Start address */
+	int read_size = 0;	/* Read size of each iteration */
+	u8 *buf = NULL, *databuf = NULL;
 
-		/* Read the remaining frame data */
-		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
-				SDIO_FUNC_2, F2SYNC, ((u8 *) (pkt->data)),
-				rdlen, pkt);
-		bus->f2rxdata++;
+	/* Get full mem size */
+	size = bus->ramsize;
+	buf = kmalloc(size, GFP_ATOMIC);
+	if (!buf) {
+		brcmf_dbg(ERROR, "Out of memory (%d bytes)\n", size);
+		return -1;
+	}
 
-		if (sdret < 0) {
-			brcmf_dbg(ERROR, "read %d %s bytes failed: %d\n", rdlen,
-				  ((chan == SDPCM_EVENT_CHANNEL) ? "event"
-				   : ((chan == SDPCM_DATA_CHANNEL) ? "data"
-				      : "test")), sdret);
-			brcmu_pkt_buf_free_skb(pkt);
-			bus->drvr->rx_errors++;
-			brcmf_sdbrcm_rxfail(bus, true, RETRYCHAN(chan));
-			continue;
+	/* Read mem content */
+	printk(KERN_DEBUG "Dump dongle memory");
+	databuf = buf;
+	while (size) {
+		read_size = min(MEMBLOCK, size);
+		ret = brcmf_sdbrcm_membytes(bus, false, start, databuf,
+					  read_size);
+		if (ret) {
+			brcmf_dbg(ERROR, "Error membytes %d\n", ret);
+			kfree(buf);
+			return -1;
 		}
+		printk(".");
 
-		/* Copy the already-read portion */
-		skb_push(pkt, firstread);
-		memcpy(pkt->data, bus->rxhdr, firstread);
+		/* Decrement size and increment start address */
+		size -= read_size;
+		start += read_size;
+		databuf += read_size;
+	}
+	printk(KERN_DEBUG "Done\n");
 
-#ifdef BCMDBG
-		if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
-			printk(KERN_DEBUG "Rx Data:\n");
-			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-					     pkt->data, len);
-		}
-#endif
+	/* free buf before return !!! */
+	if (brcmf_write_to_file(bus->drvr, buf, bus->ramsize)) {
+		brcmf_dbg(ERROR, "Error writing to files\n");
+		return -1;
+	}
 
-deliver:
-		/* Save superframe descriptor and allocate packet frame */
-		if (chan == SDPCM_GLOM_CHANNEL) {
-			if (SDPCM_GLOMDESC(&bus->rxhdr[SDPCM_FRAMETAG_LEN])) {
-				brcmf_dbg(GLOM, "glom descriptor, %d bytes:\n",
-					  len);
-#ifdef BCMDBG
-				if (BRCMF_GLOM_ON()) {
-					printk(KERN_DEBUG "Glom Data:\n");
-					print_hex_dump_bytes("",
-							     DUMP_PREFIX_OFFSET,
-							     pkt->data, len);
-				}
-#endif
-				__skb_trim(pkt, len);
-				skb_pull(pkt, SDPCM_HDRLEN);
-				bus->glomd = pkt;
-			} else {
-				brcmf_dbg(ERROR, "%s: glom superframe w/o "
-					  "descriptor!\n", __func__);
-				brcmf_sdbrcm_rxfail(bus, false, false);
-			}
-			continue;
-		}
+	/* buf free handled in brcmf_write_to_file, not here */
+	return 0;
+}
 
-		/* Fill in packet len and prio, deliver upward */
-		__skb_trim(pkt, len);
-		skb_pull(pkt, doff);
+static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
+{
+	int bcmerror = 0;
+	uint msize = 512;
+	char *mbuffer = NULL;
+	uint maxstrlen = 256;
+	char *str = NULL;
+	struct brcmf_trap tr;
+	struct sdpcm_shared sdpcm_shared;
+	struct brcmu_strbuf strbuf;
 
-		if (pkt->len == 0) {
-			brcmu_pkt_buf_free_skb(pkt);
-			continue;
-		} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx, pkt) != 0) {
-			brcmf_dbg(ERROR, "rx protocol error\n");
-			brcmu_pkt_buf_free_skb(pkt);
-			bus->drvr->rx_errors++;
-			continue;
+	brcmf_dbg(TRACE, "Enter\n");
+
+	if (data == NULL) {
+		/*
+		 * Called after a rx ctrl timeout. "data" is NULL.
+		 * allocate memory to trace the trap or assert.
+		 */
+		size = msize;
+		mbuffer = data = kmalloc(msize, GFP_ATOMIC);
+		if (mbuffer == NULL) {
+			brcmf_dbg(ERROR, "kmalloc(%d) failed\n", msize);
+			bcmerror = -ENOMEM;
+			goto done;
 		}
-
-		/* Unlock during rx call */
-		brcmf_sdbrcm_sdunlock(bus);
-		brcmf_rx_frame(bus->drvr, ifidx, pkt, 1);
-		brcmf_sdbrcm_sdlock(bus);
 	}
-	rxcount = maxframes - rxleft;
-#ifdef BCMDBG
-	/* Message if we hit the limit */
-	if (!rxleft)
-		brcmf_dbg(DATA, "hit rx limit of %d frames\n",
-			  maxframes);
-	else
-#endif				/* BCMDBG */
-		brcmf_dbg(DATA, "processed %d frames\n", rxcount);
-	/* Back off rxseq if awaiting rtx, update rx_seq */
-	if (bus->rxskip)
-		rxseq--;
-	bus->rx_seq = rxseq;
 
-	return rxcount;
-}
+	str = kmalloc(maxstrlen, GFP_ATOMIC);
+	if (str == NULL) {
+		brcmf_dbg(ERROR, "kmalloc(%d) failed\n", maxstrlen);
+		bcmerror = -ENOMEM;
+		goto done;
+	}
 
-static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
-{
-	u32 intstatus = 0;
-	u32 hmb_data;
-	u8 fcbits;
-	uint retries = 0;
+	bcmerror = brcmf_sdbrcm_readshared(bus, &sdpcm_shared);
+	if (bcmerror < 0)
+		goto done;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmu_binit(&strbuf, data, size);
 
-	/* Read mailbox data and ack that we did so */
-	r_sdreg32(bus, &hmb_data,
-		  offsetof(struct sdpcmd_regs, tohostmailboxdata), &retries);
+	brcmu_bprintf(&strbuf,
+		    "msgtrace address : 0x%08X\nconsole address  : 0x%08X\n",
+		    sdpcm_shared.msgtrace_addr, sdpcm_shared.console_addr);
 
-	if (retries <= retry_limit)
-		w_sdreg32(bus, SMB_INT_ACK,
-			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
-	bus->f1regdata += 2;
+	if ((sdpcm_shared.flags & SDPCM_SHARED_ASSERT_BUILT) == 0)
+		/* NOTE: Misspelled assert is intentional - DO NOT FIX.
+		 * (Avoids conflict with real asserts for programmatic
+		 * parsing of output.)
+		 */
+		brcmu_bprintf(&strbuf, "Assrt not built in dongle\n");
 
-	/* Dongle recomposed rx frames, accept them again */
-	if (hmb_data & HMB_DATA_NAKHANDLED) {
-		brcmf_dbg(INFO, "Dongle reports NAK handled, expect rtx of %d\n",
-			  bus->rx_seq);
-		if (!bus->rxskip)
-			brcmf_dbg(ERROR, "unexpected NAKHANDLED!\n");
+	if ((sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP)) ==
+	    0) {
+		/* NOTE: Misspelled assert is intentional - DO NOT FIX.
+		 * (Avoids conflict with real asserts for programmatic
+		 * parsing of output.)
+		 */
+		brcmu_bprintf(&strbuf, "No trap%s in dongle",
+			    (sdpcm_shared.flags & SDPCM_SHARED_ASSERT_BUILT)
+			    ? "/assrt" : "");
+	} else {
+		if (sdpcm_shared.flags & SDPCM_SHARED_ASSERT) {
+			/* Download assert */
+			brcmu_bprintf(&strbuf, "Dongle assert");
+			if (sdpcm_shared.assert_exp_addr != 0) {
+				str[0] = '\0';
+				bcmerror = brcmf_sdbrcm_membytes(bus, false,
+						sdpcm_shared.assert_exp_addr,
+						(u8 *) str, maxstrlen);
+				if (bcmerror < 0)
+					goto done;
 
-		bus->rxskip = false;
-		intstatus |= I_HMB_FRAME_IND;
-	}
+				str[maxstrlen - 1] = '\0';
+				brcmu_bprintf(&strbuf, " expr \"%s\"", str);
+			}
 
-	/*
-	 * DEVREADY does not occur with gSPI.
-	 */
-	if (hmb_data & (HMB_DATA_DEVREADY | HMB_DATA_FWREADY)) {
-		bus->sdpcm_ver =
-		    (hmb_data & HMB_DATA_VERSION_MASK) >>
-		    HMB_DATA_VERSION_SHIFT;
-		if (bus->sdpcm_ver != SDPCM_PROT_VERSION)
-			brcmf_dbg(ERROR, "Version mismatch, dongle reports %d, "
-				  "expecting %d\n",
-				  bus->sdpcm_ver, SDPCM_PROT_VERSION);
-		else
-			brcmf_dbg(INFO, "Dongle ready, protocol version %d\n",
-				  bus->sdpcm_ver);
-	}
+			if (sdpcm_shared.assert_file_addr != 0) {
+				str[0] = '\0';
+				bcmerror = brcmf_sdbrcm_membytes(bus, false,
+						sdpcm_shared.assert_file_addr,
+						(u8 *) str, maxstrlen);
+				if (bcmerror < 0)
+					goto done;
 
-	/*
-	 * Flow Control has been moved into the RX headers and this out of band
-	 * method isn't used any more.
-	 * remaining backward compatible with older dongles.
-	 */
-	if (hmb_data & HMB_DATA_FC) {
-		fcbits = (hmb_data & HMB_DATA_FCDATA_MASK) >>
-							HMB_DATA_FCDATA_SHIFT;
+				str[maxstrlen - 1] = '\0';
+				brcmu_bprintf(&strbuf, " file \"%s\"", str);
+			}
 
-		if (fcbits & ~bus->flowcontrol)
-			bus->fc_xoff++;
+			brcmu_bprintf(&strbuf, " line %d ",
+				    sdpcm_shared.assert_line);
+		}
 
-		if (bus->flowcontrol & ~fcbits)
-			bus->fc_xon++;
+		if (sdpcm_shared.flags & SDPCM_SHARED_TRAP) {
+			bcmerror = brcmf_sdbrcm_membytes(bus, false,
+					sdpcm_shared.trap_addr, (u8 *)&tr,
+					sizeof(struct brcmf_trap));
+			if (bcmerror < 0)
+				goto done;
 
-		bus->fc_rcvd++;
-		bus->flowcontrol = fcbits;
+			brcmu_bprintf(&strbuf,
+				    "Dongle trap type 0x%x @ epc 0x%x, cpsr 0x%x, spsr 0x%x, sp 0x%x,"
+				    "lp 0x%x, rpc 0x%x Trap offset 0x%x, "
+				    "r0 0x%x, r1 0x%x, r2 0x%x, r3 0x%x, r4 0x%x, r5 0x%x, r6 0x%x, r7 0x%x\n",
+				    tr.type, tr.epc, tr.cpsr, tr.spsr, tr.r13,
+				    tr.r14, tr.pc, sdpcm_shared.trap_addr,
+				    tr.r0, tr.r1, tr.r2, tr.r3, tr.r4, tr.r5,
+				    tr.r6, tr.r7);
+		}
 	}
 
-	/* Shouldn't be any others */
-	if (hmb_data & ~(HMB_DATA_DEVREADY |
-			 HMB_DATA_NAKHANDLED |
-			 HMB_DATA_FC |
-			 HMB_DATA_FWREADY |
-			 HMB_DATA_FCDATA_MASK | HMB_DATA_VERSION_MASK))
-		brcmf_dbg(ERROR, "Unknown mailbox data content: 0x%02x\n",
-			  hmb_data);
+	if (sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP))
+		brcmf_dbg(ERROR, "%s\n", strbuf.origbuf);
 
-	return intstatus;
+#ifdef BCMDBG
+	if (sdpcm_shared.flags & SDPCM_SHARED_TRAP)
+		/* Mem dump to a file on device */
+		brcmf_sdbrcm_mem_dump(bus);
+
+#endif				/* BCMDBG */
+
+done:
+	kfree(mbuffer);
+	kfree(str);
+
+	return bcmerror;
 }
 
-static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
+#define CONSOLE_LINE_MAX	192
+
+static int brcmf_sdbrcm_readconsole(struct brcmf_bus *bus)
 {
-	u32 intstatus, newstatus = 0;
-	uint retries = 0;
-	uint rxlimit = brcmf_rxbound;	/* Rx frames to read before resched */
-	uint txlimit = brcmf_txbound;	/* Tx frames to send before resched */
-	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
-	bool rxdone = true;	/* Flag for no more read data */
-	bool resched = false;	/* Flag indicating resched wanted */
+	struct brcmf_console *c = &bus->console;
+	u8 line[CONSOLE_LINE_MAX], ch;
+	u32 n, idx, addr;
+	int rv;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	/* Don't do anything until FWREADY updates console address */
+	if (bus->console_addr == 0)
+		return 0;
 
-	/* Start with leftover status bits */
-	intstatus = bus->intstatus;
+	/* Read console log struct */
+	addr = bus->console_addr + offsetof(struct rte_console, log);
+	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *)&c->log,
+				sizeof(c->log));
+	if (rv < 0)
+		return rv;
 
-	brcmf_sdbrcm_sdlock(bus);
+	/* Allocate console buffer (one time only) */
+	if (c->buf == NULL) {
+		c->bufsize = le32_to_cpu(c->log.buf_size);
+		c->buf = kmalloc(c->bufsize, GFP_ATOMIC);
+		if (c->buf == NULL)
+			return -ENOMEM;
+	}
 
-	/* If waiting for HTAVAIL, check status */
-	if (bus->clkstate == CLK_PENDING) {
-		int err;
-		u8 clkctl, devctl = 0;
+	idx = le32_to_cpu(c->log.idx);
 
-#ifdef BCMDBG
-		/* Check for inconsistent device control */
-		devctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					       SBSDIO_DEVICE_CTL, &err);
-		if (err) {
-			brcmf_dbg(ERROR, "error reading DEVCTL: %d\n", err);
-			bus->drvr->busstate = BRCMF_BUS_DOWN;
-		}
-#endif				/* BCMDBG */
+	/* Protect against corrupt value */
+	if (idx > c->bufsize)
+		return -EBADE;
 
-		/* Read CSR, if clock on switch to AVAIL, else ignore */
-		clkctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
-		if (err) {
-			brcmf_dbg(ERROR, "error reading CSR: %d\n",
-				  err);
-			bus->drvr->busstate = BRCMF_BUS_DOWN;
-		}
+	/* Skip reading the console buffer if the index pointer
+	 has not moved */
+	if (idx == c->last)
+		return 0;
 
-		brcmf_dbg(INFO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
-			  devctl, clkctl);
+	/* Read the console buffer */
+	addr = le32_to_cpu(c->log.buf);
+	rv = brcmf_sdbrcm_membytes(bus, false, addr, c->buf, c->bufsize);
+	if (rv < 0)
+		return rv;
 
-		if (SBSDIO_HTAV(clkctl)) {
-			devctl = brcmf_sdcard_cfg_read(bus->sdiodev,
-						       SDIO_FUNC_1,
-						       SBSDIO_DEVICE_CTL, &err);
-			if (err) {
-				brcmf_dbg(ERROR, "error reading DEVCTL: %d\n",
-					  err);
-				bus->drvr->busstate = BRCMF_BUS_DOWN;
-			}
-			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
-			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				SBSDIO_DEVICE_CTL, devctl, &err);
-			if (err) {
-				brcmf_dbg(ERROR, "error writing DEVCTL: %d\n",
-					  err);
-				bus->drvr->busstate = BRCMF_BUS_DOWN;
+	while (c->last != idx) {
+		for (n = 0; n < CONSOLE_LINE_MAX - 2; n++) {
+			if (c->last == idx) {
+				/* This would output a partial line.
+				 * Instead, back up
+				 * the buffer pointer and output this
+				 * line next time around.
+				 */
+				if (c->last >= n)
+					c->last -= n;
+				else
+					c->last = c->bufsize - n;
+				goto break2;
 			}
-			bus->clkstate = CLK_AVAIL;
-		} else {
-			goto clkwait;
+			ch = c->buf[c->last];
+			c->last = (c->last + 1) % c->bufsize;
+			if (ch == '\n')
+				break;
+			line[n] = ch;
 		}
-	}
-
-	bus_wake(bus);
-
-	/* Make sure backplane clock is on */
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
-	if (bus->clkstate == CLK_PENDING)
-		goto clkwait;
 
-	/* Pending interrupt indicates new device status */
-	if (bus->ipend) {
-		bus->ipend = false;
-		r_sdreg32(bus, &newstatus,
-			  offsetof(struct sdpcmd_regs, intstatus), &retries);
-		bus->f1regdata++;
-		if (brcmf_sdcard_regfail(bus->sdiodev))
-			newstatus = 0;
-		newstatus &= bus->hostintmask;
-		bus->fcstate = !!(newstatus & I_HMB_FC_STATE);
-		if (newstatus) {
-			w_sdreg32(bus, newstatus,
-				  offsetof(struct sdpcmd_regs, intstatus),
-				  &retries);
-			bus->f1regdata++;
+		if (n > 0) {
+			if (line[n - 1] == '\r')
+				n--;
+			line[n] = 0;
+			printk(KERN_DEBUG "CONSOLE: %s\n", line);
 		}
 	}
+break2:
 
-	/* Merge new bits with previous */
-	intstatus |= newstatus;
-	bus->intstatus = 0;
+	return 0;
+}
+#endif				/* BCMDBG */
 
-	/* Handle flow-control change: read new state in case our ack
-	 * crossed another change interrupt.  If change still set, assume
-	 * FC ON for safety, let next loop through do the debounce.
-	 */
-	if (intstatus & I_HMB_FC_CHANGE) {
-		intstatus &= ~I_HMB_FC_CHANGE;
-		w_sdreg32(bus, I_HMB_FC_CHANGE,
-			  offsetof(struct sdpcmd_regs, intstatus), &retries);
+int
+brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
+{
+	u8 *frame;
+	u16 len;
+	u32 swheader;
+	uint retries = 0;
+	u8 doff = 0;
+	int ret = -1;
+	int i;
 
-		r_sdreg32(bus, &newstatus,
-			  offsetof(struct sdpcmd_regs, intstatus), &retries);
-		bus->f1regdata += 2;
-		bus->fcstate =
-		    !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE));
-		intstatus |= (newstatus & bus->hostintmask);
-	}
+	brcmf_dbg(TRACE, "Enter\n");
 
-	/* Handle host mailbox indication */
-	if (intstatus & I_HMB_HOST_INT) {
-		intstatus &= ~I_HMB_HOST_INT;
-		intstatus |= brcmf_sdbrcm_hostmail(bus);
-	}
+	if (bus->drvr->dongle_reset)
+		return -EIO;
 
-	/* Generally don't ask for these, can get CRC errors... */
-	if (intstatus & I_WR_OOSYNC) {
-		brcmf_dbg(ERROR, "Dongle reports WR_OOSYNC\n");
-		intstatus &= ~I_WR_OOSYNC;
-	}
+	/* Back the pointer to make a room for bus header */
+	frame = msg - SDPCM_HDRLEN;
+	len = (msglen += SDPCM_HDRLEN);
 
-	if (intstatus & I_RD_OOSYNC) {
-		brcmf_dbg(ERROR, "Dongle reports RD_OOSYNC\n");
-		intstatus &= ~I_RD_OOSYNC;
+	/* Add alignment padding (optional for ctl frames) */
+	if (brcmf_alignctl) {
+		doff = ((unsigned long)frame % BRCMF_SDALIGN);
+		if (doff) {
+			frame -= doff;
+			len += doff;
+			msglen += doff;
+			memset(frame, 0, doff + SDPCM_HDRLEN);
+		}
+		/* precondition: doff < BRCMF_SDALIGN */
 	}
+	doff += SDPCM_HDRLEN;
 
-	if (intstatus & I_SBINT) {
-		brcmf_dbg(ERROR, "Dongle reports SBINT\n");
-		intstatus &= ~I_SBINT;
+	/* Round send length to next SDIO block */
+	if (bus->roundup && bus->blocksize && (len > bus->blocksize)) {
+		u16 pad = bus->blocksize - (len % bus->blocksize);
+		if ((pad <= bus->roundup) && (pad < bus->blocksize))
+			len += pad;
+	} else if (len % BRCMF_SDALIGN) {
+		len += BRCMF_SDALIGN - (len % BRCMF_SDALIGN);
 	}
 
-	/* Would be active due to wake-wlan in gSPI */
-	if (intstatus & I_CHIPACTIVE) {
-		brcmf_dbg(INFO, "Dongle reports CHIPACTIVE\n");
-		intstatus &= ~I_CHIPACTIVE;
-	}
+	/* Satisfy length-alignment requirements */
+	if (forcealign && (len & (ALIGNMENT - 1)))
+		len = roundup(len, ALIGNMENT);
 
-	/* Ignore frame indications if rxskip is set */
-	if (bus->rxskip)
-		intstatus &= ~I_HMB_FRAME_IND;
+	/* precondition: IS_ALIGNED((unsigned long)frame, 2) */
 
-	/* On frame indication, read available frames */
-	if (PKT_AVAILABLE()) {
-		framecnt = brcmf_sdbrcm_readframes(bus, rxlimit, &rxdone);
-		if (rxdone || bus->rxskip)
-			intstatus &= ~I_HMB_FRAME_IND;
-		rxlimit -= min(framecnt, rxlimit);
-	}
+	/* Need to lock here to protect txseq and SDIO tx calls */
+	brcmf_sdbrcm_sdlock(bus);
 
-	/* Keep still-pending events for next scheduling */
-	bus->intstatus = intstatus;
+	bus_wake(bus);
 
-clkwait:
-	if (data_ok(bus) && bus->ctrl_frame_stat &&
-		(bus->clkstate == CLK_AVAIL)) {
-		int ret, i;
+	/* Make sure backplane clock is on */
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
-		ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
-			SDIO_FUNC_2, F2SYNC, (u8 *) bus->ctrl_frame_buf,
-			(u32) bus->ctrl_frame_len, NULL);
+	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
+	*(u16 *) frame = cpu_to_le16((u16) msglen);
+	*(((u16 *) frame) + 1) = cpu_to_le16(~msglen);
 
-		if (ret < 0) {
-			/* On failure, abort the command and
-				terminate the frame */
-			brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
-				  ret);
-			bus->tx_sderrs++;
+	/* Software tag: channel, sequence number, data offset */
+	swheader =
+	    ((SDPCM_CONTROL_CHANNEL << SDPCM_CHANNEL_SHIFT) &
+	     SDPCM_CHANNEL_MASK)
+	    | bus->tx_seq | ((doff << SDPCM_DOFFSET_SHIFT) &
+			     SDPCM_DOFFSET_MASK);
+	put_unaligned_le32(swheader, frame + SDPCM_FRAMETAG_LEN);
+	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
 
-			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
+	if (!data_ok(bus)) {
+		brcmf_dbg(INFO, "No bus credit bus->tx_max %d, bus->tx_seq %d\n",
+			  bus->tx_max, bus->tx_seq);
+		bus->ctrl_frame_stat = true;
+		/* Send from dpc */
+		bus->ctrl_frame_buf = frame;
+		bus->ctrl_frame_len = len;
 
-			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
-					 NULL);
-			bus->f1regdata++;
+		brcmf_sdbrcm_wait_for_event(bus, &bus->ctrl_frame_stat);
 
-			for (i = 0; i < 3; i++) {
-				u8 hi, lo;
-				hi = brcmf_sdcard_cfg_read(bus->sdiodev,
-						     SDIO_FUNC_1,
-						     SBSDIO_FUNC1_WFRAMEBCHI,
-						     NULL);
-				lo = brcmf_sdcard_cfg_read(bus->sdiodev,
-						     SDIO_FUNC_1,
-						     SBSDIO_FUNC1_WFRAMEBCLO,
-						     NULL);
-				bus->f1regdata += 2;
-				if ((hi == 0) && (lo == 0))
-					break;
-			}
+		if (bus->ctrl_frame_stat == false) {
+			brcmf_dbg(INFO, "ctrl_frame_stat == false\n");
+			ret = 0;
+		} else {
+			brcmf_dbg(INFO, "ctrl_frame_stat == true\n");
+			ret = -1;
+		}
+	}
 
+	if (ret == -1) {
+#ifdef BCMDBG
+		if (BRCMF_BYTES_ON() && BRCMF_CTL_ON()) {
+			printk(KERN_DEBUG "Tx Frame:\n");
+			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+					     frame, len);
+		} else if (BRCMF_HDRS_ON()) {
+			printk(KERN_DEBUG "TxHdr:\n");
+			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+					     frame, min_t(u16, len, 16));
 		}
-		if (ret == 0)
-			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
+#endif
 
-		brcmf_dbg(INFO, "Return_dpc value is : %d\n", ret);
-		bus->ctrl_frame_stat = false;
-		brcmf_sdbrcm_wait_event_wakeup(bus);
-	}
-	/* Send queued frames (limit 1 if rx may still be pending) */
-	else if ((bus->clkstate == CLK_AVAIL) && !bus->fcstate &&
-		 brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
-		 && data_ok(bus)) {
-		framecnt = rxdone ? txlimit : min(txlimit, brcmf_txminmax);
-		framecnt = brcmf_sdbrcm_sendfromq(bus, framecnt);
-		txlimit -= framecnt;
-	}
+		do {
+			bus->ctrl_frame_stat = false;
+			ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
+					SDIO_FUNC_2, F2SYNC, frame, len, NULL);
+
+			if (ret < 0) {
+				/* On failure, abort the command and
+				 terminate the frame */
+				brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
+					  ret);
+				bus->tx_sderrs++;
+
+				brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
+
+				brcmf_sdcard_cfg_write(bus->sdiodev,
+						 SDIO_FUNC_1,
+						 SBSDIO_FUNC1_FRAMECTRL,
+						 SFC_WF_TERM, NULL);
+				bus->f1regdata++;
+
+				for (i = 0; i < 3; i++) {
+					u8 hi, lo;
+					hi = brcmf_sdcard_cfg_read(bus->sdiodev,
+					     SDIO_FUNC_1,
+					     SBSDIO_FUNC1_WFRAMEBCHI,
+					     NULL);
+					lo = brcmf_sdcard_cfg_read(bus->sdiodev,
+					     SDIO_FUNC_1,
+					     SBSDIO_FUNC1_WFRAMEBCLO,
+					     NULL);
+					bus->f1regdata += 2;
+					if ((hi == 0) && (lo == 0))
+						break;
+				}
 
-	/* Resched if events or tx frames are pending,
-		 else await next interrupt */
-	/* On failed register access, all bets are off:
-		 no resched or interrupts */
-	if ((bus->drvr->busstate == BRCMF_BUS_DOWN) ||
-	    brcmf_sdcard_regfail(bus->sdiodev)) {
-		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting operation %d\n",
-			  brcmf_sdcard_regfail(bus->sdiodev));
-		bus->drvr->busstate = BRCMF_BUS_DOWN;
-		bus->intstatus = 0;
-	} else if (bus->clkstate == CLK_PENDING) {
-		brcmf_dbg(INFO, "rescheduled due to CLK_PENDING awaiting I_CHIPACTIVE interrupt\n");
-		resched = true;
-	} else if (bus->intstatus || bus->ipend ||
-		(!bus->fcstate && brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol)
-		 && data_ok(bus)) || PKT_AVAILABLE()) {
-		resched = true;
-	}
+			}
+			if (ret == 0)
+				bus->tx_seq =
+				    (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
-	bus->dpc_sched = resched;
+		} while ((ret < 0) && retries++ < TXRETRIES);
+	}
 
-	/* If we're done for now, turn off clock request. */
-	if ((bus->clkstate != CLK_PENDING)
-	    && bus->idletime == BRCMF_IDLE_IMMEDIATE) {
+	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) && !bus->dpc_sched) {
 		bus->activity = false;
-		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
 
 	brcmf_sdbrcm_sdunlock(bus);
 
-	return resched;
+	if (ret)
+		bus->drvr->tx_ctlerrs++;
+	else
+		bus->drvr->tx_ctlpkts++;
+
+	return ret ? -EIO : 0;
 }
 
-void brcmf_sdbrcm_isr(void *arg)
+int
+brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 {
-	struct brcmf_bus *bus = (struct brcmf_bus *) arg;
+	int timeleft;
+	uint rxlen = 0;
+	bool pending;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (!bus) {
-		brcmf_dbg(ERROR, "bus is null pointer, exiting\n");
-		return;
-	}
+	if (bus->drvr->dongle_reset)
+		return -EIO;
 
-	if (bus->drvr->busstate == BRCMF_BUS_DOWN) {
-		brcmf_dbg(ERROR, "bus is down. we have nothing to do\n");
-		return;
-	}
-	/* Count the interrupt call */
-	bus->intrcount++;
-	bus->ipend = true;
+	/* Wait until control frame is available */
+	timeleft = brcmf_sdbrcm_ioctl_resp_wait(bus, &bus->rxlen, &pending);
 
-	/* Shouldn't get this interrupt if we're sleeping? */
-	if (bus->sleeping) {
-		brcmf_dbg(ERROR, "INTERRUPT WHILE SLEEPING??\n");
-		return;
+	brcmf_sdbrcm_sdlock(bus);
+	rxlen = bus->rxlen;
+	memcpy(msg, bus->rxctl, min(msglen, rxlen));
+	bus->rxlen = 0;
+	brcmf_sdbrcm_sdunlock(bus);
+
+	if (rxlen) {
+		brcmf_dbg(CTL, "resumed on rxctl frame, got %d expected %d\n",
+			  rxlen, msglen);
+	} else if (timeleft == 0) {
+		brcmf_dbg(ERROR, "resumed on timeout\n");
+#ifdef BCMDBG
+		brcmf_sdbrcm_sdlock(bus);
+		brcmf_sdbrcm_checkdied(bus, NULL, 0);
+		brcmf_sdbrcm_sdunlock(bus);
+#endif				/* BCMDBG */
+	} else if (pending == true) {
+		brcmf_dbg(CTL, "cancelled\n");
+		return -ERESTARTSYS;
+	} else {
+		brcmf_dbg(CTL, "resumed for unknown reason?\n");
+#ifdef BCMDBG
+		brcmf_sdbrcm_sdlock(bus);
+		brcmf_sdbrcm_checkdied(bus, NULL, 0);
+		brcmf_sdbrcm_sdunlock(bus);
+#endif				/* BCMDBG */
 	}
 
-	/* Disable additional interrupts (is this needed now)? */
-	if (!bus->intr)
-		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
+	if (rxlen)
+		bus->drvr->rx_ctlpkts++;
+	else
+		bus->drvr->rx_ctlerrs++;
 
-	bus->dpc_sched = true;
-	brcmf_sdbrcm_sched_dpc(bus);
+	return rxlen ? (int)rxlen : -ETIMEDOUT;
 }
 
-static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
+static int brcmf_sdbrcm_downloadvars(struct brcmf_bus *bus, void *arg, int len)
 {
-	struct brcmf_bus *bus;
+	int bcmerror = 0;
 
-	brcmf_dbg(TIMER, "Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 
-	bus = drvr->bus;
+	/* Basic sanity checks */
+	if (bus->drvr->up) {
+		bcmerror = -EISCONN;
+		goto err;
+	}
+	if (!len) {
+		bcmerror = -EOVERFLOW;
+		goto err;
+	}
 
-	if (bus->drvr->dongle_reset)
-		return false;
+	/* Free the old ones and replace with passed variables */
+	kfree(bus->vars);
 
-	/* Ignore the timer if simulating bus down */
-	if (bus->sleeping)
-		return false;
+	bus->vars = kmalloc(len, GFP_ATOMIC);
+	bus->varsz = bus->vars ? len : 0;
+	if (bus->vars == NULL) {
+		bcmerror = -ENOMEM;
+		goto err;
+	}
 
-	brcmf_sdbrcm_sdlock(bus);
+	/* Copy the passed variables, which should include the
+		 terminating double-null */
+	memcpy(bus->vars, arg, bus->varsz);
+err:
+	return bcmerror;
+}
 
-	/* Poll period: check device if appropriate. */
-	if (bus->poll && (++bus->polltick >= bus->pollrate)) {
-		u32 intstatus = 0;
+static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
+{
+	int bcmerror = 0;
+	u32 varsize;
+	u32 varaddr;
+	u8 *vbuffer;
+	u32 varsizew;
+#ifdef BCMDBG
+	char *nvram_ularray;
+#endif				/* BCMDBG */
 
-		/* Reset poll tick */
-		bus->polltick = 0;
+	/* Even if there are no vars are to be written, we still
+		 need to set the ramsize. */
+	varsize = bus->varsz ? roundup(bus->varsz, 4) : 0;
+	varaddr = (bus->ramsize - 4) - varsize;
 
-		/* Check device if no interrupts */
-		if (!bus->intr || (bus->intrcount == bus->lastintrs)) {
+	if (bus->vars) {
+		vbuffer = kzalloc(varsize, GFP_ATOMIC);
+		if (!vbuffer)
+			return -ENOMEM;
 
-			if (!bus->dpc_sched) {
-				u8 devpend;
-				devpend = brcmf_sdcard_cfg_read(bus->sdiodev,
-						SDIO_FUNC_0, SDIO_CCCR_INTx,
-						NULL);
-				intstatus =
-				    devpend & (INTR_STATUS_FUNC1 |
-					       INTR_STATUS_FUNC2);
-			}
+		memcpy(vbuffer, bus->vars, bus->varsz);
 
-			/* If there is something, make like the ISR and
-				 schedule the DPC */
-			if (intstatus) {
-				bus->pollcnt++;
-				bus->ipend = true;
+		/* Write the vars list */
+		bcmerror =
+		    brcmf_sdbrcm_membytes(bus, true, varaddr, vbuffer, varsize);
+#ifdef BCMDBG
+		/* Verify NVRAM bytes */
+		brcmf_dbg(INFO, "Compare NVRAM dl & ul; varsize=%d\n", varsize);
+		nvram_ularray = kmalloc(varsize, GFP_ATOMIC);
+		if (!nvram_ularray)
+			return -ENOMEM;
 
-				bus->dpc_sched = true;
-				brcmf_sdbrcm_sched_dpc(bus);
+		/* Upload image to verify downloaded contents. */
+		memset(nvram_ularray, 0xaa, varsize);
 
-			}
+		/* Read the vars list to temp buffer for comparison */
+		bcmerror =
+		    brcmf_sdbrcm_membytes(bus, false, varaddr, nvram_ularray,
+				     varsize);
+		if (bcmerror) {
+			brcmf_dbg(ERROR, "error %d on reading %d nvram bytes at 0x%08x\n",
+				  bcmerror, varsize, varaddr);
 		}
+		/* Compare the org NVRAM with the one read from RAM */
+		if (memcmp(vbuffer, nvram_ularray, varsize))
+			brcmf_dbg(ERROR, "Downloaded NVRAM image is corrupted\n");
+		else
+			brcmf_dbg(ERROR, "Download/Upload/Compare of NVRAM ok\n");
 
-		/* Update interrupt tracking */
-		bus->lastintrs = bus->intrcount;
-	}
-#ifdef BCMDBG
-	/* Poll for console output periodically */
-	if (drvr->busstate == BRCMF_BUS_DATA && brcmf_console_ms != 0) {
-		bus->console.count += brcmf_watchdog_ms;
-		if (bus->console.count >= brcmf_console_ms) {
-			bus->console.count -= brcmf_console_ms;
-			/* Make sure backplane clock is on */
-			brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-			if (brcmf_sdbrcm_readconsole(bus) < 0)
-				brcmf_console_ms = 0;	/* On error,
-							 stop trying */
-		}
-	}
+		kfree(nvram_ularray);
 #endif				/* BCMDBG */
 
-	/* On idle timeout clear activity flag and/or turn off clock */
-	if ((bus->idletime > 0) && (bus->clkstate == CLK_AVAIL)) {
-		if (++bus->idlecount >= bus->idletime) {
-			bus->idlecount = 0;
-			if (bus->activity) {
-				bus->activity = false;
-				brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
-			} else {
-				brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
-			}
-		}
+		kfree(vbuffer);
+	}
+
+	/* adjust to the user specified RAM */
+	brcmf_dbg(INFO, "Physical memory size: %d, usable memory size: %d\n",
+		  bus->orig_ramsize, bus->ramsize);
+	brcmf_dbg(INFO, "Vars are at %d, orig varsize is %d\n",
+		  varaddr, varsize);
+	varsize = ((bus->orig_ramsize - 4) - varaddr);
+
+	/*
+	 * Determine the length token:
+	 * Varsize, converted to words, in lower 16-bits, checksum
+	 * in upper 16-bits.
+	 */
+	if (bcmerror) {
+		varsizew = 0;
+	} else {
+		varsizew = varsize / 4;
+		varsizew = (~varsizew << 16) | (varsizew & 0x0000FFFF);
+		varsizew = cpu_to_le32(varsizew);
 	}
 
-	brcmf_sdbrcm_sdunlock(bus);
+	brcmf_dbg(INFO, "New varsize is %d, length token=0x%08x\n",
+		  varsize, varsizew);
 
-	return bus->ipend;
-}
+	/* Write the length token to the last word */
+	bcmerror = brcmf_sdbrcm_membytes(bus, true, (bus->orig_ramsize - 4),
+				    (u8 *)&varsizew, 4);
 
-static bool brcmf_sdbrcm_chipmatch(u16 chipid)
-{
-	if (chipid == BCM4329_CHIP_ID)
-		return true;
-	return false;
+	return bcmerror;
 }
 
-void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
-			 u32 regsva, struct brcmf_sdio_dev *sdiodev)
+static void
+brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 {
-	int ret;
-	struct brcmf_bus *bus;
+	u32 regdata;
 
-	/* Init global variables at run-time, not as part of the declaration.
-	 * This is required to support init/de-init of the driver.
-	 * Initialization
-	 * of globals as part of the declaration results in non-deterministic
-	 * behavior since the value of the globals may be different on the
-	 * first time that the driver is initialized vs subsequent
-	 * initializations.
-	 */
-	brcmf_txbound = BRCMF_TXBOUND;
-	brcmf_rxbound = BRCMF_RXBOUND;
-	brcmf_alignctl = true;
-	brcmf_readahead = true;
-	retrydata = false;
-	brcmf_dongle_memsize = 0;
-	brcmf_txminmax = BRCMF_TXMINMAX;
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+		CORE_SB(corebase, sbtmstatelow), 4);
+	if (regdata & SBTML_RESET)
+		return;
 
-	forcealign = true;
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+		CORE_SB(corebase, sbtmstatelow), 4);
+	if ((regdata & (SICF_CLOCK_EN << SBTML_SICF_SHIFT)) != 0) {
+		/*
+		 * set target reject and spin until busy is clear
+		 * (preserve core-specific bits)
+		 */
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbtmstatelow), 4);
+		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow),
+				       4, regdata | SBTML_REJ);
 
-	brcmf_c_init();
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbtmstatelow), 4);
+		udelay(1);
+		SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbtmstatehigh), 4) &
+			SBTMH_BUSY), 100000);
 
-	brcmf_dbg(TRACE, "Enter\n");
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbtmstatehigh), 4);
+		if (regdata & SBTMH_BUSY)
+			brcmf_dbg(ERROR, "ARM core still busy\n");
 
-	/* We make an assumption about address window mappings:
-	 * regsva == SI_ENUM_BASE*/
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbidlow), 4);
+		if (regdata & SBIDL_INIT) {
+			regdata = brcmf_sdcard_reg_read(sdiodev,
+				CORE_SB(corebase, sbimstate), 4) |
+				SBIM_RJ;
+			brcmf_sdcard_reg_write(sdiodev,
+				CORE_SB(corebase, sbimstate), 4,
+				regdata);
+			regdata = brcmf_sdcard_reg_read(sdiodev,
+				CORE_SB(corebase, sbimstate), 4);
+			udelay(1);
+			SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
+				CORE_SB(corebase, sbimstate), 4) &
+				SBIM_BY), 100000);
+		}
 
-	/* Allocate private bus interface state */
-	bus = kzalloc(sizeof(struct brcmf_bus), GFP_ATOMIC);
-	if (!bus) {
-		brcmf_dbg(ERROR, "kmalloc of struct dhd_bus failed\n");
-		goto fail;
-	}
-	bus->sdiodev = sdiodev;
-	sdiodev->bus = bus;
-	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
-	bus->usebufpool = false;	/* Use bufpool if allocated,
-					 else use locally malloced rxbuf */
+		/* set reset and reject while enabling the clocks */
+		brcmf_sdcard_reg_write(sdiodev,
+			CORE_SB(corebase, sbtmstatelow), 4,
+			(((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
+			SBTML_REJ | SBTML_RESET));
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbtmstatelow), 4);
+		udelay(10);
 
-	/* attempt to attach to the dongle */
-	if (!(brcmf_sdbrcm_probe_attach(bus, regsva))) {
-		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_attach failed\n");
-		goto fail;
+		/* clear the initiator reject bit */
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbidlow), 4);
+		if (regdata & SBIDL_INIT) {
+			regdata = brcmf_sdcard_reg_read(sdiodev,
+				CORE_SB(corebase, sbimstate), 4) &
+				~SBIM_RJ;
+			brcmf_sdcard_reg_write(sdiodev,
+				CORE_SB(corebase, sbimstate), 4,
+				regdata);
+		}
 	}
 
-	spin_lock_init(&bus->txqlock);
-	init_waitqueue_head(&bus->ctrl_wait);
-	init_waitqueue_head(&bus->ioctl_resp_wait);
+	/* leave reset and reject asserted */
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
+		(SBTML_REJ | SBTML_RESET));
+	udelay(1);
+}
 
-	/* Set up the watchdog timer */
-	init_timer(&bus->timer);
-	bus->timer.data = (unsigned long)bus;
-	bus->timer.function = brcmf_sdbrcm_watchdog;
+static void
+brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
+{
+	u32 regdata;
 
-	/* Initialize thread based operation and lock */
-	if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0)) {
-		bus->threads_only = true;
-		sema_init(&bus->sdsem, 1);
-	} else {
-		bus->threads_only = false;
-		spin_lock_init(&bus->sdlock);
-	}
+	/*
+	 * Must do the disable sequence first to work for
+	 * arbitrary current core state.
+	 */
+	brcmf_sdbrcm_chip_disablecore(sdiodev, corebase);
 
-	if (brcmf_dpc_prio >= 0) {
-		/* Initialize watchdog thread */
-		init_completion(&bus->watchdog_wait);
-		bus->watchdog_tsk = kthread_run(brcmf_sdbrcm_watchdog_thread,
-						bus, "brcmf_watchdog");
-		if (IS_ERR(bus->watchdog_tsk)) {
-			printk(KERN_WARNING
-			       "brcmf_watchdog thread failed to start\n");
-			bus->watchdog_tsk = NULL;
-		}
-	} else
-		bus->watchdog_tsk = NULL;
+	/*
+	 * Now do the initialization sequence.
+	 * set reset while enabling the clock and
+	 * forcing them on throughout the core
+	 */
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
+		((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
+		SBTML_RESET);
+	udelay(1);
 
-	/* Set up the bottom half handler */
-	if (brcmf_dpc_prio >= 0) {
-		/* Initialize DPC thread */
-		init_completion(&bus->dpc_wait);
-		bus->dpc_tsk = kthread_run(brcmf_sdbrcm_dpc_thread,
-					   bus, "brcmf_dpc");
-		if (IS_ERR(bus->dpc_tsk)) {
-			printk(KERN_WARNING
-			       "brcmf_dpc thread failed to start\n");
-			bus->dpc_tsk = NULL;
-		}
-	} else {
-		tasklet_init(&bus->tasklet, brcmf_sdbrcm_dpc_tasklet,
-			     (unsigned long)bus);
-		bus->dpc_tsk = NULL;
-	}
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					CORE_SB(corebase, sbtmstatehigh), 4);
+	if (regdata & SBTMH_SERR)
+		brcmf_sdcard_reg_write(sdiodev,
+				       CORE_SB(corebase, sbtmstatehigh), 4, 0);
 
-	/* Attach to the brcmf/OS/network interface */
-	bus->drvr = brcmf_attach(bus, SDPCM_RESERVE);
-	if (!bus->drvr) {
-		brcmf_dbg(ERROR, "brcmf_attach failed\n");
-		goto fail;
-	}
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					CORE_SB(corebase, sbimstate), 4);
+	if (regdata & (SBIM_IBE | SBIM_TO))
+		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbimstate), 4,
+			regdata & ~(SBIM_IBE | SBIM_TO));
 
-	/* Allocate buffers */
-	if (!(brcmf_sdbrcm_probe_malloc(bus))) {
-		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_malloc failed\n");
-		goto fail;
-	}
+	/* clear reset and allow it to propagate throughout the core */
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
+		(SICF_FGC << SBTML_SICF_SHIFT) |
+		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
+	udelay(1);
 
-	if (!(brcmf_sdbrcm_probe_init(bus))) {
-		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_init failed\n");
-		goto fail;
-	}
+	/* leave clock enabled */
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
+		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
+	udelay(1);
+}
 
-	/* Register interrupt callback, but mask it (not operational yet). */
-	brcmf_dbg(INTR, "disable SDIO interrupts (not interested yet)\n");
-	ret = brcmf_sdcard_intr_reg(bus->sdiodev);
-	if (ret != 0) {
-		brcmf_dbg(ERROR, "FAILED: sdcard_intr_reg returned %d\n", ret);
-		goto fail;
-	}
-	brcmf_dbg(INTR, "registered SDIO interrupt function ok\n");
+static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
+{
+	uint retries;
+	u32 regdata;
+	int bcmerror = 0;
 
-	brcmf_dbg(INFO, "completed!!\n");
+	/* To enter download state, disable ARM and reset SOCRAM.
+	 * To exit download state, simply reset ARM (default is RAM boot).
+	 */
+	if (enter) {
+		bus->alp_only = true;
 
-	/* if firmware path present try to download and bring up bus */
-	ret = brcmf_bus_start(bus->drvr);
-	if (ret != 0) {
-		if (ret == -ENOLINK) {
-			brcmf_dbg(ERROR, "dongle is not responding\n");
+		brcmf_sdbrcm_chip_disablecore(bus->sdiodev,
+					      bus->ci->armcorebase);
+
+		brcmf_sdbrcm_chip_resetcore(bus->sdiodev, bus->ci->ramcorebase);
+
+		/* Clear the top bit of memory */
+		if (bus->ramsize) {
+			u32 zeros = 0;
+			brcmf_sdbrcm_membytes(bus, true, bus->ramsize - 4,
+					 (u8 *)&zeros, 4);
+		}
+	} else {
+		regdata = brcmf_sdcard_reg_read(bus->sdiodev,
+			CORE_SB(bus->ci->ramcorebase, sbtmstatelow), 4);
+		regdata &= (SBTML_RESET | SBTML_REJ_MASK |
+			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
+		if ((SICF_CLOCK_EN << SBTML_SICF_SHIFT) != regdata) {
+			brcmf_dbg(ERROR, "SOCRAM core is down after reset?\n");
+			bcmerror = -EBADE;
 			goto fail;
 		}
-	}
-	/* Ok, have the per-port tell the stack we're open for business */
-	if (brcmf_net_attach(bus->drvr, 0) != 0) {
-		brcmf_dbg(ERROR, "Net attach failed!!\n");
-		goto fail;
-	}
 
-	return bus;
+		bcmerror = brcmf_sdbrcm_write_vars(bus);
+		if (bcmerror) {
+			brcmf_dbg(ERROR, "no vars written to RAM\n");
+			bcmerror = 0;
+		}
+
+		w_sdreg32(bus, 0xFFFFFFFF,
+			  offsetof(struct sdpcmd_regs, intstatus), &retries);
+
+		brcmf_sdbrcm_chip_resetcore(bus->sdiodev, bus->ci->armcorebase);
+
+		/* Allow HT Clock now that the ARM is running. */
+		bus->alp_only = false;
 
+		bus->drvr->busstate = BRCMF_BUS_LOAD;
+	}
 fail:
-	brcmf_sdbrcm_release(bus);
-	return NULL;
+	return bcmerror;
 }
 
-static bool
-brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
+static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus)
 {
-	u8 clkctl = 0;
-	int err = 0;
-	int reg_addr;
-	u32 reg_val;
-
-	bus->alp_only = true;
-
-	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdcard_set_sbaddr_window(bus->sdiodev, SI_ENUM_BASE))
-		brcmf_dbg(ERROR, "FAILED to return to SI_ENUM_BASE\n");
+	if (bus->firmware->size < bus->fw_ptr + len)
+		len = bus->firmware->size - bus->fw_ptr;
 
-#ifdef BCMDBG
-	printk(KERN_DEBUG "F1 signature read @0x18000000=0x%4x\n",
-	       brcmf_sdcard_reg_read(bus->sdiodev, SI_ENUM_BASE, 4));
+	memcpy(buf, &bus->firmware->data[bus->fw_ptr], len);
+	bus->fw_ptr += len;
+	return len;
+}
 
-#endif				/* BCMDBG */
+MODULE_FIRMWARE(BCM4329_FW_NAME);
+MODULE_FIRMWARE(BCM4329_NV_NAME);
 
-	/*
-	 * Force PLL off until brcmf_sdbrcm_chip_attach()
-	 * programs PLL control regs
-	 */
+static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
+{
+	int offset = 0;
+	uint len;
+	u8 *memblock = NULL, *memptr;
+	int ret;
 
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_CHIPCLKCSR,
-			       BRCMF_INIT_CLKCTL1, &err);
-	if (!err)
-		clkctl =
-		    brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
+	brcmf_dbg(INFO, "Enter\n");
 
-	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
-		brcmf_dbg(ERROR, "ChipClkCSR access: err %d wrote 0x%02x read 0x%02x\n",
-			  err, BRCMF_INIT_CLKCTL1, clkctl);
-		goto fail;
+	bus->fw_name = BCM4329_FW_NAME;
+	ret = request_firmware(&bus->firmware, bus->fw_name,
+			       &bus->sdiodev->func[2]->dev);
+	if (ret) {
+		brcmf_dbg(ERROR, "Fail to request firmware %d\n", ret);
+		return ret;
 	}
+	bus->fw_ptr = 0;
 
-	if (brcmf_sdbrcm_chip_attach(bus, regsva)) {
-		brcmf_dbg(ERROR, "brcmf_sdbrcm_chip_attach failed!\n");
-		goto fail;
+	memptr = memblock = kmalloc(MEMBLOCK + BRCMF_SDALIGN, GFP_ATOMIC);
+	if (memblock == NULL) {
+		brcmf_dbg(ERROR, "Failed to allocate memory %d bytes\n",
+			  MEMBLOCK);
+		ret = -ENOMEM;
+		goto err;
 	}
+	if ((u32)(unsigned long)memblock % BRCMF_SDALIGN)
+		memptr += (BRCMF_SDALIGN -
+			   ((u32)(unsigned long)memblock % BRCMF_SDALIGN));
 
-	if (!brcmf_sdbrcm_chipmatch((u16) bus->ci->chip)) {
-		brcmf_dbg(ERROR, "unsupported chip: 0x%04x\n", bus->ci->chip);
-		goto fail;
+	/* Download image */
+	while ((len =
+		brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus))) {
+		ret = brcmf_sdbrcm_membytes(bus, true, offset, memptr, len);
+		if (ret) {
+			brcmf_dbg(ERROR, "error %d on writing %d membytes at 0x%08x\n",
+				  ret, MEMBLOCK, offset);
+			goto err;
+		}
+
+		offset += MEMBLOCK;
 	}
 
-	brcmf_sdbrcm_sdiod_drive_strength_init(bus, brcmf_sdiod_drive_strength);
+err:
+	kfree(memblock);
 
-	/* Get info on the ARM and SOCRAM cores... */
-	brcmf_sdcard_reg_read(bus->sdiodev,
-		  CORE_SB(bus->ci->armcorebase, sbidhigh), 4);
-	bus->orig_ramsize = bus->ci->ramsize;
-	if (!(bus->orig_ramsize)) {
-		brcmf_dbg(ERROR, "failed to find SOCRAM memory!\n");
-		goto fail;
-	}
-	bus->ramsize = bus->orig_ramsize;
-	if (brcmf_dongle_memsize)
-		brcmf_sdbrcm_setmemsize(bus, brcmf_dongle_memsize);
+	release_firmware(bus->firmware);
+	bus->fw_ptr = 0;
 
-	brcmf_dbg(ERROR, "DHD: dongle ram size is set to %d(orig %d)\n",
-		  bus->ramsize, bus->orig_ramsize);
+	return ret;
+}
 
-	/* Set core control so an SDIO reset does a backplane reset */
-	reg_addr = bus->ci->buscorebase +
-		   offsetof(struct sdpcmd_regs, corecontrol);
-	reg_val = brcmf_sdcard_reg_read(bus->sdiodev, reg_addr, sizeof(u32));
-	brcmf_sdcard_reg_write(bus->sdiodev, reg_addr, sizeof(u32),
-			       reg_val | CC_BPRESEN);
+/*
+ * ProcessVars:Takes a buffer of "<var>=<value>\n" lines read from a file
+ * and ending in a NUL.
+ * Removes carriage returns, empty lines, comment lines, and converts
+ * newlines to NULs.
+ * Shortens buffer as needed and pads with NULs.  End of buffer is marked
+ * by two NULs.
+*/
 
-	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
+static uint brcmf_process_nvram_vars(char *varbuf, uint len)
+{
+	char *dp;
+	bool findNewline;
+	int column;
+	uint buf_len, n;
 
-	/* Locate an appropriately-aligned portion of hdrbuf */
-	bus->rxhdr = (u8 *) roundup((unsigned long)&bus->hdrbuf[0],
-				    BRCMF_SDALIGN);
+	dp = varbuf;
 
-	/* Set the poll and/or interrupt flags */
-	bus->intr = (bool) brcmf_intr;
-	bus->poll = (bool) brcmf_poll;
-	if (bus->poll)
-		bus->pollrate = 1;
+	findNewline = false;
+	column = 0;
 
-	return true;
+	for (n = 0; n < len; n++) {
+		if (varbuf[n] == 0)
+			break;
+		if (varbuf[n] == '\r')
+			continue;
+		if (findNewline && varbuf[n] != '\n')
+			continue;
+		findNewline = false;
+		if (varbuf[n] == '#') {
+			findNewline = true;
+			continue;
+		}
+		if (varbuf[n] == '\n') {
+			if (column == 0)
+				continue;
+			*dp++ = 0;
+			column = 0;
+			continue;
+		}
+		*dp++ = varbuf[n];
+		column++;
+	}
+	buf_len = dp - varbuf;
 
-fail:
-	return false;
+	while (dp < varbuf + n)
+		*dp++ = 0;
+
+	return buf_len;
 }
 
-static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus)
+static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
 {
-	brcmf_dbg(TRACE, "Enter\n");
+	uint len;
+	char *memblock = NULL;
+	char *bufp;
+	int ret;
 
-	if (bus->drvr->maxctl) {
-		bus->rxblen =
-		    roundup((bus->drvr->maxctl + SDPCM_HDRLEN),
-			    ALIGNMENT) + BRCMF_SDALIGN;
-		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
-		if (!(bus->rxbuf)) {
-			brcmf_dbg(ERROR, "kmalloc of %d-byte rxbuf failed\n",
-				  bus->rxblen);
-			goto fail;
-		}
+	bus->nv_name = BCM4329_NV_NAME;
+	ret = request_firmware(&bus->firmware, bus->nv_name,
+			       &bus->sdiodev->func[2]->dev);
+	if (ret) {
+		brcmf_dbg(ERROR, "Fail to request nvram %d\n", ret);
+		return ret;
 	}
+	bus->fw_ptr = 0;
 
-	/* Allocate buffer to receive glomed packet */
-	bus->databuf = kmalloc(MAX_DATA_BUF, GFP_ATOMIC);
-	if (!(bus->databuf)) {
-		brcmf_dbg(ERROR, "kmalloc of %d-byte databuf failed\n",
-			  MAX_DATA_BUF);
-		/* release rxbuf which was already located as above */
-		if (!bus->rxblen)
-			kfree(bus->rxbuf);
-		goto fail;
+	memblock = kmalloc(MEMBLOCK, GFP_ATOMIC);
+	if (memblock == NULL) {
+		brcmf_dbg(ERROR, "Failed to allocate memory %d bytes\n",
+			  MEMBLOCK);
+		ret = -ENOMEM;
+		goto err;
 	}
 
-	/* Align the buffer */
-	if ((unsigned long)bus->databuf % BRCMF_SDALIGN)
-		bus->dataptr = bus->databuf + (BRCMF_SDALIGN -
-			       ((unsigned long)bus->databuf % BRCMF_SDALIGN));
-	else
-		bus->dataptr = bus->databuf;
+	len = brcmf_sdbrcm_get_image(memblock, MEMBLOCK, bus);
+
+	if (len > 0 && len < MEMBLOCK) {
+		bufp = (char *)memblock;
+		bufp[len] = 0;
+		len = brcmf_process_nvram_vars(bufp, len);
+		bufp += len;
+		*bufp++ = 0;
+		if (len)
+			ret = brcmf_sdbrcm_downloadvars(bus, memblock, len + 1);
+		if (ret)
+			brcmf_dbg(ERROR, "error downloading vars: %d\n", ret);
+	} else {
+		brcmf_dbg(ERROR, "error reading nvram file: %d\n", len);
+		ret = -EIO;
+	}
+
+err:
+	kfree(memblock);
 
-	return true;
+	release_firmware(bus->firmware);
+	bus->fw_ptr = 0;
 
-fail:
-	return false;
+	return ret;
 }
 
-static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
+static int _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
 {
-	brcmf_dbg(TRACE, "Enter\n");
-
-	/* Disable F2 to clear any intermediate frame state on the dongle */
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
-			       SDIO_FUNC_ENABLE_1, NULL);
+	int bcmerror = -1;
 
-	bus->drvr->busstate = BRCMF_BUS_DOWN;
-	bus->sleeping = false;
-	bus->rxflow = false;
+	/* Keep arm in reset */
+	if (brcmf_sdbrcm_download_state(bus, true)) {
+		brcmf_dbg(ERROR, "error placing ARM core in reset\n");
+		goto err;
+	}
 
-	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
+	/* External image takes precedence if specified */
+	if (brcmf_sdbrcm_download_code_file(bus)) {
+		brcmf_dbg(ERROR, "dongle image file download failed\n");
+		goto err;
+	}
 
-	/* ...and initialize clock/power states */
-	bus->clkstate = CLK_SDONLY;
-	bus->idletime = (s32) brcmf_idletime;
-	bus->idleclock = BRCMF_IDLE_ACTIVE;
+	/* External nvram takes precedence if specified */
+	if (brcmf_sdbrcm_download_nvram(bus))
+		brcmf_dbg(ERROR, "dongle nvram file download failed\n");
 
-	/* Query the F2 block size, set roundup accordingly */
-	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
-	bus->roundup = min(max_roundup, bus->blocksize);
+	/* Take arm out of reset */
+	if (brcmf_sdbrcm_download_state(bus, false)) {
+		brcmf_dbg(ERROR, "error getting out of ARM core reset\n");
+		goto err;
+	}
 
-	/* bus module does not support packet chaining */
-	bus->use_rxchain = false;
-	bus->sd_rxchain = false;
+	bcmerror = 0;
 
-	return true;
+err:
+	return bcmerror;
 }
 
 static bool
@@ -4219,359 +3991,478 @@ brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
 	return ret;
 }
 
-/* Detach and free everything */
-static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
+void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 {
+	u32 local_hostintmask;
+	u8 saveclk;
+	uint retries;
+	int err;
+
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (bus) {
-		/* De-register interrupt handler */
-		brcmf_sdcard_intr_dereg(bus->sdiodev);
+	if (enforce_mutex)
+		brcmf_sdbrcm_sdlock(bus);
 
-		if (bus->drvr) {
-			brcmf_detach(bus->drvr);
-			brcmf_sdbrcm_release_dongle(bus);
-			bus->drvr = NULL;
-		}
+	bus_wake(bus);
 
-		brcmf_sdbrcm_release_malloc(bus);
+	/* Enable clock for device interrupts */
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
-		kfree(bus);
+	if (bus->watchdog_tsk) {
+		send_sig(SIGTERM, bus->watchdog_tsk, 1);
+		kthread_stop(bus->watchdog_tsk);
+		bus->watchdog_tsk = NULL;
 	}
 
-	brcmf_dbg(TRACE, "Disconnected\n");
-}
+	if (bus->dpc_tsk) {
+		send_sig(SIGTERM, bus->dpc_tsk, 1);
+		kthread_stop(bus->dpc_tsk);
+		bus->dpc_tsk = NULL;
+	} else
+		tasklet_kill(&bus->tasklet);
 
-static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus)
-{
-	brcmf_dbg(TRACE, "Enter\n");
+	/* Disable and clear interrupts at the chip level also */
+	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask), &retries);
+	local_hostintmask = bus->hostintmask;
+	bus->hostintmask = 0;
 
-	if (bus->drvr && bus->drvr->dongle_reset)
-		return;
+	/* Change our idea of bus state */
+	bus->drvr->busstate = BRCMF_BUS_DOWN;
 
-	kfree(bus->rxbuf);
-	bus->rxctl = bus->rxbuf = NULL;
+	/* Force clocks on backplane to be sure F2 interrupt propagates */
+	saveclk = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+					SBSDIO_FUNC1_CHIPCLKCSR, &err);
+	if (!err) {
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+				       SBSDIO_FUNC1_CHIPCLKCSR,
+				       (saveclk | SBSDIO_FORCE_HT), &err);
+	}
+	if (err)
+		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
+
+	/* Turn off the bus (F2), free any pending packets */
+	brcmf_dbg(INTR, "disable SDIO interrupts\n");
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+			 SDIO_FUNC_ENABLE_1, NULL);
+
+	/* Clear any pending interrupts now that F2 is disabled */
+	w_sdreg32(bus, local_hostintmask,
+		  offsetof(struct sdpcmd_regs, intstatus), &retries);
+
+	/* Turn off the backplane clock (only) */
+	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
+
+	/* Clear the data packet queues */
+	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
+
+	/* Clear any held glomming stuff */
+	if (bus->glomd)
+		brcmu_pkt_buf_free_skb(bus->glomd);
+
+	if (bus->glom)
+		brcmu_pkt_buf_free_skb(bus->glom);
+
+	bus->glom = bus->glomd = NULL;
+
+	/* Clear rx control and wake any waiters */
 	bus->rxlen = 0;
+	brcmf_sdbrcm_ioctl_resp_wake(bus);
 
-	kfree(bus->databuf);
-	bus->databuf = NULL;
+	/* Reset some F2 state stuff */
+	bus->rxskip = false;
+	bus->tx_seq = bus->rx_seq = 0;
+
+	if (enforce_mutex)
+		brcmf_sdbrcm_sdunlock(bus);
 }
 
-static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
+int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 {
-	brcmf_dbg(TRACE, "Enter\n");
+	struct brcmf_bus *bus = drvr->bus;
+	unsigned long timeout;
+	uint retries = 0;
+	u8 ready, enable;
+	int err, ret = 0;
+	u8 saveclk;
 
-	if (bus->drvr && bus->drvr->dongle_reset)
-		return;
+	brcmf_dbg(TRACE, "Enter\n");
 
-	if (bus->ci) {
-		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
-		brcmf_sdbrcm_chip_detach(bus);
-		if (bus->vars && bus->varsz)
-			kfree(bus->vars);
-		bus->vars = NULL;
+	/* try to download image and nvram to the dongle */
+	if (drvr->busstate == BRCMF_BUS_DOWN) {
+		if (!(brcmf_sdbrcm_download_firmware(bus)))
+			return -1;
 	}
 
-	brcmf_dbg(TRACE, "Disconnected\n");
-}
+	if (!bus->drvr)
+		return 0;
 
-void brcmf_sdbrcm_disconnect(void *ptr)
-{
-	struct brcmf_bus *bus = (struct brcmf_bus *)ptr;
+	/* Start the watchdog timer */
+	bus->drvr->tickcnt = 0;
+	brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
 
-	brcmf_dbg(TRACE, "Enter\n");
+	if (enforce_mutex)
+		brcmf_sdbrcm_sdlock(bus);
 
-	if (bus)
-		brcmf_sdbrcm_release(bus);
+	/* Make sure backplane clock is on, needed to generate F2 interrupt */
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+	if (bus->clkstate != CLK_AVAIL)
+		goto exit;
 
-	brcmf_dbg(TRACE, "Disconnected\n");
-}
+	/* Force clocks on backplane to be sure F2 interrupt propagates */
+	saveclk =
+	    brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+				  SBSDIO_FUNC1_CHIPCLKCSR, &err);
+	if (!err) {
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+				       SBSDIO_FUNC1_CHIPCLKCSR,
+				       (saveclk | SBSDIO_FORCE_HT), &err);
+	}
+	if (err) {
+		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
+		goto exit;
+	}
 
-int brcmf_bus_register(void)
-{
-	brcmf_dbg(TRACE, "Enter\n");
+	/* Enable function 2 (frame transfers) */
+	w_sdreg32(bus, SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT,
+		  offsetof(struct sdpcmd_regs, tosbmailboxdata), &retries);
+	enable = (SDIO_FUNC_ENABLE_1 | SDIO_FUNC_ENABLE_2);
 
-	/* Sanity check on the module parameters */
-	do {
-		/* Both watchdog and DPC as tasklets are ok */
-		if ((brcmf_watchdog_prio < 0) && (brcmf_dpc_prio < 0))
-			break;
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+			       enable, NULL);
 
-		/* If both watchdog and DPC are threads, TX must be deferred */
-		if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0)
-		    && brcmf_deferred_tx)
+	timeout = jiffies + msecs_to_jiffies(BRCMF_WAIT_F2RDY);
+	ready = 0;
+	while (enable != ready) {
+		ready = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_0,
+					      SDIO_CCCR_IORx, NULL);
+		if (time_after(jiffies, timeout))
 			break;
+		else if (time_after(jiffies, timeout - BRCMF_WAIT_F2RDY + 50))
+			/* prevent busy waiting if it takes too long */
+			msleep_interruptible(20);
+	}
 
-		brcmf_dbg(ERROR, "Invalid module parameters.\n");
-		return -EINVAL;
-	} while (0);
+	brcmf_dbg(INFO, "enable 0x%02x, ready 0x%02x\n", enable, ready);
+
+	/* If F2 successfully enabled, set core and enable interrupts */
+	if (ready == enable) {
+		/* Set up the interrupt mask and enable interrupts */
+		bus->hostintmask = HOSTINTMASK;
+		w_sdreg32(bus, bus->hostintmask,
+			  offsetof(struct sdpcmd_regs, hostintmask), &retries);
+
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+				       SBSDIO_WATERMARK, 8, &err);
+
+		/* Set bus state according to enable result */
+		drvr->busstate = BRCMF_BUS_DATA;
+	}
+
+	else {
+		/* Disable F2 again */
+		enable = SDIO_FUNC_ENABLE_1;
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0,
+				       SDIO_CCCR_IOEx, enable, NULL);
+	}
+
+	/* Restore previous clock setting */
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
 
-	return brcmf_sdio_register();
-}
+	/* If we didn't come up, turn off backplane clock */
+	if (drvr->busstate != BRCMF_BUS_DATA)
+		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 
-void brcmf_bus_unregister(void)
-{
-	brcmf_dbg(TRACE, "Enter\n");
+exit:
+	if (enforce_mutex)
+		brcmf_sdbrcm_sdunlock(bus);
 
-	brcmf_sdio_unregister();
+	return ret;
 }
 
-struct device *brcmf_bus_get_device(struct brcmf_bus *bus)
+void brcmf_sdbrcm_isr(void *arg)
 {
-	return &bus->sdiodev->func[2]->dev;
-}
+	struct brcmf_bus *bus = (struct brcmf_bus *) arg;
 
-static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
-{
-	int offset = 0;
-	uint len;
-	u8 *memblock = NULL, *memptr;
-	int ret;
+	brcmf_dbg(TRACE, "Enter\n");
 
-	brcmf_dbg(INFO, "Enter\n");
+	if (!bus) {
+		brcmf_dbg(ERROR, "bus is null pointer, exiting\n");
+		return;
+	}
 
-	bus->fw_name = BCM4329_FW_NAME;
-	ret = request_firmware(&bus->firmware, bus->fw_name,
-			       &bus->sdiodev->func[2]->dev);
-	if (ret) {
-		brcmf_dbg(ERROR, "Fail to request firmware %d\n", ret);
-		return ret;
+	if (bus->drvr->busstate == BRCMF_BUS_DOWN) {
+		brcmf_dbg(ERROR, "bus is down. we have nothing to do\n");
+		return;
 	}
-	bus->fw_ptr = 0;
+	/* Count the interrupt call */
+	bus->intrcount++;
+	bus->ipend = true;
 
-	memptr = memblock = kmalloc(MEMBLOCK + BRCMF_SDALIGN, GFP_ATOMIC);
-	if (memblock == NULL) {
-		brcmf_dbg(ERROR, "Failed to allocate memory %d bytes\n",
-			  MEMBLOCK);
-		ret = -ENOMEM;
-		goto err;
+	/* Shouldn't get this interrupt if we're sleeping? */
+	if (bus->sleeping) {
+		brcmf_dbg(ERROR, "INTERRUPT WHILE SLEEPING??\n");
+		return;
 	}
-	if ((u32)(unsigned long)memblock % BRCMF_SDALIGN)
-		memptr += (BRCMF_SDALIGN -
-			   ((u32)(unsigned long)memblock % BRCMF_SDALIGN));
 
-	/* Download image */
-	while ((len =
-		brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus))) {
-		ret = brcmf_sdbrcm_membytes(bus, true, offset, memptr, len);
-		if (ret) {
-			brcmf_dbg(ERROR, "error %d on writing %d membytes at 0x%08x\n",
-				  ret, MEMBLOCK, offset);
-			goto err;
-		}
+	/* Disable additional interrupts (is this needed now)? */
+	if (!bus->intr)
+		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
 
-		offset += MEMBLOCK;
-	}
+	bus->dpc_sched = true;
+	brcmf_sdbrcm_sched_dpc(bus);
+}
 
-err:
-	kfree(memblock);
+static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
+{
+	struct brcmf_bus *bus;
 
-	release_firmware(bus->firmware);
-	bus->fw_ptr = 0;
+	brcmf_dbg(TIMER, "Enter\n");
 
-	return ret;
-}
+	bus = drvr->bus;
 
-/*
- * ProcessVars:Takes a buffer of "<var>=<value>\n" lines read from a file
- * and ending in a NUL.
- * Removes carriage returns, empty lines, comment lines, and converts
- * newlines to NULs.
- * Shortens buffer as needed and pads with NULs.  End of buffer is marked
- * by two NULs.
-*/
+	if (bus->drvr->dongle_reset)
+		return false;
 
-static uint brcmf_process_nvram_vars(char *varbuf, uint len)
-{
-	char *dp;
-	bool findNewline;
-	int column;
-	uint buf_len, n;
+	/* Ignore the timer if simulating bus down */
+	if (bus->sleeping)
+		return false;
 
-	dp = varbuf;
+	brcmf_sdbrcm_sdlock(bus);
 
-	findNewline = false;
-	column = 0;
+	/* Poll period: check device if appropriate. */
+	if (bus->poll && (++bus->polltick >= bus->pollrate)) {
+		u32 intstatus = 0;
 
-	for (n = 0; n < len; n++) {
-		if (varbuf[n] == 0)
-			break;
-		if (varbuf[n] == '\r')
-			continue;
-		if (findNewline && varbuf[n] != '\n')
-			continue;
-		findNewline = false;
-		if (varbuf[n] == '#') {
-			findNewline = true;
-			continue;
-		}
-		if (varbuf[n] == '\n') {
-			if (column == 0)
-				continue;
-			*dp++ = 0;
-			column = 0;
-			continue;
-		}
-		*dp++ = varbuf[n];
-		column++;
-	}
-	buf_len = dp - varbuf;
+		/* Reset poll tick */
+		bus->polltick = 0;
 
-	while (dp < varbuf + n)
-		*dp++ = 0;
+		/* Check device if no interrupts */
+		if (!bus->intr || (bus->intrcount == bus->lastintrs)) {
 
-	return buf_len;
-}
+			if (!bus->dpc_sched) {
+				u8 devpend;
+				devpend = brcmf_sdcard_cfg_read(bus->sdiodev,
+						SDIO_FUNC_0, SDIO_CCCR_INTx,
+						NULL);
+				intstatus =
+				    devpend & (INTR_STATUS_FUNC1 |
+					       INTR_STATUS_FUNC2);
+			}
 
-static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
-{
-	uint len;
-	char *memblock = NULL;
-	char *bufp;
-	int ret;
+			/* If there is something, make like the ISR and
+				 schedule the DPC */
+			if (intstatus) {
+				bus->pollcnt++;
+				bus->ipend = true;
 
-	bus->nv_name = BCM4329_NV_NAME;
-	ret = request_firmware(&bus->firmware, bus->nv_name,
-			       &bus->sdiodev->func[2]->dev);
-	if (ret) {
-		brcmf_dbg(ERROR, "Fail to request nvram %d\n", ret);
-		return ret;
-	}
-	bus->fw_ptr = 0;
+				bus->dpc_sched = true;
+				brcmf_sdbrcm_sched_dpc(bus);
 
-	memblock = kmalloc(MEMBLOCK, GFP_ATOMIC);
-	if (memblock == NULL) {
-		brcmf_dbg(ERROR, "Failed to allocate memory %d bytes\n",
-			  MEMBLOCK);
-		ret = -ENOMEM;
-		goto err;
-	}
+			}
+		}
 
-	len = brcmf_sdbrcm_get_image(memblock, MEMBLOCK, bus);
+		/* Update interrupt tracking */
+		bus->lastintrs = bus->intrcount;
+	}
+#ifdef BCMDBG
+	/* Poll for console output periodically */
+	if (drvr->busstate == BRCMF_BUS_DATA && brcmf_console_ms != 0) {
+		bus->console.count += brcmf_watchdog_ms;
+		if (bus->console.count >= brcmf_console_ms) {
+			bus->console.count -= brcmf_console_ms;
+			/* Make sure backplane clock is on */
+			brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+			if (brcmf_sdbrcm_readconsole(bus) < 0)
+				brcmf_console_ms = 0;	/* On error,
+							 stop trying */
+		}
+	}
+#endif				/* BCMDBG */
 
-	if (len > 0 && len < MEMBLOCK) {
-		bufp = (char *)memblock;
-		bufp[len] = 0;
-		len = brcmf_process_nvram_vars(bufp, len);
-		bufp += len;
-		*bufp++ = 0;
-		if (len)
-			ret = brcmf_sdbrcm_downloadvars(bus, memblock, len + 1);
-		if (ret)
-			brcmf_dbg(ERROR, "error downloading vars: %d\n", ret);
-	} else {
-		brcmf_dbg(ERROR, "error reading nvram file: %d\n", len);
-		ret = -EIO;
+	/* On idle timeout clear activity flag and/or turn off clock */
+	if ((bus->idletime > 0) && (bus->clkstate == CLK_AVAIL)) {
+		if (++bus->idlecount >= bus->idletime) {
+			bus->idlecount = 0;
+			if (bus->activity) {
+				bus->activity = false;
+				brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
+			} else {
+				brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+			}
+		}
 	}
 
-err:
-	kfree(memblock);
+	brcmf_sdbrcm_sdunlock(bus);
 
-	release_firmware(bus->firmware);
-	bus->fw_ptr = 0;
+	return bus->ipend;
+}
 
-	return ret;
+static bool brcmf_sdbrcm_chipmatch(u16 chipid)
+{
+	if (chipid == BCM4329_CHIP_ID)
+		return true;
+	return false;
 }
 
-static int _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
+static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus)
 {
-	int bcmerror = -1;
+	brcmf_dbg(TRACE, "Enter\n");
 
-	/* Keep arm in reset */
-	if (brcmf_sdbrcm_download_state(bus, true)) {
-		brcmf_dbg(ERROR, "error placing ARM core in reset\n");
-		goto err;
-	}
+	if (bus->drvr && bus->drvr->dongle_reset)
+		return;
 
-	/* External image takes precedence if specified */
-	if (brcmf_sdbrcm_download_code_file(bus)) {
-		brcmf_dbg(ERROR, "dongle image file download failed\n");
-		goto err;
-	}
+	kfree(bus->rxbuf);
+	bus->rxctl = bus->rxbuf = NULL;
+	bus->rxlen = 0;
 
-	/* External nvram takes precedence if specified */
-	if (brcmf_sdbrcm_download_nvram(bus))
-		brcmf_dbg(ERROR, "dongle nvram file download failed\n");
+	kfree(bus->databuf);
+	bus->databuf = NULL;
+}
 
-	/* Take arm out of reset */
-	if (brcmf_sdbrcm_download_state(bus, false)) {
-		brcmf_dbg(ERROR, "error getting out of ARM core reset\n");
-		goto err;
+static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus)
+{
+	brcmf_dbg(TRACE, "Enter\n");
+
+	if (bus->drvr->maxctl) {
+		bus->rxblen =
+		    roundup((bus->drvr->maxctl + SDPCM_HDRLEN),
+			    ALIGNMENT) + BRCMF_SDALIGN;
+		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
+		if (!(bus->rxbuf)) {
+			brcmf_dbg(ERROR, "kmalloc of %d-byte rxbuf failed\n",
+				  bus->rxblen);
+			goto fail;
+		}
 	}
 
-	bcmerror = 0;
+	/* Allocate buffer to receive glomed packet */
+	bus->databuf = kmalloc(MAX_DATA_BUF, GFP_ATOMIC);
+	if (!(bus->databuf)) {
+		brcmf_dbg(ERROR, "kmalloc of %d-byte databuf failed\n",
+			  MAX_DATA_BUF);
+		/* release rxbuf which was already located as above */
+		if (!bus->rxblen)
+			kfree(bus->rxbuf);
+		goto fail;
+	}
 
-err:
-	return bcmerror;
-}
+	/* Align the buffer */
+	if ((unsigned long)bus->databuf % BRCMF_SDALIGN)
+		bus->dataptr = bus->databuf + (BRCMF_SDALIGN -
+			       ((unsigned long)bus->databuf % BRCMF_SDALIGN));
+	else
+		bus->dataptr = bus->databuf;
 
+	return true;
 
-static int
-brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn, uint flags,
-		    u8 *buf, uint nbytes, struct sk_buff *pkt)
-{
-	return brcmf_sdcard_send_buf
-		(bus->sdiodev, addr, fn, flags, buf, nbytes, pkt);
+fail:
+	return false;
 }
 
-int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
-{
-	int bcmerror = 0;
-	struct brcmf_bus *bus;
-
-	bus = drvr->bus;
+/* SDIO Pad drive strength to select value mappings */
+struct sdiod_drive_str {
+	u8 strength;	/* Pad Drive Strength in mA */
+	u8 sel;		/* Chip-specific select value */
+};
 
-	if (flag == true) {
-		brcmf_sdbrcm_wd_timer(bus, 0);
-		if (!bus->drvr->dongle_reset) {
-			/* Expect app to have torn down any
-			 connection before calling */
-			/* Stop the bus, disable F2 */
-			brcmf_sdbrcm_bus_stop(bus, false);
+/* SDIO Drive Strength to sel value table for PMU Rev 1 */
+static const struct sdiod_drive_str sdiod_drive_strength_tab1[] = {
+	{
+	4, 0x2}, {
+	2, 0x3}, {
+	1, 0x0}, {
+	0, 0x0}
+	};
 
-			/* Clean tx/rx buffer pointers,
-			 detach from the dongle */
-			brcmf_sdbrcm_release_dongle(bus);
+/* SDIO Drive Strength to sel value table for PMU Rev 2, 3 */
+static const struct sdiod_drive_str sdiod_drive_strength_tab2[] = {
+	{
+	12, 0x7}, {
+	10, 0x6}, {
+	8, 0x5}, {
+	6, 0x4}, {
+	4, 0x2}, {
+	2, 0x1}, {
+	0, 0x0}
+	};
 
-			bus->drvr->dongle_reset = true;
-			bus->drvr->up = false;
+/* SDIO Drive Strength to sel value table for PMU Rev 8 (1.8V) */
+static const struct sdiod_drive_str sdiod_drive_strength_tab3[] = {
+	{
+	32, 0x7}, {
+	26, 0x6}, {
+	22, 0x5}, {
+	16, 0x4}, {
+	12, 0x3}, {
+	8, 0x2}, {
+	4, 0x1}, {
+	0, 0x0}
+	};
 
-			brcmf_dbg(TRACE, "WLAN OFF DONE\n");
-			/* App can now remove power from device */
-		} else
-			bcmerror = -EIO;
-	} else {
-		/* App must have restored power to device before calling */
+#define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
 
-		brcmf_dbg(TRACE, " == WLAN ON ==\n");
+static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
+						   u32 drivestrength) {
+	struct sdiod_drive_str *str_tab = NULL;
+	u32 str_mask = 0;
+	u32 str_shift = 0;
+	char chn[8];
 
-		if (bus->drvr->dongle_reset) {
-			/* Turn on WLAN */
+	if (!(bus->ci->cccaps & CC_CAP_PMU))
+		return;
 
-			/* Attempt to re-attach & download */
-			if (brcmf_sdbrcm_probe_attach(bus, SI_ENUM_BASE)) {
-				/* Attempt to download binary to the dongle */
-				if (brcmf_sdbrcm_probe_init(bus)) {
-					/* Re-init bus, enable F2 transfer */
-					brcmf_sdbrcm_bus_init(bus->drvr, false);
+	switch (SDIOD_DRVSTR_KEY(bus->ci->chip, bus->ci->pmurev)) {
+	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 1):
+		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab1;
+		str_mask = 0x30000000;
+		str_shift = 28;
+		break;
+	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 2):
+	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 3):
+		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab2;
+		str_mask = 0x00003800;
+		str_shift = 11;
+		break;
+	case SDIOD_DRVSTR_KEY(BCM4336_CHIP_ID, 8):
+		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab3;
+		str_mask = 0x00003800;
+		str_shift = 11;
+		break;
+	default:
+		brcmf_dbg(ERROR, "No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
+			  brcmu_chipname(bus->ci->chip, chn, 8),
+			  bus->ci->chiprev, bus->ci->pmurev);
+		break;
+	}
 
-					bus->drvr->dongle_reset = false;
-					bus->drvr->up = true;
+	if (str_tab != NULL) {
+		u32 drivestrength_sel = 0;
+		u32 cc_data_temp;
+		int i;
 
-					brcmf_dbg(TRACE, "WLAN ON DONE\n");
-				} else
-					bcmerror = -EIO;
-			} else
-				bcmerror = -EIO;
-		} else {
-			bcmerror = -EISCONN;
-			brcmf_dbg(ERROR, "Set DEVRESET=false invoked when device is on\n");
-			bcmerror = -EIO;
+		for (i = 0; str_tab[i].strength != 0; i++) {
+			if (drivestrength >= str_tab[i].strength) {
+				drivestrength_sel = str_tab[i].sel;
+				break;
+			}
 		}
-		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
+
+		brcmf_sdcard_reg_write(bus->sdiodev,
+			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
+			4, 1);
+		cc_data_temp = brcmf_sdcard_reg_read(bus->sdiodev,
+			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr), 4);
+		cc_data_temp &= ~str_mask;
+		drivestrength_sel <<= str_shift;
+		cc_data_temp |= drivestrength_sel;
+		brcmf_sdcard_reg_write(bus->sdiodev,
+			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
+			4, cc_data_temp);
+
+		brcmf_dbg(INFO, "SDIO: %dmA drive strength selected, set to 0x%08x\n",
+			  drivestrength, cc_data_temp);
 	}
-	return bcmerror;
 }
 
 static int
@@ -4615,98 +4506,19 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		CORE_CC_REG(ci->cccorebase, pmucapabilities), 4);
 	ci->pmurev = regdata & PCAP_REV_MASK;
 
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					CORE_SB(ci->buscorebase, sbidhigh), 4);
-	ci->buscorerev = SBCOREREV(regdata);
-	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
-
-	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
-		  ci->ccrev, ci->pmurev, ci->buscorerev, ci->buscoretype);
-
-	/* get chipcommon capabilites */
-	ci->cccaps = brcmf_sdcard_reg_read(sdiodev,
-		CORE_CC_REG(ci->cccorebase, capabilities), 4);
-
-	return 0;
-}
-
-static void
-brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
-{
-	u32 regdata;
-
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_SB(corebase, sbtmstatelow), 4);
-	if (regdata & SBTML_RESET)
-		return;
-
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_SB(corebase, sbtmstatelow), 4);
-	if ((regdata & (SICF_CLOCK_EN << SBTML_SICF_SHIFT)) != 0) {
-		/*
-		 * set target reject and spin until busy is clear
-		 * (preserve core-specific bits)
-		 */
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4);
-		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow),
-				       4, regdata | SBTML_REJ);
-
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4);
-		udelay(1);
-		SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatehigh), 4) &
-			SBTMH_BUSY), 100000);
-
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatehigh), 4);
-		if (regdata & SBTMH_BUSY)
-			brcmf_dbg(ERROR, "ARM core still busy\n");
-
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbidlow), 4);
-		if (regdata & SBIDL_INIT) {
-			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4) |
-				SBIM_RJ;
-			brcmf_sdcard_reg_write(sdiodev,
-				CORE_SB(corebase, sbimstate), 4,
-				regdata);
-			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4);
-			udelay(1);
-			SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4) &
-				SBIM_BY), 100000);
-		}
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					CORE_SB(ci->buscorebase, sbidhigh), 4);
+	ci->buscorerev = SBCOREREV(regdata);
+	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
 
-		/* set reset and reject while enabling the clocks */
-		brcmf_sdcard_reg_write(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4,
-			(((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
-			SBTML_REJ | SBTML_RESET));
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4);
-		udelay(10);
+	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
+		  ci->ccrev, ci->pmurev, ci->buscorerev, ci->buscoretype);
 
-		/* clear the initiator reject bit */
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbidlow), 4);
-		if (regdata & SBIDL_INIT) {
-			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4) &
-				~SBIM_RJ;
-			brcmf_sdcard_reg_write(sdiodev,
-				CORE_SB(corebase, sbimstate), 4,
-				regdata);
-		}
-	}
+	/* get chipcommon capabilites */
+	ci->cccaps = brcmf_sdcard_reg_read(sdiodev,
+		CORE_CC_REG(ci->cccorebase, capabilities), 4);
 
-	/* leave reset and reject asserted */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		(SBTML_REJ | SBTML_RESET));
-	udelay(1);
+	return 0;
 }
 
 static int
@@ -4804,234 +4616,483 @@ fail:
 	return err;
 }
 
-static void
-brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
+static bool
+brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
+{
+	u8 clkctl = 0;
+	int err = 0;
+	int reg_addr;
+	u32 reg_val;
+
+	bus->alp_only = true;
+
+	/* Return the window to backplane enumeration space for core access */
+	if (brcmf_sdcard_set_sbaddr_window(bus->sdiodev, SI_ENUM_BASE))
+		brcmf_dbg(ERROR, "FAILED to return to SI_ENUM_BASE\n");
+
+#ifdef BCMDBG
+	printk(KERN_DEBUG "F1 signature read @0x18000000=0x%4x\n",
+	       brcmf_sdcard_reg_read(bus->sdiodev, SI_ENUM_BASE, 4));
+
+#endif				/* BCMDBG */
+
+	/*
+	 * Force PLL off until brcmf_sdbrcm_chip_attach()
+	 * programs PLL control regs
+	 */
+
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_CHIPCLKCSR,
+			       BRCMF_INIT_CLKCTL1, &err);
+	if (!err)
+		clkctl =
+		    brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
+
+	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
+		brcmf_dbg(ERROR, "ChipClkCSR access: err %d wrote 0x%02x read 0x%02x\n",
+			  err, BRCMF_INIT_CLKCTL1, clkctl);
+		goto fail;
+	}
+
+	if (brcmf_sdbrcm_chip_attach(bus, regsva)) {
+		brcmf_dbg(ERROR, "brcmf_sdbrcm_chip_attach failed!\n");
+		goto fail;
+	}
+
+	if (!brcmf_sdbrcm_chipmatch((u16) bus->ci->chip)) {
+		brcmf_dbg(ERROR, "unsupported chip: 0x%04x\n", bus->ci->chip);
+		goto fail;
+	}
+
+	brcmf_sdbrcm_sdiod_drive_strength_init(bus, brcmf_sdiod_drive_strength);
+
+	/* Get info on the ARM and SOCRAM cores... */
+	brcmf_sdcard_reg_read(bus->sdiodev,
+		  CORE_SB(bus->ci->armcorebase, sbidhigh), 4);
+	bus->orig_ramsize = bus->ci->ramsize;
+	if (!(bus->orig_ramsize)) {
+		brcmf_dbg(ERROR, "failed to find SOCRAM memory!\n");
+		goto fail;
+	}
+	bus->ramsize = bus->orig_ramsize;
+	if (brcmf_dongle_memsize)
+		brcmf_sdbrcm_setmemsize(bus, brcmf_dongle_memsize);
+
+	brcmf_dbg(ERROR, "DHD: dongle ram size is set to %d(orig %d)\n",
+		  bus->ramsize, bus->orig_ramsize);
+
+	/* Set core control so an SDIO reset does a backplane reset */
+	reg_addr = bus->ci->buscorebase +
+		   offsetof(struct sdpcmd_regs, corecontrol);
+	reg_val = brcmf_sdcard_reg_read(bus->sdiodev, reg_addr, sizeof(u32));
+	brcmf_sdcard_reg_write(bus->sdiodev, reg_addr, sizeof(u32),
+			       reg_val | CC_BPRESEN);
+
+	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
+
+	/* Locate an appropriately-aligned portion of hdrbuf */
+	bus->rxhdr = (u8 *) roundup((unsigned long)&bus->hdrbuf[0],
+				    BRCMF_SDALIGN);
+
+	/* Set the poll and/or interrupt flags */
+	bus->intr = (bool) brcmf_intr;
+	bus->poll = (bool) brcmf_poll;
+	if (bus->poll)
+		bus->pollrate = 1;
+
+	return true;
+
+fail:
+	return false;
+}
+
+static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
+{
+	brcmf_dbg(TRACE, "Enter\n");
+
+	/* Disable F2 to clear any intermediate frame state on the dongle */
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+			       SDIO_FUNC_ENABLE_1, NULL);
+
+	bus->drvr->busstate = BRCMF_BUS_DOWN;
+	bus->sleeping = false;
+	bus->rxflow = false;
+
+	/* Done with backplane-dependent accesses, can drop clock... */
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			       SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
+
+	/* ...and initialize clock/power states */
+	bus->clkstate = CLK_SDONLY;
+	bus->idletime = (s32) brcmf_idletime;
+	bus->idleclock = BRCMF_IDLE_ACTIVE;
+
+	/* Query the F2 block size, set roundup accordingly */
+	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
+	bus->roundup = min(max_roundup, bus->blocksize);
+
+	/* bus module does not support packet chaining */
+	bus->use_rxchain = false;
+	bus->sd_rxchain = false;
+
+	return true;
+}
+
+static int
+brcmf_sdbrcm_watchdog_thread(void *data)
+{
+	struct brcmf_bus *bus = (struct brcmf_bus *)data;
+
+	/* This thread doesn't need any user-level access,
+	* so get rid of all our resources
+	*/
+	if (brcmf_watchdog_prio > 0) {
+		struct sched_param param;
+		param.sched_priority = (brcmf_watchdog_prio < MAX_RT_PRIO) ?
+				       brcmf_watchdog_prio : (MAX_RT_PRIO - 1);
+		sched_setscheduler(current, SCHED_FIFO, &param);
+	}
+
+	allow_signal(SIGTERM);
+	/* Run until signal received */
+	while (1) {
+		if (kthread_should_stop())
+			break;
+		if (!wait_for_completion_interruptible(&bus->watchdog_wait)) {
+			if (bus->drvr->dongle_reset == false)
+				brcmf_sdbrcm_bus_watchdog(bus->drvr);
+			/* Count the tick for reference */
+			bus->drvr->tickcnt++;
+		} else
+			break;
+	}
+	return 0;
+}
+
+static void
+brcmf_sdbrcm_watchdog(unsigned long data)
+{
+	struct brcmf_bus *bus = (struct brcmf_bus *)data;
+
+	if (brcmf_watchdog_prio >= 0) {
+		if (bus->watchdog_tsk)
+			complete(&bus->watchdog_wait);
+		else
+			return;
+	} else {
+		brcmf_sdbrcm_bus_watchdog(bus->drvr);
+
+		/* Count the tick for reference */
+		bus->drvr->tickcnt++;
+	}
+
+	/* Reschedule the watchdog */
+	if (bus->wd_timer_valid)
+		mod_timer(&bus->timer, jiffies + brcmf_watchdog_ms * HZ / 1000);
+}
+
+static void
+brcmf_sdbrcm_chip_detach(struct brcmf_bus *bus)
+{
+	brcmf_dbg(TRACE, "Enter\n");
+
+	kfree(bus->ci);
+	bus->ci = NULL;
+}
+
+static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
+{
+	brcmf_dbg(TRACE, "Enter\n");
+
+	if (bus->drvr && bus->drvr->dongle_reset)
+		return;
+
+	if (bus->ci) {
+		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+		brcmf_sdbrcm_chip_detach(bus);
+		if (bus->vars && bus->varsz)
+			kfree(bus->vars);
+		bus->vars = NULL;
+	}
+
+	brcmf_dbg(TRACE, "Disconnected\n");
+}
+
+/* Detach and free everything */
+static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
+{
+	brcmf_dbg(TRACE, "Enter\n");
+
+	if (bus) {
+		/* De-register interrupt handler */
+		brcmf_sdcard_intr_dereg(bus->sdiodev);
+
+		if (bus->drvr) {
+			brcmf_detach(bus->drvr);
+			brcmf_sdbrcm_release_dongle(bus);
+			bus->drvr = NULL;
+		}
+
+		brcmf_sdbrcm_release_malloc(bus);
+
+		kfree(bus);
+	}
+
+	brcmf_dbg(TRACE, "Disconnected\n");
+}
+
+void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
+			 u32 regsva, struct brcmf_sdio_dev *sdiodev)
 {
-	u32 regdata;
+	int ret;
+	struct brcmf_bus *bus;
 
-	/*
-	 * Must do the disable sequence first to work for
-	 * arbitrary current core state.
+	/* Init global variables at run-time, not as part of the declaration.
+	 * This is required to support init/de-init of the driver.
+	 * Initialization
+	 * of globals as part of the declaration results in non-deterministic
+	 * behavior since the value of the globals may be different on the
+	 * first time that the driver is initialized vs subsequent
+	 * initializations.
 	 */
-	brcmf_sdbrcm_chip_disablecore(sdiodev, corebase);
+	brcmf_txbound = BRCMF_TXBOUND;
+	brcmf_rxbound = BRCMF_RXBOUND;
+	brcmf_alignctl = true;
+	brcmf_readahead = true;
+	retrydata = false;
+	brcmf_dongle_memsize = 0;
+	brcmf_txminmax = BRCMF_TXMINMAX;
 
-	/*
-	 * Now do the initialization sequence.
-	 * set reset while enabling the clock and
-	 * forcing them on throughout the core
-	 */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
-		SBTML_RESET);
-	udelay(1);
+	forcealign = true;
 
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					CORE_SB(corebase, sbtmstatehigh), 4);
-	if (regdata & SBTMH_SERR)
-		brcmf_sdcard_reg_write(sdiodev,
-				       CORE_SB(corebase, sbtmstatehigh), 4, 0);
+	brcmf_c_init();
 
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					CORE_SB(corebase, sbimstate), 4);
-	if (regdata & (SBIM_IBE | SBIM_TO))
-		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbimstate), 4,
-			regdata & ~(SBIM_IBE | SBIM_TO));
+	brcmf_dbg(TRACE, "Enter\n");
 
-	/* clear reset and allow it to propagate throughout the core */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		(SICF_FGC << SBTML_SICF_SHIFT) |
-		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
-	udelay(1);
+	/* We make an assumption about address window mappings:
+	 * regsva == SI_ENUM_BASE*/
 
-	/* leave clock enabled */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
-	udelay(1);
-}
+	/* Allocate private bus interface state */
+	bus = kzalloc(sizeof(struct brcmf_bus), GFP_ATOMIC);
+	if (!bus) {
+		brcmf_dbg(ERROR, "kmalloc of struct dhd_bus failed\n");
+		goto fail;
+	}
+	bus->sdiodev = sdiodev;
+	sdiodev->bus = bus;
+	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
+	bus->usebufpool = false;	/* Use bufpool if allocated,
+					 else use locally malloced rxbuf */
 
-/* SDIO Pad drive strength to select value mappings */
-struct sdiod_drive_str {
-	u8 strength;	/* Pad Drive Strength in mA */
-	u8 sel;		/* Chip-specific select value */
-};
+	/* attempt to attach to the dongle */
+	if (!(brcmf_sdbrcm_probe_attach(bus, regsva))) {
+		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_attach failed\n");
+		goto fail;
+	}
 
-/* SDIO Drive Strength to sel value table for PMU Rev 1 */
-static const struct sdiod_drive_str sdiod_drive_strength_tab1[] = {
-	{
-	4, 0x2}, {
-	2, 0x3}, {
-	1, 0x0}, {
-	0, 0x0}
-	};
+	spin_lock_init(&bus->txqlock);
+	init_waitqueue_head(&bus->ctrl_wait);
+	init_waitqueue_head(&bus->ioctl_resp_wait);
 
-/* SDIO Drive Strength to sel value table for PMU Rev 2, 3 */
-static const struct sdiod_drive_str sdiod_drive_strength_tab2[] = {
-	{
-	12, 0x7}, {
-	10, 0x6}, {
-	8, 0x5}, {
-	6, 0x4}, {
-	4, 0x2}, {
-	2, 0x1}, {
-	0, 0x0}
-	};
+	/* Set up the watchdog timer */
+	init_timer(&bus->timer);
+	bus->timer.data = (unsigned long)bus;
+	bus->timer.function = brcmf_sdbrcm_watchdog;
 
-/* SDIO Drive Strength to sel value table for PMU Rev 8 (1.8V) */
-static const struct sdiod_drive_str sdiod_drive_strength_tab3[] = {
-	{
-	32, 0x7}, {
-	26, 0x6}, {
-	22, 0x5}, {
-	16, 0x4}, {
-	12, 0x3}, {
-	8, 0x2}, {
-	4, 0x1}, {
-	0, 0x0}
-	};
+	/* Initialize thread based operation and lock */
+	if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0)) {
+		bus->threads_only = true;
+		sema_init(&bus->sdsem, 1);
+	} else {
+		bus->threads_only = false;
+		spin_lock_init(&bus->sdlock);
+	}
 
-#define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
+	if (brcmf_dpc_prio >= 0) {
+		/* Initialize watchdog thread */
+		init_completion(&bus->watchdog_wait);
+		bus->watchdog_tsk = kthread_run(brcmf_sdbrcm_watchdog_thread,
+						bus, "brcmf_watchdog");
+		if (IS_ERR(bus->watchdog_tsk)) {
+			printk(KERN_WARNING
+			       "brcmf_watchdog thread failed to start\n");
+			bus->watchdog_tsk = NULL;
+		}
+	} else
+		bus->watchdog_tsk = NULL;
 
-static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
-						   u32 drivestrength) {
-	struct sdiod_drive_str *str_tab = NULL;
-	u32 str_mask = 0;
-	u32 str_shift = 0;
-	char chn[8];
+	/* Set up the bottom half handler */
+	if (brcmf_dpc_prio >= 0) {
+		/* Initialize DPC thread */
+		init_completion(&bus->dpc_wait);
+		bus->dpc_tsk = kthread_run(brcmf_sdbrcm_dpc_thread,
+					   bus, "brcmf_dpc");
+		if (IS_ERR(bus->dpc_tsk)) {
+			printk(KERN_WARNING
+			       "brcmf_dpc thread failed to start\n");
+			bus->dpc_tsk = NULL;
+		}
+	} else {
+		tasklet_init(&bus->tasklet, brcmf_sdbrcm_dpc_tasklet,
+			     (unsigned long)bus);
+		bus->dpc_tsk = NULL;
+	}
 
-	if (!(bus->ci->cccaps & CC_CAP_PMU))
-		return;
+	/* Attach to the brcmf/OS/network interface */
+	bus->drvr = brcmf_attach(bus, SDPCM_RESERVE);
+	if (!bus->drvr) {
+		brcmf_dbg(ERROR, "brcmf_attach failed\n");
+		goto fail;
+	}
 
-	switch (SDIOD_DRVSTR_KEY(bus->ci->chip, bus->ci->pmurev)) {
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 1):
-		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab1;
-		str_mask = 0x30000000;
-		str_shift = 28;
-		break;
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 2):
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 3):
-		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab2;
-		str_mask = 0x00003800;
-		str_shift = 11;
-		break;
-	case SDIOD_DRVSTR_KEY(BCM4336_CHIP_ID, 8):
-		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab3;
-		str_mask = 0x00003800;
-		str_shift = 11;
-		break;
-	default:
-		brcmf_dbg(ERROR, "No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
-			  brcmu_chipname(bus->ci->chip, chn, 8),
-			  bus->ci->chiprev, bus->ci->pmurev);
-		break;
+	/* Allocate buffers */
+	if (!(brcmf_sdbrcm_probe_malloc(bus))) {
+		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_malloc failed\n");
+		goto fail;
 	}
 
-	if (str_tab != NULL) {
-		u32 drivestrength_sel = 0;
-		u32 cc_data_temp;
-		int i;
+	if (!(brcmf_sdbrcm_probe_init(bus))) {
+		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_init failed\n");
+		goto fail;
+	}
 
-		for (i = 0; str_tab[i].strength != 0; i++) {
-			if (drivestrength >= str_tab[i].strength) {
-				drivestrength_sel = str_tab[i].sel;
-				break;
-			}
+	/* Register interrupt callback, but mask it (not operational yet). */
+	brcmf_dbg(INTR, "disable SDIO interrupts (not interested yet)\n");
+	ret = brcmf_sdcard_intr_reg(bus->sdiodev);
+	if (ret != 0) {
+		brcmf_dbg(ERROR, "FAILED: sdcard_intr_reg returned %d\n", ret);
+		goto fail;
+	}
+	brcmf_dbg(INTR, "registered SDIO interrupt function ok\n");
+
+	brcmf_dbg(INFO, "completed!!\n");
+
+	/* if firmware path present try to download and bring up bus */
+	ret = brcmf_bus_start(bus->drvr);
+	if (ret != 0) {
+		if (ret == -ENOLINK) {
+			brcmf_dbg(ERROR, "dongle is not responding\n");
+			goto fail;
 		}
+	}
+	/* Ok, have the per-port tell the stack we're open for business */
+	if (brcmf_net_attach(bus->drvr, 0) != 0) {
+		brcmf_dbg(ERROR, "Net attach failed!!\n");
+		goto fail;
+	}
 
-		brcmf_sdcard_reg_write(bus->sdiodev,
-			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
-			4, 1);
-		cc_data_temp = brcmf_sdcard_reg_read(bus->sdiodev,
-			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr), 4);
-		cc_data_temp &= ~str_mask;
-		drivestrength_sel <<= str_shift;
-		cc_data_temp |= drivestrength_sel;
-		brcmf_sdcard_reg_write(bus->sdiodev,
-			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
-			4, cc_data_temp);
+	return bus;
+
+fail:
+	brcmf_sdbrcm_release(bus);
+	return NULL;
+}
+
+void brcmf_sdbrcm_disconnect(void *ptr)
+{
+	struct brcmf_bus *bus = (struct brcmf_bus *)ptr;
 
-		brcmf_dbg(INFO, "SDIO: %dmA drive strength selected, set to 0x%08x\n",
-			  drivestrength, cc_data_temp);
-	}
+	brcmf_dbg(TRACE, "Enter\n");
+
+	if (bus)
+		brcmf_sdbrcm_release(bus);
+
+	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
-static void
-brcmf_sdbrcm_chip_detach(struct brcmf_bus *bus)
+int brcmf_bus_register(void)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
-	kfree(bus->ci);
-	bus->ci = NULL;
+	/* Sanity check on the module parameters */
+	do {
+		/* Both watchdog and DPC as tasklets are ok */
+		if ((brcmf_watchdog_prio < 0) && (brcmf_dpc_prio < 0))
+			break;
+
+		/* If both watchdog and DPC are threads, TX must be deferred */
+		if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0)
+		    && brcmf_deferred_tx)
+			break;
+
+		brcmf_dbg(ERROR, "Invalid module parameters.\n");
+		return -EINVAL;
+	} while (0);
+
+	return brcmf_sdio_register();
 }
 
-static void
-brcmf_sdbrcm_wait_for_event(struct brcmf_bus *bus, bool *lockvar)
+void brcmf_bus_unregister(void)
 {
-	brcmf_sdbrcm_sdunlock(bus);
-	wait_event_interruptible_timeout(bus->ctrl_wait,
-					 (*lockvar == false), HZ * 2);
-	brcmf_sdbrcm_sdlock(bus);
-	return;
+	brcmf_dbg(TRACE, "Enter\n");
+
+	brcmf_sdio_unregister();
 }
 
-static void
-brcmf_sdbrcm_wait_event_wakeup(struct brcmf_bus *bus)
+struct device *brcmf_bus_get_device(struct brcmf_bus *bus)
 {
-	if (waitqueue_active(&bus->ctrl_wait))
-		wake_up_interruptible(&bus->ctrl_wait);
-	return;
+	return &bus->sdiodev->func[2]->dev;
 }
 
-static int
-brcmf_sdbrcm_watchdog_thread(void *data)
+int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 {
-	struct brcmf_bus *bus = (struct brcmf_bus *)data;
+	int bcmerror = 0;
+	struct brcmf_bus *bus;
 
-	/* This thread doesn't need any user-level access,
-	* so get rid of all our resources
-	*/
-	if (brcmf_watchdog_prio > 0) {
-		struct sched_param param;
-		param.sched_priority = (brcmf_watchdog_prio < MAX_RT_PRIO) ?
-				       brcmf_watchdog_prio : (MAX_RT_PRIO - 1);
-		sched_setscheduler(current, SCHED_FIFO, &param);
-	}
+	bus = drvr->bus;
 
-	allow_signal(SIGTERM);
-	/* Run until signal received */
-	while (1) {
-		if (kthread_should_stop())
-			break;
-		if (!wait_for_completion_interruptible(&bus->watchdog_wait)) {
-			if (bus->drvr->dongle_reset == false)
-				brcmf_sdbrcm_bus_watchdog(bus->drvr);
-			/* Count the tick for reference */
-			bus->drvr->tickcnt++;
-		} else
-			break;
-	}
-	return 0;
-}
+	if (flag == true) {
+		brcmf_sdbrcm_wd_timer(bus, 0);
+		if (!bus->drvr->dongle_reset) {
+			/* Expect app to have torn down any
+			 connection before calling */
+			/* Stop the bus, disable F2 */
+			brcmf_sdbrcm_bus_stop(bus, false);
 
-static void
-brcmf_sdbrcm_watchdog(unsigned long data)
-{
-	struct brcmf_bus *bus = (struct brcmf_bus *)data;
+			/* Clean tx/rx buffer pointers,
+			 detach from the dongle */
+			brcmf_sdbrcm_release_dongle(bus);
 
-	if (brcmf_watchdog_prio >= 0) {
-		if (bus->watchdog_tsk)
-			complete(&bus->watchdog_wait);
-		else
-			return;
+			bus->drvr->dongle_reset = true;
+			bus->drvr->up = false;
+
+			brcmf_dbg(TRACE, "WLAN OFF DONE\n");
+			/* App can now remove power from device */
+		} else
+			bcmerror = -EIO;
 	} else {
-		brcmf_sdbrcm_bus_watchdog(bus->drvr);
+		/* App must have restored power to device before calling */
 
-		/* Count the tick for reference */
-		bus->drvr->tickcnt++;
-	}
+		brcmf_dbg(TRACE, " == WLAN ON ==\n");
 
-	/* Reschedule the watchdog */
-	if (bus->wd_timer_valid)
-		mod_timer(&bus->timer, jiffies + brcmf_watchdog_ms * HZ / 1000);
+		if (bus->drvr->dongle_reset) {
+			/* Turn on WLAN */
+
+			/* Attempt to re-attach & download */
+			if (brcmf_sdbrcm_probe_attach(bus, SI_ENUM_BASE)) {
+				/* Attempt to download binary to the dongle */
+				if (brcmf_sdbrcm_probe_init(bus)) {
+					/* Re-init bus, enable F2 transfer */
+					brcmf_sdbrcm_bus_init(bus->drvr, false);
+
+					bus->drvr->dongle_reset = false;
+					bus->drvr->up = true;
+
+					brcmf_dbg(TRACE, "WLAN ON DONE\n");
+				} else
+					bcmerror = -EIO;
+			} else
+				bcmerror = -EIO;
+		} else {
+			bcmerror = -EISCONN;
+			brcmf_dbg(ERROR, "Set DEVRESET=false invoked when device is on\n");
+			bcmerror = -EIO;
+		}
+		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
+	}
+	return bcmerror;
 }
 
 void
@@ -5074,118 +5135,3 @@ brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
 		bus->save_ms = wdtick;
 	}
 }
-
-static int brcmf_sdbrcm_dpc_thread(void *data)
-{
-	struct brcmf_bus *bus = (struct brcmf_bus *) data;
-
-	/* This thread doesn't need any user-level access,
-	 * so get rid of all our resources
-	 */
-	if (brcmf_dpc_prio > 0) {
-		struct sched_param param;
-		param.sched_priority = (brcmf_dpc_prio < MAX_RT_PRIO) ?
-				       brcmf_dpc_prio : (MAX_RT_PRIO - 1);
-		sched_setscheduler(current, SCHED_FIFO, &param);
-	}
-
-	allow_signal(SIGTERM);
-	/* Run until signal received */
-	while (1) {
-		if (kthread_should_stop())
-			break;
-		if (!wait_for_completion_interruptible(&bus->dpc_wait)) {
-			/* Call bus dpc unless it indicated down
-			(then clean stop) */
-			if (bus->drvr->busstate != BRCMF_BUS_DOWN) {
-				if (brcmf_sdbrcm_dpc(bus))
-					complete(&bus->dpc_wait);
-			} else {
-				brcmf_sdbrcm_bus_stop(bus, true);
-			}
-		} else
-			break;
-	}
-	return 0;
-}
-
-static void brcmf_sdbrcm_dpc_tasklet(unsigned long data)
-{
-	struct brcmf_bus *bus = (struct brcmf_bus *) data;
-
-	/* Call bus dpc unless it indicated down (then clean stop) */
-	if (bus->drvr->busstate != BRCMF_BUS_DOWN) {
-		if (brcmf_sdbrcm_dpc(bus))
-			tasklet_schedule(&bus->tasklet);
-	} else
-		brcmf_sdbrcm_bus_stop(bus, true);
-}
-
-static void brcmf_sdbrcm_sched_dpc(struct brcmf_bus *bus)
-{
-	if (bus->dpc_tsk) {
-		complete(&bus->dpc_wait);
-		return;
-	}
-
-	tasklet_schedule(&bus->tasklet);
-}
-
-static void brcmf_sdbrcm_sdlock(struct brcmf_bus *bus)
-{
-	if (bus->threads_only)
-		down(&bus->sdsem);
-	else
-		spin_lock_bh(&bus->sdlock);
-}
-
-static void brcmf_sdbrcm_sdunlock(struct brcmf_bus *bus)
-{
-	if (bus->threads_only)
-		up(&bus->sdsem);
-	else
-		spin_unlock_bh(&bus->sdlock);
-}
-
-static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus)
-{
-	if (bus->firmware->size < bus->fw_ptr + len)
-		len = bus->firmware->size - bus->fw_ptr;
-
-	memcpy(buf, &bus->firmware->data[bus->fw_ptr], len);
-	bus->fw_ptr += len;
-	return len;
-}
-
-MODULE_FIRMWARE(BCM4329_FW_NAME);
-MODULE_FIRMWARE(BCM4329_NV_NAME);
-
-static int brcmf_sdbrcm_ioctl_resp_wait(struct brcmf_bus *bus, uint *condition,
-					bool *pending)
-{
-	DECLARE_WAITQUEUE(wait, current);
-	int timeout = msecs_to_jiffies(brcmf_ioctl_timeout_msec);
-
-	/* Wait until control frame is available */
-	add_wait_queue(&bus->ioctl_resp_wait, &wait);
-	set_current_state(TASK_INTERRUPTIBLE);
-
-	while (!(*condition) && (!signal_pending(current) && timeout))
-		timeout = schedule_timeout(timeout);
-
-	if (signal_pending(current))
-		*pending = true;
-
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&bus->ioctl_resp_wait, &wait);
-
-	return timeout;
-}
-
-static int brcmf_sdbrcm_ioctl_resp_wake(struct brcmf_bus *bus)
-{
-	if (waitqueue_active(&bus->ioctl_resp_wait))
-		wake_up_interruptible(&bus->ioctl_resp_wait);
-
-	return 0;
-}
-- 
1.7.4.1


