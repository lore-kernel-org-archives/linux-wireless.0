Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1502 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760989Ab1LQChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/30] brcm80211: fmac: change function proto_hdrpull
 parameter
Date: Fri, 16 Dec 2011 18:37:01 -0800
Message-ID: <1324089440-8957-12-git-send-email-frankyl@broadcom.com> (sfid-20111217_035944_693743_9B295A2F)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change parameter to device pointer for bus layer interface function
brcmf_proto_hdrpull This is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    4 +++-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    7 ++++---
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 87003f8..3f0b316 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -376,10 +376,12 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 	BDC_SET_IF_IDX(h, ifidx);
 }
 
-int brcmf_proto_hdrpull(struct brcmf_pub *drvr, int *ifidx,
+int brcmf_proto_hdrpull(struct device *dev, int *ifidx,
 			struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bdc_header *h;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 3efa301..576cdc4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -470,7 +470,7 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 
-	brcmf_proto_hdrpull(drvr, &ifidx, txp);
+	brcmf_proto_hdrpull(dev, &ifidx, txp);
 
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
index 4ee1ea8..130a847 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
@@ -42,7 +42,7 @@ extern void brcmf_proto_hdrpush(struct brcmf_pub *, int ifidx,
 				struct sk_buff *txp);
 
 /* Remove any protocol-specific data header. */
-extern int brcmf_proto_hdrpull(struct brcmf_pub *, int *ifidx,
+extern int brcmf_proto_hdrpull(struct device *dev, int *ifidx,
 			       struct sk_buff *rxp);
 
 /* Use protocol to issue command to dongle */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 7de002b..a54abaf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1437,8 +1437,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				skb_unlink(pfirst, &bus->glom);
 				brcmu_pkt_buf_free_skb(pfirst);
 				continue;
-			} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx,
-						       pfirst) != 0) {
+			} else if (brcmf_proto_hdrpull(bus->sdiodev->dev,
+						       &ifidx, pfirst) != 0) {
 				brcmf_dbg(ERROR, "rx protocol error\n");
 				bus->drvr->rx_errors++;
 				skb_unlink(pfirst, &bus->glom);
@@ -2053,7 +2053,8 @@ deliver:
 		if (pkt->len == 0) {
 			brcmu_pkt_buf_free_skb(pkt);
 			continue;
-		} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx, pkt) != 0) {
+		} else if (brcmf_proto_hdrpull(bus->sdiodev->dev, &ifidx,
+			   pkt) != 0) {
 			brcmf_dbg(ERROR, "rx protocol error\n");
 			brcmu_pkt_buf_free_skb(pkt);
 			bus->drvr->rx_errors++;
-- 
1.7.5.4


