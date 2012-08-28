Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65520 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2H1JgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 05:36:04 -0400
Received: by pbbrr13 with SMTP id rr13so9037981pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2012 02:36:03 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath5k: add support of HW encryption in management frames
Date: Tue, 28 Aug 2012 17:34:06 +0800
Message-Id: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120828_113608_728319_48791C3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch provides the support of hardware encyrption for
management frame, including the support of AES CMAC. This
patch is tested with the following chipsets:
- AR5213A
- AR5413
- AR2413/AR2414

Beside, this patch also extends the IBSS RSN to mesh.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c         |    4 +++-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a0a202d..084162e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2446,7 +2446,9 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 			IEEE80211_HW_SIGNAL_DBM |
-			IEEE80211_HW_REPORTS_TX_ACK_STATUS;
+			IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+			IEEE80211_HW_MFP_CAPABLE |
+			IEEE80211_HW_SUPPORTS_PER_STA_GTK;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index df61a09..7f78caa 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -489,7 +489,8 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (ath5k_modparam_nohwcrypt)
 		return -EOPNOTSUPP;
 
-	if (vif->type == NL80211_IFTYPE_ADHOC &&
+	if ((vif->type == NL80211_IFTYPE_ADHOC ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
 	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
 	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
 	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
@@ -502,6 +503,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case WLAN_CIPHER_SUITE_WEP104:
 	case WLAN_CIPHER_SUITE_TKIP:
 		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_CCMP:
 		if (common->crypt_caps & ATH_CRYPT_CAP_CIPHER_AESCCM)
 			break;
@@ -522,7 +524,8 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 			if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
 				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-			if (key->cipher == WLAN_CIPHER_SUITE_CCMP)
+			if (key->cipher == WLAN_CIPHER_SUITE_CCMP &&
+			    !(common->crypt_caps & ATH_CRYPT_CAP_CIPHER_AESCCM))
 				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
 			ret = 0;
 		}
-- 
1.7.0.4

