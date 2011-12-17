Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1517 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760977Ab1LQChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/30] brcm80211: fmac: change function txflowcontrol
 parameter
Date: Fri, 16 Dec 2011 18:36:57 -0800
Message-ID: <1324089440-8957-8-git-send-email-frankyl@broadcom.com> (sfid-20111217_035945_751538_E99485CC)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change parameter to device pointer for bus layer interface function
brcmf_txflowcontrol. This is part of the fullmac bus interface
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
index 4e59c86..6577fc5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -706,7 +706,7 @@ extern s32 brcmf_exec_dcmd(struct net_device *dev, u32 cmd, void *arg, u32 len);
 extern void brcmf_detach(struct device *dev);
 
 /* Indication from bus module to change flow-control state */
-extern void brcmf_txflowcontrol(struct brcmf_pub *drvr, int ifidx, bool on);
+extern void brcmf_txflowcontrol(struct device *dev, int ifidx, bool on);
 
 extern bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 			 struct sk_buff *pkt, int prec);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 6b0739b..f82f87c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -348,9 +348,11 @@ done:
 	return 0;
 }
 
-void brcmf_txflowcontrol(struct brcmf_pub *drvr, int ifidx, bool state)
+void brcmf_txflowcontrol(struct device *dev, int ifidx, bool state)
 {
 	struct net_device *ndev;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 6e347ed..2253f7a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2289,7 +2289,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	/* Deflow-control stack if needed */
 	if (drvr->up && (drvr->bus_if->state == BRCMF_BUS_DATA) &&
 	    drvr->txoff && (pktq_len(&bus->txq) < TXLOW))
-		brcmf_txflowcontrol(drvr, 0, OFF);
+		brcmf_txflowcontrol(bus->sdiodev->dev, 0, OFF);
 
 	return cnt;
 }
@@ -2602,7 +2602,7 @@ int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	spin_unlock_bh(&bus->txqlock);
 
 	if (pktq_len(&bus->txq) >= TXHI)
-		brcmf_txflowcontrol(bus->drvr, 0, ON);
+		brcmf_txflowcontrol(bus->sdiodev->dev, 0, ON);
 
 #ifdef BCMDBG
 	if (pktq_plen(&bus->txq, prec) > qcount[prec])
-- 
1.7.5.4


