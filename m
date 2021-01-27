Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F41DC433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Jan 2021 09:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1486D2072C
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Jan 2021 09:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhA0J4I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Jan 2021 04:56:08 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:46890 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232989AbhA0Jx6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jan 2021 04:53:58 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UN1fMSF_1611741191;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UN1fMSF_1611741191)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Jan 2021 17:53:15 +0800
From:   Abaci Team <abaci-bugfix@linux.alibaba.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        Larry.Finger@lwfinger.net, lee.jones@linaro.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Abaci Team <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] rtlwifi: halbtc8723b2ant: Remove redundant code
Date:   Wed, 27 Jan 2021 17:53:09 +0800
Message-Id: <1611741189-45892-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:
1876:11-13: WARNING: possible condition with no effect (if == else).

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Suggested-by: Jiapeng Zhong <oswb@linux.alibaba.com>
Signed-off-by: Abaci Team <abaci-bugfix@linux.alibaba.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 7a71f06..ef2c3eb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1273,8 +1273,6 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 	} else {
 		if (coex_sta->a2dp_bit_pool >= 45)
 			wifi_duration_adjust = -15;
-		else if (coex_sta->a2dp_bit_pool >= 35)
-			wifi_duration_adjust = -10;
 		else
 			wifi_duration_adjust = -10;
 	}
@@ -1805,11 +1803,6 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 							     NORMAL_EXEC,
 							     true, 14);
 					coex_dm->ps_tdma_du_adj_type = 14;
-				} else if (max_interval == 3) {
-					btc8723b2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 15);
-					coex_dm->ps_tdma_du_adj_type = 15;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
@@ -1827,11 +1820,6 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 							     NORMAL_EXEC,
 							     true, 10);
 					coex_dm->ps_tdma_du_adj_type = 10;
-				} else if (max_interval == 3) {
-					btc8723b2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-						     true, 11);
-					coex_dm->ps_tdma_du_adj_type = 11;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
@@ -1851,11 +1839,6 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 							     NORMAL_EXEC,
 							     true, 6);
 					coex_dm->ps_tdma_du_adj_type = 6;
-				} else if (max_interval == 3) {
-					btc8723b2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 7);
-					coex_dm->ps_tdma_du_adj_type = 7;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
@@ -1873,11 +1856,6 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 							     NORMAL_EXEC,
 							     true, 2);
 					coex_dm->ps_tdma_du_adj_type = 2;
-				} else if (max_interval == 3) {
-					btc8723b2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 3);
-					coex_dm->ps_tdma_du_adj_type = 3;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
-- 
1.8.3.1

