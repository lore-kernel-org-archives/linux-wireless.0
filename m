Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED44C282E1
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 01:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45F01214AE
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 01:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388557AbfDYB5P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 21:57:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7251 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387652AbfDYB5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 21:57:15 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 301577396B205FA7EBC8;
        Thu, 25 Apr 2019 09:57:13 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Thu, 25 Apr 2019 09:57:04 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Mack <daniel@zonque.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Gomez <dagmcr@gmail.com>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] NFC: st95hf: remove set but not used variables 'dev, nfcddev'
Date:   Thu, 25 Apr 2019 02:07:20 +0000
Message-ID: <20190425020720.46560-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/nfc/st95hf/core.c: In function 'st95hf_irq_thread_handler':
drivers/nfc/st95hf/core.c:786:26: warning:
 variable 'nfcddev' set but not used [-Wunused-but-set-variable]

drivers/nfc/st95hf/core.c:784:17: warning:
 variable 'dev' set but not used [-Wunused-but-set-variable]

They are never used since introduction in
commit cab47333f0f7 ("NFC: Add STMicroelectronics ST95HF driver")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/nfc/st95hf/core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 815194bfda8e..f3bec0a84595 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -781,9 +781,7 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 	int result = 0;
 	int res_len;
 	static bool wtx;
-	struct device *dev;
 	struct device *spidevice;
-	struct nfc_digital_dev *nfcddev;
 	struct sk_buff *skb_resp;
 	struct st95hf_context *stcontext  =
 		(struct st95hf_context *)st95hfcontext;
@@ -828,8 +826,6 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 		goto end;
 	}
 
-	dev = &stcontext->nfcdev->dev;
-	nfcddev = stcontext->ddev;
 	if (skb_resp->data[2] == WTX_REQ_FROM_TAG) {
 		/* Request for new FWT from tag */
 		result = st95hf_handle_wtx(stcontext, true, skb_resp->data[3]);



