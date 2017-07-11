Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33201 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753956AbdGKBd3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 21:33:29 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Stable <stable@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/2] rtlwifi: fix static checker warning of uninitialized symbol.
Date: Mon, 10 Jul 2017 20:33:12 -0500
Message-Id: <20170711013313.3478-2-Larry.Finger@lwfinger.net> (sfid-20170711_033338_483245_55AF9322)
In-Reply-To: <20170711013313.3478-1-Larry.Finger@lwfinger.net>
References: <20170711013313.3478-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Patch 2635664e6e4a: ("rtlwifi: Add rx ampdu cfg for btcoexist.")
leads to the following static checker warning:

	drivers/net/wireless/realtek/rtlwifi/base.c:1664 rtl_rx_ampdu_apply()
	error: uninitialized symbol 'reject_agg'.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 2635664e6e4a: ("rtlwifi: Add rx ampdu cfg for btcoexist.")
Cc: Stable <stable@vger.kernel.org> # v4.12+
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index c145cfe27216..d7a1e2d2d529 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1731,7 +1731,7 @@ int rtl_tx_agg_oper(struct ieee80211_hw *hw,
 void rtl_rx_ampdu_apply(struct rtl_priv *rtlpriv)
 {
 	struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
-	u8 reject_agg, ctrl_agg_size = 0, agg_size;
+	u8 reject_agg = 0, ctrl_agg_size = 0, agg_size = 0;
 
 	if (rtlpriv->cfg->ops->get_btc_status())
 		btc_ops->btc_get_ampdu_cfg(rtlpriv, &reject_agg,
-- 
2.12.3
