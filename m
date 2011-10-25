Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3952 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537Ab1JYOGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:06:21 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 18/31] ath6kl: Take vif information from wmi event
Date: Tue, 25 Oct 2011 19:34:13 +0530
Message-ID: <1319551466-29070-19-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160625_780729_BA04A5EB)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interface index is passed in wmi command header from target.
Use this index to get the appropriate vif.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  105 +++++++---------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    8 +-
 drivers/net/wireless/ath/ath6kl/core.h     |   24 ++--
 drivers/net/wireless/ath/ath6kl/debug.c    |    9 +-
 drivers/net/wireless/ath/ath6kl/main.c     |  121 ++++++++----------
 drivers/net/wireless/ath/ath6kl/txrx.c     |   12 +-
 drivers/net/wireless/ath/ath6kl/wmi.c      |  193 ++++++++++++++++------------
 drivers/net/wireless/ath/ath6kl/wmi.h      |   16 ++-
 8 files changed, 249 insertions(+), 239 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c8c5712..e870c9c 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -123,12 +123,9 @@ static struct ieee80211_supported_band ath6kl_band_5ghz = {
 
 #define CCKM_KRK_CIPHER_SUITE 0x004096ff /* use for KRK */
 
-static int ath6kl_set_wpa_version(struct ath6kl *ar,
+static int ath6kl_set_wpa_version(struct ath6kl_vif *vif,
 				  enum nl80211_wpa_versions wpa_version)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
-
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: %u\n", __func__, wpa_version);
 
 	if (!wpa_version) {
@@ -145,12 +142,9 @@ static int ath6kl_set_wpa_version(struct ath6kl *ar,
 	return 0;
 }
 
-static int ath6kl_set_auth_type(struct ath6kl *ar,
+static int ath6kl_set_auth_type(struct ath6kl_vif *vif,
 				enum nl80211_auth_type auth_type)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
-
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: 0x%x\n", __func__, auth_type);
 
 	switch (auth_type) {
@@ -176,11 +170,8 @@ static int ath6kl_set_auth_type(struct ath6kl *ar,
 	return 0;
 }
 
-static int ath6kl_set_cipher(struct ath6kl *ar, u32 cipher, bool ucast)
+static int ath6kl_set_cipher(struct ath6kl_vif *vif, u32 cipher, bool ucast)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
-
 	u8 *ar_cipher = ucast ? &vif->prwise_crypto : &vif->grp_crypto;
 	u8 *ar_cipher_len = ucast ? &vif->prwise_crypto_len :
 		&vif->grp_crypto_len;
@@ -218,11 +209,8 @@ static int ath6kl_set_cipher(struct ath6kl *ar, u32 cipher, bool ucast)
 	return 0;
 }
 
-static void ath6kl_set_key_mgmt(struct ath6kl *ar, u32 key_mgmt)
+static void ath6kl_set_key_mgmt(struct ath6kl_vif *vif, u32 key_mgmt)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
-
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: 0x%x\n", __func__, key_mgmt);
 
 	if (key_mgmt == WLAN_AKM_SUITE_PSK) {
@@ -376,7 +364,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		return 0;
 	} else if (vif->ssid_len == sme->ssid_len &&
 		   !memcmp(vif->ssid, sme->ssid, vif->ssid_len)) {
-		ath6kl_disconnect(ar, vif->fw_vif_idx);
+		ath6kl_disconnect(vif);
 	}
 
 	memset(vif->ssid, 0, sizeof(vif->ssid));
@@ -390,23 +378,23 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	if (sme->bssid && !is_broadcast_ether_addr(sme->bssid))
 		memcpy(vif->req_bssid, sme->bssid, sizeof(vif->req_bssid));
 
-	ath6kl_set_wpa_version(ar, sme->crypto.wpa_versions);
+	ath6kl_set_wpa_version(vif, sme->crypto.wpa_versions);
 
-	status = ath6kl_set_auth_type(ar, sme->auth_type);
+	status = ath6kl_set_auth_type(vif, sme->auth_type);
 	if (status) {
 		up(&ar->sem);
 		return status;
 	}
 
 	if (sme->crypto.n_ciphers_pairwise)
-		ath6kl_set_cipher(ar, sme->crypto.ciphers_pairwise[0], true);
+		ath6kl_set_cipher(vif, sme->crypto.ciphers_pairwise[0], true);
 	else
-		ath6kl_set_cipher(ar, 0, true);
+		ath6kl_set_cipher(vif, 0, true);
 
-	ath6kl_set_cipher(ar, sme->crypto.cipher_group, false);
+	ath6kl_set_cipher(vif, sme->crypto.cipher_group, false);
 
 	if (sme->crypto.n_akm_suites)
-		ath6kl_set_key_mgmt(ar, sme->crypto.akm_suites[0]);
+		ath6kl_set_key_mgmt(vif, sme->crypto.akm_suites[0]);
 
 	if ((sme->key_len) &&
 	    (vif->auth_mode == NONE_AUTH) &&
@@ -438,7 +426,8 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	if (!ar->usr_bss_filter) {
 		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
-		if (ath6kl_wmi_bssfilter_cmd(ar->wmi, ALL_BSS_FILTER, 0) != 0) {
+		if (ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
+		    ALL_BSS_FILTER, 0) != 0) {
 			ath6kl_err("couldn't set bss filtering\n");
 			up(&ar->sem);
 			return -EIO;
@@ -491,12 +480,11 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-static int ath6kl_add_bss_if_needed(struct ath6kl *ar, const u8 *bssid,
+static int ath6kl_add_bss_if_needed(struct ath6kl_vif *vif, const u8 *bssid,
 				    struct ieee80211_channel *chan,
 				    const u8 *beacon_ie, size_t beacon_ie_len)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 	struct cfg80211_bss *bss;
 	u8 *ie;
 
@@ -540,7 +528,7 @@ static int ath6kl_add_bss_if_needed(struct ath6kl *ar, const u8 *bssid,
 	return 0;
 }
 
-void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
+void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 				   u8 *bssid, u16 listen_intvl,
 				   u16 beacon_intvl,
 				   enum network_type nw_type,
@@ -548,8 +536,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 				   u8 assoc_resp_len, u8 *assoc_info)
 {
 	struct ieee80211_channel *chan;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 
 	/* capinfo + listen interval */
 	u8 assoc_req_ie_offset = sizeof(u16) + sizeof(u16);
@@ -592,11 +579,11 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 
 
 	if (nw_type & ADHOC_NETWORK) {
-		cfg80211_ibss_joined(ar->net_dev, bssid, GFP_KERNEL);
+		cfg80211_ibss_joined(vif->ndev, bssid, GFP_KERNEL);
 		return;
 	}
 
-	if (ath6kl_add_bss_if_needed(ar, bssid, chan, assoc_info,
+	if (ath6kl_add_bss_if_needed(vif, bssid, chan, assoc_info,
 				     beacon_ie_len) < 0) {
 		ath6kl_err("could not add cfg80211 bss entry for "
 			   "connect/roamed notification\n");
@@ -606,13 +593,13 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 	if (vif->sme_state == SME_CONNECTING) {
 		/* inform connect result to cfg80211 */
 		vif->sme_state = SME_CONNECTED;
-		cfg80211_connect_result(ar->net_dev, bssid,
+		cfg80211_connect_result(vif->ndev, bssid,
 					assoc_req_ie, assoc_req_len,
 					assoc_resp_ie, assoc_resp_len,
 					WLAN_STATUS_SUCCESS, GFP_KERNEL);
 	} else if (vif->sme_state == SME_CONNECTED) {
 		/* inform roam event to cfg80211 */
-		cfg80211_roamed(ar->net_dev, chan, bssid,
+		cfg80211_roamed(vif->ndev, chan, bssid,
 				assoc_req_ie, assoc_req_len,
 				assoc_resp_ie, assoc_resp_len, GFP_KERNEL);
 	}
@@ -641,7 +628,7 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 	}
 
 	vif->reconnect_flag = 0;
-	ath6kl_disconnect(ar, vif->fw_vif_idx);
+	ath6kl_disconnect(vif);
 	memset(vif->ssid, 0, sizeof(vif->ssid));
 	vif->ssid_len = 0;
 
@@ -655,12 +642,11 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 	return 0;
 }
 
-void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
+void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 				      u8 *bssid, u8 assoc_resp_len,
 				      u8 *assoc_info, u16 proto_reason)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 
 	if (vif->scan_req) {
 		cfg80211_scan_done(vif->scan_req, true);
@@ -674,7 +660,7 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 			return;
 		}
 		memset(bssid, 0, ETH_ALEN);
-		cfg80211_ibss_joined(ar->net_dev, bssid, GFP_KERNEL);
+		cfg80211_ibss_joined(vif->ndev, bssid, GFP_KERNEL);
 		return;
 	}
 
@@ -704,13 +690,13 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 	clear_bit(CONNECT_PEND, &vif->flags);
 
 	if (vif->sme_state == SME_CONNECTING) {
-		cfg80211_connect_result(ar->net_dev,
+		cfg80211_connect_result(vif->ndev,
 				bssid, NULL, 0,
 				NULL, 0,
 				WLAN_STATUS_UNSPECIFIED_FAILURE,
 				GFP_KERNEL);
 	} else if (vif->sme_state == SME_CONNECTED) {
-		cfg80211_disconnected(ar->net_dev, reason,
+		cfg80211_disconnected(vif->ndev, reason,
 				NULL, 0, GFP_KERNEL);
 	}
 
@@ -733,7 +719,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	if (!ar->usr_bss_filter) {
 		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
 		ret = ath6kl_wmi_bssfilter_cmd(
-			ar->wmi,
+			ar->wmi, vif->fw_vif_idx,
 			(test_bit(CONNECTED, &vif->flags) ?
 			 ALL_BUT_BSS_FILTER : ALL_BSS_FILTER), 0);
 		if (ret) {
@@ -804,10 +790,9 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	return ret;
 }
 
-void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status)
+void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, int status)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 	int i;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: status %d\n", __func__, status);
@@ -852,7 +837,8 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (params->cipher == CCKM_KRK_CIPHER_SUITE) {
 		if (params->key_len != WMI_KRK_LEN)
 			return -EINVAL;
-		return ath6kl_wmi_add_krk_cmd(ar->wmi, params->key);
+		return ath6kl_wmi_add_krk_cmd(ar->wmi, vif->fw_vif_idx,
+					      params->key);
 	}
 
 	if (key_index < WMI_MIN_KEY_INDEX || key_index > WMI_MAX_KEY_INDEX) {
@@ -1079,16 +1065,13 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	return 0;
 }
 
-void ath6kl_cfg80211_tkip_micerr_event(struct ath6kl *ar, u8 keyid,
+void ath6kl_cfg80211_tkip_micerr_event(struct ath6kl_vif *vif, u8 keyid,
 				       bool ismcast)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
-
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 		   "%s: keyid %d, ismcast %d\n", __func__, keyid, ismcast);
 
-	cfg80211_michael_mic_failure(ar->net_dev, vif->bssid,
+	cfg80211_michael_mic_failure(vif->ndev, vif->bssid,
 				     (ismcast ? NL80211_KEYTYPE_GROUP :
 				      NL80211_KEYTYPE_PAIRWISE), keyid, NULL,
 				     GFP_KERNEL);
@@ -1282,18 +1265,18 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 		memcpy(vif->req_bssid, ibss_param->bssid,
 		       sizeof(vif->req_bssid));
 
-	ath6kl_set_wpa_version(ar, 0);
+	ath6kl_set_wpa_version(vif, 0);
 
-	status = ath6kl_set_auth_type(ar, NL80211_AUTHTYPE_OPEN_SYSTEM);
+	status = ath6kl_set_auth_type(vif, NL80211_AUTHTYPE_OPEN_SYSTEM);
 	if (status)
 		return status;
 
 	if (ibss_param->privacy) {
-		ath6kl_set_cipher(ar, WLAN_CIPHER_SUITE_WEP40, true);
-		ath6kl_set_cipher(ar, WLAN_CIPHER_SUITE_WEP40, false);
+		ath6kl_set_cipher(vif, WLAN_CIPHER_SUITE_WEP40, true);
+		ath6kl_set_cipher(vif, WLAN_CIPHER_SUITE_WEP40, false);
 	} else {
-		ath6kl_set_cipher(ar, 0, true);
-		ath6kl_set_cipher(ar, 0, false);
+		ath6kl_set_cipher(vif, 0, true);
+		ath6kl_set_cipher(vif, 0, false);
 	}
 
 	vif->nw_type = vif->next_mode;
@@ -1329,7 +1312,7 @@ static int ath6kl_cfg80211_leave_ibss(struct wiphy *wiphy,
 	if (!ath6kl_cfg80211_ready(ar))
 		return -EIO;
 
-	ath6kl_disconnect(ar, vif->fw_vif_idx);
+	ath6kl_disconnect(vif);
 	memset(vif->ssid, 0, sizeof(vif->ssid));
 	vif->ssid_len = 0;
 
@@ -1720,9 +1703,9 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	}
 	if (p.prwise_crypto_type == 0) {
 		p.prwise_crypto_type = NONE_CRYPT;
-		ath6kl_set_cipher(ar, 0, true);
+		ath6kl_set_cipher(vif, 0, true);
 	} else if (info->crypto.n_ciphers_pairwise == 1)
-		ath6kl_set_cipher(ar, info->crypto.ciphers_pairwise[0], true);
+		ath6kl_set_cipher(vif, info->crypto.ciphers_pairwise[0], true);
 
 	switch (info->crypto.cipher_group) {
 	case WLAN_CIPHER_SUITE_WEP40:
@@ -1739,7 +1722,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 		p.grp_crypto_type = NONE_CRYPT;
 		break;
 	}
-	ath6kl_set_cipher(ar, info->crypto.cipher_group, false);
+	ath6kl_set_cipher(vif, info->crypto.cipher_group, false);
 
 	p.nw_type = AP_NETWORK;
 	vif->nw_type = vif->next_mode;
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 033e742..66042f2 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -24,20 +24,20 @@ int ath6kl_register_ieee80211_hw(struct ath6kl *ar);
 struct ath6kl *ath6kl_core_alloc(struct device *dev);
 void ath6kl_deinit_ieee80211_hw(struct ath6kl *ar);
 
-void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status);
+void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, int status);
 
-void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
+void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 				   u8 *bssid, u16 listen_intvl,
 				   u16 beacon_intvl,
 				   enum network_type nw_type,
 				   u8 beacon_ie_len, u8 assoc_req_len,
 				   u8 assoc_resp_len, u8 *assoc_info);
 
-void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
+void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 				      u8 *bssid, u8 assoc_resp_len,
 				      u8 *assoc_info, u16 proto_reason);
 
-void ath6kl_cfg80211_tkip_micerr_event(struct ath6kl *ar, u8 keyid,
+void ath6kl_cfg80211_tkip_micerr_event(struct ath6kl_vif *vif, u8 keyid,
 				     bool ismcast);
 
 #endif /* ATH6KL_CFG80211_H */
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f21d777..3fb8898 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -628,32 +628,32 @@ struct ath6kl_sta *ath6kl_find_sta_by_aid(struct ath6kl *ar, u8 aid);
 void ath6kl_ready_event(void *devt, u8 * datap, u32 sw_ver, u32 abi_ver);
 int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 		      enum htc_endpoint_id eid);
-void ath6kl_connect_event(struct ath6kl *ar, u16 channel,
+void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel,
 			  u8 *bssid, u16 listen_int,
 			  u16 beacon_int, enum network_type net_type,
 			  u8 beacon_ie_len, u8 assoc_req_len,
 			  u8 assoc_resp_len, u8 *assoc_info);
-void ath6kl_connect_ap_mode_bss(struct ath6kl *ar, u16 channel);
-void ath6kl_connect_ap_mode_sta(struct ath6kl *ar, u16 aid, u8 *mac_addr,
+void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel);
+void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 				u8 keymgmt, u8 ucipher, u8 auth,
 				u8 assoc_req_len, u8 *assoc_info);
-void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason,
+void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 			     u8 *bssid, u8 assoc_resp_len,
 			     u8 *assoc_info, u16 prot_reason_status);
-void ath6kl_tkip_micerr_event(struct ath6kl *ar, u8 keyid, bool ismcast);
+void ath6kl_tkip_micerr_event(struct ath6kl_vif *vif, u8 keyid, bool ismcast);
 void ath6kl_txpwr_rx_evt(void *devt, u8 tx_pwr);
-void ath6kl_scan_complete_evt(struct ath6kl *ar, int status);
-void ath6kl_tgt_stats_event(struct ath6kl *ar, u8 *ptr, u32 len);
+void ath6kl_scan_complete_evt(struct ath6kl_vif *vif, int status);
+void ath6kl_tgt_stats_event(struct ath6kl_vif *vif, u8 *ptr, u32 len);
 void ath6kl_indicate_tx_activity(void *devt, u8 traffic_class, bool active);
 enum htc_endpoint_id ath6kl_ac2_endpoint_id(void *devt, u8 ac);
 
-void ath6kl_pspoll_event(struct ath6kl *ar, u8 aid);
+void ath6kl_pspoll_event(struct ath6kl_vif *vif, u8 aid);
 
-void ath6kl_dtimexpiry_event(struct ath6kl *ar);
-void ath6kl_disconnect(struct ath6kl *ar, u8 if_idx);
+void ath6kl_dtimexpiry_event(struct ath6kl_vif *vif);
+void ath6kl_disconnect(struct ath6kl_vif *vif);
 void ath6kl_deep_sleep_enable(struct ath6kl *ar);
-void aggr_recv_delba_req_evt(struct ath6kl *ar, u8 tid);
-void aggr_recv_addba_req_evt(struct ath6kl *ar, u8 tid, u16 seq_no,
+void aggr_recv_delba_req_evt(struct ath6kl_vif *vif, u8 tid);
+void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid, u16 seq_no,
 			     u8 win_sz);
 void ath6kl_wakeup_event(void *dev);
 void ath6kl_target_failure(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 870e9b1..54faa6b 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1249,6 +1249,8 @@ static ssize_t ath6kl_create_qos_write(struct file *file,
 {
 
 	struct ath6kl *ar = file->private_data;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 	char buf[100];
 	ssize_t len;
 	char *sptr, *token;
@@ -1403,7 +1405,7 @@ static ssize_t ath6kl_create_qos_write(struct file *file,
 		return -EINVAL;
 	pstream.medium_time = cpu_to_le32(val32);
 
-	ath6kl_wmi_create_pstream_cmd(ar->wmi, &pstream);
+	ath6kl_wmi_create_pstream_cmd(ar->wmi, vif->fw_vif_idx, &pstream);
 
 	return count;
 }
@@ -1421,6 +1423,8 @@ static ssize_t ath6kl_delete_qos_write(struct file *file,
 {
 
 	struct ath6kl *ar = file->private_data;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 	char buf[100];
 	ssize_t len;
 	char *sptr, *token;
@@ -1445,7 +1449,8 @@ static ssize_t ath6kl_delete_qos_write(struct file *file,
 	if (kstrtou8(token, 0, &tsid))
 		return -EINVAL;
 
-	ath6kl_wmi_delete_pstream_cmd(ar->wmi, traffic_class, tsid);
+	ath6kl_wmi_delete_pstream_cmd(ar->wmi, vif->fw_vif_idx,
+				      traffic_class, tsid);
 
 	return count;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 9929901..19b64ae 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -441,7 +441,7 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 	if (test_bit(WMI_READY, &ar->flag)) {
 		discon_issued = (test_bit(CONNECTED, &vif->flags) ||
 				 test_bit(CONNECT_PEND, &vif->flags));
-		ath6kl_disconnect(ar, vif->fw_vif_idx);
+		ath6kl_disconnect(vif);
 		if (!keep_profile)
 			ath6kl_init_profile_info(ar);
 
@@ -462,7 +462,7 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 		 * are collected.
 		 */
 		if (discon_issued)
-			ath6kl_disconnect_event(ar, DISCONNECT_CMD,
+			ath6kl_disconnect_event(vif, DISCONNECT_CMD,
 						(vif->nw_type & AP_NETWORK) ?
 						bcast_mac : vif->bssid,
 						0, NULL, 0);
@@ -498,10 +498,8 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 	ath6kl_reset_device(ar, ar->target_type, true, true);
 }
 
-static void ath6kl_install_static_wep_keys(struct ath6kl *ar)
+static void ath6kl_install_static_wep_keys(struct ath6kl_vif *vif)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
 	u8 index;
 	u8 keyusage;
 
@@ -511,7 +509,7 @@ static void ath6kl_install_static_wep_keys(struct ath6kl *ar)
 			if (index == vif->def_txkey_index)
 				keyusage |= TX_USAGE;
 
-			ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx,
+			ath6kl_wmi_addkey_cmd(vif->ar->wmi, vif->fw_vif_idx,
 					      index,
 					      WEP_CRYPT,
 					      keyusage,
@@ -524,13 +522,12 @@ static void ath6kl_install_static_wep_keys(struct ath6kl *ar)
 	}
 }
 
-void ath6kl_connect_ap_mode_bss(struct ath6kl *ar, u16 channel)
+void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel)
 {
+	struct ath6kl *ar = vif->ar;
 	struct ath6kl_req_key *ik;
 	int res;
 	u8 key_rsc[ATH6KL_KEY_SEQ_LEN];
-	/* TODO: Pass vif instead of taking it from ar */
-	struct ath6kl_vif *vif = ar->vif;
 
 	ik = &ar->ap_mode_bkey;
 
@@ -539,7 +536,7 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl *ar, u16 channel)
 	switch (vif->auth_mode) {
 	case NONE_AUTH:
 		if (vif->prwise_crypto == WEP_CRYPT)
-			ath6kl_install_static_wep_keys(ar);
+			ath6kl_install_static_wep_keys(vif);
 		break;
 	case WPA_PSK_AUTH:
 	case WPA2_PSK_AUTH:
@@ -561,15 +558,16 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl *ar, u16 channel)
 		break;
 	}
 
-	ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
+	ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx, NONE_BSS_FILTER, 0);
 	set_bit(CONNECTED, &vif->flags);
-	netif_carrier_on(ar->net_dev);
+	netif_carrier_on(vif->ndev);
 }
 
-void ath6kl_connect_ap_mode_sta(struct ath6kl *ar, u16 aid, u8 *mac_addr,
+void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 				u8 keymgmt, u8 ucipher, u8 auth,
 				u8 assoc_req_len, u8 *assoc_info)
 {
+	struct ath6kl *ar = vif->ar;
 	u8 *ies = NULL, *wpa_ie = NULL, *pos;
 	size_t ies_len = 0;
 	struct station_info sinfo;
@@ -624,9 +622,9 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl *ar, u16 aid, u8 *mac_addr,
 	sinfo.assoc_req_ies_len = ies_len;
 	sinfo.filled |= STATION_INFO_ASSOC_REQ_IES;
 
-	cfg80211_new_sta(ar->net_dev, mac_addr, &sinfo, GFP_KERNEL);
+	cfg80211_new_sta(vif->ndev, mac_addr, &sinfo, GFP_KERNEL);
 
-	netif_wake_queue(ar->net_dev);
+	netif_wake_queue(vif->ndev);
 }
 
 /* Functions for Tx credit handling */
@@ -916,17 +914,14 @@ void disconnect_timer_handler(unsigned long ptr)
 	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	ath6kl_init_profile_info(vif->ar);
-	ath6kl_disconnect(vif->ar, vif->fw_vif_idx);
+	ath6kl_disconnect(vif);
 }
 
-void ath6kl_disconnect(struct ath6kl *ar, u8 if_idx)
+void ath6kl_disconnect(struct ath6kl_vif *vif)
 {
-	/* TODO: Pass vif instead of taking it from ar */
-	struct ath6kl_vif *vif = ar->vif;
-
 	if (test_bit(CONNECTED, &vif->flags) ||
 	    test_bit(CONNECT_PEND, &vif->flags)) {
-		ath6kl_wmi_disconnect_cmd(ar->wmi, if_idx);
+		ath6kl_wmi_disconnect_cmd(vif->ar->wmi, vif->fw_vif_idx);
 		/*
 		 * Disconnect command is issued, clear the connect pending
 		 * flag. The connected flag will be cleared in
@@ -971,7 +966,7 @@ void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 		printk(KERN_WARNING "ath6kl: failed to disable scan "
 		       "during suspend\n");
 
-	ath6kl_cfg80211_scan_complete_event(ar, -ECANCELED);
+	ath6kl_cfg80211_scan_complete_event(vif, -ECANCELED);
 
 	/* save the current power mode before enabling power save */
 	ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
@@ -1027,31 +1022,30 @@ void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 		    test_bit(TESTMODE, &ar->flag) ? " testmode" : "");
 }
 
-void ath6kl_scan_complete_evt(struct ath6kl *ar, int status)
+void ath6kl_scan_complete_evt(struct ath6kl_vif *vif, int status)
 {
-	/* TODO: Pass vif instead of taking it from ar */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 
-	ath6kl_cfg80211_scan_complete_event(ar, status);
+	ath6kl_cfg80211_scan_complete_event(vif, status);
 
 	if (!ar->usr_bss_filter) {
 		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
-		ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
+		ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
+					 NONE_BSS_FILTER, 0);
 	}
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_SCAN, "scan complete: %d\n", status);
 }
 
-void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
+void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel, u8 *bssid,
 			  u16 listen_int, u16 beacon_int,
 			  enum network_type net_type, u8 beacon_ie_len,
 			  u8 assoc_req_len, u8 assoc_resp_len,
 			  u8 *assoc_info)
 {
-	/* TODO: findout  vif instead of taking it from ar */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 
-	ath6kl_cfg80211_connect_event(ar, channel, bssid,
+	ath6kl_cfg80211_connect_event(vif, channel, bssid,
 				      listen_int, beacon_int,
 				      net_type, beacon_ie_len,
 				      assoc_req_len, assoc_resp_len,
@@ -1065,13 +1059,13 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 					      ar->listen_intvl_t,
 					      ar->listen_intvl_b);
 
-	netif_wake_queue(ar->net_dev);
+	netif_wake_queue(vif->ndev);
 
 	/* Update connect & link status atomically */
 	spin_lock_bh(&ar->lock);
 	set_bit(CONNECTED, &vif->flags);
 	clear_bit(CONNECT_PEND, &vif->flags);
-	netif_carrier_on(ar->net_dev);
+	netif_carrier_on(vif->ndev);
 	spin_unlock_bh(&ar->lock);
 
 	aggr_reset_state(vif->aggr_cntxt);
@@ -1085,16 +1079,17 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 
 	if (!ar->usr_bss_filter) {
 		set_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
-		ath6kl_wmi_bssfilter_cmd(ar->wmi, CURRENT_BSS_FILTER, 0);
+		ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
+					 CURRENT_BSS_FILTER, 0);
 	}
 }
 
-void ath6kl_tkip_micerr_event(struct ath6kl *ar, u8 keyid, bool ismcast)
+void ath6kl_tkip_micerr_event(struct ath6kl_vif *vif, u8 keyid, bool ismcast)
 {
 	struct ath6kl_sta *sta;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 	u8 tsc[6];
+
 	/*
 	 * For AP case, keyid will have aid of STA which sent pkt with
 	 * MIC error. Use this aid to get MAC & send it to hostapd.
@@ -1108,20 +1103,19 @@ void ath6kl_tkip_micerr_event(struct ath6kl *ar, u8 keyid, bool ismcast)
 			   "ap tkip mic error received from aid=%d\n", keyid);
 
 		memset(tsc, 0, sizeof(tsc)); /* FIX: get correct TSC */
-		cfg80211_michael_mic_failure(ar->net_dev, sta->mac,
+		cfg80211_michael_mic_failure(vif->ndev, sta->mac,
 					     NL80211_KEYTYPE_PAIRWISE, keyid,
 					     tsc, GFP_KERNEL);
 	} else
-		ath6kl_cfg80211_tkip_micerr_event(ar, keyid, ismcast);
+		ath6kl_cfg80211_tkip_micerr_event(vif, keyid, ismcast);
 
 }
 
-static void ath6kl_update_target_stats(struct ath6kl *ar, u8 *ptr, u32 len)
+static void ath6kl_update_target_stats(struct ath6kl_vif *vif, u8 *ptr, u32 len)
 {
 	struct wmi_target_stats *tgt_stats =
 		(struct wmi_target_stats *) ptr;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 	struct target_stats *stats = &vif->target_stats;
 	struct tkip_ccmp_stats *ccmp_stats;
 	u8 ac;
@@ -1229,13 +1223,12 @@ static void ath6kl_add_le32(__le32 *var, __le32 val)
 	*var = cpu_to_le32(le32_to_cpu(*var) + le32_to_cpu(val));
 }
 
-void ath6kl_tgt_stats_event(struct ath6kl *ar, u8 *ptr, u32 len)
+void ath6kl_tgt_stats_event(struct ath6kl_vif *vif, u8 *ptr, u32 len)
 {
 	struct wmi_ap_mode_stat *p = (struct wmi_ap_mode_stat *) ptr;
+	struct ath6kl *ar = vif->ar;
 	struct wmi_ap_mode_stat *ap = &ar->ap_stats;
 	struct wmi_per_sta_stat *st_ap, *st_p;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
 	u8 ac;
 
 	if (vif->nw_type == AP_NETWORK) {
@@ -1257,7 +1250,7 @@ void ath6kl_tgt_stats_event(struct ath6kl *ar, u8 *ptr, u32 len)
 		}
 
 	} else {
-		ath6kl_update_target_stats(ar, ptr, len);
+		ath6kl_update_target_stats(vif, ptr, len);
 	}
 }
 
@@ -1276,13 +1269,12 @@ void ath6kl_txpwr_rx_evt(void *devt, u8 tx_pwr)
 	wake_up(&ar->event_wq);
 }
 
-void ath6kl_pspoll_event(struct ath6kl *ar, u8 aid)
+void ath6kl_pspoll_event(struct ath6kl_vif *vif, u8 aid)
 {
 	struct ath6kl_sta *conn;
 	struct sk_buff *skb;
 	bool psq_empty = false;
-	/* TODO: Pass vif instead of taking it from ar */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 
 	conn = ath6kl_find_sta_by_aid(ar, aid);
 
@@ -1305,7 +1297,7 @@ void ath6kl_pspoll_event(struct ath6kl *ar, u8 aid)
 	spin_unlock_bh(&conn->psq_lock);
 
 	conn->sta_flags |= STA_PS_POLLED;
-	ath6kl_data_tx(skb, ar->net_dev);
+	ath6kl_data_tx(skb, vif->ndev);
 	conn->sta_flags &= ~STA_PS_POLLED;
 
 	spin_lock_bh(&conn->psq_lock);
@@ -1316,12 +1308,11 @@ void ath6kl_pspoll_event(struct ath6kl *ar, u8 aid)
 		ath6kl_wmi_set_pvb_cmd(ar->wmi, vif->fw_vif_idx, conn->aid, 0);
 }
 
-void ath6kl_dtimexpiry_event(struct ath6kl *ar)
+void ath6kl_dtimexpiry_event(struct ath6kl_vif *vif)
 {
 	bool mcastq_empty = false;
 	struct sk_buff *skb;
-	/* TODO: Pass vif instead of taking it from ar */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 
 	/*
 	 * If there are no associated STAs, ignore the DTIM expiry event.
@@ -1349,7 +1340,7 @@ void ath6kl_dtimexpiry_event(struct ath6kl *ar)
 	while ((skb = skb_dequeue(&ar->mcastpsq)) != NULL) {
 		spin_unlock_bh(&ar->mcastpsq_lock);
 
-		ath6kl_data_tx(skb, ar->net_dev);
+		ath6kl_data_tx(skb, vif->ndev);
 
 		spin_lock_bh(&ar->mcastpsq_lock);
 	}
@@ -1361,12 +1352,11 @@ void ath6kl_dtimexpiry_event(struct ath6kl *ar)
 	ath6kl_wmi_set_pvb_cmd(ar->wmi, vif->fw_vif_idx, MCAST_AID, 0);
 }
 
-void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
+void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 			     u8 assoc_resp_len, u8 *assoc_info,
 			     u16 prot_reason_status)
 {
-	/* TODO: Findout vif instead of taking it from ar */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 
 	if (vif->nw_type == AP_NETWORK) {
 		if (!ath6kl_remove_sta(ar, bssid, prot_reason_status))
@@ -1386,17 +1376,17 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 
 		if (!is_broadcast_ether_addr(bssid)) {
 			/* send event to application */
-			cfg80211_del_sta(ar->net_dev, bssid, GFP_KERNEL);
+			cfg80211_del_sta(vif->ndev, bssid, GFP_KERNEL);
 		}
 
-		if (memcmp(ar->net_dev->dev_addr, bssid, ETH_ALEN) == 0) {
+		if (memcmp(vif->ndev->dev_addr, bssid, ETH_ALEN) == 0) {
 			memset(vif->wep_key_list, 0, sizeof(vif->wep_key_list));
 			clear_bit(CONNECTED, &vif->flags);
 		}
 		return;
 	}
 
-	ath6kl_cfg80211_disconnect_event(ar, reason, bssid,
+	ath6kl_cfg80211_disconnect_event(vif, reason, bssid,
 				       assoc_resp_len, assoc_info,
 				       prot_reason_status);
 
@@ -1414,7 +1404,8 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 	 */
 	if (reason == DISCONNECT_CMD) {
 		if (!ar->usr_bss_filter && test_bit(WMI_READY, &ar->flag))
-			ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
+			ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
+						 NONE_BSS_FILTER, 0);
 	} else {
 		set_bit(CONNECT_PEND, &vif->flags);
 		if (((reason == ASSOC_FAILED) &&
@@ -1429,7 +1420,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 	/* update connect & link status atomically */
 	spin_lock_bh(&ar->lock);
 	clear_bit(CONNECTED, &vif->flags);
-	netif_carrier_off(ar->net_dev);
+	netif_carrier_off(vif->ndev);
 	spin_unlock_bh(&ar->lock);
 
 	if ((reason != CSERV_DISCONNECT) || (vif->reconnect_flag != 1))
@@ -1438,7 +1429,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 	if (reason != CSERV_DISCONNECT)
 		ar->user_key_ctrl = 0;
 
-	netif_stop_queue(ar->net_dev);
+	netif_stop_queue(vif->ndev);
 	memset(vif->bssid, 0, sizeof(vif->bssid));
 	vif->bss_ch = 0;
 
@@ -1472,7 +1463,7 @@ static int ath6kl_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	ath6kl_disconnect(ar, vif->fw_vif_idx);
+	ath6kl_disconnect(vif);
 
 	if (test_bit(WMI_READY, &ar->flag)) {
 		if (ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx, 0xFFFF,
@@ -1482,7 +1473,7 @@ static int ath6kl_close(struct net_device *dev)
 		clear_bit(WLAN_ENABLED, &vif->flags);
 	}
 
-	ath6kl_cfg80211_scan_complete_event(ar, -ECANCELED);
+	ath6kl_cfg80211_scan_complete_event(vif, -ECANCELED);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index c54f1a9..50ff9a4 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -287,7 +287,8 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 			chk_adhoc_ps_mapping = true;
 		else {
 			/* get the stream mapping */
-			ret = ath6kl_wmi_implicit_create_pstream(ar->wmi, skb,
+			ret = ath6kl_wmi_implicit_create_pstream(ar->wmi,
+				    vif->fw_vif_idx, skb,
 				    0, test_bit(WMM_ENABLED, &vif->flags), &ac);
 			if (ret)
 				goto fail_tx;
@@ -1354,10 +1355,9 @@ static void aggr_delete_tid_state(struct aggr_info *p_aggr, u8 tid)
 	memset(stats, 0, sizeof(struct rxtid_stats));
 }
 
-void aggr_recv_addba_req_evt(struct ath6kl *ar, u8 tid, u16 seq_no, u8 win_sz)
+void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid, u16 seq_no,
+			     u8 win_sz)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
 	struct aggr_info *p_aggr = vif->aggr_cntxt;
 	struct rxtid *rxtid;
 	struct rxtid_stats *stats;
@@ -1425,10 +1425,8 @@ struct aggr_info *aggr_init(struct net_device *dev)
 	return p_aggr;
 }
 
-void aggr_recv_delba_req_evt(struct ath6kl *ar, u8 tid)
+void aggr_recv_delba_req_evt(struct ath6kl_vif *vif, u8 tid)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
 	struct aggr_info *p_aggr = vif->aggr_cntxt;
 	struct rxtid *rxtid;
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index a4ad7cb..ed092b7 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -21,7 +21,7 @@
 #include "../regd.h"
 #include "../regd_common.h"
 
-static int ath6kl_wmi_sync_point(struct wmi *wmi);
+static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx);
 
 static const s32 wmi_rate_tbl[][2] = {
 	/* {W/O SGI, with SGI} */
@@ -81,6 +81,14 @@ enum htc_endpoint_id ath6kl_wmi_get_control_ep(struct wmi *wmi)
 	return wmi->ep_id;
 }
 
+static struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx)
+{
+	if (WARN_ON(if_idx > (MAX_NUM_VIF - 1)))
+		return NULL;
+
+	return ar->vif;
+}
+
 /*  Performs DIX to 802.3 encapsulation for transmit packets.
  *  Assumes the entire DIX header is contigous and that there is
  *  enough room in the buffer for a 802.3 mac header and LLC+SNAP headers.
@@ -216,7 +224,8 @@ static u8 ath6kl_wmi_determine_user_priority(u8 *pkt, u32 layer2_pri)
 		return ip_pri;
 }
 
-int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, struct sk_buff *skb,
+int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, u8 if_idx,
+				       struct sk_buff *skb,
 				       u32 layer2_priority, bool wmm_enabled,
 				       u8 *ac)
 {
@@ -289,7 +298,7 @@ int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, struct sk_buff *skb,
 			cpu_to_le32(WMI_IMPLICIT_PSTREAM_INACTIVITY_INT);
 		/* Implicit streams are created with TSID 0xFF */
 		cmd.tsid = WMI_IMPLICIT_PSTREAM;
-		ath6kl_wmi_create_pstream_cmd(wmi, &cmd);
+		ath6kl_wmi_create_pstream_cmd(wmi, if_idx, &cmd);
 	}
 
 	*ac = traffic_class;
@@ -415,7 +424,7 @@ static int ath6kl_wmi_tx_complete_event_rx(u8 *datap, int len)
 }
 
 static int ath6kl_wmi_remain_on_chnl_event_rx(struct wmi *wmi, u8 *datap,
-					      int len)
+					      int len, struct ath6kl_vif *vif)
 {
 	struct wmi_remain_on_chnl_event *ev;
 	u32 freq;
@@ -437,14 +446,15 @@ static int ath6kl_wmi_remain_on_chnl_event_rx(struct wmi *wmi, u8 *datap,
 			   "(freq=%u)\n", freq);
 		return -EINVAL;
 	}
-	cfg80211_ready_on_channel(ar->net_dev, 1, chan, NL80211_CHAN_NO_HT,
+	cfg80211_ready_on_channel(vif->ndev, 1, chan, NL80211_CHAN_NO_HT,
 				  dur, GFP_ATOMIC);
 
 	return 0;
 }
 
 static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(struct wmi *wmi,
-						     u8 *datap, int len)
+						     u8 *datap, int len,
+						     struct ath6kl_vif *vif)
 {
 	struct wmi_cancel_remain_on_chnl_event *ev;
 	u32 freq;
@@ -466,17 +476,17 @@ static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(struct wmi *wmi,
 			   "channel (freq=%u)\n", freq);
 		return -EINVAL;
 	}
-	cfg80211_remain_on_channel_expired(ar->net_dev, 1, chan,
+	cfg80211_remain_on_channel_expired(vif->ndev, 1, chan,
 					   NL80211_CHAN_NO_HT, GFP_ATOMIC);
 
 	return 0;
 }
 
-static int ath6kl_wmi_tx_status_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_tx_status_event_rx(struct wmi *wmi, u8 *datap, int len,
+					 struct ath6kl_vif *vif)
 {
 	struct wmi_tx_status_event *ev;
 	u32 id;
-	struct ath6kl *ar = wmi->parent_dev;
 
 	if (len < sizeof(*ev))
 		return -EINVAL;
@@ -486,7 +496,7 @@ static int ath6kl_wmi_tx_status_event_rx(struct wmi *wmi, u8 *datap, int len)
 	ath6kl_dbg(ATH6KL_DBG_WMI, "tx_status: id=%x ack_status=%u\n",
 		   id, ev->ack_status);
 	if (wmi->last_mgmt_tx_frame) {
-		cfg80211_mgmt_tx_status(ar->net_dev, id,
+		cfg80211_mgmt_tx_status(vif->ndev, id,
 					wmi->last_mgmt_tx_frame,
 					wmi->last_mgmt_tx_frame_len,
 					!!ev->ack_status, GFP_ATOMIC);
@@ -498,14 +508,12 @@ static int ath6kl_wmi_tx_status_event_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
-static int ath6kl_wmi_rx_probe_req_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_rx_probe_req_event_rx(struct wmi *wmi, u8 *datap, int len,
+					    struct ath6kl_vif *vif)
 {
 	struct wmi_p2p_rx_probe_req_event *ev;
 	u32 freq;
 	u16 dlen;
-	struct ath6kl *ar = wmi->parent_dev;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
 
 	if (len < sizeof(*ev))
 		return -EINVAL;
@@ -523,7 +531,7 @@ static int ath6kl_wmi_rx_probe_req_event_rx(struct wmi *wmi, u8 *datap, int len)
 		   dlen, freq, vif->probe_req_report);
 
 	if (vif->probe_req_report || vif->nw_type == AP_NETWORK)
-		cfg80211_rx_mgmt(ar->net_dev, freq, ev->data, dlen, GFP_ATOMIC);
+		cfg80211_rx_mgmt(vif->ndev, freq, ev->data, dlen, GFP_ATOMIC);
 
 	return 0;
 }
@@ -543,12 +551,12 @@ static int ath6kl_wmi_p2p_capabilities_event_rx(u8 *datap, int len)
 	return 0;
 }
 
-static int ath6kl_wmi_rx_action_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_rx_action_event_rx(struct wmi *wmi, u8 *datap, int len,
+					 struct ath6kl_vif *vif)
 {
 	struct wmi_rx_action_event *ev;
 	u32 freq;
 	u16 dlen;
-	struct ath6kl *ar = wmi->parent_dev;
 
 	if (len < sizeof(*ev))
 		return -EINVAL;
@@ -562,7 +570,7 @@ static int ath6kl_wmi_rx_action_event_rx(struct wmi *wmi, u8 *datap, int len)
 		return -EINVAL;
 	}
 	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_action: len=%u freq=%u\n", dlen, freq);
-	cfg80211_rx_mgmt(ar->net_dev, freq, ev->data, dlen, GFP_ATOMIC);
+	cfg80211_rx_mgmt(vif->ndev, freq, ev->data, dlen, GFP_ATOMIC);
 
 	return 0;
 }
@@ -726,13 +734,11 @@ int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode)
 				   NO_SYNC_WMIFLAG);
 }
 
-static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
+				       struct ath6kl_vif *vif)
 {
 	struct wmi_connect_event *ev;
 	u8 *pie, *peie;
-	struct ath6kl *ar = wmi->parent_dev;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
 
 	if (len < sizeof(struct wmi_connect_event))
 		return -EINVAL;
@@ -741,14 +747,14 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
 
 	if (vif->nw_type == AP_NETWORK) {
 		/* AP mode start/STA connected event */
-		struct net_device *dev = ar->net_dev;
+		struct net_device *dev = vif->ndev;
 		if (memcmp(dev->dev_addr, ev->u.ap_bss.bssid, ETH_ALEN) == 0) {
 			ath6kl_dbg(ATH6KL_DBG_WMI, "%s: freq %d bssid %pM "
 				   "(AP started)\n",
 				   __func__, le16_to_cpu(ev->u.ap_bss.ch),
 				   ev->u.ap_bss.bssid);
 			ath6kl_connect_ap_mode_bss(
-				ar, le16_to_cpu(ev->u.ap_bss.ch));
+				vif, le16_to_cpu(ev->u.ap_bss.ch));
 		} else {
 			ath6kl_dbg(ATH6KL_DBG_WMI, "%s: aid %u mac_addr %pM "
 				   "auth=%u keymgmt=%u cipher=%u apsd_info=%u "
@@ -760,7 +766,7 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
 				   le16_to_cpu(ev->u.ap_sta.cipher),
 				   ev->u.ap_sta.apsd_info);
 			ath6kl_connect_ap_mode_sta(
-				ar, ev->u.ap_sta.aid, ev->u.ap_sta.mac_addr,
+				vif, ev->u.ap_sta.aid, ev->u.ap_sta.mac_addr,
 				ev->u.ap_sta.keymgmt,
 				le16_to_cpu(ev->u.ap_sta.cipher),
 				ev->u.ap_sta.auth, ev->assoc_req_len,
@@ -805,7 +811,7 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
 		pie += pie[1] + 2;
 	}
 
-	ath6kl_connect_event(wmi->parent_dev, le16_to_cpu(ev->u.sta.ch),
+	ath6kl_connect_event(vif, le16_to_cpu(ev->u.sta.ch),
 			     ev->u.sta.bssid,
 			     le16_to_cpu(ev->u.sta.listen_intvl),
 			     le16_to_cpu(ev->u.sta.beacon_intvl),
@@ -891,7 +897,8 @@ static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
 	}
 }
 
-static int ath6kl_wmi_disconnect_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_disconnect_event_rx(struct wmi *wmi, u8 *datap, int len,
+					  struct ath6kl_vif *vif)
 {
 	struct wmi_disconnect_event *ev;
 	wmi->traffic_class = 100;
@@ -908,7 +915,7 @@ static int ath6kl_wmi_disconnect_event_rx(struct wmi *wmi, u8 *datap, int len)
 
 	wmi->is_wmm_enabled = false;
 
-	ath6kl_disconnect_event(wmi->parent_dev, ev->disconn_reason,
+	ath6kl_disconnect_event(vif, ev->disconn_reason,
 				ev->bssid, ev->assoc_resp_len, ev->assoc_info,
 				le16_to_cpu(ev->proto_reason_status));
 
@@ -934,7 +941,8 @@ static int ath6kl_wmi_peer_node_event_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
-static int ath6kl_wmi_tkip_micerr_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_tkip_micerr_event_rx(struct wmi *wmi, u8 *datap, int len,
+					   struct ath6kl_vif *vif)
 {
 	struct wmi_tkip_micerr_event *ev;
 
@@ -943,12 +951,13 @@ static int ath6kl_wmi_tkip_micerr_event_rx(struct wmi *wmi, u8 *datap, int len)
 
 	ev = (struct wmi_tkip_micerr_event *) datap;
 
-	ath6kl_tkip_micerr_event(wmi->parent_dev, ev->key_id, ev->is_mcast);
+	ath6kl_tkip_micerr_event(vif, ev->key_id, ev->is_mcast);
 
 	return 0;
 }
 
-static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
+				       struct ath6kl_vif *vif)
 {
 	struct wmi_bss_info_hdr2 *bih;
 	u8 *buf;
@@ -956,8 +965,6 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 	struct ath6kl *ar = wmi->parent_dev;
 	struct ieee80211_mgmt *mgmt;
 	struct cfg80211_bss *bss;
-	/*TODO: Findout vif properly */
-	struct ath6kl_vif *vif = ar->vif;
 
 	if (len <= sizeof(struct wmi_bss_info_hdr2))
 		return -EINVAL;
@@ -979,7 +986,8 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 	if (bih->frame_type == BEACON_FTYPE &&
 	    test_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags)) {
 		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
-		ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
+		ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
+					 NONE_BSS_FILTER, 0);
 	}
 
 	channel = ieee80211_get_channel(ar->wiphy, le16_to_cpu(bih->ch));
@@ -1016,7 +1024,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 						  IEEE80211_STYPE_BEACON);
 		memset(mgmt->da, 0xff, ETH_ALEN);
 	} else {
-		struct net_device *dev = ar->net_dev;
+		struct net_device *dev = vif->ndev;
 
 		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						  IEEE80211_STYPE_PROBE_RESP);
@@ -1144,20 +1152,21 @@ static int ath6kl_wmi_keepalive_reply_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
-static int ath6kl_wmi_scan_complete_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_scan_complete_rx(struct wmi *wmi, u8 *datap, int len,
+				       struct ath6kl_vif *vif)
 {
 	struct wmi_scan_complete_event *ev;
 
 	ev = (struct wmi_scan_complete_event *) datap;
 
-	ath6kl_scan_complete_evt(wmi->parent_dev, a_sle32_to_cpu(ev->status));
+	ath6kl_scan_complete_evt(vif, a_sle32_to_cpu(ev->status));
 	wmi->is_probe_ssid = false;
 
 	return 0;
 }
 
 static int ath6kl_wmi_neighbor_report_event_rx(struct wmi *wmi, u8 *datap,
-					       int len)
+					       int len, struct ath6kl_vif *vif)
 {
 	struct wmi_neighbor_report_event *ev;
 	u8 i;
@@ -1175,7 +1184,7 @@ static int ath6kl_wmi_neighbor_report_event_rx(struct wmi *wmi, u8 *datap,
 		ath6kl_dbg(ATH6KL_DBG_WMI, "neighbor %d/%d - %pM 0x%x\n",
 			   i + 1, ev->num_neighbors, ev->neighbor[i].bssid,
 			   ev->neighbor[i].bss_flags);
-		cfg80211_pmksa_candidate_notify(wmi->parent_dev->net_dev, i,
+		cfg80211_pmksa_candidate_notify(vif->ndev, i,
 						ev->neighbor[i].bssid,
 						!!(ev->neighbor[i].bss_flags &
 						   WMI_PREAUTH_CAPABLE_BSS),
@@ -1216,9 +1225,10 @@ static int ath6kl_wmi_error_event_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
-static int ath6kl_wmi_stats_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_stats_event_rx(struct wmi *wmi, u8 *datap, int len,
+				     struct ath6kl_vif *vif)
 {
-	ath6kl_tgt_stats_event(wmi->parent_dev, datap, len);
+	ath6kl_tgt_stats_event(vif, datap, len);
 
 	return 0;
 }
@@ -1372,7 +1382,8 @@ static int ath6kl_wmi_rssi_threshold_event_rx(struct wmi *wmi, u8 *datap,
 	return 0;
 }
 
-static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, u8 *datap, int len,
+				   struct ath6kl_vif *vif)
 {
 	struct wmi_cac_event *reply;
 	struct ieee80211_tspec_ie *ts;
@@ -1393,7 +1404,8 @@ static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, u8 *datap, int len)
 		tsid = (tsinfo >> IEEE80211_WMM_IE_TSPEC_TID_SHIFT) &
 			IEEE80211_WMM_IE_TSPEC_TID_MASK;
 
-		ath6kl_wmi_delete_pstream_cmd(wmi, reply->ac, tsid);
+		ath6kl_wmi_delete_pstream_cmd(wmi, vif->fw_vif_idx,
+					      reply->ac, tsid);
 	} else if (reply->cac_indication == CAC_INDICATION_NO_RESP) {
 		/*
 		 * Following assumes that there is only one outstanding
@@ -1408,7 +1420,8 @@ static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, u8 *datap, int len)
 				break;
 		}
 		if (index < (sizeof(active_tsids) * 8))
-			ath6kl_wmi_delete_pstream_cmd(wmi, reply->ac, index);
+			ath6kl_wmi_delete_pstream_cmd(wmi, vif->fw_vif_idx,
+						      reply->ac, index);
 	}
 
 	/*
@@ -1605,7 +1618,7 @@ int ath6kl_wmi_cmd_send(struct wmi *wmi, u8 if_idx, struct sk_buff *skb,
 		 * Make sure all data currently queued is transmitted before
 		 * the cmd execution.  Establish a new sync point.
 		 */
-		ath6kl_wmi_sync_point(wmi);
+		ath6kl_wmi_sync_point(wmi, if_idx);
 	}
 
 	skb_push(skb, sizeof(struct wmi_cmd_hdr));
@@ -1634,7 +1647,7 @@ int ath6kl_wmi_cmd_send(struct wmi *wmi, u8 if_idx, struct sk_buff *skb,
 		 * Make sure all new data queued waits for the command to
 		 * execute. Establish a new sync point.
 		 */
-		ath6kl_wmi_sync_point(wmi);
+		ath6kl_wmi_sync_point(wmi, if_idx);
 	}
 
 	return 0;
@@ -1816,7 +1829,7 @@ int ath6kl_wmi_scanparams_cmd(struct wmi *wmi, u8 if_idx,
 	return ret;
 }
 
-int ath6kl_wmi_bssfilter_cmd(struct wmi *wmi, u8 filter, u32 ie_mask)
+int ath6kl_wmi_bssfilter_cmd(struct wmi *wmi, u8 if_idx, u8 filter, u32 ie_mask)
 {
 	struct sk_buff *skb;
 	struct wmi_bss_filter_cmd *cmd;
@@ -1833,7 +1846,7 @@ int ath6kl_wmi_bssfilter_cmd(struct wmi *wmi, u8 filter, u32 ie_mask)
 	cmd->bss_filter = filter;
 	cmd->ie_mask = cpu_to_le32(ie_mask);
 
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_BSS_FILTER_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_BSS_FILTER_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
@@ -2010,7 +2023,7 @@ int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index,
 	return ret;
 }
 
-int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 *krk)
+int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 if_idx, u8 *krk)
 {
 	struct sk_buff *skb;
 	struct wmi_add_krk_cmd *cmd;
@@ -2023,7 +2036,7 @@ int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 *krk)
 	cmd = (struct wmi_add_krk_cmd *) skb->data;
 	memcpy(cmd->krk, krk, WMI_KRK_LEN);
 
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_ADD_KRK_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_ADD_KRK_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return ret;
@@ -2104,7 +2117,7 @@ static int ath6kl_wmi_data_sync_send(struct wmi *wmi, struct sk_buff *skb,
 	return ret;
 }
 
-static int ath6kl_wmi_sync_point(struct wmi *wmi)
+static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx)
 {
 	struct sk_buff *skb;
 	struct wmi_sync_cmd *cmd;
@@ -2160,7 +2173,7 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi)
 	 * Send sync cmd followed by sync data messages on all
 	 * endpoints being used
 	 */
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SYNCHRONIZE_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SYNCHRONIZE_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	if (ret)
@@ -2202,7 +2215,7 @@ free_skb:
 	return ret;
 }
 
-int ath6kl_wmi_create_pstream_cmd(struct wmi *wmi,
+int ath6kl_wmi_create_pstream_cmd(struct wmi *wmi, u8 if_idx,
 				  struct wmi_create_pstream_cmd *params)
 {
 	struct sk_buff *skb;
@@ -2291,12 +2304,13 @@ int ath6kl_wmi_create_pstream_cmd(struct wmi *wmi,
 		ath6kl_indicate_tx_activity(wmi->parent_dev,
 					    params->traffic_class, true);
 
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_CREATE_PSTREAM_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_CREATE_PSTREAM_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
 
-int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8 traffic_class, u8 tsid)
+int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8 if_idx, u8 traffic_class,
+				  u8 tsid)
 {
 	struct sk_buff *skb;
 	struct wmi_delete_pstream_cmd *cmd;
@@ -2332,7 +2346,7 @@ int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8 traffic_class, u8 tsid)
 		   "sending delete_pstream_cmd: traffic class: %d tsid=%d\n",
 		   traffic_class, tsid);
 
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_DELETE_PSTREAM_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_DELETE_PSTREAM_CMDID,
 				  SYNC_BEFORE_WMIFLAG);
 
 	spin_lock_bh(&wmi->lock);
@@ -2598,21 +2612,23 @@ static int ath6kl_wmi_get_pmkid_list_event_rx(struct wmi *wmi, u8 *datap,
 	return 0;
 }
 
-static int ath6kl_wmi_addba_req_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_addba_req_event_rx(struct wmi *wmi, u8 *datap, int len,
+					 struct ath6kl_vif *vif)
 {
 	struct wmi_addba_req_event *cmd = (struct wmi_addba_req_event *) datap;
 
-	aggr_recv_addba_req_evt(wmi->parent_dev, cmd->tid,
+	aggr_recv_addba_req_evt(vif, cmd->tid,
 				le16_to_cpu(cmd->st_seq_no), cmd->win_sz);
 
 	return 0;
 }
 
-static int ath6kl_wmi_delba_req_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_delba_req_event_rx(struct wmi *wmi, u8 *datap, int len,
+					 struct ath6kl_vif *vif)
 {
 	struct wmi_delba_event *cmd = (struct wmi_delba_event *) datap;
 
-	aggr_recv_delba_req_evt(wmi->parent_dev, cmd->tid);
+	aggr_recv_delba_req_evt(vif, cmd->tid);
 
 	return 0;
 }
@@ -2661,7 +2677,8 @@ int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 if_idx, u8 cmd, const u8 *mac,
 				   NO_SYNC_WMIFLAG);
 }
 
-static int ath6kl_wmi_pspoll_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_pspoll_event_rx(struct wmi *wmi, u8 *datap, int len,
+				      struct ath6kl_vif *vif)
 {
 	struct wmi_pspoll_event *ev;
 
@@ -2670,14 +2687,15 @@ static int ath6kl_wmi_pspoll_event_rx(struct wmi *wmi, u8 *datap, int len)
 
 	ev = (struct wmi_pspoll_event *) datap;
 
-	ath6kl_pspoll_event(wmi->parent_dev, le16_to_cpu(ev->aid));
+	ath6kl_pspoll_event(vif, le16_to_cpu(ev->aid));
 
 	return 0;
 }
 
-static int ath6kl_wmi_dtimexpiry_event_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_dtimexpiry_event_rx(struct wmi *wmi, u8 *datap, int len,
+					  struct ath6kl_vif *vif)
 {
-	ath6kl_dtimexpiry_event(wmi->parent_dev);
+	ath6kl_dtimexpiry_event(vif);
 
 	return 0;
 }
@@ -2930,8 +2948,10 @@ static int ath6kl_wmi_roam_tbl_event_rx(struct wmi *wmi, u8 *datap, int len)
 int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd;
+	struct ath6kl_vif *vif;
 	u32 len;
 	u16 id;
+	u8 if_idx;
 	u8 *datap;
 	int ret = 0;
 
@@ -2946,6 +2966,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 
 	cmd = (struct wmi_cmd_hdr *) skb->data;
 	id = le16_to_cpu(cmd->cmd_id);
+	if_idx = le16_to_cpu(cmd->info1) & WMI_CMD_HDR_IF_ID_MASK;
 
 	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
 
@@ -2956,6 +2977,15 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 	ath6kl_dbg_dump(ATH6KL_DBG_WMI_DUMP, NULL, "wmi rx ",
 			datap, len);
 
+	vif = ath6kl_get_vif_by_index(wmi->parent_dev, if_idx);
+	if (!vif) {
+		ath6kl_dbg(ATH6KL_DBG_WMI,
+			   "Wmi event for unavailable vif, vif_index:%d\n",
+			    if_idx);
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
 	switch (id) {
 	case WMI_GET_BITRATE_CMDID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_GET_BITRATE_CMDID\n");
@@ -2975,11 +3005,11 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_CONNECT_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_CONNECT_EVENTID\n");
-		ret = ath6kl_wmi_connect_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_connect_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_DISCONNECT_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_DISCONNECT_EVENTID\n");
-		ret = ath6kl_wmi_disconnect_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_disconnect_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_PEER_NODE_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_PEER_NODE_EVENTID\n");
@@ -2987,11 +3017,11 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_TKIP_MICERR_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TKIP_MICERR_EVENTID\n");
-		ret = ath6kl_wmi_tkip_micerr_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_tkip_micerr_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_BSSINFO_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_BSSINFO_EVENTID\n");
-		ret = ath6kl_wmi_bssinfo_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_bssinfo_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_REGDOMAIN_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REGDOMAIN_EVENTID\n");
@@ -3003,11 +3033,12 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_NEIGHBOR_REPORT_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_NEIGHBOR_REPORT_EVENTID\n");
-		ret = ath6kl_wmi_neighbor_report_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_neighbor_report_event_rx(wmi, datap, len,
+							  vif);
 		break;
 	case WMI_SCAN_COMPLETE_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_SCAN_COMPLETE_EVENTID\n");
-		ret = ath6kl_wmi_scan_complete_rx(wmi, datap, len);
+		ret = ath6kl_wmi_scan_complete_rx(wmi, datap, len, vif);
 		break;
 	case WMI_CMDERROR_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_CMDERROR_EVENTID\n");
@@ -3015,7 +3046,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_REPORT_STATISTICS_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REPORT_STATISTICS_EVENTID\n");
-		ret = ath6kl_wmi_stats_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_stats_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_RSSI_THRESHOLD_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RSSI_THRESHOLD_EVENTID\n");
@@ -3038,7 +3069,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_CAC_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_CAC_EVENTID\n");
-		ret = ath6kl_wmi_cac_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_cac_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_CHANNEL_CHANGE_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_CHANNEL_CHANGE_EVENTID\n");
@@ -3082,25 +3113,25 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_PSPOLL_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_PSPOLL_EVENTID\n");
-		ret = ath6kl_wmi_pspoll_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_pspoll_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_DTIMEXPIRY_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_DTIMEXPIRY_EVENTID\n");
-		ret = ath6kl_wmi_dtimexpiry_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_dtimexpiry_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_SET_PARAMS_REPLY_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_SET_PARAMS_REPLY_EVENTID\n");
 		break;
 	case WMI_ADDBA_REQ_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_ADDBA_REQ_EVENTID\n");
-		ret = ath6kl_wmi_addba_req_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_addba_req_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_ADDBA_RESP_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_ADDBA_RESP_EVENTID\n");
 		break;
 	case WMI_DELBA_REQ_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_DELBA_REQ_EVENTID\n");
-		ret = ath6kl_wmi_delba_req_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_delba_req_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_REPORT_BTCOEX_CONFIG_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI,
@@ -3116,21 +3147,21 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_REMAIN_ON_CHNL_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REMAIN_ON_CHNL_EVENTID\n");
-		ret = ath6kl_wmi_remain_on_chnl_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_remain_on_chnl_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_CANCEL_REMAIN_ON_CHNL_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI,
 			   "WMI_CANCEL_REMAIN_ON_CHNL_EVENTID\n");
 		ret = ath6kl_wmi_cancel_remain_on_chnl_event_rx(wmi, datap,
-								len);
+								len, vif);
 		break;
 	case WMI_TX_STATUS_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TX_STATUS_EVENTID\n");
-		ret = ath6kl_wmi_tx_status_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_tx_status_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_RX_PROBE_REQ_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_PROBE_REQ_EVENTID\n");
-		ret = ath6kl_wmi_rx_probe_req_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_rx_probe_req_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_P2P_CAPABILITIES_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_P2P_CAPABILITIES_EVENTID\n");
@@ -3138,7 +3169,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_RX_ACTION_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_ACTION_EVENTID\n");
-		ret = ath6kl_wmi_rx_action_event_rx(wmi, datap, len);
+		ret = ath6kl_wmi_rx_action_event_rx(wmi, datap, len, vif);
 		break;
 	case WMI_P2P_INFO_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_P2P_INFO_EVENTID\n");
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 83bf46c..d2c9510 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2171,9 +2171,9 @@ int ath6kl_wmi_data_hdr_add(struct wmi *wmi, struct sk_buff *skb,
 
 int ath6kl_wmi_dot11_hdr_remove(struct wmi *wmi, struct sk_buff *skb);
 int ath6kl_wmi_dot3_2_dix(struct sk_buff *skb);
-int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, struct sk_buff *skb,
-				       u32 layer2_priority, bool wmm_enabled,
-				       u8 *ac);
+int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, u8 if_idx,
+				       struct sk_buff *skb, u32 layer2_priority,
+				       bool wmm_enabled, u8 *ac);
 
 int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb);
 
@@ -2204,7 +2204,8 @@ int ath6kl_wmi_scanparams_cmd(struct wmi *wmi, u8 if_idx, u16 fg_start_sec,
 			      u16 pas_chdw_msec, u8 short_scan_ratio,
 			      u8 scan_ctrl_flag, u32 max_dfsch_act_time,
 			      u16 maxact_scan_per_ssid);
-int ath6kl_wmi_bssfilter_cmd(struct wmi *wmi, u8 filter, u32 ie_mask);
+int ath6kl_wmi_bssfilter_cmd(struct wmi *wmi, u8 if_idx, u8 filter,
+			     u32 ie_mask);
 int ath6kl_wmi_probedssid_cmd(struct wmi *wmi, u8 if_idx, u8 index, u8 flag,
 			      u8 ssid_len, u8 *ssid);
 int ath6kl_wmi_listeninterval_cmd(struct wmi *wmi, u8 if_idx,
@@ -2216,9 +2217,10 @@ int ath6kl_wmi_pmparams_cmd(struct wmi *wmi, u16 idle_period,
 			    u16 tx_wakup_policy, u16 num_tx_to_wakeup,
 			    u16 ps_fail_event_policy);
 int ath6kl_wmi_disctimeout_cmd(struct wmi *wmi, u8 timeout);
-int ath6kl_wmi_create_pstream_cmd(struct wmi *wmi,
+int ath6kl_wmi_create_pstream_cmd(struct wmi *wmi, u8 if_idx,
 				  struct wmi_create_pstream_cmd *pstream);
-int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8 traffic_class, u8 tsid);
+int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8 if_idx, u8 traffic_class,
+				  u8 tsid);
 
 int ath6kl_wmi_set_rts_cmd(struct wmi *wmi, u16 threshold);
 int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 status,
@@ -2234,7 +2236,7 @@ int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index,
 			  u8 *key_rsc, u8 *key_material,
 			  u8 key_op_ctrl, u8 *mac_addr,
 			  enum wmi_sync_flag sync_flag);
-int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 *krk);
+int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 if_idx, u8 *krk);
 int ath6kl_wmi_deletekey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index);
 int ath6kl_wmi_setpmkid_cmd(struct wmi *wmi, u8 if_idx, const u8 *bssid,
 			    const u8 *pmkid, bool set);
-- 
1.7.0.4

