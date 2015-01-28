Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44576 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965269AbbA1Enh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 23:43:37 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0S4Yxh7015607
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:43:37 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1s50eqxar6-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:43:37 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 8/8] mwifiex: support conversion to any virtual interface type
Date: Wed, 28 Jan 2015 15:42:05 +0530
Message-ID: <1422439925-25666-9-git-send-email-patila@marvell.com> (sfid-20150128_054342_634435_F0AE2463)
In-Reply-To: <1422439925-25666-1-git-send-email-patila@marvell.com>
References: <1422439925-25666-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, we support virtual interface type change from
station<=>adhoc or station <=> p2p client/GO.
This patch adds support to change virtual interface type to
any of the type advertised in interface combinations.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  | 331 ++++++++++++++++++++++++++++---
 drivers/net/wireless/mwifiex/main.c      |   2 +-
 drivers/net/wireless/mwifiex/main.h      |   2 -
 drivers/net/wireless/mwifiex/sta_ioctl.c |  30 ---
 4 files changed, 301 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index a0221b5..30ea94a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -656,9 +656,6 @@ mwifiex_cfg80211_deinit_p2p(struct mwifiex_private *priv)
 {
 	u16 mode = P2P_MODE_DISABLE;
 
-	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_STA)
-		mwifiex_set_bss_role(priv, MWIFIEX_BSS_ROLE_STA);
-
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_P2P_MODE_CFG,
 			     HostCmd_ACT_GEN_SET, 0, &mode, true))
 		return -1;
@@ -715,12 +712,249 @@ mwifiex_cfg80211_init_p2p_go(struct mwifiex_private *priv)
 			     HostCmd_ACT_GEN_SET, 0, &mode, true))
 		return -1;
 
-	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_UAP)
-		mwifiex_set_bss_role(priv, MWIFIEX_BSS_ROLE_UAP);
+	return 0;
+}
+
+static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
+{
+	priv->mgmt_frame_mask = 0;
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_MGMT_FRAME_REG,
+			     HostCmd_ACT_GEN_SET, 0,
+			     &priv->mgmt_frame_mask, false)) {
+		dev_warn(priv->adapter->dev,
+			 "could not unregister mgmt frame rx\n");
+		return -1;
+	}
+
+	mwifiex_deauthenticate(priv, NULL);
+	mwifiex_free_priv(priv);
+	priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
+	priv->sec_info.authentication_mode = NL80211_AUTHTYPE_OPEN_SYSTEM;
+
+	return 0;
+}
+
+static int
+mwifiex_init_new_priv_params(struct mwifiex_private *priv,
+			     struct net_device *dev,
+			     enum nl80211_iftype type)
+{
+	mwifiex_init_priv(priv);
+
+	priv->bss_mode = type;
+	priv->wdev.iftype = type;
+
+	mwifiex_init_priv_params(priv, priv->netdev);
+	priv->bss_started = 0;
+
+	switch (type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
+		priv->bss_type = MWIFIEX_BSS_TYPE_STA;
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
+		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
+		break;
+	case NL80211_IFTYPE_AP:
+		priv->bss_type = MWIFIEX_BSS_TYPE_UAP;
+		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
+		break;
+	default:
+		dev_err(priv->adapter->dev,
+			"%s: changing to %d not supported\n",
+			dev->name, type);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int
+mwifiex_change_vif_to_p2p(struct net_device *dev,
+			  enum nl80211_iftype curr_iftype,
+			  enum nl80211_iftype type, u32 *flags,
+			  struct vif_params *params)
+{
+	struct mwifiex_private *priv;
+	struct mwifiex_adapter *adapter;
+
+	priv = mwifiex_netdev_get_priv(dev);
+
+	if (!priv)
+		return -1;
+
+	adapter = priv->adapter;
+
+	if (adapter->curr_iface_comb.p2p_intf ==
+	    adapter->iface_limit.p2p_intf) {
+		dev_err(adapter->dev,
+			"cannot create multiple P2P ifaces\n");
+		return -1;
+	}
+
+	dev_dbg(priv->adapter->dev, "%s: changing role to p2p\n", dev->name);
+
+	if (mwifiex_deinit_priv_params(priv))
+		return -1;
+	if (mwifiex_init_new_priv_params(priv, dev, type))
+		return -1;
+
+	switch (type) {
+	case NL80211_IFTYPE_P2P_CLIENT:
+		if (mwifiex_cfg80211_init_p2p_client(priv))
+			return -EFAULT;
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		if (mwifiex_cfg80211_init_p2p_go(priv))
+			return -EFAULT;
+		break;
+	default:
+		dev_err(priv->adapter->dev,
+			"%s: changing to %d not supported\n",
+			dev->name, type);
+		return -EOPNOTSUPP;
+	}
+
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+			     HostCmd_ACT_GEN_SET, 0, NULL, true))
+		return -1;
+
+	if (mwifiex_sta_init_cmd(priv, false, false))
+		return -1;
+
+	switch (curr_iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+		adapter->curr_iface_comb.sta_intf--;
+		break;
+	case NL80211_IFTYPE_AP:
+		adapter->curr_iface_comb.uap_intf--;
+		break;
+	default:
+		break;
+	}
+
+	adapter->curr_iface_comb.p2p_intf++;
+	dev->ieee80211_ptr->iftype = type;
 
 	return 0;
 }
 
+static int
+mwifiex_change_vif_to_sta_adhoc(struct net_device *dev,
+				enum nl80211_iftype curr_iftype,
+				enum nl80211_iftype type, u32 *flags,
+				struct vif_params *params)
+{
+	struct mwifiex_private *priv;
+	struct mwifiex_adapter *adapter;
+
+	priv = mwifiex_netdev_get_priv(dev);
+
+	if (!priv)
+		return -1;
+
+	adapter = priv->adapter;
+
+	if ((curr_iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	     curr_iftype != NL80211_IFTYPE_P2P_GO) &&
+	    (adapter->curr_iface_comb.sta_intf ==
+	     adapter->iface_limit.sta_intf)) {
+		dev_err(adapter->dev,
+			"cannot create multiple station/adhoc ifaces\n");
+		return -1;
+	}
+
+	if (type == NL80211_IFTYPE_STATION)
+		dev_notice(adapter->dev,
+			   "%s: changing role to station\n", dev->name);
+	else
+		dev_notice(adapter->dev,
+			   "%s: changing role to adhoc\n", dev->name);
+
+	if (mwifiex_deinit_priv_params(priv))
+		return -1;
+	if (mwifiex_init_new_priv_params(priv, dev, type))
+		return -1;
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+			     HostCmd_ACT_GEN_SET, 0, NULL, true))
+		return -1;
+	if (mwifiex_sta_init_cmd(priv, false, false))
+		return -1;
+
+	switch (curr_iftype) {
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		adapter->curr_iface_comb.p2p_intf--;
+		break;
+	case NL80211_IFTYPE_AP:
+		adapter->curr_iface_comb.uap_intf--;
+		break;
+	default:
+		break;
+	}
+
+	adapter->curr_iface_comb.sta_intf++;
+	dev->ieee80211_ptr->iftype = type;
+	return 0;
+}
+
+static int
+mwifiex_change_vif_to_ap(struct net_device *dev,
+			 enum nl80211_iftype curr_iftype,
+			 enum nl80211_iftype type, u32 *flags,
+			 struct vif_params *params)
+{
+	struct mwifiex_private *priv;
+	struct mwifiex_adapter *adapter;
+
+	priv = mwifiex_netdev_get_priv(dev);
+
+	if (!priv)
+		return -1;
+
+	adapter = priv->adapter;
+
+	if (adapter->curr_iface_comb.uap_intf ==
+	    adapter->iface_limit.uap_intf) {
+		dev_err(adapter->dev,
+			"cannot create multiple AP ifaces\n");
+		return -1;
+	}
+
+	dev_notice(adapter->dev, "%s: changing role to AP\n", dev->name);
+
+	if (mwifiex_deinit_priv_params(priv))
+		return -1;
+	if (mwifiex_init_new_priv_params(priv, dev, type))
+		return -1;
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+			     HostCmd_ACT_GEN_SET, 0, NULL, true))
+		return -1;
+	if (mwifiex_sta_init_cmd(priv, false, false))
+		return -1;
+
+	switch (curr_iftype) {
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		adapter->curr_iface_comb.p2p_intf--;
+		break;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+		adapter->curr_iface_comb.sta_intf--;
+		break;
+	default:
+		break;
+	}
+
+	adapter->curr_iface_comb.uap_intf++;
+	dev->ieee80211_ptr->iftype = type;
+	return 0;
+}
 /*
  * CFG802.11 operation handler to change interface type.
  */
@@ -730,19 +964,32 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 				     enum nl80211_iftype type, u32 *flags,
 				     struct vif_params *params)
 {
-	int ret;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	enum nl80211_iftype curr_iftype = dev->ieee80211_ptr->iftype;
 
-	switch (dev->ieee80211_ptr->iftype) {
+	switch (curr_iftype) {
 	case NL80211_IFTYPE_ADHOC:
 		switch (type) {
 		case NL80211_IFTYPE_STATION:
-			break;
+			priv->bss_mode = type;
+			priv->sec_info.authentication_mode =
+						   NL80211_AUTHTYPE_OPEN_SYSTEM;
+			dev->ieee80211_ptr->iftype = type;
+			mwifiex_deauthenticate(priv, NULL);
+			return mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+						HostCmd_ACT_GEN_SET, 0, NULL,
+						true);
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
+			return mwifiex_change_vif_to_p2p(dev, curr_iftype,
+							 type, flags, params);
+		case NL80211_IFTYPE_AP:
+			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
+							flags, params);
 		case NL80211_IFTYPE_UNSPECIFIED:
 			wiphy_warn(wiphy, "%s: kept type as IBSS\n", dev->name);
 		case NL80211_IFTYPE_ADHOC:	/* This shouldn't happen */
 			return 0;
-		case NL80211_IFTYPE_AP:
 		default:
 			wiphy_err(wiphy, "%s: changing to %d not supported\n",
 				  dev->name, type);
@@ -752,22 +999,25 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 	case NL80211_IFTYPE_STATION:
 		switch (type) {
 		case NL80211_IFTYPE_ADHOC:
-			break;
-		case NL80211_IFTYPE_P2P_CLIENT:
-			if (mwifiex_cfg80211_init_p2p_client(priv))
-				return -EFAULT;
+			priv->bss_mode = type;
+			priv->sec_info.authentication_mode =
+						   NL80211_AUTHTYPE_OPEN_SYSTEM;
 			dev->ieee80211_ptr->iftype = type;
-			return 0;
+			mwifiex_deauthenticate(priv, NULL);
+			return mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+						HostCmd_ACT_GEN_SET, 0, NULL,
+						true);
+		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_P2P_GO:
-			if (mwifiex_cfg80211_init_p2p_go(priv))
-				return -EFAULT;
-			dev->ieee80211_ptr->iftype = type;
-			return 0;
+			return mwifiex_change_vif_to_p2p(dev, curr_iftype,
+							 type, flags, params);
+		case NL80211_IFTYPE_AP:
+			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
+							flags, params);
 		case NL80211_IFTYPE_UNSPECIFIED:
 			wiphy_warn(wiphy, "%s: kept type as STA\n", dev->name);
 		case NL80211_IFTYPE_STATION:	/* This shouldn't happen */
 			return 0;
-		case NL80211_IFTYPE_AP:
 		default:
 			wiphy_err(wiphy, "%s: changing to %d not supported\n",
 				  dev->name, type);
@@ -776,12 +1026,20 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		break;
 	case NL80211_IFTYPE_AP:
 		switch (type) {
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_STATION:
+			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
+							       type, flags,
+							       params);
+			break;
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
+			return mwifiex_change_vif_to_p2p(dev, curr_iftype,
+							 type, flags, params);
 		case NL80211_IFTYPE_UNSPECIFIED:
 			wiphy_warn(wiphy, "%s: kept type as AP\n", dev->name);
 		case NL80211_IFTYPE_AP:		/* This shouldn't happen */
 			return 0;
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_STATION:
 		default:
 			wiphy_err(wiphy, "%s: changing to %d not supported\n",
 				  dev->name, type);
@@ -792,11 +1050,30 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 	case NL80211_IFTYPE_P2P_GO:
 		switch (type) {
 		case NL80211_IFTYPE_STATION:
-			if (mwifiex_cfg80211_deinit_p2p(priv))
+			if (mwifiex_cfg80211_init_p2p_client(priv))
 				return -EFAULT;
 			dev->ieee80211_ptr->iftype = type;
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			if (mwifiex_cfg80211_deinit_p2p(priv))
+				return -EFAULT;
+			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
+							       type, flags,
+							       params);
+			break;
+		case NL80211_IFTYPE_AP:
+			if (mwifiex_cfg80211_deinit_p2p(priv))
+				return -EFAULT;
+			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
+							flags, params);
+		case NL80211_IFTYPE_UNSPECIFIED:
+			wiphy_warn(wiphy, "%s: kept type as P2P\n", dev->name);
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
 			return 0;
 		default:
+			wiphy_err(wiphy, "%s: changing to %d not supported\n",
+				  dev->name, type);
 			return -EOPNOTSUPP;
 		}
 		break;
@@ -806,16 +1083,8 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		return -EOPNOTSUPP;
 	}
 
-	dev->ieee80211_ptr->iftype = type;
-	priv->bss_mode = type;
-	mwifiex_deauthenticate(priv, NULL);
-
-	priv->sec_info.authentication_mode = NL80211_AUTHTYPE_OPEN_SYSTEM;
-
-	ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
-			       HostCmd_ACT_GEN_SET, 0, NULL, true);
 
-	return ret;
+	return 0;
 }
 
 static void
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index cb9cab2..30e5193 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -961,7 +961,7 @@ static const struct net_device_ops mwifiex_netdev_ops = {
  * In addition, the CFG80211 work queue is also created.
  */
 void mwifiex_init_priv_params(struct mwifiex_private *priv,
-						struct net_device *dev)
+			      struct net_device *dev)
 {
 	dev->netdev_ops = &mwifiex_netdev_ops;
 	dev->destructor = free_netdev;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 78304a7..9e839cd 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1261,8 +1261,6 @@ int mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
 			       struct ieee80211_channel *chan,
 			       unsigned int duration);
 
-int mwifiex_set_bss_role(struct mwifiex_private *priv, u8 bss_role);
-
 int mwifiex_get_stats_info(struct mwifiex_private *priv,
 			   struct mwifiex_ds_get_stats *log);
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 2faa517..0599e41 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1135,36 +1135,6 @@ mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
 	return roc_cfg.status;
 }
 
-int
-mwifiex_set_bss_role(struct mwifiex_private *priv, u8 bss_role)
-{
-	if (GET_BSS_ROLE(priv) == bss_role) {
-		dev_dbg(priv->adapter->dev,
-			"info: already in the desired role.\n");
-		return 0;
-	}
-
-	mwifiex_free_priv(priv);
-	mwifiex_init_priv(priv);
-
-	priv->bss_role = bss_role;
-	switch (bss_role) {
-	case MWIFIEX_BSS_ROLE_UAP:
-		priv->bss_mode = NL80211_IFTYPE_AP;
-		break;
-	case MWIFIEX_BSS_ROLE_STA:
-	case MWIFIEX_BSS_ROLE_ANY:
-	default:
-		priv->bss_mode = NL80211_IFTYPE_STATION;
-		break;
-	}
-
-	mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
-			 HostCmd_ACT_GEN_SET, 0, NULL, true);
-
-	return mwifiex_sta_init_cmd(priv, false, false);
-}
-
 /*
  * Sends IOCTL request to get statistics information.
  *
-- 
1.8.1.4

