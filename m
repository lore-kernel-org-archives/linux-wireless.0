Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.50.161]:21644 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754113AbdEQWPR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 18:15:17 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 8F9881AE5F
        for <linux-wireless@vger.kernel.org>; Wed, 17 May 2017 16:52:32 -0500 (CDT)
Date: Wed, 17 May 2017 16:52:32 -0500
Message-ID: <20170517165232.Horde.v4lHW1-r73ZYdz2POOdERBa@gator4166.hostgator.com> (sfid-20170518_001521_201522_332E89FD)
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-realtek-btcoexist] question about identical code for different
 branches
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello everybody,

While looking into Coverity ID 1362263 I ran into the following piece  
of code at  
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1000:

1000void exhalbtc_set_ant_num(struct rtl_priv *rtlpriv, u8 type, u8 ant_num)
1001{
1002        if (BT_COEX_ANT_TYPE_PG == type) {
1003                gl_bt_coexist.board_info.pg_ant_num = ant_num;
1004                gl_bt_coexist.board_info.btdm_ant_num = ant_num;
1005                /* The antenna position:
1006                 * Main (default) or Aux for pgAntNum=2 && btdmAntNum =1.
1007                 * The antenna position should be determined by
1008                 * auto-detect mechanism.
1009                 * The following is assumed to main,
1010                 * and those must be modified
1011                 * if y auto-detect mechanism is ready
1012                 */
1013                if ((gl_bt_coexist.board_info.pg_ant_num == 2) &&
1014                    (gl_bt_coexist.board_info.btdm_ant_num == 1))
1015                        gl_bt_coexist.board_info.btdm_ant_pos =
1016                                                        
BTC_ANTENNA_AT_MAIN_PORT;
1017                else
1018                        gl_bt_coexist.board_info.btdm_ant_pos =
1019                                                        
BTC_ANTENNA_AT_MAIN_PORT;
1020        } else if (BT_COEX_ANT_TYPE_ANTDIV == type) {
1021                gl_bt_coexist.board_info.btdm_ant_num = ant_num;
1022                gl_bt_coexist.board_info.btdm_ant_pos =
1023                                                        
BTC_ANTENNA_AT_MAIN_PORT;
1024        } else if (type == BT_COEX_ANT_TYPE_DETECTED) {
1025                gl_bt_coexist.board_info.btdm_ant_num = ant_num;
1026                if (rtlpriv->cfg->mod_params->ant_sel == 1)
1027                        gl_bt_coexist.board_info.btdm_ant_pos =
1028                                BTC_ANTENNA_AT_AUX_PORT;
1029                else
1030                        gl_bt_coexist.board_info.btdm_ant_pos =
1031                                BTC_ANTENNA_AT_MAIN_PORT;
1032        }
1033}

The issue is that lines of code 1015-1016 and 1018-1019 are identical  
for different branches.

My question here is if one of those assignments should be modified, or  
the entire _if_ statement replaced and the function refactored?

I'd really appreciate any comment on this.

Thank you!
--
Gustavo A. R. Silva
