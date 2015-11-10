Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33368 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbbKJHZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 02:25:11 -0500
Received: by pabfh17 with SMTP id fh17so226307518pab.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 23:25:11 -0800 (PST)
From: "Yin, Fengwei" <fengwei.yin@linaro.org>
To: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org
Subject: [PATCH v2 4/5] wcn3620: use new response format for wcn3620 trigger_ba
Date: Tue, 10 Nov 2015 03:25:54 -0500
Message-Id: <1447143955-10304-5-git-send-email-fengwei.yin@linaro.org> (sfid-20151110_082516_302119_27198B80)
In-Reply-To: <1447143955-10304-1-git-send-email-fengwei.yin@linaro.org>
References: <1447143955-10304-1-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy.green@linaro.org>

On wcn3620, firmware response to trigger_ba uses the new, larger
"v2" format

Signed-off-by: Andy Green <andy.green@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index b7e61a0..dae5e1a 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1967,7 +1967,8 @@ int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index)
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

