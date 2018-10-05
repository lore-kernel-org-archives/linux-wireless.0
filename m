Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3A7C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 21:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E05A208E7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 21:56:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E05A208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbeJFE4y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 00:56:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47923 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbeJFE4y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 00:56:54 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1g8Y4w-0007qH-LI; Fri, 05 Oct 2018 21:56:10 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sriram R <srirrama@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath10k: fix out of bound read on array ath10k_rates
Date:   Fri,  5 Oct 2018 22:56:09 +0100
Message-Id: <20181005215609.13935-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

An out-of-bounds read on array ath10k_rates is occurring because
the maximum number of elements is currently based on the size of
the array and not the number of elements in the array. Fix this
by using ARRAY_SIZE instead of sizeof.

Detected by CoverityScan, CID#1473918 ("Out-of-bounds read")

Fixes: f279294e9ee2 ("ath10k: add support for configuring management packet rate")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3933dd96da55..3564676e74e3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -164,7 +164,7 @@ static int ath10k_mac_get_rate_hw_value(int bitrate)
 	if (ath10k_mac_bitrate_is_cck(bitrate))
 		hw_value_prefix = WMI_RATE_PREAMBLE_CCK << 6;
 
-	for (i = 0; i < sizeof(ath10k_rates); i++) {
+	for (i = 0; i < ARRAY_SIZE(ath10k_rates); i++) {
 		if (ath10k_rates[i].bitrate == bitrate)
 			return hw_value_prefix | ath10k_rates[i].hw_value;
 	}
-- 
2.17.1

