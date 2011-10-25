Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38824 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1JYKMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:12:15 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 14/34] ath6kl: Move scan_req info and sme_state to vif
Date: Tue, 25 Oct 2011 15:40:10 +0530
Message-ID: <1319537430-12459-15-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121220_392502_CC8A0C87)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   49 +++++++++++++++------------
 drivers/net/wireless/ath/ath6kl/core.h     |    4 +-
 drivers/net/wireless/ath/ath6kl/main.c     |    4 +-
 3 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index dacad7a..5ef8d35 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -311,7 +311,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	int status;
 
-	ar->sme_state = SME_CONNECTING;
+	vif->sme_state = SME_CONNECTING;
 
 	if (!ath6kl_cfg80211_ready(ar))
 		return -EIO;
@@ -601,14 +601,14 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 		return;
 	}
 
-	if (ar->sme_state == SME_CONNECTING) {
+	if (vif->sme_state == SME_CONNECTING) {
 		/* inform connect result to cfg80211 */
-		ar->sme_state = SME_CONNECTED;
+		vif->sme_state = SME_CONNECTED;
 		cfg80211_connect_result(ar->net_dev, bssid,
 					assoc_req_ie, assoc_req_len,
 					assoc_resp_ie, assoc_resp_len,
 					WLAN_STATUS_SUCCESS, GFP_KERNEL);
-	} else if (ar->sme_state == SME_CONNECTED) {
+	} else if (vif->sme_state == SME_CONNECTED) {
 		/* inform roam event to cfg80211 */
 		cfg80211_roamed(ar->net_dev, chan, bssid,
 				assoc_req_ie, assoc_req_len,
@@ -648,7 +648,7 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 
 	up(&ar->sem);
 
-	ar->sme_state = SME_DISCONNECTED;
+	vif->sme_state = SME_DISCONNECTED;
 
 	return 0;
 }
@@ -660,9 +660,9 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 	/* TODO: Findout vif */
 	struct ath6kl_vif *vif = ar->vif;
 
-	if (ar->scan_req) {
-		cfg80211_scan_done(ar->scan_req, true);
-		ar->scan_req = NULL;
+	if (vif->scan_req) {
+		cfg80211_scan_done(vif->scan_req, true);
+		vif->scan_req = NULL;
 	}
 
 	if (vif->nw_type & ADHOC_NETWORK) {
@@ -701,18 +701,18 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 
 	clear_bit(CONNECT_PEND, &vif->flags);
 
-	if (ar->sme_state == SME_CONNECTING) {
+	if (vif->sme_state == SME_CONNECTING) {
 		cfg80211_connect_result(ar->net_dev,
 				bssid, NULL, 0,
 				NULL, 0,
 				WLAN_STATUS_UNSPECIFIED_FAILURE,
 				GFP_KERNEL);
-	} else if (ar->sme_state == SME_CONNECTED) {
+	} else if (vif->sme_state == SME_CONNECTED) {
 		cfg80211_disconnected(ar->net_dev, reason,
 				NULL, 0, GFP_KERNEL);
 	}
 
-	ar->sme_state = SME_DISCONNECTED;
+	vif->sme_state = SME_DISCONNECTED;
 }
 
 static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
@@ -793,7 +793,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	if (ret)
 		ath6kl_err("wmi_startscan_cmd failed\n");
 	else
-		ar->scan_req = request;
+		vif->scan_req = request;
 
 	kfree(channels);
 
@@ -802,22 +802,24 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 
 void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status)
 {
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
 	int i;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: status %d\n", __func__, status);
 
-	if (!ar->scan_req)
+	if (!vif->scan_req)
 		return;
 
 	if ((status == -ECANCELED) || (status == -EBUSY)) {
-		cfg80211_scan_done(ar->scan_req, true);
+		cfg80211_scan_done(vif->scan_req, true);
 		goto out;
 	}
 
-	cfg80211_scan_done(ar->scan_req, false);
+	cfg80211_scan_done(vif->scan_req, false);
 
-	if (ar->scan_req->n_ssids && ar->scan_req->ssids[0].ssid_len) {
-		for (i = 0; i < ar->scan_req->n_ssids; i++) {
+	if (vif->scan_req->n_ssids && vif->scan_req->ssids[0].ssid_len) {
+		for (i = 0; i < vif->scan_req->n_ssids; i++) {
 			ath6kl_wmi_probedssid_cmd(ar->wmi, i + 1,
 						  DISABLE_SSID_FLAG,
 						  0, NULL);
@@ -825,7 +827,7 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status)
 	}
 
 out:
-	ar->scan_req = NULL;
+	vif->scan_req = NULL;
 }
 
 static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
@@ -2125,7 +2127,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	if (register_netdev(ndev))
 		goto err;
 
-	ar->sme_state = SME_DISCONNECTED;
+	vif->sme_state = SME_DISCONNECTED;
 	set_bit(WLAN_ENABLED, &vif->flags);
 	ar->wlan_pwr_state = WLAN_POWER_STATE_ON;
 	set_bit(NETDEV_REGISTERED, &vif->flags);
@@ -2140,9 +2142,12 @@ err:
 
 void ath6kl_deinit_ieee80211_hw(struct ath6kl *ar)
 {
-	if (ar->scan_req) {
-		cfg80211_scan_done(ar->scan_req, true);
-		ar->scan_req = NULL;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
+
+	if (vif->scan_req) {
+		cfg80211_scan_done(vif->scan_req, true);
+		vif->scan_req = NULL;
 	}
 
 	wiphy_unregister(ar->wiphy);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c2e0269..2317cc9 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -417,6 +417,8 @@ struct ath6kl_vif {
 	struct ath6kl_key keys[WMI_MAX_KEY_INDEX + 1];
 	struct aggr_info *aggr_cntxt;
 	struct timer_list disconnect_timer;
+	struct cfg80211_scan_request *scan_req;
+	enum sme_state sme_state;
 };
 
 /* Flag info */
@@ -480,8 +482,6 @@ struct ath6kl {
 	struct list_head amsdu_rx_buffer_queue;
 	u8 rx_meta_ver;
 	struct wireless_dev *wdev;
-	struct cfg80211_scan_request *scan_req;
-	enum sme_state sme_state;
 	enum wlan_low_pwr_state wlan_pwr_state;
 	struct wmi_scan_params_cmd sc_params;
 #define AR_MCAST_FILTER_MAC_ADDR_SIZE  4
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 6dbced0..adab098 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -660,7 +660,7 @@ void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 	/* TODO: Pass vif instead of taking it from ar */
 	struct ath6kl_vif *vif = ar->vif;
 
-	switch (ar->sme_state) {
+	switch (vif->sme_state) {
 	case SME_CONNECTING:
 		cfg80211_connect_result(ar->net_dev, vif->bssid, NULL, 0,
 					NULL, 0,
@@ -682,7 +682,7 @@ void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 	    test_bit(CONNECT_PEND, &vif->flags))
 		ath6kl_wmi_disconnect_cmd(ar->wmi);
 
-	ar->sme_state = SME_DISCONNECTED;
+	vif->sme_state = SME_DISCONNECTED;
 
 	/* disable scanning */
 	if (ath6kl_wmi_scanparams_cmd(ar->wmi, 0xFFFF, 0, 0, 0, 0, 0, 0, 0,
-- 
1.7.0.4

