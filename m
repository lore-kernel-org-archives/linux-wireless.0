Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:50022 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754528Ab2ECHXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:23:40 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	harvey yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 08/18] mwifiex: add AP command sys_config and set channel
Date: Thu,  3 May 2012 00:22:30 -0700
Message-Id: <1336029760-22565-9-git-send-email-bzhao@marvell.com> (sfid-20120503_092343_042228_F9064DD5)
In-Reply-To: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

1. support for AP sys_config command and added parsing of channel
information.
2. support for setting AP channel from cfg80211 set_channel handler

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    5 ++-
 drivers/net/wireless/mwifiex/fw.h       |   12 ++++++
 drivers/net/wireless/mwifiex/ioctl.h    |    6 +++
 drivers/net/wireless/mwifiex/main.h     |    1 +
 drivers/net/wireless/mwifiex/uap_cmd.c  |   67 +++++++++++++++++++++++++++++++
 5 files changed, 90 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 8f3d4e3..38ece48 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -387,7 +387,10 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 	if (mwifiex_bss_set_channel(priv, &cfp))
 		return -EFAULT;
 
-	return mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
+	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA)
+		return mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
+	else
+		return mwifiex_uap_set_channel(priv, cfp.channel);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 5caa826..a3e9c28 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1112,11 +1112,22 @@ struct host_cmd_tlv {
 	__le16 len;
 } __packed;
 
+struct host_cmd_ds_sys_config {
+	__le16 action;
+	u8 tlv[0];
+};
+
 struct host_cmd_tlv_mac_addr {
 	struct host_cmd_tlv tlv;
 	u8 mac_addr[ETH_ALEN];
 } __packed;
 
+struct host_cmd_tlv_channel_band {
+	struct host_cmd_tlv tlv;
+	u8 band_config;
+	u8 channel;
+} __packed;
+
 struct host_cmd_ds_802_11_rf_channel {
 	__le16 action;
 	__le16 current_channel;
@@ -1231,6 +1242,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_pcie_details pcie_host_spec;
 		struct host_cmd_ds_802_11_eeprom_access eeprom;
 		struct host_cmd_ds_802_11_subsc_evt subsc_evt;
+		struct host_cmd_ds_sys_config uap_sys_config;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index f0f9552..50e9b77 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -62,6 +62,12 @@ enum {
 	BAND_AN = 16,
 };
 
+#define BAND_CONFIG_MANUAL      0x00
+struct mwifiex_uap_bss_param {
+	u8 channel;
+	u8 band_cfg;
+};
+
 enum {
 	ADHOC_IDLE,
 	ADHOC_STARTED,
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 24db86f..014a13f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -975,6 +975,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 
 int mwifiex_main_process(struct mwifiex_adapter *);
 
+int mwifiex_uap_set_channel(struct mwifiex_private *priv, int channel);
 int mwifiex_bss_set_channel(struct mwifiex_private *,
 			    struct mwifiex_chan_freq_power *cfp);
 int mwifiex_get_bss_info(struct mwifiex_private *,
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 74187b2..a3e57d3 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -19,6 +19,41 @@
 
 #include "main.h"
 
+/* Parse AP config structure and prepare TLV based command structure
+ * to be sent to FW for uAP configuration
+ */
+static int mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd,
+				      u16 cmd_action, void *cmd_buf)
+{
+	u8 *tlv;
+	struct host_cmd_ds_sys_config *sys_config = &cmd->params.uap_sys_config;
+	struct host_cmd_tlv_channel_band *chan_band;
+	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
+	u16 cmd_size;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_UAP_SYS_CONFIG);
+	cmd_size = ((u16)(sizeof(struct host_cmd_ds_sys_config) + S_DS_GEN));
+
+	sys_config->action = cpu_to_le16(cmd_action);
+
+	tlv = sys_config->tlv;
+
+	if (bss_cfg->channel && bss_cfg->channel <= MAX_CHANNEL_BAND_BG) {
+		chan_band = (struct host_cmd_tlv_channel_band *)tlv;
+		chan_band->tlv.type = cpu_to_le16(TLV_TYPE_CHANNELBANDLIST);
+		chan_band->tlv.len =
+			cpu_to_le16(sizeof(struct host_cmd_tlv_channel_band) -
+				    sizeof(struct host_cmd_tlv));
+		chan_band->band_config = bss_cfg->band_cfg;
+		chan_band->channel = bss_cfg->channel;
+		cmd_size += sizeof(struct host_cmd_tlv_channel_band);
+		tlv += sizeof(struct host_cmd_tlv_channel_band);
+	}
+
+	cmd->size = cpu_to_le16(cmd_size);
+	return 0;
+}
+
 /* This function prepares the AP specific commands before sending them
  * to the firmware.
  * This is a generic function which calls specific command preparation
@@ -31,6 +66,10 @@ int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
 	struct host_cmd_ds_command *cmd = cmd_buf;
 
 	switch (cmd_no) {
+	case HostCmd_CMD_UAP_SYS_CONFIG:
+		if (mwifiex_cmd_uap_sys_config(cmd, cmd_action, data_buf))
+			return -1;
+		break;
 	case HostCmd_CMD_UAP_BSS_START:
 	case HostCmd_CMD_UAP_BSS_STOP:
 		cmd->command = cpu_to_le16(cmd_no);
@@ -44,3 +83,31 @@ int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
 
 	return 0;
 }
+
+/* This function sets the RF channel for AP.
+ *
+ * This function populates channel information in AP config structure
+ * and sends command to configure channel information in AP.
+ */
+int mwifiex_uap_set_channel(struct mwifiex_private *priv, int channel)
+{
+	struct mwifiex_uap_bss_param *bss_cfg;
+	struct wiphy *wiphy = priv->wdev->wiphy;
+
+	bss_cfg = kzalloc(sizeof(struct mwifiex_uap_bss_param), GFP_KERNEL);
+	if (!bss_cfg)
+		return -ENOMEM;
+
+	bss_cfg->band_cfg = BAND_CONFIG_MANUAL;
+	bss_cfg->channel = channel;
+
+	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_UAP_SYS_CONFIG,
+				   HostCmd_ACT_GEN_SET, 0, bss_cfg)) {
+		wiphy_err(wiphy, "Failed to set the uAP channel\n");
+		kfree(bss_cfg);
+		return -1;
+	}
+
+	kfree(bss_cfg);
+	return 0;
+}
-- 
1.7.0.2

