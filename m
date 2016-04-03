Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36729 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbcDCWRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2016 18:17:04 -0400
Received: by mail-pa0-f44.google.com with SMTP id tt10so130156209pab.3
        for <linux-wireless@vger.kernel.org>; Sun, 03 Apr 2016 15:17:04 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>, wcn36xx@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/15] wcn36xx: Use allocated self sta index instead of hard coded
Date: Sun,  3 Apr 2016 15:16:42 -0700
Message-Id: <1459721806-11817-11-git-send-email-bjorn.andersson@linaro.org> (sfid-20160404_001857_108196_699DAE93)
In-Reply-To: <1459721806-11817-1-git-send-email-bjorn.andersson@linaro.org>
References: <1459721806-11817-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index ebb446272d21..e0d5631657c1 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -200,7 +200,7 @@ static void wcn36xx_smd_set_sta_params(struct wcn36xx *wcn,
 		sta_params->sta_index = WCN36XX_HAL_STA_INVALID_IDX;
 	} else {
 		sta_params->type = 0;
-		sta_params->sta_index = 1;
+		sta_params->sta_index = vif_priv->self_sta_index;
 	}
 
 	sta_params->listen_interval = WCN36XX_LISTEN_INTERVAL(wcn);
-- 
2.5.0

