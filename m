Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E20FC10F0B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 02:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DBCB218CD
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 02:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbfB0CKZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 21:10:25 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:46256 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729527AbfB0CKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 21:10:25 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EEC5BC1ED05CABCEDBB2;
        Wed, 27 Feb 2019 10:10:22 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.408.0; Wed, 27 Feb 2019 10:10:14 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8723ae: Remove set but not used variable 'bt_retry_cnt'
Date:   Wed, 27 Feb 2019 02:23:34 +0000
Message-ID: <20190227022334.7750-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c: In function '_rtl8723e_dm_bt_coexist_2_ant':
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c:1408:5: warning:
 variable 'bt_retry_cnt' set but not used [-Wunused-but-set-variable]

It's never used and can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
index a6b31dae5691..680198280f8f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
@@ -1405,7 +1405,6 @@ static void rtl8723e_dm_bt_reset_action_profile_state(struct ieee80211_hw *hw)
 static void _rtl8723e_dm_bt_coexist_2_ant(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 bt_retry_cnt;
 	u8 bt_info_original;
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
 		"[BTCoex] Get bt info by fw!!\n");
@@ -1417,7 +1416,6 @@ static void _rtl8723e_dm_bt_coexist_2_ant(struct ieee80211_hw *hw)
 				"[BTCoex] c2h for bt_info not rcvd yet!!\n");
 	}
 
-	bt_retry_cnt = hal_coex_8723.bt_retry_cnt;
 	bt_info_original = hal_coex_8723.c2h_bt_info_original;
 
 	/* when bt inquiry or page scan, we have to set h2c 0x25 */



