Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:39490 "EHLO
        mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751994AbdLJUCQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Dec 2017 15:02:16 -0500
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] rtlwifi: always initialize variables given to RT_TRACE()
Date: Sun, 10 Dec 2017 20:51:59 +0100
Message-Id: <20171210195159.7454-1-nicolas.iooss_linux@m4x.org> (sfid-20171210_210227_223390_EE1644ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rtl_rx_ampdu_apply(), when rtlpriv->cfg->ops->get_btc_status()
returns false, RT_TRACE() is called with the values of variables
reject_agg and agg_size, which have not been initialized.

Always initialize these variables in order to prevent using
uninitialized values.

This issue has been found with clang. The compiler reported:

    drivers/net/wireless/realtek/rtlwifi/base.c:1665:6: error: variable
    'agg_size' is used uninitialized whenever 'if' condition is false
    [-Werror,-Wsometimes-uninitialized]
            if (rtlpriv->cfg->ops->get_btc_status())
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    drivers/net/wireless/realtek/rtlwifi/base.c:1671:31: note:
    uninitialized use occurs here
                     reject_agg, ctrl_agg_size, agg_size);
                                                ^~~~~~~~

    drivers/net/wireless/realtek/rtlwifi/base.c:1665:6: error: variable
    'reject_agg' is used uninitialized whenever 'if' condition
          is false [-Werror,-Wsometimes-uninitialized]
            if (rtlpriv->cfg->ops->get_btc_status())
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    drivers/net/wireless/realtek/rtlwifi/base.c:1671:4: note:
    uninitialized use occurs here
                     reject_agg, ctrl_agg_size, agg_size);
                     ^~~~~~~~~~

Fixes: 2635664e6e4a ("rtlwifi: Add rx ampdu cfg for btcoexist.")
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index cad2272ae21b..704741d6f495 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1726,7 +1726,7 @@ int rtl_tx_agg_oper(struct ieee80211_hw *hw,
 void rtl_rx_ampdu_apply(struct rtl_priv *rtlpriv)
 {
 	struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
-	u8 reject_agg, ctrl_agg_size = 0, agg_size;
+	u8 reject_agg = 0, ctrl_agg_size = 0, agg_size = 0;
 
 	if (rtlpriv->cfg->ops->get_btc_status())
 		btc_ops->btc_get_ampdu_cfg(rtlpriv, &reject_agg,
-- 
2.15.0
