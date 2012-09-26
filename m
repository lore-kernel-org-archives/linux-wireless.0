Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33594 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420Ab2IZDb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:31:27 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 12/15] mwifiex: add support for P2P GO in interface type change
Date: Tue, 25 Sep 2012 20:23:42 -0700
Message-Id: <1348629825-12001-13-git-send-email-bzhao@marvell.com> (sfid-20120926_053130_553618_6C13D8CA)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

When cfg80211 calls to change interface type for P2P GO, send
P2P mode config commands to firmware and set bss role and bss
mode accordingly.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   42 ++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/fw.h        |    1 +
 drivers/net/wireless/mwifiex/init.c      |   13 ++++++++-
 drivers/net/wireless/mwifiex/main.h      |    5 +++
 drivers/net/wireless/mwifiex/sta_cmd.c   |    2 +
 drivers/net/wireless/mwifiex/sta_ioctl.c |   30 +++++++++++++++++++++
 6 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4990603..94ac40c 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -679,6 +679,9 @@ mwifiex_cfg80211_deinit_p2p(struct mwifiex_private *priv)
 {
 	u16 mode = P2P_MODE_DISABLE;
 
+	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_STA)
+		mwifiex_set_bss_role(priv, MWIFIEX_BSS_ROLE_STA);
+
 	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_P2P_MODE_CFG,
 				  HostCmd_ACT_GEN_SET, 0, &mode))
 		return -1;
@@ -713,6 +716,35 @@ mwifiex_cfg80211_init_p2p_client(struct mwifiex_private *priv)
 }
 
 /*
+ * This function initializes the functionalities for P2P GO.
+ * The P2P GO initialization sequence is:
+ * disable -> device -> GO
+ */
+static int
+mwifiex_cfg80211_init_p2p_go(struct mwifiex_private *priv)
+{
+	u16 mode;
+
+	if (mwifiex_cfg80211_deinit_p2p(priv))
+		return -1;
+
+	mode = P2P_MODE_DEVICE;
+	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_P2P_MODE_CFG,
+				  HostCmd_ACT_GEN_SET, 0, &mode))
+		return -1;
+
+	mode = P2P_MODE_GO;
+	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_P2P_MODE_CFG,
+				  HostCmd_ACT_GEN_SET, 0, &mode))
+		return -1;
+
+	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_UAP)
+		mwifiex_set_bss_role(priv, MWIFIEX_BSS_ROLE_UAP);
+
+	return 0;
+}
+
+/*
  * CFG802.11 operation handler to change interface type.
  */
 static int
@@ -749,6 +781,11 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 				return -EFAULT;
 			dev->ieee80211_ptr->iftype = type;
 			return 0;
+		case NL80211_IFTYPE_P2P_GO:
+			if (mwifiex_cfg80211_init_p2p_go(priv))
+				return -EFAULT;
+			dev->ieee80211_ptr->iftype = type;
+			return 0;
 		case NL80211_IFTYPE_UNSPECIFIED:
 			wiphy_warn(wiphy, "%s: kept type as STA\n", dev->name);
 		case NL80211_IFTYPE_STATION:	/* This shouldn't happen */
@@ -775,6 +812,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		}
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
 		switch (type) {
 		case NL80211_IFTYPE_STATION:
 			if (mwifiex_cfg80211_deinit_p2p(priv))
@@ -1135,7 +1173,7 @@ static int mwifiex_cfg80211_change_beacon(struct wiphy *wiphy,
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
-	if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
+	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_UAP) {
 		wiphy_err(wiphy, "%s: bss_type mismatched\n", __func__);
 		return -EINVAL;
 	}
@@ -1223,7 +1261,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	u8 config_bands = 0;
 
-	if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP)
+	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_UAP)
 		return -1;
 	if (mwifiex_set_mgmt_ies(priv, &params->beacon))
 		return -1;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 7887848..857af0f 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1379,6 +1379,7 @@ struct host_cmd_ds_802_11_ibss_status {
 
 #define CONNECTION_TYPE_INFRA   0
 #define CONNECTION_TYPE_ADHOC   1
+#define CONNECTION_TYPE_AP      2
 
 struct host_cmd_ds_set_bss_mode {
 	u8 con_type;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index fa96dc3..b5d37a8 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -144,7 +144,7 @@ done:
  * Additionally, it also initializes all the locks and sets up all the
  * lists.
  */
-static int mwifiex_init_priv(struct mwifiex_private *priv)
+int mwifiex_init_priv(struct mwifiex_private *priv)
 {
 	u32 i;
 
@@ -649,6 +649,17 @@ static void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 }
 
 /*
+ * This function frees the private structure, including cleans
+ * up the TX and RX queues and frees the BSS priority tables.
+ */
+void mwifiex_free_priv(struct mwifiex_private *priv)
+{
+	mwifiex_clean_txrx(priv);
+	mwifiex_delete_bss_prio_tbl(priv);
+	mwifiex_free_curr_bcn(priv);
+}
+
+/*
  * This function is used to shutdown the driver.
  *
  * The following operations are performed sequentially -
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 89ba66e..956312f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -736,6 +736,9 @@ void mwifiex_stop_net_dev_queue(struct net_device *netdev,
 void mwifiex_wake_up_net_dev_queue(struct net_device *netdev,
 		struct mwifiex_adapter *adapter);
 
+int mwifiex_init_priv(struct mwifiex_private *priv);
+void mwifiex_free_priv(struct mwifiex_private *priv);
+
 int mwifiex_init_fw(struct mwifiex_adapter *adapter);
 
 int mwifiex_init_fw_complete(struct mwifiex_adapter *adapter);
@@ -1018,6 +1021,8 @@ int mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
 			       enum nl80211_channel_type *channel_type,
 			       unsigned int duration);
 
+int mwifiex_set_bss_role(struct mwifiex_private *priv, u8 bss_role);
+
 int mwifiex_get_stats_info(struct mwifiex_private *priv,
 			   struct mwifiex_ds_get_stats *log);
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 704cfaa..5d87195 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1261,6 +1261,8 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		else if (priv->bss_mode == NL80211_IFTYPE_STATION)
 			cmd_ptr->params.bss_mode.con_type =
 				CONNECTION_TYPE_INFRA;
+		else if (priv->bss_mode == NL80211_IFTYPE_AP)
+			cmd_ptr->params.bss_mode.con_type = CONNECTION_TYPE_AP;
 		cmd_ptr->size = cpu_to_le16(sizeof(struct
 				host_cmd_ds_set_bss_mode) + S_DS_GEN);
 		ret = 0;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index fd09a21..0c9f70b 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1072,6 +1072,36 @@ mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
 	return roc_cfg.status;
 }
 
+int
+mwifiex_set_bss_role(struct mwifiex_private *priv, u8 bss_role)
+{
+	if (GET_BSS_ROLE(priv) == bss_role) {
+		dev_dbg(priv->adapter->dev,
+			"info: already in the desired role.\n");
+		return 0;
+	}
+
+	mwifiex_free_priv(priv);
+	mwifiex_init_priv(priv);
+
+	priv->bss_role = bss_role;
+	switch (bss_role) {
+	case MWIFIEX_BSS_ROLE_UAP:
+		priv->bss_mode = NL80211_IFTYPE_AP;
+		break;
+	case MWIFIEX_BSS_ROLE_STA:
+	case MWIFIEX_BSS_ROLE_ANY:
+	default:
+		priv->bss_mode = NL80211_IFTYPE_STATION;
+		break;
+	}
+
+	mwifiex_send_cmd_sync(priv, HostCmd_CMD_SET_BSS_MODE,
+			      HostCmd_ACT_GEN_SET, 0, NULL);
+
+	return mwifiex_sta_init_cmd(priv, false);
+}
+
 /*
  * Sends IOCTL request to get statistics information.
  *
-- 
1.7.0.2

