Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2420 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab2FIVZa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 17:25:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 4/5] brcmfmac: expose sdio internal counters in debugfs
Date: Sat, 9 Jun 2012 22:51:44 +0200
Message-ID: <1339275105-3593-5-git-send-email-arend@broadcom.com> (sfid-20120609_232535_157992_951392CB)
In-Reply-To: <1339275105-3593-1-git-send-email-arend@broadcom.com>
References: <1339275105-3593-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The structure brcmf_sdio contains a number of counters that are useful
for debugging. These were not available in user-space. This patch
exposes them in debugfs under the filename 'counters'.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |   63 ++++++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   36 +++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  169 +++++++++-----------
 3 files changed, 175 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index 0a7a3d5..7f89540 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -17,12 +17,14 @@
 #include <linux/if_ether.h>
 #include <linux/if.h>
 #include <linux/ieee80211.h>
+#include <linux/module.h>
 
 #include <defs.h>
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include "dhd.h"
 #include "dhd_bus.h"
+#include "dhd_dbg.h"
 
 static struct dentry *root_folder;
 
@@ -61,3 +63,64 @@ struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr)
 {
 	return drvr->dbgfs_dir;
 }
+
+static
+ssize_t brcmf_debugfs_sdio_counter_read(struct file *f, char __user *data,
+					size_t count, loff_t *ppos)
+{
+	struct brcmf_sdio_count *sdcnt = f->private_data;
+	char buf[750];
+	int res;
+
+	/* only allow read from start */
+	if (*ppos > 0)
+		return 0;
+
+	res = scnprintf(buf, sizeof(buf),
+			"intrcount:    %u\nlastintrs:    %u\n"
+			"pollcnt:      %u\nregfails:     %u\n"
+			"tx_sderrs:    %u\nfcqueued:     %u\n"
+			"rxrtx:        %u\nrx_toolong:   %u\n"
+			"rxc_errors:   %u\nrx_hdrfail:   %u\n"
+			"rx_badhdr:    %u\nrx_badseq:    %u\n"
+			"fc_rcvd:      %u\nfc_xoff:      %u\n"
+			"fc_xon:       %u\nrxglomfail:   %u\n"
+			"rxglomframes: %u\nrxglompkts:   %u\n"
+			"f2rxhdrs:     %u\nf2rxdata:     %u\n"
+			"f2txdata:     %u\nf1regdata:    %u\n"
+			"tickcnt:      %u\ntx_ctlerrs:   %lu\n"
+			"tx_ctlpkts:   %lu\nrx_ctlerrs:   %lu\n"
+			"rx_ctlpkts:   %lu\nrx_readahead: %lu\n",
+			sdcnt->intrcount, sdcnt->lastintrs,
+			sdcnt->pollcnt, sdcnt->regfails,
+			sdcnt->tx_sderrs, sdcnt->fcqueued,
+			sdcnt->rxrtx, sdcnt->rx_toolong,
+			sdcnt->rxc_errors, sdcnt->rx_hdrfail,
+			sdcnt->rx_badhdr, sdcnt->rx_badseq,
+			sdcnt->fc_rcvd, sdcnt->fc_xoff,
+			sdcnt->fc_xon, sdcnt->rxglomfail,
+			sdcnt->rxglomframes, sdcnt->rxglompkts,
+			sdcnt->f2rxhdrs, sdcnt->f2rxdata,
+			sdcnt->f2txdata, sdcnt->f1regdata,
+			sdcnt->tickcnt, sdcnt->tx_ctlerrs,
+			sdcnt->tx_ctlpkts, sdcnt->rx_ctlerrs,
+			sdcnt->rx_ctlpkts, sdcnt->rx_readahead_cnt);
+
+	return simple_read_from_buffer(data, count, ppos, buf, res);
+}
+
+static const struct file_operations brcmf_debugfs_sdio_counter_ops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = brcmf_debugfs_sdio_counter_read
+};
+
+void brcmf_debugfs_create_sdio_count(struct brcmf_pub *drvr,
+				     struct brcmf_sdio_count *sdcnt)
+{
+	struct dentry *dentry = drvr->dbgfs_dir;
+
+	if (!IS_ERR_OR_NULL(dentry))
+		debugfs_create_file("counters", S_IRUGO, dentry,
+				    sdcnt, &brcmf_debugfs_sdio_counter_ops);
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index 0efb226..b784920 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -76,6 +76,40 @@ do {									\
 
 extern int brcmf_msg_level;
 
+/*
+ * hold counter variables used in brcmfmac sdio driver.
+ */
+struct brcmf_sdio_count {
+	uint intrcount;		/* Count of device interrupt callbacks */
+	uint lastintrs;		/* Count as of last watchdog timer */
+	uint pollcnt;		/* Count of active polls */
+	uint regfails;		/* Count of R_REG failures */
+	uint tx_sderrs;		/* Count of tx attempts with sd errors */
+	uint fcqueued;		/* Tx packets that got queued */
+	uint rxrtx;		/* Count of rtx requests (NAK to dongle) */
+	uint rx_toolong;	/* Receive frames too long to receive */
+	uint rxc_errors;	/* SDIO errors when reading control frames */
+	uint rx_hdrfail;	/* SDIO errors on header reads */
+	uint rx_badhdr;		/* Bad received headers (roosync?) */
+	uint rx_badseq;		/* Mismatched rx sequence number */
+	uint fc_rcvd;		/* Number of flow-control events received */
+	uint fc_xoff;		/* Number which turned on flow-control */
+	uint fc_xon;		/* Number which turned off flow-control */
+	uint rxglomfail;	/* Failed deglom attempts */
+	uint rxglomframes;	/* Number of glom frames (superframes) */
+	uint rxglompkts;	/* Number of packets from glom frames */
+	uint f2rxhdrs;		/* Number of header reads */
+	uint f2rxdata;		/* Number of frame data reads */
+	uint f2txdata;		/* Number of f2 frame writes */
+	uint f1regdata;		/* Number of f1 register accesses */
+	uint tickcnt;		/* Number of watchdog been schedule */
+	ulong tx_ctlerrs;	/* Err of sending ctrl frames */
+	ulong tx_ctlpkts;	/* Ctrl frames sent to dongle */
+	ulong rx_ctlerrs;	/* Err of processing rx ctrl frames */
+	ulong rx_ctlpkts;	/* Ctrl frames processed from dongle */
+	ulong rx_readahead_cnt;	/* packets where header read-ahead was used */
+};
+
 struct brcmf_pub;
 #ifdef DEBUG
 void brcmf_debugfs_init(void);
@@ -83,6 +117,8 @@ void brcmf_debugfs_exit(void);
 int brcmf_debugfs_attach(struct brcmf_pub *drvr);
 void brcmf_debugfs_detach(struct brcmf_pub *drvr);
 struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
+void brcmf_debugfs_create_sdio_count(struct brcmf_pub *drvr,
+				     struct brcmf_sdio_count *sdcnt);
 #else
 static inline void brcmf_debugfs_init(void)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 1dbf2be..a07fb01 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -502,12 +502,9 @@ struct brcmf_sdio {
 	bool intr;		/* Use interrupts */
 	bool poll;		/* Use polling */
 	bool ipend;		/* Device interrupt is pending */
-	uint intrcount;		/* Count of device interrupt callbacks */
-	uint lastintrs;		/* Count as of last watchdog timer */
 	uint spurious;		/* Count of spurious interrupts */
 	uint pollrate;		/* Ticks between device polls */
 	uint polltick;		/* Tick counter */
-	uint pollcnt;		/* Count of active polls */
 
 #ifdef DEBUG
 	uint console_interval;
@@ -515,8 +512,6 @@ struct brcmf_sdio {
 	uint console_addr;	/* Console address from shared struct */
 #endif				/* DEBUG */
 
-	uint regfails;		/* Count of R_REG failures */
-
 	uint clkstate;		/* State of sd and backplane clock(s) */
 	bool activity;		/* Activity flag for clock down */
 	s32 idletime;		/* Control for activity timeout */
@@ -531,33 +526,6 @@ struct brcmf_sdio {
 /* Field to decide if rx of control frames happen in rxbuf or lb-pool */
 	bool usebufpool;
 
-	/* Some additional counters */
-	uint tx_sderrs;		/* Count of tx attempts with sd errors */
-	uint fcqueued;		/* Tx packets that got queued */
-	uint rxrtx;		/* Count of rtx requests (NAK to dongle) */
-	uint rx_toolong;	/* Receive frames too long to receive */
-	uint rxc_errors;	/* SDIO errors when reading control frames */
-	uint rx_hdrfail;	/* SDIO errors on header reads */
-	uint rx_badhdr;		/* Bad received headers (roosync?) */
-	uint rx_badseq;		/* Mismatched rx sequence number */
-	uint fc_rcvd;		/* Number of flow-control events received */
-	uint fc_xoff;		/* Number which turned on flow-control */
-	uint fc_xon;		/* Number which turned off flow-control */
-	uint rxglomfail;	/* Failed deglom attempts */
-	uint rxglomframes;	/* Number of glom frames (superframes) */
-	uint rxglompkts;	/* Number of packets from glom frames */
-	uint f2rxhdrs;		/* Number of header reads */
-	uint f2rxdata;		/* Number of frame data reads */
-	uint f2txdata;		/* Number of f2 frame writes */
-	uint f1regdata;		/* Number of f1 register accesses */
-	uint tickcnt;		/* Number of watchdog been schedule */
-	unsigned long tx_ctlerrs;	/* Err of sending ctrl frames */
-	unsigned long tx_ctlpkts;	/* Ctrl frames sent to dongle */
-	unsigned long rx_ctlerrs;	/* Err of processing rx ctrl frames */
-	unsigned long rx_ctlpkts;	/* Ctrl frames processed from dongle */
-	unsigned long rx_readahead_cnt;	/* Number of packets where header
-					 * read-ahead was used. */
-
 	u8 *ctrl_frame_buf;
 	u32 ctrl_frame_len;
 	bool ctrl_frame_stat;
@@ -583,6 +551,7 @@ struct brcmf_sdio {
 	u32 fw_ptr;
 
 	bool txoff;		/* Transmit flow-controlled */
+	struct brcmf_sdio_count sdcnt;
 };
 
 /* clkstate */
@@ -945,7 +914,7 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 	if (ret == 0)
 		w_sdreg32(bus, SMB_INT_ACK,
 			  offsetof(struct sdpcmd_regs, tosbmailbox));
-	bus->f1regdata += 2;
+	bus->sdcnt.f1regdata += 2;
 
 	/* Dongle recomposed rx frames, accept them again */
 	if (hmb_data & HMB_DATA_NAKHANDLED) {
@@ -984,12 +953,12 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 							HMB_DATA_FCDATA_SHIFT;
 
 		if (fcbits & ~bus->flowcontrol)
-			bus->fc_xoff++;
+			bus->sdcnt.fc_xoff++;
 
 		if (bus->flowcontrol & ~fcbits)
-			bus->fc_xon++;
+			bus->sdcnt.fc_xon++;
 
-		bus->fc_rcvd++;
+		bus->sdcnt.fc_rcvd++;
 		bus->flowcontrol = fcbits;
 	}
 
@@ -1021,7 +990,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 
 	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
 			 SFC_RF_TERM, &err);
-	bus->f1regdata++;
+	bus->sdcnt.f1regdata++;
 
 	/* Wait until the packet has been flushed (device/FIFO stable) */
 	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
@@ -1029,7 +998,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 				      SBSDIO_FUNC1_RFRAMEBCHI, &err);
 		lo = brcmf_sdio_regrb(bus->sdiodev,
 				      SBSDIO_FUNC1_RFRAMEBCLO, &err);
-		bus->f1regdata += 2;
+		bus->sdcnt.f1regdata += 2;
 
 		if ((hi == 0) && (lo == 0))
 			break;
@@ -1047,11 +1016,11 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 		brcmf_dbg(INFO, "flush took %d iterations\n", 0xffff - retries);
 
 	if (rtx) {
-		bus->rxrtx++;
+		bus->sdcnt.rxrtx++;
 		err = w_sdreg32(bus, SMB_NAK,
 				offsetof(struct sdpcmd_regs, tosbmailbox));
 
-		bus->f1regdata++;
+		bus->sdcnt.f1regdata++;
 		if (err == 0)
 			bus->rxskip = true;
 	}
@@ -1243,7 +1212,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				  dlen);
 			errcode = -1;
 		}
-		bus->f2rxdata++;
+		bus->sdcnt.f2rxdata++;
 
 		/* On failure, kill the superframe, allow a couple retries */
 		if (errcode < 0) {
@@ -1256,7 +1225,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			} else {
 				bus->glomerr = 0;
 				brcmf_sdbrcm_rxfail(bus, true, false);
-				bus->rxglomfail++;
+				bus->sdcnt.rxglomfail++;
 				brcmf_sdbrcm_free_glom(bus);
 			}
 			return 0;
@@ -1312,7 +1281,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		if (rxseq != seq) {
 			brcmf_dbg(INFO, "(superframe) rx_seq %d, expected %d\n",
 				  seq, rxseq);
-			bus->rx_badseq++;
+			bus->sdcnt.rx_badseq++;
 			rxseq = seq;
 		}
 
@@ -1376,7 +1345,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			} else {
 				bus->glomerr = 0;
 				brcmf_sdbrcm_rxfail(bus, true, false);
-				bus->rxglomfail++;
+				bus->sdcnt.rxglomfail++;
 				brcmf_sdbrcm_free_glom(bus);
 			}
 			bus->nextlen = 0;
@@ -1402,7 +1371,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			if (rxseq != seq) {
 				brcmf_dbg(GLOM, "rx_seq %d, expected %d\n",
 					  seq, rxseq);
-				bus->rx_badseq++;
+				bus->sdcnt.rx_badseq++;
 				rxseq = seq;
 			}
 			rxseq++;
@@ -1441,8 +1410,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			down(&bus->sdsem);
 		}
 
-		bus->rxglomframes++;
-		bus->rxglompkts += bus->glom.qlen;
+		bus->sdcnt.rxglomframes++;
+		bus->sdcnt.rxglompkts += bus->glom.qlen;
 	}
 	return num;
 }
@@ -1526,7 +1495,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 		brcmf_dbg(ERROR, "%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
 			  len, len - doff, bus->sdiodev->bus_if->maxctl);
 		bus->sdiodev->bus_if->dstats.rx_errors++;
-		bus->rx_toolong++;
+		bus->sdcnt.rx_toolong++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
 	}
@@ -1536,13 +1505,13 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 				bus->sdiodev->sbwad,
 				SDIO_FUNC_2,
 				F2SYNC, (bus->rxctl + BRCMF_FIRSTREAD), rdlen);
-	bus->f2rxdata++;
+	bus->sdcnt.f2rxdata++;
 
 	/* Control frame failures need retransmission */
 	if (sdret < 0) {
 		brcmf_dbg(ERROR, "read %d control bytes failed: %d\n",
 			  rdlen, sdret);
-		bus->rxc_errors++;
+		bus->sdcnt.rxc_errors++;
 		brcmf_sdbrcm_rxfail(bus, true, true);
 		goto done;
 	}
@@ -1589,7 +1558,7 @@ brcmf_alloc_pkt_and_read(struct brcmf_sdio *bus, u16 rdlen,
 	/* Read the entire frame */
 	sdret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
 				      SDIO_FUNC_2, F2SYNC, *pkt);
-	bus->f2rxdata++;
+	bus->sdcnt.f2rxdata++;
 
 	if (sdret < 0) {
 		brcmf_dbg(ERROR, "(nextlen): read %d bytes failed: %d\n",
@@ -1630,7 +1599,7 @@ brcmf_check_rxbuf(struct brcmf_sdio *bus, struct sk_buff *pkt, u8 *rxbuf,
 	if ((u16)~(*len ^ check)) {
 		brcmf_dbg(ERROR, "(nextlen): HW hdr error: nextlen/len/check 0x%04x/0x%04x/0x%04x\n",
 			  nextlen, *len, check);
-		bus->rx_badhdr++;
+		bus->sdcnt.rx_badhdr++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto fail;
 	}
@@ -1746,7 +1715,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 				bus->nextlen = 0;
 			}
 
-			bus->rx_readahead_cnt++;
+			bus->sdcnt.rx_readahead_cnt++;
 
 			/* Handle Flow Control */
 			fcbits = SDPCM_FCMASK_VALUE(
@@ -1754,12 +1723,12 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 
 			if (bus->flowcontrol != fcbits) {
 				if (~bus->flowcontrol & fcbits)
-					bus->fc_xoff++;
+					bus->sdcnt.fc_xoff++;
 
 				if (bus->flowcontrol & ~fcbits)
-					bus->fc_xon++;
+					bus->sdcnt.fc_xon++;
 
-				bus->fc_rcvd++;
+				bus->sdcnt.fc_rcvd++;
 				bus->flowcontrol = fcbits;
 			}
 
@@ -1767,7 +1736,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 			if (rxseq != seq) {
 				brcmf_dbg(INFO, "(nextlen): rx_seq %d, expected %d\n",
 					  seq, rxseq);
-				bus->rx_badseq++;
+				bus->sdcnt.rx_badseq++;
 				rxseq = seq;
 			}
 
@@ -1814,11 +1783,11 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
 					      SDIO_FUNC_2, F2SYNC, bus->rxhdr,
 					      BRCMF_FIRSTREAD);
-		bus->f2rxhdrs++;
+		bus->sdcnt.f2rxhdrs++;
 
 		if (sdret < 0) {
 			brcmf_dbg(ERROR, "RXHEADER FAILED: %d\n", sdret);
-			bus->rx_hdrfail++;
+			bus->sdcnt.rx_hdrfail++;
 			brcmf_sdbrcm_rxfail(bus, true, true);
 			continue;
 		}
@@ -1840,7 +1809,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 		if ((u16) ~(len ^ check)) {
 			brcmf_dbg(ERROR, "HW hdr err: len/check 0x%04x/0x%04x\n",
 				  len, check);
-			bus->rx_badhdr++;
+			bus->sdcnt.rx_badhdr++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
 		}
@@ -1861,7 +1830,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 		if ((doff < SDPCM_HDRLEN) || (doff > len)) {
 			brcmf_dbg(ERROR, "Bad data offset %d: HW len %d, min %d seq %d\n",
 				  doff, len, SDPCM_HDRLEN, seq);
-			bus->rx_badhdr++;
+			bus->sdcnt.rx_badhdr++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
 		}
@@ -1880,19 +1849,19 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 
 		if (bus->flowcontrol != fcbits) {
 			if (~bus->flowcontrol & fcbits)
-				bus->fc_xoff++;
+				bus->sdcnt.fc_xoff++;
 
 			if (bus->flowcontrol & ~fcbits)
-				bus->fc_xon++;
+				bus->sdcnt.fc_xon++;
 
-			bus->fc_rcvd++;
+			bus->sdcnt.fc_rcvd++;
 			bus->flowcontrol = fcbits;
 		}
 
 		/* Check and update sequence number */
 		if (rxseq != seq) {
 			brcmf_dbg(INFO, "rx_seq %d, expected %d\n", seq, rxseq);
-			bus->rx_badseq++;
+			bus->sdcnt.rx_badseq++;
 			rxseq = seq;
 		}
 
@@ -1937,7 +1906,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 			brcmf_dbg(ERROR, "too long: len %d rdlen %d\n",
 				  len, rdlen);
 			bus->sdiodev->bus_if->dstats.rx_errors++;
-			bus->rx_toolong++;
+			bus->sdcnt.rx_toolong++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
 		}
@@ -1960,7 +1929,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 		/* Read the remaining frame data */
 		sdret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
 					      SDIO_FUNC_2, F2SYNC, pkt);
-		bus->f2rxdata++;
+		bus->sdcnt.f2rxdata++;
 
 		if (sdret < 0) {
 			brcmf_dbg(ERROR, "read %d %s bytes failed: %d\n", rdlen,
@@ -2147,18 +2116,18 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 
 	ret = brcmf_sdcard_send_pkt(bus->sdiodev, bus->sdiodev->sbwad,
 				    SDIO_FUNC_2, F2SYNC, pkt);
-	bus->f2txdata++;
+	bus->sdcnt.f2txdata++;
 
 	if (ret < 0) {
 		/* On failure, abort the command and terminate the frame */
 		brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
 			  ret);
-		bus->tx_sderrs++;
+		bus->sdcnt.tx_sderrs++;
 
 		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
 				 SFC_WF_TERM, NULL);
-		bus->f1regdata++;
+		bus->sdcnt.f1regdata++;
 
 		for (i = 0; i < 3; i++) {
 			u8 hi, lo;
@@ -2166,7 +2135,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 					      SBSDIO_FUNC1_WFRAMEBCHI, NULL);
 			lo = brcmf_sdio_regrb(bus->sdiodev,
 					      SBSDIO_FUNC1_WFRAMEBCLO, NULL);
-			bus->f1regdata += 2;
+			bus->sdcnt.f1regdata += 2;
 			if ((hi == 0) && (lo == 0))
 				break;
 		}
@@ -2224,7 +2193,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 			ret = r_sdreg32(bus, &intstatus,
 					offsetof(struct sdpcmd_regs,
 						 intstatus));
-			bus->f2txdata++;
+			bus->sdcnt.f2txdata++;
 			if (ret != 0)
 				break;
 			if (intstatus & bus->hostintmask)
@@ -2417,7 +2386,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		bus->ipend = false;
 		err = r_sdreg32(bus, &newstatus,
 				offsetof(struct sdpcmd_regs, intstatus));
-		bus->f1regdata++;
+		bus->sdcnt.f1regdata++;
 		if (err != 0)
 			newstatus = 0;
 		newstatus &= bus->hostintmask;
@@ -2426,7 +2395,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			err = w_sdreg32(bus, newstatus,
 					offsetof(struct sdpcmd_regs,
 						 intstatus));
-			bus->f1regdata++;
+			bus->sdcnt.f1regdata++;
 		}
 	}
 
@@ -2445,7 +2414,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 
 		err = r_sdreg32(bus, &newstatus,
 				offsetof(struct sdpcmd_regs, intstatus));
-		bus->f1regdata += 2;
+		bus->sdcnt.f1regdata += 2;
 		bus->fcstate =
 		    !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE));
 		intstatus |= (newstatus & bus->hostintmask);
@@ -2510,13 +2479,13 @@ clkwait:
 				terminate the frame */
 			brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
 				  ret);
-			bus->tx_sderrs++;
+			bus->sdcnt.tx_sderrs++;
 
 			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 
 			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
 					 SFC_WF_TERM, &err);
-			bus->f1regdata++;
+			bus->sdcnt.f1regdata++;
 
 			for (i = 0; i < 3; i++) {
 				u8 hi, lo;
@@ -2526,7 +2495,7 @@ clkwait:
 				lo = brcmf_sdio_regrb(bus->sdiodev,
 						      SBSDIO_FUNC1_WFRAMEBCLO,
 						      &err);
-				bus->f1regdata += 2;
+				bus->sdcnt.f1regdata += 2;
 				if ((hi == 0) && (lo == 0))
 					break;
 			}
@@ -2657,7 +2626,7 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	/* Check for existing queue, current flow-control,
 			 pending event, or pending clock */
 	brcmf_dbg(TRACE, "deferring pktq len %d\n", pktq_len(&bus->txq));
-	bus->fcqueued++;
+	bus->sdcnt.fcqueued++;
 
 	/* Priority based enq */
 	spin_lock_bh(&bus->txqlock);
@@ -2845,13 +2814,13 @@ static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 		/* On failure, abort the command and terminate the frame */
 		brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
 			  ret);
-		bus->tx_sderrs++;
+		bus->sdcnt.tx_sderrs++;
 
 		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 
 		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
 				 SFC_WF_TERM, NULL);
-		bus->f1regdata++;
+		bus->sdcnt.f1regdata++;
 
 		for (i = 0; i < 3; i++) {
 			u8 hi, lo;
@@ -2859,7 +2828,7 @@ static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 					      SBSDIO_FUNC1_WFRAMEBCHI, NULL);
 			lo = brcmf_sdio_regrb(bus->sdiodev,
 					      SBSDIO_FUNC1_WFRAMEBCLO, NULL);
-			bus->f1regdata += 2;
+			bus->sdcnt.f1regdata += 2;
 			if (hi == 0 && lo == 0)
 				break;
 		}
@@ -2976,13 +2945,26 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	up(&bus->sdsem);
 
 	if (ret)
-		bus->tx_ctlerrs++;
+		bus->sdcnt.tx_ctlerrs++;
 	else
-		bus->tx_ctlpkts++;
+		bus->sdcnt.tx_ctlpkts++;
 
 	return ret ? -EIO : 0;
 }
 
+#ifdef DEBUG
+static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
+{
+	struct brcmf_pub *drvr = bus->sdiodev->bus_if->drvr;
+
+	brcmf_debugfs_create_sdio_count(drvr, &bus->sdcnt);
+}
+#else
+static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
+{
+}
+#endif /* DEBUG */
+
 static int
 brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 {
@@ -3017,9 +2999,9 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	}
 
 	if (rxlen)
-		bus->rx_ctlpkts++;
+		bus->sdcnt.rx_ctlpkts++;
 	else
-		bus->rx_ctlerrs++;
+		bus->sdcnt.rx_ctlerrs++;
 
 	return rxlen ? (int)rxlen : -ETIMEDOUT;
 }
@@ -3419,7 +3401,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		return 0;
 
 	/* Start the watchdog timer */
-	bus->tickcnt = 0;
+	bus->sdcnt.tickcnt = 0;
 	brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 
 	down(&bus->sdsem);
@@ -3512,7 +3494,7 @@ void brcmf_sdbrcm_isr(void *arg)
 		return;
 	}
 	/* Count the interrupt call */
-	bus->intrcount++;
+	bus->sdcnt.intrcount++;
 	bus->ipend = true;
 
 	/* Shouldn't get this interrupt if we're sleeping? */
@@ -3554,7 +3536,8 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 		bus->polltick = 0;
 
 		/* Check device if no interrupts */
-		if (!bus->intr || (bus->intrcount == bus->lastintrs)) {
+		if (!bus->intr ||
+		    (bus->sdcnt.intrcount == bus->sdcnt.lastintrs)) {
 
 			if (!bus->dpc_sched) {
 				u8 devpend;
@@ -3569,7 +3552,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 			/* If there is something, make like the ISR and
 				 schedule the DPC */
 			if (intstatus) {
-				bus->pollcnt++;
+				bus->sdcnt.pollcnt++;
 				bus->ipend = true;
 
 				bus->dpc_sched = true;
@@ -3581,7 +3564,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 		}
 
 		/* Update interrupt tracking */
-		bus->lastintrs = bus->intrcount;
+		bus->sdcnt.lastintrs = bus->sdcnt.intrcount;
 	}
 #ifdef DEBUG
 	/* Poll for console output periodically */
@@ -3793,7 +3776,7 @@ brcmf_sdbrcm_watchdog_thread(void *data)
 		if (!wait_for_completion_interruptible(&bus->watchdog_wait)) {
 			brcmf_sdbrcm_bus_watchdog(bus);
 			/* Count the tick for reference */
-			bus->tickcnt++;
+			bus->sdcnt.tickcnt++;
 		} else
 			break;
 	}
@@ -3834,7 +3817,6 @@ static void brcmf_sdbrcm_release_dongle(struct brcmf_sdio *bus)
 static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
-
 	if (bus) {
 		/* De-register interrupt handler */
 		brcmf_sdio_intr_unregister(bus->sdiodev);
@@ -3938,6 +3920,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 		goto fail;
 	}
 
+	brcmf_sdio_debugfs_create(bus);
 	brcmf_dbg(INFO, "completed!!\n");
 
 	/* if firmware path present try to download and bring up bus */
-- 
1.7.9.5


