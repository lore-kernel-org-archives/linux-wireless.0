Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1800 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab3BFRlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:41:09 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/12] brcmfmac: Track statistics per ifp.
Date: Wed, 6 Feb 2013 18:40:41 +0100
Message-ID: <1360172447-2424-7-git-send-email-arend@broadcom.com> (sfid-20130206_184117_725345_3A6FDE7C)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Statistics were tracked by bus driver while it is to be tracked
per ifp/netdev.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   13 -----
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   61 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   10 ----
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    9 +--
 4 files changed, 27 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 57826dc..6af7c9d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -24,18 +24,6 @@ enum brcmf_bus_state {
 	BRCMF_BUS_DATA		/* Ready for frame transfers */
 };
 
-struct dngl_stats {
-	unsigned long rx_packets;	/* total packets received */
-	unsigned long tx_packets;	/* total packets transmitted */
-	unsigned long rx_bytes;	/* total bytes received */
-	unsigned long tx_bytes;	/* total bytes transmitted */
-	unsigned long rx_errors;	/* bad packets received */
-	unsigned long tx_errors;	/* packet transmit problems */
-	unsigned long rx_dropped;	/* packets dropped by dongle */
-	unsigned long tx_dropped;	/* packets dropped by dongle */
-	unsigned long multicast;	/* multicast packets received */
-};
-
 struct brcmf_bus_dcmd {
 	char *name;
 	char *param;
@@ -87,7 +75,6 @@ struct brcmf_bus {
 	enum brcmf_bus_state state;
 	uint maxctl;
 	unsigned long tx_realloc;
-	struct dngl_stats dstats;
 	u8 align;
 	struct list_head dcmd_list;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 9a4494a..05cae37 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -226,10 +226,12 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	ret =  brcmf_bus_txdata(drvr->bus_if, skb);
 
 done:
-	if (ret)
-		drvr->bus_if->dstats.tx_dropped++;
-	else
-		drvr->bus_if->dstats.tx_packets++;
+	if (ret) {
+		ifp->stats.tx_dropped++;
+	} else {
+		ifp->stats.tx_packets++;
+		ifp->stats.tx_bytes += skb->len;
+	}
 
 	/* Return ok: we always eat the packet */
 	return NETDEV_TX_OK;
@@ -270,12 +272,13 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 	skb_queue_walk_safe(skb_list, skb, pnext) {
 		skb_unlink(skb, skb_list);
 
-		/* process and remove protocol-specific header
-		 */
+		/* process and remove protocol-specific header */
 		ret = brcmf_proto_hdrpull(drvr, &ifidx, skb);
-		if (ret < 0) {
-			if (ret != -ENODATA)
-				bus_if->dstats.rx_errors++;
+		ifp = drvr->iflist[ifidx];
+
+		if (ret || !ifp || !ifp->ndev) {
+			if ((ret != -ENODATA) && ifp)
+				ifp->stats.rx_errors++;
 			brcmu_pkt_buf_free_skb(skb);
 			continue;
 		}
@@ -295,21 +298,11 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 		eth = skb->data;
 		len = skb->len;
 
-		ifp = drvr->iflist[ifidx];
-		if (ifp == NULL)
-			ifp = drvr->iflist[0];
-
-		if (!ifp || !ifp->ndev ||
-		    ifp->ndev->reg_state != NETREG_REGISTERED) {
-			brcmu_pkt_buf_free_skb(skb);
-			continue;
-		}
-
 		skb->dev = ifp->ndev;
 		skb->protocol = eth_type_trans(skb, skb->dev);
 
 		if (skb->pkt_type == PACKET_MULTICAST)
-			bus_if->dstats.multicast++;
+			ifp->stats.multicast++;
 
 		skb->data = eth;
 		skb->len = len;
@@ -325,8 +318,13 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 			ifp->ndev->last_rx = jiffies;
 		}
 
-		bus_if->dstats.rx_bytes += skb->len;
-		bus_if->dstats.rx_packets++;	/* Local count */
+		if (!(ifp->ndev->flags & IFF_UP)) {
+			brcmu_pkt_buf_free_skb(skb);
+			continue;
+		}
+
+		ifp->stats.rx_bytes += skb->len;
+		ifp->stats.rx_packets++;
 
 		if (in_interrupt())
 			netif_rx(skb);
@@ -352,35 +350,28 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 
 	brcmf_proto_hdrpull(drvr, &ifidx, txp);
 
+	ifp = drvr->iflist[ifidx];
+	if (!ifp)
+		return;
+
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
 
 	if (type == ETH_P_PAE) {
-		ifp = drvr->iflist[ifidx];
 		atomic_dec(&ifp->pend_8021x_cnt);
 		if (waitqueue_active(&ifp->pend_8021x_wait))
 			wake_up(&ifp->pend_8021x_wait);
 	}
+	if (!success)
+		ifp->stats.tx_errors++;
 }
 
 static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_bus *bus_if = ifp->drvr->bus_if;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/* Copy dongle stats to net device stats */
-	ifp->stats.rx_packets = bus_if->dstats.rx_packets;
-	ifp->stats.tx_packets = bus_if->dstats.tx_packets;
-	ifp->stats.rx_bytes = bus_if->dstats.rx_bytes;
-	ifp->stats.tx_bytes = bus_if->dstats.tx_bytes;
-	ifp->stats.rx_errors = bus_if->dstats.rx_errors;
-	ifp->stats.tx_errors = bus_if->dstats.tx_errors;
-	ifp->stats.rx_dropped = bus_if->dstats.rx_dropped;
-	ifp->stats.tx_dropped = bus_if->dstats.tx_dropped;
-	ifp->stats.multicast = bus_if->dstats.multicast;
-
 	return &ifp->stats;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index df8a185..d424dd6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1096,7 +1096,6 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	if (len > MAX_RX_DATASZ && rd->channel != SDPCM_CONTROL_CHANNEL &&
 	    type != BRCMF_SDIO_FT_SUPER) {
 		brcmf_err("HW header length too long\n");
-		bus->sdiodev->bus_if->dstats.rx_errors++;
 		bus->sdcnt.rx_toolong++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		rd->len = 0;
@@ -1298,7 +1297,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		if (errcode < 0) {
 			brcmf_err("glom read of %d bytes failed: %d\n",
 				  dlen, errcode);
-			bus->sdiodev->bus_if->dstats.rx_errors++;
 
 			sdio_claim_host(bus->sdiodev->func[1]);
 			if (bus->glomerr++ < 3) {
@@ -1478,7 +1476,6 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	if ((rdlen + BRCMF_FIRSTREAD) > bus->sdiodev->bus_if->maxctl) {
 		brcmf_err("%d-byte control read exceeds %d-byte buffer\n",
 			  rdlen, bus->sdiodev->bus_if->maxctl);
-		bus->sdiodev->bus_if->dstats.rx_errors++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
 	}
@@ -1486,7 +1483,6 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	if ((len - doff) > bus->sdiodev->bus_if->maxctl) {
 		brcmf_err("%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
 			  len, len - doff, bus->sdiodev->bus_if->maxctl);
-		bus->sdiodev->bus_if->dstats.rx_errors++;
 		bus->sdcnt.rx_toolong++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
@@ -1634,7 +1630,6 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
 			brcmf_err("brcmu_pkt_buf_get_skb failed\n");
-			bus->sdiodev->bus_if->dstats.rx_dropped++;
 			brcmf_sdbrcm_rxfail(bus, false,
 					    RETRYCHAN(rd->channel));
 			sdio_release_host(bus->sdiodev->func[1]);
@@ -1652,7 +1647,6 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			brcmf_err("read %d bytes from channel %d failed: %d\n",
 				  rd->len, rd->channel, sdret);
 			brcmu_pkt_buf_free_skb(pkt);
-			bus->sdiodev->bus_if->dstats.rx_errors++;
 			sdio_claim_host(bus->sdiodev->func[1]);
 			brcmf_sdbrcm_rxfail(bus, true,
 					    RETRYCHAN(rd->channel));
@@ -1940,10 +1934,6 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		datalen = pkt->len - SDPCM_HDRLEN;
 
 		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
-		if (ret)
-			bus->sdiodev->bus_if->dstats.tx_errors++;
-		else
-			bus->sdiodev->bus_if->dstats.tx_bytes += datalen;
 
 		/* In poll mode, need to check for other events */
 		if (!bus->intr && cnt) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index e15630c..06f7339 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -421,10 +421,6 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 	brcmf_dbg(USB, "Enter, urb->status=%d, skb=%p\n", urb->status,
 		  req->skb);
 	brcmf_usb_del_fromq(devinfo, req);
-	if (urb->status == 0)
-		devinfo->bus_pub.bus->dstats.tx_packets++;
-	else
-		devinfo->bus_pub.bus->dstats.tx_errors++;
 
 	brcmf_txcomplete(devinfo->dev, req->skb, urb->status == 0);
 
@@ -451,10 +447,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 	req->skb = NULL;
 
 	/* zero lenght packets indicate usb "failure". Do not refill */
-	if (urb->status == 0 && urb->actual_length) {
-		devinfo->bus_pub.bus->dstats.rx_packets++;
-	} else {
-		devinfo->bus_pub.bus->dstats.rx_errors++;
+	if (urb->status != 0 || !urb->actual_length) {
 		brcmu_pkt_buf_free_skb(skb);
 		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req, NULL);
 		return;
-- 
1.7.10.4


