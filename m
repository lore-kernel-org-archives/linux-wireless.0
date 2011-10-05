Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2288 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934694Ab1JENUa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/15] staging: brcm80211: remove brcmf_op_if from
 fullmac
Date: Wed, 5 Oct 2011 15:20:14 +0200
Message-ID: <1317820814-7083-16-git-send-email-arend@broadcom.com> (sfid-20111005_152035_462416_5AA5F862)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Absorb related code into brcmf_add_if/brcmf_del_if. This is part
of the net device interface clean up.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |  120 ++++++++++--------------
 1 files changed, 50 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index b0202b7..99ba5e3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -282,74 +282,6 @@ _brcmf_set_mac_address(struct work_struct *work)
 	return;
 }
 
-/* Virtual interfaces only ((ifp && ifp->info && ifp->idx == true) */
-static void brcmf_op_if(struct brcmf_if *ifp)
-{
-	struct brcmf_info *drvr_priv;
-	int ret = 0, err = 0;
-
-	drvr_priv = ifp->info;
-
-	brcmf_dbg(TRACE, "idx %d, state %d\n", ifp->idx, ifp->state);
-
-	switch (ifp->state) {
-	case BRCMF_E_IF_ADD:
-		/*
-		 * Delete the existing interface before overwriting it
-		 * in case we missed the BRCMF_E_IF_DEL event.
-		 */
-		if (ifp->ndev != NULL) {
-			brcmf_dbg(ERROR, "ERROR: netdev:%s already exists, try free & unregister\n",
-				  ifp->ndev->name);
-			netif_stop_queue(ifp->ndev);
-			unregister_netdev(ifp->ndev);
-			free_netdev(ifp->ndev);
-		}
-		/* Allocate netdev, including space for private structure */
-		ifp->ndev = alloc_netdev(sizeof(drvr_priv), "wlan%d",
-					 ether_setup);
-		if (!ifp->ndev) {
-			brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
-			ret = -ENOMEM;
-		}
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
-		break;
-	case BRCMF_E_IF_DEL:
-		if (ifp->ndev != NULL) {
-			brcmf_dbg(TRACE, "got 'WLC_E_IF_DEL' state\n");
-			netif_stop_queue(ifp->ndev);
-			unregister_netdev(ifp->ndev);
-			ret = BRCMF_DEL_IF;	/* Make sure the free_netdev()
-							 is called */
-		}
-		break;
-	default:
-		brcmf_dbg(ERROR, "bad op %d\n", ifp->state);
-		break;
-	}
-
-	if (ret < 0) {
-		if (ifp->ndev)
-			free_netdev(ifp->ndev);
-
-		drvr_priv->iflist[ifp->idx] = NULL;
-		kfree(ifp);
-	}
-}
-
 static int brcmf_netdev_set_mac_address(struct net_device *ndev, void *addr)
 {
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
@@ -964,6 +896,7 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *ndev,
 	     char *name, u8 *mac_addr, u32 flags, u8 bssidx)
 {
 	struct brcmf_if *ifp;
+	int ret = 0, err = 0;
 
 	brcmf_dbg(TRACE, "idx %d, handle->%p\n", ifidx, ndev);
 
@@ -983,7 +916,48 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *ndev,
 	if (ndev == NULL) {
 		ifp->state = BRCMF_E_IF_ADD;
 		ifp->idx = ifidx;
-		brcmf_op_if(ifp);
+		/*
+		 * Delete the existing interface before overwriting it
+		 * in case we missed the BRCMF_E_IF_DEL event.
+		 */
+		if (ifp->ndev != NULL) {
+			brcmf_dbg(ERROR, "ERROR: netdev:%s already exists, try free & unregister\n",
+				  ifp->ndev->name);
+			netif_stop_queue(ifp->ndev);
+			unregister_netdev(ifp->ndev);
+			free_netdev(ifp->ndev);
+		}
+
+		/* Allocate netdev, including space for private structure */
+		ifp->ndev = alloc_netdev(sizeof(drvr_priv), "wlan%d",
+					 ether_setup);
+		if (!ifp->ndev) {
+			brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
+			ret = -ENOMEM;
+		}
+
+		if (ret == 0) {
+			memcpy(netdev_priv(ifp->ndev), &drvr_priv,
+			       sizeof(drvr_priv));
+			err = brcmf_net_attach(&drvr_priv->pub, ifp->idx);
+			if (err != 0) {
+				brcmf_dbg(ERROR, "brcmf_net_attach failed, err %d\n",
+					  err);
+				ret = -EOPNOTSUPP;
+			} else {
+				brcmf_dbg(TRACE, " ==== pid:%x, net_device for if:%s created ===\n",
+					  current->pid, ifp->ndev->name);
+				ifp->state = 0;
+			}
+		}
+
+		if (ret < 0) {
+			if (ifp->ndev)
+				free_netdev(ifp->ndev);
+
+			drvr_priv->iflist[ifp->idx] = NULL;
+			kfree(ifp);
+		}
 	} else
 		ifp->ndev = ndev;
 
@@ -1004,7 +978,13 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 
 	ifp->state = BRCMF_E_IF_DEL;
 	ifp->idx = ifidx;
-	brcmf_op_if(ifp);
+	if (ifp->ndev != NULL) {
+		netif_stop_queue(ifp->ndev);
+		unregister_netdev(ifp->ndev);
+		free_netdev(ifp->ndev);
+		drvr_priv->iflist[ifidx] = NULL;
+		kfree(ifp);
+	}
 }
 
 struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
-- 
1.7.4.1


