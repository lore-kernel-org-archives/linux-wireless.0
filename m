Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40418 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab1JKOcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 10:32:48 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 5/5] ath6kl: Allow CCKM AKM and KRK to be configured
Date: Tue, 11 Oct 2011 17:31:57 +0300
Message-ID: <1318343517-15292-6-git-send-email-jouni@qca.qualcomm.com> (sfid-20111011_163251_867401_B6A04863)
In-Reply-To: <1318343517-15292-1-git-send-email-jouni@qca.qualcomm.com>
References: <1318343517-15292-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use vendor-specific suite selectors to allow CCKM to be configured.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b7b2c57..6b30b75 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -121,6 +121,8 @@ static struct ieee80211_supported_band ath6kl_band_5ghz = {
 	.bitrates = ath6kl_a_rates,
 };
 
+#define CCKM_KRK_CIPHER_SUITE 0x004096ff /* use for KRK */
+
 static int ath6kl_set_wpa_version(struct ath6kl *ar,
 				  enum nl80211_wpa_versions wpa_version)
 {
@@ -217,6 +219,11 @@ static void ath6kl_set_key_mgmt(struct ath6kl *ar, u32 key_mgmt)
 			ar->auth_mode = WPA_PSK_AUTH;
 		else if (ar->auth_mode == WPA2_AUTH)
 			ar->auth_mode = WPA2_PSK_AUTH;
+	} else if (key_mgmt == 0x00409600) {
+		if (ar->auth_mode == WPA_AUTH)
+			ar->auth_mode = WPA_AUTH_CCKM;
+		else if (ar->auth_mode == WPA2_AUTH)
+			ar->auth_mode = WPA2_AUTH_CCKM;
 	} else if (key_mgmt != WLAN_AKM_SUITE_8021X) {
 		ar->auth_mode = NONE_AUTH;
 	}
@@ -758,6 +765,12 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (!ath6kl_cfg80211_ready(ar))
 		return -EIO;
 
+	if (params->cipher == CCKM_KRK_CIPHER_SUITE) {
+		if (params->key_len != WMI_KRK_LEN)
+			return -EINVAL;
+		return ath6kl_wmi_add_krk_cmd(ar->wmi, params->key);
+	}
+
 	if (key_index < WMI_MIN_KEY_INDEX || key_index > WMI_MAX_KEY_INDEX) {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 			   "%s: key index %d out of bounds\n", __func__,
@@ -1228,6 +1241,7 @@ static const u32 cipher_suites[] = {
 	WLAN_CIPHER_SUITE_WEP104,
 	WLAN_CIPHER_SUITE_TKIP,
 	WLAN_CIPHER_SUITE_CCMP,
+	CCKM_KRK_CIPHER_SUITE,
 };
 
 static bool is_rate_legacy(s32 rate)
-- 
1.7.4.1

