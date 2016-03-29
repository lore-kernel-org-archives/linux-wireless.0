Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33246 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbcC2GGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 02:06:50 -0400
Received: by mail-pf0-f178.google.com with SMTP id 4so6637350pfd.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2016 23:06:50 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 11/16] wcn36xx: Use allocated self sta index instead of hard coded
Date: Mon, 28 Mar 2016 23:06:28 -0700
Message-Id: <1459231593-360-12-git-send-email-bjorn.andersson@linaro.org> (sfid-20160329_080950_029777_51878E67)
In-Reply-To: <1459231593-360-1-git-send-email-bjorn.andersson@linaro.org>
References: <1459231593-360-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index ce764cce1a3e..8b304b305e69 100644
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

