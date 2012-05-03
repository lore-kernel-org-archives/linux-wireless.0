Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:37158 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755408Ab2ECHX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:23:56 -0400
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
Subject: [PATCH 15/18] mwifiex: rearrange AP sys configure code
Date: Thu,  3 May 2012 00:22:37 -0700
Message-Id: <1336029760-22565-16-git-send-email-bzhao@marvell.com> (sfid-20120503_092413_119262_8E5FFCBB)
In-Reply-To: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch takes into account AP config_type
(bss config/custom ie config) while preparing AP
sys_configure command buffer.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    5 +-
 drivers/net/wireless/mwifiex/fw.h       |    2 +
 drivers/net/wireless/mwifiex/uap_cmd.c  |   62 +++++++++++++++++++++---------
 3 files changed, 48 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index da9d975..1077e01 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -502,7 +502,7 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 			ret = mwifiex_send_cmd_async(priv,
 						     HostCmd_CMD_UAP_SYS_CONFIG,
 						     HostCmd_ACT_GEN_SET,
-						     0, bss_cfg);
+						     UAP_BSS_PARAMS_I, bss_cfg);
 
 			kfree(bss_cfg);
 
@@ -983,7 +983,8 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	}
 
 	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_UAP_SYS_CONFIG,
-				   HostCmd_ACT_GEN_SET, 0, bss_cfg)) {
+				   HostCmd_ACT_GEN_SET,
+				   UAP_BSS_PARAMS_I, bss_cfg)) {
 		wiphy_err(wiphy, "Failed to set the SSID\n");
 		kfree(bss_cfg);
 		return -1;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 57fd0ca..4fd7a05 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -93,6 +93,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define CAL_SNR(RSSI, NF)		((s16)((s16)(RSSI)-(s16)(NF)))
 
+#define UAP_BSS_PARAMS_I			0
+
 #define TLV_TYPE_UAP_SSID			0x0000
 
 #define PROPRIETARY_TLV_BASE_ID                 0x0100
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 11118eb..4890f5f 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -123,14 +123,12 @@ void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config)
 	config->retry_limit = 0x7F;
 }
 
-/* Parse AP config structure and prepare TLV based command structure
- * to be sent to FW for uAP configuration
- */
-static int mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd,
-				      u16 cmd_action, void *cmd_buf)
+/* This function parses BSS related parameters from structure
+ * and prepares TLVs. These TLVs are appended to command buffer.
+*/
+static int
+mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 {
-	u8 *tlv;
-	struct host_cmd_ds_sys_config *sys_config = &cmd->params.uap_sys_config;
 	struct host_cmd_tlv_dtim_period *dtim_period;
 	struct host_cmd_tlv_beacon_period *beacon_period;
 	struct host_cmd_tlv_ssid *ssid;
@@ -145,14 +143,7 @@ static int mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd,
 	struct host_cmd_tlv_passphrase *passphrase;
 	struct host_cmd_tlv_akmp *tlv_akmp;
 	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
-	u16 cmd_size;
-
-	cmd->command = cpu_to_le16(HostCmd_CMD_UAP_SYS_CONFIG);
-	cmd_size = ((u16)(sizeof(struct host_cmd_ds_sys_config) + S_DS_GEN));
-
-	sys_config->action = cpu_to_le16(cmd_action);
-
-	tlv = sys_config->tlv;
+	u16 cmd_size = *param_size;
 
 	if (bss_cfg->ssid.ssid_len) {
 		ssid = (struct host_cmd_tlv_ssid *)tlv;
@@ -319,7 +310,39 @@ static int mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd,
 		tlv += sizeof(struct host_cmd_tlv_encrypt_protocol);
 	}
 
-	cmd->size = cpu_to_le16(cmd_size);
+	*param_size = cmd_size;
+
+	return 0;
+}
+
+/* Parse AP config structure and prepare TLV based command structure
+ * to be sent to FW for uAP configuration
+ */
+static int
+mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd, u16 cmd_action,
+			   u32 type, void *cmd_buf)
+{
+	u8 *tlv;
+	u16 cmd_size, param_size;
+	struct host_cmd_ds_sys_config *sys_cfg;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_UAP_SYS_CONFIG);
+	cmd_size = (u16)(sizeof(struct host_cmd_ds_sys_config) + S_DS_GEN);
+	sys_cfg = (struct host_cmd_ds_sys_config *)&cmd->params.uap_sys_config;
+	sys_cfg->action = cpu_to_le16(cmd_action);
+	tlv = sys_cfg->tlv;
+
+	switch (type) {
+	case UAP_BSS_PARAMS_I:
+		param_size = cmd_size;
+		if (mwifiex_uap_bss_param_prepare(tlv, cmd_buf, &param_size))
+			return -1;
+		cmd->size = cpu_to_le16(param_size);
+		break;
+	default:
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -329,14 +352,14 @@ static int mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd,
  * routines based upon the command number.
  */
 int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
-			    u16 cmd_action, u32 cmd_oid,
+			    u16 cmd_action, u32 type,
 			    void *data_buf, void *cmd_buf)
 {
 	struct host_cmd_ds_command *cmd = cmd_buf;
 
 	switch (cmd_no) {
 	case HostCmd_CMD_UAP_SYS_CONFIG:
-		if (mwifiex_cmd_uap_sys_config(cmd, cmd_action, data_buf))
+		if (mwifiex_cmd_uap_sys_config(cmd, cmd_action, type, data_buf))
 			return -1;
 		break;
 	case HostCmd_CMD_UAP_BSS_START:
@@ -371,7 +394,8 @@ int mwifiex_uap_set_channel(struct mwifiex_private *priv, int channel)
 	bss_cfg->channel = channel;
 
 	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_UAP_SYS_CONFIG,
-				   HostCmd_ACT_GEN_SET, 0, bss_cfg)) {
+				   HostCmd_ACT_GEN_SET,
+				   UAP_BSS_PARAMS_I, bss_cfg)) {
 		wiphy_err(wiphy, "Failed to set the uAP channel\n");
 		kfree(bss_cfg);
 		return -1;
-- 
1.7.0.2

