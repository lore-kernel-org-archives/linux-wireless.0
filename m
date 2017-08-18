Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31812 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdHRIIS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 04:08:18 -0400
Date: Fri, 18 Aug 2017 11:05:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Maxim Samoylov <max7255@gmail.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] rtlwifi: make a couple arrays larger
Message-ID: <20170818080519.mvjls5pgnxeknzpk@mwanda> (sfid-20170818_100825_297236_8D994FAD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a static checker fix.  "cal_num" is 10.  We're declaring the
tx_dt[] and rx_td[] arrays as 3 element arrays.  The static checker
complains that we do:

	tx_dt[cal] = (vdf_y[1]>>20)-(vdf_y[0]>>20);

"cal" is the iterator and it is in the 0-9 range so it looks like
we could corrupt memory.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I'm pretty sure this patch is correct and absolutely harmless.  But the
code is pretty involved and I didn't test it.  So you may want to review
this one carefully.

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index aa3ccc740521..176deb2b5386 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -3773,10 +3773,11 @@ static void _rtl8821ae_iqk_tx(struct ieee80211_hw *hw, enum radio_path path)
 	u32	tx_fail, rx_fail, delay_count, iqk_ready, cal_retry, cal = 0, temp_reg65;
 	int	tx_x = 0, tx_y = 0, rx_x = 0, rx_y = 0, tx_average = 0, rx_average = 0;
 	int	tx_x0[cal_num], tx_y0[cal_num], tx_x0_rxk[cal_num],
-		tx_y0_rxk[cal_num], rx_x0[cal_num], rx_y0[cal_num];
+		tx_y0_rxk[cal_num], rx_x0[cal_num], rx_y0[cal_num],
+		tx_dt[cal_num], rx_dt[cal_num];
 	bool	tx0iqkok = false, rx0iqkok = false;
 	bool	vdf_enable = false;
-	int	i, k, vdf_y[3], vdf_x[3], tx_dt[3], rx_dt[3],
+	int	i, k, vdf_y[3], vdf_x[3],
 		ii, dx = 0, dy = 0, tx_finish = 0, rx_finish = 0;
 
 	RT_TRACE(rtlpriv, COMP_IQK, DBG_LOUD,
