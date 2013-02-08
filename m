Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3737 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760211Ab3BHO4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:45 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/27] brcmfmac: Create p2p0 netdev via module variable.
Date: Fri, 8 Feb 2013 15:53:52 +0100
Message-ID: <1360335242-12608-18-git-send-email-arend@broadcom.com> (sfid-20130208_160029_834752_5CCB948B)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Add module variable with which a p2p0 netdev can be created. This
netdev can be used by wpa-supplicant to configure and set up the
p2p client/GO.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  109 ++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  226 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |    6 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   12 +-
 4 files changed, 213 insertions(+), 140 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 451b89c..65176c6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -42,6 +42,12 @@ MODULE_LICENSE("Dual BSD/GPL");
 int brcmf_msg_level;
 module_param(brcmf_msg_level, int, 0);
 
+/* P2P0 enable */
+static int brcmf_p2p_enable;
+#ifdef CONFIG_BRCMDBG
+module_param_named(p2pon, brcmf_p2p_enable, int, 0);
+MODULE_PARM_DESC(p2pon, "enable p2p management functionality");
+#endif
 
 char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 {
@@ -593,16 +599,6 @@ static const struct net_device_ops brcmf_netdev_ops_pri = {
 	.ndo_set_rx_mode = brcmf_netdev_set_multicast_list
 };
 
-static const struct net_device_ops brcmf_netdev_ops_virt = {
-	.ndo_open = brcmf_cfg80211_up,
-	.ndo_stop = brcmf_cfg80211_down,
-	.ndo_get_stats = brcmf_netdev_get_stats,
-	.ndo_do_ioctl = brcmf_netdev_ioctl_entry,
-	.ndo_start_xmit = brcmf_netdev_start_xmit,
-	.ndo_set_mac_address = brcmf_netdev_set_mac_address,
-	.ndo_set_rx_mode = brcmf_netdev_set_multicast_list
-};
-
 int brcmf_net_attach(struct brcmf_if *ifp)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
@@ -613,10 +609,7 @@ int brcmf_net_attach(struct brcmf_if *ifp)
 	ndev = ifp->ndev;
 
 	/* set appropriate operations */
-	if (!ifp->bssidx)
-		ndev->netdev_ops = &brcmf_netdev_ops_pri;
-	else
-		ndev->netdev_ops = &brcmf_netdev_ops_virt;
+	ndev->netdev_ops = &brcmf_netdev_ops_pri;
 
 	ndev->hard_header_len = ETH_HLEN + drvr->hdrlen;
 	ndev->ethtool_ops = &brcmf_ethtool_ops;
@@ -627,6 +620,9 @@ int brcmf_net_attach(struct brcmf_if *ifp)
 	/* set the mac address */
 	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
 
+	INIT_WORK(&ifp->setmacaddr_work, _brcmf_set_mac_address);
+	INIT_WORK(&ifp->multicast_work, _brcmf_set_multicast_list);
+
 	if (register_netdev(ndev) != 0) {
 		brcmf_err("couldn't register the net device\n");
 		goto fail;
@@ -641,6 +637,69 @@ fail:
 	return -EBADE;
 }
 
+static int brcmf_net_p2p_open(struct net_device *ndev)
+{
+	brcmf_dbg(TRACE, "Enter\n");
+
+	return brcmf_cfg80211_up(ndev);
+}
+
+static int brcmf_net_p2p_stop(struct net_device *ndev)
+{
+	brcmf_dbg(TRACE, "Enter\n");
+
+	return brcmf_cfg80211_down(ndev);
+}
+
+static int brcmf_net_p2p_do_ioctl(struct net_device *ndev,
+				  struct ifreq *ifr, int cmd)
+{
+	brcmf_dbg(TRACE, "Enter\n");
+	return 0;
+}
+
+static netdev_tx_t brcmf_net_p2p_start_xmit(struct sk_buff *skb,
+					    struct net_device *ndev)
+{
+	if (skb)
+		dev_kfree_skb_any(skb);
+
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops brcmf_netdev_ops_p2p = {
+	.ndo_open = brcmf_net_p2p_open,
+	.ndo_stop = brcmf_net_p2p_stop,
+	.ndo_do_ioctl = brcmf_net_p2p_do_ioctl,
+	.ndo_start_xmit = brcmf_net_p2p_start_xmit
+};
+
+static int brcmf_net_p2p_attach(struct brcmf_if *ifp)
+{
+	struct net_device *ndev;
+
+	brcmf_dbg(TRACE, "Enter, idx=%d mac=%pM\n", ifp->bssidx,
+		  ifp->mac_addr);
+	ndev = ifp->ndev;
+
+	ndev->netdev_ops = &brcmf_netdev_ops_p2p;
+
+	/* set the mac address */
+	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
+
+	if (register_netdev(ndev) != 0) {
+		brcmf_err("couldn't register the p2p net device\n");
+		goto fail;
+	}
+
+	brcmf_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", ndev->name);
+
+	return 0;
+
+fail:
+	return -EBADE;
+}
+
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 			      char *name, u8 *mac_addr)
 {
@@ -682,8 +741,6 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 	ifp->ifidx = ifidx;
 	ifp->bssidx = bssidx;
 
-	INIT_WORK(&ifp->setmacaddr_work, _brcmf_set_mac_address);
-	INIT_WORK(&ifp->multicast_work, _brcmf_set_multicast_list);
 
 	init_waitqueue_head(&ifp->pend_8021x_wait);
 
@@ -717,8 +774,10 @@ void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 			netif_stop_queue(ifp->ndev);
 		}
 
-		cancel_work_sync(&ifp->setmacaddr_work);
-		cancel_work_sync(&ifp->multicast_work);
+		if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
+			cancel_work_sync(&ifp->setmacaddr_work);
+			cancel_work_sync(&ifp->multicast_work);
+		}
 
 		unregister_netdev(ifp->ndev);
 		drvr->iflist[bssidx] = NULL;
@@ -776,6 +835,7 @@ int brcmf_bus_start(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 	struct brcmf_if *ifp;
+	struct brcmf_if *p2p_ifp;
 
 	brcmf_dbg(TRACE, "\n");
 
@@ -791,6 +851,13 @@ int brcmf_bus_start(struct device *dev)
 	if (IS_ERR(ifp))
 		return PTR_ERR(ifp);
 
+	if (brcmf_p2p_enable)
+		p2p_ifp = brcmf_add_if(drvr, 1, 0, "p2p%d", NULL);
+	else
+		p2p_ifp = NULL;
+	if (IS_ERR(p2p_ifp))
+		p2p_ifp = NULL;
+
 	/* signal bus ready */
 	bus_if->state = BRCMF_BUS_DATA;
 
@@ -817,8 +884,14 @@ fail:
 			brcmf_cfg80211_detach(drvr->config);
 		free_netdev(ifp->ndev);
 		drvr->iflist[0] = NULL;
+		if (p2p_ifp) {
+			free_netdev(p2p_ifp->ndev);
+			drvr->iflist[1] = NULL;
+		}
 		return ret;
 	}
+	if ((brcmf_p2p_enable) && (p2p_ifp))
+		brcmf_net_p2p_attach(p2p_ifp);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 1c854f6..c04d596 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -407,22 +407,21 @@ static void brcmf_p2p_print_actframe(bool tx, void *frame, u32 frame_len)
 /**
  * brcmf_p2p_set_firmware() - prepare firmware for peer-to-peer operation.
  *
- * @p2p: P2P specific data.
+ * @ifp: ifp to use for iovars (primary).
+ * @p2p_mac: mac address to configure for p2p_da_override
  */
-static int brcmf_p2p_set_firmware(struct brcmf_p2p_info *p2p)
+static int brcmf_p2p_set_firmware(struct brcmf_if *ifp, u8 *p2p_mac)
 {
-	struct net_device *ndev = cfg_to_ndev(p2p->cfg);
-	u8 null_eth_addr[] = { 0, 0, 0, 0, 0, 0 };
 	s32 ret = 0;
 
-	brcmf_fil_iovar_int_set(netdev_priv(ndev), "apsta", 1);
+	brcmf_fil_iovar_int_set(ifp, "apsta", 1);
 
 	/* In case of COB type, firmware has default mac address
 	 * After Initializing firmware, we have to set current mac address to
 	 * firmware for P2P device address
 	 */
-	ret = brcmf_fil_iovar_data_set(netdev_priv(ndev), "p2p_da_override",
-				       null_eth_addr, sizeof(null_eth_addr));
+	ret = brcmf_fil_iovar_data_set(ifp, "p2p_da_override", p2p_mac,
+				       ETH_ALEN);
 	if (ret)
 		brcmf_err("failed to update device address ret %d\n", ret);
 
@@ -440,11 +439,15 @@ static int brcmf_p2p_set_firmware(struct brcmf_p2p_info *p2p)
  */
 static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p)
 {
+	struct brcmf_if *pri_ifp = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
+	struct brcmf_if *p2p_ifp = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->ifp;
+
 	/* Generate the P2P Device Address.  This consists of the device's
 	 * primary MAC address with the locally administered bit set.
 	 */
-	memcpy(p2p->dev_addr, p2p->cfg->pub->mac, ETH_ALEN);
+	memcpy(p2p->dev_addr, pri_ifp->mac_addr, ETH_ALEN);
 	p2p->dev_addr[0] |= 0x02;
+	memcpy(p2p_ifp->mac_addr, p2p->dev_addr, ETH_ALEN);
 
 	/* Generate the P2P Interface Address.  If the discovery and connection
 	 * BSSCFGs need to simultaneously co-exist, then this address must be
@@ -503,111 +506,25 @@ static s32 brcmf_p2p_set_discover_state(struct brcmf_if *ifp, u8 state,
 }
 
 /**
- * brcmf_p2p_init_discovery() - enable discovery in the firmware.
- *
- * @p2p: P2P specific data.
- *
- * Configures the firmware to allow P2P peer discovery. Creates the
- * virtual interface and consequently the P2P device for it.
- */
-static s32 brcmf_p2p_init_discovery(struct brcmf_p2p_info *p2p)
-{
-	struct net_device *ndev = cfg_to_ndev(p2p->cfg);
-	struct brcmf_cfg80211_vif *vif;
-	struct brcmf_if *ifp;
-	struct p2p_bss *bss_dev;
-	s32 index;
-	s32 ret;
-
-	brcmf_dbg(TRACE, "enter\n");
-
-	bss_dev = &p2p->bss_idx[P2PAPI_BSSCFG_DEVICE];
-	if (bss_dev->vif != NULL) {
-		brcmf_dbg(INFO, "do nothing, already initialized\n");
-		return 0;
-	}
-
-	/* Enable P2P Discovery in the firmware */
-	ret = brcmf_fil_iovar_int_set(netdev_priv(ndev), "p2p_disc", 1);
-	if (ret < 0) {
-		brcmf_err("set discover error\n");
-		return ret;
-	}
-
-	/* obtain bsscfg index for P2P discovery */
-	ret = brcmf_fil_iovar_int_get(netdev_priv(ndev), "p2p_dev", &index);
-	if (ret < 0) {
-		brcmf_err("retrieving discover bsscfg index failed\n");
-		return ret;
-	}
-
-	/*
-	 * need brcmf_if for setting the discovery state.
-	 */
-	ifp = kzalloc(sizeof(*vif->ifp), GFP_KERNEL);
-	if (!ifp) {
-		brcmf_err("could not create discovery if\n");
-		return -ENOMEM;
-	}
-
-	/* set required fields */
-	ifp->drvr = p2p->cfg->pub;
-	ifp->ifidx = 0;
-	ifp->bssidx = index;
-
-	/* Set the initial discovery state to SCAN */
-	ret = brcmf_p2p_set_discover_state(ifp, WL_P2P_DISC_ST_SCAN, 0, 0);
-
-	if (ret != 0) {
-		brcmf_err("unable to set WL_P2P_DISC_ST_SCAN\n");
-		(void)brcmf_fil_iovar_int_set(netdev_priv(ndev), "p2p_disc", 0);
-		kfree(ifp);
-		return ret;
-	}
-
-	/* create a vif for it */
-	vif = brcmf_alloc_vif(p2p->cfg, NL80211_IFTYPE_P2P_DEVICE, false);
-	if (IS_ERR(vif)) {
-		brcmf_err("could not create discovery vif\n");
-		kfree(ifp);
-		return PTR_ERR(vif);
-	}
-
-	vif->ifp = ifp;
-	ifp->vif = vif;
-	bss_dev->vif = vif;
-
-	return 0;
-}
-
-/**
  * brcmf_p2p_deinit_discovery() - disable P2P device discovery.
  *
  * @p2p: P2P specific data.
  *
- * Resets the discovery state and disables it in firmware. The virtual
- * interface and P2P device are freed.
+ * Resets the discovery state and disables it in firmware.
  */
 static s32 brcmf_p2p_deinit_discovery(struct brcmf_p2p_info *p2p)
 {
-	struct net_device *ndev = cfg_to_ndev(p2p->cfg);
-	struct brcmf_if *ifp;
-	struct p2p_bss *bss_dev;
-	brcmf_dbg(TRACE, "enter\n");
+	struct brcmf_cfg80211_vif *vif;
 
-	bss_dev = &p2p->bss_idx[P2PAPI_BSSCFG_DEVICE];
-	ifp = bss_dev->vif->ifp;
+	brcmf_dbg(TRACE, "enter\n");
 
 	/* Set the discovery state to SCAN */
-	(void)brcmf_p2p_set_discover_state(ifp, WL_P2P_DISC_ST_SCAN, 0, 0);
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	(void)brcmf_p2p_set_discover_state(vif->ifp, WL_P2P_DISC_ST_SCAN, 0, 0);
 
 	/* Disable P2P discovery in the firmware */
-	(void)brcmf_fil_iovar_int_set(netdev_priv(ndev), "p2p_disc", 0);
-
-	/* remove discovery interface */
-	brcmf_free_vif(bss_dev->vif);
-	bss_dev->vif = NULL;
-	kfree(ifp);
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
+	(void)brcmf_fil_iovar_int_set(vif->ifp, "p2p_disc", 0);
 
 	return 0;
 }
@@ -626,18 +543,30 @@ static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p)
 
 	brcmf_dbg(TRACE, "enter\n");
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
-	if (vif) {
-		brcmf_dbg(INFO, "DISCOVERY init already done\n");
+	if (!vif) {
+		brcmf_err("P2P config device not available\n");
+		ret = -EPERM;
 		goto exit;
 	}
 
-	ret = brcmf_p2p_init_discovery(p2p);
-	if (ret < 0) {
-		brcmf_err("init discovery error %d\n", ret);
+	if (test_bit(BRCMF_P2P_STATUS_ENABLED, &p2p->status)) {
+		brcmf_dbg(INFO, "P2P config device already configured\n");
 		goto exit;
 	}
 
+	/* Re-initialize P2P Discovery in the firmware */
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
+	ret = brcmf_fil_iovar_int_set(vif->ifp, "p2p_disc", 1);
+	if (ret < 0) {
+		brcmf_err("set p2p_disc error\n");
+		goto exit;
+	}
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	ret = brcmf_p2p_set_discover_state(vif->ifp, WL_P2P_DISC_ST_SCAN, 0, 0);
+	if (ret < 0) {
+		brcmf_err("unable to set WL_P2P_DISC_ST_SCAN\n");
+		goto exit;
+	}
 
 	/*
 	 * Set wsec to any non-zero value in the discovery bsscfg
@@ -646,9 +575,12 @@ static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p)
 	 * initiate WPS with us if this bit is not set.
 	 */
 	ret = brcmf_fil_bsscfg_int_set(vif->ifp, "wsec", AES_ENABLED);
-	if (ret < 0)
+	if (ret < 0) {
 		brcmf_err("wsec error %d\n", ret);
+		goto exit;
+	}
 
+	set_bit(BRCMF_P2P_STATUS_ENABLED, &p2p->status);
 exit:
 	return ret;
 }
@@ -1356,20 +1288,75 @@ exit:
  *
  * @cfg: driver private data for cfg80211 interface.
  */
-void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg,
-		      struct brcmf_cfg80211_vif *vif)
+s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
 {
+	struct brcmf_if *pri_ifp;
+	struct brcmf_if *p2p_ifp;
+	struct brcmf_cfg80211_vif *p2p_vif;
 	struct brcmf_p2p_info *p2p;
+	struct brcmf_pub *drvr;
+	s32 bssidx;
+	s32 err = 0;
 
 	p2p = &cfg->p2p;
-
 	p2p->cfg = cfg;
-	p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif = vif;
-	brcmf_p2p_generate_bss_mac(p2p);
-	brcmf_p2p_set_firmware(p2p);
-	init_completion(&p2p->send_af_done);
+
+	drvr = cfg->pub;
+
+	pri_ifp = drvr->iflist[0];
+	p2p_ifp = drvr->iflist[1];
+
+	p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif = pri_ifp->vif;
+
+	if (p2p_ifp) {
+		p2p_vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_STATION,
+					  false);
+		if (IS_ERR(p2p_vif)) {
+			brcmf_err("could not create discovery vif\n");
+			err = -ENOMEM;
+			goto exit;
+		}
+
+		p2p_vif->ifp = p2p_ifp;
+		p2p_ifp->vif = p2p_vif;
+		p2p_vif->wdev.netdev = p2p_ifp->ndev;
+		p2p_ifp->ndev->ieee80211_ptr = &p2p_vif->wdev;
+		SET_NETDEV_DEV(p2p_ifp->ndev, wiphy_dev(cfg->wiphy));
+
+		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = p2p_vif;
+
+		brcmf_p2p_generate_bss_mac(p2p);
+		brcmf_p2p_set_firmware(pri_ifp, p2p->dev_addr);
+
+		/* Initialize P2P Discovery in the firmware */
+		err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
+		if (err < 0) {
+			brcmf_err("set p2p_disc error\n");
+			brcmf_free_vif(p2p_vif);
+			goto exit;
+		}
+		/* obtain bsscfg index for P2P discovery */
+		err = brcmf_fil_iovar_int_get(pri_ifp, "p2p_dev", &bssidx);
+		if (err < 0) {
+			brcmf_err("retrieving discover bsscfg index failed\n");
+			brcmf_free_vif(p2p_vif);
+			goto exit;
+		}
+		/* Verify that firmware uses same bssidx as driver !! */
+		if (p2p_ifp->bssidx != bssidx) {
+			brcmf_err("Incorrect bssidx=%d, compared to p2p_ifp->bssidx=%d\n",
+				  bssidx, p2p_ifp->bssidx);
+			brcmf_free_vif(p2p_vif);
+			goto exit;
+		}
+
+		init_completion(&p2p->send_af_done);
+	}
+exit:
+	return err;
 }
 
+
 /**
  * brcmf_p2p_detach() - detach P2P.
  *
@@ -1377,10 +1364,15 @@ void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg,
  */
 void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
 {
-	if (p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif != NULL) {
-		brcmf_p2p_cancel_remain_on_channel(
-			p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->ifp);
+	struct brcmf_cfg80211_vif *vif;
+
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	if (vif != NULL) {
+		brcmf_p2p_cancel_remain_on_channel(vif->ifp);
 		brcmf_p2p_deinit_discovery(p2p);
+		/* remove discovery interface */
+		brcmf_free_vif(vif);
+		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
 	}
 	/* just set it all to zero */
 	memset(p2p, 0, sizeof(*p2p));
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index 0594018..8fed9a3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -66,7 +66,8 @@ struct p2p_bss {
  * @BRCMF_P2P_STATUS_DISCOVER_LISTEN: P2P listen, remaining on channel.
  */
 enum brcmf_p2p_status {
-	BRCMF_P2P_STATUS_IF_ADD = 0,
+	BRCMF_P2P_STATUS_ENABLED,
+	BRCMF_P2P_STATUS_IF_ADD,
 	BRCMF_P2P_STATUS_IF_DEL,
 	BRCMF_P2P_STATUS_IF_DELETING,
 	BRCMF_P2P_STATUS_IF_CHANGING,
@@ -108,8 +109,7 @@ struct brcmf_p2p_info {
 	struct completion send_af_done;
 };
 
-void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg,
-		      struct brcmf_cfg80211_vif *vif);
+s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg);
 void brcmf_p2p_detach(struct brcmf_p2p_info *p2p);
 struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 				       enum nl80211_iftype type, u32 *flags,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 7ae84a0..3011575 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4857,11 +4857,19 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		brcmf_err("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
-	brcmf_p2p_attach(cfg, vif);
-
 	ifp->vif = vif;
+
+	err = brcmf_p2p_attach(cfg);
+	if (err) {
+		brcmf_err("P2P initilisation failed (%d)\n", err);
+		goto cfg80211_p2p_attach_out;
+	}
+
 	return cfg;
 
+cfg80211_p2p_attach_out:
+	wl_deinit_priv(cfg);
+
 cfg80211_attach_out:
 	brcmf_free_vif(vif);
 	wiphy_free(wiphy);
-- 
1.7.10.4


