Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11269 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab1JYOE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:04:58 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 07/31] ath6kl: Move ssid and crypto information to vif structure
Date: Tue, 25 Oct 2011 19:34:02 +0530
Message-ID: <1319551466-29070-8-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160501_688743_314A441B)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  175 +++++++++++++++-------------
 drivers/net/wireless/ath/ath6kl/core.h     |   18 ++--
 drivers/net/wireless/ath/ath6kl/init.c     |   25 +++--
 drivers/net/wireless/ath/ath6kl/main.c     |    8 +-
 4 files changed, 125 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index fed31cf..f9732f7 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -126,14 +126,17 @@ static struct ieee80211_supported_band ath6kl_band_5ghz = {
 static int ath6kl_set_wpa_version(struct ath6kl *ar,
 				  enum nl80211_wpa_versions wpa_version)
 {
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
+
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: %u\n", __func__, wpa_version);
 
 	if (!wpa_version) {
-		ar->auth_mode = NONE_AUTH;
+		vif->auth_mode = NONE_AUTH;
 	} else if (wpa_version & NL80211_WPA_VERSION_2) {
-		ar->auth_mode = WPA2_AUTH;
+		vif->auth_mode = WPA2_AUTH;
 	} else if (wpa_version & NL80211_WPA_VERSION_1) {
-		ar->auth_mode = WPA_AUTH;
+		vif->auth_mode = WPA_AUTH;
 	} else {
 		ath6kl_err("%s: %u not supported\n", __func__, wpa_version);
 		return -ENOTSUPP;
@@ -145,22 +148,24 @@ static int ath6kl_set_wpa_version(struct ath6kl *ar,
 static int ath6kl_set_auth_type(struct ath6kl *ar,
 				enum nl80211_auth_type auth_type)
 {
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: 0x%x\n", __func__, auth_type);
 
 	switch (auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
-		ar->dot11_auth_mode = OPEN_AUTH;
+		vif->dot11_auth_mode = OPEN_AUTH;
 		break;
 	case NL80211_AUTHTYPE_SHARED_KEY:
-		ar->dot11_auth_mode = SHARED_AUTH;
+		vif->dot11_auth_mode = SHARED_AUTH;
 		break;
 	case NL80211_AUTHTYPE_NETWORK_EAP:
-		ar->dot11_auth_mode = LEAP_AUTH;
+		vif->dot11_auth_mode = LEAP_AUTH;
 		break;
 
 	case NL80211_AUTHTYPE_AUTOMATIC:
-		ar->dot11_auth_mode = OPEN_AUTH | SHARED_AUTH;
+		vif->dot11_auth_mode = OPEN_AUTH | SHARED_AUTH;
 		break;
 
 	default:
@@ -173,9 +178,12 @@ static int ath6kl_set_auth_type(struct ath6kl *ar,
 
 static int ath6kl_set_cipher(struct ath6kl *ar, u32 cipher, bool ucast)
 {
-	u8 *ar_cipher = ucast ? &ar->prwise_crypto : &ar->grp_crypto;
-	u8 *ar_cipher_len = ucast ? &ar->prwise_crypto_len :
-		&ar->grp_crypto_len;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
+
+	u8 *ar_cipher = ucast ? &vif->prwise_crypto : &vif->grp_crypto;
+	u8 *ar_cipher_len = ucast ? &vif->prwise_crypto_len :
+		&vif->grp_crypto_len;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: cipher 0x%x, ucast %u\n",
 		   __func__, cipher, ucast);
@@ -212,20 +220,23 @@ static int ath6kl_set_cipher(struct ath6kl *ar, u32 cipher, bool ucast)
 
 static void ath6kl_set_key_mgmt(struct ath6kl *ar, u32 key_mgmt)
 {
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
+
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: 0x%x\n", __func__, key_mgmt);
 
 	if (key_mgmt == WLAN_AKM_SUITE_PSK) {
-		if (ar->auth_mode == WPA_AUTH)
-			ar->auth_mode = WPA_PSK_AUTH;
-		else if (ar->auth_mode == WPA2_AUTH)
-			ar->auth_mode = WPA2_PSK_AUTH;
+		if (vif->auth_mode == WPA_AUTH)
+			vif->auth_mode = WPA_PSK_AUTH;
+		else if (vif->auth_mode == WPA2_AUTH)
+			vif->auth_mode = WPA2_PSK_AUTH;
 	} else if (key_mgmt == 0x00409600) {
-		if (ar->auth_mode == WPA_AUTH)
-			ar->auth_mode = WPA_AUTH_CCKM;
-		else if (ar->auth_mode == WPA2_AUTH)
-			ar->auth_mode = WPA2_AUTH_CCKM;
+		if (vif->auth_mode == WPA_AUTH)
+			vif->auth_mode = WPA_AUTH_CCKM;
+		else if (vif->auth_mode == WPA2_AUTH)
+			vif->auth_mode = WPA2_AUTH_CCKM;
 	} else if (key_mgmt != WLAN_AKM_SUITE_8021X) {
-		ar->auth_mode = NONE_AUTH;
+		vif->auth_mode = NONE_AUTH;
 	}
 }
 
@@ -349,8 +360,8 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (test_bit(CONNECTED, &vif->flags) &&
-	    ar->ssid_len == sme->ssid_len &&
-	    !memcmp(ar->ssid, sme->ssid, ar->ssid_len)) {
+	    vif->ssid_len == sme->ssid_len &&
+	    !memcmp(vif->ssid, sme->ssid, vif->ssid_len)) {
 		ar->reconnect_flag = true;
 		status = ath6kl_wmi_reconnect_cmd(ar->wmi, ar->req_bssid,
 						  ar->ch_hint);
@@ -361,14 +372,14 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 			return -EIO;
 		}
 		return 0;
-	} else if (ar->ssid_len == sme->ssid_len &&
-		   !memcmp(ar->ssid, sme->ssid, ar->ssid_len)) {
+	} else if (vif->ssid_len == sme->ssid_len &&
+		   !memcmp(vif->ssid, sme->ssid, vif->ssid_len)) {
 		ath6kl_disconnect(ar);
 	}
 
-	memset(ar->ssid, 0, sizeof(ar->ssid));
-	ar->ssid_len = sme->ssid_len;
-	memcpy(ar->ssid, sme->ssid, sme->ssid_len);
+	memset(vif->ssid, 0, sizeof(vif->ssid));
+	vif->ssid_len = sme->ssid_len;
+	memcpy(vif->ssid, sme->ssid, sme->ssid_len);
 
 	if (sme->channel)
 		ar->ch_hint = sme->channel->center_freq;
@@ -396,7 +407,8 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		ath6kl_set_key_mgmt(ar, sme->crypto.akm_suites[0]);
 
 	if ((sme->key_len) &&
-	    (ar->auth_mode == NONE_AUTH) && (ar->prwise_crypto == WEP_CRYPT)) {
+	    (vif->auth_mode == NONE_AUTH) &&
+	    (vif->prwise_crypto == WEP_CRYPT)) {
 		struct ath6kl_key *key = NULL;
 
 		if (sme->key_idx < WMI_MIN_KEY_INDEX ||
@@ -410,11 +422,11 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		key = &ar->keys[sme->key_idx];
 		key->key_len = sme->key_len;
 		memcpy(key->key, sme->key, key->key_len);
-		key->cipher = ar->prwise_crypto;
-		ar->def_txkey_index = sme->key_idx;
+		key->cipher = vif->prwise_crypto;
+		vif->def_txkey_index = sme->key_idx;
 
 		ath6kl_wmi_addkey_cmd(ar->wmi, sme->key_idx,
-				      ar->prwise_crypto,
+				      vif->prwise_crypto,
 				      GROUP_USAGE | TX_USAGE,
 				      key->key_len,
 				      NULL,
@@ -438,25 +450,25 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		   " PW crypto %d PW crypto len %d GRP crypto %d"
 		   " GRP crypto len %d channel hint %u\n",
 		   __func__,
-		   ar->auth_mode, ar->dot11_auth_mode, ar->prwise_crypto,
-		   ar->prwise_crypto_len, ar->grp_crypto,
-		   ar->grp_crypto_len, ar->ch_hint);
+		   vif->auth_mode, vif->dot11_auth_mode, vif->prwise_crypto,
+		   vif->prwise_crypto_len, vif->grp_crypto,
+		   vif->grp_crypto_len, ar->ch_hint);
 
 	ar->reconnect_flag = 0;
 	status = ath6kl_wmi_connect_cmd(ar->wmi, ar->nw_type,
-					ar->dot11_auth_mode, ar->auth_mode,
-					ar->prwise_crypto,
-					ar->prwise_crypto_len,
-					ar->grp_crypto, ar->grp_crypto_len,
-					ar->ssid_len, ar->ssid,
+					vif->dot11_auth_mode, vif->auth_mode,
+					vif->prwise_crypto,
+					vif->prwise_crypto_len,
+					vif->grp_crypto, vif->grp_crypto_len,
+					vif->ssid_len, vif->ssid,
 					ar->req_bssid, ar->ch_hint,
 					ar->connect_ctrl_flags);
 
 	up(&ar->sem);
 
 	if (status == -EINVAL) {
-		memset(ar->ssid, 0, sizeof(ar->ssid));
-		ar->ssid_len = 0;
+		memset(vif->ssid, 0, sizeof(vif->ssid));
+		vif->ssid_len = 0;
 		ath6kl_err("invalid request\n");
 		return -ENOENT;
 	} else if (status) {
@@ -465,8 +477,8 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if ((!(ar->connect_ctrl_flags & CONNECT_DO_WPA_OFFLOAD)) &&
-	    ((ar->auth_mode == WPA_PSK_AUTH)
-	     || (ar->auth_mode == WPA2_PSK_AUTH))) {
+	    ((vif->auth_mode == WPA_PSK_AUTH)
+	     || (vif->auth_mode == WPA2_PSK_AUTH))) {
 		mod_timer(&ar->disconnect_timer,
 			  jiffies + msecs_to_jiffies(DISCON_TIMER_INTVAL));
 	}
@@ -481,11 +493,13 @@ static int ath6kl_add_bss_if_needed(struct ath6kl *ar, const u8 *bssid,
 				    struct ieee80211_channel *chan,
 				    const u8 *beacon_ie, size_t beacon_ie_len)
 {
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 	struct cfg80211_bss *bss;
 	u8 *ie;
 
 	bss = cfg80211_get_bss(ar->wiphy, chan, bssid,
-			       ar->ssid, ar->ssid_len, WLAN_CAPABILITY_ESS,
+			       vif->ssid, vif->ssid_len, WLAN_CAPABILITY_ESS,
 			       WLAN_CAPABILITY_ESS);
 	if (bss == NULL) {
 		/*
@@ -496,16 +510,16 @@ static int ath6kl_add_bss_if_needed(struct ath6kl *ar, const u8 *bssid,
 		 * Prepend SSID element since it is not included in the Beacon
 		 * IEs from the target.
 		 */
-		ie = kmalloc(2 + ar->ssid_len + beacon_ie_len, GFP_KERNEL);
+		ie = kmalloc(2 + vif->ssid_len + beacon_ie_len, GFP_KERNEL);
 		if (ie == NULL)
 			return -ENOMEM;
 		ie[0] = WLAN_EID_SSID;
-		ie[1] = ar->ssid_len;
-		memcpy(ie + 2, ar->ssid, ar->ssid_len);
-		memcpy(ie + 2 + ar->ssid_len, beacon_ie, beacon_ie_len);
+		ie[1] = vif->ssid_len;
+		memcpy(ie + 2, vif->ssid, vif->ssid_len);
+		memcpy(ie + 2 + vif->ssid_len, beacon_ie, beacon_ie_len);
 		bss = cfg80211_inform_bss(ar->wiphy, chan,
 					  bssid, 0, WLAN_CAPABILITY_ESS, 100,
-					  ie, 2 + ar->ssid_len + beacon_ie_len,
+					  ie, 2 + vif->ssid_len + beacon_ie_len,
 					  0, GFP_KERNEL);
 		if (bss)
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "added dummy bss for "
@@ -606,6 +620,7 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 				      struct net_device *dev, u16 reason_code)
 {
 	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: reason=%u\n", __func__,
 		   reason_code);
@@ -625,8 +640,8 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 
 	ar->reconnect_flag = 0;
 	ath6kl_disconnect(ar);
-	memset(ar->ssid, 0, sizeof(ar->ssid));
-	ar->ssid_len = 0;
+	memset(vif->ssid, 0, sizeof(vif->ssid));
+	vif->ssid_len = 0;
 
 	if (!test_bit(SKIP_SCAN, &ar->flag))
 		memset(ar->req_bssid, 0, sizeof(ar->req_bssid));
@@ -879,8 +894,8 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		return -ENOTSUPP;
 	}
 
-	if (((ar->auth_mode == WPA_PSK_AUTH)
-	     || (ar->auth_mode == WPA2_PSK_AUTH))
+	if (((vif->auth_mode == WPA_PSK_AUTH)
+	     || (vif->auth_mode == WPA2_PSK_AUTH))
 	    && (key_usage & GROUP_USAGE))
 		del_timer(&ar->disconnect_timer);
 
@@ -889,7 +904,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		   __func__, key_index, key->key_len, key_type,
 		   key_usage, key->seq_len);
 
-	ar->def_txkey_index = key_index;
+	vif->def_txkey_index = key_index;
 
 	if (ar->nw_type == AP_NETWORK && !pairwise &&
 	    (key_type == TKIP_CRYPT || key_type == AES_CRYPT) && params) {
@@ -924,7 +939,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		return 0;
 	}
 
-	status = ath6kl_wmi_addkey_cmd(ar->wmi, ar->def_txkey_index,
+	status = ath6kl_wmi_addkey_cmd(ar->wmi, vif->def_txkey_index,
 				       key_type, key_usage, key->key_len,
 				       key->seq, key->key, KEY_OP_INIT_VAL,
 				       (u8 *) mac_addr, SYNC_BOTH_WMIFLAG);
@@ -1029,20 +1044,20 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
-	ar->def_txkey_index = key_index;
-	key = &ar->keys[ar->def_txkey_index];
+	vif->def_txkey_index = key_index;
+	key = &ar->keys[vif->def_txkey_index];
 	key_usage = GROUP_USAGE;
-	if (ar->prwise_crypto == WEP_CRYPT)
+	if (vif->prwise_crypto == WEP_CRYPT)
 		key_usage |= TX_USAGE;
 	if (unicast)
-		key_type = ar->prwise_crypto;
+		key_type = vif->prwise_crypto;
 	if (multicast)
-		key_type = ar->grp_crypto;
+		key_type = vif->grp_crypto;
 
 	if (ar->next_mode == AP_NETWORK && !test_bit(CONNECTED, &vif->flags))
 		return 0; /* Delay until AP mode has been started */
 
-	status = ath6kl_wmi_addkey_cmd(ar->wmi, ar->def_txkey_index,
+	status = ath6kl_wmi_addkey_cmd(ar->wmi, vif->def_txkey_index,
 				       key_type, key_usage,
 				       key->key_len, key->seq, key->key,
 				       KEY_OP_INIT_VAL, NULL,
@@ -1229,8 +1244,8 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 	if (!ath6kl_cfg80211_ready(ar))
 		return -EIO;
 
-	ar->ssid_len = ibss_param->ssid_len;
-	memcpy(ar->ssid, ibss_param->ssid, ar->ssid_len);
+	vif->ssid_len = ibss_param->ssid_len;
+	memcpy(vif->ssid, ibss_param->ssid, vif->ssid_len);
 
 	if (ibss_param->channel)
 		ar->ch_hint = ibss_param->channel->center_freq;
@@ -1270,16 +1285,16 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 		   " PW crypto %d PW crypto len %d GRP crypto %d"
 		   " GRP crypto len %d channel hint %u\n",
 		   __func__,
-		   ar->auth_mode, ar->dot11_auth_mode, ar->prwise_crypto,
-		   ar->prwise_crypto_len, ar->grp_crypto,
-		   ar->grp_crypto_len, ar->ch_hint);
+		   vif->auth_mode, vif->dot11_auth_mode, vif->prwise_crypto,
+		   vif->prwise_crypto_len, vif->grp_crypto,
+		   vif->grp_crypto_len, ar->ch_hint);
 
 	status = ath6kl_wmi_connect_cmd(ar->wmi, ar->nw_type,
-					ar->dot11_auth_mode, ar->auth_mode,
-					ar->prwise_crypto,
-					ar->prwise_crypto_len,
-					ar->grp_crypto, ar->grp_crypto_len,
-					ar->ssid_len, ar->ssid,
+					vif->dot11_auth_mode, vif->auth_mode,
+					vif->prwise_crypto,
+					vif->prwise_crypto_len,
+					vif->grp_crypto, vif->grp_crypto_len,
+					vif->ssid_len, vif->ssid,
 					ar->req_bssid, ar->ch_hint,
 					ar->connect_ctrl_flags);
 	set_bit(CONNECT_PEND, &vif->flags);
@@ -1291,13 +1306,14 @@ static int ath6kl_cfg80211_leave_ibss(struct wiphy *wiphy,
 				      struct net_device *dev)
 {
 	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	if (!ath6kl_cfg80211_ready(ar))
 		return -EIO;
 
 	ath6kl_disconnect(ar);
-	memset(ar->ssid, 0, sizeof(ar->ssid));
-	ar->ssid_len = 0;
+	memset(vif->ssid, 0, sizeof(vif->ssid));
+	vif->ssid_len = 0;
 
 	return 0;
 }
@@ -1575,6 +1591,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 			    struct beacon_parameters *info, bool add)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 	struct ieee80211_mgmt *mgmt;
 	u8 *ies;
 	int ies_len;
@@ -1631,12 +1648,12 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 	if (info->ssid == NULL)
 		return -EINVAL;
-	memcpy(ar->ssid, info->ssid, info->ssid_len);
-	ar->ssid_len = info->ssid_len;
+	memcpy(vif->ssid, info->ssid, info->ssid_len);
+	vif->ssid_len = info->ssid_len;
 	if (info->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE)
 		return -EOPNOTSUPP; /* TODO */
 
-	ar->dot11_auth_mode = OPEN_AUTH;
+	vif->dot11_auth_mode = OPEN_AUTH;
 
 	memset(&p, 0, sizeof(p));
 
@@ -1658,7 +1675,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	}
 	if (p.auth_mode == 0)
 		p.auth_mode = NONE_AUTH;
-	ar->auth_mode = p.auth_mode;
+	vif->auth_mode = p.auth_mode;
 
 	for (i = 0; i < info->crypto.n_ciphers_pairwise; i++) {
 		switch (info->crypto.ciphers_pairwise[i]) {
@@ -1700,9 +1717,9 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	p.nw_type = AP_NETWORK;
 	ar->nw_type = ar->next_mode;
 
-	p.ssid_len = ar->ssid_len;
-	memcpy(p.ssid, ar->ssid, ar->ssid_len);
-	p.dot11_auth_mode = ar->dot11_auth_mode;
+	p.ssid_len = vif->ssid_len;
+	memcpy(p.ssid, vif->ssid, vif->ssid_len);
+	p.dot11_auth_mode = vif->dot11_auth_mode;
 	p.ch = cpu_to_le16(ar->next_chan);
 
 	res = ath6kl_wmi_ap_profile_commit(ar->wmi, &p);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 4777171..f401715 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -398,6 +398,15 @@ struct ath6kl_vif {
 	struct net_device *ndev;
 	struct ath6kl *ar;
 	unsigned long flags;
+	int ssid_len;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 dot11_auth_mode;
+	u8 auth_mode;
+	u8 prwise_crypto;
+	u8 prwise_crypto_len;
+	u8 grp_crypto;
+	u8 grp_crypto_len;
+	u8 def_txkey_index;
 };
 
 /* Flag info */
@@ -426,17 +435,8 @@ struct ath6kl {
 	struct ath6kl_vif *vif;
 	spinlock_t lock;
 	struct semaphore sem;
-	int ssid_len;
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 next_mode;
 	u8 nw_type;
-	u8 dot11_auth_mode;
-	u8 auth_mode;
-	u8 prwise_crypto;
-	u8 prwise_crypto_len;
-	u8 grp_crypto;
-	u8 grp_crypto_len;
-	u8 def_txkey_index;
 	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
 	u8 bssid[ETH_ALEN];
 	u8 req_bssid[ETH_ALEN];
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 91c2783..1aac79c 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -75,15 +75,18 @@ struct sk_buff *ath6kl_buf_alloc(int size)
 
 void ath6kl_init_profile_info(struct ath6kl *ar)
 {
-	ar->ssid_len = 0;
-	memset(ar->ssid, 0, sizeof(ar->ssid));
-
-	ar->dot11_auth_mode = OPEN_AUTH;
-	ar->auth_mode = NONE_AUTH;
-	ar->prwise_crypto = NONE_CRYPT;
-	ar->prwise_crypto_len = 0;
-	ar->grp_crypto = NONE_CRYPT;
-	ar->grp_crypto_len = 0;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
+
+	vif->ssid_len = 0;
+	memset(vif->ssid, 0, sizeof(vif->ssid));
+
+	vif->dot11_auth_mode = OPEN_AUTH;
+	vif->auth_mode = NONE_AUTH;
+	vif->prwise_crypto = NONE_CRYPT;
+	vif->prwise_crypto_len = 0;
+	vif->grp_crypto = NONE_CRYPT;
+	vif->grp_crypto_len = 0;
 	memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
 	memset(ar->req_bssid, 0, sizeof(ar->req_bssid));
 	memset(ar->bssid, 0, sizeof(ar->bssid));
@@ -245,8 +248,10 @@ static int ath6kl_init_service_ep(struct ath6kl *ar)
 
 void ath6kl_init_control_info(struct ath6kl *ar)
 {
+	struct ath6kl_vif *vif = ar->vif;
+
 	ath6kl_init_profile_info(ar);
-	ar->def_txkey_index = 0;
+	vif->def_txkey_index = 0;
 	memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
 	ar->ch_hint = 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 6a0eaea..a207377 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -498,13 +498,15 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 
 static void ath6kl_install_static_wep_keys(struct ath6kl *ar)
 {
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 	u8 index;
 	u8 keyusage;
 
 	for (index = WMI_MIN_KEY_INDEX; index <= WMI_MAX_KEY_INDEX; index++) {
 		if (ar->wep_key_list[index].key_len) {
 			keyusage = GROUP_USAGE;
-			if (index == ar->def_txkey_index)
+			if (index == vif->def_txkey_index)
 				keyusage |= TX_USAGE;
 
 			ath6kl_wmi_addkey_cmd(ar->wmi,
@@ -532,9 +534,9 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl *ar, u16 channel)
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "AP mode started on %u MHz\n", channel);
 
-	switch (ar->auth_mode) {
+	switch (vif->auth_mode) {
 	case NONE_AUTH:
-		if (ar->prwise_crypto == WEP_CRYPT)
+		if (vif->prwise_crypto == WEP_CRYPT)
 			ath6kl_install_static_wep_keys(ar);
 		break;
 	case WPA_PSK_AUTH:
-- 
1.7.0.4

