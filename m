Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33919 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbKIJBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 04:01:43 -0500
Received: by padhx2 with SMTP id hx2so184713786pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 01:01:43 -0800 (PST)
From: "Yin, Fengwei" <fengwei.yin@linaro.org>
To: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org
Subject: [PATCH 4/5] wcn3620: use new response format for wcn3620 trigger_ba
Date: Mon,  9 Nov 2015 05:02:41 -0500
Message-Id: <1447063362-27322-5-git-send-email-fengwei.yin@linaro.org> (sfid-20151109_100147_227559_31CF4D15)
In-Reply-To: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy.green@linaro.org>

From: Andy Green <andy.green@linaro.org>

On wcn3620, firmware response to trigger_ba uses the new, larger
"v2" format

Signed-off-by: Andy Green <andy.green@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index a84c2cc..f2443a0 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1968,7 +1968,8 @@ int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index)
 		wcn36xx_err("Sending hal_trigger_ba failed\n");
 		goto out;
 	}
-	ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
+	ret = wcn36xx_smd_rsp_status_check_v2(wcn, wcn->hal_buf,
+						wcn->hal_rsp_len);
 	if (ret) {
 		wcn36xx_err("hal_trigger_ba response failed err=%d\n", ret);
 		goto out;
-- 
2.1.4

