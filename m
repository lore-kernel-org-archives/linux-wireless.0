Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27967 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbdGMHqQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Jul 2017 03:46:16 -0400
Date: Thu, 13 Jul 2017 10:43:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Masanari Iida <standby24x7@gmail.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8821ae: Fix HW_VAR_NAV_UPPER operation
Message-ID: <20170713074323.r7rjpnp6ghrdtjgx@mwanda> (sfid-20170713_094620_585914_1CAB3C6D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cast here is wrong.  We want to cast the pointer but we accidentally
do a no-op cast of the value.  We normally want to set us_nav_upper to
WIFI_NAV_UPPER_US (30000) but because of this bug we instead set it to
184 on little endian systems and 0 on big endian ones.

Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 2bc6bace069c..230f92a48f3c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -779,7 +779,7 @@ void rtl8821ae_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 			_rtl8821ae_resume_tx_beacon(hw);
 		break; }
 	case HW_VAR_NAV_UPPER: {
-		u32	us_nav_upper = ((u32)*val);
+		u32	us_nav_upper = *(u32 *)val;
 
 		if (us_nav_upper > HAL_92C_NAV_UPPER_UNIT * 0xFF) {
 			RT_TRACE(rtlpriv, COMP_INIT , DBG_WARNING,
