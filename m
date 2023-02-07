Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4B6C636CD
	for <linux-wireless@archiver.kernel.org>; Tue,  7 Feb 2023 05:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjBGFYb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 7 Feb 2023 00:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjBGFYW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2023 00:24:22 -0500
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638072B095;
        Mon,  6 Feb 2023 21:24:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vb5hf8c_1675747451;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Vb5hf8c_1675747451)
          by smtp.aliyun-inc.com;
          Tue, 07 Feb 2023 13:24:17 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] ath10k: Remove redundant assignment to changed_flags
Date:   Tue,  7 Feb 2023 13:24:10 +0800
Message-Id: <20230207052410.26337-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Variable changed_flags is assigned, but is not effectively used, so
delete it.

drivers/net/wireless/ath/ath10k/mac.c:6024:22: warning: parameter 'changed_flags' set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3963
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ec8d5b29bc72..7675858f069b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6030,7 +6030,6 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
-	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
 	ar->filter_flags = *total_flags;
 
-- 
2.20.1.7.g153144c

