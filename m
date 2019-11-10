Return-Path: <SRS0=Jrqb=ZC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C79DC17443
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Nov 2019 10:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 579E4207FA
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Nov 2019 10:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfKJKvN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Nov 2019 05:51:13 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:54404 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726609AbfKJKvN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Nov 2019 05:51:13 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9DBEA7F856F93392CD29;
        Sun, 10 Nov 2019 18:51:10 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Sun, 10 Nov 2019 18:51:03 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <Jes.Sorensen@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <zhengyongjun3@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] rtl8xxxu: Remove set but not used variable 'rsr'
Date:   Sun, 10 Nov 2019 18:49:55 +0800
Message-ID: <20191110104955.131246-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_gen2_config_channel:
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:1266:13: warning: variable rsr set but not used [-Wunused-but-set-variable]

rsr is never used, so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index c6c41fb962ff..2c1ca4bc4e56 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1255,7 +1255,7 @@ void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw)
 void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
-	u32 val32, rsr;
+	u32 val32;
 	u8 val8, subchannel;
 	u16 rf_mode_bw;
 	bool ht = true;
@@ -1264,7 +1264,6 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
 
 	rf_mode_bw = rtl8xxxu_read16(priv, REG_WMAC_TRXPTCL_CTL);
 	rf_mode_bw &= ~WMAC_TRXPTCL_CTL_BW_MASK;
-	rsr = rtl8xxxu_read32(priv, REG_RESPONSE_RATE_SET);
 	channel = hw->conf.chandef.chan->hw_value;
 
 /* Hack */
-- 
2.23.0

