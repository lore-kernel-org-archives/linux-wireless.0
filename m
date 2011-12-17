Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1493 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760984Ab1LQChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/30] brcm80211: fmac: move driver up status to struct
 brcmf_bus
Date: Fri, 16 Dec 2011 18:37:04 -0800
Message-ID: <1324089440-8957-15-git-send-email-frankyl@broadcom.com> (sfid-20111217_035946_026464_EA1DF83E)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver up/down status to network interface need to be shared by
common layer and bus layer. Move it to bus interface structure
brcmf_bus as part of the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   18 +++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 +++--
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index db30f02..4dcb11d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -577,6 +577,7 @@ struct brcmf_bus {
 	void *drvr;		/* pointer to driver pub structure brcmf_pub */
 	enum brcmf_bus_state state;
 	uint maxctl;		/* Max size rxctl request from proto to bus */
+	bool drvr_up;		/* Status flag of driver up/down */
 };
 
 /* Forward decls for struct brcmf_pub (see below) */
@@ -594,7 +595,6 @@ struct brcmf_pub {
 	struct device *dev;		/* fullmac dongle device pointer */
 
 	/* Internal brcmf items */
-	bool up;		/* Driver up/down (to OS) */
 	bool txoff;		/* Transmit flow-controlled */
 	uint hdrlen;		/* Total BRCMF header length (proto + bus) */
 	uint rxsz;		/* Rx buffer size bus module should use */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 576cdc4..5e9acf8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -273,7 +273,7 @@ static void brcmf_netdev_set_multicast_list(struct net_device *ndev)
 int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
 {
 	/* Reject if down */
-	if (!drvr->up || (drvr->bus_if->state == BRCMF_BUS_DOWN))
+	if (!drvr->bus_if->drvr_up || (drvr->bus_if->state == BRCMF_BUS_DOWN))
 		return -ENODEV;
 
 	/* Update multicast statistic */
@@ -303,10 +303,10 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Reject if down */
-	if (!drvr->up ||
+	if (!drvr->bus_if->drvr_up ||
 	    (drvr->bus_if->state == BRCMF_BUS_DOWN)) {
-		brcmf_dbg(ERROR, "xmit rejected pub.up=%d state=%d\n",
-			  drvr->up,
+		brcmf_dbg(ERROR, "xmit rejected drvup=%d state=%d\n",
+			  drvr->bus_if->drvr_up,
 			  drvr->bus_if->state);
 		netif_stop_queue(ndev);
 		return -ENODEV;
@@ -487,7 +487,7 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (drvr->up)
+	if (drvr->bus_if->drvr_up)
 		/* Use the protocol to get dongle stats */
 		brcmf_proto_dstats(drvr);
 
@@ -633,7 +633,7 @@ static int brcmf_ethtool(struct brcmf_pub *drvr, void __user *uaddr)
 		}
 
 		/* otherwise, require dongle to be up */
-		else if (!drvr->up) {
+		else if (!drvr->bus_if->drvr_up) {
 			brcmf_dbg(ERROR, "dongle is not up\n");
 			return -ENODEV;
 		}
@@ -785,11 +785,11 @@ static int brcmf_netdev_stop(struct net_device *ndev)
 
 	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_cfg80211_down(drvr->config);
-	if (drvr->up == 0)
+	if (drvr->bus_if->drvr_up == 0)
 		return 0;
 
 	/* Set state and stop OS transmissions */
-	drvr->up = 0;
+	drvr->bus_if->drvr_up = 0;
 	netif_stop_queue(ndev);
 
 	return 0;
@@ -826,7 +826,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	}
 	/* Allow transmit calls */
 	netif_start_queue(ndev);
-	drvr->up = 1;
+	drvr->bus_if->drvr_up = 1;
 	if (brcmf_cfg80211_up(drvr->config)) {
 		brcmf_dbg(ERROR, "failed to bring up cfg80211\n");
 		return -1;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index cc2c653..6c5b5b5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2295,7 +2295,8 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	}
 
 	/* Deflow-control stack if needed */
-	if (drvr->up && (drvr->bus_if->state == BRCMF_BUS_DATA) &&
+	if (drvr->bus_if->drvr_up &&
+	    (drvr->bus_if->state == BRCMF_BUS_DATA) &&
 	    drvr->txoff && (pktq_len(&bus->txq) < TXLOW))
 		brcmf_txflowcontrol(bus->sdiodev->dev, 0, OFF);
 
@@ -2974,7 +2975,7 @@ static int brcmf_sdbrcm_downloadvars(struct brcmf_sdio *bus, void *arg, int len)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Basic sanity checks */
-	if (bus->drvr->up) {
+	if (bus->sdiodev->bus_if->drvr_up) {
 		bcmerror = -EISCONN;
 		goto err;
 	}
-- 
1.7.5.4


