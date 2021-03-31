Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B113C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Mar 2021 09:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1E21619C1
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Mar 2021 09:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhCaJN5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Mar 2021 05:13:57 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:56834 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234501AbhCaJNt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Mar 2021 05:13:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UTwuZub_1617182027;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UTwuZub_1617182027)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 17:13:47 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] rtlwifi: rtl8188ee: remove redundant assignment of variable rtlpriv->btcoexist.reg_bt_sco
Date:   Wed, 31 Mar 2021 17:13:43 +0800
Message-Id: <1617182023-110950-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Assigning value "3" to "rtlpriv->btcoexist.reg_bt_sco" here, but that
stored value is overwritten before it can be used.

Coverity reports this problem as
CWE563: A value assigned to a variable is never used.
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c:
rtl8188ee_bt_reg_init

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 861cc66..bf686a9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -2466,8 +2466,6 @@ void rtl8188ee_bt_reg_init(struct ieee80211_hw *hw)
 
 	/* 0:Low, 1:High, 2:From Efuse. */
 	rtlpriv->btcoexist.reg_bt_iso = 2;
-	/* 0:Idle, 1:None-SCO, 2:SCO, 3:From Counter. */
-	rtlpriv->btcoexist.reg_bt_sco = 3;
 	/* 0:Disable BT control A-MPDU, 1:Enable BT control A-MPDU. */
 	rtlpriv->btcoexist.reg_bt_sco = 0;
 }
-- 
1.8.3.1

