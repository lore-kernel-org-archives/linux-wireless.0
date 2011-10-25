Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18046 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab1JYOF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:05:27 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 11/31] ath6kl: Move key information to vif structure
Date: Tue, 25 Oct 2011 19:34:06 +0530
Message-ID: <1319551466-29070-12-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160529_624040_2BFC2B53)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   21 ++++++++++++---------
 drivers/net/wireless/ath/ath6kl/core.h     |    4 ++--
 drivers/net/wireless/ath/ath6kl/init.c     |    5 +++--
 drivers/net/wireless/ath/ath6kl/main.c     |    8 ++++----
 4 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 76a6116..19d719b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -419,7 +419,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 			return -ENOENT;
 		}
 
-		key = &ar->keys[sme->key_idx];
+		key = &vif->keys[sme->key_idx];
 		key->key_len = sme->key_len;
 		memcpy(key->key, sme->key, key->key_len);
 		key->cipher = vif->prwise_crypto;
@@ -856,7 +856,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		return -ENOENT;
 	}
 
-	key = &ar->keys[key_index];
+	key = &vif->keys[key_index];
 	memset(key, 0, sizeof(struct ath6kl_key));
 
 	if (pairwise)
@@ -934,8 +934,9 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		 */
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delay WEP key configuration "
 			   "until AP mode has been started\n");
-		ar->wep_key_list[key_index].key_len = key->key_len;
-		memcpy(ar->wep_key_list[key_index].key, key->key, key->key_len);
+		vif->wep_key_list[key_index].key_len = key->key_len;
+		memcpy(vif->wep_key_list[key_index].key, key->key,
+		       key->key_len);
 		return 0;
 	}
 
@@ -955,6 +956,7 @@ static int ath6kl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 				   const u8 *mac_addr)
 {
 	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
+	struct ath6kl_vif *vif = netdev_priv(ndev);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: index %d\n", __func__, key_index);
 
@@ -968,13 +970,13 @@ static int ath6kl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 		return -ENOENT;
 	}
 
-	if (!ar->keys[key_index].key_len) {
+	if (!vif->keys[key_index].key_len) {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 			   "%s: index %d is empty\n", __func__, key_index);
 		return 0;
 	}
 
-	ar->keys[key_index].key_len = 0;
+	vif->keys[key_index].key_len = 0;
 
 	return ath6kl_wmi_deletekey_cmd(ar->wmi, key_index);
 }
@@ -986,6 +988,7 @@ static int ath6kl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 						     struct key_params *))
 {
 	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
+	struct ath6kl_vif *vif = netdev_priv(ndev);
 	struct ath6kl_key *key = NULL;
 	struct key_params params;
 
@@ -1001,7 +1004,7 @@ static int ath6kl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 		return -ENOENT;
 	}
 
-	key = &ar->keys[key_index];
+	key = &vif->keys[key_index];
 	memset(&params, 0, sizeof(params));
 	params.cipher = key->cipher;
 	params.key_len = key->key_len;
@@ -1038,14 +1041,14 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 		return -ENOENT;
 	}
 
-	if (!ar->keys[key_index].key_len) {
+	if (!vif->keys[key_index].key_len) {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: invalid key index %d\n",
 			   __func__, key_index);
 		return -EINVAL;
 	}
 
 	vif->def_txkey_index = key_index;
-	key = &ar->keys[vif->def_txkey_index];
+	key = &vif->keys[vif->def_txkey_index];
 	key_usage = GROUP_USAGE;
 	if (vif->prwise_crypto == WEP_CRYPT)
 		key_usage |= TX_USAGE;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index ab33244..dc21d7a 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -413,6 +413,8 @@ struct ath6kl_vif {
 	u8 req_bssid[ETH_ALEN];
 	u16 ch_hint;
 	u16 bss_ch;
+	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
+	struct ath6kl_key keys[WMI_MAX_KEY_INDEX + 1];
 };
 
 /* Flag info */
@@ -441,7 +443,6 @@ struct ath6kl {
 	struct ath6kl_vif *vif;
 	spinlock_t lock;
 	struct semaphore sem;
-	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
 	u16 listen_intvl_b;
 	u16 listen_intvl_t;
 	u8 lrssi_roam_threshold;
@@ -480,7 +481,6 @@ struct ath6kl {
 	u8 rx_meta_ver;
 	struct wireless_dev *wdev;
 	struct cfg80211_scan_request *scan_req;
-	struct ath6kl_key keys[WMI_MAX_KEY_INDEX + 1];
 	enum sme_state sme_state;
 	enum wlan_low_pwr_state wlan_pwr_state;
 	struct wmi_scan_params_cmd sc_params;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 09125cc..a26faae 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -87,7 +87,7 @@ void ath6kl_init_profile_info(struct ath6kl *ar)
 	vif->prwise_crypto_len = 0;
 	vif->grp_crypto = NONE_CRYPT;
 	vif->grp_crypto_len = 0;
-	memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
+	memset(vif->wep_key_list, 0, sizeof(vif->wep_key_list));
 	memset(vif->req_bssid, 0, sizeof(vif->req_bssid));
 	memset(vif->bssid, 0, sizeof(vif->bssid));
 	vif->bss_ch = 0;
@@ -248,11 +248,12 @@ static int ath6kl_init_service_ep(struct ath6kl *ar)
 
 void ath6kl_init_control_info(struct ath6kl *ar)
 {
+	/* TODO: Findout vif */
 	struct ath6kl_vif *vif = ar->vif;
 
 	ath6kl_init_profile_info(ar);
 	vif->def_txkey_index = 0;
-	memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
+	memset(vif->wep_key_list, 0, sizeof(vif->wep_key_list));
 	vif->ch_hint = 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 15838de..eb2137c 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -506,7 +506,7 @@ static void ath6kl_install_static_wep_keys(struct ath6kl *ar)
 	u8 keyusage;
 
 	for (index = WMI_MIN_KEY_INDEX; index <= WMI_MAX_KEY_INDEX; index++) {
-		if (ar->wep_key_list[index].key_len) {
+		if (vif->wep_key_list[index].key_len) {
 			keyusage = GROUP_USAGE;
 			if (index == vif->def_txkey_index)
 				keyusage |= TX_USAGE;
@@ -515,9 +515,9 @@ static void ath6kl_install_static_wep_keys(struct ath6kl *ar)
 					      index,
 					      WEP_CRYPT,
 					      keyusage,
-					      ar->wep_key_list[index].key_len,
+					      vif->wep_key_list[index].key_len,
 					      NULL,
-					      ar->wep_key_list[index].key,
+					      vif->wep_key_list[index].key,
 					      KEY_OP_INIT_VAL, NULL,
 					      NO_SYNC_WMIFLAG);
 		}
@@ -1384,7 +1384,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 		}
 
 		if (memcmp(ar->net_dev->dev_addr, bssid, ETH_ALEN) == 0) {
-			memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
+			memset(vif->wep_key_list, 0, sizeof(vif->wep_key_list));
 			clear_bit(CONNECTED, &vif->flags);
 		}
 		return;
-- 
1.7.0.4

