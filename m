Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19108 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab1IJJ4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Sep 2011 05:56:43 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] ath6kl: Remove auth type fall back in auto authentication mode
Date: Sat, 10 Sep 2011 15:26:34 +0530
Message-ID: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110910_115653_122452_FDDC2803)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Target already tries with different authentication mechanism
when authentication type is configured to NL80211_AUTHTYPE_AUTOMATIC.
Remove this piece of code from driver. Having this code in driver
even affects auto + WEP authentication in some cases.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   74 +++++-----------------------
 drivers/net/wireless/ath/ath6kl/core.h     |    2 -
 drivers/net/wireless/ath/ath6kl/init.c     |    1 -
 drivers/net/wireless/ath/ath6kl/wmi.h      |    5 --
 4 files changed, 12 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a889bf4..fcef417 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -158,8 +158,7 @@ static int ath6kl_set_auth_type(struct ath6kl *ar,
 		break;
 
 	case NL80211_AUTHTYPE_AUTOMATIC:
-		ar->dot11_auth_mode = OPEN_AUTH;
-		ar->auto_auth_stage = AUTH_OPEN_IN_PROGRESS;
+		ar->dot11_auth_mode = OPEN_AUTH | SHARED_AUTH;
 		break;
 
 	default:
@@ -446,8 +445,6 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 	assoc_req_len -= assoc_req_ie_offset;
 	assoc_resp_len -= assoc_resp_ie_offset;
 
-	ar->auto_auth_stage = AUTH_IDLE;
-
 	if (nw_type & ADHOC_NETWORK) {
 		if (ar->wdev->iftype != NL80211_IFTYPE_ADHOC) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
@@ -599,9 +596,6 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 				      u8 *bssid, u8 assoc_resp_len,
 				      u8 *assoc_info, u16 proto_reason)
 {
-	struct ath6kl_key *key = NULL;
-	u16 status;
-
 	if (ar->scan_req) {
 		cfg80211_scan_done(ar->scan_req, true);
 		ar->scan_req = NULL;
@@ -643,64 +637,20 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 	if (reason != DISCONNECT_CMD)
 		return;
 
-	if (!ar->auto_auth_stage) {
-		clear_bit(CONNECT_PEND, &ar->flag);
-
-		if (ar->sme_state == SME_CONNECTING) {
-			cfg80211_connect_result(ar->net_dev,
-						bssid, NULL, 0,
-						NULL, 0,
-						WLAN_STATUS_UNSPECIFIED_FAILURE,
-						GFP_KERNEL);
-		} else if (ar->sme_state == SME_CONNECTED) {
-			cfg80211_disconnected(ar->net_dev, reason,
-					      NULL, 0, GFP_KERNEL);
-		}
-
-		ar->sme_state = SME_DISCONNECTED;
-		return;
-	}
-
-	if (ar->dot11_auth_mode != OPEN_AUTH)
-		return;
+	clear_bit(CONNECT_PEND, &ar->flag);
 
-	/*
-	 * If the current auth algorithm is open, try shared and
-	 * make autoAuthStage idle. We do not make it leap for now
-	 * being.
-	 */
-	key = &ar->keys[ar->def_txkey_index];
-	if (down_interruptible(&ar->sem)) {
-		ath6kl_err("busy, couldn't get access\n");
-		return;
+	if (ar->sme_state == SME_CONNECTING) {
+		cfg80211_connect_result(ar->net_dev,
+				bssid, NULL, 0,
+				NULL, 0,
+				WLAN_STATUS_UNSPECIFIED_FAILURE,
+				GFP_KERNEL);
+	} else if (ar->sme_state == SME_CONNECTED) {
+		cfg80211_disconnected(ar->net_dev, reason,
+				NULL, 0, GFP_KERNEL);
 	}
 
-	ar->dot11_auth_mode = SHARED_AUTH;
-	ar->auto_auth_stage = AUTH_IDLE;
-
-	ath6kl_wmi_addkey_cmd(ar->wmi,
-			      ar->def_txkey_index,
-			      ar->prwise_crypto,
-			      GROUP_USAGE | TX_USAGE,
-			      key->key_len, NULL,
-			      key->key,
-			      KEY_OP_INIT_VAL, NULL,
-			      NO_SYNC_WMIFLAG);
-
-	status = ath6kl_wmi_connect_cmd(ar->wmi,
-					ar->nw_type,
-					ar->dot11_auth_mode,
-					ar->auth_mode,
-					ar->prwise_crypto,
-					ar->prwise_crypto_len,
-					ar->grp_crypto,
-					ar->grp_crypto_len,
-					ar->ssid_len,
-					ar->ssid,
-					ar->req_bssid,
-					ar->ch_hint,
-					ar->connect_ctrl_flags);
-	up(&ar->sem);
+	ar->sme_state = SME_DISCONNECTED;
 }
 
 static inline bool is_ch_11a(u16 ch)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c6ed1fc..b49e869 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -435,8 +435,6 @@ struct ath6kl {
 	enum wlan_low_pwr_state wlan_pwr_state;
 	struct wmi_scan_params_cmd sc_params;
 #define AR_MCAST_FILTER_MAC_ADDR_SIZE  4
-	u8 auto_auth_stage;
-
 	struct {
 		void *rx_report;
 		size_t rx_report_len;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index eca34aa..23ab9c3 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -603,7 +603,6 @@ struct ath6kl *ath6kl_core_alloc(struct device *sdev)
 	SET_NETDEV_DEV(dev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = dev;
 	ar->sme_state = SME_DISCONNECTED;
-	ar->auto_auth_stage = AUTH_IDLE;
 
 	init_netdev(dev);
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index dc49ef8..f036e78 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -566,11 +566,6 @@ enum dot11_auth_mode {
 	LEAP_AUTH = 0x04,
 };
 
-enum {
-	AUTH_IDLE,
-	AUTH_OPEN_IN_PROGRESS,
-};
-
 enum auth_mode {
 	NONE_AUTH = 0x01,
 	WPA_AUTH = 0x02,
-- 
1.7.0.4

