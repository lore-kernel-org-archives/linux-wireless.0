Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:47577 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033Ab3CSDGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 23:06:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: add support to configure VHT for AP mode
Date: Mon, 18 Mar 2013 20:06:03 -0700
Message-ID: <1363662363-3237-1-git-send-email-bzhao@marvell.com> (sfid-20130319_040617_366037_DB4EA389)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Currently, default VHT configuration from the firmware is used
for the VHT operations. Adding vhtcfg command to configure the
firmware based on input received from cfg.

Enable VHT for AP mode only when cfg80211_ap_settings has a
VHT IE i.e., when ieee80211ac is set to 1 in the hostapd.conf.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11ac.c        |   19 ++++++++++
 drivers/net/wireless/mwifiex/11ac.h        |   17 +++++++++
 drivers/net/wireless/mwifiex/cfg80211.c    |    7 ++++
 drivers/net/wireless/mwifiex/fw.h          |   11 ++++++
 drivers/net/wireless/mwifiex/ioctl.h       |    8 ++++
 drivers/net/wireless/mwifiex/main.h        |    6 +++
 drivers/net/wireless/mwifiex/sta_cmd.c     |    4 ++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    2 +
 drivers/net/wireless/mwifiex/uap_cmd.c     |   55 ++++++++++++++++++++++++++++
 9 files changed, 129 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
index cf43b3c..de0a634 100644
--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -259,3 +259,22 @@ int mwifiex_cmd_append_11ac_tlv(struct mwifiex_private *priv,
 
 	return ret_len;
 }
+
+int mwifiex_cmd_11ac_cfg(struct mwifiex_private *priv,
+			 struct host_cmd_ds_command *cmd, u16 cmd_action,
+			 struct mwifiex_11ac_vht_cfg *cfg)
+{
+	struct host_cmd_11ac_vht_cfg *vhtcfg = &cmd->params.vht_cfg;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_11AC_CFG);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_11ac_vht_cfg) +
+				S_DS_GEN);
+	vhtcfg->action = cpu_to_le16(cmd_action);
+	vhtcfg->band_config = cfg->band_config;
+	vhtcfg->misc_config = cfg->misc_config;
+	vhtcfg->cap_info = cpu_to_le32(cfg->cap_info);
+	vhtcfg->mcs_tx_set = cpu_to_le32(cfg->mcs_tx_set);
+	vhtcfg->mcs_rx_set = cpu_to_le32(cfg->mcs_rx_set);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mwifiex/11ac.h b/drivers/net/wireless/mwifiex/11ac.h
index 80fd1ba..7c2c69b 100644
--- a/drivers/net/wireless/mwifiex/11ac.h
+++ b/drivers/net/wireless/mwifiex/11ac.h
@@ -20,7 +20,24 @@
 #ifndef _MWIFIEX_11AC_H_
 #define _MWIFIEX_11AC_H_
 
+#define VHT_CFG_2GHZ BIT(0)
+#define VHT_CFG_5GHZ BIT(1)
+
+enum vht_cfg_misc_config {
+	VHT_CAP_TX_OPERATION = 1,
+	VHT_CAP_ASSOCIATION,
+	VHT_CAP_UAP_ONLY
+};
+
+#define DEFAULT_VHT_MCS_SET 0xfffa
+#define DISABLE_VHT_MCS_SET 0xffff
+
+#define VHT_BW_80_160_80P80 BIT(2)
+
 int mwifiex_cmd_append_11ac_tlv(struct mwifiex_private *priv,
 				struct mwifiex_bssdescriptor *bss_desc,
 				u8 **buffer);
+int mwifiex_cmd_11ac_cfg(struct mwifiex_private *priv,
+			 struct host_cmd_ds_command *cmd, u16 cmd_action,
+			 struct mwifiex_11ac_vht_cfg *cfg);
 #endif /* _MWIFIEX_11AC_H_ */
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index dbf5b12..95f3306 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1374,6 +1374,13 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	}
 
 	mwifiex_set_ht_params(priv, bss_cfg, params);
+
+	if (priv->adapter->is_hw_11ac_capable) {
+		mwifiex_set_vht_params(priv, bss_cfg, params);
+		mwifiex_set_vht_width(priv, params->chandef.width,
+				      priv->ap_11ac_enabled);
+	}
+
 	mwifiex_set_wmm_params(priv, bss_cfg, params);
 
 	if (params->inactivity_timeout > 0) {
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 57c5def..1f7578d 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -295,6 +295,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_PCIE_DESC_DETAILS                 0x00fa
 #define HostCmd_CMD_MGMT_FRAME_REG                    0x010c
 #define HostCmd_CMD_REMAIN_ON_CHAN                    0x010d
+#define HostCmd_CMD_11AC_CFG			      0x0112
 
 #define PROTOCOL_NO_SECURITY        0x01
 #define PROTOCOL_STATIC_WEP         0x02
@@ -1363,6 +1364,15 @@ struct host_cmd_ds_sys_config {
 	u8 tlv[0];
 };
 
+struct host_cmd_11ac_vht_cfg {
+	__le16 action;
+	u8 band_config;
+	u8 misc_config;
+	__le32 cap_info;
+	__le32 mcs_tx_set;
+	__le32 mcs_rx_set;
+} __packed;
+
 struct host_cmd_tlv_akmp {
 	struct host_cmd_tlv tlv;
 	__le16 key_mgmt;
@@ -1620,6 +1630,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_802_11_eeprom_access eeprom;
 		struct host_cmd_ds_802_11_subsc_evt subsc_evt;
 		struct host_cmd_ds_sys_config uap_sys_config;
+		struct host_cmd_11ac_vht_cfg vht_cfg;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 91d522c..7f27e45 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -272,6 +272,14 @@ struct mwifiex_ds_pm_cfg {
 	} param;
 };
 
+struct mwifiex_11ac_vht_cfg {
+	u8 band_config;
+	u8 misc_config;
+	u32 cap_info;
+	u32 mcs_tx_set;
+	u32 mcs_rx_set;
+};
+
 struct mwifiex_ds_11n_tx_cfg {
 	u16 tx_htcap;
 	u16 tx_htinfo;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 7255289..535595e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -912,8 +912,14 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 void mwifiex_set_ht_params(struct mwifiex_private *priv,
 			   struct mwifiex_uap_bss_param *bss_cfg,
 			   struct cfg80211_ap_settings *params);
+void mwifiex_set_vht_params(struct mwifiex_private *priv,
+			    struct mwifiex_uap_bss_param *bss_cfg,
+			    struct cfg80211_ap_settings *params);
 void mwifiex_set_uap_rates(struct mwifiex_uap_bss_param *bss_cfg,
 			   struct cfg80211_ap_settings *params);
+void mwifiex_set_vht_width(struct mwifiex_private *priv,
+			   enum nl80211_chan_width width,
+			   bool ap_11ac_disable);
 void
 mwifiex_set_wmm_params(struct mwifiex_private *priv,
 		       struct mwifiex_uap_bss_param *bss_cfg,
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index a2ae690..b193e25 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -24,6 +24,7 @@
 #include "main.h"
 #include "wmm.h"
 #include "11n.h"
+#include "11ac.h"
 
 /*
  * This function prepares command to set/get RSSI information.
@@ -1258,6 +1259,9 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		      cpu_to_le16(sizeof(struct host_cmd_ds_remain_on_chan) +
 				  S_DS_GEN);
 		break;
+	case HostCmd_CMD_11AC_CFG:
+		ret = mwifiex_cmd_11ac_cfg(priv, cmd_ptr, cmd_action, data_buf);
+		break;
 	case HostCmd_CMD_P2P_MODE_CFG:
 		cmd_ptr->command = cpu_to_le16(cmd_no);
 		cmd_ptr->params.mode_cfg.action = cpu_to_le16(cmd_action);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 80b9f22..c7dc450 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -907,6 +907,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_REMAIN_ON_CHAN:
 		ret = mwifiex_ret_remain_on_chan(priv, resp, data_buf);
 		break;
+	case HostCmd_CMD_11AC_CFG:
+		break;
 	case HostCmd_CMD_P2P_MODE_CFG:
 		ret = mwifiex_ret_p2p_mode_cfg(priv, resp, data_buf);
 		break;
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 6e76a15..b04b1db 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -18,6 +18,7 @@
  */
 
 #include "main.h"
+#include "11ac.h"
 
 /* This function parses security related parameters from cfg80211_ap_settings
  * and sets into FW understandable bss_config structure.
@@ -177,6 +178,60 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
 	return;
 }
 
+/* This function updates 11ac related parameters from IE
+ * and sets them into bss_config structure.
+ */
+void mwifiex_set_vht_params(struct mwifiex_private *priv,
+			    struct mwifiex_uap_bss_param *bss_cfg,
+			    struct cfg80211_ap_settings *params)
+{
+	const u8 *vht_ie;
+
+	vht_ie = cfg80211_find_ie(WLAN_EID_VHT_CAPABILITY, params->beacon.tail,
+				  params->beacon.tail_len);
+	if (vht_ie) {
+		memcpy(&bss_cfg->vht_cap, vht_ie + 2,
+		       sizeof(struct ieee80211_vht_cap));
+		priv->ap_11ac_enabled = 1;
+	} else {
+		priv->ap_11ac_enabled = 0;
+	}
+
+	return;
+}
+
+/* Enable VHT only when cfg80211_ap_settings has VHT IE.
+ * Otherwise disable VHT.
+ */
+void mwifiex_set_vht_width(struct mwifiex_private *priv,
+			   enum nl80211_chan_width width,
+			   bool ap_11ac_enable)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_11ac_vht_cfg vht_cfg;
+
+	vht_cfg.band_config = VHT_CFG_5GHZ;
+	vht_cfg.cap_info = adapter->hw_dot_11ac_dev_cap;
+
+	if (!ap_11ac_enable) {
+		vht_cfg.mcs_tx_set = DISABLE_VHT_MCS_SET;
+		vht_cfg.mcs_rx_set = DISABLE_VHT_MCS_SET;
+	} else {
+		vht_cfg.mcs_tx_set = DEFAULT_VHT_MCS_SET;
+		vht_cfg.mcs_rx_set = DEFAULT_VHT_MCS_SET;
+	}
+
+	vht_cfg.misc_config  = VHT_CAP_UAP_ONLY;
+
+	if (ap_11ac_enable && width >= NL80211_CHAN_WIDTH_80)
+		vht_cfg.misc_config |= VHT_BW_80_160_80P80;
+
+	mwifiex_send_cmd_sync(priv, HostCmd_CMD_11AC_CFG,
+			      HostCmd_ACT_GEN_SET, 0, &vht_cfg);
+
+	return;
+}
+
 /* This function finds supported rates IE from beacon parameter and sets
  * these rates into bss_config structure.
  */
-- 
1.7.0.2

