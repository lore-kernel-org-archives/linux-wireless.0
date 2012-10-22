Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2968 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab2JVRgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/14] brcmfmac: rework driver initialization in
 brcmf_bus_start()
Date: Mon, 22 Oct 2012 10:36:20 -0700
Message-ID: <1350927387-25608-8-git-send-email-frankyl@broadcom.com> (sfid-20121022_193650_930097_8D75F5D4)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

In brcmf_bus_start() a number of settings are sent to the device. For
this functions are used that bypass the common firmware interface.
By reordering the code in brcmf_bus_start() this bypass can be removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    3 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    3 -
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   17 ++++--
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   51 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    4 +-
 6 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index d848bb9..51d7754 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -735,6 +735,9 @@ extern int brcmf_c_host_event(struct brcmf_pub *drvr, int *idx,
 			      void *pktdata, struct brcmf_event_msg *,
 			      void **data_ptr);
 
+extern int brcmf_net_attach(struct brcmf_if *ifp);
+extern struct brcmf_if *brcmf_add_if(struct device *dev, int ifidx, s32 bssidx,
+				     char *name, u8 *mac_addr);
 extern void brcmf_del_if(struct brcmf_pub *drvr, int ifidx);
 
 extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index ba42e4e..265580f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -111,9 +111,6 @@ extern void brcmf_txcomplete(struct device *dev, struct sk_buff *txp,
 
 extern int brcmf_bus_start(struct device *dev);
 
-extern int brcmf_add_if(struct device *dev, int ifidx, s32 bssidx,
-			char *name, u8 *mac_addr);
-
 #ifdef CONFIG_BRCMFMAC_SDIO
 extern void brcmf_sdio_exit(void);
 extern void brcmf_sdio_init(void);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index bc62791..28b3eed 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -444,6 +444,7 @@ brcmf_c_host_event(struct brcmf_pub *drvr, int *ifidx, void *pktdata,
 	/* check whether packet is a BRCM event pkt */
 	struct brcmf_event *pvt_data = (struct brcmf_event *) pktdata;
 	struct brcmf_if_event *ifevent;
+	struct brcmf_if *ifp;
 	char *event_data;
 	u32 type, status;
 	u16 flags;
@@ -479,13 +480,17 @@ brcmf_c_host_event(struct brcmf_pub *drvr, int *ifidx, void *pktdata,
 		brcmf_dbg(TRACE, "if event\n");
 
 		if (ifevent->ifidx > 0 && ifevent->ifidx < BRCMF_MAX_IFS) {
-			if (ifevent->action == BRCMF_E_IF_ADD)
-				brcmf_add_if(drvr->dev,
-					     ifevent->ifidx, ifevent->bssidx,
-					     event->ifname,
-					     pvt_data->eth.h_dest);
-			else
+			if (ifevent->action == BRCMF_E_IF_ADD) {
+				ifp = brcmf_add_if(drvr->dev, ifevent->ifidx,
+						   ifevent->bssidx,
+						   event->ifname,
+						   pvt_data->eth.h_dest);
+				if (IS_ERR(ifp))
+					return PTR_ERR(ifp);
+				brcmf_net_attach(ifp);
+			} else {
 				brcmf_del_if(drvr, ifevent->ifidx);
+			}
 		} else {
 			brcmf_dbg(ERROR, "Invalid ifidx %d for %s\n",
 				  ifevent->ifidx, event->ifname);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index f603032..b1f26b5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -779,7 +779,7 @@ static const struct net_device_ops brcmf_netdev_ops_pri = {
 	.ndo_set_rx_mode = brcmf_netdev_set_multicast_list
 };
 
-static int brcmf_net_attach(struct brcmf_if *ifp)
+int brcmf_net_attach(struct brcmf_if *ifp)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct net_device *ndev;
@@ -813,15 +813,6 @@ static int brcmf_net_attach(struct brcmf_if *ifp)
 
 	memcpy(ndev->dev_addr, temp_addr, ETH_ALEN);
 
-	/* attach to cfg80211 for primary interface */
-	if (!ifp->idx) {
-		drvr->config = brcmf_cfg80211_attach(ndev, drvr->dev, drvr);
-		if (drvr->config == NULL) {
-			brcmf_dbg(ERROR, "wl_cfg80211_attach failed\n");
-			goto fail;
-		}
-	}
-
 	if (register_netdev(ndev) != 0) {
 		brcmf_dbg(ERROR, "couldn't register the net device\n");
 		goto fail;
@@ -833,12 +824,12 @@ static int brcmf_net_attach(struct brcmf_if *ifp)
 
 fail:
 	ndev->netdev_ops = NULL;
+	free_netdev(ndev);
 	return -EBADE;
 }
 
-int
-brcmf_add_if(struct device *dev, int ifidx, s32 bssidx,
-	     char *name, u8 *mac_addr)
+struct brcmf_if *brcmf_add_if(struct device *dev, int ifidx, s32 bssidx,
+			      char *name, u8 *mac_addr)
 {
 	struct brcmf_if *ifp;
 	struct net_device *ndev;
@@ -865,7 +856,7 @@ brcmf_add_if(struct device *dev, int ifidx, s32 bssidx,
 	ndev = alloc_netdev(sizeof(struct brcmf_if), name, ether_setup);
 	if (!ndev) {
 		brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	ifp = netdev_priv(ndev);
@@ -877,17 +868,10 @@ brcmf_add_if(struct device *dev, int ifidx, s32 bssidx,
 	if (mac_addr != NULL)
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
-	if (brcmf_net_attach(ifp)) {
-		brcmf_dbg(ERROR, "brcmf_net_attach failed");
-		free_netdev(ifp->ndev);
-		drvr->iflist[ifidx] = NULL;
-		return -EOPNOTSUPP;
-	}
-
 	brcmf_dbg(TRACE, " ==== pid:%x, net_device for if:%s created ===\n",
 		  current->pid, ifp->ndev->name);
 
-	return 0;
+	return ifp;
 }
 
 void brcmf_del_if(struct brcmf_pub *drvr, int ifidx)
@@ -970,6 +954,7 @@ int brcmf_bus_start(struct device *dev)
 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
+	struct brcmf_if *ifp;
 
 	brcmf_dbg(TRACE, "\n");
 
@@ -1006,21 +991,31 @@ int brcmf_bus_start(struct device *dev)
 	setbit(drvr->eventmask, BRCMF_E_SCAN_COMPLETE);
 	setbit(drvr->eventmask, BRCMF_E_IF);
 
-/* enable dongle roaming event */
-
-	drvr->pktfilter_count = 1;
 	/* Setup filter to allow only unicast */
+	drvr->pktfilter_count = 1;
 	drvr->pktfilter[0] = "100 0 0 0 0x01 0x00";
 
+	/* add primary networking interface */
+	ifp = brcmf_add_if(dev, 0, 0, "wlan%d", drvr->mac);
+	if (IS_ERR(ifp))
+		return PTR_ERR(ifp);
+
 	/* Bus is ready, do any protocol initialization */
 	ret = brcmf_proto_init(drvr);
 	if (ret < 0)
 		return ret;
 
-	/* add primary networking interface */
-	ret = brcmf_add_if(dev, 0, 0, "wlan%d", drvr->mac);
-	if (ret < 0)
+	drvr->config = brcmf_cfg80211_attach(drvr);
+	if (drvr->config == NULL)
+		return -ENOMEM;
+
+	ret = brcmf_net_attach(ifp);
+	if (ret < 0) {
+		brcmf_dbg(ERROR, "brcmf_net_attach failed");
+		drvr->iflist[0] = NULL;
 		return ret;
+	}
+
 
 	/* signal bus ready */
 	bus_if->state = BRCMF_BUS_DATA;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 24f5580..30e9c12 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4939,10 +4939,10 @@ static void wl_deinit_priv(struct brcmf_cfg80211_info *cfg)
 	brcmf_deinit_priv_mem(cfg);
 }
 
-struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct net_device *ndev,
-						  struct device *busdev,
-						  struct brcmf_pub *drvr)
+struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr)
 {
+	struct net_device *ndev = drvr->iflist[0]->ndev;
+	struct device *busdev = drvr->dev;
 	struct wireless_dev *wdev;
 	struct brcmf_cfg80211_info *cfg;
 	s32 err = 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 71ced17..1912625 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -500,9 +500,7 @@ brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_info *cfg)
 	return &cfg->conn_info;
 }
 
-struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct net_device *ndev,
-						  struct device *busdev,
-						  struct brcmf_pub *drvr);
+struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr);
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg);
 
 /* event handler from dongle */
-- 
1.7.6


