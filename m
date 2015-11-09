Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36228 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbbKIJBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 04:01:31 -0500
Received: by pacdm15 with SMTP id dm15so168910665pac.3
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 01:01:31 -0800 (PST)
From: "Yin, Fengwei" <fengwei.yin@linaro.org>
To: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org
Subject: [PATCH 2/5] wcn36xx: swallow two wcn3620 IND messages
Date: Mon,  9 Nov 2015 05:02:39 -0500
Message-Id: <1447063362-27322-3-git-send-email-fengwei.yin@linaro.org> (sfid-20151109_100134_131832_1F1D4870)
In-Reply-To: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy.green@linaro.org>

From: Andy Green <andy.green@linaro.org>

WCN3620 can asynchronously send two new kinds of indication message,
since we can't handle them just accept them quietly.

v2: used one break for both in the second stanza

Signed-off-by: Andy Green <andy.green@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index c9263e1..be317f4 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2128,6 +2128,8 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
 		complete(&wcn->hal_rsp_compl);
 		break;
 
+	case WCN36XX_HAL_COEX_IND:
+	case WCN36XX_HAL_AVOID_FREQ_RANGE_IND:
 	case WCN36XX_HAL_OTA_TX_COMPL_IND:
 	case WCN36XX_HAL_MISSED_BEACON_IND:
 	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
@@ -2174,6 +2176,9 @@ static void wcn36xx_ind_smd_work(struct work_struct *work)
 	msg_header = (struct wcn36xx_hal_msg_header *)hal_ind_msg->msg;
 
 	switch (msg_header->msg_type) {
+	case WCN36XX_HAL_COEX_IND:
+	case WCN36XX_HAL_AVOID_FREQ_RANGE_IND:
+		break;
 	case WCN36XX_HAL_OTA_TX_COMPL_IND:
 		wcn36xx_smd_tx_compl_ind(wcn,
 					 hal_ind_msg->msg,
-- 
2.1.4

