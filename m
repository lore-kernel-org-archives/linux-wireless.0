Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52307 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdHLWAn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 Aug 2017 18:00:43 -0400
From: Colin King <colin.king@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: btcoex: make function btc8723b2ant_dac_swing static
Date: Sat, 12 Aug 2017 23:00:17 +0100
Message-Id: <20170812220017.6505-1-colin.king@canonical.com> (sfid-20170813_000103_905946_780B7CD6)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The function btc8723b2ant_dac_swing  is local to the source and
does not need to be in global scope, so make it static.

Cleans up sparse warning:
symbol 'btc8723b2ant_dac_swing' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 31965f0ef69d..9d2ecfbc7b33 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -833,9 +833,9 @@ static void btc8723b2ant_set_sw_fulltime_dac_swing(struct btc_coexist *btcoex,
 		btc8723b2ant_set_dac_swing_reg(btcoex, 0x18);
 }
 
-void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
-			    bool force_exec, bool dac_swing_on,
-			    u32 dac_swing_lvl)
+static void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
+				   bool force_exec, bool dac_swing_on,
+				   u32 dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
-- 
2.11.0
