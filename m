Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:49947 "HELO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753822Ab2EIBdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 21:33:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 06/18] mwifiex: append peer mac address TLV in key material command to firmware
Date: Tue,  8 May 2012 18:30:18 -0700
Message-Id: <1336527030-2045-7-git-send-email-bzhao@marvell.com> (sfid-20120509_033314_853503_761BDAFF)
In-Reply-To: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
References: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Modify key related cfg80211 handlers to copy peer mac address for
pairwise keys. If peer mac address is not present or group keys,
it will be sent as broadcast mac address.
This would be required since hostapd downloads per peer PTK.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   14 +++++++++-----
 drivers/net/wireless/mwifiex/fw.h        |   11 +++++++++++
 drivers/net/wireless/mwifiex/main.h      |    3 ++-
 drivers/net/wireless/mwifiex/sta_cmd.c   |   20 ++++++++++++++++++--
 drivers/net/wireless/mwifiex/sta_ioctl.c |    7 ++++++-
 5 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ff627e1..e09f0c2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -97,8 +97,10 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 			 u8 key_index, bool pairwise, const u8 *mac_addr)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
+	const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	const u8 *peer_mac = pairwise ? mac_addr : bc_mac;
 
-	if (mwifiex_set_encode(priv, NULL, 0, key_index, 1)) {
+	if (mwifiex_set_encode(priv, NULL, 0, key_index, peer_mac, 1)) {
 		wiphy_err(wiphy, "deleting the crypto keys\n");
 		return -EFAULT;
 	}
@@ -168,7 +170,7 @@ mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 	if (!priv->sec_info.wep_enabled)
 		return 0;
 
-	if (mwifiex_set_encode(priv, NULL, 0, key_index, 0)) {
+	if (mwifiex_set_encode(priv, NULL, 0, key_index, NULL, 0)) {
 		wiphy_err(wiphy, "set default Tx key index\n");
 		return -EFAULT;
 	}
@@ -185,9 +187,11 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 			 struct key_params *params)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
+	const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	const u8 *peer_mac = pairwise ? mac_addr : bc_mac;
 
 	if (mwifiex_set_encode(priv, params->key, params->key_len,
-			       key_index, 0)) {
+			       key_index, peer_mac, 0)) {
 		wiphy_err(wiphy, "crypto keys added\n");
 		return -EFAULT;
 	}
@@ -947,7 +951,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	priv->wep_key_curr_index = 0;
 	priv->sec_info.encryption_mode = 0;
 	priv->sec_info.is_authtype_auto = 0;
-	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);
+	ret = mwifiex_set_encode(priv, NULL, 0, 0, NULL, 1);
 
 	if (mode == NL80211_IFTYPE_ADHOC) {
 		/* "privacy" is set only for ad-hoc mode */
@@ -995,7 +999,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 				" with key len %d\n", sme->key_len);
 			priv->wep_key_curr_index = sme->key_idx;
 			ret = mwifiex_set_encode(priv, sme->key, sme->key_len,
-							sme->key_idx, 0);
+						 sme->key_idx, NULL, 0);
 		}
 	}
 done:
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 5f6adeb..3996918 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -104,6 +104,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_TSFTIMESTAMP       (PROPRIETARY_TLV_BASE_ID + 19)
 #define TLV_TYPE_RSSI_HIGH          (PROPRIETARY_TLV_BASE_ID + 22)
 #define TLV_TYPE_AUTH_TYPE          (PROPRIETARY_TLV_BASE_ID + 31)
+#define TLV_TYPE_STA_MAC_ADDR       (PROPRIETARY_TLV_BASE_ID + 32)
 #define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
 #define TLV_TYPE_RATE_DROP_CONTROL  (PROPRIETARY_TLV_BASE_ID + 82)
 #define TLV_TYPE_RATE_SCOPE         (PROPRIETARY_TLV_BASE_ID + 83)
@@ -1103,6 +1104,16 @@ struct host_cmd_ds_802_11_eeprom_access {
 	u8 value;
 } __packed;
 
+struct host_cmd_tlv {
+	__le16 type;
+	__le16 len;
+} __packed;
+
+struct host_cmd_tlv_mac_addr {
+	struct host_cmd_tlv tlv;
+	u8 mac_addr[ETH_ALEN];
+} __packed;
+
 struct host_cmd_ds_802_11_rf_channel {
 	__le16 action;
 	__le16 current_channel;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e324e29..ed978de 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -935,7 +935,8 @@ int mwifiex_set_radio(struct mwifiex_private *priv, u8 option);
 int mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, u16 channel);
 
 int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
-		       int key_len, u8 key_index, int disable);
+		       int key_len, u8 key_index, const u8 *mac_addr,
+		       int disable);
 
 int mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len);
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 3697aaa..40e025d 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -498,7 +498,8 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_802_11_key_material *key_material =
 		&cmd->params.key_material;
-	u16 key_param_len = 0;
+	struct host_cmd_tlv_mac_addr *tlv_mac;
+	u16 key_param_len = 0, cmd_size;
 	int ret = 0;
 	const u8 bc_mac[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
@@ -614,11 +615,26 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 			cpu_to_le16((u16) enc_key->key_len +
 				    KEYPARAMSET_FIXED_LEN);
 
-		key_param_len = (u16) (enc_key->key_len + KEYPARAMSET_FIXED_LEN)
+		key_param_len = (u16)(enc_key->key_len + KEYPARAMSET_FIXED_LEN)
 				+ sizeof(struct mwifiex_ie_types_header);
 
 		cmd->size = cpu_to_le16(sizeof(key_material->action) + S_DS_GEN
 					+ key_param_len);
+
+		if (priv->bss_type == MWIFIEX_BSS_TYPE_UAP) {
+			tlv_mac = (void *)((u8 *)&key_material->key_param_set +
+					   key_param_len);
+			tlv_mac->tlv.type = cpu_to_le16(TLV_TYPE_STA_MAC_ADDR);
+			tlv_mac->tlv.len = cpu_to_le16(ETH_ALEN);
+			memcpy(tlv_mac->mac_addr, enc_key->mac_addr, ETH_ALEN);
+			cmd_size = key_param_len + S_DS_GEN +
+				   sizeof(key_material->action) +
+				   sizeof(struct host_cmd_tlv_mac_addr);
+		} else {
+			cmd_size = key_param_len + S_DS_GEN +
+				   sizeof(key_material->action);
+		}
+		cmd->size = cpu_to_le16(cmd_size);
 	}
 
 	return ret;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 9265e42..106c449 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1219,7 +1219,8 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
  * with requisite parameters and calls the IOCTL handler.
  */
 int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
-			int key_len, u8 key_index, int disable)
+			int key_len, u8 key_index,
+			const u8 *mac_addr, int disable)
 {
 	struct mwifiex_ds_encrypt_key encrypt_key;
 
@@ -1229,8 +1230,12 @@ int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
 		encrypt_key.key_index = key_index;
 		if (key_len)
 			memcpy(encrypt_key.key_material, key, key_len);
+		if (mac_addr)
+			memcpy(encrypt_key.mac_addr, mac_addr, ETH_ALEN);
 	} else {
 		encrypt_key.key_disable = true;
+		if (mac_addr)
+			memcpy(encrypt_key.mac_addr, mac_addr, ETH_ALEN);
 	}
 
 	return mwifiex_sec_ioctl_encrypt_key(priv, &encrypt_key);
-- 
1.7.0.2

