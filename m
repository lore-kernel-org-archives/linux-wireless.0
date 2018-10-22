Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51048ECDE43
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 07:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2263320779
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 07:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2263320779
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbeJVP6J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 11:58:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58925 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727672AbeJVP6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 11:58:09 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 200BE58EE83B6;
        Mon, 22 Oct 2018 15:40:42 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.408.0; Mon, 22 Oct 2018 15:40:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        Nathan Chancellor <natechancellor@gmail.com>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] rtlwifi: btcoex: remove set but not used variable 'ppsc'
Date:   Mon, 22 Oct 2018 07:51:15 +0000
Message-ID: <1540194675-65562-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c: In function 'halbtc_leave_lps':
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:295:21: warning:
 variable 'ppsc' set but not used [-Wunused-but-set-variable]

drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c: In function 'halbtc_enter_lps':
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:318:21: warning:
 variable 'ppsc' set but not used [-Wunused-but-set-variable]

It never used since introduction in
commit aa45a673b291 ("rtlwifi: btcoexist: Add new mini driver")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 6fbf884..d748aab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -292,11 +292,9 @@ bool halbtc_send_bt_mp_operation(struct btc_coexist *btcoexist, u8 op_code,
 static void halbtc_leave_lps(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv;
-	struct rtl_ps_ctl *ppsc;
 	bool ap_enable = false;
 
 	rtlpriv = btcoexist->adapter;
-	ppsc = rtl_psc(rtlpriv);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_AP_MODE_ENABLE,
 			   &ap_enable);
@@ -315,11 +313,9 @@ static void halbtc_leave_lps(struct btc_coexist *btcoexist)
 static void halbtc_enter_lps(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv;
-	struct rtl_ps_ctl *ppsc;
 	bool ap_enable = false;
 
 	rtlpriv = btcoexist->adapter;
-	ppsc = rtl_psc(rtlpriv);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_AP_MODE_ENABLE,
 			   &ap_enable);

