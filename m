Return-Path: <SRS0=EA+v=SB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F58CC4360F
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 20:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7098D217F5
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 20:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbfC3UO2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 30 Mar 2019 16:14:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57173 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730851AbfC3UO2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Mar 2019 16:14:28 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hAKMx-0007Gx-15; Sat, 30 Mar 2019 20:14:23 +0000
From:   Colin King <colin.king@canonical.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlegacy: remove redundant assignment to *res
Date:   Sat, 30 Mar 2019 20:14:22 +0000
Message-Id: <20190330201422.8024-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently 1 is being assigned to *res and then it is immediately
updated with the computed result.  The first assignment is
redundant and can be removed.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlegacy/4965.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965.c b/drivers/net/wireless/intel/iwlegacy/4965.c
index ce4144a89217..a20b6c885047 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965.c
@@ -577,7 +577,6 @@ il4965_math_div_round(s32 num, s32 denom, s32 * res)
 		sign = -sign;
 		denom = -denom;
 	}
-	*res = 1;
 	*res = ((num * 2 + denom) / (denom * 2)) * sign;
 
 	return 1;
-- 
2.20.1

