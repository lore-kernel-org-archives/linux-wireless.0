Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4688 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759832Ab2IKTTN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 15:19:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 1/7] brcmfmac: Stop all net if queues on tx flow
 halt.
Date: Tue, 11 Sep 2012 21:18:46 +0200
Message-ID: <1347391132-10953-2-git-send-email-arend@broadcom.com> (sfid-20120911_211917_578035_7E71B77F)
In-Reply-To: <1347391132-10953-1-git-send-email-arend@broadcom.com>
References: <1347391132-10953-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When tx flow is to be blocked due to host interface throttle then
all net if queues should be stopped.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   16 ++++++++++------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 ++++----
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 537f499..9b8ee19 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -103,7 +103,7 @@ extern int brcmf_attach(uint bus_hdrlen, struct device *dev);
 extern void brcmf_detach(struct device *dev);
 
 /* Indication from bus module to change flow-control state */
-extern void brcmf_txflowcontrol(struct device *dev, int ifidx, bool on);
+extern void brcmf_txflowblock(struct device *dev, bool state);
 
 /* Notify tx completion */
 extern void brcmf_txcomplete(struct device *dev, struct sk_buff *txp,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 7f9ba82..b08f347 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -350,19 +350,23 @@ done:
 	return 0;
 }
 
-void brcmf_txflowcontrol(struct device *dev, int ifidx, bool state)
+void brcmf_txflowblock(struct device *dev, bool state)
 {
 	struct net_device *ndev;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
+	int i;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	ndev = drvr->iflist[ifidx]->ndev;
-	if (state == ON)
-		netif_stop_queue(ndev);
-	else
-		netif_wake_queue(ndev);
+	for (i = 0; i < BRCMF_MAX_IFS; i++)
+		if (drvr->iflist[i]) {
+			ndev = drvr->iflist[i]->ndev;
+			if (state)
+				netif_stop_queue(ndev);
+			else
+				netif_wake_queue(ndev);
+		}
 }
 
 static int brcmf_host_event(struct brcmf_pub *drvr, int *ifidx,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2dd6b48..4580ff3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2235,8 +2235,8 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	if (bus->sdiodev->bus_if->drvr_up &&
 	    (bus->sdiodev->bus_if->state == BRCMF_BUS_DATA) &&
 	    bus->txoff && (pktq_len(&bus->txq) < TXLOW)) {
-		bus->txoff = OFF;
-		brcmf_txflowcontrol(bus->sdiodev->dev, 0, OFF);
+		bus->txoff = false;
+		brcmf_txflowblock(bus->sdiodev->dev, false);
 	}
 
 	return cnt;
@@ -2672,8 +2672,8 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	spin_unlock_bh(&bus->txqlock);
 
 	if (pktq_len(&bus->txq) >= TXHI) {
-		bus->txoff = ON;
-		brcmf_txflowcontrol(bus->sdiodev->dev, 0, ON);
+		bus->txoff = true;
+		brcmf_txflowblock(bus->sdiodev->dev, true);
 	}
 
 #ifdef DEBUG
-- 
1.7.9.5


