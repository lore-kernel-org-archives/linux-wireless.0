Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46682 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbbAMGJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 01:09:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0D65XJr023029
	for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 22:09:33 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rv520k6c8-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 22:09:33 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 6/8] mwifiex: manage virtual interface limits efficiently
Date: Tue, 13 Jan 2015 17:08:48 +0530
Message-ID: <1421149130-5889-7-git-send-email-patila@marvell.com> (sfid-20150113_070937_673139_C199506F)
In-Reply-To: <1421149130-5889-1-git-send-email-patila@marvell.com>
References: <1421149130-5889-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently interface limits are checked by seeing if bss_mode for
particular priv is set. If bss_mode is not set, interface creation
is allowed. This patch adds framework to initializes maximum virtual
interfaces supported during load time and check current number of
interfaces created agains allowed interface limit during new virtual
interface creation.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 80 ++++++++++++++++++++++++++++-----
 drivers/net/wireless/mwifiex/decl.h     | 10 +++++
 drivers/net/wireless/mwifiex/init.c     |  4 ++
 drivers/net/wireless/mwifiex/main.h     | 21 +++++++++
 4 files changed, 103 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 54b86bb..bf8b3cf 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2183,13 +2183,20 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
-		priv = adapter->priv[MWIFIEX_BSS_TYPE_STA];
-		if (priv->bss_mode) {
+		if (adapter->curr_iface_comb.sta_intf ==
+		    adapter->iface_limit.sta_intf) {
 			wiphy_err(wiphy,
 				  "cannot create multiple sta/adhoc ifaces\n");
 			return ERR_PTR(-EINVAL);
 		}
 
+		priv = mwifiex_get_unused_priv(adapter);
+		if (!priv) {
+			wiphy_err(wiphy,
+				  "could not get free private struct\n");
+			return ERR_PTR(-EFAULT);
+		}
+
 		priv->wdev.wiphy = wiphy;
 		priv->wdev.iftype = NL80211_IFTYPE_STATION;
 
@@ -2206,13 +2213,20 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 		break;
 	case NL80211_IFTYPE_AP:
-		priv = adapter->priv[MWIFIEX_BSS_TYPE_UAP];
-
-		if (priv->bss_mode) {
-			wiphy_err(wiphy, "Can't create multiple AP interfaces");
+		if (adapter->curr_iface_comb.uap_intf ==
+		    adapter->iface_limit.uap_intf) {
+			wiphy_err(wiphy,
+				  "cannot create multiple AP ifaces\n");
 			return ERR_PTR(-EINVAL);
 		}
 
+		priv = mwifiex_get_unused_priv(adapter);
+		if (!priv) {
+			wiphy_err(wiphy,
+				  "could not get free private struct\n");
+			return ERR_PTR(-EFAULT);
+		}
+
 		priv->wdev.wiphy = wiphy;
 		priv->wdev.iftype = NL80211_IFTYPE_AP;
 
@@ -2226,15 +2240,21 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
-		priv = adapter->priv[MWIFIEX_BSS_TYPE_P2P];
-
-		if (priv->bss_mode) {
-			wiphy_err(wiphy, "Can't create multiple P2P ifaces");
+		if (adapter->curr_iface_comb.p2p_intf ==
+		    adapter->iface_limit.p2p_intf) {
+			wiphy_err(wiphy,
+				  "cannot create multiple P2P ifaces\n");
 			return ERR_PTR(-EINVAL);
 		}
 
-		priv->wdev.wiphy = wiphy;
+		priv = mwifiex_get_unused_priv(adapter);
+		if (!priv) {
+			wiphy_err(wiphy,
+				  "could not get free private struct\n");
+			return ERR_PTR(-EFAULT);
+		}
 
+		priv->wdev.wiphy = wiphy;
 		/* At start-up, wpa_supplicant tries to change the interface
 		 * to NL80211_IFTYPE_STATION if it is not managed mode.
 		 */
@@ -2327,6 +2347,23 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	mwifiex_dev_debugfs_init(priv);
 #endif
 
+	switch (type) {
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+		adapter->curr_iface_comb.sta_intf++;
+		break;
+	case NL80211_IFTYPE_AP:
+		adapter->curr_iface_comb.uap_intf++;
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		adapter->curr_iface_comb.p2p_intf++;
+		break;
+	default:
+		wiphy_err(wiphy, "type not supported\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	return &priv->wdev;
 }
 EXPORT_SYMBOL_GPL(mwifiex_add_virtual_intf);
@@ -2337,12 +2374,13 @@ EXPORT_SYMBOL_GPL(mwifiex_add_virtual_intf);
 int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
+	struct mwifiex_adapter *adapter = priv->adapter;
 
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_remove(priv);
 #endif
 
-	mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
+	mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 
 	if (netif_carrier_ok(priv->netdev))
 		netif_carrier_off(priv->netdev);
@@ -2357,6 +2395,24 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 
 	priv->media_connected = false;
 
+	switch (priv->bss_mode) {
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+		adapter->curr_iface_comb.sta_intf++;
+		break;
+	case NL80211_IFTYPE_AP:
+		adapter->curr_iface_comb.uap_intf++;
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		adapter->curr_iface_comb.p2p_intf++;
+		break;
+	default:
+		dev_err(adapter->dev, "del_virtual_intf: type not supported\n");
+		break;
+	}
+
 	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA ||
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 7aa988e..4481ac4 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -104,6 +104,10 @@
 /* Rate index for OFDM 0 */
 #define MWIFIEX_RATE_INDEX_OFDM0   4
 
+#define MWIFIEX_MAX_STA_NUM		1
+#define MWIFIEX_MAX_UAP_NUM		1
+#define MWIFIEX_MAX_P2P_NUM		1
+
 enum mwifiex_bss_type {
 	MWIFIEX_BSS_TYPE_STA = 0,
 	MWIFIEX_BSS_TYPE_UAP = 1,
@@ -232,4 +236,10 @@ struct mwifiex_histogram_data {
 	atomic_t num_samples;
 };
 
+struct mwifiex_iface_comb {
+	u8 sta_intf;
+	u8 uap_intf;
+	u8 p2p_intf;
+};
+
 #endif /* !_MWIFIEX_DECL_H_ */
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index ae42cd9..d54c576 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -286,6 +286,10 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->key_api_major_ver = 0;
 	adapter->key_api_minor_ver = 0;
 	memset(adapter->perm_addr, 0xff, ETH_ALEN);
+
+	adapter->iface_limit.sta_intf = MWIFIEX_MAX_STA_NUM;
+	adapter->iface_limit.uap_intf = MWIFIEX_MAX_UAP_NUM;
+	adapter->iface_limit.p2p_intf = MWIFIEX_MAX_P2P_NUM;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index b2fe220..5f33cc5 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -731,6 +731,8 @@ struct mwifiex_if_ops {
 
 struct mwifiex_adapter {
 	u8 iface_type;
+	struct mwifiex_iface_comb iface_limit;
+	struct mwifiex_iface_comb curr_iface_comb;
 	struct mwifiex_private *priv[MWIFIEX_MAX_BSS_NUM];
 	u8 priv_num;
 	const struct firmware *firmware;
@@ -1150,6 +1152,25 @@ mwifiex_get_priv(struct mwifiex_adapter *adapter,
 }
 
 /*
+ * This function returns the first available unused private structure pointer.
+ */
+static inline struct mwifiex_private *
+mwifiex_get_unused_priv(struct mwifiex_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i]) {
+			if (adapter->priv[i]->bss_mode ==
+			    NL80211_IFTYPE_UNSPECIFIED)
+				break;
+		}
+	}
+
+	return ((i < adapter->priv_num) ? adapter->priv[i] : NULL);
+}
+
+/*
  * This function returns the driver private structure of a network device.
  */
 static inline struct mwifiex_private *
-- 
1.8.1.4

