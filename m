Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1349 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803Ab1JUOQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:16:48 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 14/17] brcm80211: fmac: use brcmf_add_if for all net
 devices
Date: Fri, 21 Oct 2011 16:16:32 +0200
Message-ID: <1319206595-17138-15-git-send-email-arend@broadcom.com> (sfid-20111021_161703_434611_4E86A119)
In-Reply-To: <1319206595-17138-1-git-send-email-arend@broadcom.com>
References: <1319206595-17138-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use brcmf_add_if for primary and virtual net device interfaces. This
is part of the net device interface clean up for fullmac.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    3 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    5 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  125 ++++++++------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    7 +-
 4 files changed, 54 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 54b055b..2cf22e0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -729,8 +729,7 @@ extern int brcmf_c_host_event(struct brcmf_info *drvr_priv, int *idx,
 extern void brcmf_c_init(void);
 
 extern int brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx,
-			struct net_device *ndev, char *name, u8 *mac_addr,
-			u32 flags, u8 bssidx);
+			char *name, u8 *mac_addr);
 extern void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx);
 
 /* Send packet to dongle via data channel */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 8918261..40928e5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -488,10 +488,9 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 
 		if (ifevent->ifidx > 0 && ifevent->ifidx < BRCMF_MAX_IFS) {
 			if (ifevent->action == BRCMF_E_IF_ADD)
-				brcmf_add_if(drvr_priv, ifevent->ifidx, NULL,
+				brcmf_add_if(drvr_priv, ifevent->ifidx,
 					     event->ifname,
-					     pvt_data->eth.h_dest,
-					     ifevent->flags, ifevent->bssidx);
+					     pvt_data->eth.h_dest);
 			else
 				brcmf_del_if(drvr_priv, ifevent->ifidx);
 		} else {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 6739ece..14ac210 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -904,30 +904,21 @@ static const struct net_device_ops brcmf_netdev_ops_pri = {
 };
 
 int
-brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *ndev,
-	     char *name, u8 *mac_addr, u32 flags, u8 bssidx)
+brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, char *name, u8 *mac_addr)
 {
 	struct brcmf_if *ifp;
-	int ret = 0, err = 0;
+	int err = 0;
 
-	brcmf_dbg(TRACE, "idx %d, handle->%p\n", ifidx, ndev);
+	brcmf_dbg(TRACE, "idx %d\n", ifidx);
 
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
 		ifp = kmalloc(sizeof(struct brcmf_if), GFP_ATOMIC);
 		if (!ifp)
 			return -ENOMEM;
-	}
 
-	memset(ifp, 0, sizeof(struct brcmf_if));
-	ifp->info = drvr_priv;
-	drvr_priv->iflist[ifidx] = ifp;
-	if (mac_addr != NULL)
-		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
-
-	if (ndev == NULL) {
-		ifp->state = BRCMF_E_IF_ADD;
-		ifp->idx = ifidx;
+		drvr_priv->iflist[ifidx] = ifp;
+	} else {
 		/*
 		 * Delete the existing interface before overwriting it
 		 * in case we missed the BRCMF_E_IF_DEL event.
@@ -939,41 +930,42 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *ndev,
 			unregister_netdev(ifp->ndev);
 			free_netdev(ifp->ndev);
 		}
+	}
+	memset(ifp, 0, sizeof(struct brcmf_if));
+	ifp->info = drvr_priv;
+	drvr_priv->iflist[ifidx] = ifp;
+	ifp->state = BRCMF_E_IF_ADD;
+	ifp->idx = ifidx;
 
-		/* Allocate netdev, including space for private structure */
-		ifp->ndev = alloc_netdev(sizeof(drvr_priv), "wlan%d",
-					 ether_setup);
-		if (!ifp->ndev) {
-			brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
-			ret = -ENOMEM;
-		}
+	/* Allocate netdev, including space for private structure */
+	ifp->ndev = alloc_netdev(sizeof(drvr_priv), name, ether_setup);
+	if (!ifp->ndev) {
+		brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
+		err = -ENOMEM;
+		goto errout;
+	}
 
-		if (ret == 0) {
-			memcpy(netdev_priv(ifp->ndev), &drvr_priv,
-			       sizeof(drvr_priv));
-			err = brcmf_net_attach(&drvr_priv->pub, ifp->idx);
-			if (err != 0) {
-				brcmf_dbg(ERROR, "brcmf_net_attach failed, err %d\n",
-					  err);
-				ret = -EOPNOTSUPP;
-			} else {
-				brcmf_dbg(TRACE, " ==== pid:%x, net_device for if:%s created ===\n",
-					  current->pid, ifp->ndev->name);
-				ifp->state = 0;
-			}
-		}
+	if (mac_addr != NULL)
+		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
-		if (ret < 0) {
-			if (ifp->ndev)
-				free_netdev(ifp->ndev);
+	memcpy(netdev_priv(ifp->ndev), &drvr_priv, sizeof(drvr_priv));
+	if (brcmf_net_attach(&drvr_priv->pub, ifp->idx)) {
+		brcmf_dbg(ERROR, "brcmf_net_attach failed");
+		free_netdev(ifp->ndev);
+		err = -EOPNOTSUPP;
+		goto errout;
+	}
 
-			drvr_priv->iflist[ifp->idx] = NULL;
-			kfree(ifp);
-		}
-	} else
-		ifp->ndev = ndev;
+	brcmf_dbg(TRACE, " ==== pid:%x, net_device for if:%s created ===\n",
+		  current->pid, ifp->ndev->name);
+	ifp->state = 0;
 
 	return 0;
+
+errout:
+	kfree(ifp);
+	drvr_priv->iflist[ifidx] = NULL;
+	return err;
 }
 
 void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
@@ -1011,32 +1003,14 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 {
 	struct brcmf_info *drvr_priv = NULL;
-	struct net_device *ndev;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/* Allocate netdev, including space for private structure */
-	ndev = alloc_netdev(sizeof(drvr_priv), "wlan%d", ether_setup);
-	if (!ndev) {
-		brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
-		goto fail;
-	}
-
 	/* Allocate primary brcmf_info */
 	drvr_priv = kzalloc(sizeof(struct brcmf_info), GFP_ATOMIC);
 	if (!drvr_priv)
 		goto fail;
 
-	/*
-	 * Save the brcmf_info into the priv
-	 */
-	memcpy(netdev_priv(ndev), &drvr_priv, sizeof(drvr_priv));
-
-	if (brcmf_add_if(drvr_priv, 0, ndev, ndev->name, NULL, 0, 0) ==
-	    BRCMF_BAD_IF)
-		goto fail;
-
-	ndev->netdev_ops = NULL;
 	mutex_init(&drvr_priv->proto_block);
 
 	/* Link to info module */
@@ -1052,29 +1026,12 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 		goto fail;
 	}
 
-	/* Attach and link in the cfg80211 */
-	drvr_priv->pub.config =
-			brcmf_cfg80211_attach(ndev,
-					      brcmf_bus_get_device(bus),
-					      &drvr_priv->pub);
-	if (drvr_priv->pub.config == NULL) {
-		brcmf_dbg(ERROR, "wl_cfg80211_attach failed\n");
-		goto fail;
-	}
-
 	INIT_WORK(&drvr_priv->setmacaddr_work, _brcmf_set_mac_address);
 	INIT_WORK(&drvr_priv->multicast_work, _brcmf_set_multicast_list);
 
-	/*
-	 * Save the brcmf_info into the priv
-	 */
-	memcpy(netdev_priv(ndev), &drvr_priv, sizeof(drvr_priv));
-
 	return &drvr_priv->pub;
 
 fail:
-	if (ndev)
-		free_netdev(ndev);
 	if (drvr_priv)
 		brcmf_detach(&drvr_priv->pub);
 
@@ -1178,6 +1135,18 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 
 	memcpy(ndev->dev_addr, temp_addr, ETH_ALEN);
 
+	/* attach to cfg80211 for primary interface */
+	if (!ifidx) {
+		drvr->config =
+			brcmf_cfg80211_attach(ndev,
+					      brcmf_bus_get_device(drvr->bus),
+					      drvr);
+		if (drvr->config == NULL) {
+			brcmf_dbg(ERROR, "wl_cfg80211_attach failed\n");
+			goto fail;
+		}
+	}
+
 	if (register_netdev(ndev) != 0) {
 		brcmf_dbg(ERROR, "couldn't register the net device\n");
 		goto fail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 785ab08..6de489b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -4546,9 +4546,10 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 			goto fail;
 		}
 	}
-	/* Ok, have the per-port tell the stack we're open for business */
-	if (brcmf_net_attach(bus->drvr, 0) != 0) {
-		brcmf_dbg(ERROR, "Net attach failed!!\n");
+
+	/* add interface and open for business */
+	if (brcmf_add_if((struct brcmf_info *)bus->drvr, 0, "wlan%d", NULL)) {
+		brcmf_dbg(ERROR, "Add primary net device interface failed!!\n");
 		goto fail;
 	}
 
-- 
1.7.4.1


