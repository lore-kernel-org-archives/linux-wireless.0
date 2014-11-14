Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40128 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaKNFH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 00:07:27 -0500
Received: by mail-pd0-f172.google.com with SMTP id r10so16066237pdi.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2014 21:07:26 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath9k_htc: turn on software mgmt crypto for secured mesh
Date: Fri, 14 Nov 2014 13:07:11 +0800
Message-Id: <1415941631-24140-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20141114_060730_646428_2668060C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Secured mesh encrypts the unicast mgmt frame using the same
key that used for encrypting the unicast data frame. The patch
"ath9k_htc_firmware: fix the offset of CCMP header for mesh
data frame" applied to open-ath9k-htc-firmware allows the
ath9k_htc to be loaded without "nohwcrypt=1". Unfortunately,
this is not working and we still need CCMP encryption of
management frames to be done in software. Fix this.

This patch is tested with the following hardwares:
- TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]
- AR9271 802.11n

and managed to work with peer mesh STA equipped with ath9k.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 689ac99..d3f65a2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1447,7 +1447,8 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 			if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
 				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-			if (priv->ah->sw_mgmt_crypto &&
+			if ((vif->type == NL80211_IFTYPE_MESH_POINT ||
+			     priv->ah->sw_mgmt_crypto) &&
 			    key->cipher == WLAN_CIPHER_SUITE_CCMP)
 				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 			ret = 0;
-- 
2.1.1

