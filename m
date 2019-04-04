Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2A9C10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 13:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 774C220882
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 13:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbfDDNr2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 09:47:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56163 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbfDDNr1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 09:47:27 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hC2iB-0006vp-KZ; Thu, 04 Apr 2019 13:47:23 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath6kl: remove redundant check of status != 0
Date:   Thu,  4 Apr 2019 14:47:23 +0100
Message-Id: <20190404134723.24667-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check on status not being zero is redundant as previous code
paths that set status to an error value break out of the while
loop and hence status is never non-zero at the check. Remove
this redundant code.

Addresses-Coverity: ("Logically dead code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index 434b66829646..c68848819a52 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -898,9 +898,6 @@ static int htc_process_trailer(struct htc_target *target, u8 *buffer,
 			break;
 		}
 
-		if (status != 0)
-			break;
-
 		/* advance buffer past this record for next time around */
 		buffer += record->len;
 		len -= record->len;
-- 
2.20.1

