Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2347 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760944Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/30] brcm80211: fmac: move dongle statistics to struct
 brcmf_bus
Date: Fri, 16 Dec 2011 18:37:06 -0800
Message-ID: <1324089440-8957-17-git-send-email-frankyl@broadcom.com> (sfid-20111217_033748_089252_02FF1DDA)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dongle statistics are shared data between common layer and bus
layer. This patch places them in bus interface structure brcmf_bus
as part of the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   30 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   22 +++++++-------
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 44cad9b..86cb197 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -578,6 +578,7 @@ struct brcmf_bus {
 	enum brcmf_bus_state state;
 	uint maxctl;		/* Max size rxctl request from proto to bus */
 	bool drvr_up;		/* Status flag of driver up/down */
+	struct dngl_stats dstats;	/* Stats for dongle-based data */
 };
 
 /* Forward decls for struct brcmf_pub (see below) */
@@ -604,7 +605,6 @@ struct brcmf_pub {
 	bool iswl;		/* Dongle-resident driver is wl */
 	unsigned long drv_version;	/* Version of dongle-resident driver */
 	u8 mac[ETH_ALEN];		/* MAC address obtained from dongle */
-	struct dngl_stats dstats;	/* Stats for dongle-based data */
 
 	/* Additional stats for the bus level */
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 4f5ec43..e456099 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -340,9 +340,9 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 done:
 	if (ret)
-		drvr->dstats.tx_dropped++;
+		drvr->bus_if->dstats.tx_dropped++;
 	else
-		drvr->dstats.tx_packets++;
+		drvr->bus_if->dstats.tx_packets++;
 
 	/* Return ok: we always eat the packet */
 	return 0;
@@ -427,7 +427,7 @@ void brcmf_rx_frame(struct device *dev, int ifidx,
 		skb->protocol = eth_type_trans(skb, skb->dev);
 
 		if (skb->pkt_type == PACKET_MULTICAST)
-			drvr->dstats.multicast++;
+			bus_if->dstats.multicast++;
 
 		skb->data = eth;
 		skb->len = len;
@@ -446,8 +446,8 @@ void brcmf_rx_frame(struct device *dev, int ifidx,
 			ifp->ndev->last_rx = jiffies;
 		}
 
-		drvr->dstats.rx_bytes += skb->len;
-		drvr->dstats.rx_packets++;	/* Local count */
+		bus_if->dstats.rx_bytes += skb->len;
+		bus_if->dstats.rx_packets++;	/* Local count */
 
 		if (in_interrupt())
 			netif_rx(skb);
@@ -483,20 +483,20 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_pub *drvr = ifp->drvr;
+	struct brcmf_bus *bus_if = ifp->drvr->bus_if;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Copy dongle stats to net device stats */
-	ifp->stats.rx_packets = drvr->dstats.rx_packets;
-	ifp->stats.tx_packets = drvr->dstats.tx_packets;
-	ifp->stats.rx_bytes = drvr->dstats.rx_bytes;
-	ifp->stats.tx_bytes = drvr->dstats.tx_bytes;
-	ifp->stats.rx_errors = drvr->dstats.rx_errors;
-	ifp->stats.tx_errors = drvr->dstats.tx_errors;
-	ifp->stats.rx_dropped = drvr->dstats.rx_dropped;
-	ifp->stats.tx_dropped = drvr->dstats.tx_dropped;
-	ifp->stats.multicast = drvr->dstats.multicast;
+	ifp->stats.rx_packets = bus_if->dstats.rx_packets;
+	ifp->stats.tx_packets = bus_if->dstats.tx_packets;
+	ifp->stats.rx_bytes = bus_if->dstats.rx_bytes;
+	ifp->stats.tx_bytes = bus_if->dstats.tx_bytes;
+	ifp->stats.rx_errors = bus_if->dstats.rx_errors;
+	ifp->stats.tx_errors = bus_if->dstats.tx_errors;
+	ifp->stats.rx_dropped = bus_if->dstats.rx_dropped;
+	ifp->stats.tx_dropped = bus_if->dstats.tx_dropped;
+	ifp->stats.multicast = bus_if->dstats.multicast;
 
 	return &ifp->stats;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 255861b..4b0a87d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1263,7 +1263,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		if (errcode < 0) {
 			brcmf_dbg(ERROR, "glom read of %d bytes failed: %d\n",
 				  dlen, errcode);
-			bus->drvr->dstats.rx_errors++;
+			bus->sdiodev->bus_if->dstats.rx_errors++;
 
 			if (bus->glomerr++ < 3) {
 				brcmf_sdbrcm_rxfail(bus, true, true);
@@ -1447,7 +1447,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			} else if (brcmf_proto_hdrpull(bus->sdiodev->dev,
 						       &ifidx, pfirst) != 0) {
 				brcmf_dbg(ERROR, "rx protocol error\n");
-				bus->drvr->dstats.rx_errors++;
+				bus->sdiodev->bus_if->dstats.rx_errors++;
 				skb_unlink(pfirst, &bus->glom);
 				brcmu_pkt_buf_free_skb(pfirst);
 				continue;
@@ -1548,7 +1548,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	if ((rdlen + BRCMF_FIRSTREAD) > bus->sdiodev->bus_if->maxctl) {
 		brcmf_dbg(ERROR, "%d-byte control read exceeds %d-byte buffer\n",
 			  rdlen, bus->sdiodev->bus_if->maxctl);
-		bus->drvr->dstats.rx_errors++;
+		bus->sdiodev->bus_if->dstats.rx_errors++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
 	}
@@ -1556,7 +1556,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	if ((len - doff) > bus->sdiodev->bus_if->maxctl) {
 		brcmf_dbg(ERROR, "%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
 			  len, len - doff, bus->sdiodev->bus_if->maxctl);
-		bus->drvr->dstats.rx_errors++;
+		bus->sdiodev->bus_if->dstats.rx_errors++;
 		bus->rx_toolong++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
@@ -1630,7 +1630,7 @@ brcmf_alloc_pkt_and_read(struct brcmf_sdio *bus, u16 rdlen,
 		brcmf_dbg(ERROR, "(nextlen): read %d bytes failed: %d\n",
 			  rdlen, sdret);
 		brcmu_pkt_buf_free_skb(*pkt);
-		bus->drvr->dstats.rx_errors++;
+		bus->sdiodev->bus_if->dstats.rx_errors++;
 		/* Force retry w/normal header read.
 		 * Don't attempt NAK for
 		 * gSPI
@@ -1979,7 +1979,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 			/* Too long -- skip this frame */
 			brcmf_dbg(ERROR, "too long: len %d rdlen %d\n",
 				  len, rdlen);
-			bus->drvr->dstats.rx_errors++;
+			bus->sdiodev->bus_if->dstats.rx_errors++;
 			bus->rx_toolong++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
@@ -1991,7 +1991,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 			/* Give up on data, request rtx of events */
 			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: rdlen %d chan %d\n",
 				  rdlen, chan);
-			bus->drvr->dstats.rx_dropped++;
+			bus->sdiodev->bus_if->dstats.rx_dropped++;
 			brcmf_sdbrcm_rxfail(bus, false, RETRYCHAN(chan));
 			continue;
 		}
@@ -2011,7 +2011,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 				   : ((chan == SDPCM_DATA_CHANNEL) ? "data"
 				      : "test")), sdret);
 			brcmu_pkt_buf_free_skb(pkt);
-			bus->drvr->dstats.rx_errors++;
+			bus->sdiodev->bus_if->dstats.rx_errors++;
 			brcmf_sdbrcm_rxfail(bus, true, RETRYCHAN(chan));
 			continue;
 		}
@@ -2064,7 +2064,7 @@ deliver:
 			   pkt) != 0) {
 			brcmf_dbg(ERROR, "rx protocol error\n");
 			brcmu_pkt_buf_free_skb(pkt);
-			bus->drvr->dstats.rx_errors++;
+			bus->sdiodev->bus_if->dstats.rx_errors++;
 			continue;
 		}
 
@@ -2276,9 +2276,9 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 
 		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
 		if (ret)
-			bus->drvr->dstats.tx_errors++;
+			bus->sdiodev->bus_if->dstats.tx_errors++;
 		else
-			bus->drvr->dstats.tx_bytes += datalen;
+			bus->sdiodev->bus_if->dstats.tx_bytes += datalen;
 
 		/* In poll mode, need to check for other events */
 		if (!bus->intr && cnt) {
-- 
1.7.5.4


