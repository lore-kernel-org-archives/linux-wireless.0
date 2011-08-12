Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1917 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab1HLNfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/14] staging: brcm80211: remove dead SDTEST code from
 fullmac
Date: Fri, 12 Aug 2011 15:35:00 +0200
Message-ID: <1313156101-16817-14-git-send-email-arend@broadcom.com> (sfid-20110812_153528_226123_6C3CDC19)
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove legacy dead code of SDTEST

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h      |   37 --
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  455 +------------------------
 2 files changed, 1 insertions(+), 491 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index cd1b90d..ae8a9a6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -672,15 +672,6 @@ extern uint brcmf_radio_up;
 /* Override to force tx queueing all the time */
 extern uint brcmf_force_tx_queueing;
 
-#ifdef SDTEST
-/* Echo packet generator (SDIO), pkts/s */
-extern uint brcmf_pktgen;
-
-/* Echo packet len (0 => sawtooth, max 1800) */
-extern uint brcmf_pktgen_len;
-#define BRCMF_MAX_PKTGEN_LEN 1800
-#endif
-
 extern const struct bcmevent_name bcmevent_names[];
 extern const int bcmevent_names_size;
 
@@ -823,34 +814,6 @@ struct brcmf_c_ioctl {
 #define BRCMF_BTA_VAL	0x1000
 #define BRCMF_ISCAN_VAL 0x2000
 
-#ifdef SDTEST
-/* For pktgen iovar */
-struct brcmf_pktgen {
-	uint version;		/* To allow structure change tracking */
-	uint freq;		/* Max ticks between tx/rx attempts */
-	uint count;		/* Test packets to send/rcv each attempt */
-	uint print;		/* Print counts every <print> attempts */
-	uint total;		/* Total packets (or bursts) */
-	uint minlen;		/* Minimum length of packets to send */
-	uint maxlen;		/* Maximum length of packets to send */
-	uint numsent;		/* Count of test packets sent */
-	uint numrcvd;		/* Count of test packets received */
-	uint numfail;		/* Count of test send failures */
-	uint mode;		/* Test mode (type of test packets) */
-	uint stop;		/* Stop after this many tx failures */
-};
-
-/* Version in case structure changes */
-#define BRCMF_PKTGEN_VERSION	2
-
-/* Type of test packets to use */
-#define BRCMF_PKTGEN_ECHO	1	/* Send echo requests */
-#define BRCMF_PKTGEN_SEND	2	/* Send discard packets */
-#define BRCMF_PKTGEN_RXBURST	3	/* Request dongle send N packets */
-#define BRCMF_PKTGEN_RECV		4	/* Continuous rx from continuous
-					 tx dongle */
-#endif				/* SDTEST */
-
 /* Enter idle immediately (no timeout) */
 #define BRCMF_IDLE_IMMEDIATE	(-1)
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 60e7a814..cc321d6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -251,11 +251,7 @@ struct rte_console {
 
 /* Total length of frame header for dongle protocol */
 #define SDPCM_HDRLEN	(SDPCM_FRAMETAG_LEN + SDPCM_SWHEADER_LEN)
-#ifdef SDTEST
-#define SDPCM_RESERVE	(SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + BRCMF_SDALIGN)
-#else
 #define SDPCM_RESERVE	(SDPCM_HDRLEN + BRCMF_SDALIGN)
-#endif
 
 /*
  * Software allocation of To SB Mailbox resources
@@ -661,30 +657,6 @@ struct brcmf_bus {
 /* Field to decide if rx of control frames happen in rxbuf or lb-pool */
 	bool usebufpool;
 
-#ifdef SDTEST
-	/* external loopback */
-	bool ext_loop;
-	u8 loopid;
-
-	/* pktgen configuration */
-	uint pktgen_freq;	/* Ticks between bursts */
-	uint pktgen_count;	/* Packets to send each burst */
-	uint pktgen_print;	/* Bursts between count displays */
-	uint pktgen_total;	/* Stop after this many */
-	uint pktgen_minlen;	/* Minimum packet data len */
-	uint pktgen_maxlen;	/* Maximum packet data len */
-	uint pktgen_mode;	/* Configured mode: tx, rx, or echo */
-	uint pktgen_stop;	/* Number of tx failures causing stop */
-
-	/* active pktgen fields */
-	uint pktgen_tick;	/* Tick counter for bursts */
-	uint pktgen_ptick;	/* Burst counter for printing */
-	uint pktgen_sent;	/* Number of test packets generated */
-	uint pktgen_rcvd;	/* Number of test packets received */
-	uint pktgen_fail;	/* Number of failed send attempts */
-	u16 pktgen_len;	/* Length of next packet to send */
-#endif				/* SDTEST */
-
 	/* Some additional counters */
 	uint tx_sderrs;		/* Count of tx attempts with sd errors */
 	uint fcqueued;		/* Tx packets that got queued */
@@ -915,11 +887,6 @@ w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 
 #define HOSTINTMASK		(I_HMB_SW_MASK | I_CHIPACTIVE)
 
-#ifdef SDTEST
-static void brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, void *pkt, uint seq);
-static void brcmf_sdbrcm_sdtest_set(struct brcmf_bus *bus, bool start);
-#endif
-
 #ifdef BCMDBG
 static int brcmf_sdbrcm_bus_console_in(struct brcmf_pub *drvr,
 				       unsigned char *msg, uint msglen);
@@ -1469,20 +1436,6 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 
 	datalen = pkt->len;
 
-#ifdef SDTEST
-	/* Push the test header if doing loopback */
-	if (bus->ext_loop) {
-		u8 *data;
-		skb_push(pkt, SDPCM_TEST_HDRLEN);
-		data = pkt->data;
-		*data++ = SDPCM_TEST_ECHOREQ;
-		*data++ = (u8) bus->loopid++;
-		*data++ = (datalen >> 0);
-		*data++ = (datalen >> 8);
-		datalen += SDPCM_TEST_HDRLEN;
-	}
-#endif				/* SDTEST */
-
 	/* Add space for the header */
 	skb_push(pkt, SDPCM_HDRLEN);
 	/* precondition: IS_ALIGNED((unsigned long)(pkt->data), 2) */
@@ -1534,14 +1487,8 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 		/* Make sure back plane ht clk is on, no pending allowed */
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
 
-#ifndef SDTEST
 		BRCMF_TRACE(("%s: calling txpkt\n", __func__));
 		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
-#else
-		ret = brcmf_sdbrcm_txpkt(bus, pkt,
-				    (bus->ext_loop ? SDPCM_TEST_CHANNEL :
-				     SDPCM_DATA_CHANNEL), true);
-#endif
 		if (ret)
 			bus->drvr->tx_errors++;
 		else
@@ -1586,13 +1533,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 		spin_unlock_bh(&bus->txqlock);
 		datalen = pkt->len - SDPCM_HDRLEN;
 
-#ifndef SDTEST
 		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
-#else
-		ret = brcmf_sdbrcm_txpkt(bus, pkt,
-				    (bus->ext_loop ? SDPCM_TEST_CHANNEL :
-				     SDPCM_DATA_CHANNEL), true);
-#endif
 		if (ret)
 			bus->drvr->tx_errors++;
 		else
@@ -1857,10 +1798,6 @@ enum {
 	IOV_ALIGNCTL,
 	IOV_SDALIGN,
 	IOV_DEVRESET,
-#ifdef SDTEST
-	IOV_PKTGEN,
-	IOV_EXTLOOP,
-#endif				/* SDTEST */
 	IOV_TXBOUND,
 	IOV_RXBOUND,
 	IOV_TXMINMAX,
@@ -1912,12 +1849,6 @@ const struct brcmu_iovar brcmf_sdio_iovars[] = {
 	{"checkdied", IOV_CHECKDIED, 0, IOVT_BUFFER, 0}
 	,
 #endif				/* BCMDBG */
-#ifdef SDTEST
-	{"extloop", IOV_EXTLOOP, 0, IOVT_BOOL, 0}
-	,
-	{"pktgen", IOV_PKTGEN, 0, IOVT_BUFFER, sizeof(struct brcmf_pktgen)}
-	,
-#endif				/* SDTEST */
 
 	{NULL, 0, 0, 0, 0}
 };
@@ -2011,19 +1942,6 @@ void brcmf_sdbrcm_bus_dump(struct brcmf_pub *drvr, struct brcmu_strbuf *strbuf)
 		brcmu_bprintf(strbuf, "\n\n");
 	}
 
-#ifdef SDTEST
-	if (bus->pktgen_count) {
-		brcmu_bprintf(strbuf, "pktgen config and count:\n");
-		brcmu_bprintf(strbuf,
-			    "freq %d count %d print %d total %d min %d len %d\n",
-			    bus->pktgen_freq, bus->pktgen_count,
-			    bus->pktgen_print, bus->pktgen_total,
-			    bus->pktgen_minlen, bus->pktgen_maxlen);
-		brcmu_bprintf(strbuf, "send attempts %d rcvd %d fail %d\n",
-			    bus->pktgen_sent, bus->pktgen_rcvd,
-			    bus->pktgen_fail);
-	}
-#endif				/* SDTEST */
 #ifdef BCMDBG
 	brcmu_bprintf(strbuf, "dpc_sched %d host interrupt%spending\n",
 		      bus->dpc_sched, " not ");
@@ -2048,62 +1966,6 @@ void brcmf_bus_clearcounts(struct brcmf_pub *drvr)
 	bus->f2rxhdrs = bus->f2rxdata = bus->f2txdata = bus->f1regdata = 0;
 }
 
-#ifdef SDTEST
-static int brcmf_sdbrcm_pktgen_get(struct brcmf_bus *bus, u8 *arg)
-{
-	struct brcmf_pktgen pktgen;
-
-	pktgen.version = BRCMF_PKTGEN_VERSION;
-	pktgen.freq = bus->pktgen_freq;
-	pktgen.count = bus->pktgen_count;
-	pktgen.print = bus->pktgen_print;
-	pktgen.total = bus->pktgen_total;
-	pktgen.minlen = bus->pktgen_minlen;
-	pktgen.maxlen = bus->pktgen_maxlen;
-	pktgen.numsent = bus->pktgen_sent;
-	pktgen.numrcvd = bus->pktgen_rcvd;
-	pktgen.numfail = bus->pktgen_fail;
-	pktgen.mode = bus->pktgen_mode;
-	pktgen.stop = bus->pktgen_stop;
-
-	memcpy(arg, &pktgen, sizeof(pktgen));
-
-	return 0;
-}
-
-static int brcmf_sdbrcm_pktgen_set(struct brcmf_bus *bus, u8 *arg)
-{
-	struct brcmf_pktgen pktgen;
-	uint oldcnt, oldmode;
-
-	memcpy(&pktgen, arg, sizeof(pktgen));
-	if (pktgen.version != BRCMF_PKTGEN_VERSION)
-		return -EINVAL;
-
-	oldcnt = bus->pktgen_count;
-	oldmode = bus->pktgen_mode;
-
-	bus->pktgen_freq = pktgen.freq;
-	bus->pktgen_count = pktgen.count;
-	bus->pktgen_print = pktgen.print;
-	bus->pktgen_total = pktgen.total;
-	bus->pktgen_minlen = pktgen.minlen;
-	bus->pktgen_maxlen = pktgen.maxlen;
-	bus->pktgen_mode = pktgen.mode;
-	bus->pktgen_stop = pktgen.stop;
-
-	bus->pktgen_tick = bus->pktgen_ptick = 0;
-	bus->pktgen_len = max(bus->pktgen_len, bus->pktgen_minlen);
-	bus->pktgen_len = min(bus->pktgen_len, bus->pktgen_maxlen);
-
-	/* Clear counts for a new pktgen (mode change, or was stopped) */
-	if (bus->pktgen_count && (!oldcnt || oldmode != bus->pktgen_mode))
-		bus->pktgen_sent = bus->pktgen_rcvd = bus->pktgen_fail = 0;
-
-	return 0;
-}
-#endif				/* SDTEST */
-
 static int
 brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 		 uint size)
@@ -2858,25 +2720,6 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 		break;
 #endif				/* BCMDBG */
 
-#ifdef SDTEST
-	case IOV_GVAL(IOV_EXTLOOP):
-		int_val = (s32) bus->ext_loop;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_EXTLOOP):
-		bus->ext_loop = bool_val;
-		break;
-
-	case IOV_GVAL(IOV_PKTGEN):
-		bcmerror = brcmf_sdbrcm_pktgen_get(bus, arg);
-		break;
-
-	case IOV_SVAL(IOV_PKTGEN):
-		bcmerror = brcmf_sdbrcm_pktgen_set(bus, arg);
-		break;
-#endif				/* SDTEST */
-
 	case IOV_SVAL(IOV_DEVRESET):
 		BRCMF_TRACE(("%s: Called set IOV_DEVRESET=%d dongle_reset=%d "
 			     "busstate=%d\n",
@@ -3943,20 +3786,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 	int ifidx = 0;
 	uint rxcount = 0;	/* Total frames read */
 
-#if defined(BCMDBG) || defined(SDTEST)
-	bool sdtest = false;	/* To limit message spew from test mode */
-#endif
-
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-#ifdef SDTEST
-	/* Allow pktgen to override maxframes */
-	if (bus->pktgen_count && (bus->pktgen_mode == BRCMF_PKTGEN_RECV)) {
-		maxframes = bus->pktgen_count;
-		sdtest = true;
-	}
-#endif
-
 	/* Not finished unless we encounter no more frames indication */
 	*finished = false;
 
@@ -4405,14 +4236,6 @@ deliver:
 		__skb_trim(pkt, len);
 		skb_pull(pkt, doff);
 
-#ifdef SDTEST
-		/* Test channel packets are processed separately */
-		if (chan == SDPCM_TEST_CHANNEL) {
-			brcmf_sdbrcm_checkdied(bus, pkt, seq);
-			continue;
-		}
-#endif				/* SDTEST */
-
 		if (pkt->len == 0) {
 			brcmu_pkt_buf_free_skb(pkt);
 			continue;
@@ -4431,7 +4254,7 @@ deliver:
 	rxcount = maxframes - rxleft;
 #ifdef BCMDBG
 	/* Message if we hit the limit */
-	if (!rxleft && !sdtest)
+	if (!rxleft)
 		BRCMF_DATA(("%s: hit rx limit of %d frames\n", __func__,
 			    maxframes));
 	else
@@ -4810,268 +4633,6 @@ void brcmf_sdbrcm_isr(void *arg)
 
 }
 
-#ifdef SDTEST
-static void brcmf_sdbrcm_pktgen_init(struct brcmf_bus *bus)
-{
-	/* Default to specified length, or full range */
-	if (brcmf_pktgen_len) {
-		bus->pktgen_maxlen = min(brcmf_pktgen_len,
-					 BRCMF_MAX_PKTGEN_LEN);
-		bus->pktgen_minlen = bus->pktgen_maxlen;
-	} else {
-		bus->pktgen_maxlen = BRCMF_MAX_PKTGEN_LEN;
-		bus->pktgen_minlen = 0;
-	}
-	bus->pktgen_len = (u16) bus->pktgen_minlen;
-
-	/* Default to per-watchdog burst with 10s print time */
-	bus->pktgen_freq = 1;
-	bus->pktgen_print = 10000 / brcmf_watchdog_ms;
-	bus->pktgen_count = (brcmf_pktgen * brcmf_watchdog_ms + 999) / 1000;
-
-	/* Default to echo mode */
-	bus->pktgen_mode = BRCMF_PKTGEN_ECHO;
-	bus->pktgen_stop = 1;
-}
-
-static void brcmf_sdbrcm_pktgen(struct brcmf_bus *bus)
-{
-	struct sk_buff *pkt;
-	u8 *data;
-	uint pktcount;
-	uint fillbyte;
-	u16 len;
-
-	/* Display current count if appropriate */
-	if (bus->pktgen_print && (++bus->pktgen_ptick >= bus->pktgen_print)) {
-		bus->pktgen_ptick = 0;
-		printk(KERN_DEBUG "%s: send attempts %d rcvd %d\n",
-		       __func__, bus->pktgen_sent, bus->pktgen_rcvd);
-	}
-
-	/* For recv mode, just make sure dongle has started sending */
-	if (bus->pktgen_mode == BRCMF_PKTGEN_RECV) {
-		if (!bus->pktgen_rcvd)
-			brcmf_sdbrcm_sdtest_set(bus, true);
-		return;
-	}
-
-	/* Otherwise, generate or request the specified number of packets */
-	for (pktcount = 0; pktcount < bus->pktgen_count; pktcount++) {
-		/* Stop if total has been reached */
-		if (bus->pktgen_total
-		    && (bus->pktgen_sent >= bus->pktgen_total)) {
-			bus->pktgen_count = 0;
-			break;
-		}
-
-		/* Allocate an appropriate-sized packet */
-		len = bus->pktgen_len;
-		pkt = brcmu_pkt_buf_get_skb(
-			len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + BRCMF_SDALIGN,
-			true);
-		if (!pkt) {
-			BRCMF_ERROR(("%s: brcmu_pkt_buf_get_skb failed!\n",
-				     __func__));
-			break;
-		}
-		PKTALIGN(pkt, (len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN),
-			 BRCMF_SDALIGN);
-		data = (u8 *) (pkt->data) + SDPCM_HDRLEN;
-
-		/* Write test header cmd and extra based on mode */
-		switch (bus->pktgen_mode) {
-		case BRCMF_PKTGEN_ECHO:
-			*data++ = SDPCM_TEST_ECHOREQ;
-			*data++ = (u8) bus->pktgen_sent;
-			break;
-
-		case BRCMF_PKTGEN_SEND:
-			*data++ = SDPCM_TEST_DISCARD;
-			*data++ = (u8) bus->pktgen_sent;
-			break;
-
-		case BRCMF_PKTGEN_RXBURST:
-			*data++ = SDPCM_TEST_BURST;
-			*data++ = (u8) bus->pktgen_count;
-			break;
-
-		default:
-			BRCMF_ERROR(("Unrecognized pktgen mode %d\n",
-				     bus->pktgen_mode));
-			brcmu_pkt_buf_free_skb(pkt, true);
-			bus->pktgen_count = 0;
-			return;
-		}
-
-		/* Write test header length field */
-		*data++ = (len >> 0);
-		*data++ = (len >> 8);
-
-		/* Then fill in the remainder -- N/A for burst,
-			 but who cares... */
-		for (fillbyte = 0; fillbyte < len; fillbyte++)
-			*data++ =
-			    SDPCM_TEST_FILL(fillbyte, (u8) bus->pktgen_sent);
-
-#ifdef BCMDBG
-		if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
-			data = (u8 *) (pkt->data) + SDPCM_HDRLEN;
-			printk(KERN_DEBUG "brcmf_sdbrcm_pktgen: Tx Data:\n");
-			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, data,
-					     pkt->len - SDPCM_HDRLEN);
-		}
-#endif
-
-		/* Send it */
-		if (brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_TEST_CHANNEL, true)) {
-			bus->pktgen_fail++;
-			if (bus->pktgen_stop
-			    && bus->pktgen_stop == bus->pktgen_fail)
-				bus->pktgen_count = 0;
-		}
-		bus->pktgen_sent++;
-
-		/* Bump length if not fixed, wrap at max */
-		if (++bus->pktgen_len > bus->pktgen_maxlen)
-			bus->pktgen_len = (u16) bus->pktgen_minlen;
-
-		/* Special case for burst mode: just send one request! */
-		if (bus->pktgen_mode == BRCMF_PKTGEN_RXBURST)
-			break;
-	}
-}
-
-static void brcmf_sdbrcm_sdtest_set(struct brcmf_bus *bus, bool start)
-{
-	struct sk_buff *pkt;
-	u8 *data;
-
-	/* Allocate the packet */
-	pkt = brcmu_pkt_buf_get_skb(SDPCM_HDRLEN + SDPCM_TEST_HDRLEN +
-		BRCMF_SDALIGN, true);
-	if (!pkt) {
-		BRCMF_ERROR(("%s: brcmu_pkt_buf_get_skb failed!\n", __func__));
-		return;
-	}
-	PKTALIGN(pkt, (SDPCM_HDRLEN + SDPCM_TEST_HDRLEN), BRCMF_SDALIGN);
-	data = (u8 *) (pkt->data) + SDPCM_HDRLEN;
-
-	/* Fill in the test header */
-	*data++ = SDPCM_TEST_SEND;
-	*data++ = start;
-	*data++ = (bus->pktgen_maxlen >> 0);
-	*data++ = (bus->pktgen_maxlen >> 8);
-
-	/* Send it */
-	if (brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_TEST_CHANNEL, true))
-		bus->pktgen_fail++;
-}
-
-static void
-brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, struct sk_buff *pkt, uint seq)
-{
-	u8 *data;
-	uint pktlen;
-
-	u8 cmd;
-	u8 extra;
-	u16 len;
-	u16 offset;
-
-	/* Check for min length */
-	pktlen = pkt->len;
-	if (pktlen < SDPCM_TEST_HDRLEN) {
-		BRCMF_ERROR(("brcmf_sdbrcm_checkdied: toss runt frame, pktlen "
-			     "%d\n", pktlen));
-		brcmu_pkt_buf_free_skb(pkt, false);
-		return;
-	}
-
-	/* Extract header fields */
-	data = pkt->data;
-	cmd = *data++;
-	extra = *data++;
-	len = *data++;
-	len += *data++ << 8;
-
-	/* Check length for relevant commands */
-	if (cmd == SDPCM_TEST_DISCARD || cmd == SDPCM_TEST_ECHOREQ
-	    || cmd == SDPCM_TEST_ECHORSP) {
-		if (pktlen != len + SDPCM_TEST_HDRLEN) {
-			BRCMF_ERROR(("brcmf_sdbrcm_checkdied: frame length "
-				     "mismatch, pktlen %d seq %d"
-				     " cmd %d extra %d len %d\n",
-				     pktlen, seq, cmd, extra, len));
-			brcmu_pkt_buf_free_skb(pkt, false);
-			return;
-		}
-	}
-
-	/* Process as per command */
-	switch (cmd) {
-	case SDPCM_TEST_ECHOREQ:
-		/* Rx->Tx turnaround ok (even on NDIS w/current
-			 implementation) */
-		*(u8 *) (pkt->data) = SDPCM_TEST_ECHORSP;
-		if (brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_TEST_CHANNEL, true) == 0)
-			bus->pktgen_sent++;
-		else {
-			bus->pktgen_fail++;
-			brcmu_pkt_buf_free_skb(pkt, false);
-		}
-		bus->pktgen_rcvd++;
-		break;
-
-	case SDPCM_TEST_ECHORSP:
-		if (bus->ext_loop) {
-			brcmu_pkt_buf_free_skb(pkt, false);
-			bus->pktgen_rcvd++;
-			break;
-		}
-
-		for (offset = 0; offset < len; offset++, data++) {
-			if (*data != SDPCM_TEST_FILL(offset, extra)) {
-				BRCMF_ERROR(("brcmf_sdbrcm_checkdied: echo"
-					     " data mismatch: "
-					     "offset %d (len %d) "
-					     "expect 0x%02x rcvd 0x%02x\n",
-					     offset, len,
-					     SDPCM_TEST_FILL(offset, extra),
-					     *data));
-				break;
-			}
-		}
-		brcmu_pkt_buf_free_skb(pkt, false);
-		bus->pktgen_rcvd++;
-		break;
-
-	case SDPCM_TEST_DISCARD:
-		brcmu_pkt_buf_free_skb(pkt, false);
-		bus->pktgen_rcvd++;
-		break;
-
-	case SDPCM_TEST_BURST:
-	case SDPCM_TEST_SEND:
-	default:
-		BRCMF_INFO(("brcmf_sdbrcm_checkdied: unsupported or unknown "
-			    "command, pktlen %d seq %d" " cmd %d extra %d"
-			    " len %d\n", pktlen, seq, cmd, extra, len));
-		brcmu_pkt_buf_free_skb(pkt, false);
-		break;
-	}
-
-	/* For recv mode, stop at limie (and tell dongle to stop sending) */
-	if (bus->pktgen_mode == BRCMF_PKTGEN_RECV) {
-		if (bus->pktgen_total
-		    && (bus->pktgen_rcvd >= bus->pktgen_total)) {
-			bus->pktgen_count = 0;
-			brcmf_sdbrcm_sdtest_set(bus, false);
-		}
-	}
-}
-#endif				/* SDTEST */
-
 extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 {
 	struct brcmf_bus *bus;
@@ -5139,16 +4700,6 @@ extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 	}
 #endif				/* BCMDBG */
 
-#ifdef SDTEST
-	/* Generate packets if configured */
-	if (bus->pktgen_count && (++bus->pktgen_tick >= bus->pktgen_freq)) {
-		/* Make sure backplane clock is on */
-		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-		bus->pktgen_tick = 0;
-		brcmf_sdbrcm_pktgen(bus);
-	}
-#endif
-
 	/* On idle timeout clear activity flag and/or turn off clock */
 	if ((bus->idletime > 0) && (bus->clkstate == CLK_AVAIL)) {
 		if (++bus->idlecount >= bus->idletime) {
@@ -5533,10 +5084,6 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
 {
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-#ifdef SDTEST
-	brcmf_sdbrcm_pktgen_init(bus);
-#endif				/* SDTEST */
-
 	/* Disable F2 to clear any intermediate frame state on the dongle */
 	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			       SDIO_FUNC_ENABLE_1, NULL);
-- 
1.7.4.1


