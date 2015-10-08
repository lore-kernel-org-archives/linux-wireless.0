Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:46366 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbbJHSdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:33:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/11] brcmfmac: Rework p2p attach, use single method for p2p dev creation.
Date: Thu, 8 Oct 2015 20:33:15 +0200
Message-ID: <1444329201-3696-6-git-send-email-arend@broadcom.com> (sfid-20151008_203335_792977_B6675F03)
In-Reply-To: <1444329201-3696-1-git-send-email-arend@broadcom.com>
References: <1444329201-3696-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When module param p2pon is used a p2p device is created at init.
This patch reworks how this is done by using the same method as
for a dynamically (by user space) created p2p device.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 18 ++++++
 drivers/net/wireless/brcm80211/brcmfmac/core.c     | 33 ++++------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |  3 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      | 71 +++-------------------
 4 files changed, 40 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 891f4ed..2ee57c0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -6238,6 +6238,17 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		else
 			*cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 	}
+	/* p2p might require that "if-events" get processed by fweh. So
+	 * activate the already registered event handlers now and activate
+	 * the rest when initialization has completed. drvr->config needs to
+	 * be assigned before activating events.
+	 */
+	drvr->config = cfg;
+	err = brcmf_fweh_activate_events(ifp);
+	if (err) {
+		brcmf_err("FWEH activation failed (%d)\n", err);
+		goto wiphy_unreg_out;
+	}
 
 	err = brcmf_p2p_attach(cfg, p2pdev_forced);
 	if (err) {
@@ -6260,6 +6271,13 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 				    brcmf_notify_tdls_peer_event);
 	}
 
+	/* (re-) activate FWEH event handling */
+	err = brcmf_fweh_activate_events(ifp);
+	if (err) {
+		brcmf_err("FWEH activation failed (%d)\n", err);
+		goto wiphy_unreg_out;
+	}
+
 	return cfg;
 
 wiphy_unreg_out:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index a1d39b196..d3212bf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -828,8 +828,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 	} else {
 		brcmf_dbg(INFO, "allocate netdev interface\n");
 		/* Allocate netdev, including space for private structure */
-		ndev = alloc_netdev(sizeof(*ifp), name, NET_NAME_UNKNOWN,
-				    ether_setup);
+		ndev = alloc_netdev(sizeof(*ifp), is_p2pdev ? "p2p%d" : name,
+				    NET_NAME_UNKNOWN, ether_setup);
 		if (!ndev)
 			return ERR_PTR(-ENOMEM);
 
@@ -1021,12 +1021,7 @@ int brcmf_bus_start(struct device *dev)
 	if (IS_ERR(ifp))
 		return PTR_ERR(ifp);
 
-	if (brcmf_p2p_enable)
-		p2p_ifp = brcmf_add_if(drvr, 1, 0, false, "p2p%d", NULL);
-	else
-		p2p_ifp = NULL;
-	if (IS_ERR(p2p_ifp))
-		p2p_ifp = NULL;
+	p2p_ifp = NULL;
 
 	/* signal bus ready */
 	brcmf_bus_change_state(bus_if, BRCMF_BUS_UP);
@@ -1060,11 +1055,13 @@ int brcmf_bus_start(struct device *dev)
 		goto fail;
 	}
 
-	ret = brcmf_fweh_activate_events(ifp);
-	if (ret < 0)
-		goto fail;
-
 	ret = brcmf_net_attach(ifp, false);
+
+	if ((!ret) && (brcmf_p2p_enable)) {
+		p2p_ifp = drvr->iflist[1];
+		if (p2p_ifp)
+			ret = brcmf_net_p2p_attach(p2p_ifp);
+	}
 fail:
 	if (ret < 0) {
 		brcmf_err("failed: %d\n", ret);
@@ -1076,20 +1073,12 @@ fail:
 			brcmf_fws_del_interface(ifp);
 			brcmf_fws_deinit(drvr);
 		}
-		if (drvr->iflist[0]) {
+		if (ifp)
 			brcmf_net_detach(ifp->ndev);
-			drvr->iflist[0] = NULL;
-		}
-		if (p2p_ifp) {
+		if (p2p_ifp)
 			brcmf_net_detach(p2p_ifp->ndev);
-			drvr->iflist[1] = NULL;
-		}
 		return ret;
 	}
-	if ((brcmf_p2p_enable) && (p2p_ifp))
-		if (brcmf_net_p2p_attach(p2p_ifp) < 0)
-			brcmf_p2p_enable = 0;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 383d6fa..3878b6f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -213,7 +213,8 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 				   is_p2pdev, emsg->ifname, emsg->addr);
 		if (IS_ERR(ifp))
 			return;
-		brcmf_fws_add_interface(ifp);
+		if (!is_p2pdev)
+			brcmf_fws_add_interface(ifp);
 		if (!drvr->fweh.evt_handler[BRCMF_E_IF])
 			if (brcmf_net_attach(ifp, false) < 0)
 				return;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 37a8c352..d224b3d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2353,83 +2353,30 @@ void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev)
  * brcmf_p2p_attach() - attach for P2P.
  *
  * @cfg: driver private data for cfg80211 interface.
+ * @p2pdev_forced: create p2p device interface at attach.
  */
 s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced)
 {
-	struct brcmf_if *pri_ifp;
-	struct brcmf_if *p2p_ifp;
-	struct brcmf_cfg80211_vif *p2p_vif;
 	struct brcmf_p2p_info *p2p;
-	struct brcmf_pub *drvr;
-	s32 bssidx;
+	struct brcmf_if *pri_ifp;
 	s32 err = 0;
+	void *err_ptr;
 
 	p2p = &cfg->p2p;
 	p2p->cfg = cfg;
 
-	drvr = cfg->pub;
-
-	pri_ifp = brcmf_get_ifp(drvr, 0);
+	pri_ifp = brcmf_get_ifp(cfg->pub, 0);
 	p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif = pri_ifp->vif;
 
 	if (p2pdev_forced) {
-		p2p_ifp = drvr->iflist[1];
+		err_ptr = brcmf_p2p_create_p2pdev(p2p, NULL, NULL);
+		if (IS_ERR(err_ptr)) {
+			brcmf_err("P2P device creation failed.\n");
+			err = PTR_ERR(err_ptr);
+		}
 	} else {
-		p2p_ifp = NULL;
 		p2p->p2pdev_dynamically = true;
 	}
-	if (p2p_ifp) {
-		p2p_vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_P2P_DEVICE,
-					  false);
-		if (IS_ERR(p2p_vif)) {
-			brcmf_err("could not create discovery vif\n");
-			err = -ENOMEM;
-			goto exit;
-		}
-
-		p2p_vif->ifp = p2p_ifp;
-		p2p_ifp->vif = p2p_vif;
-		p2p_vif->wdev.netdev = p2p_ifp->ndev;
-		p2p_ifp->ndev->ieee80211_ptr = &p2p_vif->wdev;
-		SET_NETDEV_DEV(p2p_ifp->ndev, wiphy_dev(cfg->wiphy));
-
-		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = p2p_vif;
-
-		brcmf_p2p_generate_bss_mac(p2p, NULL);
-		memcpy(p2p_ifp->mac_addr, p2p->dev_addr, ETH_ALEN);
-		brcmf_p2p_set_firmware(pri_ifp, p2p->dev_addr);
-
-		brcmf_fweh_p2pdev_setup(pri_ifp, true);
-
-		/* Initialize P2P Discovery in the firmware */
-		err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
-		if (err < 0) {
-			brcmf_err("set p2p_disc error\n");
-			brcmf_free_vif(p2p_vif);
-			goto exit;
-		}
-		/* obtain bsscfg index for P2P discovery */
-		err = brcmf_fil_iovar_int_get(pri_ifp, "p2p_dev", &bssidx);
-		if (err < 0) {
-			brcmf_err("retrieving discover bsscfg index failed\n");
-			brcmf_free_vif(p2p_vif);
-			goto exit;
-		}
-		/* Verify that firmware uses same bssidx as driver !! */
-		if (p2p_ifp->bssidx != bssidx) {
-			brcmf_err("Incorrect bssidx=%d, compared to p2p_ifp->bssidx=%d\n",
-				  bssidx, p2p_ifp->bssidx);
-			brcmf_free_vif(p2p_vif);
-			goto exit;
-		}
-
-		init_completion(&p2p->send_af_done);
-		INIT_WORK(&p2p->afx_hdl.afx_work, brcmf_p2p_afx_handler);
-		init_completion(&p2p->afx_hdl.act_frm_scan);
-		init_completion(&p2p->wait_next_af);
-exit:
-		brcmf_fweh_p2pdev_setup(pri_ifp, false);
-	}
 	return err;
 }
 
-- 
1.9.1

