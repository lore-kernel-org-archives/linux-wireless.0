Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:47169 "HELO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754528Ab2ECHXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:23:55 -0400
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
Subject: [PATCH 14/18] mwifiex: add WPA2 support for AP
Date: Thu,  3 May 2012 00:22:36 -0700
Message-Id: <1336029760-22565-15-git-send-email-bzhao@marvell.com> (sfid-20120503_092406_196005_1380570F)
In-Reply-To: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

1. Support for parsing security related parameters from
   cfg80211_ap_settings in start_ap cfg80211 handler
2. Conversion of these security information into FW understandle TLVs
   and setting into FW thru sys_config command
3. key management is done on host. This ensures that FW forwards EAPOL
   key packets to host instead of processing on its own.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    9 ++
 drivers/net/wireless/mwifiex/fw.h       |   53 +++++++++
 drivers/net/wireless/mwifiex/ioctl.h    |   16 +++
 drivers/net/wireless/mwifiex/main.h     |    3 +
 drivers/net/wireless/mwifiex/uap_cmd.c  |  187 +++++++++++++++++++++++++++++++
 5 files changed, 268 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 5a0f20c..da9d975 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -950,6 +950,9 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	struct mwifiex_uap_bss_param *bss_cfg;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
+	if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP)
+		return -1;
+
 	bss_cfg = kzalloc(sizeof(struct mwifiex_uap_bss_param), GFP_KERNEL);
 	if (!bss_cfg)
 		return -ENOMEM;
@@ -966,6 +969,12 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		bss_cfg->ssid.ssid_len = params->ssid_len;
 	}
 
+	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
+		kfree(bss_cfg);
+		wiphy_err(wiphy, "Failed to parse secuirty parameters!\n");
+		return -1;
+	}
+
 	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_UAP_BSS_STOP,
 				  HostCmd_ACT_GEN_SET, 0, NULL)) {
 		wiphy_err(wiphy, "Failed to stop the BSS\n");
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 77f82fc..57fd0ca 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -111,6 +111,9 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_UAP_BEACON_PERIOD  (PROPRIETARY_TLV_BASE_ID + 44)
 #define TLV_TYPE_UAP_DTIM_PERIOD    (PROPRIETARY_TLV_BASE_ID + 45)
 #define TLV_TYPE_UAP_RTS_THRESHOLD  (PROPRIETARY_TLV_BASE_ID + 51)
+#define TLV_TYPE_UAP_WPA_PASSPHRASE (PROPRIETARY_TLV_BASE_ID + 60)
+#define TLV_TYPE_UAP_ENCRY_PROTOCOL (PROPRIETARY_TLV_BASE_ID + 64)
+#define TLV_TYPE_UAP_AKMP           (PROPRIETARY_TLV_BASE_ID + 65)
 #define TLV_TYPE_UAP_FRAG_THRESHOLD (PROPRIETARY_TLV_BASE_ID + 70)
 #define TLV_TYPE_RATE_DROP_CONTROL  (PROPRIETARY_TLV_BASE_ID + 82)
 #define TLV_TYPE_RATE_SCOPE         (PROPRIETARY_TLV_BASE_ID + 83)
@@ -121,6 +124,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_MGMT_IE            (PROPRIETARY_TLV_BASE_ID + 105)
 #define TLV_TYPE_AUTO_DS_PARAM      (PROPRIETARY_TLV_BASE_ID + 113)
 #define TLV_TYPE_PS_PARAM           (PROPRIETARY_TLV_BASE_ID + 114)
+#define TLV_TYPE_PWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 145)
+#define TLV_TYPE_GWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 146)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -235,6 +240,19 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_SET_BSS_MODE                      0x00f7
 #define HostCmd_CMD_PCIE_DESC_DETAILS                 0x00fa
 
+#define PROTOCOL_NO_SECURITY        0x01
+#define PROTOCOL_STATIC_WEP         0x02
+#define PROTOCOL_WPA                0x08
+#define PROTOCOL_WPA2               0x20
+#define PROTOCOL_WPA2_MIXED         0x28
+#define PROTOCOL_EAP                0x40
+#define KEY_MGMT_NONE               0x04
+#define KEY_MGMT_PSK                0x02
+#define KEY_MGMT_EAP                0x01
+#define CIPHER_TKIP                 0x04
+#define CIPHER_AES_CCMP             0x08
+#define VALID_CIPHER_BITMAP         0x0c
+
 enum ENH_PS_MODES {
 	EN_PS = 1,
 	DIS_PS = 2,
@@ -1139,6 +1157,41 @@ struct host_cmd_ds_sys_config {
 	__le16 action;
 	u8 tlv[0];
 };
+
+struct host_cmd_tlv_akmp {
+	struct host_cmd_tlv tlv;
+	__le16 key_mgmt;
+	__le16 key_mgmt_operation;
+} __packed;
+
+struct host_cmd_tlv_pwk_cipher {
+	struct host_cmd_tlv tlv;
+	__le16 proto;
+	u8 cipher;
+	u8 reserved;
+} __packed;
+
+struct host_cmd_tlv_gwk_cipher {
+	struct host_cmd_tlv tlv;
+	u8 cipher;
+	u8 reserved;
+} __packed;
+
+struct host_cmd_tlv_passphrase {
+	struct host_cmd_tlv tlv;
+	u8 passphrase[0];
+} __packed;
+
+struct host_cmd_tlv_auth_type {
+	struct host_cmd_tlv tlv;
+	u8 auth_type;
+} __packed;
+
+struct host_cmd_tlv_encrypt_protocol {
+	struct host_cmd_tlv tlv;
+	__le16 proto;
+} __packed;
+
 struct host_cmd_tlv_ssid {
 	struct host_cmd_tlv tlv;
 	u8 ssid[0];
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 99a7168..eb14f55 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -62,6 +62,17 @@ enum {
 	BAND_AN = 16,
 };
 
+#define MWIFIEX_WPA_PASSHPHRASE_LEN 64
+struct wpa_param {
+	u8 pairwise_cipher_wpa;
+	u8 pairwise_cipher_wpa2;
+	u8 group_cipher;
+	u32 length;
+	u8 passphrase[MWIFIEX_WPA_PASSHPHRASE_LEN];
+};
+
+#define KEY_MGMT_ON_HOST        0x03
+#define MWIFIEX_AUTH_MODE_AUTO  0xFF
 #define BAND_CONFIG_MANUAL      0x00
 struct mwifiex_uap_bss_param {
 	u8 channel;
@@ -74,6 +85,11 @@ struct mwifiex_uap_bss_param {
 	u8 radio_ctl;
 	u8 dtim_period;
 	u16 beacon_period;
+	u16 auth_mode;
+	u16 protocol;
+	u16 key_mgmt;
+	u16 key_mgmt_operation;
+	struct wpa_param wpa_cfg;
 };
 
 enum {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index b0a8338..824bd43 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -826,6 +826,9 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 int is_command_pending(struct mwifiex_adapter *adapter);
 void mwifiex_init_priv_params(struct mwifiex_private *priv,
 						struct net_device *dev);
+int mwifiex_set_secure_params(struct mwifiex_private *priv,
+			      struct mwifiex_uap_bss_param *bss_config,
+			      struct cfg80211_ap_settings *params);
 
 /*
  * This function checks if the queuing is RA based or not.
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 134cdaa..11118eb 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -19,12 +19,105 @@
 
 #include "main.h"
 
+/* This function parses security related parameters from cfg80211_ap_settings
+ * and sets into FW understandable bss_config structure.
+ */
+int mwifiex_set_secure_params(struct mwifiex_private *priv,
+			      struct mwifiex_uap_bss_param *bss_config,
+			      struct cfg80211_ap_settings *params) {
+	int i;
+
+	switch (params->auth_type) {
+	case NL80211_AUTHTYPE_OPEN_SYSTEM:
+		bss_config->auth_mode = WLAN_AUTH_OPEN;
+		break;
+	case NL80211_AUTHTYPE_SHARED_KEY:
+		bss_config->auth_mode = WLAN_AUTH_SHARED_KEY;
+		break;
+	case NL80211_AUTHTYPE_NETWORK_EAP:
+		bss_config->auth_mode = WLAN_AUTH_LEAP;
+		break;
+	default:
+		bss_config->auth_mode = MWIFIEX_AUTH_MODE_AUTO;
+		break;
+	}
+
+	bss_config->key_mgmt_operation |= KEY_MGMT_ON_HOST;
+
+	for (i = 0; i < params->crypto.n_akm_suites; i++) {
+		switch (params->crypto.akm_suites[i]) {
+		case WLAN_AKM_SUITE_8021X:
+			if (params->crypto.wpa_versions
+			    & NL80211_WPA_VERSION_1) {
+				bss_config->protocol = PROTOCOL_WPA;
+				bss_config->key_mgmt = KEY_MGMT_EAP;
+			}
+			if (params->crypto.wpa_versions
+			    & NL80211_WPA_VERSION_2) {
+				bss_config->protocol = PROTOCOL_WPA2;
+				bss_config->key_mgmt = KEY_MGMT_EAP;
+			}
+			break;
+		case WLAN_AKM_SUITE_PSK:
+			if (params->crypto.wpa_versions
+			    & NL80211_WPA_VERSION_1) {
+				bss_config->protocol = PROTOCOL_WPA;
+				bss_config->key_mgmt = KEY_MGMT_PSK;
+			}
+			if (params->crypto.wpa_versions
+			    & NL80211_WPA_VERSION_2) {
+				bss_config->protocol = PROTOCOL_WPA2;
+				bss_config->key_mgmt = KEY_MGMT_PSK;
+			}
+			break;
+		default:
+			break;
+		}
+	}
+	for (i = 0; i < params->crypto.n_ciphers_pairwise; i++) {
+		switch (params->crypto.ciphers_pairwise[i]) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+			break;
+		case WLAN_CIPHER_SUITE_TKIP:
+			bss_config->wpa_cfg.pairwise_cipher_wpa = CIPHER_TKIP;
+			break;
+		case WLAN_CIPHER_SUITE_CCMP:
+			bss_config->wpa_cfg.pairwise_cipher_wpa2 =
+								CIPHER_AES_CCMP;
+		default:
+			break;
+		}
+	}
+
+	switch (params->crypto.cipher_group) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		bss_config->wpa_cfg.group_cipher = CIPHER_TKIP;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		bss_config->wpa_cfg.group_cipher = CIPHER_AES_CCMP;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 /* This function initializes some of mwifiex_uap_bss_param variables.
  * This helps FW in ignoring invalid values. These values may or may not
  * be get updated to valid ones at later stage.
  */
 void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config)
 {
+	config->bcast_ssid_ctl = 0x7F;
+	config->radio_ctl = 0x7F;
+	config->dtim_period = 0x7F;
+	config->beacon_period = 0x7FFF;
+	config->auth_mode = 0x7F;
 	config->rts_threshold = 0x7FFF;
 	config->frag_threshold = 0x7FFF;
 	config->retry_limit = 0x7F;
@@ -45,6 +138,12 @@ static int mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd,
 	struct host_cmd_tlv_frag_threshold *frag_threshold;
 	struct host_cmd_tlv_rts_threshold *rts_threshold;
 	struct host_cmd_tlv_retry_limit *retry_limit;
+	struct host_cmd_tlv_pwk_cipher *pwk_cipher;
+	struct host_cmd_tlv_gwk_cipher *gwk_cipher;
+	struct host_cmd_tlv_encrypt_protocol *encrypt_protocol;
+	struct host_cmd_tlv_auth_type *auth_type;
+	struct host_cmd_tlv_passphrase *passphrase;
+	struct host_cmd_tlv_akmp *tlv_akmp;
 	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
 	u16 cmd_size;
 
@@ -131,6 +230,94 @@ static int mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd,
 		cmd_size += sizeof(struct host_cmd_tlv_retry_limit);
 		tlv += sizeof(struct host_cmd_tlv_retry_limit);
 	}
+	if ((bss_cfg->protocol & PROTOCOL_WPA) ||
+	    (bss_cfg->protocol & PROTOCOL_WPA2) ||
+	    (bss_cfg->protocol & PROTOCOL_EAP)) {
+		tlv_akmp = (struct host_cmd_tlv_akmp *)tlv;
+		tlv_akmp->tlv.type = cpu_to_le16(TLV_TYPE_UAP_AKMP);
+		tlv_akmp->tlv.len =
+		    cpu_to_le16(sizeof(struct host_cmd_tlv_akmp) -
+				sizeof(struct host_cmd_tlv));
+		tlv_akmp->key_mgmt_operation =
+			cpu_to_le16(bss_cfg->key_mgmt_operation);
+		tlv_akmp->key_mgmt = cpu_to_le16(bss_cfg->key_mgmt);
+		cmd_size += sizeof(struct host_cmd_tlv_akmp);
+		tlv += sizeof(struct host_cmd_tlv_akmp);
+
+		if (bss_cfg->wpa_cfg.pairwise_cipher_wpa &
+				VALID_CIPHER_BITMAP) {
+			pwk_cipher = (struct host_cmd_tlv_pwk_cipher *)tlv;
+			pwk_cipher->tlv.type =
+				cpu_to_le16(TLV_TYPE_PWK_CIPHER);
+			pwk_cipher->tlv.len = cpu_to_le16(
+				sizeof(struct host_cmd_tlv_pwk_cipher) -
+				sizeof(struct host_cmd_tlv));
+			pwk_cipher->proto = cpu_to_le16(PROTOCOL_WPA);
+			pwk_cipher->cipher =
+				bss_cfg->wpa_cfg.pairwise_cipher_wpa;
+			cmd_size += sizeof(struct host_cmd_tlv_pwk_cipher);
+			tlv += sizeof(struct host_cmd_tlv_pwk_cipher);
+		}
+		if (bss_cfg->wpa_cfg.pairwise_cipher_wpa2 &
+				VALID_CIPHER_BITMAP) {
+			pwk_cipher = (struct host_cmd_tlv_pwk_cipher *)tlv;
+			pwk_cipher->tlv.type = cpu_to_le16(TLV_TYPE_PWK_CIPHER);
+			pwk_cipher->tlv.len = cpu_to_le16(
+				sizeof(struct host_cmd_tlv_pwk_cipher) -
+				sizeof(struct host_cmd_tlv));
+			pwk_cipher->proto = cpu_to_le16(PROTOCOL_WPA2);
+			pwk_cipher->cipher =
+				bss_cfg->wpa_cfg.pairwise_cipher_wpa2;
+			cmd_size += sizeof(struct host_cmd_tlv_pwk_cipher);
+			tlv += sizeof(struct host_cmd_tlv_pwk_cipher);
+		}
+		if (bss_cfg->wpa_cfg.group_cipher & VALID_CIPHER_BITMAP) {
+			gwk_cipher = (struct host_cmd_tlv_gwk_cipher *)tlv;
+			gwk_cipher->tlv.type = cpu_to_le16(TLV_TYPE_GWK_CIPHER);
+			gwk_cipher->tlv.len = cpu_to_le16(
+				sizeof(struct host_cmd_tlv_gwk_cipher) -
+				sizeof(struct host_cmd_tlv));
+			gwk_cipher->cipher = bss_cfg->wpa_cfg.group_cipher;
+			cmd_size += sizeof(struct host_cmd_tlv_gwk_cipher);
+			tlv += sizeof(struct host_cmd_tlv_gwk_cipher);
+		}
+		if (bss_cfg->wpa_cfg.length) {
+			passphrase = (struct host_cmd_tlv_passphrase *)tlv;
+			passphrase->tlv.type =
+				cpu_to_le16(TLV_TYPE_UAP_WPA_PASSPHRASE);
+			passphrase->tlv.len =
+				cpu_to_le16(bss_cfg->wpa_cfg.length);
+			memcpy(passphrase->passphrase,
+			       bss_cfg->wpa_cfg.passphrase,
+			       bss_cfg->wpa_cfg.length);
+			cmd_size += sizeof(struct host_cmd_tlv) +
+				    bss_cfg->wpa_cfg.length;
+			tlv += sizeof(struct host_cmd_tlv) +
+			       bss_cfg->wpa_cfg.length;
+		}
+	}
+	if ((bss_cfg->auth_mode <= WLAN_AUTH_SHARED_KEY) ||
+	    (bss_cfg->auth_mode == MWIFIEX_AUTH_MODE_AUTO)) {
+		auth_type = (struct host_cmd_tlv_auth_type *)tlv;
+		auth_type->tlv.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
+		auth_type->tlv.len =
+			cpu_to_le16(sizeof(struct host_cmd_tlv_auth_type) -
+			sizeof(struct host_cmd_tlv));
+		auth_type->auth_type = (u8)bss_cfg->auth_mode;
+		cmd_size += sizeof(struct host_cmd_tlv_auth_type);
+		tlv += sizeof(struct host_cmd_tlv_auth_type);
+	}
+	if (bss_cfg->protocol) {
+		encrypt_protocol = (struct host_cmd_tlv_encrypt_protocol *)tlv;
+		encrypt_protocol->tlv.type =
+			cpu_to_le16(TLV_TYPE_UAP_ENCRY_PROTOCOL);
+		encrypt_protocol->tlv.len =
+			cpu_to_le16(sizeof(struct host_cmd_tlv_encrypt_protocol)
+			- sizeof(struct host_cmd_tlv));
+		encrypt_protocol->proto = cpu_to_le16(bss_cfg->protocol);
+		cmd_size += sizeof(struct host_cmd_tlv_encrypt_protocol);
+		tlv += sizeof(struct host_cmd_tlv_encrypt_protocol);
+	}
 
 	cmd->size = cpu_to_le16(cmd_size);
 	return 0;
-- 
1.7.0.2

