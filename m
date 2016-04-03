Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34268 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbcDCWQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2016 18:16:59 -0400
Received: by mail-pf0-f173.google.com with SMTP id c20so21524416pfc.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Apr 2016 15:16:59 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>, wcn36xx@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/15] wcn36xx: Parse trigger_ba response properly
Date: Sun,  3 Apr 2016 15:16:40 -0700
Message-Id: <1459721806-11817-9-git-send-email-bjorn.andersson@linaro.org> (sfid-20160404_002018_143704_2FB41AAB)
In-Reply-To: <1459721806-11817-1-git-send-email-bjorn.andersson@linaro.org>
References: <1459721806-11817-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

This message does not follow the canonical format and needs it's own
parser.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 76c6856ed932..7f315d098f52 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1968,6 +1968,17 @@ out:
 	return ret;
 }
 
+static int wcn36xx_smd_trigger_ba_rsp(void *buf, int len)
+{
+	struct wcn36xx_hal_trigger_ba_rsp_msg *rsp;
+
+	if (len < sizeof(*rsp))
+		return -EINVAL;
+
+	rsp = (struct wcn36xx_hal_trigger_ba_rsp_msg *) buf;
+	return rsp->status;
+}
+
 int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index)
 {
 	struct wcn36xx_hal_trigger_ba_req_msg msg_body;
@@ -1992,8 +2003,7 @@ int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index)
 		wcn36xx_err("Sending hal_trigger_ba failed\n");
 		goto out;
 	}
-	ret = wcn36xx_smd_rsp_status_check_v2(wcn, wcn->hal_buf,
-						wcn->hal_rsp_len);
+	ret = wcn36xx_smd_trigger_ba_rsp(wcn->hal_buf, wcn->hal_rsp_len);
 	if (ret) {
 		wcn36xx_err("hal_trigger_ba response failed err=%d\n", ret);
 		goto out;
-- 
2.5.0

