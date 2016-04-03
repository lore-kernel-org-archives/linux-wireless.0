Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34990 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbcDCWRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2016 18:17:10 -0400
Received: by mail-pf0-f179.google.com with SMTP id n1so25356557pfn.2
        for <linux-wireless@vger.kernel.org>; Sun, 03 Apr 2016 15:17:10 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>, wcn36xx@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/15] wcn36xx: Clear encrypt_type when deleting bss key
Date: Sun,  3 Apr 2016 15:16:43 -0700
Message-Id: <1459721806-11817-12-git-send-email-bjorn.andersson@linaro.org> (sfid-20160404_001753_249332_EA3F537B)
In-Reply-To: <1459721806-11817-1-git-send-email-bjorn.andersson@linaro.org>
References: <1459721806-11817-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

This fixes a problem connecting to an open network after being
connected to an encrypted network.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 7c06ca9fdd2c..f9c77de94583 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -471,6 +471,7 @@ static int wcn36xx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		break;
 	case DISABLE_KEY:
 		if (!(IEEE80211_KEY_FLAG_PAIRWISE & key_conf->flags)) {
+			vif_priv->encrypt_type = WCN36XX_HAL_ED_NONE;
 			wcn36xx_smd_remove_bsskey(wcn,
 				vif_priv->encrypt_type,
 				key_conf->keyidx);
@@ -626,6 +627,7 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 		} else {
 			vif_priv->is_joining = false;
 			wcn36xx_smd_delete_bss(wcn, vif);
+			vif_priv->encrypt_type = WCN36XX_HAL_ED_NONE;
 		}
 	}
 
-- 
2.5.0

