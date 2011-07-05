Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1408 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/31] staging: brcm80211: removed asserts from
 dhd_sdio.c
Date: Wed, 6 Jul 2011 00:02:36 +0200
Message-ID: <1309903378-29021-10-git-send-email-arend@broadcom.com> (sfid-20110706_000408_452521_0FDE3597)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   76 +++++++------------------
 1 files changed, 21 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 2ed770d..077cb49 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -772,8 +772,6 @@ static bool forcealign;
 		uint datalign;						\
 		datalign = (unsigned long)((_p)->data);			\
 		datalign = roundup(datalign, (_align)) - datalign;	\
-		ASSERT(datalign < (_align));				\
-		ASSERT((_p)->len >= ((_len) + datalign));		\
 		if (datalign)						\
 			skb_pull((_p), datalign);			\
 		__skb_trim((_p), (_len));				\
@@ -1286,17 +1284,16 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt, uint c
 			free_pkt = true;
 			pkt = new;
 			frame = (u8 *) (pkt->data);
-			ASSERT(((unsigned long)frame % BRCMF_SDALIGN) == 0);
+			/* precondition: (frame % BRCMF_SDALIGN) == 0) */
 			pad = 0;
 		} else {
 			skb_push(pkt, pad);
 			frame = (u8 *) (pkt->data);
-
-			ASSERT((pad + SDPCM_HDRLEN) <= (int)(pkt->len));
+			/* precondition: pad + SDPCM_HDRLEN <= pkt->len */
 			memset(frame, 0, pad + SDPCM_HDRLEN);
 		}
 	}
-	ASSERT(pad < BRCMF_SDALIGN);
+	/* precondition: pad < BRCMF_SDALIGN */
 
 	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
 	len = (u16) (pkt->len);
@@ -1344,7 +1341,6 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt, uint c
 		ret = brcmf_sdbrcm_send_buf(bus, brcmf_sdcard_cur_sbwad(card),
 			SDIO_FUNC_2, F2SYNC, frame, len, pkt, NULL, NULL);
 		bus->f2txdata++;
-		ASSERT(ret != -BCME_PENDING);
 
 		if (ret < 0) {
 			/* On failure, abort the command
@@ -1416,7 +1412,7 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 
 	/* Add space for the header */
 	skb_push(pkt, SDPCM_HDRLEN);
-	ASSERT(IS_ALIGNED((unsigned long)(pkt->data), 2));
+	/* precondition: IS_ALIGNED((unsigned long)(pkt->data), 2) */
 
 	prec = PRIO2PREC((pkt->priority & PRIOMASK));
 
@@ -1580,7 +1576,7 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 			msglen += doff;
 			memset(frame, 0, doff + SDPCM_HDRLEN);
 		}
-		ASSERT(doff < BRCMF_SDALIGN);
+		/* precondition: doff < BRCMF_SDALIGN */
 	}
 	doff += SDPCM_HDRLEN;
 
@@ -1597,7 +1593,7 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	if (forcealign && (len & (ALIGNMENT - 1)))
 		len = roundup(len, ALIGNMENT);
 
-	ASSERT(IS_ALIGNED((unsigned long)frame, 2));
+	/* precondition: IS_ALIGNED((unsigned long)frame, 2) */
 
 	/* Need to lock here to protect txseq and SDIO tx calls */
 	brcmf_sdbrcm_sdlock(bus);
@@ -1660,8 +1656,6 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 				brcmf_sdcard_cur_sbwad(card), SDIO_FUNC_2,
 				F2SYNC, frame, len, NULL, NULL, NULL);
 
-			ASSERT(ret != -BCME_PENDING);
-
 			if (ret < 0) {
 				/* On failure, abort the command and
 				 terminate the frame */
@@ -2559,8 +2553,6 @@ brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 ac
 
 			bool set = (actionid == IOV_SVAL(IOV_MEMBYTES));
 
-			ASSERT(plen >= 2 * sizeof(int));
-
 			address = (u32) int_val;
 			memcpy(&int_val, (char *)params + sizeof(int_val),
 			       sizeof(int_val));
@@ -3037,14 +3029,16 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	ASSERT(name);
-	ASSERT(len >= 0);
+	if (name == NULL || len <= 0)
+		return -EINVAL;
 
-	/* Get MUST have return space */
-	ASSERT(set || (arg && len));
+	/* Set does not take qualifiers */
+	if (set && (params || plen))
+		return -EINVAL;
 
-	/* Set does NOT take qualifiers */
-	ASSERT(!set || (!params && !plen));
+	/* Get must have return space;*/
+	if (!set && !(arg && len))
+		return -EINVAL;
 
 	/* Look up var locally; if not found pass to host driver */
 	vi = brcmu_iovar_lookup(brcmf_sdio_iovars, name);
@@ -3219,7 +3213,6 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 			return -1;
 	}
 
-	ASSERT(bus->drvr);
 	if (!bus->drvr)
 		return 0;
 
@@ -3408,7 +3401,6 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 	if ((bus->bus == SPI_BUS) && (!bus->usebufpool))
 		goto gotpkt;
 
-	ASSERT(bus->rxbuf);
 	/* Set rxctl for frame (w/optional alignment) */
 	bus->rxctl = bus->rxbuf;
 	if (brcmf_alignctl) {
@@ -3418,7 +3410,6 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 			bus->rxctl += (BRCMF_SDALIGN - pad);
 		bus->rxctl -= firstread;
 	}
-	ASSERT(bus->rxctl >= bus->rxbuf);
 
 	/* Copy the already-read portion over */
 	memcpy(bus->rxctl, hdr, firstread);
@@ -3471,7 +3462,6 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 				F2SYNC, (bus->rxctl + firstread), rdlen,
 				NULL, NULL, NULL);
 	bus->f2rxdata++;
-	ASSERT(sdret != -BCME_PENDING);
 
 	/* Control frame failures need retransmission */
 	if (sdret < 0) {
@@ -3569,12 +3559,9 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 					     num, sublen));
 				break;
 			}
-			ASSERT(!(pnext->prev));
 			if (!pfirst) {
-				ASSERT(!plast);
 				pfirst = plast = pnext;
 			} else {
-				ASSERT(plast);
 				plast->next = pnext;
 				plast = pnext;
 			}
@@ -3659,7 +3646,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			errcode = -1;
 		}
 		bus->f2rxdata++;
-		ASSERT(errcode != -BCME_PENDING);
 
 		/* On failure, kill the superframe, allow a couple retries */
 		if (errcode < 0) {
@@ -3833,8 +3819,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 				    __func__, num, pfirst, pfirst->data,
 				    pfirst->len, sublen, chan, seq));
 
-			ASSERT((chan == SDPCM_DATA_CHANNEL)
-			       || (chan == SDPCM_EVENT_CHANNEL));
+			/* precondition: chan == SDPCM_DATA_CHANNEL ||
+					 chan == SDPCM_EVENT_CHANNEL */
 
 			if (rxseq != seq) {
 				BRCMF_GLOM(("%s: rx_seq %d, expected %d\n",
@@ -3858,7 +3844,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 				if (plast) {
 					plast->next = pnext;
 				} else {
-					ASSERT(save_pfirst == pfirst);
 					save_pfirst = pnext;
 				}
 				continue;
@@ -3871,7 +3856,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 				if (plast) {
 					plast->next = pnext;
 				} else {
-					ASSERT(save_pfirst == pfirst);
 					save_pfirst = pnext;
 				}
 				continue;
@@ -3937,8 +3921,6 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	ASSERT(maxframes);
-
 #ifdef SDTEST
 	/* Allow pktgen to override maxframes */
 	if (bus->pktgen_count && (bus->pktgen_mode == BRCMF_PKTGEN_RECV)) {
@@ -4018,7 +4000,6 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 							    (BRCMF_SDALIGN - pad);
 						bus->rxctl -= firstread;
 					}
-					ASSERT(bus->rxctl >= bus->rxbuf);
 					rxbuf = bus->rxctl;
 					/* Read the entire frame */
 					sdret = brcmf_sdcard_recv_buf(card,
@@ -4027,7 +4008,6 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 						   rxbuf, rdlen,
 						   NULL, NULL, NULL);
 					bus->f2rxdata++;
-					ASSERT(sdret != -BCME_PENDING);
 
 					/* Control frame failures need
 					 retransmission */
@@ -4060,7 +4040,6 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				if (bus->bus == SPI_BUS)
 					bus->usebufpool = true;
 
-				ASSERT(!(pkt->prev));
 				PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
 				rxbuf = (u8 *) (pkt->data);
 				/* Read the entire frame */
@@ -4070,7 +4049,6 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 						rxbuf, rdlen,
 						pkt, NULL, NULL);
 				bus->f2rxdata++;
-				ASSERT(sdret != -BCME_PENDING);
 
 				if (sdret < 0) {
 					BRCMF_ERROR(("%s (nextlen): read %d"
@@ -4254,7 +4232,6 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				SDIO_FUNC_2, F2SYNC, bus->rxhdr, firstread,
 				NULL, NULL, NULL);
 		bus->f2rxhdrs++;
-		ASSERT(sdret != -BCME_PENDING);
 
 		if (sdret < 0) {
 			BRCMF_ERROR(("%s: RXHEADER FAILED: %d\n", __func__,
@@ -4309,7 +4286,6 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				     " min %d seq %d\n", __func__, doff,
 				     len, SDPCM_HDRLEN, seq));
 			bus->rx_badhdr++;
-			ASSERT(0);
 			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
 		}
@@ -4360,10 +4336,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			continue;
 		}
 
-		ASSERT((chan == SDPCM_DATA_CHANNEL)
-		       || (chan == SDPCM_EVENT_CHANNEL)
-		       || (chan == SDPCM_TEST_CHANNEL)
-		       || (chan == SDPCM_GLOM_CHANNEL));
+		/* precondition: chan is either SDPCM_DATA_CHANNEL,
+		   SDPCM_EVENT_CHANNEL, SDPCM_TEST_CHANNEL or
+		   SDPCM_GLOM_CHANNEL */
 
 		/* Length to read */
 		rdlen = (len > firstread) ? (len - firstread) : 0;
@@ -4404,10 +4379,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			continue;
 		}
 
-		ASSERT(!(pkt->prev));
-
 		/* Leave room for what we already read, and align remainder */
-		ASSERT(firstread < pkt->len);
 		skb_pull(pkt, firstread);
 		PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
 
@@ -4417,7 +4389,6 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				SDIO_FUNC_2, F2SYNC, ((u8 *) (pkt->data)),
 				rdlen, pkt, NULL, NULL);
 		bus->f2rxdata++;
-		ASSERT(sdret != -BCME_PENDING);
 
 		if (sdret < 0) {
 			BRCMF_ERROR(("%s: read %d %s bytes failed: %d\n",
@@ -4458,7 +4429,6 @@ deliver:
 				}
 #endif
 				__skb_trim(pkt, len);
-				ASSERT(doff == SDPCM_HDRLEN);
 				skb_pull(pkt, SDPCM_HDRLEN);
 				bus->glomd = pkt;
 			} else {
@@ -4621,8 +4591,6 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 			BRCMF_ERROR(("%s: error reading DEVCTL: %d\n",
 				     __func__, err));
 			bus->drvr->busstate = BRCMF_BUS_DOWN;
-		} else {
-			ASSERT(devctl & SBSDIO_DEVCTL_CA_INT_ONLY);
 		}
 #endif				/* BCMDBG */
 
@@ -4768,7 +4736,6 @@ clkwait:
 		ret = brcmf_sdbrcm_send_buf(bus, brcmf_sdcard_cur_sbwad(card),
 			SDIO_FUNC_2, F2SYNC, (u8 *) bus->ctrl_frame_buf,
 			(u32) bus->ctrl_frame_len, NULL, NULL, NULL);
-		ASSERT(ret != -BCME_PENDING);
 
 		if (ret < 0) {
 			/* On failure, abort the command and
@@ -5364,8 +5331,8 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 	BRCMF_INFO(("%s: venid 0x%04x devid 0x%04x\n", __func__, venid, devid));
 
-	/* We make assumptions about address window mappings */
-	ASSERT(regsva == SI_ENUM_BASE);
+	/* We make an assumption about address window mappings:
+	 * regsva == SI_ENUM_BASE*/
 
 	/* SDIO car passes venid and devid based on CIS parsing -- but
 	 * low-power start
@@ -5803,7 +5770,6 @@ static void brcmf_sdbrcm_disconnect(void *ptr)
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 	if (bus) {
-		ASSERT(bus->drvr);
 		brcmf_sdbrcm_release(bus);
 	}
 
-- 
1.7.4.1


