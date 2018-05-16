Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:35622 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752588AbeEPOIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 10:08:49 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 10/10] wcn36xx: improve debug and error messages for SMD
Date: Wed, 16 May 2018 16:08:20 +0200
Message-Id: <20180516140820.1636-11-daniel@zonque.org> (sfid-20180516_160856_156239_4A2DD131)
In-Reply-To: <20180516140820.1636-1-daniel@zonque.org>
References: <20180516140820.1636-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a missing newline in wcn36xx_smd_send_and_wait() and also log the
command request and response type that was processed.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 43c8aa79fad4..b855a58d5aac 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -252,23 +252,29 @@ static int wcn36xx_smd_send_and_wait(struct wcn36xx *wcn, size_t len)
 {
 	int ret = 0;
 	unsigned long start;
+	struct wcn36xx_hal_msg_header *hdr =
+		(struct wcn36xx_hal_msg_header *)wcn->hal_buf;
+	u16 req_type = hdr->msg_type;
+
 	wcn36xx_dbg_dump(WCN36XX_DBG_SMD_DUMP, "HAL >>> ", wcn->hal_buf, len);
 
 	init_completion(&wcn->hal_rsp_compl);
 	start = jiffies;
 	ret = rpmsg_send(wcn->smd_channel, wcn->hal_buf, len);
 	if (ret) {
-		wcn36xx_err("HAL TX failed\n");
+		wcn36xx_err("HAL TX failed for req %d\n", req_type);
 		goto out;
 	}
 	if (wait_for_completion_timeout(&wcn->hal_rsp_compl,
 		msecs_to_jiffies(HAL_MSG_TIMEOUT)) <= 0) {
-		wcn36xx_err("Timeout! No SMD response in %dms\n",
-			    HAL_MSG_TIMEOUT);
+		wcn36xx_err("Timeout! No SMD response to req %d in %dms\n",
+			    req_type, HAL_MSG_TIMEOUT);
 		ret = -ETIME;
 		goto out;
 	}
-	wcn36xx_dbg(WCN36XX_DBG_SMD, "SMD command completed in %dms",
+	wcn36xx_dbg(WCN36XX_DBG_SMD,
+		    "SMD command (req %d, rsp %d) completed in %dms\n",
+		    req_type, hdr->msg_type,
 		    jiffies_to_msecs(jiffies - start));
 out:
 	return ret;
-- 
2.14.3
