Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1500 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760973Ab1LQChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/30] brcm80211: fmac: change function txcomplete
 parameter
Date: Fri, 16 Dec 2011 18:36:58 -0800
Message-ID: <1324089440-8957-9-git-send-email-frankyl@broadcom.com> (sfid-20111217_035944_865627_EA76FF6E)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change parameter to device pointer for bus layer interface function
brcmf_txcomplete. This is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    4 +++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 6577fc5..bfceba3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -728,7 +728,7 @@ static inline void brcmf_rx_packet(struct brcmf_pub *drvr, int ifidx,
 extern char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 
 /* Notify tx completion */
-extern void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp,
+extern void brcmf_txcomplete(struct device *dev, struct sk_buff *txp,
 			     bool success);
 
 /* Query dongle */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index f82f87c..e095b6f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -460,11 +460,13 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
 	}
 }
 
-void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp, bool success)
+void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 {
 	uint ifidx;
 	struct ethhdr *eh;
 	u16 type;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
 
 	brcmf_proto_hdrpull(drvr, &ifidx, txp);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2253f7a..16a05e9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2230,7 +2230,7 @@ done:
 	/* restore pkt buffer pointer before calling tx complete routine */
 	skb_pull(pkt, SDPCM_HDRLEN + pad);
 	up(&bus->sdsem);
-	brcmf_txcomplete(bus->drvr, pkt, ret != 0);
+	brcmf_txcomplete(bus->sdiodev->dev, pkt, ret != 0);
 	down(&bus->sdsem);
 
 	if (free_pkt)
@@ -2592,7 +2592,7 @@ int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	spin_lock_bh(&bus->txqlock);
 	if (brcmf_c_prec_enq(bus->drvr, &bus->txq, pkt, prec) == false) {
 		skb_pull(pkt, SDPCM_HDRLEN);
-		brcmf_txcomplete(bus->drvr, pkt, false);
+		brcmf_txcomplete(bus->sdiodev->dev, pkt, false);
 		brcmu_pkt_buf_free_skb(pkt);
 		brcmf_dbg(ERROR, "out of bus->txq !!!\n");
 		ret = -ENOSR;
-- 
1.7.5.4


