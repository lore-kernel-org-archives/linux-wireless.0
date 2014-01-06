Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:50440 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbaAFLk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:59 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 12/15] brcmfmac: move wiphy_unregister() call to brcmf_cfg80211_detach()
Date: Mon, 6 Jan 2014 12:40:47 +0100
Message-ID: <1389008450-28529-13-git-send-email-arend@broadcom.com> (sfid-20140106_130435_688502_41989488)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wiphy_unregister() call was done in brcmf_free_vif() when the
last interface was being removed. This is not the obvious place to
do that. This patch moves it to the brcmf_cfg80211_detach(). This
removes the need to keep count of interfaces.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   26 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   26 +++++---------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    4 +--
 3 files changed, 18 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index d318036..af5c4c7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1956,21 +1956,21 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
 		err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
 		if (err < 0) {
 			brcmf_err("set p2p_disc error\n");
-			brcmf_free_vif(cfg, p2p_vif);
+			brcmf_free_vif(p2p_vif);
 			goto exit;
 		}
 		/* obtain bsscfg index for P2P discovery */
 		err = brcmf_fil_iovar_int_get(pri_ifp, "p2p_dev", &bssidx);
 		if (err < 0) {
 			brcmf_err("retrieving discover bsscfg index failed\n");
-			brcmf_free_vif(cfg, p2p_vif);
+			brcmf_free_vif(p2p_vif);
 			goto exit;
 		}
 		/* Verify that firmware uses same bssidx as driver !! */
 		if (p2p_ifp->bssidx != bssidx) {
 			brcmf_err("Incorrect bssidx=%d, compared to p2p_ifp->bssidx=%d\n",
 				  bssidx, p2p_ifp->bssidx);
-			brcmf_free_vif(cfg, p2p_vif);
+			brcmf_free_vif(p2p_vif);
 			goto exit;
 		}
 
@@ -1998,7 +1998,7 @@ void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
 		brcmf_p2p_cancel_remain_on_channel(vif->ifp);
 		brcmf_p2p_deinit_discovery(p2p);
 		/* remove discovery interface */
-		brcmf_free_vif(p2p->cfg, vif);
+		brcmf_free_vif(vif);
 		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
 	}
 	/* just set it all to zero */
@@ -2223,7 +2223,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	return &p2p_vif->wdev;
 
 fail:
-	brcmf_free_vif(p2p->cfg, p2p_vif);
+	brcmf_free_vif(p2p_vif);
 	return ERR_PTR(err);
 }
 
@@ -2232,12 +2232,12 @@ fail:
  *
  * @vif: virtual interface object to delete.
  */
-static void brcmf_p2p_delete_p2pdev(struct brcmf_cfg80211_info *cfg,
+static void brcmf_p2p_delete_p2pdev(struct brcmf_p2p_info *p2p,
 				    struct brcmf_cfg80211_vif *vif)
 {
 	cfg80211_unregister_wdev(&vif->wdev);
-	cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
-	brcmf_free_vif(cfg, vif);
+	p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
+	brcmf_free_vif(vif);
 }
 
 /**
@@ -2247,15 +2247,13 @@ static void brcmf_p2p_delete_p2pdev(struct brcmf_cfg80211_info *cfg,
  */
 static void brcmf_p2p_free_p2p_if(struct net_device *ndev)
 {
-	struct brcmf_cfg80211_info *cfg;
 	struct brcmf_cfg80211_vif *vif;
 	struct brcmf_if *ifp;
 
 	ifp = netdev_priv(ndev);
-	cfg = ifp->drvr->config;
 	vif = ifp->vif;
 
-	brcmf_free_vif(cfg, vif);
+	brcmf_free_vif(vif);
 	free_netdev(ifp->ndev);
 }
 
@@ -2350,7 +2348,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	return &ifp->vif->wdev;
 
 fail:
-	brcmf_free_vif(cfg, vif);
+	brcmf_free_vif(vif);
 	return ERR_PTR(err);
 }
 
@@ -2359,8 +2357,6 @@ fail:
  *
  * @wiphy: wiphy device of interface.
  * @wdev: wireless device of interface.
- *
- * TODO: not yet supported.
  */
 int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
@@ -2386,7 +2382,7 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 		break;
 
 	case NL80211_IFTYPE_P2P_DEVICE:
-		brcmf_p2p_delete_p2pdev(cfg, vif);
+		brcmf_p2p_delete_p2pdev(p2p, vif);
 		return 0;
 	default:
 		return -ENOTSUPP;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 8cc9444..5598a20 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4360,9 +4360,6 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 {
 	struct brcmf_cfg80211_vif *vif;
 
-	if (cfg->vif_cnt == BRCMF_IFACE_MAX_CNT)
-		return ERR_PTR(-ENOSPC);
-
 	brcmf_dbg(TRACE, "allocating virtual interface (size=%zu)\n",
 		  sizeof(*vif));
 	vif = kzalloc(sizeof(*vif), GFP_KERNEL);
@@ -4379,21 +4376,13 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 	brcmf_init_prof(&vif->profile);
 
 	list_add_tail(&vif->list, &cfg->vif_list);
-	cfg->vif_cnt++;
 	return vif;
 }
 
-void brcmf_free_vif(struct brcmf_cfg80211_info *cfg,
-		    struct brcmf_cfg80211_vif *vif)
+void brcmf_free_vif(struct brcmf_cfg80211_vif *vif)
 {
 	list_del(&vif->list);
-	cfg->vif_cnt--;
-
 	kfree(vif);
-	if (!cfg->vif_cnt) {
-		wiphy_unregister(cfg->wiphy);
-		wiphy_free(cfg->wiphy);
-	}
 }
 
 static bool brcmf_is_linkup(const struct brcmf_event_msg *e)
@@ -4980,20 +4969,17 @@ cfg80211_p2p_attach_out:
 	wl_deinit_priv(cfg);
 
 cfg80211_attach_out:
-	brcmf_free_vif(cfg, vif);
+	brcmf_free_vif(vif);
 	return NULL;
 }
 
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_vif *vif;
-	struct brcmf_cfg80211_vif *tmp;
-
-	wl_deinit_priv(cfg);
+	WARN_ON(!list_empty(&cfg->vif_list));
+	wiphy_unregister(cfg->wiphy);
 	brcmf_btcoex_detach(cfg);
-	list_for_each_entry_safe(vif, tmp, &cfg->vif_list, list) {
-		brcmf_free_vif(cfg, vif);
-	}
+	wl_deinit_priv(cfg);
+	wiphy_free(cfg->wiphy);
 }
 
 static s32
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index d9bdaf9..d9b2d62 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -412,7 +412,6 @@ struct brcmf_cfg80211_info {
 	struct work_struct escan_timeout_work;
 	u8 *escan_ioctl_buf;
 	struct list_head vif_list;
-	u8 vif_cnt;
 	struct brcmf_cfg80211_vif_event vif_event;
 	struct completion vif_disabled;
 	struct brcmu_d11inf d11inf;
@@ -487,8 +486,7 @@ enum nl80211_iftype brcmf_cfg80211_get_iftype(struct brcmf_if *ifp);
 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 					   enum nl80211_iftype type,
 					   bool pm_block);
-void brcmf_free_vif(struct brcmf_cfg80211_info *cfg,
-	            struct brcmf_cfg80211_vif *vif);
+void brcmf_free_vif(struct brcmf_cfg80211_vif *vif);
 
 s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			  const u8 *vndr_ie_buf, u32 vndr_ie_len);
-- 
1.7.10.4

