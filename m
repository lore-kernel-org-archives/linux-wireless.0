Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81467C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 14:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57AF0217D8
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 14:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387474AbeLTOFz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 09:05:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56498 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731231AbeLTOFy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 09:05:54 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gZyxS-000620-O3; Thu, 20 Dec 2018 14:05:50 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] ray_cs: fix array out-of-bounds access
Date:   Thu, 20 Dec 2018 14:05:50 +0000
Message-Id: <20181220140550.18853-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently array element org[3] is being accessed, however the array is
only 3 elements in size, so this looks like an off-by-one out-of-bounds
error. Fix this by using org[2], which I believe was the original
intent.

This issue has existed in the driver back in the pre-git days, so no
idea when it was introduced.

Detected by CoverityScan, CID#711344 ("Out-of-bounds read")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ray_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 33ad87528d9a..8b2741c8edf2 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -959,7 +959,7 @@ static int translate_frame(ray_dev_t *local, struct tx_msg __iomem *ptx,
 		if (proto == htons(ETH_P_AARP) || proto == htons(ETH_P_IPX)) {
 			/* This is the selective translation table, only 2 entries */
 			writeb(0xf8,
-			       &((struct snaphdr_t __iomem *)ptx->var)->org[3]);
+			       &((struct snaphdr_t __iomem *)ptx->var)->org[2]);
 		}
 		/* Copy body of ethernet packet without ethernet header */
 		memcpy_toio((void __iomem *)&ptx->var +
-- 
2.19.1

