Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:38819 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3LLK7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:20 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 16/18] brcmfmac: use consistent function names in dhd_sdio.c
Date: Thu, 12 Dec 2013 11:59:04 +0100
Message-ID: <1386845946-9859-17-git-send-email-arend@broadcom.com> (sfid-20131212_122500_582999_4DD7A4BB)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Functions in dhd_sdio.c that are called with struct brcmf_sdio
instance are renamed consistently with brcmf_sdio_ prefix.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   12 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  346 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    9 +-
 3 files changed, 178 insertions(+), 189 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 9c41438..e07bad2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -72,7 +72,7 @@ static irqreturn_t brcmf_sdiod_oob_irqhandler(int irq, void *dev_id)
 		sdiodev->irq_en = false;
 	}
 
-	brcmf_sdbrcm_isr(sdiodev->bus);
+	brcmf_sdio_isr(sdiodev->bus);
 
 	return IRQ_HANDLED;
 }
@@ -84,7 +84,7 @@ static void brcmf_sdiod_ib_irqhandler(struct sdio_func *func)
 
 	brcmf_dbg(INTR, "IB intr triggered\n");
 
-	brcmf_sdbrcm_isr(sdiodev->bus);
+	brcmf_sdio_isr(sdiodev->bus);
 }
 
 /* dummy handler for SDIO function 2 interrupt */
@@ -901,7 +901,7 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 
 	if (sdiodev->bus) {
-		brcmf_sdbrcm_disconnect(sdiodev->bus);
+		brcmf_sdio_disconnect(sdiodev->bus);
 		sdiodev->bus = NULL;
 	}
 
@@ -971,7 +971,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->max_segment_size = host->max_seg_size;
 
 	/* try to attach to the target device */
-	sdiodev->bus = brcmf_sdbrcm_probe(sdiodev);
+	sdiodev->bus = brcmf_sdio_probe(sdiodev);
 	if (!sdiodev->bus) {
 		ret = -ENODEV;
 		goto out;
@@ -1117,7 +1117,7 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 		return ret;
 	}
 
-	brcmf_sdbrcm_wd_timer(sdiodev->bus, 0);
+	brcmf_sdio_wd_timer(sdiodev->bus, 0);
 
 	return ret;
 }
@@ -1127,7 +1127,7 @@ static int brcmf_ops_sdio_resume(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 
-	brcmf_sdbrcm_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
+	brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
 	atomic_set(&sdiodev->suspend, false);
 	return 0;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 7fff4cc..f3069b4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -556,7 +556,7 @@ static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 };
 
 
-static const struct firmware *brcmf_sdbrcm_get_fw(struct brcmf_sdio *bus,
+static const struct firmware *brcmf_sdio_get_fw(struct brcmf_sdio *bus,
 						  enum brcmf_firmware_type type)
 {
 	const struct firmware *fw;
@@ -641,7 +641,7 @@ w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
 }
 
 static int
-brcmf_sdbrcm_kso_control(struct brcmf_sdio *bus, bool on)
+brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 {
 	u8 wr_val = 0, rd_val, cmp_val, bmask;
 	int err = 0;
@@ -701,7 +701,7 @@ brcmf_sdbrcm_kso_control(struct brcmf_sdio *bus, bool on)
 #define HOSTINTMASK		(I_HMB_SW_MASK | I_CHIPACTIVE)
 
 /* Turn backplane clock on or off */
-static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
+static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 {
 	int err;
 	u8 clkctl, clkreq, devctl;
@@ -823,7 +823,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 }
 
 /* Change idle/active SD state */
-static int brcmf_sdbrcm_sdclk(struct brcmf_sdio *bus, bool on)
+static int brcmf_sdio_sdclk(struct brcmf_sdio *bus, bool on)
 {
 	brcmf_dbg(SDIO, "Enter\n");
 
@@ -836,7 +836,7 @@ static int brcmf_sdbrcm_sdclk(struct brcmf_sdio *bus, bool on)
 }
 
 /* Transition SD and backplane clock readiness */
-static int brcmf_sdbrcm_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
+static int brcmf_sdio_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 {
 #ifdef DEBUG
 	uint oldstate = bus->clkstate;
@@ -847,7 +847,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 	/* Early exit if we're already there */
 	if (bus->clkstate == target) {
 		if (target == CLK_AVAIL) {
-			brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
+			brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
 			bus->activity = true;
 		}
 		return 0;
@@ -857,32 +857,32 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 	case CLK_AVAIL:
 		/* Make sure SD clock is available */
 		if (bus->clkstate == CLK_NONE)
-			brcmf_sdbrcm_sdclk(bus, true);
+			brcmf_sdio_sdclk(bus, true);
 		/* Now request HT Avail on the backplane */
-		brcmf_sdbrcm_htclk(bus, true, pendok);
-		brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
+		brcmf_sdio_htclk(bus, true, pendok);
+		brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
 		bus->activity = true;
 		break;
 
 	case CLK_SDONLY:
 		/* Remove HT request, or bring up SD clock */
 		if (bus->clkstate == CLK_NONE)
-			brcmf_sdbrcm_sdclk(bus, true);
+			brcmf_sdio_sdclk(bus, true);
 		else if (bus->clkstate == CLK_AVAIL)
-			brcmf_sdbrcm_htclk(bus, false, false);
+			brcmf_sdio_htclk(bus, false, false);
 		else
 			brcmf_err("request for %d -> %d\n",
 				  bus->clkstate, target);
-		brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
+		brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
 		break;
 
 	case CLK_NONE:
 		/* Make sure to remove HT request */
 		if (bus->clkstate == CLK_AVAIL)
-			brcmf_sdbrcm_htclk(bus, false, false);
+			brcmf_sdio_htclk(bus, false, false);
 		/* Now remove the SD clock */
-		brcmf_sdbrcm_sdclk(bus, false);
-		brcmf_sdbrcm_wd_timer(bus, 0);
+		brcmf_sdio_sdclk(bus, false);
+		brcmf_sdio_wd_timer(bus, 0);
 		break;
 	}
 #ifdef DEBUG
@@ -893,7 +893,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 }
 
 static int
-brcmf_sdbrcm_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
+brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 {
 	int err = 0;
 	brcmf_dbg(TRACE, "Enter\n");
@@ -916,13 +916,13 @@ brcmf_sdbrcm_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 			    brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
 			    data_ok(bus)))
 				 return -EBUSY;
-			err = brcmf_sdbrcm_kso_control(bus, false);
+			err = brcmf_sdio_kso_control(bus, false);
 			/* disable watchdog */
 			if (!err)
-				brcmf_sdbrcm_wd_timer(bus, 0);
+				brcmf_sdio_wd_timer(bus, 0);
 		} else {
 			bus->idlecount = 0;
-			err = brcmf_sdbrcm_kso_control(bus, true);
+			err = brcmf_sdio_kso_control(bus, true);
 		}
 		if (!err) {
 			/* Change state */
@@ -940,16 +940,16 @@ end:
 	/* control clocks */
 	if (sleep) {
 		if (!bus->sr_enabled)
-			brcmf_sdbrcm_clkctl(bus, CLK_NONE, pendok);
+			brcmf_sdio_clkctl(bus, CLK_NONE, pendok);
 	} else {
-		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, pendok);
+		brcmf_sdio_clkctl(bus, CLK_AVAIL, pendok);
 	}
 
 	return err;
 
 }
 
-static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
+static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 {
 	u32 intstatus = 0;
 	u32 hmb_data;
@@ -1025,7 +1025,7 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 	return intstatus;
 }
 
-static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
+static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 {
 	uint retries = 0;
 	u16 lastrbc;
@@ -1085,7 +1085,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 }
 
 /* return total length of buffer chain */
-static uint brcmf_sdbrcm_glom_len(struct brcmf_sdio *bus)
+static uint brcmf_sdio_glom_len(struct brcmf_sdio *bus)
 {
 	struct sk_buff *p;
 	uint total;
@@ -1096,7 +1096,7 @@ static uint brcmf_sdbrcm_glom_len(struct brcmf_sdio *bus)
 	return total;
 }
 
-static void brcmf_sdbrcm_free_glom(struct brcmf_sdio *bus)
+static void brcmf_sdio_free_glom(struct brcmf_sdio *bus)
 {
 	struct sk_buff *cur, *next;
 
@@ -1184,7 +1184,7 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 	if ((u16)(~(len ^ checksum))) {
 		brcmf_err("HW header checksum error\n");
 		bus->sdcnt.rx_badhdr++;
-		brcmf_sdbrcm_rxfail(bus, false, false);
+		brcmf_sdio_rxfail(bus, false, false);
 		return -EIO;
 	}
 	if (len < SDPCM_HDRLEN) {
@@ -1216,7 +1216,7 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 	    type != BRCMF_SDIO_FT_SUPER) {
 		brcmf_err("HW header length too long\n");
 		bus->sdcnt.rx_toolong++;
-		brcmf_sdbrcm_rxfail(bus, false, false);
+		brcmf_sdio_rxfail(bus, false, false);
 		rd->len = 0;
 		return -EPROTO;
 	}
@@ -1235,7 +1235,7 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 	if (rd->dat_offset < SDPCM_HDRLEN || rd->dat_offset > rd->len) {
 		brcmf_err("seq %d: bad data offset\n", rx_seq);
 		bus->sdcnt.rx_badhdr++;
-		brcmf_sdbrcm_rxfail(bus, false, false);
+		brcmf_sdio_rxfail(bus, false, false);
 		rd->len = 0;
 		return -ENXIO;
 	}
@@ -1308,7 +1308,7 @@ static void brcmf_sdio_hdpack(struct brcmf_sdio *bus, u8 *header,
 	trace_brcmf_sdpcm_hdr(SDPCM_TX + !!(bus->txglom), header);
 }
 
-static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
+static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 {
 	u16 dlen, totlen;
 	u8 *dptr, num = 0;
@@ -1388,7 +1388,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			}
 			pfirst = pnext = NULL;
 		} else {
-			brcmf_sdbrcm_free_glom(bus);
+			brcmf_sdio_free_glom(bus);
 			num = 0;
 		}
 
@@ -1411,7 +1411,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		}
 
 		pfirst = skb_peek(&bus->glom);
-		dlen = (u16) brcmf_sdbrcm_glom_len(bus);
+		dlen = (u16) brcmf_sdio_glom_len(bus);
 
 		/* Do an SDIO read for the superframe.  Configurable iovar to
 		 * read directly into the chained packet, or allocate a large
@@ -1430,12 +1430,12 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 			sdio_claim_host(bus->sdiodev->func[1]);
 			if (bus->glomerr++ < 3) {
-				brcmf_sdbrcm_rxfail(bus, true, true);
+				brcmf_sdio_rxfail(bus, true, true);
 			} else {
 				bus->glomerr = 0;
-				brcmf_sdbrcm_rxfail(bus, true, false);
+				brcmf_sdio_rxfail(bus, true, false);
 				bus->sdcnt.rxglomfail++;
-				brcmf_sdbrcm_free_glom(bus);
+				brcmf_sdio_free_glom(bus);
 			}
 			sdio_release_host(bus->sdiodev->func[1]);
 			return 0;
@@ -1483,12 +1483,12 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			if (bus->glomerr++ < 3) {
 				/* Restore superframe header space */
 				skb_push(pfirst, sfdoff);
-				brcmf_sdbrcm_rxfail(bus, true, true);
+				brcmf_sdio_rxfail(bus, true, true);
 			} else {
 				bus->glomerr = 0;
-				brcmf_sdbrcm_rxfail(bus, true, false);
+				brcmf_sdio_rxfail(bus, true, false);
 				bus->sdcnt.rxglomfail++;
-				brcmf_sdbrcm_free_glom(bus);
+				brcmf_sdio_free_glom(bus);
 			}
 			sdio_release_host(bus->sdiodev->func[1]);
 			bus->cur_read.len = 0;
@@ -1532,8 +1532,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 	return num;
 }
 
-static int brcmf_sdbrcm_dcmd_resp_wait(struct brcmf_sdio *bus, uint *condition,
-					bool *pending)
+static int brcmf_sdio_dcmd_resp_wait(struct brcmf_sdio *bus, uint *condition,
+				     bool *pending)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	int timeout = msecs_to_jiffies(DCMD_RESP_TIMEOUT);
@@ -1554,7 +1554,7 @@ static int brcmf_sdbrcm_dcmd_resp_wait(struct brcmf_sdio *bus, uint *condition,
 	return timeout;
 }
 
-static int brcmf_sdbrcm_dcmd_resp_wake(struct brcmf_sdio *bus)
+static int brcmf_sdio_dcmd_resp_wake(struct brcmf_sdio *bus)
 {
 	if (waitqueue_active(&bus->dcmd_resp_wait))
 		wake_up_interruptible(&bus->dcmd_resp_wait);
@@ -1562,7 +1562,7 @@ static int brcmf_sdbrcm_dcmd_resp_wake(struct brcmf_sdio *bus)
 	return 0;
 }
 static void
-brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
+brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 {
 	uint rdlen, pad;
 	u8 *buf = NULL, *rbuf;
@@ -1600,7 +1600,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	if ((rdlen + BRCMF_FIRSTREAD) > bus->sdiodev->bus_if->maxctl) {
 		brcmf_err("%d-byte control read exceeds %d-byte buffer\n",
 			  rdlen, bus->sdiodev->bus_if->maxctl);
-		brcmf_sdbrcm_rxfail(bus, false, false);
+		brcmf_sdio_rxfail(bus, false, false);
 		goto done;
 	}
 
@@ -1608,7 +1608,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 		brcmf_err("%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
 			  len, len - doff, bus->sdiodev->bus_if->maxctl);
 		bus->sdcnt.rx_toolong++;
-		brcmf_sdbrcm_rxfail(bus, false, false);
+		brcmf_sdio_rxfail(bus, false, false);
 		goto done;
 	}
 
@@ -1621,7 +1621,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 		brcmf_err("read %d control bytes failed: %d\n",
 			  rdlen, sdret);
 		bus->sdcnt.rxc_errors++;
-		brcmf_sdbrcm_rxfail(bus, true, true);
+		brcmf_sdio_rxfail(bus, true, true);
 		goto done;
 	} else
 		memcpy(buf + BRCMF_FIRSTREAD, rbuf, rdlen);
@@ -1646,11 +1646,11 @@ gotpkt:
 
 done:
 	/* Awake any waiters */
-	brcmf_sdbrcm_dcmd_resp_wake(bus);
+	brcmf_sdio_dcmd_resp_wake(bus);
 }
 
 /* Pad read to blocksize for efficiency */
-static void brcmf_pad(struct brcmf_sdio *bus, u16 *pad, u16 *rdlen)
+static void brcmf_sdio_pad(struct brcmf_sdio *bus, u16 *pad, u16 *rdlen)
 {
 	if (bus->roundup && bus->blocksize && *rdlen > bus->blocksize) {
 		*pad = bus->blocksize - (*rdlen % bus->blocksize);
@@ -1687,7 +1687,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			u8 cnt;
 			brcmf_dbg(GLOM, "calling rxglom: glomd %p, glom %p\n",
 				  bus->glomd, skb_peek(&bus->glom));
-			cnt = brcmf_sdbrcm_rxglom(bus, rd->seq_num);
+			cnt = brcmf_sdio_rxglom(bus, rd->seq_num);
 			brcmf_dbg(GLOM, "rxglom returned %d\n", cnt);
 			rd->seq_num += cnt - 1;
 			rxleft = (rxleft > cnt) ? (rxleft - cnt) : 1;
@@ -1705,7 +1705,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 				brcmf_err("RXHEADER FAILED: %d\n",
 					  ret);
 				bus->sdcnt.rx_hdrfail++;
-				brcmf_sdbrcm_rxfail(bus, true, true);
+				brcmf_sdio_rxfail(bus, true, true);
 				sdio_release_host(bus->sdiodev->func[1]);
 				continue;
 			}
@@ -1724,9 +1724,9 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			}
 
 			if (rd->channel == SDPCM_CONTROL_CHANNEL) {
-				brcmf_sdbrcm_read_control(bus, bus->rxhdr,
-							  rd->len,
-							  rd->dat_offset);
+				brcmf_sdio_read_control(bus, bus->rxhdr,
+							rd->len,
+							rd->dat_offset);
 				/* prepare the descriptor for the next read */
 				rd->len = rd->len_nxtfrm << 4;
 				rd->len_nxtfrm = 0;
@@ -1740,14 +1740,14 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			head_read = BRCMF_FIRSTREAD;
 		}
 
-		brcmf_pad(bus, &pad, &rd->len_left);
+		brcmf_sdio_pad(bus, &pad, &rd->len_left);
 
 		pkt = brcmu_pkt_buf_get_skb(rd->len_left + head_read +
 					    bus->head_align);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
 			brcmf_err("brcmu_pkt_buf_get_skb failed\n");
-			brcmf_sdbrcm_rxfail(bus, false,
+			brcmf_sdio_rxfail(bus, false,
 					    RETRYCHAN(rd->channel));
 			sdio_release_host(bus->sdiodev->func[1]);
 			continue;
@@ -1764,7 +1764,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 				  rd->len, rd->channel, ret);
 			brcmu_pkt_buf_free_skb(pkt);
 			sdio_claim_host(bus->sdiodev->func[1]);
-			brcmf_sdbrcm_rxfail(bus, true,
+			brcmf_sdio_rxfail(bus, true,
 					    RETRYCHAN(rd->channel));
 			sdio_release_host(bus->sdiodev->func[1]);
 			continue;
@@ -1789,7 +1789,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  rd->len,
 					  roundup(rd_new.len, 16) >> 4);
 				rd->len = 0;
-				brcmf_sdbrcm_rxfail(bus, true, true);
+				brcmf_sdio_rxfail(bus, true, true);
 				sdio_release_host(bus->sdiodev->func[1]);
 				brcmu_pkt_buf_free_skb(pkt);
 				continue;
@@ -1811,7 +1811,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 				/* Force retry w/normal header read */
 				rd->len = 0;
 				sdio_claim_host(bus->sdiodev->func[1]);
-				brcmf_sdbrcm_rxfail(bus, false, true);
+				brcmf_sdio_rxfail(bus, false, true);
 				sdio_release_host(bus->sdiodev->func[1]);
 				brcmu_pkt_buf_free_skb(pkt);
 				continue;
@@ -1836,7 +1836,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 				brcmf_err("%s: glom superframe w/o "
 					  "descriptor!\n", __func__);
 				sdio_claim_host(bus->sdiodev->func[1]);
-				brcmf_sdbrcm_rxfail(bus, false, false);
+				brcmf_sdio_rxfail(bus, false, false);
 				sdio_release_host(bus->sdiodev->func[1]);
 			}
 			/* prepare the descriptor for the next read */
@@ -1880,7 +1880,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 }
 
 static void
-brcmf_sdbrcm_wait_event_wakeup(struct brcmf_sdio *bus)
+brcmf_sdio_wait_event_wakeup(struct brcmf_sdio *bus)
 {
 	if (waitqueue_active(&bus->ctrl_wait))
 		wake_up_interruptible(&bus->ctrl_wait);
@@ -2096,8 +2096,8 @@ brcmf_sdio_txpkt_postp(struct brcmf_sdio *bus, struct sk_buff_head *pktq)
 
 /* Writes a HW/SW header into the packet and sends it. */
 /* Assumes: (a) header space already there, (b) caller holds lock */
-static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
-			      uint chan)
+static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
+			    uint chan)
 {
 	int ret;
 	int i;
@@ -2148,7 +2148,7 @@ done:
 	return ret;
 }
 
-static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
+static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 {
 	struct sk_buff *pkt;
 	struct sk_buff_head pktq;
@@ -2182,7 +2182,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		if (i == 0)
 			break;
 
-		ret = brcmf_sdbrcm_txpkt(bus, &pktq, SDPCM_DATA_CHANNEL);
+		ret = brcmf_sdio_txpkt(bus, &pktq, SDPCM_DATA_CHANNEL);
 		cnt += i;
 
 		/* In poll mode, need to check for other events */
@@ -2211,7 +2211,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	return cnt;
 }
 
-static void brcmf_sdbrcm_bus_stop(struct device *dev)
+static void brcmf_sdio_bus_stop(struct device *dev)
 {
 	u32 local_hostintmask;
 	u8 saveclk;
@@ -2231,7 +2231,7 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* Enable clock for device interrupts */
-	brcmf_sdbrcm_bus_sleep(bus, false, false);
+	brcmf_sdio_bus_sleep(bus, false, false);
 
 	/* Disable and clear interrupts at the chip level also */
 	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask));
@@ -2260,7 +2260,7 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 		  offsetof(struct sdpcmd_regs, intstatus));
 
 	/* Turn off the backplane clock (only) */
-	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
+	brcmf_sdio_clkctl(bus, CLK_SDONLY, false);
 	sdio_release_host(bus->sdiodev->func[1]);
 
 	/* Clear the data packet queues */
@@ -2269,20 +2269,20 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	/* Clear any held glomming stuff */
 	if (bus->glomd)
 		brcmu_pkt_buf_free_skb(bus->glomd);
-	brcmf_sdbrcm_free_glom(bus);
+	brcmf_sdio_free_glom(bus);
 
 	/* Clear rx control and wake any waiters */
 	spin_lock_bh(&bus->rxctl_lock);
 	bus->rxlen = 0;
 	spin_unlock_bh(&bus->rxctl_lock);
-	brcmf_sdbrcm_dcmd_resp_wake(bus);
+	brcmf_sdio_dcmd_resp_wake(bus);
 
 	/* Reset some F2 state stuff */
 	bus->rxskip = false;
 	bus->tx_seq = bus->rx_seq = 0;
 }
 
-static inline void brcmf_sdbrcm_clrintr(struct brcmf_sdio *bus)
+static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 {
 	unsigned long flags;
 
@@ -2331,7 +2331,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	return ret;
 }
 
-static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
+static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 {
 	u32 newstatus = 0;
 	unsigned long intstatus;
@@ -2391,7 +2391,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	}
 
 	/* Make sure backplane clock is on */
-	brcmf_sdbrcm_bus_sleep(bus, false, true);
+	brcmf_sdio_bus_sleep(bus, false, true);
 
 	/* Pending interrupt indicates new device status */
 	if (atomic_read(&bus->ipend) > 0) {
@@ -2422,7 +2422,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	/* Handle host mailbox indication */
 	if (intstatus & I_HMB_HOST_INT) {
 		intstatus &= ~I_HMB_HOST_INT;
-		intstatus |= brcmf_sdbrcm_hostmail(bus);
+		intstatus |= brcmf_sdio_hostmail(bus);
 	}
 
 	sdio_release_host(bus->sdiodev->func[1]);
@@ -2467,7 +2467,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			set_bit(n, (unsigned long *)&bus->intstatus.counter);
 	}
 
-	brcmf_sdbrcm_clrintr(bus);
+	brcmf_sdio_clrintr(bus);
 
 	if (data_ok(bus) && bus->ctrl_frame_stat &&
 		(bus->clkstate == CLK_AVAIL)) {
@@ -2508,7 +2508,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		}
 		sdio_release_host(bus->sdiodev->func[1]);
 		bus->ctrl_frame_stat = false;
-		brcmf_sdbrcm_wait_event_wakeup(bus);
+		brcmf_sdio_wait_event_wakeup(bus);
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
 	else if ((bus->clkstate == CLK_AVAIL) && !atomic_read(&bus->fcstate) &&
@@ -2516,7 +2516,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		 && data_ok(bus)) {
 		framecnt = bus->rxpending ? min(txlimit, bus->txminmax) :
 					    txlimit;
-		framecnt = brcmf_sdbrcm_sendfromq(bus, framecnt);
+		framecnt = brcmf_sdio_sendfromq(bus, framecnt);
 		txlimit -= framecnt;
 	}
 
@@ -2538,12 +2538,12 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		bus->activity = false;
 		brcmf_dbg(SDIO, "idle state\n");
 		sdio_claim_host(bus->sdiodev->func[1]);
-		brcmf_sdbrcm_bus_sleep(bus, true, false);
+		brcmf_sdio_bus_sleep(bus, true, false);
 		sdio_release_host(bus->sdiodev->func[1]);
 	}
 }
 
-static struct pktq *brcmf_sdbrcm_bus_gettxq(struct device *dev)
+static struct pktq *brcmf_sdio_bus_gettxq(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
@@ -2552,7 +2552,7 @@ static struct pktq *brcmf_sdbrcm_bus_gettxq(struct device *dev)
 	return &bus->txq;
 }
 
-static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
+static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 {
 	int ret = -EBADE;
 	uint datalen, prec;
@@ -2608,7 +2608,7 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 #ifdef DEBUG
 #define CONSOLE_LINE_MAX	192
 
-static int brcmf_sdbrcm_readconsole(struct brcmf_sdio *bus)
+static int brcmf_sdio_readconsole(struct brcmf_sdio *bus)
 {
 	struct brcmf_console *c = &bus->console;
 	u8 line[CONSOLE_LINE_MAX], ch;
@@ -2685,7 +2685,7 @@ break2:
 }
 #endif				/* DEBUG */
 
-static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
+static int brcmf_sdio_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 {
 	int i;
 	int ret;
@@ -2724,7 +2724,7 @@ static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 }
 
 static int
-brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
+brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 {
 	u8 *frame;
 	u16 len, pad;
@@ -2768,7 +2768,7 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 
 	/* Make sure backplane clock is on */
 	sdio_claim_host(bus->sdiodev->func[1]);
-	brcmf_sdbrcm_bus_sleep(bus, false, false);
+	brcmf_sdio_bus_sleep(bus, false, false);
 	sdio_release_host(bus->sdiodev->func[1]);
 
 	hd_info.len = (u16)msglen;
@@ -2812,7 +2812,7 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 
 		do {
 			sdio_claim_host(bus->sdiodev->func[1]);
-			ret = brcmf_tx_frame(bus, frame, len);
+			ret = brcmf_sdio_tx_frame(bus, frame, len);
 			sdio_release_host(bus->sdiodev->func[1]);
 		} while (ret < 0 && retries++ < TXRETRIES);
 	}
@@ -2822,7 +2822,7 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 		bus->activity = false;
 		sdio_claim_host(bus->sdiodev->func[1]);
 		brcmf_dbg(INFO, "idle\n");
-		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
+		brcmf_sdio_clkctl(bus, CLK_NONE, true);
 		sdio_release_host(bus->sdiodev->func[1]);
 	}
 
@@ -2856,7 +2856,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	 * address of sdpcm_shared structure
 	 */
 	sdio_claim_host(bus->sdiodev->func[1]);
-	brcmf_sdbrcm_bus_sleep(bus, false, false);
+	brcmf_sdio_bus_sleep(bus, false, false);
 	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, shaddr, (u8 *)&addr_le, 4);
 	sdio_release_host(bus->sdiodev->func[1]);
 	if (rv < 0)
@@ -3044,7 +3044,7 @@ static int brcmf_sdio_assert_info(struct brcmf_sdio *bus,
 	return simple_read_from_buffer(data, count, &pos, buf, res);
 }
 
-static int brcmf_sdbrcm_checkdied(struct brcmf_sdio *bus)
+static int brcmf_sdio_checkdied(struct brcmf_sdio *bus)
 {
 	int error;
 	struct sdpcm_shared sh;
@@ -3065,8 +3065,8 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_sdio *bus)
 	return 0;
 }
 
-static int brcmf_sdbrcm_died_dump(struct brcmf_sdio *bus, char __user *data,
-				  size_t count, loff_t *ppos)
+static int brcmf_sdio_died_dump(struct brcmf_sdio *bus, char __user *data,
+				size_t count, loff_t *ppos)
 {
 	int error = 0;
 	struct sdpcm_shared sh;
@@ -3107,7 +3107,7 @@ static ssize_t brcmf_sdio_forensic_read(struct file *f, char __user *data,
 	struct brcmf_sdio *bus = f->private_data;
 	int res;
 
-	res = brcmf_sdbrcm_died_dump(bus, data, count, ppos);
+	res = brcmf_sdio_died_dump(bus, data, count, ppos);
 	if (res > 0)
 		*ppos += res;
 	return (ssize_t)res;
@@ -3132,7 +3132,7 @@ static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
 	brcmf_debugfs_create_sdio_count(drvr, &bus->sdcnt);
 }
 #else
-static int brcmf_sdbrcm_checkdied(struct brcmf_sdio *bus)
+static int brcmf_sdio_checkdied(struct brcmf_sdio *bus)
 {
 	return 0;
 }
@@ -3143,7 +3143,7 @@ static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
 #endif /* DEBUG */
 
 static int
-brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
+brcmf_sdio_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 {
 	int timeleft;
 	uint rxlen = 0;
@@ -3156,7 +3156,7 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Wait until control frame is available */
-	timeleft = brcmf_sdbrcm_dcmd_resp_wait(bus, &bus->rxlen, &pending);
+	timeleft = brcmf_sdio_dcmd_resp_wait(bus, &bus->rxlen, &pending);
 
 	spin_lock_bh(&bus->rxctl_lock);
 	rxlen = bus->rxlen;
@@ -3173,13 +3173,13 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 			  rxlen, msglen);
 	} else if (timeleft == 0) {
 		brcmf_err("resumed on timeout\n");
-		brcmf_sdbrcm_checkdied(bus);
+		brcmf_sdio_checkdied(bus);
 	} else if (pending) {
 		brcmf_dbg(CTL, "cancelled\n");
 		return -ERESTARTSYS;
 	} else {
 		brcmf_dbg(CTL, "resumed for unknown reason?\n");
-		brcmf_sdbrcm_checkdied(bus);
+		brcmf_sdio_checkdied(bus);
 	}
 
 	if (rxlen)
@@ -3190,7 +3190,7 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	return rxlen ? (int)rxlen : -ETIMEDOUT;
 }
 
-static bool brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
+static bool brcmf_sdio_download_state(struct brcmf_sdio *bus, bool enter)
 {
 	struct chip_info *ci = bus->ci;
 
@@ -3215,7 +3215,7 @@ static bool brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
 	return true;
 }
 
-static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
+static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus)
 {
 	const struct firmware *fw;
 	int err;
@@ -3223,7 +3223,7 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
 	int address;
 	int len;
 
-	fw = brcmf_sdbrcm_get_fw(bus, BRCMF_FIRMWARE_BIN);
+	fw = brcmf_sdio_get_fw(bus, BRCMF_FIRMWARE_BIN);
 	if (fw == NULL)
 		return -ENOENT;
 
@@ -3263,8 +3263,8 @@ failure:
  * by two NULs.
 */
 
-static int brcmf_process_nvram_vars(struct brcmf_sdio *bus,
-				    const struct firmware *nv)
+static int brcmf_sdio_strip_nvram(struct brcmf_sdio *bus,
+				  const struct firmware *nv)
 {
 	char *varbuf;
 	char *dp;
@@ -3328,44 +3328,48 @@ err:
 	return ret;
 }
 
-static int brcmf_sdbrcm_download_nvram(struct brcmf_sdio *bus)
+static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus)
 {
 	const struct firmware *nv;
 	int ret;
 
-	nv = brcmf_sdbrcm_get_fw(bus, BRCMF_FIRMWARE_NVRAM);
+	nv = brcmf_sdio_get_fw(bus, BRCMF_FIRMWARE_NVRAM);
 	if (nv == NULL)
 		return -ENOENT;
 
-	ret = brcmf_process_nvram_vars(bus, nv);
+	ret = brcmf_sdio_strip_nvram(bus, nv);
 
 	release_firmware(nv);
 
 	return ret;
 }
 
-static int _brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
+static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus)
 {
-	int bcmerror = -1;
+	int bcmerror = -EFAULT;
+
+
+	sdio_claim_host(bus->sdiodev->func[1]);
+	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 
 	/* Keep arm in reset */
-	if (!brcmf_sdbrcm_download_state(bus, true)) {
+	if (!brcmf_sdio_download_state(bus, true)) {
 		brcmf_err("error placing ARM core in reset\n");
 		goto err;
 	}
 
-	if (brcmf_sdbrcm_download_code_file(bus)) {
+	if (brcmf_sdio_download_code_file(bus)) {
 		brcmf_err("dongle image file download failed\n");
 		goto err;
 	}
 
-	if (brcmf_sdbrcm_download_nvram(bus)) {
+	if (brcmf_sdio_download_nvram(bus)) {
 		brcmf_err("dongle nvram file download failed\n");
 		goto err;
 	}
 
 	/* Take arm out of reset */
-	if (!brcmf_sdbrcm_download_state(bus, false)) {
+	if (!brcmf_sdio_download_state(bus, false)) {
 		brcmf_err("error getting out of ARM core reset\n");
 		goto err;
 	}
@@ -3373,10 +3377,12 @@ static int _brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 	bcmerror = 0;
 
 err:
+	brcmf_sdio_clkctl(bus, CLK_SDONLY, false);
+	sdio_release_host(bus->sdiodev->func[1]);
 	return bcmerror;
 }
 
-static bool brcmf_sdbrcm_sr_capable(struct brcmf_sdio *bus)
+static bool brcmf_sdio_sr_capable(struct brcmf_sdio *bus)
 {
 	u32 addr, reg;
 
@@ -3395,7 +3401,7 @@ static bool brcmf_sdbrcm_sr_capable(struct brcmf_sdio *bus)
 	return (bool)reg;
 }
 
-static void brcmf_sdbrcm_sr_init(struct brcmf_sdio *bus)
+static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 {
 	int err = 0;
 	u8 val;
@@ -3438,7 +3444,7 @@ static void brcmf_sdbrcm_sr_init(struct brcmf_sdio *bus)
 }
 
 /* enable KSO bit */
-static int brcmf_sdbrcm_kso_init(struct brcmf_sdio *bus)
+static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 {
 	u8 val;
 	int err = 0;
@@ -3470,25 +3476,7 @@ static int brcmf_sdbrcm_kso_init(struct brcmf_sdio *bus)
 }
 
 
-static bool
-brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
-{
-	bool ret;
-
-	sdio_claim_host(bus->sdiodev->func[1]);
-
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-
-	ret = _brcmf_sdbrcm_download_firmware(bus) == 0;
-
-	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
-
-	sdio_release_host(bus->sdiodev->func[1]);
-
-	return ret;
-}
-
-static int brcmf_sdbrcm_bus_preinit(struct device *dev)
+static int brcmf_sdio_bus_preinit(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
@@ -3547,7 +3535,7 @@ done:
 	return err;
 }
 
-static int brcmf_sdbrcm_bus_init(struct device *dev)
+static int brcmf_sdio_bus_init(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
@@ -3559,8 +3547,9 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 
 	/* try to download image and nvram to the dongle */
 	if (bus_if->state == BRCMF_BUS_DOWN) {
-		if (!(brcmf_sdbrcm_download_firmware(bus)))
-			return -1;
+		err = brcmf_sdio_download_firmware(bus);
+		if (err)
+			return err;
 	}
 
 	if (!bus->sdiodev->bus_if->drvr)
@@ -3568,12 +3557,12 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 
 	/* Start the watchdog timer */
 	bus->sdcnt.tickcnt = 0;
-	brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
+	brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
 
 	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* Make sure backplane clock is on, needed to generate F2 interrupt */
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 	if (bus->clkstate != CLK_AVAIL)
 		goto exit;
 
@@ -3611,8 +3600,8 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		ret = -ENODEV;
 	}
 
-	if (brcmf_sdbrcm_sr_capable(bus)) {
-		brcmf_sdbrcm_sr_init(bus);
+	if (brcmf_sdio_sr_capable(bus)) {
+		brcmf_sdio_sr_init(bus);
 	} else {
 		/* Restore previous clock setting */
 		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
@@ -3627,7 +3616,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 
 	/* If we didn't come up, turn off backplane clock */
 	if (bus_if->state != BRCMF_BUS_DATA)
-		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+		brcmf_sdio_clkctl(bus, CLK_NONE, false);
 
 exit:
 	sdio_release_host(bus->sdiodev->func[1]);
@@ -3635,7 +3624,7 @@ exit:
 	return ret;
 }
 
-void brcmf_sdbrcm_isr(struct brcmf_sdio *bus)
+void brcmf_sdio_isr(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3666,7 +3655,7 @@ void brcmf_sdbrcm_isr(struct brcmf_sdio *bus)
 	queue_work(bus->brcmf_wq, &bus->datawork);
 }
 
-static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
+static bool brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 {
 #ifdef DEBUG
 	struct brcmf_bus *bus_if = dev_get_drvdata(bus->sdiodev->dev);
@@ -3722,8 +3711,8 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 			bus->console.count -= bus->console_interval;
 			sdio_claim_host(bus->sdiodev->func[1]);
 			/* Make sure backplane clock is on */
-			brcmf_sdbrcm_bus_sleep(bus, false, false);
-			if (brcmf_sdbrcm_readconsole(bus) < 0)
+			brcmf_sdio_bus_sleep(bus, false, false);
+			if (brcmf_sdio_readconsole(bus) < 0)
 				/* stop on error */
 				bus->console_interval = 0;
 			sdio_release_host(bus->sdiodev->func[1]);
@@ -3737,11 +3726,11 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 			bus->idlecount = 0;
 			if (bus->activity) {
 				bus->activity = false;
-				brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
+				brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
 			} else {
 				brcmf_dbg(SDIO, "idle\n");
 				sdio_claim_host(bus->sdiodev->func[1]);
-				brcmf_sdbrcm_bus_sleep(bus, true, false);
+				brcmf_sdio_bus_sleep(bus, true, false);
 				sdio_release_host(bus->sdiodev->func[1]);
 			}
 		}
@@ -3756,12 +3745,12 @@ static void brcmf_sdio_dataworker(struct work_struct *work)
 					      datawork);
 
 	while (atomic_read(&bus->dpc_tskcnt)) {
-		brcmf_sdbrcm_dpc(bus);
+		brcmf_sdio_dpc(bus);
 		atomic_dec(&bus->dpc_tskcnt);
 	}
 }
 
-static void brcmf_sdbrcm_release_malloc(struct brcmf_sdio *bus)
+static void brcmf_sdio_release_malloc(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3770,7 +3759,7 @@ static void brcmf_sdbrcm_release_malloc(struct brcmf_sdio *bus)
 	bus->rxlen = 0;
 }
 
-static bool brcmf_sdbrcm_probe_malloc(struct brcmf_sdio *bus)
+static bool brcmf_sdio_probe_malloc(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3787,7 +3776,7 @@ static bool brcmf_sdbrcm_probe_malloc(struct brcmf_sdio *bus)
 }
 
 static bool
-brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus)
+brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 {
 	u8 clkctl = 0;
 	int err = 0;
@@ -3824,7 +3813,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus)
 		goto fail;
 	}
 
-	if (brcmf_sdbrcm_kso_init(bus)) {
+	if (brcmf_sdio_kso_init(bus)) {
 		brcmf_err("error enabling KSO\n");
 		goto fail;
 	}
@@ -3899,7 +3888,7 @@ fail:
 	return false;
 }
 
-static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
+static bool brcmf_sdio_probe_init(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3933,7 +3922,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 }
 
 static int
-brcmf_sdbrcm_watchdog_thread(void *data)
+brcmf_sdio_watchdog_thread(void *data)
 {
 	struct brcmf_sdio *bus = (struct brcmf_sdio *)data;
 
@@ -3943,7 +3932,7 @@ brcmf_sdbrcm_watchdog_thread(void *data)
 		if (kthread_should_stop())
 			break;
 		if (!wait_for_completion_interruptible(&bus->watchdog_wait)) {
-			brcmf_sdbrcm_bus_watchdog(bus);
+			brcmf_sdio_bus_watchdog(bus);
 			/* Count the tick for reference */
 			bus->sdcnt.tickcnt++;
 		} else
@@ -3953,7 +3942,7 @@ brcmf_sdbrcm_watchdog_thread(void *data)
 }
 
 static void
-brcmf_sdbrcm_watchdog(unsigned long data)
+brcmf_sdio_watchdog(unsigned long data)
 {
 	struct brcmf_sdio *bus = (struct brcmf_sdio *)data;
 
@@ -3966,14 +3955,14 @@ brcmf_sdbrcm_watchdog(unsigned long data)
 	}
 }
 
-static void brcmf_sdbrcm_release_dongle(struct brcmf_sdio *bus)
+static void brcmf_sdio_release_dongle(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus->ci) {
 		sdio_claim_host(bus->sdiodev->func[1]);
-		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+		brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
+		brcmf_sdio_clkctl(bus, CLK_NONE, false);
 		sdio_release_host(bus->sdiodev->func[1]);
 		brcmf_sdio_chip_detach(&bus->ci);
 		if (bus->vars && bus->varsz)
@@ -3985,7 +3974,7 @@ static void brcmf_sdbrcm_release_dongle(struct brcmf_sdio *bus)
 }
 
 /* Detach and free everything */
-static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
+static void brcmf_sdio_release(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3999,11 +3988,11 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 
 		if (bus->sdiodev->bus_if->drvr) {
 			brcmf_detach(bus->sdiodev->dev);
-			brcmf_sdbrcm_release_dongle(bus);
+			brcmf_sdio_release_dongle(bus);
 		}
 
 		brcmu_pkt_buf_free_skb(bus->txglom_sgpad);
-		brcmf_sdbrcm_release_malloc(bus);
+		brcmf_sdio_release_malloc(bus);
 		kfree(bus->hdrbuf);
 		kfree(bus);
 	}
@@ -4012,16 +4001,16 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 }
 
 static struct brcmf_bus_ops brcmf_sdio_bus_ops = {
-	.stop = brcmf_sdbrcm_bus_stop,
-	.preinit = brcmf_sdbrcm_bus_preinit,
-	.init = brcmf_sdbrcm_bus_init,
-	.txdata = brcmf_sdbrcm_bus_txdata,
-	.txctl = brcmf_sdbrcm_bus_txctl,
-	.rxctl = brcmf_sdbrcm_bus_rxctl,
-	.gettxq = brcmf_sdbrcm_bus_gettxq,
+	.stop = brcmf_sdio_bus_stop,
+	.preinit = brcmf_sdio_bus_preinit,
+	.init = brcmf_sdio_bus_init,
+	.txdata = brcmf_sdio_bus_txdata,
+	.txctl = brcmf_sdio_bus_txctl,
+	.rxctl = brcmf_sdio_bus_rxctl,
+	.gettxq = brcmf_sdio_bus_gettxq,
 };
 
-struct brcmf_sdio *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev)
+struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
 	struct brcmf_sdio *bus;
@@ -4061,8 +4050,8 @@ struct brcmf_sdio *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	/* attempt to attach to the dongle */
-	if (!(brcmf_sdbrcm_probe_attach(bus))) {
-		brcmf_err("brcmf_sdbrcm_probe_attach failed\n");
+	if (!(brcmf_sdio_probe_attach(bus))) {
+		brcmf_err("brcmf_sdio_probe_attach failed\n");
 		goto fail;
 	}
 
@@ -4074,11 +4063,11 @@ struct brcmf_sdio *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev)
 	/* Set up the watchdog timer */
 	init_timer(&bus->timer);
 	bus->timer.data = (unsigned long)bus;
-	bus->timer.function = brcmf_sdbrcm_watchdog;
+	bus->timer.function = brcmf_sdio_watchdog;
 
 	/* Initialize watchdog thread */
 	init_completion(&bus->watchdog_wait);
-	bus->watchdog_tsk = kthread_run(brcmf_sdbrcm_watchdog_thread,
+	bus->watchdog_tsk = kthread_run(brcmf_sdio_watchdog_thread,
 					bus, "brcmf_watchdog");
 	if (IS_ERR(bus->watchdog_tsk)) {
 		pr_warn("brcmf_watchdog thread failed to start\n");
@@ -4104,13 +4093,13 @@ struct brcmf_sdio *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	/* Allocate buffers */
-	if (!(brcmf_sdbrcm_probe_malloc(bus))) {
-		brcmf_err("brcmf_sdbrcm_probe_malloc failed\n");
+	if (!(brcmf_sdio_probe_malloc(bus))) {
+		brcmf_err("brcmf_sdio_probe_malloc failed\n");
 		goto fail;
 	}
 
-	if (!(brcmf_sdbrcm_probe_init(bus))) {
-		brcmf_err("brcmf_sdbrcm_probe_init failed\n");
+	if (!(brcmf_sdio_probe_init(bus))) {
+		brcmf_err("brcmf_sdio_probe_init failed\n");
 		goto fail;
 	}
 
@@ -4127,21 +4116,20 @@ struct brcmf_sdio *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev)
 	return bus;
 
 fail:
-	brcmf_sdbrcm_release(bus);
+	brcmf_sdio_release(bus);
 	return NULL;
 }
 
-void brcmf_sdbrcm_disconnect(struct brcmf_sdio *bus)
+void brcmf_sdio_disconnect(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
-	brcmf_sdbrcm_release(bus);
+	brcmf_sdio_release(bus);
 
 	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
-void
-brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick)
+void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 {
 	/* Totally stop the timer */
 	if (!wdtick && bus->wd_timer_valid) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 4c70cf2..e28498e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -235,9 +235,10 @@ int brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 /* Issue an abort to the specified function */
 int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
 
-struct brcmf_sdio *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev);
-void brcmf_sdbrcm_disconnect(struct brcmf_sdio *bus);
-void brcmf_sdbrcm_isr(struct brcmf_sdio *bus);
-void brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick);
+struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
+void brcmf_sdio_disconnect(struct brcmf_sdio *bus);
+void brcmf_sdio_isr(struct brcmf_sdio *bus);
+
+void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick);
 
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.10.4

