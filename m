Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48564 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaJJRwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 13:52:46 -0400
Date: Fri, 10 Oct 2014 20:52:40 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] cfg80211: Convert del_station() callback to use a param
 struct
Message-ID: <20141010175240.GA29287@jouni.qca.qualcomm.com> (sfid-20141010_195250_174534_EC26C2C8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it easier to add new parameters for the del_station calls
without having to modify all drivers that use this.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  4 ++--
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  5 +++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  8 +++----
 drivers/net/wireless/mwifiex/cfg80211.c            |  9 ++++----
 include/net/cfg80211.h                             | 15 +++++++++++--
 net/mac80211/cfg.c                                 |  6 +++---
 net/wireless/nl80211.c                             |  8 ++++---
 net/wireless/rdev-ops.h                            |  7 +++---
 net/wireless/trace.h                               | 25 +++++++++++++++++++---
 9 files changed, 61 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ba60e37..7a53378 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2976,11 +2976,11 @@ static int ath6kl_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 static const u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 static int ath6kl_del_station(struct wiphy *wiphy, struct net_device *dev,
-			      const u8 *mac)
+			      struct station_del_parameters *params)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
-	const u8 *addr = mac ? mac : bcast_addr;
+	const u8 *addr = params->mac ? params->mac : bcast_addr;
 
 	return ath6kl_wmi_ap_set_mlme(ar->wmi, vif->fw_vif_idx, WMI_AP_DEAUTH,
 				      addr, WLAN_REASON_PREV_AUTH_NOT_VALID);
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index d9f4b30..8fdfa32 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -792,12 +792,13 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 }
 
 static int wil_cfg80211_del_station(struct wiphy *wiphy,
-				    struct net_device *dev, const u8 *mac)
+				    struct net_device *dev,
+				    struct station_del_parameters *params)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
 	mutex_lock(&wil->mutex);
-	wil6210_disconnect(wil, mac);
+	wil6210_disconnect(wil, params->mac);
 	mutex_unlock(&wil->mutex);
 
 	return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 28fa25b..1a2e062 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3998,24 +3998,24 @@ brcmf_cfg80211_change_beacon(struct wiphy *wiphy, struct net_device *ndev,
 
 static int
 brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
-			   const u8 *mac)
+			   struct station_del_parameters *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_scb_val_le scbval;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 
-	if (!mac)
+	if (!params->mac)
 		return -EFAULT;
 
-	brcmf_dbg(TRACE, "Enter %pM\n", mac);
+	brcmf_dbg(TRACE, "Enter %pM\n", params->mac);
 
 	if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
 		ifp = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
-	memcpy(&scbval.ea, mac, ETH_ALEN);
+	memcpy(&scbval.ea, params->mac, ETH_ALEN);
 	scbval.val = cpu_to_le32(WLAN_REASON_DEAUTH_LEAVING);
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
 				     &scbval, sizeof(scbval));
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 0dd6729..71e29c7 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1239,7 +1239,7 @@ static int mwifiex_cfg80211_change_beacon(struct wiphy *wiphy,
  */
 static int
 mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
-			     const u8 *mac)
+			     struct station_del_parameters *params)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct mwifiex_sta_node *sta_node;
@@ -1248,7 +1248,7 @@ mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 	if (list_empty(&priv->sta_list) || !priv->bss_started)
 		return 0;
 
-	if (!mac || is_broadcast_ether_addr(mac)) {
+	if (!params->mac || is_broadcast_ether_addr(params->mac)) {
 		wiphy_dbg(wiphy, "%s: NULL/broadcast mac address\n", __func__);
 		list_for_each_entry(sta_node, &priv->sta_list, list) {
 			if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_STA_DEAUTH,
@@ -1258,9 +1258,10 @@ mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 			mwifiex_uap_del_sta_data(priv, sta_node);
 		}
 	} else {
-		wiphy_dbg(wiphy, "%s: mac address %pM\n", __func__, mac);
+		wiphy_dbg(wiphy, "%s: mac address %pM\n", __func__,
+			  params->mac);
 		spin_lock_irqsave(&priv->sta_list_spinlock, flags);
-		sta_node = mwifiex_get_sta_entry(priv, mac);
+		sta_node = mwifiex_get_sta_entry(priv, params->mac);
 		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 		if (sta_node) {
 			if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_STA_DEAUTH,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a2ddcf2..777e191 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -799,6 +799,17 @@ struct station_parameters {
 };
 
 /**
+ * struct station_del_parameters - station deletion parameters
+ *
+ * Used to delete a station entry (or all stations).
+ *
+ * @mac: MAC address of the station to remove or NULL to remove all stations
+ */
+struct station_del_parameters {
+	const u8 *mac;
+};
+
+/**
  * enum cfg80211_station_type - the type of station being modified
  * @CFG80211_STA_AP_CLIENT: client of an AP interface
  * @CFG80211_STA_AP_MLME_CLIENT: client of an AP interface that has
@@ -2132,7 +2143,7 @@ struct cfg80211_qos_map {
  * @stop_ap: Stop being an AP, including stopping beaconing.
  *
  * @add_station: Add a new station.
- * @del_station: Remove a station; @mac may be NULL to remove all stations.
+ * @del_station: Remove a station
  * @change_station: Modify a given station. Note that flags changes are not much
  *	validated in cfg80211, in particular the auth/assoc/authorized flags
  *	might come to the driver in invalid combinations -- make sure to check
@@ -2376,7 +2387,7 @@ struct cfg80211_ops {
 			       const u8 *mac,
 			       struct station_parameters *params);
 	int	(*del_station)(struct wiphy *wiphy, struct net_device *dev,
-			       const u8 *mac);
+			       struct station_del_parameters *params);
 	int	(*change_station)(struct wiphy *wiphy, struct net_device *dev,
 				  const u8 *mac,
 				  struct station_parameters *params);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fb6a150..2b4c7d2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1225,14 +1225,14 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
-				 const u8 *mac)
+				 struct station_del_parameters *params)
 {
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (mac)
-		return sta_info_destroy_addr_bss(sdata, mac);
+	if (params->mac)
+		return sta_info_destroy_addr_bss(sdata, params->mac);
 
 	sta_info_flush(sdata);
 	return 0;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cb9f5a4..9333990 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4398,10 +4398,12 @@ static int nl80211_del_station(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
-	u8 *mac_addr = NULL;
+	struct station_del_parameters params;
+
+	memset(&params, 0, sizeof(params));
 
 	if (info->attrs[NL80211_ATTR_MAC])
-		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+		params.mac = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
@@ -4412,7 +4414,7 @@ static int nl80211_del_station(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->del_station)
 		return -EOPNOTSUPP;
 
-	return rdev_del_station(rdev, dev, mac_addr);
+	return rdev_del_station(rdev, dev, &params);
 }
 
 static int nl80211_send_mpath(struct sk_buff *msg, u32 portid, u32 seq,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index f6d457d..3bfd20e 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -178,11 +178,12 @@ static inline int rdev_add_station(struct cfg80211_registered_device *rdev,
 }
 
 static inline int rdev_del_station(struct cfg80211_registered_device *rdev,
-				   struct net_device *dev, u8 *mac)
+				   struct net_device *dev,
+				   struct station_del_parameters *params)
 {
 	int ret;
-	trace_rdev_del_station(&rdev->wiphy, dev, mac);
-	ret = rdev->ops->del_station(&rdev->wiphy, dev, mac);
+	trace_rdev_del_station(&rdev->wiphy, dev, params);
+	ret = rdev->ops->del_station(&rdev->wiphy, dev, params);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 625a6e6..66bc3c9 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -680,9 +680,28 @@ DECLARE_EVENT_CLASS(wiphy_netdev_mac_evt,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(sta_mac))
 );
 
-DEFINE_EVENT(wiphy_netdev_mac_evt, rdev_del_station,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *mac),
-	TP_ARGS(wiphy, netdev, mac)
+DECLARE_EVENT_CLASS(station_del,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct station_del_parameters *params),
+	TP_ARGS(wiphy, netdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(sta_mac)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(sta_mac, params->mac);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", station mac: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(sta_mac))
+);
+
+DEFINE_EVENT(station_del, rdev_del_station,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct station_del_parameters *params),
+	TP_ARGS(wiphy, netdev, params)
 );
 
 DEFINE_EVENT(wiphy_netdev_mac_evt, rdev_get_station,
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
