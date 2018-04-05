Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.146.80]:37965 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752583AbeDEBZn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 21:25:43 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id BBA81293F52F
        for <linux-wireless@vger.kernel.org>; Wed,  4 Apr 2018 20:25:42 -0500 (CDT)
Date: Wed, 4 Apr 2018 20:25:40 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [rtlwifi-btcoex] Suspicious code in halbtc8821a1ant driver
Message-ID: <20180405012540.GA24241@embeddedor.com> (sfid-20180405_032549_191290_37E32BA4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

While doing some static analysis I came across the following piece of code at drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c:1581:

1581 static void btc8821a1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
1582                                                   u8 wifi_status)
1583 {
1584         /* tdma and coex table */
1585         btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
1586 
1587         if (BT_8821A_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN ==
1588             wifi_status)
1589                 btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
1590         else
1591                 btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
1592 }

The issue here is that the code for both branches of the if-else statement is identical.

The if-else was introduced a year ago in this commit c6821613e653

I wonder if an argument should be changed in any of the calls to btc8821a1ant_coex_table_with_type?

What do you think?

Thanks
--
Gustavo
