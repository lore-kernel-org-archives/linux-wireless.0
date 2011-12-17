Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1515 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760986Ab1LQChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 18/30] brcm80211: fmac: move tx flow ctrl flag to bus
 layer
Date: Fri, 16 Dec 2011 18:37:08 -0800
Message-ID: <1324089440-8957-19-git-send-email-frankyl@broadcom.com> (sfid-20111217_035945_315382_8FBAB158)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

txoff is the flow control flag for transmit used in sdio layer.
Move it to bus layer data structure brcmf_sdio. Also flag
management code is moved out of brcmf_txflowcontrol(). This is
part of the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   10 ++++++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 7461567..980bf70 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -597,7 +597,6 @@ struct brcmf_pub {
 	struct device *dev;		/* fullmac dongle device pointer */
 
 	/* Internal brcmf items */
-	bool txoff;		/* Transmit flow-controlled */
 	uint hdrlen;		/* Total BRCMF header length (proto + bus) */
 	uint rxsz;		/* Rx buffer size bus module should use */
 	u8 wme_dp;		/* wme discard priority */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 1ce6322..130cab1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -356,7 +356,6 @@ void brcmf_txflowcontrol(struct device *dev, int ifidx, bool state)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	drvr->txoff = state;
 	ndev = drvr->iflist[ifidx]->ndev;
 	if (state == ON)
 		netif_stop_queue(ndev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index e0456e9..a7fe00f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -575,6 +575,8 @@ struct brcmf_sdio {
 
 	const struct firmware *firmware;
 	u32 fw_ptr;
+
+	bool txoff;		/* Transmit flow-controlled */
 };
 
 /* clkstate */
@@ -2297,8 +2299,10 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	/* Deflow-control stack if needed */
 	if (drvr->bus_if->drvr_up &&
 	    (drvr->bus_if->state == BRCMF_BUS_DATA) &&
-	    drvr->txoff && (pktq_len(&bus->txq) < TXLOW))
+	    bus->txoff && (pktq_len(&bus->txq) < TXLOW)) {
+		bus->txoff = OFF;
 		brcmf_txflowcontrol(bus->sdiodev->dev, 0, OFF);
+	}
 
 	return cnt;
 }
@@ -2611,8 +2615,10 @@ int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	}
 	spin_unlock_bh(&bus->txqlock);
 
-	if (pktq_len(&bus->txq) >= TXHI)
+	if (pktq_len(&bus->txq) >= TXHI) {
+		bus->txoff = ON;
 		brcmf_txflowcontrol(bus->sdiodev->dev, 0, ON);
+	}
 
 #ifdef BCMDBG
 	if (pktq_plen(&bus->txq, prec) > qcount[prec])
-- 
1.7.5.4


