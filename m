Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A51C169C4
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 03:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48DFE2175B
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 03:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfA3DKz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 22:10:55 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:41498 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728356AbfA3DKz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 22:10:55 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 067B679DCF0BA246F9F7;
        Wed, 30 Jan 2019 11:10:52 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.408.0; Wed, 30 Jan 2019
 11:10:42 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <ath10k@lists.infradead.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH][RESEND] ath10k: snoc: remove set but not used variable 'ar_snoc'
Date:   Wed, 30 Jan 2019 11:09:00 +0800
Message-ID: <20190130030900.18764-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/ath/ath10k/snoc.c: In function 'ath10k_snoc_tx_pipe_cleanup':
drivers/net/wireless/ath/ath10k/snoc.c:681:22: warning:
 variable 'ar_snoc' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 54efe6b..b7493df 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -875,13 +875,11 @@ static void ath10k_snoc_tx_pipe_cleanup(struct ath10k_snoc_pipe *snoc_pipe)
 {
 	struct ath10k_ce_pipe *ce_pipe;
 	struct ath10k_ce_ring *ce_ring;
-	struct ath10k_snoc *ar_snoc;
 	struct sk_buff *skb;
 	struct ath10k *ar;
 	int i;
 
 	ar = snoc_pipe->hif_ce_state;
-	ar_snoc = ath10k_snoc_priv(ar);
 	ce_pipe = snoc_pipe->ce_hdl;
 	ce_ring = ce_pipe->src_ring;
 
-- 
2.7.4


