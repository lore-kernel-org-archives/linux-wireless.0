Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3779 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab1JUNzd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 09:55:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/17] brcm80211: fmac: use brcmf_del_if for all net
 devices
Date: Fri, 21 Oct 2011 15:55:04 +0200
Message-ID: <1319205319-16891-3-git-send-email-arend@broadcom.com> (sfid-20111021_155601_500274_C6B0E46A)
In-Reply-To: <1319205319-16891-1-git-send-email-arend@broadcom.com>
References: <1319205319-16891-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use brcmf_del_if for primary and virtual net device interfaces. This
is part of the net device interface clean up for fullmac.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   55 +++++++++----------
 1 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 4acbac5..6739ece 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -893,6 +893,16 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	return ret;
 }
 
+static const struct net_device_ops brcmf_netdev_ops_pri = {
+	.ndo_open = brcmf_netdev_open,
+	.ndo_stop = brcmf_netdev_stop,
+	.ndo_get_stats = brcmf_netdev_get_stats,
+	.ndo_do_ioctl = brcmf_netdev_ioctl_entry,
+	.ndo_start_xmit = brcmf_netdev_start_xmit,
+	.ndo_set_mac_address = brcmf_netdev_set_mac_address,
+	.ndo_set_rx_mode = brcmf_netdev_set_multicast_list
+};
+
 int
 brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *ndev,
 	     char *name, u8 *mac_addr, u32 flags, u8 bssidx)
@@ -977,14 +987,23 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 		brcmf_dbg(ERROR, "Null interface\n");
 		return;
 	}
-
 	ifp->state = BRCMF_E_IF_DEL;
-	ifp->idx = ifidx;
-	if (ifp->ndev != NULL) {
-		netif_stop_queue(ifp->ndev);
+	if (ifp->ndev) {
+		if (ifidx == 0) {
+			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
+				rtnl_lock();
+				brcmf_netdev_stop(ifp->ndev);
+				rtnl_unlock();
+			}
+		} else {
+			netif_stop_queue(ifp->ndev);
+		}
+
 		unregister_netdev(ifp->ndev);
-		free_netdev(ifp->ndev);
 		drvr_priv->iflist[ifidx] = NULL;
+		if (ifidx == 0)
+			brcmf_cfg80211_detach(drvr_priv->pub.config);
+		free_netdev(ifp->ndev);
 		kfree(ifp);
 	}
 }
@@ -1123,16 +1142,6 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 	return 0;
 }
 
-static struct net_device_ops brcmf_netdev_ops_pri = {
-	.ndo_open = brcmf_netdev_open,
-	.ndo_stop = brcmf_netdev_stop,
-	.ndo_get_stats = brcmf_netdev_get_stats,
-	.ndo_do_ioctl = brcmf_netdev_ioctl_entry,
-	.ndo_start_xmit = brcmf_netdev_start_xmit,
-	.ndo_set_mac_address = brcmf_netdev_set_mac_address,
-	.ndo_set_rx_mode = brcmf_netdev_set_multicast_list
-};
-
 int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
@@ -1210,21 +1219,13 @@ void brcmf_detach(struct brcmf_pub *drvr)
 	if (drvr) {
 		drvr_priv = drvr->info;
 		if (drvr_priv) {
-			struct brcmf_if *ifp;
 			int i;
 
-			for (i = 1; i < BRCMF_MAX_IFS; i++)
+			/* make sure primary interface removed last */
+			for (i = BRCMF_MAX_IFS-1; i > -1; i--)
 				if (drvr_priv->iflist[i])
 					brcmf_del_if(drvr_priv, i);
 
-			ifp = drvr_priv->iflist[0];
-			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
-				rtnl_lock();
-				brcmf_netdev_stop(ifp->ndev);
-				rtnl_unlock();
-				unregister_netdev(ifp->ndev);
-			}
-
 			cancel_work_sync(&drvr_priv->setmacaddr_work);
 			cancel_work_sync(&drvr_priv->multicast_work);
 
@@ -1233,10 +1234,6 @@ void brcmf_detach(struct brcmf_pub *drvr)
 			if (drvr->prot)
 				brcmf_proto_detach(drvr);
 
-			brcmf_cfg80211_detach(drvr->config);
-
-			free_netdev(ifp->ndev);
-			kfree(ifp);
 			kfree(drvr_priv);
 		}
 	}
-- 
1.7.4.1


