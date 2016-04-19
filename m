Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33381 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbcDSFBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 01:01:08 -0400
Received: by mail-pa0-f50.google.com with SMTP id zm5so2666789pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 22:01:08 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/18] wcn36xx: Fetch private sta data from sta entry instead of from vif
Date: Mon, 18 Apr 2016 22:00:45 -0700
Message-Id: <1461042056-10607-8-git-send-email-bjorn.andersson@linaro.org> (sfid-20160419_070555_167867_D9B86D1D)
In-Reply-To: <1461042056-10607-1-git-send-email-bjorn.andersson@linaro.org>
References: <1461042056-10607-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

For consistency with other code.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v1:
- Reordered after the now previous patch, to make wcn36xx_sta_to_priv()
  available before we use it

 drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 30f015d3a9e6..a23738deb5b3 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -386,7 +386,7 @@ static int wcn36xx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 {
 	struct wcn36xx *wcn = hw->priv;
 	struct wcn36xx_vif *vif_priv = wcn36xx_vif_to_priv(vif);
-	struct wcn36xx_sta *sta_priv = vif_priv->sta;
+	struct wcn36xx_sta *sta_priv = wcn36xx_sta_to_priv(sta);
 	int ret = 0;
 	u8 key[WLAN_MAX_KEY_LEN];
 
-- 
2.5.0

