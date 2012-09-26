Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:39592 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777Ab2IZD27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:28:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 04/15] mwifiex: implement cfg80211 mgmt_frame_register handler
Date: Tue, 25 Sep 2012 20:23:34 -0700
Message-Id: <1348629825-12001-5-git-send-email-bzhao@marvell.com> (sfid-20120926_052901_866723_53F14D5D)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Add a new command to implement mgmt_frame_register.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |   22 ++++++++++++++++++++++
 drivers/net/wireless/mwifiex/fw.h          |    7 +++++++
 drivers/net/wireless/mwifiex/main.h        |    1 +
 drivers/net/wireless/mwifiex/sta_cmd.c     |    9 +++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    1 +
 5 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 2befac5..f86043d 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -227,6 +227,27 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 
 /*
+ * CFG802.11 operation handler to register a mgmt frame.
+ */
+static void
+mwifiex_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
+				     struct wireless_dev *wdev,
+				     u16 frame_type, bool reg)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
+
+	if (reg)
+		priv->mgmt_frame_mask |= BIT(frame_type >> 4);
+	else
+		priv->mgmt_frame_mask &= ~BIT(frame_type >> 4);
+
+	mwifiex_send_cmd_async(priv, HostCmd_CMD_MGMT_FRAME_REG,
+			       HostCmd_ACT_GEN_SET, 0, &priv->mgmt_frame_mask);
+
+	wiphy_dbg(wiphy, "info: mgmt frame registered\n");
+}
+
+/*
  * CFG802.11 operation handler to set Tx power.
  */
 static int
@@ -1928,6 +1949,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.add_key = mwifiex_cfg80211_add_key,
 	.del_key = mwifiex_cfg80211_del_key,
 	.mgmt_tx = mwifiex_cfg80211_mgmt_tx,
+	.mgmt_frame_register = mwifiex_cfg80211_mgmt_frame_register,
 	.set_default_key = mwifiex_cfg80211_set_default_key,
 	.set_power_mgmt = mwifiex_cfg80211_set_power_mgmt,
 	.set_tx_power = mwifiex_cfg80211_set_tx_power,
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index b8ce78e..41b304a 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -263,6 +263,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_CAU_REG_ACCESS                    0x00ed
 #define HostCmd_CMD_SET_BSS_MODE                      0x00f7
 #define HostCmd_CMD_PCIE_DESC_DETAILS                 0x00fa
+#define HostCmd_CMD_MGMT_FRAME_REG                    0x010c
 
 #define PROTOCOL_NO_SECURITY        0x01
 #define PROTOCOL_STATIC_WEP         0x02
@@ -1336,6 +1337,11 @@ struct host_cmd_ds_version_ext {
 	char version_str[128];
 } __packed;
 
+struct host_cmd_ds_mgmt_frame_reg {
+	__le16 action;
+	__le32 mask;
+} __packed;
+
 struct host_cmd_ds_802_11_ibss_status {
 	__le16 action;
 	__le16 enable;
@@ -1444,6 +1450,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_wmm_get_status get_wmm_status;
 		struct host_cmd_ds_802_11_key_material key_material;
 		struct host_cmd_ds_version_ext verext;
+		struct host_cmd_ds_mgmt_frame_reg reg_mask;
 		struct host_cmd_ds_802_11_ibss_status ibss_coalescing;
 		struct host_cmd_ds_mac_reg_access mac_reg;
 		struct host_cmd_ds_bbp_reg_access bbp_reg;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 092fbfa..6e08062 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -496,6 +496,7 @@ struct mwifiex_private {
 	u16 rsn_idx;
 	struct timer_list scan_delay_timer;
 	u8 ap_11n_enabled;
+	u32 mgmt_frame_mask;
 };
 
 enum mwifiex_ba_status {
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 3a4161c..dc4fe8c 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1167,6 +1167,15 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 				    S_DS_GEN);
 		ret = 0;
 		break;
+	case HostCmd_CMD_MGMT_FRAME_REG:
+		cmd_ptr->command = cpu_to_le16(cmd_no);
+		cmd_ptr->params.reg_mask.action = cpu_to_le16(cmd_action);
+		cmd_ptr->params.reg_mask.mask = cpu_to_le32(*(u32 *)data_buf);
+		cmd_ptr->size =
+			cpu_to_le16(sizeof(struct host_cmd_ds_mgmt_frame_reg) +
+				    S_DS_GEN);
+		ret = 0;
+		break;
 	case HostCmd_CMD_FUNC_INIT:
 		if (priv->adapter->hw_status == MWIFIEX_HW_STATUS_RESET)
 			priv->adapter->hw_status = MWIFIEX_HW_STATUS_READY;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 31f80e1..d1f53e3 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -875,6 +875,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_VERSION_EXT:
 		ret = mwifiex_ret_ver_ext(priv, resp, data_buf);
 		break;
+	case HostCmd_CMD_MGMT_FRAME_REG:
 	case HostCmd_CMD_FUNC_INIT:
 	case HostCmd_CMD_FUNC_SHUTDOWN:
 		break;
-- 
1.7.0.2

