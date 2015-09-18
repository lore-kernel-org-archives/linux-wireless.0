Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:13486 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbbIRUI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/16] brcmfmac: Deleting of p2p device is leaking memory.
Date: Fri, 18 Sep 2015 22:08:12 +0200
Message-ID: <1442606899-31872-10-git-send-email-arend@broadcom.com> (sfid-20150918_220842_055810_3746DE5B)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When a p2p device gets deleted, the memory for the vif is not being
released. This is solved by reorganizing the cleanup path and
properly freeing the memory.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c | 13 ++++++++-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c  | 38 +++++++++++++-------------
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h  |  1 +
 3 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 031283a..8c2a280 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -887,6 +887,16 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 			cancel_work_sync(&ifp->multicast_work);
 		}
 		brcmf_net_detach(ifp->ndev);
+	} else {
+		/* Only p2p device interfaces which get dynamically created
+		 * end up here. In this case the p2p module should be informed
+		 * about the removal of the interface within the firmware. If
+		 * not then p2p commands towards the firmware will cause some
+		 * serious troublesome side effects. The p2p module will clean
+		 * up the ifp if needed.
+		 */
+		brcmf_p2p_ifp_removed(ifp);
+		kfree(ifp);
 	}
 }
 
@@ -894,7 +904,8 @@ void brcmf_remove_interface(struct brcmf_if *ifp)
 {
 	if (!ifp || WARN_ON(ifp->drvr->iflist[ifp->bssidx] != ifp))
 		return;
-
+	brcmf_dbg(TRACE, "Enter, bssidx=%d, ifidx=%d\n", ifp->bssidx,
+		  ifp->ifidx);
 	brcmf_fws_del_interface(ifp);
 	brcmf_del_if(ifp->drvr, ifp->bssidx);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 1e09cd2..83027dc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2131,20 +2131,6 @@ fail:
 }
 
 /**
- * brcmf_p2p_delete_p2pdev() - delete P2P_DEVICE virtual interface.
- *
- * @vif: virtual interface object to delete.
- */
-static void brcmf_p2p_delete_p2pdev(struct brcmf_p2p_info *p2p,
-				    struct brcmf_cfg80211_vif *vif)
-{
-	cfg80211_unregister_wdev(&vif->wdev);
-	p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
-	brcmf_remove_interface(vif->ifp);
-	brcmf_free_vif(vif);
-}
-
-/**
  * brcmf_p2p_add_vif() - create a new P2P virtual interface.
  *
  * @wiphy: wiphy device of new interface.
@@ -2267,9 +2253,11 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 		break;
 
 	case NL80211_IFTYPE_P2P_DEVICE:
+		if (!p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
+			return 0;
 		brcmf_p2p_cancel_remain_on_channel(vif->ifp);
 		brcmf_p2p_deinit_discovery(p2p);
-		brcmf_p2p_delete_p2pdev(p2p, vif);
+		brcmf_remove_interface(vif->ifp);
 		return 0;
 	default:
 		return -ENOTSUPP;
@@ -2301,6 +2289,21 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 	return err;
 }
 
+void brcmf_p2p_ifp_removed(struct brcmf_if *ifp)
+{
+	struct brcmf_cfg80211_info *cfg;
+	struct brcmf_cfg80211_vif *vif;
+
+	brcmf_dbg(INFO, "P2P: device interface removed\n");
+	vif = ifp->vif;
+	cfg = wdev_to_cfg(&vif->wdev);
+	cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
+	rtnl_lock();
+	cfg80211_unregister_wdev(&vif->wdev);
+	rtnl_unlock();
+	brcmf_free_vif(vif);
+}
+
 int brcmf_p2p_start_device(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
@@ -2425,10 +2428,7 @@ void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
 	if (vif != NULL) {
 		brcmf_p2p_cancel_remain_on_channel(vif->ifp);
 		brcmf_p2p_deinit_discovery(p2p);
-		/* remove discovery interface */
-		rtnl_lock();
-		brcmf_p2p_delete_p2pdev(p2p, vif);
-		rtnl_unlock();
+		brcmf_remove_interface(vif->ifp);
 	}
 	/* just set it all to zero */
 	memset(p2p, 0, sizeof(*p2p));
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index d82287d..5d49059 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -157,6 +157,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev);
 int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 		       enum brcmf_fil_p2p_if_types if_type);
+void brcmf_p2p_ifp_removed(struct brcmf_if *ifp);
 int brcmf_p2p_start_device(struct wiphy *wiphy, struct wireless_dev *wdev);
 void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev);
 int brcmf_p2p_scan_prep(struct wiphy *wiphy,
-- 
1.9.1

