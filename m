Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1672 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968546Ab3HJK1q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:27:46 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/12] brcmfmac: .txdata() bus callback should not call
 brcmf_txcomplete()
Date: Sat, 10 Aug 2013 12:27:20 +0200
Message-ID: <1376130450-29746-3-git-send-email-arend@broadcom.com> (sfid-20130810_122815_897367_AFBFF82B)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With firmware-signalling the packet handed to the bus specific driver
layer should not be discarded with brcmf_txcomplete() in the failure
path. Instead only an error is returned and the caller decides what
to do with the packet.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 1 -
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 6 +++++-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      | 1 -
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5cbce1d..db31312 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2297,7 +2297,6 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	spin_lock_irqsave(&bus->txqlock, flags);
 	if (!brcmf_c_prec_enq(bus->sdiodev->dev, &bus->txq, pkt, prec)) {
 		skb_pull(pkt, SDPCM_HDRLEN);
-		brcmf_txcomplete(bus->sdiodev->dev, pkt, false);
 		brcmf_err("out of bus->txq !!!\n");
 		ret = -ENOSR;
 	} else {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 29b1f24..601b0d0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1745,6 +1745,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	int fifo = BRCMF_FWS_FIFO_BCMC;
 	bool multicast = is_multicast_ether_addr(eh->h_dest);
 	bool pae = eh->h_proto == htons(ETH_P_PAE);
+	int ret;
 
 	/* determine the priority */
 	if (!skb->priority)
@@ -1759,7 +1760,10 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		brcmf_proto_hdrpush(drvr, ifp->ifidx, 0, skb);
 
 		/* Use bus module to send data frame */
-		return brcmf_bus_txdata(drvr->bus_if, skb);
+		ret = brcmf_bus_txdata(drvr->bus_if, skb);
+		if (ret < 0)
+			brcmf_txfinalize(drvr, skb, false);
+		return ret;
 	}
 
 	/* set control buffer information */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 322cadc..39e01a7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -614,7 +614,6 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 	return 0;
 
 fail:
-	brcmf_txcomplete(dev, skb, false);
 	return ret;
 }
 
-- 
1.8.1.3


