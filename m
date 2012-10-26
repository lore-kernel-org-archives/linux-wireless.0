Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2JZNSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 09:18:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/4] cfg80211: allow per interface TX power setting
Date: Fri, 26 Oct 2012 15:19:20 +0200
Message-Id: <1351257562-30729-3-git-send-email-johannes@sipsolutions.net> (sfid-20121026_151855_648082_0C869E33)
In-Reply-To: <1351257562-30729-1-git-send-email-johannes@sipsolutions.net>
References: <1351257562-30729-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The TX power setting is currently per wiphy (hardware
device) but with multi-channel capabilities that doesn't
make much sense any more.

Allow drivers (and mac80211) to advertise support for
per-interface TX power configuration. When the TX power
is configured for the wiphy, the wdev will be NULL and
the driver can still handle that, but when a wdev is
given the TX power can be set only for that wdev now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    9 ++++----
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 +++--
 drivers/net/wireless/mwifiex/cfg80211.c            |    1 +
 drivers/net/wireless/rndis_wlan.c                  |   10 ++++++--
 include/net/cfg80211.h                             |   10 +++++---
 include/uapi/linux/nl80211.h                       |    2 ++
 net/mac80211/cfg.c                                 |    5 +++-
 net/wireless/nl80211.c                             |    6 ++++-
 net/wireless/rdev-ops.h                            |   11 +++++----
 net/wireless/trace.h                               |   24 +++++++++++---------
 net/wireless/wext-compat.c                         |    4 ++--
 11 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2770899..d615f9f 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1384,11 +1384,8 @@ static int ath6kl_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	return 0;
 }
 
-/*
- * The type nl80211_tx_power_setting replaces the following
- * data type from 2.6.36 onwards
-*/
 static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
+				       struct wireless_dev *wdev,
 				       enum nl80211_tx_power_setting type,
 				       int mbm)
 {
@@ -1423,7 +1420,9 @@ static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
 	return 0;
 }
 
-static int ath6kl_cfg80211_get_txpower(struct wiphy *wiphy, int *dbm)
+static int ath6kl_cfg80211_get_txpower(struct wiphy *wiphy,
+				       struct wireless_dev *wdev,
+				       int *dbm)
 {
 	struct ath6kl *ar = (struct ath6kl *)wiphy_priv(wiphy);
 	struct ath6kl_vif *vif;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 0e95209..ce88d96 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1876,7 +1876,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 }
 
 static s32
-brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
+brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 			    enum nl80211_tx_power_setting type, s32 mbm)
 {
 
@@ -1924,7 +1924,9 @@ done:
 	return err;
 }
 
-static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
+static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy,
+				       struct wireless_dev *wdev,
+				       s32 *dbm)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct net_device *ndev = cfg_to_ndev(cfg);
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 38a5871..d3d7a71 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -324,6 +324,7 @@ mwifiex_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
  */
 static int
 mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
+			      struct wireless_dev *wdev,
 			      enum nl80211_tx_power_setting type,
 			      int mbm)
 {
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index bd1f0cb..5390af3 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -490,9 +490,12 @@ static int rndis_scan(struct wiphy *wiphy,
 static int rndis_set_wiphy_params(struct wiphy *wiphy, u32 changed);
 
 static int rndis_set_tx_power(struct wiphy *wiphy,
+			      struct wireless_dev *wdev,
 			      enum nl80211_tx_power_setting type,
 			      int mbm);
-static int rndis_get_tx_power(struct wiphy *wiphy, int *dbm);
+static int rndis_get_tx_power(struct wiphy *wiphy,
+			      struct wireless_dev *wdev,
+			      int *dbm);
 
 static int rndis_connect(struct wiphy *wiphy, struct net_device *dev,
 				struct cfg80211_connect_params *sme);
@@ -1903,6 +1906,7 @@ static int rndis_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 }
 
 static int rndis_set_tx_power(struct wiphy *wiphy,
+			      struct wireless_dev *wdev,
 			      enum nl80211_tx_power_setting type,
 			      int mbm)
 {
@@ -1930,7 +1934,9 @@ static int rndis_set_tx_power(struct wiphy *wiphy,
 	return -ENOTSUPP;
 }
 
-static int rndis_get_tx_power(struct wiphy *wiphy, int *dbm)
+static int rndis_get_tx_power(struct wiphy *wiphy,
+			      struct wireless_dev *wdev,
+			      int *dbm)
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
 	struct usbnet *usbdev = priv->usbdev;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index aa0e4a1..08c921a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1550,7 +1550,10 @@ struct cfg80211_gtk_rekey_data {
  *	struct wiphy. If returning an error, no value should be changed.
  *
  * @set_tx_power: set the transmit power according to the parameters,
- *	the power passed is in mBm, to get dBm use MBM_TO_DBM().
+ *	the power passed is in mBm, to get dBm use MBM_TO_DBM(). The
+ *	wdev may be %NULL if power was set for the wiphy, and will
+ *	always be %NULL unless the driver supports per-vif TX power
+ *	(as advertised by the nl80211 feature flag.)
  * @get_tx_power: store the current TX power into the dbm variable;
  *	return 0 if successful
  *
@@ -1747,9 +1750,10 @@ struct cfg80211_ops {
 
 	int	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
 
-	int	(*set_tx_power)(struct wiphy *wiphy,
+	int	(*set_tx_power)(struct wiphy *wiphy, struct wireless_dev *wdev,
 				enum nl80211_tx_power_setting type, int mbm);
-	int	(*get_tx_power)(struct wiphy *wiphy, int *dbm);
+	int	(*get_tx_power)(struct wiphy *wiphy, struct wireless_dev *wdev,
+				int *dbm);
 
 	int	(*set_wds_peer)(struct wiphy *wiphy, struct net_device *dev,
 				const u8 *addr);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 617d0fb..4c5f674 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3051,6 +3051,7 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_LOW_PRIORITY_SCAN: This driver supports low priority scan
  * @NL80211_FEATURE_SCAN_FLUSH: Scan flush is supported
  * @NL80211_FEATURE_AP_SCAN: Support scanning using an AP vif
+ * @NL80211_FEATURE_VIF_TXPOWER: The driver supports per-vif TX power setting
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3062,6 +3063,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_LOW_PRIORITY_SCAN		= 1 << 6,
 	NL80211_FEATURE_SCAN_FLUSH			= 1 << 7,
 	NL80211_FEATURE_AP_SCAN				= 1 << 8,
+	NL80211_FEATURE_VIF_TXPOWER			= 1 << 9,
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 34fd3eb..a352e4d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1992,6 +1992,7 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 }
 
 static int ieee80211_set_tx_power(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
 				  enum nl80211_tx_power_setting type, int mbm)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
@@ -2026,7 +2027,9 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 	return 0;
 }
 
-static int ieee80211_get_tx_power(struct wiphy *wiphy, int *dbm)
+static int ieee80211_get_tx_power(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  int *dbm)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 879ca62..87d4670 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1585,9 +1585,13 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_TX_POWER_SETTING]) {
+		struct wireless_dev *txp_wdev = wdev;
 		enum nl80211_tx_power_setting type;
 		int idx, mbm = 0;
 
+		if (!(rdev->wiphy.features & NL80211_FEATURE_VIF_TXPOWER))
+			txp_wdev = NULL;
+
 		if (!rdev->ops->set_tx_power) {
 			result = -EOPNOTSUPP;
 			goto bad_res;
@@ -1607,7 +1611,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			mbm = nla_get_u32(info->attrs[idx]);
 		}
 
-		result = rdev_set_tx_power(rdev, type, mbm);
+		result = rdev_set_tx_power(rdev, txp_wdev, type, mbm);
 		if (result)
 			goto bad_res;
 	}
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index eb5f897..6e5fa65 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -476,21 +476,22 @@ rdev_set_wiphy_params(struct cfg80211_registered_device *rdev, u32 changed)
 }
 
 static inline int rdev_set_tx_power(struct cfg80211_registered_device *rdev,
+				    struct wireless_dev *wdev,
 				    enum nl80211_tx_power_setting type, int mbm)
 {
 	int ret;
-	trace_rdev_set_tx_power(&rdev->wiphy, type, mbm);
-	ret = rdev->ops->set_tx_power(&rdev->wiphy, type, mbm);
+	trace_rdev_set_tx_power(&rdev->wiphy, wdev, type, mbm);
+	ret = rdev->ops->set_tx_power(&rdev->wiphy, wdev, type, mbm);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
 
 static inline int rdev_get_tx_power(struct cfg80211_registered_device *rdev,
-				    int *dbm)
+				    struct wireless_dev *wdev, int *dbm)
 {
 	int ret;
-	trace_rdev_get_tx_power(&rdev->wiphy);
-	ret = rdev->ops->get_tx_power(&rdev->wiphy, dbm);
+	trace_rdev_get_tx_power(&rdev->wiphy, wdev);
+	ret = rdev->ops->get_tx_power(&rdev->wiphy, wdev, dbm);
 	trace_rdev_return_int_int(&rdev->wiphy, ret, *dbm);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 0ca71ca..8e03c63 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -26,7 +26,7 @@
 #define WIPHY_PR_ARG MAC_PR_ARG(wiphy_mac)
 
 #define WDEV_ENTRY __field(u32, id)
-#define WDEV_ASSIGN (__entry->id) = (wdev->identifier)
+#define WDEV_ASSIGN (__entry->id) = (wdev ? wdev->identifier : 0)
 #define WDEV_PR_FMT ", wdev id: %u"
 #define WDEV_PR_ARG (__entry->id)
 
@@ -260,11 +260,6 @@ DEFINE_EVENT(wiphy_only_evt, rdev_get_antenna,
 	TP_ARGS(wiphy)
 );
 
-DEFINE_EVENT(wiphy_only_evt, rdev_get_tx_power,
-	TP_PROTO(struct wiphy *wiphy),
-	TP_ARGS(wiphy)
-);
-
 DEFINE_EVENT(wiphy_only_evt, rdev_rfkill_poll,
 	TP_PROTO(struct wiphy *wiphy),
 	TP_ARGS(wiphy)
@@ -1230,22 +1225,29 @@ TRACE_EVENT(rdev_set_wiphy_params,
 		  WIPHY_PR_ARG, __entry->changed)
 );
 
+DEFINE_EVENT(wiphy_wdev_evt, rdev_get_tx_power,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev)
+);
+
 TRACE_EVENT(rdev_set_tx_power,
-	TP_PROTO(struct wiphy *wiphy, enum nl80211_tx_power_setting type,
-		 int mbm),
-	TP_ARGS(wiphy, type, mbm),
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 enum nl80211_tx_power_setting type, int mbm),
+	TP_ARGS(wiphy, wdev, type, mbm),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
+		WDEV_ENTRY
 		__field(enum nl80211_tx_power_setting, type)
 		__field(int, mbm)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
 		__entry->type = type;
 		__entry->mbm = mbm;
 	),
-	TP_printk(WIPHY_PR_FMT ", type: %d, mbm: %d",
-		  WIPHY_PR_ARG, __entry->type, __entry->mbm)
+	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT ", type: %d, mbm: %d",
+		  WIPHY_PR_ARG, WDEV_PR_ARG,__entry->type, __entry->mbm)
 );
 
 TRACE_EVENT(rdev_return_int_int,
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 6488d2d..742ab6e 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -895,7 +895,7 @@ static int cfg80211_wext_siwtxpower(struct net_device *dev,
 		return 0;
 	}
 
-	return rdev_set_tx_power(rdev, type, DBM_TO_MBM(dbm));
+	return rdev_set_tx_power(rdev, wdev, type, DBM_TO_MBM(dbm));
 }
 
 static int cfg80211_wext_giwtxpower(struct net_device *dev,
@@ -914,7 +914,7 @@ static int cfg80211_wext_giwtxpower(struct net_device *dev,
 	if (!rdev->ops->get_tx_power)
 		return -EOPNOTSUPP;
 
-	err = rdev_get_tx_power(rdev, &val);
+	err = rdev_get_tx_power(rdev, wdev, &val);
 	if (err)
 		return err;
 
-- 
1.7.10.4

