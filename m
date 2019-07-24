Return-Path: <SRS0=rB3s=VV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6ADBC76191
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 14:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FF2921BF6
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 14:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbfGXOKj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Jul 2019 10:10:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56612 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726287AbfGXOKj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jul 2019 10:10:39 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EF2187C835ACB6CCCB09;
        Wed, 24 Jul 2019 22:10:31 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Jul 2019
 22:10:23 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtlwifi: remove unneeded function _rtl_dump_channel_map()
Date:   Wed, 24 Jul 2019 22:10:20 +0800
Message-ID: <20190724141020.58800-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Now _rtl_dump_channel_map() does not do any actual
thing using the channel. So remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/regd.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index 6ccb5b9..c10432c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -276,22 +276,6 @@ static void _rtl_reg_apply_world_flags(struct wiphy *wiphy,
 	return;
 }
 
-static void _rtl_dump_channel_map(struct wiphy *wiphy)
-{
-	enum nl80211_band band;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *ch;
-	unsigned int i;
-
-	for (band = 0; band < NUM_NL80211_BANDS; band++) {
-		if (!wiphy->bands[band])
-			continue;
-		sband = wiphy->bands[band];
-		for (i = 0; i < sband->n_channels; i++)
-			ch = &sband->channels[i];
-	}
-}
-
 static int _rtl_reg_notifier_apply(struct wiphy *wiphy,
 				   struct regulatory_request *request,
 				   struct rtl_regulatory *reg)
@@ -309,8 +293,6 @@ static int _rtl_reg_notifier_apply(struct wiphy *wiphy,
 		break;
 	}
 
-	_rtl_dump_channel_map(wiphy);
-
 	return 0;
 }
 
-- 
2.7.4


