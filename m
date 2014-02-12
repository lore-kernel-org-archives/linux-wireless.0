Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40214 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaBLTFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 14:05:02 -0500
Received: by mail-we0-f174.google.com with SMTP id w61so727628wes.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 11:05:01 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 3/9] wcn36xx: Wait longer for SMD commands to complete
Date: Wed, 12 Feb 2014 19:04:42 +0000
Message-Id: <1392231888-2191-3-git-send-email-k.eugene.e@gmail.com> (sfid-20140212_200514_998634_7AE6F524)
In-Reply-To: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
References: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

On some wcnss firmwares the start command can take up to 300ms to
complete. Currently there is a 200ms timeout for SMD command to
complete which causes the start to fail.

Increase the timeout to 500ms. Also improve debug information
regarding SMD command completion time.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 7 ++++++-
 drivers/net/wireless/ath/wcn36xx/smd.h | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 425365c..ad93cc7 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -195,9 +195,11 @@ static void wcn36xx_smd_set_sta_params(struct wcn36xx *wcn,
 static int wcn36xx_smd_send_and_wait(struct wcn36xx *wcn, size_t len)
 {
 	int ret = 0;
+	unsigned long start;
 	wcn36xx_dbg_dump(WCN36XX_DBG_SMD_DUMP, "HAL >>> ", wcn->hal_buf, len);
 
 	init_completion(&wcn->hal_rsp_compl);
+	start = jiffies;
 	ret = wcn->ctrl_ops->tx(wcn->hal_buf, len);
 	if (ret) {
 		wcn36xx_err("HAL TX failed\n");
@@ -205,10 +207,13 @@ static int wcn36xx_smd_send_and_wait(struct wcn36xx *wcn, size_t len)
 	}
 	if (wait_for_completion_timeout(&wcn->hal_rsp_compl,
 		msecs_to_jiffies(HAL_MSG_TIMEOUT)) <= 0) {
-		wcn36xx_err("Timeout while waiting SMD response\n");
+		wcn36xx_err("Timeout! No SMD response in %dms\n",
+			    HAL_MSG_TIMEOUT);
 		ret = -ETIME;
 		goto out;
 	}
+	wcn36xx_dbg(WCN36XX_DBG_SMD, "SMD command completed in %dms",
+		    jiffies_to_msecs(jiffies - start));
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
index e7c3901..c46246f 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.h
+++ b/drivers/net/wireless/ath/wcn36xx/smd.h
@@ -24,7 +24,7 @@
 
 #define WCN36XX_HAL_BUF_SIZE				4096
 
-#define HAL_MSG_TIMEOUT 200
+#define HAL_MSG_TIMEOUT 500
 #define WCN36XX_SMSM_WLAN_TX_ENABLE			0x00000400
 #define WCN36XX_SMSM_WLAN_TX_RINGS_EMPTY		0x00000200
 /* The PNO version info be contained in the rsp msg */
-- 
1.8.3.2

