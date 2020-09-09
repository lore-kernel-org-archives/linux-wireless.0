Return-Path: <SRS0=opxm=CS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3916EC43461
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 16:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 007652067C
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 16:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730777AbgIIQCB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Sep 2020 12:02:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40740 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730702AbgIIQA5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Sep 2020 12:00:57 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2EFB16363AE265E31F7C;
        Wed,  9 Sep 2020 21:58:46 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 21:58:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath10k: Remove unused macro ATH10K_ROC_TIMEOUT_HZ
Date:   Wed, 9 Sep 2020 21:58:34 +0800
Message-ID: <20200909135834.38448-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is no caller in tree, so can remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index fed8682f266f..5991d0ac41ad 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7033,8 +7033,6 @@ static int ath10k_conf_tx(struct ieee80211_hw *hw,
 	return ret;
 }
 
-#define ATH10K_ROC_TIMEOUT_HZ (2 * HZ)
-
 static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_channel *chan,
-- 
2.17.1


