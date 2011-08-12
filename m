Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4840 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab1HLNfN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/14] staging: brcm80211: remove dead code from
 dhd_sdio.c
Date: Fri, 12 Aug 2011 15:34:57 +0200
Message-ID: <1313156101-16817-11-git-send-email-arend@broadcom.com> (sfid-20110812_153530_628141_17E025D7)
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Code cleanup for brcmfmac

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  222 +++++-------------------
 1 files changed, 47 insertions(+), 175 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 85ce5d9..1d487db 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -38,28 +38,6 @@
 #ifdef BCMDBG
 
 /* ARM trap handling */
-
-/* Trap types defined by ARM (see arminc.h) */
-
-#if defined(__ARM_ARCH_4T__)
-#define	MAX_TRAP_TYPE	(TR_FIQ + 1)
-#elif defined(__ARM_ARCH_7M__)
-#define	MAX_TRAP_TYPE	(TR_ISR + ARMCM3_NUMINTS)
-#endif				/* __ARM_ARCH_7M__ */
-
-/* The trap structure is defined here as offsets for assembly */
-#define	TR_TYPE		0x00
-#define	TR_EPC		0x04
-#define	TR_CPSR		0x08
-#define	TR_SPSR		0x0c
-#define	TR_REGS		0x10
-#define	TR_REG(n)	(TR_REGS + (n) * 4)
-#define	TR_SP		TR_REG(13)
-#define	TR_LR		TR_REG(14)
-#define	TR_PC		TR_REG(15)
-
-#define	TRAP_T_SIZE	80
-
 struct brcmf_trap {
 	u32 type;
 	u32 epc;
@@ -620,7 +598,6 @@ struct brcmf_bus {
 	u32 ramsize;		/* Size of RAM in SOCRAM (bytes) */
 	u32 orig_ramsize;	/* Size of RAM in SOCRAM (bytes) */
 
-	u32 bus;		/* gSPI or SDIO bus */
 	u32 hostintmask;	/* Copy of Host Interrupt Mask */
 	u32 intstatus;	/* Intstatus bits (events) pending */
 	bool dpc_sched;		/* Indicates DPC schedule (intrpt rcvd) */
@@ -801,8 +778,6 @@ struct sbconfig {
 #define CLK_PENDING	2	/* Not used yet */
 #define CLK_AVAIL	3
 
-#define BRCMF_NOPMU(brcmf)	(false)
-
 #ifdef BCMDBG
 static int qcount[NUMPRIO];
 static int tx_packets[NUMPRIO];
@@ -862,12 +837,9 @@ module_param(brcmf_dongle_memsize, int, 0);
 
 static bool brcmf_alignctl;
 
-static bool sd1idle;
-
 static bool retrydata;
 #define RETRYCHAN(chan) (((chan) == SDPCM_EVENT_CHANNEL) || retrydata)
 
-static const uint watermark = 8;
 static const uint firstread = BRCMF_FIRSTREAD;
 
 /* Retry count for register access failures */
@@ -939,8 +911,6 @@ w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 	}
 }
 
-#define BRCMF_BUS			SDIO_BUS
-
 #define PKT_AVAILABLE()		(intstatus & I_HMB_FRAME_IND)
 
 #define HOSTINTMASK		(I_HMB_SW_MASK | I_CHIPACTIVE)
@@ -1012,7 +982,7 @@ static int brcmf_sdbrcm_ioctl_resp_wake(struct brcmf_bus *bus);
  */
 static void brcmf_sdbrcm_pktfree2(struct brcmf_bus *bus, struct sk_buff *pkt)
 {
-	if ((bus->bus != SPI_BUS) || bus->usebufpool)
+	if (bus->usebufpool)
 		brcmu_pkt_buf_free_skb(pkt);
 }
 
@@ -1890,18 +1860,15 @@ enum {
 	IOV_ALIGNCTL,
 	IOV_SDALIGN,
 	IOV_DEVRESET,
-	IOV_CPU,
 #ifdef SDTEST
 	IOV_PKTGEN,
 	IOV_EXTLOOP,
 #endif				/* SDTEST */
-	IOV_SPROM,
 	IOV_TXBOUND,
 	IOV_RXBOUND,
 	IOV_TXMINMAX,
 	IOV_IDLETIME,
 	IOV_IDLECLOCK,
-	IOV_SD1IDLE,
 	IOV_SLEEP,
 	IOV_WDTICK,
 	IOV_IOCTLTIMEOUT,
@@ -1914,7 +1881,6 @@ const struct brcmu_iovar brcmf_sdio_iovars[] = {
 	{"pollrate", IOV_POLLRATE, 0, IOVT_UINT32, 0},
 	{"idletime", IOV_IDLETIME, 0, IOVT_INT32, 0},
 	{"idleclock", IOV_IDLECLOCK, 0, IOVT_INT32, 0},
-	{"sd1idle", IOV_SD1IDLE, 0, IOVT_BOOL, 0},
 	{"membytes", IOV_MEMBYTES, 0, IOVT_BUFFER, 2 * sizeof(int)},
 	{"memsize", IOV_MEMSIZE, 0, IOVT_UINT32, 0},
 	{"download", IOV_DOWNLOAD, 0, IOVT_BOOL, 0},
@@ -1946,8 +1912,6 @@ const struct brcmu_iovar brcmf_sdio_iovars[] = {
 	,
 	{"txminmax", IOV_TXMINMAX, 0, IOVT_UINT32, 0}
 	,
-	{"cpu", IOV_CPU, 0, IOVT_BOOL, 0}
-	,
 	{"checkdied", IOV_CHECKDIED, 0, IOVT_BUFFER, 0}
 	,
 #endif				/* BCMDBG */
@@ -2636,15 +2600,6 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 		bus->idleclock = int_val;
 		break;
 
-	case IOV_GVAL(IOV_SD1IDLE):
-		int_val = (s32) sd1idle;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_SD1IDLE):
-		sd1idle = bool_val;
-		break;
-
 	case IOV_SVAL(IOV_MEMBYTES):
 	case IOV_GVAL(IOV_MEMBYTES):
 		{
@@ -3370,7 +3325,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 			  offsetof(struct sdpcmd_regs, hostintmask), &retries);
 
 		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				       SBSDIO_WATERMARK, (u8) watermark, &err);
+				       SBSDIO_WATERMARK, 8, &err);
 
 		/* Set bus state according to enable result */
 		drvr->busstate = BRCMF_BUS_DATA;
@@ -3484,10 +3439,6 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	/* Control data already received in aligned rxctl */
-	if ((bus->bus == SPI_BUS) && (!bus->usebufpool))
-		goto gotpkt;
-
 	/* Set rxctl for frame (w/optional alignment) */
 	bus->rxctl = bus->rxbuf;
 	if (brcmf_alignctl) {
@@ -3503,12 +3454,6 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 	if (len <= firstread)
 		goto gotpkt;
 
-	/* Copy the full data pkt in gSPI case and process ioctl. */
-	if (bus->bus == SPI_BUS) {
-		memcpy(bus->rxctl, hdr, len);
-		goto gotpkt;
-	}
-
 	/* Raise rdlen to next SDIO block to avoid tail command */
 	rdlen = len - firstread;
 	if (bus->roundup && bus->blocksize && (rdlen > bus->blocksize)) {
@@ -4039,26 +3984,22 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			u16 nextlen = bus->nextlen;
 			bus->nextlen = 0;
 
-			if (bus->bus == SPI_BUS) {
-				rdlen = len = nextlen;
-			} else {
-				rdlen = len = nextlen << 4;
-
-				/* Pad read to blocksize for efficiency */
-				if (bus->roundup && bus->blocksize
-				    && (rdlen > bus->blocksize)) {
-					pad =
-					    bus->blocksize -
-					    (rdlen % bus->blocksize);
-					if ((pad <= bus->roundup)
-					    && (pad < bus->blocksize)
-					    && ((rdlen + pad + firstread) <
-						MAX_RX_DATASZ))
-						rdlen += pad;
-				} else if (rdlen % BRCMF_SDALIGN) {
-					rdlen += BRCMF_SDALIGN -
-						 (rdlen % BRCMF_SDALIGN);
-				}
+			rdlen = len = nextlen << 4;
+
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
 
 			/* We use bus->rxctl buffer in WinXP for initial
@@ -4074,60 +4015,15 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			/* Allocate a packet buffer */
 			pkt = brcmu_pkt_buf_get_skb(rdlen + BRCMF_SDALIGN);
 			if (!pkt) {
-				if (bus->bus == SPI_BUS) {
-					bus->usebufpool = false;
-					bus->rxctl = bus->rxbuf;
-					if (brcmf_alignctl) {
-						bus->rxctl += firstread;
-						pad = ((unsigned long)bus->rxctl
-							% BRCMF_SDALIGN);
-						if (pad)
-							bus->rxctl +=
-							  (BRCMF_SDALIGN - pad);
-						bus->rxctl -= firstread;
-					}
-					rxbuf = bus->rxctl;
-					/* Read the entire frame */
-					sdret = brcmf_sdcard_recv_buf(
-						   bus->sdiodev,
-						   brcmf_sdcard_cur_sbwad(
-							bus->sdiodev),
-						   SDIO_FUNC_2, F2SYNC,
-						   rxbuf, rdlen,
-						   NULL, NULL, NULL);
-					bus->f2rxdata++;
-
-					/* Control frame failures need
-					 retransmission */
-					if (sdret < 0) {
-						BRCMF_ERROR(("%s: read %d "
-							     "control bytes "
-							     "failed: %d\n",
-							     __func__,
-							     rdlen, sdret));
-						/* dhd.rx_ctlerrs is higher */
-						bus->rxc_errors++;
-						brcmf_sdbrcm_rxfail(bus, true,
-						       (bus->bus ==
-							SPI_BUS) ? false
-						       : true);
-						continue;
-					}
-				} else {
-					/* Give up on data,
-					request rtx of events */
-					BRCMF_ERROR(("%s (nextlen): "
-						     "brcmu_pkt_buf_get_skb "
-						     "failed:"
-						     " len %d rdlen %d expected"
-						     " rxseq %d\n", __func__,
-						     len, rdlen, rxseq));
-					continue;
-				}
+				/* Give up on data, request rtx of events */
+				BRCMF_ERROR(("%s (nextlen): "
+					     "brcmu_pkt_buf_get_skb "
+					     "failed:"
+					     " len %d rdlen %d expected"
+					     " rxseq %d\n", __func__,
+					     len, rdlen, rxseq));
+				continue;
 			} else {
-				if (bus->bus == SPI_BUS)
-					bus->usebufpool = true;
-
 				PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
 				rxbuf = (u8 *) (pkt->data);
 				/* Read the entire frame */
@@ -4149,10 +4045,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 					 * Don't attempt NAK for
 					 * gSPI
 					 */
-					brcmf_sdbrcm_rxfail(bus, true,
-						       (bus->bus ==
-							SPI_BUS) ? false :
-						       true);
+					brcmf_sdbrcm_rxfail(bus, true, true);
 					continue;
 				}
 			}
@@ -4202,8 +4095,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 					     "expected rxseq %d\n",
 					     __func__, nextlen,
 					     len, roundup(len, 16), rxseq));
-				brcmf_sdbrcm_rxfail(bus, true,
-						  bus->bus != SPI_BUS);
+				brcmf_sdbrcm_rxfail(bus, true, true);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
@@ -4275,29 +4167,16 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 #endif
 
 			if (chan == SDPCM_CONTROL_CHANNEL) {
-				if (bus->bus == SPI_BUS) {
-					brcmf_sdbrcm_read_control(bus, rxbuf,
-								  len, doff);
-				} else {
-					BRCMF_ERROR(("%s (nextlen): readahead"
-						     " on control packet %d?\n",
-						     __func__, seq));
-					/* Force retry w/normal header read */
-					bus->nextlen = 0;
-					brcmf_sdbrcm_rxfail(bus, false, true);
-				}
+				BRCMF_ERROR(("%s (nextlen): readahead"
+					     " on control packet %d?\n",
+					     __func__, seq));
+				/* Force retry w/normal header read */
+				bus->nextlen = 0;
+				brcmf_sdbrcm_rxfail(bus, false, true);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
 
-			if ((bus->bus == SPI_BUS) && !bus->usebufpool) {
-				BRCMF_ERROR(("Received %d bytes on %d channel."
-					     " Running out of " "rx pktbuf's or"
-					     " not yet malloced.\n",
-					     len, chan));
-				continue;
-			}
-
 			/* Validate data offset */
 			if ((doff < SDPCM_HDRLEN) || (doff > len)) {
 				BRCMF_ERROR(("%s (nextlen): bad data offset %d:"
@@ -4311,9 +4190,6 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			/* All done with this one -- now deliver the packet */
 			goto deliver;
 		}
-		/* gSPI frames should not be handled in fractions */
-		if (bus->bus == SPI_BUS)
-			break;
 
 		/* Read frame header (hardware and software) */
 		sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
@@ -5384,7 +5260,6 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	brcmf_txbound = BRCMF_TXBOUND;
 	brcmf_rxbound = BRCMF_RXBOUND;
 	brcmf_alignctl = true;
-	sd1idle = true;
 	brcmf_readahead = true;
 	retrydata = false;
 	brcmf_dongle_memsize = 0;
@@ -5408,7 +5283,6 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	}
 	bus->sdiodev = sdiodev;
 	sdiodev->bus = bus;
-	bus->bus = BRCMF_BUS;
 	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
 	bus->usebufpool = false;	/* Use bufpool if allocated,
 					 else use locally malloced rxbuf */
@@ -5578,22 +5452,20 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 	brcmf_sdbrcm_sdiod_drive_strength_init(bus, brcmf_sdiod_drive_strength);
 
 	/* Get info on the ARM and SOCRAM cores... */
-	if (!BRCMF_NOPMU(bus)) {
-		brcmf_sdcard_reg_read(bus->sdiodev,
-			  CORE_SB(bus->ci->armcorebase, sbidhigh), 4);
-		bus->orig_ramsize = bus->ci->ramsize;
-		if (!(bus->orig_ramsize)) {
-			BRCMF_ERROR(("%s: failed to find SOCRAM memory!\n",
-				     __func__));
-			goto fail;
-		}
-		bus->ramsize = bus->orig_ramsize;
-		if (brcmf_dongle_memsize)
-			brcmf_sdbrcm_setmemsize(bus, brcmf_dongle_memsize);
-
-		BRCMF_ERROR(("DHD: dongle ram size is set to %d(orig %d)\n",
-			     bus->ramsize, bus->orig_ramsize));
+	brcmf_sdcard_reg_read(bus->sdiodev,
+		  CORE_SB(bus->ci->armcorebase, sbidhigh), 4);
+	bus->orig_ramsize = bus->ci->ramsize;
+	if (!(bus->orig_ramsize)) {
+		BRCMF_ERROR(("%s: failed to find SOCRAM memory!\n",
+			     __func__));
+		goto fail;
 	}
+	bus->ramsize = bus->orig_ramsize;
+	if (brcmf_dongle_memsize)
+		brcmf_sdbrcm_setmemsize(bus, brcmf_dongle_memsize);
+
+	BRCMF_ERROR(("DHD: dongle ram size is set to %d(orig %d)\n",
+		     bus->ramsize, bus->orig_ramsize));
 
 	/* Set core control so an SDIO reset does a backplane reset */
 	reg_addr = bus->ci->buscorebase +
-- 
1.7.4.1


