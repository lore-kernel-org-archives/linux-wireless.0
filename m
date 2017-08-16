Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33659 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbdHPNSi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 09:18:38 -0400
Received: by mail-pf0-f194.google.com with SMTP id c65so1362281pfl.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Aug 2017 06:18:38 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 11/11] rsi: security enhancements for AP mode
Date: Wed, 16 Aug 2017 18:43:18 +0530
Message-Id: <1502889198-4478-12-git-send-email-amitkarwar@gmail.com> (sfid-20170816_151841_221304_40A13D81)
In-Reply-To: <1502889198-4478-1-git-send-email-amitkarwar@gmail.com>
References: <1502889198-4478-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Station id should be set in load key frame configured to device.
For WEP mode, key is configured once from mac80211. This key is
saved and configured to device every time a station is connected.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 60 +++++++++++++++++++++--------
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 10 ++++-
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 drivers/net/wireless/rsi/rsi_mgmt.h         |  3 +-
 4 files changed, 56 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index f2cb61f..8b983d0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -758,11 +758,14 @@ static int rsi_mac80211_conf_tx(struct ieee80211_hw *hw,
  */
 static int rsi_hal_key_config(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
-			      struct ieee80211_key_conf *key)
+			      struct ieee80211_key_conf *key,
+			      struct ieee80211_sta *sta)
 {
 	struct rsi_hw *adapter = hw->priv;
+	struct rsi_sta *rsta = NULL;
 	int status;
 	u8 key_type;
+	s16 sta_id = 0;
 
 	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
 		key_type = RSI_PAIRWISE_KEY;
@@ -772,23 +775,35 @@ static int rsi_hal_key_config(struct ieee80211_hw *hw,
 	rsi_dbg(ERR_ZONE, "%s: Cipher 0x%x key_type: %d key_len: %d\n",
 		__func__, key->cipher, key_type, key->keylen);
 
-	if ((key->cipher == WLAN_CIPHER_SUITE_WEP104) ||
-	    (key->cipher == WLAN_CIPHER_SUITE_WEP40)) {
-		status = rsi_hal_load_key(adapter->priv,
-					  key->key,
-					  key->keylen,
-					  RSI_PAIRWISE_KEY,
-					  key->keyidx,
-					  key->cipher);
-		if (status)
-			return status;
+	if (vif->type == NL80211_IFTYPE_AP) {
+		if (sta) {
+			rsta = rsi_find_sta(adapter->priv, sta->addr);
+			if (rsta)
+				sta_id = rsta->sta_id;
+		}
+		adapter->priv->key = key;
+	} else {
+		if ((key->cipher == WLAN_CIPHER_SUITE_WEP104) ||
+		    (key->cipher == WLAN_CIPHER_SUITE_WEP40)) {
+			status = rsi_hal_load_key(adapter->priv,
+						  key->key,
+						  key->keylen,
+						  RSI_PAIRWISE_KEY,
+						  key->keyidx,
+						  key->cipher,
+						  sta_id);
+			if (status)
+				return status;
+		}
 	}
+
 	return rsi_hal_load_key(adapter->priv,
 				key->key,
 				key->keylen,
 				key_type,
 				key->keyidx,
-				key->cipher);
+				key->cipher,
+				sta_id);
 }
 
 /**
@@ -816,7 +831,7 @@ static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
 	switch (cmd) {
 	case SET_KEY:
 		secinfo->security_enable = true;
-		status = rsi_hal_key_config(hw, vif, key);
+		status = rsi_hal_key_config(hw, vif, key, sta);
 		if (status) {
 			mutex_unlock(&common->mutex);
 			return status;
@@ -834,10 +849,11 @@ static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
 		break;
 
 	case DISABLE_KEY:
-		secinfo->security_enable = false;
+		if (vif->type == NL80211_IFTYPE_STATION)
+			secinfo->security_enable = false;
 		rsi_dbg(ERR_ZONE, "%s: RSI del key\n", __func__);
 		memset(key, 0, sizeof(struct ieee80211_key_conf));
-		status = rsi_hal_key_config(hw, vif, key);
+		status = rsi_hal_key_config(hw, vif, key, sta);
 		break;
 
 	default:
@@ -1242,6 +1258,20 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 			rsi_inform_bss_status(common, AP_OPMODE, 1, sta->addr,
 					      sta->wme, sta->aid, sta, sta_idx);
 
+			if (common->key) {
+				struct ieee80211_key_conf *key = common->key;
+
+				if ((key->cipher == WLAN_CIPHER_SUITE_WEP104) ||
+				    (key->cipher == WLAN_CIPHER_SUITE_WEP40))
+					rsi_hal_load_key(adapter->priv,
+							 key->key,
+							 key->keylen,
+							 RSI_PAIRWISE_KEY,
+							 key->keyidx,
+							 key->cipher,
+							 sta_idx);
+			}
+
 			common->num_stations++;
 		}
 	}
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 2d3cae5..f7b550f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -715,8 +715,10 @@ int rsi_hal_load_key(struct rsi_common *common,
 		     u16 key_len,
 		     u8 key_type,
 		     u8 key_id,
-		     u32 cipher)
+		     u32 cipher,
+		     s16 sta_id)
 {
+	struct ieee80211_vif *vif = common->priv->vifs[0];
 	struct sk_buff *skb = NULL;
 	struct rsi_set_key *set_key;
 	u16 key_descriptor = 0;
@@ -734,8 +736,11 @@ int rsi_hal_load_key(struct rsi_common *common,
 	memset(skb->data, 0, frame_len);
 	set_key = (struct rsi_set_key *)skb->data;
 
-	if (key_type == RSI_GROUP_KEY)
+	if (key_type == RSI_GROUP_KEY) {
 		key_descriptor = RSI_KEY_TYPE_BROADCAST;
+		if (vif->type == NL80211_IFTYPE_AP)
+			key_descriptor |= RSI_KEY_MODE_AP;
+	}
 	if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
 	    (cipher == WLAN_CIPHER_SUITE_WEP104)) {
 		key_id = 0;
@@ -754,6 +759,7 @@ int rsi_hal_load_key(struct rsi_common *common,
 			(frame_len - FRAME_DESC_SZ), RSI_WIFI_MGMT_Q);
 	set_key->desc_dword0.frame_type = SET_KEY_REQ;
 	set_key->key_desc = cpu_to_le16(key_descriptor);
+	set_key->sta_id = sta_id;
 
 	if (data) {
 		if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 169e2f9..2c18dde 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -269,6 +269,7 @@ struct rsi_common {
 	struct rsi_sta stations[RSI_MAX_ASSOC_STAS + 1];
 	int num_stations;
 	int max_stations;
+	struct ieee80211_key_conf *key;
 };
 
 enum host_intf {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 2d82733..c6e1fa6 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -409,6 +409,7 @@ struct rsi_dynamic_s {
 #define RSI_WEP_KEY_104		BIT(3)
 #define RSI_CIPHER_WPA		BIT(4)
 #define RSI_CIPHER_TKIP		BIT(5)
+#define RSI_KEY_MODE_AP		BIT(7)
 #define RSI_PROTECT_DATA_FRAMES	BIT(13)
 #define RSI_KEY_ID_MASK		0xC0
 #define RSI_KEY_ID_OFFSET	14
@@ -612,7 +613,7 @@ int rsi_send_aggregation_params_frame(struct rsi_common *common, u16 tid,
 				      u16 ssn, u8 buf_size, u8 event,
 				      u8 sta_id);
 int rsi_hal_load_key(struct rsi_common *common, u8 *data, u16 key_len,
-		     u8 key_type, u8 key_id, u32 cipher);
+		     u8 key_type, u8 key_id, u32 cipher, s16 sta_id);
 int rsi_set_channel(struct rsi_common *common,
 		    struct ieee80211_channel *channel);
 int rsi_send_vap_dynamic_update(struct rsi_common *common);
-- 
2.7.4
