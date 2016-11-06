Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:34558 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751764AbcKFNaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 Nov 2016 08:30:18 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH RFC] rtlwifi: btcoexist: fix port assignment
Date: Sun,  6 Nov 2016 13:56:59 +0100
Message-Id: <1478437019-24689-1-git-send-email-hofrat@osadl.org> (sfid-20161106_143026_574087_7A2D3E14)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The port assignment in the if case should be to AUX not MAIN.

Fixes: commit baa170229095 ("rtlwifi: btcoexist: Implement antenna selection")
Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---
problem located by coccinelle

in:
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:exhalbtc_set_ant_num()
973       /* The antenna position:
974        * Main (default) or Aux for pgAntNum=2 && btdmAntNum =1.
975        * The antenna position should be determined by
976        * auto-detect mechanism.
977        * The following is assumed to main,
978        * and those must be modified
979        * if y auto-detect mechanism is ready
980        */
981       if ((gl_bt_coexist.board_info.pg_ant_num == 2) &&
982           (gl_bt_coexist.board_info.btdm_ant_num == 1))
983               gl_bt_coexist.board_info.btdm_ant_pos =
984                                              BTC_ANTENNA_AT_MAIN_PORT;
985       else
986               gl_bt_coexist.board_info.btdm_ant_pos =
987                                              BTC_ANTENNA_AT_MAIN_PORT;
(line number from 4.9.0-rc2 linux-next 20161028)

the if and else branch here are the same but the comment seems to indicate
that the first case should be the AUX port and not the MAIN port here (the
second sentence in the comment though is not really clear to me). If the 
intent is to set it to MAIN unconditionally and then let autodetect fix it
then the if/else construct is useless.

Looks like a cut&past bug, but this needs a check by someone who knows the
details of the device.

Patch was compile tested with: x86_64_defconfig + RTL8723AE=m 
(implies CONFIG_RTLBTCOEXIST)

Patch is against 4.9.0-rc2 (localversion-next is next-20161028)

 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 91cc139..588c8ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -981,7 +981,7 @@ void exhalbtc_set_ant_num(struct rtl_priv *rtlpriv, u8 type, u8 ant_num)
 		if ((gl_bt_coexist.board_info.pg_ant_num == 2) &&
 		    (gl_bt_coexist.board_info.btdm_ant_num == 1))
 			gl_bt_coexist.board_info.btdm_ant_pos =
-						       BTC_ANTENNA_AT_MAIN_PORT;
+						       BTC_ANTENNA_AT_AUX_PORT;
 		else
 			gl_bt_coexist.board_info.btdm_ant_pos =
 						       BTC_ANTENNA_AT_MAIN_PORT;
-- 
2.1.4
