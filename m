Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49733 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553AbaBDAkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 19:40:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 30/30] mwifiex: add key material v2 support
Date: Mon, 3 Feb 2014 16:40:05 -0800
Message-ID: <1391474405-8147-1-git-send-email-bzhao@marvell.com> (sfid-20140204_014038_790879_8BB1DD77)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds key material V2 support to mwifiex.
Newer FW supports this feature and FW KEY API version is used
to determine which command structure needs to be used.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h          |  63 +++++++-
 drivers/net/wireless/mwifiex/ioctl.h       |   3 +
 drivers/net/wireless/mwifiex/main.h        |   1 +
 drivers/net/wireless/mwifiex/sta_cmd.c     | 246 ++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  51 +++++-
 drivers/net/wireless/mwifiex/sta_ioctl.c   |  36 ++++-
 6 files changed, 388 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 5808f23..aa8abef 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -79,12 +79,21 @@ enum KEY_TYPE_ID {
 	KEY_TYPE_ID_WAPI,
 	KEY_TYPE_ID_AES_CMAC,
 };
+
+#define WPA_PN_SIZE		8
+#define KEY_PARAMS_FIXED_LEN	10
+#define KEY_INDEX_MASK		0xf
+#define FW_KEY_API_VER_MAJOR_V2	2
+
 #define KEY_MCAST	BIT(0)
 #define KEY_UNICAST	BIT(1)
 #define KEY_ENABLED	BIT(2)
+#define KEY_DEFAULT	BIT(3)
+#define KEY_TX_KEY	BIT(4)
+#define KEY_RX_KEY	BIT(5)
 #define KEY_IGTK	BIT(10)
 
-#define WAPI_KEY_LEN			50
+#define WAPI_KEY_LEN			(WLAN_KEY_LEN_SMS4 + PN_LEN + 2)
 
 #define MAX_POLL_TRIES			100
 #define MAX_FIRMWARE_POLL_TRIES			100
@@ -159,6 +168,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_PWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 145)
 #define TLV_TYPE_GWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 146)
 #define TLV_TYPE_COALESCE_RULE      (PROPRIETARY_TLV_BASE_ID + 154)
+#define TLV_TYPE_KEY_PARAM_V2       (PROPRIETARY_TLV_BASE_ID + 156)
 #define TLV_TYPE_FW_API_REV         (PROPRIETARY_TLV_BASE_ID + 199)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
@@ -701,6 +711,56 @@ struct mwifiex_cmac_param {
 	u8 key[WLAN_KEY_LEN_AES_CMAC];
 } __packed;
 
+struct mwifiex_wep_param {
+	__le16 key_len;
+	u8 key[WLAN_KEY_LEN_WEP104];
+} __packed;
+
+struct mwifiex_tkip_param {
+	u8 pn[WPA_PN_SIZE];
+	__le16 key_len;
+	u8 key[WLAN_KEY_LEN_TKIP];
+} __packed;
+
+struct mwifiex_aes_param {
+	u8 pn[WPA_PN_SIZE];
+	__le16 key_len;
+	u8 key[WLAN_KEY_LEN_CCMP];
+} __packed;
+
+struct mwifiex_wapi_param {
+	u8 pn[PN_LEN];
+	__le16 key_len;
+	u8 key[WLAN_KEY_LEN_SMS4];
+} __packed;
+
+struct mwifiex_cmac_aes_param {
+	u8 ipn[IGTK_PN_LEN];
+	__le16 key_len;
+	u8 key[WLAN_KEY_LEN_AES_CMAC];
+} __packed;
+
+struct mwifiex_ie_type_key_param_set_v2 {
+	__le16 type;
+	__le16 len;
+	u8 mac_addr[ETH_ALEN];
+	u8 key_idx;
+	u8 key_type;
+	__le16 key_info;
+	union {
+		struct mwifiex_wep_param wep;
+		struct mwifiex_tkip_param tkip;
+		struct mwifiex_aes_param aes;
+		struct mwifiex_wapi_param wapi;
+		struct mwifiex_cmac_aes_param cmac_aes;
+	} key_params;
+} __packed;
+
+struct host_cmd_ds_802_11_key_material_v2 {
+	__le16 action;
+	struct mwifiex_ie_type_key_param_set_v2 key_param_set;
+} __packed;
+
 struct host_cmd_ds_802_11_key_material {
 	__le16 action;
 	struct mwifiex_ie_type_key_param_set key_param_set;
@@ -1742,6 +1802,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_11n_cfg htcfg;
 		struct host_cmd_ds_wmm_get_status get_wmm_status;
 		struct host_cmd_ds_802_11_key_material key_material;
+		struct host_cmd_ds_802_11_key_material_v2 key_material_v2;
 		struct host_cmd_ds_version_ext verext;
 		struct host_cmd_ds_mgmt_frame_reg reg_mask;
 		struct host_cmd_ds_remain_on_chan roc_cfg;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 6ed1e13..5974642 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -236,7 +236,10 @@ struct mwifiex_ds_encrypt_key {
 	u8 mac_addr[ETH_ALEN];
 	u32 is_wapi_key;
 	u8 pn[PN_LEN];		/* packet number */
+	u8 pn_len;
 	u8 is_igtk_key;
+	u8 is_current_wep_key;
+	u8 is_rx_seq_valid;
 };
 
 struct mwifiex_power_cfg {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index a221fd3..68eba5f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -469,6 +469,7 @@ struct mwifiex_private {
 	u8 wpa_ie_len;
 	u8 wpa_is_gtk_set;
 	struct host_cmd_ds_802_11_key_material aes_key;
+	struct host_cmd_ds_802_11_key_material_v2 aes_key_v2;
 	u8 wapi_ie[256];
 	u8 wapi_ie_len;
 	u8 *wps_ie;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index b10425c..5aa3d39 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -532,8 +532,228 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 	return 0;
 }
 
+/* This function populates key material v2 command
+ * to set network key for AES & CMAC AES.
+ */
+static int mwifiex_set_aes_key_v2(struct mwifiex_private *priv,
+				  struct host_cmd_ds_command *cmd,
+				  struct mwifiex_ds_encrypt_key *enc_key,
+				  struct host_cmd_ds_802_11_key_material_v2 *km)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u16 size, len = KEY_PARAMS_FIXED_LEN;
+
+	if (enc_key->is_igtk_key) {
+		dev_dbg(adapter->dev, "%s: Set CMAC AES Key\n", __func__);
+		if (enc_key->is_rx_seq_valid)
+			memcpy(km->key_param_set.key_params.cmac_aes.ipn,
+			       enc_key->pn, enc_key->pn_len);
+		km->key_param_set.key_info &= cpu_to_le16(~KEY_MCAST);
+		km->key_param_set.key_info |= cpu_to_le16(KEY_IGTK);
+		km->key_param_set.key_type = KEY_TYPE_ID_AES_CMAC;
+		km->key_param_set.key_params.cmac_aes.key_len =
+					  cpu_to_le16(enc_key->key_len);
+		memcpy(km->key_param_set.key_params.cmac_aes.key,
+		       enc_key->key_material, enc_key->key_len);
+		len += sizeof(struct mwifiex_cmac_aes_param);
+	} else {
+		dev_dbg(adapter->dev, "%s: Set AES Key\n", __func__);
+		if (enc_key->is_rx_seq_valid)
+			memcpy(km->key_param_set.key_params.aes.pn,
+			       enc_key->pn, enc_key->pn_len);
+		km->key_param_set.key_type = KEY_TYPE_ID_AES;
+		km->key_param_set.key_params.aes.key_len =
+					  cpu_to_le16(enc_key->key_len);
+		memcpy(km->key_param_set.key_params.aes.key,
+		       enc_key->key_material, enc_key->key_len);
+		len += sizeof(struct mwifiex_aes_param);
+	}
+
+	km->key_param_set.len = cpu_to_le16(len);
+	size = len + sizeof(struct mwifiex_ie_types_header) +
+	       sizeof(km->action) + S_DS_GEN;
+	cmd->size = cpu_to_le16(size);
+
+	return 0;
+}
+
+/* This function prepares command to set/get/reset network key(s).
+ * This function prepares key material command for V2 format.
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting WEP keys, WAPI keys or WPA keys along with required
+ *        encryption (TKIP, AES) (as required)
+ *      - Ensuring correct endian-ness
+ */
+static int
+mwifiex_cmd_802_11_key_material_v2(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd,
+				   u16 cmd_action, u32 cmd_oid,
+				   struct mwifiex_ds_encrypt_key *enc_key)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 *mac = enc_key->mac_addr;
+	u16 key_info, len = KEY_PARAMS_FIXED_LEN;
+	struct host_cmd_ds_802_11_key_material_v2 *km =
+						&cmd->params.key_material_v2;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_KEY_MATERIAL);
+	km->action = cpu_to_le16(cmd_action);
+
+	if (cmd_action == HostCmd_ACT_GEN_GET) {
+		dev_dbg(adapter->dev, "%s: Get key\n", __func__);
+		km->key_param_set.key_idx =
+					enc_key->key_index & KEY_INDEX_MASK;
+		km->key_param_set.type = cpu_to_le16(TLV_TYPE_KEY_PARAM_V2);
+		km->key_param_set.len = cpu_to_le16(KEY_PARAMS_FIXED_LEN);
+		memcpy(km->key_param_set.mac_addr, mac, ETH_ALEN);
+
+		if (enc_key->key_index & MWIFIEX_KEY_INDEX_UNICAST)
+			key_info = KEY_UNICAST;
+		else
+			key_info = KEY_MCAST;
+
+		if (enc_key->is_igtk_key)
+			key_info |= KEY_IGTK;
+
+		km->key_param_set.key_info = cpu_to_le16(key_info);
+
+		cmd->size = cpu_to_le16(sizeof(struct mwifiex_ie_types_header) +
+					S_DS_GEN + KEY_PARAMS_FIXED_LEN +
+					sizeof(km->action));
+		return 0;
+	}
+
+	memset(&km->key_param_set, 0,
+	       sizeof(struct mwifiex_ie_type_key_param_set_v2));
+
+	if (enc_key->key_disable) {
+		dev_dbg(adapter->dev, "%s: Remove key\n", __func__);
+		km->action = cpu_to_le16(HostCmd_ACT_GEN_REMOVE);
+		km->key_param_set.type = cpu_to_le16(TLV_TYPE_KEY_PARAM_V2);
+		km->key_param_set.len = cpu_to_le16(KEY_PARAMS_FIXED_LEN);
+		km->key_param_set.key_idx = enc_key->key_index & KEY_INDEX_MASK;
+		key_info = KEY_MCAST | KEY_UNICAST;
+		km->key_param_set.key_info = cpu_to_le16(key_info);
+		memcpy(km->key_param_set.mac_addr, mac, ETH_ALEN);
+		cmd->size = cpu_to_le16(sizeof(struct mwifiex_ie_types_header) +
+					S_DS_GEN + KEY_PARAMS_FIXED_LEN +
+					sizeof(km->action));
+		return 0;
+	}
+
+	km->action = cpu_to_le16(HostCmd_ACT_GEN_SET);
+	km->key_param_set.key_idx = enc_key->key_index & KEY_INDEX_MASK;
+	km->key_param_set.type = cpu_to_le16(TLV_TYPE_KEY_PARAM_V2);
+	key_info = KEY_ENABLED;
+	memcpy(km->key_param_set.mac_addr, mac, ETH_ALEN);
+
+	if (enc_key->key_len <= WLAN_KEY_LEN_WEP104) {
+		dev_dbg(adapter->dev, "%s: Set WEP Key\n", __func__);
+		len += sizeof(struct mwifiex_wep_param);
+		km->key_param_set.len = cpu_to_le16(len);
+		km->key_param_set.key_type = KEY_TYPE_ID_WEP;
+
+		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
+				key_info |= KEY_MCAST | KEY_UNICAST;
+		} else {
+			if (enc_key->is_current_wep_key) {
+				key_info |= KEY_MCAST | KEY_UNICAST;
+				if (km->key_param_set.key_idx ==
+				    (priv->wep_key_curr_index & KEY_INDEX_MASK))
+					key_info |= KEY_DEFAULT;
+			} else {
+				if (mac) {
+					if (is_broadcast_ether_addr(mac))
+						key_info |= KEY_MCAST;
+					else
+						key_info |= KEY_UNICAST |
+							    KEY_DEFAULT;
+				} else {
+					key_info |= KEY_MCAST;
+				}
+			}
+		}
+		km->key_param_set.key_info = cpu_to_le16(key_info);
+
+		km->key_param_set.key_params.wep.key_len =
+						  cpu_to_le16(enc_key->key_len);
+		memcpy(km->key_param_set.key_params.wep.key,
+		       enc_key->key_material, enc_key->key_len);
+
+		cmd->size = cpu_to_le16(sizeof(struct mwifiex_ie_types_header) +
+					len + sizeof(km->action) + S_DS_GEN);
+		return 0;
+	}
+
+	if (is_broadcast_ether_addr(mac))
+		key_info |= KEY_MCAST | KEY_RX_KEY;
+	else
+		key_info |= KEY_UNICAST | KEY_TX_KEY | KEY_RX_KEY;
+
+	if (enc_key->is_wapi_key) {
+		dev_dbg(adapter->dev, "%s: Set WAPI Key\n", __func__);
+		km->key_param_set.key_type = KEY_TYPE_ID_WAPI;
+		memcpy(km->key_param_set.key_params.wapi.pn, enc_key->pn,
+		       PN_LEN);
+		km->key_param_set.key_params.wapi.key_len =
+						cpu_to_le16(enc_key->key_len);
+		memcpy(km->key_param_set.key_params.wapi.key,
+		       enc_key->key_material, enc_key->key_len);
+		if (is_broadcast_ether_addr(mac))
+			priv->sec_info.wapi_key_on = true;
+
+		if (!priv->sec_info.wapi_key_on)
+			key_info |= KEY_DEFAULT;
+		km->key_param_set.key_info = cpu_to_le16(key_info);
+
+		len += sizeof(struct mwifiex_wapi_param);
+		km->key_param_set.len = cpu_to_le16(len);
+		cmd->size = cpu_to_le16(sizeof(struct mwifiex_ie_types_header) +
+					len + sizeof(km->action) + S_DS_GEN);
+		return 0;
+	}
+
+	if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
+		key_info |= KEY_DEFAULT;
+		/* Enable unicast bit for WPA-NONE/ADHOC_AES */
+		if (!priv->sec_info.wpa2_enabled &&
+		    !is_broadcast_ether_addr(mac))
+			key_info |= KEY_UNICAST;
+	} else {
+		/* Enable default key for WPA/WPA2 */
+		if (!priv->wpa_is_gtk_set)
+			key_info |= KEY_DEFAULT;
+	}
+
+	km->key_param_set.key_info = cpu_to_le16(key_info);
+
+	if (enc_key->key_len == WLAN_KEY_LEN_CCMP)
+		return mwifiex_set_aes_key_v2(priv, cmd, enc_key, km);
+
+	if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
+		dev_dbg(adapter->dev, "%s: Set TKIP Key\n", __func__);
+		if (enc_key->is_rx_seq_valid)
+			memcpy(km->key_param_set.key_params.tkip.pn,
+			       enc_key->pn, enc_key->pn_len);
+		km->key_param_set.key_type = KEY_TYPE_ID_TKIP;
+		km->key_param_set.key_params.tkip.key_len =
+						cpu_to_le16(enc_key->key_len);
+		memcpy(km->key_param_set.key_params.tkip.key,
+		       enc_key->key_material, enc_key->key_len);
+
+		len += sizeof(struct mwifiex_tkip_param);
+		km->key_param_set.len = cpu_to_le16(len);
+		cmd->size = cpu_to_le16(sizeof(struct mwifiex_ie_types_header) +
+					len + sizeof(km->action) + S_DS_GEN);
+	}
+
+	return 0;
+}
+
 /*
  * This function prepares command to set/get/reset network key(s).
+ * This function prepares key material command for V1 format.
  *
  * Preparation includes -
  *      - Setting command ID, action and proper size
@@ -542,10 +762,10 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
  *      - Ensuring correct endian-ness
  */
 static int
-mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *cmd,
-				u16 cmd_action, u32 cmd_oid,
-				struct mwifiex_ds_encrypt_key *enc_key)
+mwifiex_cmd_802_11_key_material_v1(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd,
+				   u16 cmd_action, u32 cmd_oid,
+				   struct mwifiex_ds_encrypt_key *enc_key)
 {
 	struct host_cmd_ds_802_11_key_material *key_material =
 		&cmd->params.key_material;
@@ -724,6 +944,24 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 	return ret;
 }
 
+/* Wrapper function for setting network key depending upon FW KEY API version */
+static int
+mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd,
+				u16 cmd_action, u32 cmd_oid,
+				struct mwifiex_ds_encrypt_key *enc_key)
+{
+	if (priv->adapter->fw_key_api_major_ver == FW_KEY_API_VER_MAJOR_V2)
+		return mwifiex_cmd_802_11_key_material_v2(priv, cmd,
+							  cmd_action, cmd_oid,
+							  enc_key);
+
+	else
+		return mwifiex_cmd_802_11_key_material_v1(priv, cmd,
+							  cmd_action, cmd_oid,
+							  enc_key);
+}
+
 /*
  * This function prepares command to set/get 11d domain information.
  *
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index daaf104..4626e8b 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -562,13 +562,13 @@ static int mwifiex_ret_802_11_ad_hoc_stop(struct mwifiex_private *priv,
 }
 
 /*
- * This function handles the command response of set/get key material.
+ * This function handles the command response of set/get v1 key material.
  *
  * Handling includes updating the driver parameters to reflect the
  * changes.
  */
-static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
-					   struct host_cmd_ds_command *resp)
+static int mwifiex_ret_802_11_key_material_v1(struct mwifiex_private *priv,
+					      struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_key_material *key =
 						&resp->params.key_material;
@@ -591,6 +591,51 @@ static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 }
 
 /*
+ * This function handles the command response of set/get v2 key material.
+ *
+ * Handling includes updating the driver parameters to reflect the
+ * changes.
+ */
+static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
+					      struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_802_11_key_material_v2 *key_v2;
+	__le16 len;
+
+	key_v2 = &resp->params.key_material_v2;
+	if (le16_to_cpu(key_v2->action) == HostCmd_ACT_GEN_SET) {
+		if ((le16_to_cpu(key_v2->key_param_set.key_info) & KEY_MCAST)) {
+			dev_dbg(priv->adapter->dev, "info: key: GTK is set\n");
+			priv->wpa_is_gtk_set = true;
+			priv->scan_block = false;
+		}
+	}
+
+	if (key_v2->key_param_set.key_type != KEY_TYPE_ID_AES)
+		return 0;
+
+	memset(priv->aes_key_v2.key_param_set.key_params.aes.key, 0,
+	       WLAN_KEY_LEN_CCMP);
+	priv->aes_key_v2.key_param_set.key_params.aes.key_len =
+				key_v2->key_param_set.key_params.aes.key_len;
+	len = priv->aes_key_v2.key_param_set.key_params.aes.key_len;
+	memcpy(priv->aes_key_v2.key_param_set.key_params.aes.key,
+	       key_v2->key_param_set.key_params.aes.key, le16_to_cpu(len));
+
+	return 0;
+}
+
+/* Wrapper function for processing response of key material command */
+static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
+					   struct host_cmd_ds_command *resp)
+{
+	if (priv->adapter->fw_key_api_major_ver == FW_KEY_API_VER_MAJOR_V2)
+		return mwifiex_ret_802_11_key_material_v2(priv, resp);
+	else
+		return mwifiex_ret_802_11_key_material_v1(priv, resp);
+}
+
+/*
  * This function handles the command response of get 11d domain information.
  */
 static int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 9e55a48..a55ea90 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -865,6 +865,7 @@ static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_private *priv,
 static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret;
 	struct mwifiex_wep_key *wep_key;
 	int index;
@@ -879,10 +880,17 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 		/* Copy the required key as the current key */
 		wep_key = &priv->wep_key[index];
 		if (!wep_key->key_length) {
-			dev_err(priv->adapter->dev,
+			dev_err(adapter->dev,
 				"key not set, so cannot enable it\n");
 			return -1;
 		}
+
+		if (adapter->fw_key_api_major_ver == FW_KEY_API_VER_MAJOR_V2) {
+			memcpy(encrypt_key->key_material,
+			       wep_key->key_material, wep_key->key_length);
+			encrypt_key->key_len = wep_key->key_length;
+		}
+
 		priv->wep_key_curr_index = (u16) index;
 		priv->sec_info.wep_enabled = 1;
 	} else {
@@ -897,13 +905,25 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 		priv->sec_info.wep_enabled = 1;
 	}
 	if (wep_key->key_length) {
+		void *enc_key;
+
+		if (encrypt_key->key_disable)
+			memset(&priv->wep_key[index], 0,
+			       sizeof(struct mwifiex_wep_key));
+
+		if (adapter->fw_key_api_major_ver == FW_KEY_API_VER_MAJOR_V2)
+			enc_key = encrypt_key;
+		else
+			enc_key = NULL;
+
 		/* Send request to firmware */
 		ret = mwifiex_send_cmd_async(priv,
 					     HostCmd_CMD_802_11_KEY_MATERIAL,
-					     HostCmd_ACT_GEN_SET, 0, NULL);
+					     HostCmd_ACT_GEN_SET, 0, enc_key);
 		if (ret)
 			return ret;
 	}
+
 	if (priv->sec_info.wep_enabled)
 		priv->curr_pkt_filter |= HostCmd_ACT_MAC_WEP_ENABLE;
 	else
@@ -1044,19 +1064,27 @@ int mwifiex_set_encode(struct mwifiex_private *priv, struct key_params *kp,
 
 	memset(&encrypt_key, 0, sizeof(struct mwifiex_ds_encrypt_key));
 	encrypt_key.key_len = key_len;
+	encrypt_key.key_index = key_index;
 
 	if (kp && kp->cipher == WLAN_CIPHER_SUITE_AES_CMAC)
 		encrypt_key.is_igtk_key = true;
 
 	if (!disable) {
-		encrypt_key.key_index = key_index;
 		if (key_len)
 			memcpy(encrypt_key.key_material, key, key_len);
+		else
+			encrypt_key.is_current_wep_key = true;
+
 		if (mac_addr)
 			memcpy(encrypt_key.mac_addr, mac_addr, ETH_ALEN);
-		if (kp && kp->seq && kp->seq_len)
+		if (kp && kp->seq && kp->seq_len) {
 			memcpy(encrypt_key.pn, kp->seq, kp->seq_len);
+			encrypt_key.pn_len = kp->seq_len;
+			encrypt_key.is_rx_seq_valid = true;
+		}
 	} else {
+		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP)
+			return 0;
 		encrypt_key.key_disable = true;
 		if (mac_addr)
 			memcpy(encrypt_key.mac_addr, mac_addr, ETH_ALEN);
-- 
1.8.2.3

