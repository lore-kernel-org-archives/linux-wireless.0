Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34657 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbbKJHZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 02:25:17 -0500
Received: by padhx2 with SMTP id hx2so217696184pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 23:25:17 -0800 (PST)
From: "Yin, Fengwei" <fengwei.yin@linaro.org>
To: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org
Subject: [PATCH v2 5/5] wcn3620: use new response format for wcn3620 remove_bsskey
Date: Tue, 10 Nov 2015 03:25:55 -0500
Message-Id: <1447143955-10304-6-git-send-email-fengwei.yin@linaro.org> (sfid-20151110_082522_416875_D00E0ECA)
In-Reply-To: <1447143955-10304-1-git-send-email-fengwei.yin@linaro.org>
References: <1447143955-10304-1-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy.green@linaro.org>

On wcn3620, firmware response to remove_bsskey uses the new, larger
"v2" format

Signed-off-by: Andy Green <andy.green@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index dae5e1a..74f56a8 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1598,7 +1598,8 @@ int wcn36xx_smd_remove_bsskey(struct wcn36xx *wcn,
 		wcn36xx_err("Sending hal_remove_bsskey failed\n");
 		goto out;
 	}
-	ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
+	ret = wcn36xx_smd_rsp_status_check_v2(wcn, wcn->hal_buf,
+					      wcn->hal_rsp_len);
 	if (ret) {
 		wcn36xx_err("hal_remove_bsskey response failed err=%d\n", ret);
 		goto out;
-- 
2.1.4

