Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37218 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab1JYKLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:11:37 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 10/34] ath6kl: Move channel information to vif structure
Date: Tue, 25 Oct 2011 15:40:06 +0530
Message-ID: <1319537430-12459-11-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121142_269407_0B96ADF5)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 +++++++-------
 drivers/net/wireless/ath/ath6kl/core.h     |    4 ++--
 drivers/net/wireless/ath/ath6kl/init.c     |    4 ++--
 drivers/net/wireless/ath/ath6kl/main.c     |    4 ++--
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 98d7673..e48a8c0 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -364,7 +364,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	    !memcmp(vif->ssid, sme->ssid, vif->ssid_len)) {
 		ar->reconnect_flag = true;
 		status = ath6kl_wmi_reconnect_cmd(ar->wmi, vif->req_bssid,
-						  ar->ch_hint);
+						  vif->ch_hint);
 
 		up(&ar->sem);
 		if (status) {
@@ -382,7 +382,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(vif->ssid, sme->ssid, sme->ssid_len);
 
 	if (sme->channel)
-		ar->ch_hint = sme->channel->center_freq;
+		vif->ch_hint = sme->channel->center_freq;
 
 	memset(vif->req_bssid, 0, sizeof(vif->req_bssid));
 	if (sme->bssid && !is_broadcast_ether_addr(sme->bssid))
@@ -452,7 +452,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		   __func__,
 		   vif->auth_mode, vif->dot11_auth_mode, vif->prwise_crypto,
 		   vif->prwise_crypto_len, vif->grp_crypto,
-		   vif->grp_crypto_len, ar->ch_hint);
+		   vif->grp_crypto_len, vif->ch_hint);
 
 	ar->reconnect_flag = 0;
 	status = ath6kl_wmi_connect_cmd(ar->wmi, vif->nw_type,
@@ -461,7 +461,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 					vif->prwise_crypto_len,
 					vif->grp_crypto, vif->grp_crypto_len,
 					vif->ssid_len, vif->ssid,
-					vif->req_bssid, ar->ch_hint,
+					vif->req_bssid, vif->ch_hint,
 					ar->connect_ctrl_flags);
 
 	up(&ar->sem);
@@ -1252,7 +1252,7 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 	memcpy(vif->ssid, ibss_param->ssid, vif->ssid_len);
 
 	if (ibss_param->channel)
-		ar->ch_hint = ibss_param->channel->center_freq;
+		vif->ch_hint = ibss_param->channel->center_freq;
 
 	if (ibss_param->channel_fixed) {
 		/*
@@ -1292,7 +1292,7 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 		   __func__,
 		   vif->auth_mode, vif->dot11_auth_mode, vif->prwise_crypto,
 		   vif->prwise_crypto_len, vif->grp_crypto,
-		   vif->grp_crypto_len, ar->ch_hint);
+		   vif->grp_crypto_len, vif->ch_hint);
 
 	status = ath6kl_wmi_connect_cmd(ar->wmi, vif->nw_type,
 					vif->dot11_auth_mode, vif->auth_mode,
@@ -1300,7 +1300,7 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 					vif->prwise_crypto_len,
 					vif->grp_crypto, vif->grp_crypto_len,
 					vif->ssid_len, vif->ssid,
-					vif->req_bssid, ar->ch_hint,
+					vif->req_bssid, vif->ch_hint,
 					ar->connect_ctrl_flags);
 	set_bit(CONNECT_PEND, &vif->flags);
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f830b2d..843d639 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -411,6 +411,8 @@ struct ath6kl_vif {
 	u8 nw_type;
 	u8 bssid[ETH_ALEN];
 	u8 req_bssid[ETH_ALEN];
+	u16 ch_hint;
+	u16 bss_ch;
 };
 
 /* Flag info */
@@ -440,8 +442,6 @@ struct ath6kl {
 	spinlock_t lock;
 	struct semaphore sem;
 	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
-	u16 ch_hint;
-	u16 bss_ch;
 	u16 listen_intvl_b;
 	u16 listen_intvl_t;
 	u8 lrssi_roam_threshold;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index bea337a..a662d78 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -90,7 +90,7 @@ void ath6kl_init_profile_info(struct ath6kl *ar)
 	memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
 	memset(vif->req_bssid, 0, sizeof(vif->req_bssid));
 	memset(vif->bssid, 0, sizeof(vif->bssid));
-	ar->bss_ch = 0;
+	vif->bss_ch = 0;
 	vif->nw_type = vif->next_mode = INFRA_NETWORK;
 }
 
@@ -253,7 +253,7 @@ void ath6kl_init_control_info(struct ath6kl *ar)
 	ath6kl_init_profile_info(ar);
 	vif->def_txkey_index = 0;
 	memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
-	ar->ch_hint = 0;
+	vif->ch_hint = 0;
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 620679a..e60f663 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -777,7 +777,7 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 				      assoc_info);
 
 	memcpy(vif->bssid, bssid, sizeof(vif->bssid));
-	ar->bss_ch = channel;
+	vif->bss_ch = channel;
 
 	if ((vif->nw_type == INFRA_NETWORK))
 		ath6kl_wmi_listeninterval_cmd(ar->wmi, ar->listen_intvl_t,
@@ -1152,7 +1152,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 
 	netif_stop_queue(ar->net_dev);
 	memset(vif->bssid, 0, sizeof(vif->bssid));
-	ar->bss_ch = 0;
+	vif->bss_ch = 0;
 
 	ath6kl_tx_data_cleanup(ar);
 }
-- 
1.7.0.4

