Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A05EC4361B
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Dec 2020 13:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0532E23371
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Dec 2020 13:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgLPNFE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Dec 2020 08:05:04 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10046 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgLPNFE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Dec 2020 08:05:04 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CwwKx14J9zM4BW;
        Wed, 16 Dec 2020 21:03:33 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 16 Dec 2020 21:04:11 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <tony0620emma@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH wireless -next] rtw88: Delete useless kfree code
Date:   Wed, 16 Dec 2020 21:04:42 +0800
Message-ID: <20201216130442.13869-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The parameter of kfree function is NULL, so kfree code is useless, delete it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 565efd880624..15568cd670a3 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1249,7 +1249,6 @@ static void rtw_set_supported_band(struct ieee80211_hw *hw,
 
 err_out:
 	rtw_err(rtwdev, "failed to set supported band\n");
-	kfree(sband);
 }
 
 static void rtw_unset_supported_band(struct ieee80211_hw *hw,
-- 
2.22.0

