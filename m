Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:32782 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932226AbeE3UPp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 16:15:45 -0400
Received: by mail-lf0-f68.google.com with SMTP id y20-v6so6240914lfy.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2018 13:15:44 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 3/3] brcmfmac: add initial support for monitor mode interface
Date: Wed, 30 May 2018 22:13:01 +0200
Message-Id: <20180530201301.4648-3-zajec5@gmail.com> (sfid-20180530_221556_067363_AC437BE8)
In-Reply-To: <20180530201301.4648-1-zajec5@gmail.com>
References: <20180530201301.4648-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Right now it's limited to firmwares that mark monitor interface packets
with a special flag. It's required to distinguish them from other
interface packets as firmware doesn't use any unique ifidx for monitor
interface.

In the future one may also add support for older firmwares without
support for proper packet flags. That will require limiting interface
combos to allow monitor mode *only* and adjusting condition in the
brcmf_msgbuf_process_rx_complete().

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 107 +++++++++++++++++++--
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  65 ++++++++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |   2 +
 4 files changed, 168 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index f5b405c98047..bbb4f913eece 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <net/cfg80211.h>
 #include <net/netlink.h>
+#include <uapi/linux/if_arp.h>
 
 #include <brcmu_utils.h>
 #include <defs.h>
@@ -608,6 +609,82 @@ static bool brcmf_is_ibssmode(struct brcmf_cfg80211_vif *vif)
 	return vif->wdev.iftype == NL80211_IFTYPE_ADHOC;
 }
 
+/**
+ * brcmf_mon_add_vif() - create monitor mode virtual interface
+ *
+ * @wiphy: wiphy device of new interface.
+ * @name: name of the new interface.
+ */
+static struct wireless_dev *brcmf_mon_add_vif(struct wiphy *wiphy,
+					      const char *name)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_vif *vif;
+	struct net_device *ndev;
+	struct brcmf_if *ifp;
+	int err;
+
+	if (cfg->pub->mon_if) {
+		err = -EEXIST;
+		goto err_out;
+	}
+
+	vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_MONITOR);
+	if (IS_ERR(vif)) {
+		err = PTR_ERR(vif);
+		goto err_out;
+	}
+
+	ndev = alloc_netdev(sizeof(*ifp), name, NET_NAME_UNKNOWN, ether_setup);
+	if (!ndev) {
+		err = -ENOMEM;
+		goto err_free_vif;
+	}
+	ndev->type = ARPHRD_IEEE80211_RADIOTAP;
+	ndev->ieee80211_ptr = &vif->wdev;
+	ndev->needs_free_netdev = true;
+	ndev->priv_destructor = brcmf_cfg80211_free_netdev;
+	SET_NETDEV_DEV(ndev, wiphy_dev(cfg->wiphy));
+
+	ifp = netdev_priv(ndev);
+	ifp->vif = vif;
+	ifp->ndev = ndev;
+	ifp->drvr = cfg->pub;
+
+	vif->ifp = ifp;
+	vif->wdev.netdev = ndev;
+
+	err = brcmf_net_mon_attach(ifp);
+	if (err) {
+		brcmf_err("Failed to attach %s device\n", ndev->name);
+		free_netdev(ndev);
+		goto err_free_vif;
+	}
+
+	cfg->pub->mon_if = ifp;
+
+	return &vif->wdev;
+
+err_free_vif:
+	brcmf_free_vif(vif);
+err_out:
+	return ERR_PTR(err);
+}
+
+static int brcmf_mon_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = wdev->netdev;
+
+	ndev->netdev_ops->ndo_stop(ndev);
+
+	brcmf_net_detach(ndev, true);
+
+	cfg->pub->mon_if = NULL;
+
+	return 0;
+}
+
 static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 						     const char *name,
 						     unsigned char name_assign_type,
@@ -628,9 +705,10 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
-	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_MESH_POINT:
 		return ERR_PTR(-EOPNOTSUPP);
+	case NL80211_IFTYPE_MONITOR:
+		return brcmf_mon_add_vif(wiphy, name);
 	case NL80211_IFTYPE_AP:
 		wdev = brcmf_ap_add_vif(wiphy, name, params);
 		break;
@@ -810,9 +888,10 @@ int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
-	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_MESH_POINT:
 		return -EOPNOTSUPP;
+	case NL80211_IFTYPE_MONITOR:
+		return brcmf_mon_del_vif(wiphy, wdev);
 	case NL80211_IFTYPE_AP:
 		return brcmf_cfg80211_del_ap_iface(wiphy, wdev);
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -6339,9 +6418,10 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
 	struct ieee80211_iface_limit *c0_limits = NULL;
 	struct ieee80211_iface_limit *p2p_limits = NULL;
 	struct ieee80211_iface_limit *mbss_limits = NULL;
-	bool mbss, p2p;
-	int i, c, n_combos;
+	bool mon, mbss, p2p;
+	int i, c, n_combos, n_limits;
 
+	mon = brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MON_802_11_FLAG);
 	mbss = brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS);
 	p2p = brcmf_feat_is_enabled(ifp, BRCMF_FEAT_P2P);
 
@@ -6353,14 +6433,21 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				 BIT(NL80211_IFTYPE_ADHOC) |
 				 BIT(NL80211_IFTYPE_AP);
+	if (mon)
+		wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
 
 	c = 0;
 	i = 0;
-	c0_limits = kcalloc(p2p ? 3 : 2, sizeof(*c0_limits), GFP_KERNEL);
+	n_limits = 1 + mon + p2p ? 2 : 1;
+	c0_limits = kcalloc(n_limits, sizeof(*c0_limits), GFP_KERNEL);
 	if (!c0_limits)
 		goto err;
 	c0_limits[i].max = 1;
 	c0_limits[i++].types = BIT(NL80211_IFTYPE_STATION);
+	if (mon) {
+		c0_limits[i].max = 1;
+		c0_limits[i++].types = BIT(NL80211_IFTYPE_MONITOR);
+	}
 	if (p2p) {
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MCHAN))
 			combo[c].num_different_channels = 2;
@@ -6406,14 +6493,20 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
 	if (mbss) {
 		c++;
 		i = 0;
-		mbss_limits = kcalloc(1, sizeof(*mbss_limits), GFP_KERNEL);
+		n_limits = 1 + mon;
+		mbss_limits = kcalloc(n_limits, sizeof(*mbss_limits),
+				      GFP_KERNEL);
 		if (!mbss_limits)
 			goto err;
 		mbss_limits[i].max = 4;
 		mbss_limits[i++].types = BIT(NL80211_IFTYPE_AP);
+		if (mon) {
+			mbss_limits[i].max = 1;
+			mbss_limits[i++].types = BIT(NL80211_IFTYPE_MONITOR);
+		}
 		combo[c].beacon_int_infra_match = true;
 		combo[c].num_different_channels = 1;
-		combo[c].max_interfaces = 4;
+		combo[c].max_interfaces = 4 + mon;
 		combo[c].n_limits = i;
 		combo[c].limits = mbss_limits;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index c9e1f6fcc57b..f80c8c7a590e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -623,7 +623,7 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 	return -EBADE;
 }
 
-static void brcmf_net_detach(struct net_device *ndev, bool rtnl_locked)
+void brcmf_net_detach(struct net_device *ndev, bool rtnl_locked)
 {
 	if (ndev->reg_state == NETREG_REGISTERED) {
 		if (rtnl_locked)
@@ -636,6 +636,69 @@ static void brcmf_net_detach(struct net_device *ndev, bool rtnl_locked)
 	}
 }
 
+static int brcmf_net_mon_open(struct net_device *ndev)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	u32 monitor;
+	int err;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_MONITOR, &monitor);
+	if (err) {
+		brcmf_err("BRCMF_C_GET_MONITOR error (%d)\n", err);
+		return err;
+	} else if (monitor) {
+		brcmf_err("Monitor mode is already enabled\n");
+		return -EEXIST;
+	}
+
+	monitor = 3;
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_MONITOR, monitor);
+	if (err)
+		brcmf_err("BRCMF_C_SET_MONITOR error (%d)\n", err);
+
+	return err;
+}
+
+static int brcmf_net_mon_stop(struct net_device *ndev)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	u32 monitor;
+	int err;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	monitor = 0;
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_MONITOR, monitor);
+	if (err)
+		brcmf_err("BRCMF_C_SET_MONITOR error (%d)\n", err);
+
+	return err;
+}
+
+static const struct net_device_ops brcmf_netdev_ops_mon = {
+	.ndo_open = brcmf_net_mon_open,
+	.ndo_stop = brcmf_net_mon_stop,
+};
+
+int brcmf_net_mon_attach(struct brcmf_if *ifp)
+{
+	struct net_device *ndev;
+	int err;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	ndev = ifp->ndev;
+	ndev->netdev_ops = &brcmf_netdev_ops_mon;
+
+	err = register_netdevice(ndev);
+	if (err)
+		brcmf_err("Failed to register %s device\n", ndev->name);
+
+	return err;
+}
+
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on)
 {
 	struct net_device *ndev;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index dcf6e27cc16f..2d37a2fc6a6f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -218,6 +218,8 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb);
+void brcmf_net_detach(struct net_device *ndev, bool rtnl_locked);
+int brcmf_net_mon_attach(struct brcmf_if *ifp);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 int __init brcmf_core_init(void);
 void __exit brcmf_core_exit(void);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
index 63b1287e2e6d..0d9492fd758d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
@@ -60,6 +60,8 @@
 #define BRCMF_C_GET_PM				85
 #define BRCMF_C_SET_PM				86
 #define BRCMF_C_GET_REVINFO			98
+#define BRCMF_C_GET_MONITOR			107
+#define BRCMF_C_SET_MONITOR			108
 #define BRCMF_C_GET_CURR_RATESET		114
 #define BRCMF_C_GET_AP				117
 #define BRCMF_C_SET_AP				118
-- 
2.13.6
