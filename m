Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D7DC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73C2720850
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfCSPTo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:19:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5271 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbfCSPTo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 11:19:44 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CFF72F1832997C0B44B5;
        Tue, 19 Mar 2019 23:19:40 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.408.0; Tue, 19 Mar 2019
 23:19:30 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <pkshih@realtek.com>, <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtl8723ae: Make rtl8723e_dm_refresh_rate_adaptive_mask static
Date:   Tue, 19 Mar 2019 23:19:27 +0800
Message-ID: <20190319151927.19392-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warning:

drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c:666:6:
 warning: symbol 'rtl8723e_dm_refresh_rate_adaptive_mask' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
index 514891e..d8260c7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
@@ -663,7 +663,7 @@ void rtl8723e_dm_init_rate_adaptive_mask(struct ieee80211_hw *hw)
 
 }
 
-void rtl8723e_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
+static void rtl8723e_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-- 
2.7.4


