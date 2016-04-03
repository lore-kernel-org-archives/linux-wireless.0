Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33092 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbcDCWRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2016 18:17:09 -0400
Received: by mail-pa0-f42.google.com with SMTP id zm5so130358959pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 03 Apr 2016 15:17:08 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>, wcn36xx@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/15] wcn36xx: Use correct command struct for EXIT_BMPS_REQ
Date: Sun,  3 Apr 2016 15:16:46 -0700
Message-Id: <1459721806-11817-15-git-send-email-bjorn.andersson@linaro.org> (sfid-20160404_001732_435216_782F2215)
In-Reply-To: <1459721806-11817-1-git-send-email-bjorn.andersson@linaro.org>
References: <1459721806-11817-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

EXIT_BMPS_REQ was using the command struct for ENTER_BMPS_REQ. I
spotted this when looking at command dumps.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index b1bdc229e560..c15501c06eb2 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1690,7 +1690,7 @@ out:
 
 int wcn36xx_smd_exit_bmps(struct wcn36xx *wcn, struct ieee80211_vif *vif)
 {
-	struct wcn36xx_hal_enter_bmps_req_msg msg_body;
+	struct wcn36xx_hal_exit_bmps_req_msg msg_body;
 	struct wcn36xx_vif *vif_priv = wcn36xx_vif_to_priv(vif);
 	int ret = 0;
 
-- 
2.5.0

