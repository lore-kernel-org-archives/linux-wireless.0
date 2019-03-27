Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C83C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D39E820651
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404157AbfC0Sgz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:36:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44012 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391717AbfC0Sft (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:35:49 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1h9DOr-0005c7-Hz; Wed, 27 Mar 2019 18:35:45 +0000
From:   Colin King <colin.king@canonical.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cfg80211: remove redundant zero check on variable 'changed'
Date:   Wed, 27 Mar 2019 18:35:45 +0000
Message-Id: <20190327183545.20631-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The zero check on variable changed is redundant as it must be
between 1 and 3 at the end of the proceeding if statement block.
Remove the redundant check.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/wireless/wext-compat.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index d522787c7354..46e4d69db845 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -353,9 +353,6 @@ static int cfg80211_wext_siwretry(struct net_device *dev,
 		changed |= WIPHY_PARAM_RETRY_SHORT;
 	}
 
-	if (!changed)
-		return 0;
-
 	err = rdev_set_wiphy_params(rdev, changed);
 	if (err) {
 		wdev->wiphy->retry_short = oshort;
-- 
2.20.1

