Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4128 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630Ab3E0TKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 15:10:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 5/7] brcmfmac: use struct
 net_device::destructor to remove interfaces
Date: Mon, 27 May 2013 21:09:57 +0200
Message-ID: <1369681799-3163-6-git-send-email-arend@broadcom.com> (sfid-20130527_211029_721940_0CE3AF92)
In-Reply-To: <1369681799-3163-1-git-send-email-arend@broadcom.com>
References: <1369681799-3163-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon deleting a P2P_CLIENT/GO interface the vif and consequently
the wdev is freed before the net_device is actually being unregistered
but cfg80211 still needs to access the wdev. Using destructor field
to free the net_device and vif.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    6 ++---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   23 +++++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    1 -
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index f04e355..b98f223 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -653,6 +653,7 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 
 	brcmf_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", ndev->name);
 
+	ndev->destructor = free_netdev;
 	return 0;
 
 fail:
@@ -793,6 +794,7 @@ void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 	struct brcmf_if *ifp;
 
 	ifp = drvr->iflist[bssidx];
+	drvr->iflist[bssidx] = NULL;
 	if (!ifp) {
 		brcmf_err("Null interface, idx=%d\n", bssidx);
 		return;
@@ -813,15 +815,13 @@ void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 			cancel_work_sync(&ifp->setmacaddr_work);
 			cancel_work_sync(&ifp->multicast_work);
 		}
-
+		/* unregister will take care of freeing it */
 		unregister_netdev(ifp->ndev);
 		if (bssidx == 0)
 			brcmf_cfg80211_detach(drvr->config);
-		free_netdev(ifp->ndev);
 	} else {
 		kfree(ifp);
 	}
-	drvr->iflist[bssidx] = NULL;
 }
 
 int brcmf_attach(uint bus_hdrlen, struct device *dev)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 167b7af..79555f0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2240,6 +2240,25 @@ static void brcmf_p2p_delete_p2pdev(struct brcmf_cfg80211_info *cfg,
 }
 
 /**
+ * brcmf_p2p_free_p2p_if() - free up net device related data.
+ *
+ * @ndev: net device that needs to be freed.
+ */
+static void brcmf_p2p_free_p2p_if(struct net_device *ndev)
+{
+	struct brcmf_cfg80211_info *cfg;
+	struct brcmf_cfg80211_vif *vif;
+	struct brcmf_if *ifp;
+
+	ifp = netdev_priv(ndev);
+	cfg = ifp->drvr->config;
+	vif = ifp->vif;
+
+	brcmf_free_vif(cfg, vif);
+	free_netdev(ifp->ndev);
+}
+
+/**
  * brcmf_p2p_add_vif() - create a new P2P virtual interface.
  *
  * @wiphy: wiphy device of new interface.
@@ -2316,6 +2335,9 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 		brcmf_err("Registering netdevice failed\n");
 		goto fail;
 	}
+	/* override destructor */
+	ifp->ndev->destructor = brcmf_p2p_free_p2p_if;
+
 	cfg->p2p.bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = vif;
 	/* Disable firmware roaming for P2P interface  */
 	brcmf_fil_iovar_int_set(ifp, "roam_off", 1);
@@ -2391,7 +2413,6 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 			err = 0;
 	}
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
-	brcmf_free_vif(cfg, vif);
 	p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = NULL;
 
 	return err;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index f8c86b5..656ce87 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4678,7 +4678,6 @@ static s32 brcmf_notify_vif_event(struct brcmf_if *ifp,
 		return 0;
 
 	case BRCMF_E_IF_DEL:
-		ifp->vif = NULL;
 		mutex_unlock(&event->vif_event_lock);
 		/* event may not be upon user request */
 		if (brcmf_cfg80211_vif_event_armed(cfg))
-- 
1.7.10.4


