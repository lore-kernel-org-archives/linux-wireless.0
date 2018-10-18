Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF5EECDE43
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 21:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49CB12145D
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 21:51:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49CB12145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbeJSFyK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 01:54:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37533 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbeJSFyJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 01:54:09 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gDGC9-0002UE-Jc; Thu, 18 Oct 2018 21:51:05 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][ath10k-next] ath10k: fix some spelling mistakes
Date:   Thu, 18 Oct 2018 22:51:04 +0100
Message-Id: <20181018215104.10444-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to some spelling mistakes in ath10k_err and ath10k_dbg
messages:
"capablity" -> "capability"
"registed" -> "registered"

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 56cb1831dcdf..c876f9057468 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -543,7 +543,7 @@ static int ath10k_qmi_cap_send_sync_msg(struct ath10k_qmi *qmi)
 		goto out;
 
 	if (resp->resp.result != QMI_RESULT_SUCCESS_V01) {
-		ath10k_err(ar, "capablity req rejected: %d\n", resp->resp.error);
+		ath10k_err(ar, "capability req rejected: %d\n", resp->resp.error);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -623,7 +623,7 @@ static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
 		goto out;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi host capablity request completed\n");
+	ath10k_dbg(ar, ATH10K_DBG_QMI, "qmi host capability request completed\n");
 	return 0;
 
 out:
@@ -657,7 +657,7 @@ ath10k_qmi_ind_register_send_sync_msg(struct ath10k_qmi *qmi)
 			       wlfw_ind_register_req_msg_v01_ei, &req);
 	if (ret < 0) {
 		qmi_txn_cancel(&txn);
-		ath10k_err(ar, "failed to send indication registed request: %d\n", ret);
+		ath10k_err(ar, "failed to send indication registered request: %d\n", ret);
 		goto out;
 	}
 
-- 
2.19.1

