Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4060 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580Ab1JYOGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:06:46 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 09/31] ath6kl: Move bssid information to vif structure
Date: Tue, 25 Oct 2011 19:34:04 +0530
Message-ID: <1319551466-29070-10-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160652_754579_089681A3)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   27 ++++++++++++++++-----------
 drivers/net/wireless/ath/ath6kl/core.h     |    4 ++--
 drivers/net/wireless/ath/ath6kl/init.c     |    4 ++--
 drivers/net/wireless/ath/ath6kl/main.c     |    8 ++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |    2 +-
 5 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5164e65..4861fd7 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -363,7 +363,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	    vif->ssid_len == sme->ssid_len &&
 	    !memcmp(vif->ssid, sme->ssid, vif->ssid_len)) {
 		ar->reconnect_flag = true;
-		status = ath6kl_wmi_reconnect_cmd(ar->wmi, ar->req_bssid,
+		status = ath6kl_wmi_reconnect_cmd(ar->wmi, vif->req_bssid,
 						  ar->ch_hint);
 
 		up(&ar->sem);
@@ -384,9 +384,9 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	if (sme->channel)
 		ar->ch_hint = sme->channel->center_freq;
 
-	memset(ar->req_bssid, 0, sizeof(ar->req_bssid));
+	memset(vif->req_bssid, 0, sizeof(vif->req_bssid));
 	if (sme->bssid && !is_broadcast_ether_addr(sme->bssid))
-		memcpy(ar->req_bssid, sme->bssid, sizeof(ar->req_bssid));
+		memcpy(vif->req_bssid, sme->bssid, sizeof(vif->req_bssid));
 
 	ath6kl_set_wpa_version(ar, sme->crypto.wpa_versions);
 
@@ -461,7 +461,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 					vif->prwise_crypto_len,
 					vif->grp_crypto, vif->grp_crypto_len,
 					vif->ssid_len, vif->ssid,
-					ar->req_bssid, ar->ch_hint,
+					vif->req_bssid, ar->ch_hint,
 					ar->connect_ctrl_flags);
 
 	up(&ar->sem);
@@ -644,7 +644,7 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 	vif->ssid_len = 0;
 
 	if (!test_bit(SKIP_SCAN, &ar->flag))
-		memset(ar->req_bssid, 0, sizeof(ar->req_bssid));
+		memset(vif->req_bssid, 0, sizeof(vif->req_bssid));
 
 	up(&ar->sem);
 
@@ -1071,10 +1071,13 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 void ath6kl_cfg80211_tkip_micerr_event(struct ath6kl *ar, u8 keyid,
 				       bool ismcast)
 {
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
+
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 		   "%s: keyid %d, ismcast %d\n", __func__, keyid, ismcast);
 
-	cfg80211_michael_mic_failure(ar->net_dev, ar->bssid,
+	cfg80211_michael_mic_failure(ar->net_dev, vif->bssid,
 				     (ismcast ? NL80211_KEYTYPE_GROUP :
 				      NL80211_KEYTYPE_PAIRWISE), keyid, NULL,
 				     GFP_KERNEL);
@@ -1261,9 +1264,10 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 		return -EOPNOTSUPP;
 	}
 
-	memset(ar->req_bssid, 0, sizeof(ar->req_bssid));
+	memset(vif->req_bssid, 0, sizeof(vif->req_bssid));
 	if (ibss_param->bssid && !is_broadcast_ether_addr(ibss_param->bssid))
-		memcpy(ar->req_bssid, ibss_param->bssid, sizeof(ar->req_bssid));
+		memcpy(vif->req_bssid, ibss_param->bssid,
+		       sizeof(vif->req_bssid));
 
 	ath6kl_set_wpa_version(ar, 0);
 
@@ -1296,7 +1300,7 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 					vif->prwise_crypto_len,
 					vif->grp_crypto, vif->grp_crypto_len,
 					vif->ssid_len, vif->ssid,
-					ar->req_bssid, ar->ch_hint,
+					vif->req_bssid, ar->ch_hint,
 					ar->connect_ctrl_flags);
 	set_bit(CONNECT_PEND, &vif->flags);
 
@@ -1399,7 +1403,7 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 	int ret;
 	u8 mcs;
 
-	if (memcmp(mac, ar->bssid, ETH_ALEN) != 0)
+	if (memcmp(mac, vif->bssid, ETH_ALEN) != 0)
 		return -ENOENT;
 
 	if (down_interruptible(&ar->sem))
@@ -1509,7 +1513,8 @@ static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	struct ath6kl_vif *vif = netdev_priv(netdev);
 
 	if (test_bit(CONNECTED, &vif->flags))
-		return ath6kl_wmi_setpmkid_cmd(ar->wmi, ar->bssid, NULL, false);
+		return ath6kl_wmi_setpmkid_cmd(ar->wmi, vif->bssid,
+					       NULL, false);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 714092a..298b339 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -409,6 +409,8 @@ struct ath6kl_vif {
 	u8 def_txkey_index;
 	u8 next_mode;
 	u8 nw_type;
+	u8 bssid[ETH_ALEN];
+	u8 req_bssid[ETH_ALEN];
 };
 
 /* Flag info */
@@ -438,8 +440,6 @@ struct ath6kl {
 	spinlock_t lock;
 	struct semaphore sem;
 	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
-	u8 bssid[ETH_ALEN];
-	u8 req_bssid[ETH_ALEN];
 	u16 ch_hint;
 	u16 bss_ch;
 	u16 listen_intvl_b;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index e6f4dde..a43bb29 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -88,8 +88,8 @@ void ath6kl_init_profile_info(struct ath6kl *ar)
 	vif->grp_crypto = NONE_CRYPT;
 	vif->grp_crypto_len = 0;
 	memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
-	memset(ar->req_bssid, 0, sizeof(ar->req_bssid));
-	memset(ar->bssid, 0, sizeof(ar->bssid));
+	memset(vif->req_bssid, 0, sizeof(vif->req_bssid));
+	memset(vif->bssid, 0, sizeof(vif->bssid));
 	ar->bss_ch = 0;
 	vif->nw_type = vif->next_mode = INFRA_NETWORK;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 4add0ef..bdefb89 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -464,7 +464,7 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 		if (discon_issued)
 			ath6kl_disconnect_event(ar, DISCONNECT_CMD,
 						(vif->nw_type & AP_NETWORK) ?
-						bcast_mac : ar->bssid,
+						bcast_mac : vif->bssid,
 						0, NULL, 0);
 
 		ar->user_key_ctrl = 0;
@@ -943,7 +943,7 @@ void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 
 	switch (ar->sme_state) {
 	case SME_CONNECTING:
-		cfg80211_connect_result(ar->net_dev, ar->bssid, NULL, 0,
+		cfg80211_connect_result(ar->net_dev, vif->bssid, NULL, 0,
 					NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE,
 					GFP_KERNEL);
@@ -1057,7 +1057,7 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 				      assoc_req_len, assoc_resp_len,
 				      assoc_info);
 
-	memcpy(ar->bssid, bssid, sizeof(ar->bssid));
+	memcpy(vif->bssid, bssid, sizeof(vif->bssid));
 	ar->bss_ch = channel;
 
 	if ((vif->nw_type == INFRA_NETWORK))
@@ -1433,7 +1433,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 		ar->user_key_ctrl = 0;
 
 	netif_stop_queue(ar->net_dev);
-	memset(ar->bssid, 0, sizeof(ar->bssid));
+	memset(vif->bssid, 0, sizeof(vif->bssid));
 	ar->bss_ch = 0;
 
 	ath6kl_tx_data_cleanup(ar);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 701d26d..2f4e8b5 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -988,7 +988,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 		return -EINVAL;
 
 	if (bih->frame_type == BEACON_FTYPE && test_bit(CONNECTED, &vif->flags)
-	    && memcmp(bih->bssid, ar->bssid, ETH_ALEN) == 0) {
+	    && memcmp(bih->bssid, vif->bssid, ETH_ALEN) == 0) {
 		const u8 *tim;
 		tim = cfg80211_find_ie(WLAN_EID_TIM, buf + 8 + 2 + 2,
 				       len - 8 - 2 - 2);
-- 
1.7.0.4

