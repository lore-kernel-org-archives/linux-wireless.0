Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:60037 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493Ab2IZDb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:31:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 11/15] mwifiex: add support for P2P client in interface type change
Date: Tue, 25 Sep 2012 20:23:41 -0700
Message-Id: <1348629825-12001-12-git-send-email-bzhao@marvell.com> (sfid-20120926_053129_581494_628CF4D8)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

When cfg80211 calls to change interface type for P2P client,
send P2P mode config commands to firmware.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |   54 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/fw.h          |   14 +++++++
 drivers/net/wireless/mwifiex/sta_cmd.c     |    8 ++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   19 ++++++++++
 4 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ece267a..4990603 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -674,6 +674,44 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	return 0;
 }
 
+static int
+mwifiex_cfg80211_deinit_p2p(struct mwifiex_private *priv)
+{
+	u16 mode = P2P_MODE_DISABLE;
+
+	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_P2P_MODE_CFG,
+				  HostCmd_ACT_GEN_SET, 0, &mode))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * This function initializes the functionalities for P2P client.
+ * The P2P client initialization sequence is:
+ * disable -> device -> client
+ */
+static int
+mwifiex_cfg80211_init_p2p_client(struct mwifiex_private *priv)
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
+	mode = P2P_MODE_CLIENT;
+	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_P2P_MODE_CFG,
+				  HostCmd_ACT_GEN_SET, 0, &mode))
+		return -1;
+
+	return 0;
+}
+
 /*
  * CFG802.11 operation handler to change interface type.
  */
@@ -706,6 +744,11 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		switch (type) {
 		case NL80211_IFTYPE_ADHOC:
 			break;
+		case NL80211_IFTYPE_P2P_CLIENT:
+			if (mwifiex_cfg80211_init_p2p_client(priv))
+				return -EFAULT;
+			dev->ieee80211_ptr->iftype = type;
+			return 0;
 		case NL80211_IFTYPE_UNSPECIFIED:
 			wiphy_warn(wiphy, "%s: kept type as STA\n", dev->name);
 		case NL80211_IFTYPE_STATION:	/* This shouldn't happen */
@@ -731,6 +774,17 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 			return -EOPNOTSUPP;
 		}
 		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		switch (type) {
+		case NL80211_IFTYPE_STATION:
+			if (mwifiex_cfg80211_deinit_p2p(priv))
+				return -EFAULT;
+			dev->ieee80211_ptr->iftype = type;
+			return 0;
+		default:
+			return -EOPNOTSUPP;
+		}
+		break;
 	default:
 		wiphy_err(wiphy, "%s: unknown iftype: %d\n",
 			  dev->name, dev->ieee80211_ptr->iftype);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index b8a07ad..7887848 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -261,6 +261,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_TX_RATE_CFG                       0x00d6
 #define HostCmd_CMD_802_11_PS_MODE_ENH                0x00e4
 #define HostCmd_CMD_802_11_HS_CFG_ENH                 0x00e5
+#define HostCmd_CMD_P2P_MODE_CFG                      0x00eb
 #define HostCmd_CMD_CAU_REG_ACCESS                    0x00ed
 #define HostCmd_CMD_SET_BSS_MODE                      0x00f7
 #define HostCmd_CMD_PCIE_DESC_DETAILS                 0x00fa
@@ -291,6 +292,13 @@ enum ENH_PS_MODES {
 	DIS_AUTO_PS = 0xfe,
 };
 
+enum P2P_MODES {
+	P2P_MODE_DISABLE = 0,
+	P2P_MODE_DEVICE = 1,
+	P2P_MODE_GO = 2,
+	P2P_MODE_CLIENT = 3,
+};
+
 #define HostCmd_RET_BIT                       0x8000
 #define HostCmd_ACT_GEN_GET                   0x0000
 #define HostCmd_ACT_GEN_SET                   0x0001
@@ -1346,6 +1354,11 @@ struct host_cmd_ds_mgmt_frame_reg {
 	__le32 mask;
 } __packed;
 
+struct host_cmd_ds_p2p_mode_cfg {
+	__le16 action;
+	__le16 mode;
+} __packed;
+
 struct host_cmd_ds_remain_on_chan {
 	__le16 action;
 	u8 status;
@@ -1465,6 +1478,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_version_ext verext;
 		struct host_cmd_ds_mgmt_frame_reg reg_mask;
 		struct host_cmd_ds_remain_on_chan roc_cfg;
+		struct host_cmd_ds_p2p_mode_cfg mode_cfg;
 		struct host_cmd_ds_802_11_ibss_status ibss_coalescing;
 		struct host_cmd_ds_mac_reg_access mac_reg;
 		struct host_cmd_ds_bbp_reg_access bbp_reg;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index c2198a7..704cfaa 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1184,6 +1184,14 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		      cpu_to_le16(sizeof(struct host_cmd_ds_remain_on_chan) +
 				  S_DS_GEN);
 		break;
+	case HostCmd_CMD_P2P_MODE_CFG:
+		cmd_ptr->command = cpu_to_le16(cmd_no);
+		cmd_ptr->params.mode_cfg.action = cpu_to_le16(cmd_action);
+		cmd_ptr->params.mode_cfg.mode = cpu_to_le16(*(u16 *)data_buf);
+		cmd_ptr->size =
+			cpu_to_le16(sizeof(struct host_cmd_ds_p2p_mode_cfg) +
+				    S_DS_GEN);
+		break;
 	case HostCmd_CMD_FUNC_INIT:
 		if (priv->adapter->hw_status == MWIFIEX_HW_STATUS_RESET)
 			priv->adapter->hw_status = MWIFIEX_HW_STATUS_READY;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 621d36e..e380171 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -670,6 +670,22 @@ mwifiex_ret_remain_on_chan(struct mwifiex_private *priv,
 }
 
 /*
+ * This function handles the command response of P2P mode cfg.
+ */
+static int
+mwifiex_ret_p2p_mode_cfg(struct mwifiex_private *priv,
+			 struct host_cmd_ds_command *resp,
+			 void *data_buf)
+{
+	struct host_cmd_ds_p2p_mode_cfg *mode_cfg = &resp->params.mode_cfg;
+
+	if (data_buf)
+		*((u16 *)data_buf) = le16_to_cpu(mode_cfg->mode);
+
+	return 0;
+}
+
+/*
  * This function handles the command response of register access.
  *
  * The register value and offset are returned to the user. For EEPROM
@@ -894,6 +910,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_REMAIN_ON_CHAN:
 		ret = mwifiex_ret_remain_on_chan(priv, resp, data_buf);
 		break;
+	case HostCmd_CMD_P2P_MODE_CFG:
+		ret = mwifiex_ret_p2p_mode_cfg(priv, resp, data_buf);
+		break;
 	case HostCmd_CMD_MGMT_FRAME_REG:
 	case HostCmd_CMD_FUNC_INIT:
 	case HostCmd_CMD_FUNC_SHUTDOWN:
-- 
1.7.0.2

