Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3297 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670Ab3E0TKV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 15:10:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 3/7] brcmfmac: add additional parameter to
 brcmf_free_vif()
Date: Mon, 27 May 2013 21:09:55 +0200
Message-ID: <1369681799-3163-4-git-send-email-arend@broadcom.com> (sfid-20130527_211031_883758_FB7E93E7)
In-Reply-To: <1369681799-3163-1-git-send-email-arend@broadcom.com>
References: <1369681799-3163-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass the struct brcmf_cfg80211_info instance instead of obtaining
through vif itself using vif->wdev. This is needed as the netdev
associated with this vif is already unregistered.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   25 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   17 +++++--------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    3 ++-
 3 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 17275ce..167b7af 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1955,21 +1955,21 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
 		err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
 		if (err < 0) {
 			brcmf_err("set p2p_disc error\n");
-			brcmf_free_vif(p2p_vif);
+			brcmf_free_vif(cfg, p2p_vif);
 			goto exit;
 		}
 		/* obtain bsscfg index for P2P discovery */
 		err = brcmf_fil_iovar_int_get(pri_ifp, "p2p_dev", &bssidx);
 		if (err < 0) {
 			brcmf_err("retrieving discover bsscfg index failed\n");
-			brcmf_free_vif(p2p_vif);
+			brcmf_free_vif(cfg, p2p_vif);
 			goto exit;
 		}
 		/* Verify that firmware uses same bssidx as driver !! */
 		if (p2p_ifp->bssidx != bssidx) {
 			brcmf_err("Incorrect bssidx=%d, compared to p2p_ifp->bssidx=%d\n",
 				  bssidx, p2p_ifp->bssidx);
-			brcmf_free_vif(p2p_vif);
+			brcmf_free_vif(cfg, p2p_vif);
 			goto exit;
 		}
 
@@ -1997,7 +1997,7 @@ void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
 		brcmf_p2p_cancel_remain_on_channel(vif->ifp);
 		brcmf_p2p_deinit_discovery(p2p);
 		/* remove discovery interface */
-		brcmf_free_vif(vif);
+		brcmf_free_vif(p2p->cfg, vif);
 		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
 	}
 	/* just set it all to zero */
@@ -2222,7 +2222,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	return &p2p_vif->wdev;
 
 fail:
-	brcmf_free_vif(p2p_vif);
+	brcmf_free_vif(p2p->cfg, p2p_vif);
 	return ERR_PTR(err);
 }
 
@@ -2231,13 +2231,12 @@ fail:
  *
  * @vif: virtual interface object to delete.
  */
-static void brcmf_p2p_delete_p2pdev(struct brcmf_cfg80211_vif *vif)
+static void brcmf_p2p_delete_p2pdev(struct brcmf_cfg80211_info *cfg,
+				    struct brcmf_cfg80211_vif *vif)
 {
-	struct brcmf_p2p_info *p2p = &vif->ifp->drvr->config->p2p;
-
 	cfg80211_unregister_wdev(&vif->wdev);
-	p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
-	brcmf_free_vif(vif);
+	cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
+	brcmf_free_vif(cfg, vif);
 }
 
 /**
@@ -2328,7 +2327,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	return &ifp->vif->wdev;
 
 fail:
-	brcmf_free_vif(vif);
+	brcmf_free_vif(cfg, vif);
 	return ERR_PTR(err);
 }
 
@@ -2364,7 +2363,7 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 		break;
 
 	case NL80211_IFTYPE_P2P_DEVICE:
-		brcmf_p2p_delete_p2pdev(vif);
+		brcmf_p2p_delete_p2pdev(cfg, vif);
 		return 0;
 	default:
 		return -ENOTSUPP;
@@ -2392,7 +2391,7 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 			err = 0;
 	}
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
-	brcmf_free_vif(vif);
+	brcmf_free_vif(cfg, vif);
 	p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = NULL;
 
 	return err;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 94285f6..f8c86b5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4292,20 +4292,16 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 	return vif;
 }
 
-void brcmf_free_vif(struct brcmf_cfg80211_vif *vif)
+void brcmf_free_vif(struct brcmf_cfg80211_info *cfg,
+		    struct brcmf_cfg80211_vif *vif)
 {
-	struct brcmf_cfg80211_info *cfg;
-	struct wiphy *wiphy;
-
-	wiphy = vif->wdev.wiphy;
-	cfg = wiphy_priv(wiphy);
 	list_del(&vif->list);
 	cfg->vif_cnt--;
 
 	kfree(vif);
 	if (!cfg->vif_cnt) {
-		wiphy_unregister(wiphy);
-		wiphy_free(wiphy);
+		wiphy_unregister(cfg->wiphy);
+		wiphy_free(cfg->wiphy);
 	}
 }
 
@@ -4888,8 +4884,7 @@ cfg80211_p2p_attach_out:
 	wl_deinit_priv(cfg);
 
 cfg80211_attach_out:
-	brcmf_free_vif(vif);
-	wiphy_free(wiphy);
+	brcmf_free_vif(cfg, vif);
 	return NULL;
 }
 
@@ -4901,7 +4896,7 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 	wl_deinit_priv(cfg);
 	brcmf_btcoex_detach(cfg);
 	list_for_each_entry_safe(vif, tmp, &cfg->vif_list, list) {
-		brcmf_free_vif(vif);
+		brcmf_free_vif(cfg, vif);
 	}
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index a71cff8..d9bdaf9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -487,7 +487,8 @@ enum nl80211_iftype brcmf_cfg80211_get_iftype(struct brcmf_if *ifp);
 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 					   enum nl80211_iftype type,
 					   bool pm_block);
-void brcmf_free_vif(struct brcmf_cfg80211_vif *vif);
+void brcmf_free_vif(struct brcmf_cfg80211_info *cfg,
+	            struct brcmf_cfg80211_vif *vif);
 
 s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			  const u8 *vndr_ie_buf, u32 vndr_ie_len);
-- 
1.7.10.4


