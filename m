Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22882 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbaBHAax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:30:53 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 20/30] mwifiex: add cfg80211 add_station handler support
Date: Fri, 7 Feb 2014 16:30:33 -0800
Message-ID: <1391819442-21239-1-git-send-email-bzhao@marvell.com> (sfid-20140208_020006_838073_290767B2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds cfg80211 add_station handler support for mwifiex
which is needed for TDLS setup. Driver issues create TDLS link
command to FW upon receiving add_station from cfg80211.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    | 18 ++++++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmd.c     |  3 +++
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 15 +++++++++++++++
 drivers/net/wireless/mwifiex/tdls.c        | 28 ++++++++++++++++++++++++++++
 4 files changed, 64 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4b52842..a29606a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2715,6 +2715,23 @@ mwifiex_cfg80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	return mwifiex_tdls_oper(priv, peer, action);
 }
 
+static int
+mwifiex_cfg80211_add_station(struct wiphy *wiphy,
+			     struct net_device *dev,
+			     u8 *mac, struct station_parameters *params)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	if (!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)))
+		return -ENOTSUPP;
+
+	/* make sure we are in station mode and connected */
+	if ((priv->bss_type != MWIFIEX_BSS_TYPE_STA) || !priv->media_connected)
+		return -ENOTSUPP;
+
+	return mwifiex_tdls_oper(priv, mac, MWIFIEX_TDLS_CREATE_LINK);
+}
+
 /* station cfg80211 operations */
 static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.add_virtual_intf = mwifiex_add_virtual_intf,
@@ -2752,6 +2769,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.set_coalesce = mwifiex_cfg80211_set_coalesce,
 	.tdls_mgmt = mwifiex_cfg80211_tdls_mgmt,
 	.tdls_oper = mwifiex_cfg80211_tdls_oper,
+	.add_station = mwifiex_cfg80211_add_station,
 };
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 4559f84..1e36fa7 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1300,6 +1300,9 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 	case MWIFIEX_TDLS_DISABLE_LINK:
 		tdls_oper->tdls_action = cpu_to_le16(ACT_TDLS_DELETE);
 		break;
+	case MWIFIEX_TDLS_CREATE_LINK:
+		tdls_oper->tdls_action = cpu_to_le16(ACT_TDLS_CREATE);
+		break;
 	default:
 		dev_err(priv->adapter->dev, "Unknown TDLS operation\n");
 		return -ENOTSUPP;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index cb17f49..396b936 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -807,6 +807,8 @@ static int mwifiex_ret_tdls_oper(struct mwifiex_private *priv,
 	struct host_cmd_ds_tdls_oper *cmd_tdls_oper = &resp->params.tdls_oper;
 	u16 reason = le16_to_cpu(cmd_tdls_oper->reason);
 	u16 action = le16_to_cpu(cmd_tdls_oper->tdls_action);
+	struct mwifiex_sta_node *node =
+			   mwifiex_get_sta_entry(priv, cmd_tdls_oper->peer_mac);
 
 	switch (action) {
 	case ACT_TDLS_DELETE:
@@ -819,6 +821,19 @@ static int mwifiex_ret_tdls_oper(struct mwifiex_private *priv,
 				"TDLS link config for %pM successful\n",
 				cmd_tdls_oper->peer_mac);
 		break;
+	case ACT_TDLS_CREATE:
+		if (reason) {
+			dev_err(priv->adapter->dev,
+				"TDLS link creation for %pM failed: reason %d",
+				cmd_tdls_oper->peer_mac, reason);
+			if (node && reason != TDLS_ERR_LINK_EXISTS)
+				node->tdls_status = TDLS_SETUP_FAILURE;
+		} else {
+			dev_dbg(priv->adapter->dev,
+				"TDLS link creation for %pM successful",
+				cmd_tdls_oper->peer_mac);
+		}
+		break;
 	default:
 		dev_err(priv->adapter->dev,
 			"Unknown TDLS command action respnse %d", action);
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 7fead7b..1d5ed70 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -544,6 +544,32 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 }
 
 static int
+mwifiex_tdls_process_create_link(struct mwifiex_private *priv, u8 *peer)
+{
+	struct mwifiex_sta_node *sta_ptr;
+	struct mwifiex_ds_tdls_oper tdls_oper;
+
+	memset(&tdls_oper, 0, sizeof(struct mwifiex_ds_tdls_oper));
+	sta_ptr = mwifiex_get_sta_entry(priv, peer);
+
+	if (sta_ptr && sta_ptr->tdls_status == TDLS_SETUP_INPROGRESS) {
+		dev_dbg(priv->adapter->dev,
+			"Setup already in progress for peer %pM\n", peer);
+		return 0;
+	}
+
+	sta_ptr = mwifiex_add_sta_entry(priv, peer);
+	if (!sta_ptr)
+		return -ENOMEM;
+
+	sta_ptr->tdls_status = TDLS_SETUP_INPROGRESS;
+	memcpy(&tdls_oper.peer_mac, peer, ETH_ALEN);
+	tdls_oper.tdls_action = MWIFIEX_TDLS_CREATE_LINK;
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_TDLS_OPER,
+				     HostCmd_ACT_GEN_SET, 0, &tdls_oper);
+}
+
+static int
 mwifiex_tdls_process_disable_link(struct mwifiex_private *priv, u8 *peer)
 {
 	struct mwifiex_sta_node *sta_ptr;
@@ -634,6 +660,8 @@ int mwifiex_tdls_oper(struct mwifiex_private *priv, u8 *peer, u8 action)
 		return mwifiex_tdls_process_enable_link(priv, peer);
 	case MWIFIEX_TDLS_DISABLE_LINK:
 		return mwifiex_tdls_process_disable_link(priv, peer);
+	case MWIFIEX_TDLS_CREATE_LINK:
+		return mwifiex_tdls_process_create_link(priv, peer);
 	}
 	return 0;
 }
-- 
1.8.2.3

