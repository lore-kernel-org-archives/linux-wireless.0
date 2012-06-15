Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:36666 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757522Ab2FOTcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 15:32:48 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 5/5] mwifiex: support for WEP in AP mode
Date: Fri, 15 Jun 2012 12:21:55 -0700
Message-Id: <1339788115-20596-6-git-send-email-bzhao@marvell.com> (sfid-20120615_213252_058721_BCFD68AF)
In-Reply-To: <1339788115-20596-1-git-send-email-bzhao@marvell.com>
References: <1339788115-20596-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for WEP open/shared encryption in AP mode.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v3: newly addded to v3 series

 drivers/net/wireless/mwifiex/cfg80211.c |   30 ++++++++++++++-
 drivers/net/wireless/mwifiex/fw.h       |    8 ++++
 drivers/net/wireless/mwifiex/ioctl.h    |    9 ++++
 drivers/net/wireless/mwifiex/uap_cmd.c  |   62 +++++++++++++++++++++++++++++++
 4 files changed, 108 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 5af3f97..9c2e08e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -170,7 +170,9 @@ mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 	if (!priv->sec_info.wep_enabled)
 		return 0;
 
-	if (mwifiex_set_encode(priv, NULL, 0, key_index, NULL, 0)) {
+	if (priv->bss_type == MWIFIEX_BSS_TYPE_UAP) {
+		priv->wep_key_curr_index = key_index;
+	} else if (mwifiex_set_encode(priv, NULL, 0, key_index, NULL, 0)) {
 		wiphy_err(wiphy, "set default Tx key index\n");
 		return -EFAULT;
 	}
@@ -187,9 +189,25 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 			 struct key_params *params)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
+	struct mwifiex_wep_key *wep_key;
 	const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	const u8 *peer_mac = pairwise ? mac_addr : bc_mac;
 
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP &&
+	    (params->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+	     params->cipher == WLAN_CIPHER_SUITE_WEP104)) {
+		if (params->key && params->key_len) {
+			wep_key = &priv->wep_key[key_index];
+			memset(wep_key, 0, sizeof(struct mwifiex_wep_key));
+			memcpy(wep_key->key_material, params->key,
+			       params->key_len);
+			wep_key->key_index = key_index;
+			wep_key->key_length = params->key_len;
+			priv->sec_info.wep_enabled = 1;
+		}
+		return 0;
+	}
+
 	if (mwifiex_set_encode(priv, params->key, params->key_len,
 			       key_index, peer_mac, 0)) {
 		wiphy_err(wiphy, "crypto keys added\n");
@@ -1003,6 +1021,16 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		return -1;
 	}
 
+	if (priv->sec_info.wep_enabled)
+		priv->curr_pkt_filter |= HostCmd_ACT_MAC_WEP_ENABLE;
+	else
+		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_WEP_ENABLE;
+
+	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_MAC_CONTROL,
+				  HostCmd_ACT_GEN_SET, 0,
+				  &priv->curr_pkt_filter))
+		return -1;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 9686f6f..1184141 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -124,6 +124,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_UAP_DTIM_PERIOD    (PROPRIETARY_TLV_BASE_ID + 45)
 #define TLV_TYPE_UAP_BCAST_SSID     (PROPRIETARY_TLV_BASE_ID + 48)
 #define TLV_TYPE_UAP_RTS_THRESHOLD  (PROPRIETARY_TLV_BASE_ID + 51)
+#define TLV_TYPE_UAP_WEP_KEY        (PROPRIETARY_TLV_BASE_ID + 59)
 #define TLV_TYPE_UAP_WPA_PASSPHRASE (PROPRIETARY_TLV_BASE_ID + 60)
 #define TLV_TYPE_UAP_ENCRY_PROTOCOL (PROPRIETARY_TLV_BASE_ID + 64)
 #define TLV_TYPE_UAP_AKMP           (PROPRIETARY_TLV_BASE_ID + 65)
@@ -1201,6 +1202,13 @@ struct host_cmd_tlv_passphrase {
 	u8 passphrase[0];
 } __packed;
 
+struct host_cmd_tlv_wep_key {
+	struct host_cmd_tlv tlv;
+	u8 key_index;
+	u8 is_default;
+	u8 key[1];
+};
+
 struct host_cmd_tlv_auth_type {
 	struct host_cmd_tlv tlv;
 	u8 auth_type;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 8c8e47c..9f088fb 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -21,6 +21,7 @@
 #define _MWIFIEX_IOCTL_H_
 
 #include <net/mac80211.h>
+#include <net/lib80211.h>
 
 enum {
 	MWIFIEX_SCAN_TYPE_UNCHANGED = 0,
@@ -71,6 +72,13 @@ struct wpa_param {
 	u8 passphrase[MWIFIEX_WPA_PASSHPHRASE_LEN];
 };
 
+struct wep_key {
+	u8 key_index;
+	u8 is_default;
+	u16 length;
+	u8 key[WLAN_KEY_LEN_WEP104];
+};
+
 #define KEY_MGMT_ON_HOST        0x03
 #define MWIFIEX_AUTH_MODE_AUTO  0xFF
 #define BAND_CONFIG_MANUAL      0x00
@@ -90,6 +98,7 @@ struct mwifiex_uap_bss_param {
 	u16 key_mgmt;
 	u16 key_mgmt_operation;
 	struct wpa_param wpa_cfg;
+	struct wep_key wep_cfg[NUM_WEP_KEYS];
 	struct ieee80211_ht_cap ht_cap;
 };
 
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 4b39551..f40e93f 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -26,6 +26,7 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 			      struct mwifiex_uap_bss_param *bss_config,
 			      struct cfg80211_ap_settings *params) {
 	int i;
+	struct mwifiex_wep_key wep_key;
 
 	if (!params->privacy) {
 		bss_config->protocol = PROTOCOL_NO_SECURITY;
@@ -113,6 +114,27 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 	switch (params->crypto.cipher_group) {
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
+		if (priv->sec_info.wep_enabled) {
+			bss_config->protocol = PROTOCOL_STATIC_WEP;
+			bss_config->key_mgmt = KEY_MGMT_NONE;
+			bss_config->wpa_cfg.length = 0;
+
+			for (i = 0; i < NUM_WEP_KEYS; i++) {
+				wep_key = priv->wep_key[i];
+				bss_config->wep_cfg[i].key_index = i;
+
+				if (priv->wep_key_curr_index == i)
+					bss_config->wep_cfg[i].is_default = 1;
+				else
+					bss_config->wep_cfg[i].is_default = 0;
+
+				bss_config->wep_cfg[i].length =
+							     wep_key.key_length;
+				memcpy(&bss_config->wep_cfg[i].key,
+				       &wep_key.key_material,
+				       wep_key.key_length);
+			}
+		}
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		bss_config->wpa_cfg.group_cipher = CIPHER_TKIP;
@@ -247,6 +269,44 @@ mwifiex_uap_bss_wpa(u8 **tlv_buf, void *cmd_buf, u16 *param_size)
 }
 
 /* This function parses BSS related parameters from structure
+ * and prepares TLVs specific to WEP encryption.
+ * These TLVs are appended to command buffer.
+ */
+static void
+mwifiex_uap_bss_wep(u8 **tlv_buf, void *cmd_buf, u16 *param_size)
+{
+	struct host_cmd_tlv_wep_key *wep_key;
+	u16 cmd_size = *param_size;
+	int i;
+	u8 *tlv = *tlv_buf;
+	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
+
+	for (i = 0; i < NUM_WEP_KEYS; i++) {
+		if (bss_cfg->wep_cfg[i].length &&
+		    (bss_cfg->wep_cfg[i].length == WLAN_KEY_LEN_WEP40 ||
+		     bss_cfg->wep_cfg[i].length == WLAN_KEY_LEN_WEP104)) {
+			wep_key = (struct host_cmd_tlv_wep_key *)tlv;
+			wep_key->tlv.type = cpu_to_le16(TLV_TYPE_UAP_WEP_KEY);
+			wep_key->tlv.len =
+				cpu_to_le16(bss_cfg->wep_cfg[i].length + 2);
+			wep_key->key_index = bss_cfg->wep_cfg[i].key_index;
+			wep_key->is_default = bss_cfg->wep_cfg[i].is_default;
+			memcpy(wep_key->key, bss_cfg->wep_cfg[i].key,
+			       bss_cfg->wep_cfg[i].length);
+			cmd_size += sizeof(struct host_cmd_tlv) + 2 +
+				    bss_cfg->wep_cfg[i].length;
+			tlv += sizeof(struct host_cmd_tlv) + 2 +
+				    bss_cfg->wep_cfg[i].length;
+		}
+	}
+
+	*param_size = cmd_size;
+	*tlv_buf = tlv;
+
+	return;
+}
+
+/* This function parses BSS related parameters from structure
  * and prepares TLVs. These TLVs are appended to command buffer.
 */
 static int
@@ -354,6 +414,8 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	    (bss_cfg->protocol & PROTOCOL_WPA2) ||
 	    (bss_cfg->protocol & PROTOCOL_EAP))
 		mwifiex_uap_bss_wpa(&tlv, cmd_buf, &cmd_size);
+	else
+		mwifiex_uap_bss_wep(&tlv, cmd_buf, &cmd_size);
 
 	if ((bss_cfg->auth_mode <= WLAN_AUTH_SHARED_KEY) ||
 	    (bss_cfg->auth_mode == MWIFIEX_AUTH_MODE_AUTO)) {
-- 
1.7.0.2

