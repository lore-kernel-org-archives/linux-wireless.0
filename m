Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5267 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1LHOv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 09:51:57 -0500
Date: Thu, 8 Dec 2011 16:50:30 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Use delayed key configuration for WAPI in AP mode
Message-ID: <20111208145030.GA1131@jouni.qca.qualcomm.com> (sfid-20111208_155201_087568_7C9368E7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed to allow WAPI AP to configure the initial group key
to the target in the same way as is done with TKIP/CCMP. This
fixes broadcast data frame delivery with the initial group key.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 ++-
 drivers/net/wireless/ath/ath6kl/main.c     |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index aa93527..77059c7 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1001,7 +1001,8 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		   key_usage, key->seq_len);
 
 	if (vif->nw_type == AP_NETWORK && !pairwise &&
-	    (key_type == TKIP_CRYPT || key_type == AES_CRYPT) && params) {
+	    (key_type == TKIP_CRYPT || key_type == AES_CRYPT ||
+	     key_type == WAPI_CRYPT) && params) {
 		ar->ap_mode_bkey.valid = true;
 		ar->ap_mode_bkey.key_index = key_index;
 		ar->ap_mode_bkey.key_type = key_type;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index d9b4ba4..9cf48f4 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -397,7 +397,9 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel)
 	case NONE_AUTH:
 		if (vif->prwise_crypto == WEP_CRYPT)
 			ath6kl_install_static_wep_keys(vif);
-		break;
+		if (!ik->valid || ik->key_type != WAPI_CRYPT)
+			break;
+		/* for WAPI, we need to set the delayed group key, continue: */
 	case WPA_PSK_AUTH:
 	case WPA2_PSK_AUTH:
 	case (WPA_PSK_AUTH | WPA2_PSK_AUTH):
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
