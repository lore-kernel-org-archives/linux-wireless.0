Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:48241 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab0L3TX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 14:23:58 -0500
Received: by pxi15 with SMTP id 15so2076985pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 11:23:58 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, mwl8k-devel@cozybit.com,
	Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 4/4 V2] mwl8k: Enable HW encryption for AP mode
Date: Thu, 30 Dec 2010 11:23:34 -0800
Message-Id: <1293737014-11718-4-git-send-email-thomas@cozybit.com>
In-Reply-To: <1293737014-11718-1-git-send-email-thomas@cozybit.com>
References: <1293737014-11718-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

set_key callback is defined for mac80211 to install keys for HW crypto in AP
mode. Driver currently falls back to SW crypto in STA mode.  Add support to
configure the keys appropriately in the hardware after the set_key routine is
called.

V2:
- Tell mac80211 to provide crypto padding in mwl8k_set_key() (Yogesh)

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |  280 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 277 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 2b76bbc..809f2bf 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -259,6 +259,7 @@ struct mwl8k_vif {
 	bool is_hw_crypto_enabled;
 };
 #define MWL8K_VIF(_vif) ((struct mwl8k_vif *)&((_vif)->drv_priv))
+#define IEEE80211_KEY_CONF(_u8) ((struct ieee80211_key_conf *)(_u8))
 
 struct mwl8k_sta {
 	/* Index into station database. Returned by UPDATE_STADB.  */
@@ -352,6 +353,7 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 #define MWL8K_CMD_SET_RATEADAPT_MODE	0x0203
 #define MWL8K_CMD_BSS_START		0x1100		/* per-vif */
 #define MWL8K_CMD_SET_NEW_STN		0x1111		/* per-vif */
+#define MWL8K_CMD_UPDATE_ENCRYPTION	0x1122		/* per-vif */
 #define MWL8K_CMD_UPDATE_STADB		0x1123
 
 static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
@@ -390,6 +392,7 @@ static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
 		MWL8K_CMDNAME(SET_RATEADAPT_MODE);
 		MWL8K_CMDNAME(BSS_START);
 		MWL8K_CMDNAME(SET_NEW_STN);
+		MWL8K_CMDNAME(UPDATE_ENCRYPTION);
 		MWL8K_CMDNAME(UPDATE_STADB);
 	default:
 		snprintf(buf, bufsize, "0x%x", cmd);
@@ -3241,6 +3244,274 @@ static int mwl8k_cmd_set_new_stn_del(struct ieee80211_hw *hw,
 }
 
 /*
+ * CMD_UPDATE_ENCRYPTION.
+ */
+
+#define MAX_ENCR_KEY_LENGTH	16
+#define MIC_KEY_LENGTH		8
+
+struct mwl8k_cmd_update_encryption {
+	struct mwl8k_cmd_pkt header;
+
+	__le32 action;
+	__le32 reserved;
+	__u8 mac_addr[6];
+	__u8 encr_type;
+
+} __attribute__((packed));
+
+struct mwl8k_cmd_set_key {
+	struct mwl8k_cmd_pkt header;
+
+	__le32 action;
+	__le32 reserved;
+	__le16 length;
+	__le16 key_type_id;
+	__le32 key_info;
+	__le32 key_id;
+	__le16 key_len;
+	__u8 key_material[MAX_ENCR_KEY_LENGTH];
+	__u8 tkip_tx_mic_key[MIC_KEY_LENGTH];
+	__u8 tkip_rx_mic_key[MIC_KEY_LENGTH];
+	__le16 tkip_rsc_low;
+	__le32 tkip_rsc_high;
+	__le16 tkip_tsc_low;
+	__le32 tkip_tsc_high;
+	__u8 mac_addr[6];
+} __attribute__((packed));
+
+enum {
+	MWL8K_ENCR_ENABLE,
+	MWL8K_ENCR_SET_KEY,
+	MWL8K_ENCR_REMOVE_KEY,
+	MWL8K_ENCR_SET_GROUP_KEY,
+};
+
+#define MWL8K_UPDATE_ENCRYPTION_TYPE_WEP	0
+#define MWL8K_UPDATE_ENCRYPTION_TYPE_DISABLE	1
+#define MWL8K_UPDATE_ENCRYPTION_TYPE_TKIP	4
+#define MWL8K_UPDATE_ENCRYPTION_TYPE_MIXED	7
+#define MWL8K_UPDATE_ENCRYPTION_TYPE_AES	8
+
+enum {
+	MWL8K_ALG_WEP,
+	MWL8K_ALG_TKIP,
+	MWL8K_ALG_CCMP,
+};
+
+#define MWL8K_KEY_FLAG_TXGROUPKEY	0x00000004
+#define MWL8K_KEY_FLAG_PAIRWISE		0x00000008
+#define MWL8K_KEY_FLAG_TSC_VALID	0x00000040
+#define MWL8K_KEY_FLAG_WEP_TXKEY	0x01000000
+#define MWL8K_KEY_FLAG_MICKEY_VALID	0x02000000
+
+static int mwl8k_cmd_update_encryption_enable(struct ieee80211_hw *hw,
+					      struct ieee80211_vif *vif,
+					      u8 *addr,
+					      u8 encr_type)
+{
+	struct mwl8k_cmd_update_encryption *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_UPDATE_ENCRYPTION);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->action = cpu_to_le32(MWL8K_ENCR_ENABLE);
+	memcpy(cmd->mac_addr, addr, ETH_ALEN);
+	cmd->encr_type = encr_type;
+
+	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+static int mwl8k_encryption_set_cmd_info(struct mwl8k_cmd_set_key *cmd,
+						u8 *addr,
+						struct ieee80211_key_conf *key)
+{
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_UPDATE_ENCRYPTION);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->length = cpu_to_le16(sizeof(*cmd) -
+				offsetof(struct mwl8k_cmd_set_key, length));
+	cmd->key_id = cpu_to_le32(key->keyidx);
+	cmd->key_len = cpu_to_le16(key->keylen);
+	memcpy(cmd->mac_addr, addr, ETH_ALEN);
+
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		cmd->key_type_id = cpu_to_le16(MWL8K_ALG_WEP);
+		if (key->keyidx == 0)
+			cmd->key_info =	cpu_to_le32(MWL8K_KEY_FLAG_WEP_TXKEY);
+
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		cmd->key_type_id = cpu_to_le16(MWL8K_ALG_TKIP);
+		cmd->key_info =	(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
+			? cpu_to_le32(MWL8K_KEY_FLAG_PAIRWISE)
+			: cpu_to_le32(MWL8K_KEY_FLAG_TXGROUPKEY);
+		cmd->key_info |= cpu_to_le32(MWL8K_KEY_FLAG_MICKEY_VALID
+						| MWL8K_KEY_FLAG_TSC_VALID);
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		cmd->key_type_id = cpu_to_le16(MWL8K_ALG_CCMP);
+		cmd->key_info =	(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
+			? cpu_to_le32(MWL8K_KEY_FLAG_PAIRWISE)
+			: cpu_to_le32(MWL8K_KEY_FLAG_TXGROUPKEY);
+		break;
+	default:
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static int mwl8k_cmd_encryption_set_key(struct ieee80211_hw *hw,
+						struct ieee80211_vif *vif,
+						u8 *addr,
+						struct ieee80211_key_conf *key)
+{
+	struct mwl8k_cmd_set_key *cmd;
+	int rc;
+	int keymlen;
+	u32 action;
+	u8 idx;
+	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	rc = mwl8k_encryption_set_cmd_info(cmd, addr, key);
+	if (rc < 0)
+		goto done;
+
+	idx = key->keyidx;
+
+	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
+		action = MWL8K_ENCR_SET_KEY;
+	else
+		action = MWL8K_ENCR_SET_GROUP_KEY;
+
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		if (!mwl8k_vif->wep_key_conf[idx].enabled) {
+			memcpy(mwl8k_vif->wep_key_conf[idx].key, key,
+						sizeof(*key) + key->keylen);
+			mwl8k_vif->wep_key_conf[idx].enabled = 1;
+		}
+
+		keymlen = 0;
+		action = MWL8K_ENCR_SET_KEY;
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		keymlen = MAX_ENCR_KEY_LENGTH + 2 * MIC_KEY_LENGTH;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		keymlen = key->keylen;
+		break;
+	default:
+		rc = -ENOTSUPP;
+		goto done;
+	}
+
+	memcpy(cmd->key_material, key->key, keymlen);
+	cmd->action = cpu_to_le32(action);
+
+	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
+done:
+	kfree(cmd);
+
+	return rc;
+}
+
+static int mwl8k_cmd_encryption_remove_key(struct ieee80211_hw *hw,
+						struct ieee80211_vif *vif,
+						u8 *addr,
+						struct ieee80211_key_conf *key)
+{
+	struct mwl8k_cmd_set_key *cmd;
+	int rc;
+	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	rc = mwl8k_encryption_set_cmd_info(cmd, addr, key);
+	if (rc < 0)
+		goto done;
+
+	if (key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+			WLAN_CIPHER_SUITE_WEP104)
+		mwl8k_vif->wep_key_conf[key->keyidx].enabled = 0;
+
+	cmd->action = cpu_to_le32(MWL8K_ENCR_REMOVE_KEY);
+
+	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
+done:
+	kfree(cmd);
+
+	return rc;
+}
+
+static int mwl8k_set_key(struct ieee80211_hw *hw,
+			 enum set_key_cmd cmd_param,
+			 struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta,
+			 struct ieee80211_key_conf *key)
+{
+	int rc = 0;
+	u8 encr_type;
+	u8 *addr;
+	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
+
+	if (vif->type == NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	if (sta == NULL)
+		addr = hw->wiphy->perm_addr;
+	else
+		addr = sta->addr;
+
+	if (cmd_param == SET_KEY) {
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		rc = mwl8k_cmd_encryption_set_key(hw, vif, addr, key);
+		if (rc)
+			goto out;
+
+		if ((key->cipher == WLAN_CIPHER_SUITE_WEP40)
+				|| (key->cipher == WLAN_CIPHER_SUITE_WEP104))
+			encr_type = MWL8K_UPDATE_ENCRYPTION_TYPE_WEP;
+		else
+			encr_type = MWL8K_UPDATE_ENCRYPTION_TYPE_MIXED;
+
+		rc = mwl8k_cmd_update_encryption_enable(hw, vif, addr,
+								encr_type);
+		if (rc)
+			goto out;
+
+		mwl8k_vif->is_hw_crypto_enabled = true;
+
+	} else {
+		rc = mwl8k_cmd_encryption_remove_key(hw, vif, addr, key);
+
+		if (rc)
+			goto out;
+
+		mwl8k_vif->is_hw_crypto_enabled = false;
+
+	}
+out:
+	return rc;
+}
+
+/*
  * CMD_UPDATE_STADB.
  */
 struct ewc_ht_info {
@@ -4010,17 +4281,19 @@ static int mwl8k_sta_add(struct ieee80211_hw *hw,
 {
 	struct mwl8k_priv *priv = hw->priv;
 	int ret;
+	int i;
+	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
+	struct ieee80211_key_conf *key;
 
 	if (!priv->ap_fw) {
 		ret = mwl8k_cmd_update_stadb_add(hw, vif, sta);
 		if (ret >= 0) {
 			MWL8K_STA(sta)->peer_id = ret;
-			return 0;
+			ret = 0;
 		}
 
 	} else {
 		ret = mwl8k_cmd_set_new_stn_add(hw, vif, sta);
-		return ret;
 	}
 
 	for (i = 0; i < NUM_WEP_KEYS; i++) {
@@ -4028,7 +4301,7 @@ static int mwl8k_sta_add(struct ieee80211_hw *hw,
 		if (mwl8k_vif->wep_key_conf[i].enabled)
 			mwl8k_set_key(hw, SET_KEY, vif, sta, key);
 	}
-	return mwl8k_cmd_set_new_stn_add(hw, vif, sta);
+	return ret;
 }
 
 static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
@@ -4106,6 +4379,7 @@ static const struct ieee80211_ops mwl8k_ops = {
 	.bss_info_changed	= mwl8k_bss_info_changed,
 	.prepare_multicast	= mwl8k_prepare_multicast,
 	.configure_filter	= mwl8k_configure_filter,
+	.set_key                = mwl8k_set_key,
 	.set_rts_threshold	= mwl8k_set_rts_threshold,
 	.sta_add		= mwl8k_sta_add,
 	.sta_remove		= mwl8k_sta_remove,
-- 
1.7.0.4

