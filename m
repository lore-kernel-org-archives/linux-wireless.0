Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:58691 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754804AbdFXVIh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Jun 2017 17:08:37 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] brcmfmac: fix double free upon register_netdevice() failure
Date: Sat, 24 Jun 2017 22:08:27 +0100
Message-Id: <1498338507-3432-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170624_230853_666092_EF3E6B20)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_net_attach() can only fail when register_netdevice()
fails. When this happens register_netdevice() calls priv_destructor, ie.
brcmf_cfg80211_free_netdev() freeing the vif instance. Also upon this
failure brcmf_net_attach() calls free_netdev(). However, callers are also
doing cleanup resulting in double free. In some places they need netdev
private space as it holds parameters to communicate with the device. So
we want to do the cleanup only in callers of brcmf_net_attach() by making
the following changes:

 - set priv_destructor after register_netdevice() succeeds.
 - remove call to free_netdev() in brcmf_net_attach().
 - call free_netdev() in brcmf_net_detach() for unregistered netdev.
 - add free_netdev() if brcmf_net_attach() fails for a created interface.

Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Kalle,

Here the patch to fix double free in brcmfmac. The patch is intended
for 4.13 and applies on top of following commit in the wireless-testing
tree:

  commit bd688e1cf6760af92562a5cac9b580338ebad62e (tag: wt-2017-06-21)
  Author: Stephen Rothwell <sfr@canb.auug.org.au>
  Date:   Thu Jun 8 12:24:08 2017 +1000

      Add localversion to identify builds from this tree

Regards,
Arend
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     | 5 ++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c      | 1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 2443c71..63e7683 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -625,6 +625,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 	err = brcmf_net_attach(ifp, true);
 	if (err) {
 		brcmf_err("Registering netdevice failed\n");
+		free_netdev(ifp->ndev);
 		goto fail;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index c60b897..b4c8643 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -485,13 +485,13 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 		goto fail;
 	}
 
+	ndev->priv_destructor = brcmf_cfg80211_free_netdev;
 	brcmf_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", ndev->name);
 	return 0;
 
 fail:
 	drvr->iflist[ifp->bsscfgidx] = NULL;
 	ndev->netdev_ops = NULL;
-	free_netdev(ndev);
 	return -EBADE;
 }
 
@@ -504,6 +504,7 @@ static void brcmf_net_detach(struct net_device *ndev, bool rtnl_locked)
 			unregister_netdev(ndev);
 	} else {
 		brcmf_cfg80211_free_netdev(ndev);
+		free_netdev(ndev);
 	}
 }
 
@@ -580,7 +581,6 @@ static int brcmf_net_p2p_attach(struct brcmf_if *ifp)
 fail:
 	ifp->drvr->iflist[ifp->bsscfgidx] = NULL;
 	ndev->netdev_ops = NULL;
-	free_netdev(ndev);
 	return -EBADE;
 }
 
@@ -626,7 +626,6 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 			return ERR_PTR(-ENOMEM);
 
 		ndev->needs_free_netdev = true;
-		ndev->priv_destructor = brcmf_cfg80211_free_netdev;
 		ifp = netdev_priv(ndev);
 		ifp->ndev = ndev;
 		/* store mapping ifidx to bsscfgidx */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index aa299c4..2ce675a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2208,6 +2208,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	err = brcmf_net_attach(ifp, true);
 	if (err) {
 		brcmf_err("Registering netdevice failed\n");
+		free_netdev(ifp->ndev);
 		goto fail;
 	}
 
-- 
1.9.1
