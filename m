Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B733C2B9F7
	for <linux-wireless@archiver.kernel.org>; Wed, 26 May 2021 10:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E987613F5
	for <linux-wireless@archiver.kernel.org>; Wed, 26 May 2021 10:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhEZKyj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 May 2021 06:54:39 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:33522 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233980AbhEZKyi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 May 2021 06:54:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Ua9sKBq_1622026381;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ua9sKBq_1622026381)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 May 2021 18:53:05 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2] ath6kl: Fix inconsistent indenting
Date:   Wed, 26 May 2021 18:52:56 +0800
Message-Id: <1622026376-68524-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Eliminate the follow smatch warning:

drivers/net/wireless/ath/ath6kl/cfg80211.c:3308
ath6kl_cfg80211_sscan_start() warn: inconsistent indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -For the follow advice: https://lore.kernel.org/patchwork/patch/1435973/

 drivers/net/wireless/ath/ath6kl/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 29527e8..fefdc67 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3303,8 +3303,8 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 		if (ret < 0)
 			return ret;
 	} else {
-		 ret = ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
-						MATCHED_SSID_FILTER, 0);
+		ret = ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
+					       MATCHED_SSID_FILTER, 0);
 		if (ret < 0)
 			return ret;
 	}
-- 
1.8.3.1

