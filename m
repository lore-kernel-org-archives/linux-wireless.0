Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42896 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdI2Hy0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 03:54:26 -0400
Date: Fri, 29 Sep 2017 10:52:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] rtlwifi: silence underflow warning
Message-ID: <20170929075234.dgyuiwbowu3jq6r4@mwanda> (sfid-20170929_095430_129424_A0C9DBCE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170929075117.cno3vnrebea32upt@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My static checker complains that we have an upper bound but no lower
bound.  I suspect neither are really required but it doesn't hurt to add
a check for negatives.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index c53cbf3d52bd..294a6b43d1bc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -453,7 +453,8 @@ static void _rtl_add_wowlan_patterns(struct ieee80211_hw *hw,
 	for (i = 0; i < wow->n_patterns; i++) {
 		memset(&rtl_pattern, 0, sizeof(struct rtl_wow_pattern));
 		memset(mask, 0, MAX_WOL_BIT_MASK_SIZE);
-		if (patterns[i].pattern_len > MAX_WOL_PATTERN_SIZE) {
+		if (patterns[i].pattern_len < 0 ||
+		    patterns[i].pattern_len > MAX_WOL_PATTERN_SIZE) {
 			RT_TRACE(rtlpriv, COMP_POWER, DBG_WARNING,
 				 "Pattern[%d] is too long\n", i);
 			continue;
