Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:20016 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaAFLlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:41:01 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 14/15] brcmfmac: use custom destructor callback for all netdevice interfaces
Date: Mon, 6 Jan 2014 12:40:49 +0100
Message-ID: <1389008450-28529-15-git-send-email-arend@broadcom.com> (sfid-20140106_124118_696071_12895015)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The destructor for net devices was set to free_netdev() to get rid
of it and the private data. The private data refers to a brcmf_if
instance, but indirectly it also refers to brcmf_cfg80211_vif which
holds the wdev. This is freed as well by using a new custom destructor
called brcmf_cfg80211_free_netdev().

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c       |   19 -------------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c   |   12 ++++++++++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h   |    1 +
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index d3c4fba..af39eda 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -702,7 +702,7 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 
 	brcmf_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", ndev->name);
 
-	ndev->destructor = free_netdev;
+	ndev->destructor = brcmf_cfg80211_free_netdev;
 	return 0;
 
 fail:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index af5c4c7..e23c869 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2241,23 +2241,6 @@ static void brcmf_p2p_delete_p2pdev(struct brcmf_p2p_info *p2p,
 }
 
 /**
- * brcmf_p2p_free_p2p_if() - free up net device related data.
- *
- * @ndev: net device that needs to be freed.
- */
-static void brcmf_p2p_free_p2p_if(struct net_device *ndev)
-{
-	struct brcmf_cfg80211_vif *vif;
-	struct brcmf_if *ifp;
-
-	ifp = netdev_priv(ndev);
-	vif = ifp->vif;
-
-	brcmf_free_vif(vif);
-	free_netdev(ifp->ndev);
-}
-
-/**
  * brcmf_p2p_add_vif() - create a new P2P virtual interface.
  *
  * @wiphy: wiphy device of new interface.
@@ -2334,8 +2317,6 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 		brcmf_err("Registering netdevice failed\n");
 		goto fail;
 	}
-	/* override destructor */
-	ifp->ndev->destructor = brcmf_p2p_free_p2p_if;
 
 	cfg->p2p.bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = vif;
 	/* Disable firmware roaming for P2P interface  */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 3e3de34..aad83ae 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4385,6 +4385,18 @@ void brcmf_free_vif(struct brcmf_cfg80211_vif *vif)
 	kfree(vif);
 }
 
+void brcmf_cfg80211_free_netdev(struct net_device *ndev)
+{
+	struct brcmf_cfg80211_vif *vif;
+	struct brcmf_if *ifp;
+
+	ifp = netdev_priv(ndev);
+	vif = ifp->vif;
+
+	brcmf_free_vif(vif);
+	free_netdev(ndev);
+}
+
 static bool brcmf_is_linkup(const struct brcmf_event_msg *e)
 {
 	u32 event = e->event_code;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index d9b2d62..2dc6a07 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -505,5 +505,6 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 				bool fw_abort);
 void brcmf_set_mpc(struct brcmf_if *ndev, int mpc);
 void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg);
+void brcmf_cfg80211_free_netdev(struct net_device *ndev);
 
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.10.4

