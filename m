Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60497 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbbAVUiu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:38:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] ath10k: use IEEE80211_HW_SW_CRYPTO_CONTROL
Date: Thu, 22 Jan 2015 21:38:45 +0100
Message-Id: <1421959125-10834-2-git-send-email-johannes@sipsolutions.net> (sfid-20150122_213903_766323_72CDB0A1)
In-Reply-To: <1421959125-10834-1-git-send-email-johannes@sipsolutions.net>
References: <1421959125-10834-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ath10k driver only supports HW crypto (except for management
frames or so - CMAC needs to be done in software). Make it use
the new IEEE80211_HW_SW_CRYPTO_CONTROL flag to ensure mac80211
doesn't erroneously attempt to use software crypto.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2619db1e3e74..bd950bb24087 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -74,6 +74,9 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		if (memcmp(macaddr, arvif->vif->addr, ETH_ALEN))
 			arg.key_flags = WMI_KEY_PAIRWISE;
 		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		/* this one needs to be done in software */
+		return 1;
 	default:
 		ath10k_warn(ar, "cipher %d is not supported\n", key->cipher);
 		return -EOPNOTSUPP;
@@ -4958,6 +4961,13 @@ struct ath10k_vif *ath10k_get_arvif(struct ath10k *ar, u32 vdev_id)
 
 int ath10k_mac_register(struct ath10k *ar)
 {
+	static const u32 cipher_suites[] = {
+		WLAN_CIPHER_SUITE_WEP40,
+		WLAN_CIPHER_SUITE_WEP104,
+		WLAN_CIPHER_SUITE_TKIP,
+		WLAN_CIPHER_SUITE_CCMP,
+		WLAN_CIPHER_SUITE_AES_CMAC,
+	};
 	struct ieee80211_supported_band *band;
 	struct ieee80211_sta_vht_cap vht_cap;
 	struct ieee80211_sta_ht_cap ht_cap;
@@ -5030,7 +5040,8 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 			IEEE80211_HW_HAS_RATE_CONTROL |
 			IEEE80211_HW_AP_LINK_PS |
-			IEEE80211_HW_SPECTRUM_MGMT;
+			IEEE80211_HW_SPECTRUM_MGMT |
+			IEEE80211_HW_SW_CRYPTO_CONTROL;
 
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
 
@@ -5094,6 +5105,9 @@ int ath10k_mac_register(struct ath10k *ar)
 		goto err_free;
 	}
 
+	ar->hw->wiphy->cipher_suites = cipher_suites;
+	ar->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
+
 	ret = ieee80211_register_hw(ar->hw);
 	if (ret) {
 		ath10k_err(ar, "failed to register ieee80211: %d\n", ret);
-- 
2.1.4

