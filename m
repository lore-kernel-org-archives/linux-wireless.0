Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35242 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752807AbdDLLG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 07:06:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: aviya.erenfeld@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/6] cfg80211: move add/change interface monitor flags into params
Date: Wed, 12 Apr 2017 13:06:19 +0200
Message-Id: <20170412110621.8981-4-johannes@sipsolutions.net> (sfid-20170412_130641_027250_9922FB97)
In-Reply-To: <20170412110621.8981-1-johannes@sipsolutions.net>
References: <20170412110621.8981-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead passing both flags, which can be NULL, and vif_params,
which are never NULL, move the flags into the vif_params and
use BIT(0), which is invalid from userspace, to indicate that
the flags were changed.

While updating all drivers, fix a small bug in wil6210 where
it was setting the flags to 0 instead of leaving them unchanged.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  3 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        | 11 +++----
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 12 ++++----
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |  2 +-
 drivers/net/wireless/intersil/orinoco/cfg.c        |  2 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |  2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    | 27 ++++++++---------
 drivers/net/wireless/marvell/mwifiex/main.c        |  7 ++---
 drivers/net/wireless/marvell/mwifiex/main.h        |  1 -
 drivers/net/wireless/rndis_wlan.c                  |  4 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c  |  3 +-
 drivers/staging/wlan-ng/cfg80211.c                 |  2 +-
 include/net/cfg80211.h                             |  8 +++--
 net/mac80211/cfg.c                                 | 15 +++++-----
 net/wireless/core.h                                |  2 +-
 net/wireless/nl80211.c                             | 34 ++++++++++++----------
 net/wireless/rdev-ops.h                            |  9 +++---
 net/wireless/util.c                                |  4 +--
 net/wireless/wext-compat.c                         |  2 +-
 20 files changed, 73 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index aae65ce9a2b1..0c118b7c362c 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1503,7 +1503,6 @@ static struct wireless_dev *ath6kl_cfg80211_add_iface(struct wiphy *wiphy,
 						      const char *name,
 						      unsigned char name_assign_type,
 						      enum nl80211_iftype type,
-						      u32 *flags,
 						      struct vif_params *params)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
@@ -1550,7 +1549,7 @@ static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
 
 static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 					struct net_device *ndev,
-					enum nl80211_iftype type, u32 *flags,
+					enum nl80211_iftype type,
 					struct vif_params *params)
 {
 	struct ath6kl_vif *vif = netdev_priv(ndev);
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 1981ec2e0186..b71495904cdf 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -256,7 +256,7 @@ static struct wireless_dev *
 wil_cfg80211_add_iface(struct wiphy *wiphy, const char *name,
 		       unsigned char name_assign_type,
 		       enum nl80211_iftype type,
-		       u32 *flags, struct vif_params *params)
+		       struct vif_params *params)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	struct net_device *ndev = wil_to_ndev(wil);
@@ -307,7 +307,7 @@ static int wil_cfg80211_del_iface(struct wiphy *wiphy,
 
 static int wil_cfg80211_change_iface(struct wiphy *wiphy,
 				     struct net_device *ndev,
-				     enum nl80211_iftype type, u32 *flags,
+				     enum nl80211_iftype type,
 				     struct vif_params *params)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
@@ -334,11 +334,8 @@ static int wil_cfg80211_change_iface(struct wiphy *wiphy,
 	case NL80211_IFTYPE_P2P_GO:
 		break;
 	case NL80211_IFTYPE_MONITOR:
-		if (flags)
-			wil->monitor_flags = *flags;
-		else
-			wil->monitor_flags = 0;
-
+		if (params->flags)
+			wil->monitor_flags = params->flags;
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 89ac12437c92..7efdcd64e83c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -575,12 +575,11 @@ static int brcmf_cfg80211_request_ap_if(struct brcmf_if *ifp)
  *
  * @wiphy: wiphy device of new interface.
  * @name: name of the new interface.
- * @flags: not used.
  * @params: contains mac address for AP device.
  */
 static
 struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
-				      u32 *flags, struct vif_params *params)
+				      struct vif_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
@@ -653,7 +652,6 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 						     const char *name,
 						     unsigned char name_assign_type,
 						     enum nl80211_iftype type,
-						     u32 *flags,
 						     struct vif_params *params)
 {
 	struct wireless_dev *wdev;
@@ -674,12 +672,12 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 	case NL80211_IFTYPE_MESH_POINT:
 		return ERR_PTR(-EOPNOTSUPP);
 	case NL80211_IFTYPE_AP:
-		wdev = brcmf_ap_add_vif(wiphy, name, flags, params);
+		wdev = brcmf_ap_add_vif(wiphy, name, params);
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
-		wdev = brcmf_p2p_add_vif(wiphy, name, name_assign_type, type, flags, params);
+		wdev = brcmf_p2p_add_vif(wiphy, name, name_assign_type, type, params);
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	default:
@@ -858,7 +856,7 @@ int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
 
 static s32
 brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
-			 enum nl80211_iftype type, u32 *flags,
+			 enum nl80211_iftype type,
 			 struct vif_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
@@ -6553,7 +6551,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 	if (err)
 		goto default_conf_out;
 	err = brcmf_cfg80211_change_iface(wdev->wiphy, ndev, wdev->iftype,
-					  NULL, NULL);
+					  NULL);
 	if (err)
 		goto default_conf_out;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 85d949e03f79..aa299c47bfa2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2141,12 +2141,11 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
  * @name: name of the new interface.
  * @name_assign_type: origin of the interface name
  * @type: nl80211 interface type.
- * @flags: not used.
  * @params: contains mac address for P2P device.
  */
 struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 				       unsigned char name_assign_type,
-				       enum nl80211_iftype type, u32 *flags,
+				       enum nl80211_iftype type,
 				       struct vif_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
index 8ce9447533ef..0e8b34d2d85c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
@@ -150,7 +150,7 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced);
 void brcmf_p2p_detach(struct brcmf_p2p_info *p2p);
 struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 				       unsigned char name_assign_type,
-				       enum nl80211_iftype type, u32 *flags,
+				       enum nl80211_iftype type,
 				       struct vif_params *params);
 int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev);
 int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
diff --git a/drivers/net/wireless/intersil/orinoco/cfg.c b/drivers/net/wireless/intersil/orinoco/cfg.c
index 7aa47069af0a..b2d5ec8634b5 100644
--- a/drivers/net/wireless/intersil/orinoco/cfg.c
+++ b/drivers/net/wireless/intersil/orinoco/cfg.c
@@ -97,7 +97,7 @@ int orinoco_wiphy_register(struct wiphy *wiphy)
 }
 
 static int orinoco_change_vif(struct wiphy *wiphy, struct net_device *dev,
-			      enum nl80211_iftype type, u32 *flags,
+			      enum nl80211_iftype type,
 			      struct vif_params *params)
 {
 	struct orinoco_private *priv = wiphy_priv(wiphy);
diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 3f97acb57e66..a0463fef79b0 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1657,7 +1657,7 @@ static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
  */
 
 static int lbs_change_intf(struct wiphy *wiphy, struct net_device *dev,
-	enum nl80211_iftype type, u32 *flags,
+	enum nl80211_iftype type,
 	       struct vif_params *params)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 44d06177859e..9a0208e60ebc 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -935,7 +935,7 @@ mwifiex_init_new_priv_params(struct mwifiex_private *priv,
 static int
 mwifiex_change_vif_to_p2p(struct net_device *dev,
 			  enum nl80211_iftype curr_iftype,
-			  enum nl80211_iftype type, u32 *flags,
+			  enum nl80211_iftype type,
 			  struct vif_params *params)
 {
 	struct mwifiex_private *priv;
@@ -1007,7 +1007,7 @@ mwifiex_change_vif_to_p2p(struct net_device *dev,
 static int
 mwifiex_change_vif_to_sta_adhoc(struct net_device *dev,
 				enum nl80211_iftype curr_iftype,
-				enum nl80211_iftype type, u32 *flags,
+				enum nl80211_iftype type,
 				struct vif_params *params)
 {
 	struct mwifiex_private *priv;
@@ -1066,7 +1066,7 @@ mwifiex_change_vif_to_sta_adhoc(struct net_device *dev,
 static int
 mwifiex_change_vif_to_ap(struct net_device *dev,
 			 enum nl80211_iftype curr_iftype,
-			 enum nl80211_iftype type, u32 *flags,
+			 enum nl80211_iftype type,
 			 struct vif_params *params)
 {
 	struct mwifiex_private *priv;
@@ -1122,7 +1122,7 @@ mwifiex_change_vif_to_ap(struct net_device *dev,
 static int
 mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 				     struct net_device *dev,
-				     enum nl80211_iftype type, u32 *flags,
+				     enum nl80211_iftype type,
 				     struct vif_params *params)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
@@ -1143,10 +1143,10 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_P2P_GO:
 			return mwifiex_change_vif_to_p2p(dev, curr_iftype,
-							 type, flags, params);
+							 type, params);
 		case NL80211_IFTYPE_AP:
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
-							flags, params);
+							params);
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as IBSS\n", dev->name);
@@ -1173,10 +1173,10 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_P2P_GO:
 			return mwifiex_change_vif_to_p2p(dev, curr_iftype,
-							 type, flags, params);
+							 type, params);
 		case NL80211_IFTYPE_AP:
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
-							flags, params);
+							params);
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as STA\n", dev->name);
@@ -1194,13 +1194,12 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_STATION:
 			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
-							       type, flags,
-							       params);
+							       type, params);
 			break;
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_P2P_GO:
 			return mwifiex_change_vif_to_p2p(dev, curr_iftype,
-							 type, flags, params);
+							 type, params);
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as AP\n", dev->name);
@@ -1233,14 +1232,13 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 			if (mwifiex_cfg80211_deinit_p2p(priv))
 				return -EFAULT;
 			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
-							       type, flags,
-							       params);
+							       type, params);
 			break;
 		case NL80211_IFTYPE_AP:
 			if (mwifiex_cfg80211_deinit_p2p(priv))
 				return -EFAULT;
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
-							flags, params);
+							params);
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as P2P\n", dev->name);
@@ -2841,7 +2839,6 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 					      const char *name,
 					      unsigned char name_assign_type,
 					      enum nl80211_iftype type,
-					      u32 *flags,
 					      struct vif_params *params)
 {
 	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 912b687f4671..f50080a82851 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -596,7 +596,7 @@ static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	rtnl_lock();
 	/* Create station interface by default */
 	wdev = mwifiex_add_virtual_intf(adapter->wiphy, "mlan%d", NET_NAME_ENUM,
-					NL80211_IFTYPE_STATION, NULL, NULL);
+					NL80211_IFTYPE_STATION, NULL);
 	if (IS_ERR(wdev)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "cannot create default STA interface\n");
@@ -606,7 +606,7 @@ static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 
 	if (driver_mode & MWIFIEX_DRIVER_MODE_UAP) {
 		wdev = mwifiex_add_virtual_intf(adapter->wiphy, "uap%d", NET_NAME_ENUM,
-						NL80211_IFTYPE_AP, NULL, NULL);
+						NL80211_IFTYPE_AP, NULL);
 		if (IS_ERR(wdev)) {
 			mwifiex_dbg(adapter, ERROR,
 				    "cannot create AP interface\n");
@@ -617,8 +617,7 @@ static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 
 	if (driver_mode & MWIFIEX_DRIVER_MODE_P2P) {
 		wdev = mwifiex_add_virtual_intf(adapter->wiphy, "p2p%d", NET_NAME_ENUM,
-						NL80211_IFTYPE_P2P_CLIENT, NULL,
-						NULL);
+						NL80211_IFTYPE_P2P_CLIENT, NULL);
 		if (IS_ERR(wdev)) {
 			mwifiex_dbg(adapter, ERROR,
 				    "cannot create p2p client interface\n");
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index f1cb8753dc02..bb2a467d8b13 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1529,7 +1529,6 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 					      const char *name,
 					      unsigned char name_assign_type,
 					      enum nl80211_iftype type,
-					      u32 *flags,
 					      struct vif_params *params);
 int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev);
 
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 3b68eaffb48c..eb513628d801 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -479,7 +479,7 @@ struct rndis_wlan_private {
  */
 static int rndis_change_virtual_intf(struct wiphy *wiphy,
 					struct net_device *dev,
-					enum nl80211_iftype type, u32 *flags,
+					enum nl80211_iftype type,
 					struct vif_params *params);
 
 static int rndis_scan(struct wiphy *wiphy,
@@ -1857,7 +1857,7 @@ static struct ndis_80211_pmkid *update_pmkid(struct usbnet *usbdev,
  */
 static int rndis_change_virtual_intf(struct wiphy *wiphy,
 					struct net_device *dev,
-					enum nl80211_iftype type, u32 *flags,
+					enum nl80211_iftype type,
 					struct vif_params *params)
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7961d1c56847..2b4536318ca6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1837,7 +1837,7 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
-			       enum nl80211_iftype type, u32 *flags, struct vif_params *params)
+			       enum nl80211_iftype type, struct vif_params *params)
 {
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
@@ -2099,7 +2099,6 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 					     const char *name,
 					     unsigned char name_assign_type,
 					     enum nl80211_iftype type,
-					     u32 *flags,
 					     struct vif_params *params)
 {
 	struct wilc_vif *vif;
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 11870cb3f254..cbb3388a9756 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -100,7 +100,7 @@ static int prism2_domibset_pstr32(struct wlandevice *wlandev,
 /* The interface functions, called by the cfg80211 layer */
 static int prism2_change_virtual_intf(struct wiphy *wiphy,
 				      struct net_device *dev,
-				      enum nl80211_iftype type, u32 *flags,
+				      enum nl80211_iftype type,
 				      struct vif_params *params)
 {
 	struct wlandevice *wlandev = dev->ml_priv;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 70dfdb964958..a8faf9f0cac2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -363,6 +363,8 @@ static inline void wiphy_read_of_freq_limits(struct wiphy *wiphy)
 
 /**
  * struct vif_params - describes virtual interface parameters
+ * @flags: monitor interface flags, unchanged if 0, otherwise
+ *	%MONITOR_FLAG_CHANGED will be set
  * @use_4addr: use 4-address frames
  * @macaddr: address to use for this virtual interface.
  *	If this parameter is set to zero address the driver may
@@ -376,6 +378,7 @@ static inline void wiphy_read_of_freq_limits(struct wiphy *wiphy)
  *	MU-MIMO packets going to the specified station; %NULL if not changed
  */
 struct vif_params {
+	u32 flags;
 	int use_4addr;
 	u8 macaddr[ETH_ALEN];
 	const u8 *vht_mumimo_groups;
@@ -1214,6 +1217,7 @@ static inline int cfg80211_get_station(struct net_device *dev,
  * Monitor interface configuration flags. Note that these must be the bits
  * according to the nl80211 flags.
  *
+ * @MONITOR_FLAG_CHANGED: set if the flags were changed
  * @MONITOR_FLAG_FCSFAIL: pass frames with bad FCS
  * @MONITOR_FLAG_PLCPFAIL: pass frames with bad PLCP
  * @MONITOR_FLAG_CONTROL: pass control frames
@@ -1222,6 +1226,7 @@ static inline int cfg80211_get_station(struct net_device *dev,
  * @MONITOR_FLAG_ACTIVE: active monitor, ACKs frames on its MAC address
  */
 enum monitor_flags {
+	MONITOR_FLAG_CHANGED		= 1<<__NL80211_MNTR_FLAG_INVALID,
 	MONITOR_FLAG_FCSFAIL		= 1<<NL80211_MNTR_FLAG_FCSFAIL,
 	MONITOR_FLAG_PLCPFAIL		= 1<<NL80211_MNTR_FLAG_PLCPFAIL,
 	MONITOR_FLAG_CONTROL		= 1<<NL80211_MNTR_FLAG_CONTROL,
@@ -2829,13 +2834,12 @@ struct cfg80211_ops {
 						  const char *name,
 						  unsigned char name_assign_type,
 						  enum nl80211_iftype type,
-						  u32 *flags,
 						  struct vif_params *params);
 	int	(*del_virtual_intf)(struct wiphy *wiphy,
 				    struct wireless_dev *wdev);
 	int	(*change_virtual_intf)(struct wiphy *wiphy,
 				       struct net_device *dev,
-				       enum nl80211_iftype type, u32 *flags,
+				       enum nl80211_iftype type,
 				       struct vif_params *params);
 
 	int	(*add_key)(struct wiphy *wiphy, struct net_device *netdev,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3dd0b7511b84..de52fe3e0ce6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -69,7 +69,6 @@ static struct wireless_dev *ieee80211_add_iface(struct wiphy *wiphy,
 						const char *name,
 						unsigned char name_assign_type,
 						enum nl80211_iftype type,
-						u32 *flags,
 						struct vif_params *params)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
@@ -90,8 +89,7 @@ static struct wireless_dev *ieee80211_add_iface(struct wiphy *wiphy,
 			return NULL;
 		}
 
-		if (flags)
-			sdata->u.mntr.flags = *flags;
+		sdata->u.mntr.flags = params->flags;
 	}
 
 	return wdev;
@@ -106,7 +104,7 @@ static int ieee80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
 
 static int ieee80211_change_iface(struct wiphy *wiphy,
 				  struct net_device *dev,
-				  enum nl80211_iftype type, u32 *flags,
+				  enum nl80211_iftype type,
 				  struct vif_params *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -133,7 +131,7 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		if (err)
 			return err;
 
-		if (!flags)
+		if (!params->flags)
 			return 0;
 
 		if (ieee80211_sdata_running(sdata)) {
@@ -149,11 +147,12 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 			 *	cooked_mntrs, monitor and all fif_* counters
 			 *	reconfigure hardware
 			 */
-			if ((*flags & mask) != (sdata->u.mntr.flags & mask))
+			if ((params->flags & mask) !=
+			    (sdata->u.mntr.flags & mask))
 				return -EBUSY;
 
 			ieee80211_adjust_monitor_flags(sdata, -1);
-			sdata->u.mntr.flags = *flags;
+			sdata->u.mntr.flags = params->flags;
 			ieee80211_adjust_monitor_flags(sdata, 1);
 
 			ieee80211_configure_filter(local);
@@ -163,7 +162,7 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 			 * and ieee80211_do_open take care of "everything"
 			 * mentioned in the comment above.
 			 */
-			sdata->u.mntr.flags = *flags;
+			sdata->u.mntr.flags = params->flags;
 		}
 	}
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 58ca206982fe..c935c8e4f332 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -429,7 +429,7 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
-			  u32 *flags, struct vif_params *params);
+			  struct vif_params *params);
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
 void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1b8f267315f1..dd871586cb94 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2703,6 +2703,8 @@ static int parse_monitor_flags(struct nlattr *nla, u32 *mntrflags)
 		if (flags[flag])
 			*mntrflags |= (1<<flag);
 
+	*mntrflags |= MONITOR_FLAG_CHANGED;
+
 	return 0;
 }
 
@@ -2739,7 +2741,6 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 	int err;
 	enum nl80211_iftype otype, ntype;
 	struct net_device *dev = info->user_ptr[1];
-	u32 _flags, *flags = NULL;
 	bool change = false;
 
 	memset(&params, 0, sizeof(params));
@@ -2786,14 +2787,17 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		if (ntype != NL80211_IFTYPE_MONITOR)
 			return -EINVAL;
 		err = parse_monitor_flags(info->attrs[NL80211_ATTR_MNTR_FLAGS],
-					  &_flags);
+					  &params.flags);
 		if (err)
 			return err;
 
-		flags = &_flags;
 		change = true;
 	}
 
+	if (params.flags & MONITOR_FLAG_ACTIVE &&
+	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
+		return -EOPNOTSUPP;
+
 	if (info->attrs[NL80211_ATTR_MU_MIMO_GROUP_DATA]) {
 		const u8 *mumimo_groups;
 		u32 cap_flag = NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER;
@@ -2824,12 +2828,8 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		change = true;
 	}
 
-	if (flags && (*flags & MONITOR_FLAG_ACTIVE) &&
-	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
-		return -EOPNOTSUPP;
-
 	if (change)
-		err = cfg80211_change_iface(rdev, dev, ntype, flags, &params);
+		err = cfg80211_change_iface(rdev, dev, ntype, &params);
 	else
 		err = 0;
 
@@ -2847,7 +2847,6 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	struct sk_buff *msg;
 	int err;
 	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
-	u32 flags;
 
 	/* to avoid failing a new interface creation due to pending removal */
 	cfg80211_destroy_ifaces(rdev);
@@ -2883,11 +2882,17 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	}
 
-	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
-				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
-				  &flags);
+	if (info->attrs[NL80211_ATTR_MNTR_FLAGS]) {
+		if (type != NL80211_IFTYPE_MONITOR)
+			return -EINVAL;
+
+		err = parse_monitor_flags(info->attrs[NL80211_ATTR_MNTR_FLAGS],
+					  &params.flags);
+		if (err)
+			return err;
+	}
 
-	if (!err && (flags & MONITOR_FLAG_ACTIVE) &&
+	if (params.flags & MONITOR_FLAG_ACTIVE &&
 	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
 		return -EOPNOTSUPP;
 
@@ -2897,8 +2902,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 
 	wdev = rdev_add_virtual_intf(rdev,
 				nla_data(info->attrs[NL80211_ATTR_IFNAME]),
-				NET_NAME_USER, type, err ? NULL : &flags,
-				&params);
+				NET_NAME_USER, type, &params);
 	if (WARN_ON(!wdev)) {
 		nlmsg_free(msg);
 		return -EPROTO;
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 2f425075ada8..315ceee1eaf9 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -36,13 +36,13 @@ static inline void rdev_set_wakeup(struct cfg80211_registered_device *rdev,
 static inline struct wireless_dev
 *rdev_add_virtual_intf(struct cfg80211_registered_device *rdev, char *name,
 		       unsigned char name_assign_type,
-		       enum nl80211_iftype type, u32 *flags,
+		       enum nl80211_iftype type,
 		       struct vif_params *params)
 {
 	struct wireless_dev *ret;
 	trace_rdev_add_virtual_intf(&rdev->wiphy, name, type);
 	ret = rdev->ops->add_virtual_intf(&rdev->wiphy, name, name_assign_type,
-					  type, flags, params);
+					  type, params);
 	trace_rdev_return_wdev(&rdev->wiphy, ret);
 	return ret;
 }
@@ -61,12 +61,11 @@ rdev_del_virtual_intf(struct cfg80211_registered_device *rdev,
 static inline int
 rdev_change_virtual_intf(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev, enum nl80211_iftype type,
-			 u32 *flags, struct vif_params *params)
+			 struct vif_params *params)
 {
 	int ret;
 	trace_rdev_change_virtual_intf(&rdev->wiphy, dev, type);
-	ret = rdev->ops->change_virtual_intf(&rdev->wiphy, dev, type, flags,
-					     params);
+	ret = rdev->ops->change_virtual_intf(&rdev->wiphy, dev, type, params);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 68e5f2ecee1a..69390f414d9d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -991,7 +991,7 @@ void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev)
 
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
-			  u32 *flags, struct vif_params *params)
+			  struct vif_params *params)
 {
 	int err;
 	enum nl80211_iftype otype = dev->ieee80211_ptr->iftype;
@@ -1049,7 +1049,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		cfg80211_process_rdev_events(rdev);
 	}
 
-	err = rdev_change_virtual_intf(rdev, dev, ntype, flags, params);
+	err = rdev_change_virtual_intf(rdev, dev, ntype, params);
 
 	WARN_ON(!err && dev->ieee80211_ptr->iftype != ntype);
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index a220156cf217..5d4a02c7979b 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -62,7 +62,7 @@ int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
 
 	memset(&vifparams, 0, sizeof(vifparams));
 
-	return cfg80211_change_iface(rdev, dev, type, NULL, &vifparams);
+	return cfg80211_change_iface(rdev, dev, type, &vifparams);
 }
 EXPORT_WEXT_HANDLER(cfg80211_wext_siwmode);
 
-- 
2.11.0
