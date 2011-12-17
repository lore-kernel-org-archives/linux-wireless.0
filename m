Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1508 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760974Ab1LQChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/30] brcm80211: fmac: remove duplicate statistics from
 driver data structure
Date: Fri, 16 Dec 2011 18:37:05 -0800
Message-ID: <1324089440-8957-16-git-send-email-frankyl@broadcom.com> (sfid-20111217_035946_506693_97F36A9B)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some dongle statistics are stored in two places and synced when net
device status inquired. There is no need to do it this way any more.
Direct all usage to dongle stats structure in order to increase
readability.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   13 -------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   12 ------------
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   10 +++-------
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    3 ---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   20 ++++++++++----------
 5 files changed, 13 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 4dcb11d..44cad9b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -608,21 +608,8 @@ struct brcmf_pub {
 
 	/* Additional stats for the bus level */
 
-	/* Data packets sent to dongle */
-	unsigned long tx_packets;
 	/* Multicast data packets sent to dongle */
 	unsigned long tx_multicast;
-	/* Errors in sending data to dongle */
-	unsigned long tx_errors;
-	/* Packets sent up the network interface */
-	unsigned long rx_packets;
-	/* Multicast packets sent up the network interface */
-	unsigned long rx_multicast;
-	/* Errors processing rx data packets */
-	unsigned long rx_errors;
-
-	/* Packets dropped locally (no memory) */
-	unsigned long rx_dropped;
 	/* Packets flushed due to unscheduled sendup thread */
 	unsigned long rx_flushed;
 	/* Number of times dpc scheduled by watchdog timer */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 774aeac..8b4dba3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -453,18 +453,6 @@ void brcmf_proto_detach(struct brcmf_pub *drvr)
 	drvr->prot = NULL;
 }
 
-void brcmf_proto_dstats(struct brcmf_pub *drvr)
-{
-	/* No stats from dongle added yet, copy bus stats */
-	drvr->dstats.tx_packets = drvr->tx_packets;
-	drvr->dstats.tx_errors = drvr->tx_errors;
-	drvr->dstats.rx_packets = drvr->rx_packets;
-	drvr->dstats.rx_errors = drvr->rx_errors;
-	drvr->dstats.rx_dropped = drvr->rx_dropped;
-	drvr->dstats.multicast = drvr->rx_multicast;
-	return;
-}
-
 int brcmf_proto_init(struct brcmf_pub *drvr)
 {
 	int ret = 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 5e9acf8..4f5ec43 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -342,7 +342,7 @@ done:
 	if (ret)
 		drvr->dstats.tx_dropped++;
 	else
-		drvr->tx_packets++;
+		drvr->dstats.tx_packets++;
 
 	/* Return ok: we always eat the packet */
 	return 0;
@@ -427,7 +427,7 @@ void brcmf_rx_frame(struct device *dev, int ifidx,
 		skb->protocol = eth_type_trans(skb, skb->dev);
 
 		if (skb->pkt_type == PACKET_MULTICAST)
-			drvr->rx_multicast++;
+			drvr->dstats.multicast++;
 
 		skb->data = eth;
 		skb->len = len;
@@ -447,7 +447,7 @@ void brcmf_rx_frame(struct device *dev, int ifidx,
 		}
 
 		drvr->dstats.rx_bytes += skb->len;
-		drvr->rx_packets++;	/* Local count */
+		drvr->dstats.rx_packets++;	/* Local count */
 
 		if (in_interrupt())
 			netif_rx(skb);
@@ -487,10 +487,6 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (drvr->bus_if->drvr_up)
-		/* Use the protocol to get dongle stats */
-		brcmf_proto_dstats(drvr);
-
 	/* Copy dongle stats to net device stats */
 	ifp->stats.rx_packets = drvr->dstats.rx_packets;
 	ifp->stats.tx_packets = drvr->dstats.tx_packets;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
index 130a847..7005ff17 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
@@ -49,9 +49,6 @@ extern int brcmf_proto_hdrpull(struct device *dev, int *ifidx,
 extern int brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx,
 				struct brcmf_dcmd *dcmd, int len);
 
-/* Update local copy of dongle statistics */
-extern void brcmf_proto_dstats(struct brcmf_pub *drvr);
-
 extern int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr);
 
 extern int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 6c5b5b5..255861b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1263,7 +1263,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		if (errcode < 0) {
 			brcmf_dbg(ERROR, "glom read of %d bytes failed: %d\n",
 				  dlen, errcode);
-			bus->drvr->rx_errors++;
+			bus->drvr->dstats.rx_errors++;
 
 			if (bus->glomerr++ < 3) {
 				brcmf_sdbrcm_rxfail(bus, true, true);
@@ -1447,7 +1447,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			} else if (brcmf_proto_hdrpull(bus->sdiodev->dev,
 						       &ifidx, pfirst) != 0) {
 				brcmf_dbg(ERROR, "rx protocol error\n");
-				bus->drvr->rx_errors++;
+				bus->drvr->dstats.rx_errors++;
 				skb_unlink(pfirst, &bus->glom);
 				brcmu_pkt_buf_free_skb(pfirst);
 				continue;
@@ -1548,7 +1548,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	if ((rdlen + BRCMF_FIRSTREAD) > bus->sdiodev->bus_if->maxctl) {
 		brcmf_dbg(ERROR, "%d-byte control read exceeds %d-byte buffer\n",
 			  rdlen, bus->sdiodev->bus_if->maxctl);
-		bus->drvr->rx_errors++;
+		bus->drvr->dstats.rx_errors++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
 	}
@@ -1556,7 +1556,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	if ((len - doff) > bus->sdiodev->bus_if->maxctl) {
 		brcmf_dbg(ERROR, "%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
 			  len, len - doff, bus->sdiodev->bus_if->maxctl);
-		bus->drvr->rx_errors++;
+		bus->drvr->dstats.rx_errors++;
 		bus->rx_toolong++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
@@ -1630,7 +1630,7 @@ brcmf_alloc_pkt_and_read(struct brcmf_sdio *bus, u16 rdlen,
 		brcmf_dbg(ERROR, "(nextlen): read %d bytes failed: %d\n",
 			  rdlen, sdret);
 		brcmu_pkt_buf_free_skb(*pkt);
-		bus->drvr->rx_errors++;
+		bus->drvr->dstats.rx_errors++;
 		/* Force retry w/normal header read.
 		 * Don't attempt NAK for
 		 * gSPI
@@ -1979,7 +1979,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 			/* Too long -- skip this frame */
 			brcmf_dbg(ERROR, "too long: len %d rdlen %d\n",
 				  len, rdlen);
-			bus->drvr->rx_errors++;
+			bus->drvr->dstats.rx_errors++;
 			bus->rx_toolong++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
@@ -1991,7 +1991,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 			/* Give up on data, request rtx of events */
 			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: rdlen %d chan %d\n",
 				  rdlen, chan);
-			bus->drvr->rx_dropped++;
+			bus->drvr->dstats.rx_dropped++;
 			brcmf_sdbrcm_rxfail(bus, false, RETRYCHAN(chan));
 			continue;
 		}
@@ -2011,7 +2011,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 				   : ((chan == SDPCM_DATA_CHANNEL) ? "data"
 				      : "test")), sdret);
 			brcmu_pkt_buf_free_skb(pkt);
-			bus->drvr->rx_errors++;
+			bus->drvr->dstats.rx_errors++;
 			brcmf_sdbrcm_rxfail(bus, true, RETRYCHAN(chan));
 			continue;
 		}
@@ -2064,7 +2064,7 @@ deliver:
 			   pkt) != 0) {
 			brcmf_dbg(ERROR, "rx protocol error\n");
 			brcmu_pkt_buf_free_skb(pkt);
-			bus->drvr->rx_errors++;
+			bus->drvr->dstats.rx_errors++;
 			continue;
 		}
 
@@ -2276,7 +2276,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 
 		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
 		if (ret)
-			bus->drvr->tx_errors++;
+			bus->drvr->dstats.tx_errors++;
 		else
 			bus->drvr->dstats.tx_bytes += datalen;
 
-- 
1.7.5.4


