Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357F6C10F0B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 02:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01ECC218E2
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 02:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbfB0CKO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 21:10:14 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:4170 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729527AbfB0CKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 21:10:14 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1D54FF46A673E221C458;
        Wed, 27 Feb 2019 10:10:12 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.408.0; Wed, 27 Feb 2019 10:10:01 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8723be: Remove set but not used variable 'b_last_is_cur_rdlstate'
Date:   Wed, 27 Feb 2019 02:23:21 +0000
Message-ID: <20190227022321.7623-1-yuehaibing@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c: In function 'rtl8723be_dm_check_edca_turbo':
drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c:998:7: warning:
 variable 'b_last_is_cur_rdlstate' set but not used [-Wunused-but-set-variable]

It's never used and can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
index ef355aa88117..b13fd3c0c832 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
@@ -995,12 +995,9 @@ static void rtl8723be_dm_check_edca_turbo(struct ieee80211_hw *hw)
 	u32 edca_be = 0x5ea42b;
 	u32 iot_peer = 0;
 	bool b_is_cur_rdlstate;
-	bool b_last_is_cur_rdlstate = false;
 	bool b_bias_on_rx = false;
 	bool b_edca_turbo_on = false;
 
-	b_last_is_cur_rdlstate = rtlpriv->dm.is_cur_rdlstate;
-
 	cur_txok_cnt = rtlpriv->stats.txbytesunicast - last_txok_cnt;
 	cur_rxok_cnt = rtlpriv->stats.rxbytesunicast - last_rxok_cnt;



