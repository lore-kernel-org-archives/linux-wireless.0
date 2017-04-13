Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34553 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755407AbdDMSH1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:27 -0400
Received: by mail-oi0-f65.google.com with SMTP id t14so4185351oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:27 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 12/19] rtlwifi: btcoex: 21a 2ant: ignore wifi if it is at 5G band
Date: Thu, 13 Apr 2017 13:07:03 -0500
Message-Id: <20170413180710.19953-13-Larry.Finger@lwfinger.net> (sfid-20170413_200804_020226_01D148D6)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When wifi is at 5G band, it does not intefere with 2.4G bt signal,
hence we can just ignore it and transmit normally as nothing happened.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 4030b6429c1d..bb609f078a01 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1364,6 +1364,7 @@ static void btc8821a2ant_coex_all_off(struct btc_coexist *btcoexist)
 static void btc8821a2ant_coex_under_5g(struct btc_coexist *btcoexist)
 {
 	btc8821a2ant_coex_all_off(btcoexist);
+	btc8821a2ant_ignore_wlan_act(btcoexist, NORMAL_EXEC, true);
 }
 
 static void btc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
-- 
2.12.0
