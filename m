Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34349 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbeDELvw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 07:51:52 -0400
Received: by mail-wr0-f193.google.com with SMTP id d17so12519477wre.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2018 04:51:52 -0700 (PDT)
From: Loic Poulain <loic.poulain@linaro.org>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        dan.carpenter@oracle.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] wcn36xx: Add missing fall through comment in smd.c
Date: Thu,  5 Apr 2018 13:51:49 +0200
Message-Id: <1522929109-23271-1-git-send-email-loic.poulain@linaro.org> (sfid-20180405_135156_371914_C5E9C3CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents GCC warning.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 7cc2928..7b79e0b 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2135,6 +2135,7 @@ static int wcn36xx_smd_hw_scan_ind(struct wcn36xx *wcn, void *buf, size_t len)
 	switch (rsp->type) {
 	case WCN36XX_HAL_SCAN_IND_FAILED:
 		scan_info.aborted = true;
+		/* fall through */
 	case WCN36XX_HAL_SCAN_IND_COMPLETED:
 		mutex_lock(&wcn->scan_lock);
 		wcn->scan_req = NULL;
-- 
2.7.4
