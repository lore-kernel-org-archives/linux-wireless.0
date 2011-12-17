Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1505 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760975Ab1LQChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/30] brcm80211: fmac: change function rx_frame
 parameter
Date: Fri, 16 Dec 2011 18:37:00 -0800
Message-ID: <1324089440-8957-11-git-send-email-frankyl@broadcom.com> (sfid-20111217_035946_863290_A4DD22A5)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change parameter to device pointer for bus layer interface function
brcmf_rx_frame. This is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    6 +++---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    4 +++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index e403ad0..027083e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -712,16 +712,16 @@ extern bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 			 struct sk_buff *pkt, int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-extern void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
+extern void brcmf_rx_frame(struct device *dev, int ifidx,
 			   struct sk_buff_head *rxlist);
-static inline void brcmf_rx_packet(struct brcmf_pub *drvr, int ifidx,
+static inline void brcmf_rx_packet(struct device *dev, int ifidx,
 				   struct sk_buff *pkt)
 {
 	struct sk_buff_head q;
 
 	skb_queue_head_init(&q);
 	skb_queue_tail(&q, pkt);
-	brcmf_rx_frame(drvr, ifidx, &q);
+	brcmf_rx_frame(dev, ifidx, &q);
 }
 
 /* Return pointer to interface name */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index e095b6f..3efa301 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -381,7 +381,7 @@ static int brcmf_host_event(struct brcmf_pub *drvr, int *ifidx,
 	return bcmerror;
 }
 
-void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
+void brcmf_rx_frame(struct device *dev, int ifidx,
 		    struct sk_buff_head *skb_list)
 {
 	unsigned char *eth;
@@ -390,6 +390,8 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
 	struct sk_buff *skb, *pnext;
 	struct brcmf_if *ifp;
 	struct brcmf_event_msg event;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5d392c9..7de002b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1461,7 +1461,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		/* sent any remaining packets up */
 		if (bus->glom.qlen) {
 			up(&bus->sdsem);
-			brcmf_rx_frame(bus->drvr, ifidx, &bus->glom);
+			brcmf_rx_frame(bus->sdiodev->dev, ifidx, &bus->glom);
 			down(&bus->sdsem);
 		}
 
@@ -2062,7 +2062,7 @@ deliver:
 
 		/* Unlock during rx call */
 		up(&bus->sdsem);
-		brcmf_rx_packet(bus->drvr, ifidx, pkt);
+		brcmf_rx_packet(bus->sdiodev->dev, ifidx, pkt);
 		down(&bus->sdsem);
 	}
 	rxcount = maxframes - rxleft;
-- 
1.7.5.4


