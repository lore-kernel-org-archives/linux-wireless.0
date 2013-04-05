Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1829 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162013Ab3DEI6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:09 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/16] brcmfmac: wait for firmware event when creating
 P2P_DEVICE interface
Date: Fri, 5 Apr 2013 10:57:51 +0200
Message-ID: <1365152274-4252-14-git-send-email-arend@broadcom.com> (sfid-20130405_111306_106064_B20596AD)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware sends a IF event to notify the host driver that the
P2P_DEVICE interface has been created. Wait for the event before
returning the related wireless_dev.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   28 +++++++----
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   52 +++++++++++---------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    8 +--
 4 files changed, 55 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index c82f3e0..e68500b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -755,15 +755,23 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 		}
 	}
 
-	/* Allocate netdev, including space for private structure */
-	ndev = alloc_netdev(sizeof(struct brcmf_if), name, ether_setup);
-	if (!ndev) {
-		brcmf_err("OOM - alloc_netdev\n");
-		return ERR_PTR(-ENOMEM);
+	if (!brcmf_p2p_enable && bssidx == 1) {
+		/* this is P2P_DEVICE interface */
+		brcmf_dbg(INFO, "allocate non-netdev interface\n");
+		ifp = kzalloc(sizeof(*ifp), GFP_KERNEL);
+	} else {
+		brcmf_dbg(INFO, "allocate netdev interface\n");
+		/* Allocate netdev, including space for private structure */
+		ndev = alloc_netdev(sizeof(*ifp), name, ether_setup);
+		if (!ndev) {
+			brcmf_err("OOM - alloc_netdev\n");
+			return ERR_PTR(-ENOMEM);
+		}
+
+		ifp = netdev_priv(ndev);
+		ifp->ndev = ndev;
 	}
 
-	ifp = netdev_priv(ndev);
-	ifp->ndev = ndev;
 	ifp->drvr = drvr;
 	drvr->iflist[bssidx] = ifp;
 	ifp->ifidx = ifidx;
@@ -775,7 +783,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 		memcpy(ifp->mac_addr, mac_addr, ETH_ALEN);
 
 	brcmf_dbg(TRACE, " ==== pid:%x, if:%s (%pM) created ===\n",
-		  current->pid, ifp->ndev->name, ifp->mac_addr);
+		  current->pid, name, ifp->mac_addr);
 
 	return ifp;
 }
@@ -807,11 +815,13 @@ void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 		}
 
 		unregister_netdev(ifp->ndev);
-		drvr->iflist[bssidx] = NULL;
 		if (bssidx == 0)
 			brcmf_cfg80211_detach(drvr->config);
 		free_netdev(ifp->ndev);
+	} else {
+		kfree(ifp);
 	}
+	drvr->iflist[bssidx] = NULL;
 }
 
 int brcmf_attach(uint bus_hdrlen, struct device *dev)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 619fff3..b3c608e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1786,7 +1786,7 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp)
 
 	brcmf_dbg(TRACE, "enter: idx=%d, mac=%pM\n",
 		  ifp->bssidx, ifp->mac_addr);
-	if (!ifp->drvr->fw_signals)
+	if (!ifp->ndev || !ifp->drvr->fw_signals)
 		return;
 
 	entry = &fws->desc.iface[ifp->ifidx];
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 5d5d1e4..c3d9836 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -485,7 +485,6 @@ static int brcmf_p2p_set_firmware(struct brcmf_if *ifp, u8 *p2p_mac)
 static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p, u8 *dev_addr)
 {
 	struct brcmf_if *pri_ifp = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
-	struct brcmf_if *p2p_ifp = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->ifp;
 	bool local_admin = false;
 
 	if (!dev_addr || is_zero_ether_addr(dev_addr)) {
@@ -499,7 +498,6 @@ static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p, u8 *dev_addr)
 	memcpy(p2p->dev_addr, dev_addr, ETH_ALEN);
 	if (local_admin)
 		p2p->dev_addr[0] |= 0x02;
-	memcpy(p2p_ifp->mac_addr, p2p->dev_addr, ETH_ALEN);
 
 	/* Generate the P2P Interface Address.  If the discovery and connection
 	 * BSSCFGs need to simultaneously co-exist, then this address must be
@@ -1948,6 +1946,7 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
 		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = p2p_vif;
 
 		brcmf_p2p_generate_bss_mac(p2p, NULL);
+		memcpy(p2p_ifp->mac_addr, p2p->dev_addr, ETH_ALEN);
 		brcmf_p2p_set_firmware(pri_ifp, p2p->dev_addr);
 
 		/* Initialize P2P Discovery in the firmware */
@@ -2163,38 +2162,44 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 		return (struct wireless_dev *)p2p_vif;
 	}
 
-	/* create ifp here */
-	p2p_ifp = kzalloc(sizeof(*p2p_ifp), GFP_KERNEL);
-	if (!p2p_ifp)
-		return ERR_PTR(-ENOMEM);
-
-	p2p_vif->ifp = p2p_ifp;
-	p2p_ifp->vif = p2p_vif;
-
-	p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = p2p_vif;
-	brcmf_p2p_generate_bss_mac(p2p, addr);
-	memcpy(&p2p_vif->wdev.address, p2p->dev_addr, sizeof(p2p->dev_addr));
-
 	pri_ifp = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
+	brcmf_p2p_generate_bss_mac(p2p, addr);
 	brcmf_p2p_set_firmware(pri_ifp, p2p->dev_addr);
 
+	brcmf_cfg80211_arm_vif_event(p2p->cfg, p2p_vif);
+
 	/* Initialize P2P Discovery in the firmware */
 	err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
 	if (err < 0) {
 		brcmf_err("set p2p_disc error\n");
-		brcmf_free_vif(p2p_vif);
-		return ERR_PTR(err);
+		brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
+		goto fail;
 	}
-	/* obtain bsscfg index for P2P discovery */
+
+	/* wait for firmware event */
+	err = brcmf_cfg80211_wait_vif_event_timeout(p2p->cfg, BRCMF_E_IF_ADD,
+						    msecs_to_jiffies(1500));
+	brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
+	if (!err) {
+		brcmf_err("timeout occurred\n");
+		err = -EIO;
+		goto fail;
+	}
+
+	/* discovery interface created */
+	p2p_ifp = p2p_vif->ifp;
+	p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = p2p_vif;
+	memcpy(p2p_ifp->mac_addr, p2p->dev_addr, ETH_ALEN);
+	memcpy(&p2p_vif->wdev.address, p2p->dev_addr, sizeof(p2p->dev_addr));
+
+	/* verify bsscfg index for P2P discovery */
 	err = brcmf_fil_iovar_int_get(pri_ifp, "p2p_dev", &bssidx);
 	if (err < 0) {
 		brcmf_err("retrieving discover bsscfg index failed\n");
-		brcmf_free_vif(p2p_vif);
-		return ERR_PTR(err);
+		goto fail;
 	}
 
-	p2p_ifp->drvr = p2p->cfg->pub;
-	p2p_ifp->bssidx = bssidx;
+	WARN_ON(p2p_ifp->bssidx != bssidx);
 
 	init_completion(&p2p->send_af_done);
 	INIT_WORK(&p2p->afx_hdl.afx_work, brcmf_p2p_afx_handler);
@@ -2202,6 +2207,10 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	init_completion(&p2p->wait_next_af);
 
 	return &p2p_vif->wdev;
+
+fail:
+	brcmf_free_vif(p2p_vif);
+	return ERR_PTR(err);
 }
 
 /**
@@ -2215,7 +2224,6 @@ static void brcmf_p2p_delete_p2pdev(struct brcmf_cfg80211_vif *vif)
 
 	cfg80211_unregister_wdev(&vif->wdev);
 	p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
-	kfree(vif->ifp);
 	brcmf_free_vif(vif);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index cba757b..68859e5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4568,9 +4568,11 @@ static s32 brcmf_notify_vif_event(struct brcmf_if *ifp,
 
 		ifp->vif = vif;
 		vif->ifp = ifp;
-		vif->wdev.netdev = ifp->ndev;
-		ifp->ndev->ieee80211_ptr = &vif->wdev;
-		SET_NETDEV_DEV(ifp->ndev, wiphy_dev(cfg->wiphy));
+		if (ifp->ndev) {
+			vif->wdev.netdev = ifp->ndev;
+			ifp->ndev->ieee80211_ptr = &vif->wdev;
+			SET_NETDEV_DEV(ifp->ndev, wiphy_dev(cfg->wiphy));
+		}
 		mutex_unlock(&event->vif_event_lock);
 		wake_up(&event->vif_wq);
 		return 0;
-- 
1.7.10.4


