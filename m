Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4674 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1H3TBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:01:06 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 03/22] ath6kl: Delay initial group key setup in AP mode
Date: Tue, 30 Aug 2011 21:57:52 +0300
Message-ID: <1314730691-12089-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210109_603288_136C33CC)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The target is not ready to accept addkey commands until the connect
event has been delivered, so delay these operations for the initial GTK.
In addition, properly set interface connected and mark netdev ready when
the AP mode setup has been completed.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   31 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/core.h     |   25 ++++--------------
 drivers/net/wireless/ath/ath6kl/main.c     |   36 +++++++++++++++------------
 drivers/net/wireless/ath/ath6kl/wmi.c      |    4 +++
 4 files changed, 60 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 4752a76..faefc23 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -888,6 +888,26 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		   key_usage, key->seq_len);
 
 	ar->def_txkey_index = key_index;
+
+	if (ar->nw_type == AP_NETWORK && !pairwise &&
+	    (key_type == TKIP_CRYPT || key_type == AES_CRYPT) && params) {
+		ar->ap_mode_bkey.valid = true;
+		ar->ap_mode_bkey.key_index = key_index;
+		ar->ap_mode_bkey.key_type = key_type;
+		ar->ap_mode_bkey.key_len = key->key_len;
+		memcpy(ar->ap_mode_bkey.key, key->key, key->key_len);
+		if (!test_bit(CONNECTED, &ar->flag)) {
+			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delay initial group "
+				   "key configuration until AP mode has been "
+				   "started\n");
+			/*
+			 * The key will be set in ath6kl_connect_ap_mode() once
+			 * the connected event is received from the target.
+			 */
+			return 0;
+		}
+	}
+
 	status = ath6kl_wmi_addkey_cmd(ar->wmi, ar->def_txkey_index,
 				       key_type, key_usage, key->key_len,
 				       key->seq, key->key, KEY_OP_INIT_VAL,
@@ -997,6 +1017,9 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	if (ar->prwise_crypto == WEP_CRYPT)
 		key_usage |= TX_USAGE;
 
+	if (ar->nw_type == AP_NETWORK && !test_bit(CONNECTED, &ar->flag))
+		return 0; /* Delay until AP mode has been started */
+
 	status = ath6kl_wmi_addkey_cmd(ar->wmi, ar->def_txkey_index,
 				       ar->prwise_crypto, key_usage,
 				       key->key_len, key->seq, key->key,
@@ -1495,6 +1518,8 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	if (!add)
 		return 0;
 
+	ar->ap_mode_bkey.valid = false;
+
 	/* TODO:
 	 * info->interval
 	 * info->dtim_period
@@ -1580,7 +1605,11 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	p.dot11_auth_mode = ar->dot11_auth_mode;
 	p.ch = cpu_to_le16(ar->next_chan);
 
-	return ath6kl_wmi_ap_profile_commit(ar->wmi, &p);
+	res = ath6kl_wmi_ap_profile_commit(ar->wmi, &p);
+	if (res < 0)
+		return res;
+
+	return 0;
 }
 
 static int ath6kl_add_beacon(struct wiphy *wiphy, struct net_device *dev,
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 00d0add..f0b1dff 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -335,26 +335,13 @@ struct ath6kl_mbox_info {
 #define ATH6KL_KEY_RECV  0x02
 #define ATH6KL_KEY_DEFAULT   0x80	/* default xmit key */
 
-/*
- * WPA/RSN get/set key request.  Specify the key/cipher
- * type and whether the key is to be used for sending and/or
- * receiving.  The key index should be set only when working
- * with global keys (use IEEE80211_KEYIX_NONE for ``no index'').
- * Otherwise a unicast/pairwise key is specified by the bssid
- * (on a station) or mac address (on an ap).  They key length
- * must include any MIC key data; otherwise it should be no
- * more than ATH6KL_KEYBUF_SIZE.
- */
+/* Initial group key for AP mode */
 struct ath6kl_req_key {
-	u8 ik_type;	/* key/cipher type */
-	u8 ik_pad;
-	u16 ik_keyix;	/* key index */
-	u8 ik_keylen;	/* key length in bytes */
-	u8 ik_flags;
-	u8 ik_macaddr[ETH_ALEN];
-	u64 ik_keyrsc;	/* key receive sequence counter */
-	u64 ik_keytsc;	/* key transmit sequence counter */
-	u8 ik_keydata[ATH6KL_KEYBUF_SIZE + ATH6KL_MICBUF_SIZE];
+	bool valid;
+	u8 key_index;
+	int key_type;
+	u8 key[WLAN_MAX_KEY_LEN];
+	u8 key_len;
 };
 
 /* Flag info */
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 89e29ea..a19caec 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -437,11 +437,15 @@ static void ath6kl_connect_ap_mode(struct ath6kl *ar, u16 channel, u8 *bssid,
 	size_t ies_len = 0;
 	struct station_info sinfo;
 	struct ath6kl_req_key *ik;
-	enum crypto_type keyType = NONE_CRYPT;
+	int res;
+	u8 key_rsc[ATH6KL_KEY_SEQ_LEN];
 
 	if (memcmp(dev->dev_addr, bssid, ETH_ALEN) == 0) {
 		ik = &ar->ap_mode_bkey;
 
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "AP mode started on %u MHz\n",
+			   channel);
+
 		switch (ar->auth_mode) {
 		case NONE_AUTH:
 			if (ar->prwise_crypto == WEP_CRYPT)
@@ -450,26 +454,26 @@ static void ath6kl_connect_ap_mode(struct ath6kl *ar, u16 channel, u8 *bssid,
 		case WPA_PSK_AUTH:
 		case WPA2_PSK_AUTH:
 		case (WPA_PSK_AUTH|WPA2_PSK_AUTH):
-			switch (ik->ik_type) {
-			case ATH6KL_CIPHER_TKIP:
-				keyType = TKIP_CRYPT;
-				break;
-			case ATH6KL_CIPHER_AES_CCM:
-				keyType = AES_CRYPT;
+			if (!ik->valid)
 				break;
-			default:
-				goto skip_key;
+
+			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delayed addkey for "
+				   "the initial group key for AP mode\n");
+			memset(key_rsc, 0, sizeof(key_rsc));
+			res = ath6kl_wmi_addkey_cmd(
+				ar->wmi, ik->key_index, ik->key_type,
+				GROUP_USAGE, ik->key_len, key_rsc, ik->key,
+				KEY_OP_INIT_VAL, NULL, SYNC_BOTH_WMIFLAG);
+			if (res) {
+				ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delayed "
+					   "addkey failed: %d\n", res);
 			}
-			ath6kl_wmi_addkey_cmd(ar->wmi, ik->ik_keyix, keyType,
-					      GROUP_USAGE, ik->ik_keylen,
-					      (u8 *)&ik->ik_keyrsc,
-					      ik->ik_keydata,
-					      KEY_OP_INIT_VAL, ik->ik_macaddr,
-					      SYNC_BOTH_WMIFLAG);
 			break;
 		}
-skip_key:
+
+		ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
 		set_bit(CONNECTED, &ar->flag);
+		netif_carrier_on(ar->net_dev);
 		return;
 	}
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 0114a71..d587f84 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1764,6 +1764,10 @@ int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 key_index,
 	struct wmi_add_cipher_key_cmd *cmd;
 	int ret;
 
+	ath6kl_dbg(ATH6KL_DBG_WMI, "addkey cmd: key_index=%u key_type=%d "
+		   "key_usage=%d key_len=%d key_op_ctrl=%d\n",
+		   key_index, key_type, key_usage, key_len, key_op_ctrl);
+
 	if ((key_index > WMI_MAX_KEY_INDEX) || (key_len > WMI_MAX_KEY_LEN) ||
 	    (key_material == NULL))
 		return -EINVAL;
-- 
1.7.4.1

