Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38674 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbcEDGRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2016 02:17:02 -0400
Date: Wed, 4 May 2016 09:16:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] rtlwifi: rtl818x: silence uninitialized variable warning
Message-ID: <20160504061639.GB22064@mwanda> (sfid-20160504_081723_329774_CC214270)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What about if "rtlphy->pwrgroup_cnt" is 2?  In that case we would use an
uninitialized "chnlgroup" variable and probably crash.  Maybe that can't
happen for some reason which is not obvious but in that case this patch
is harmless.

Setting it to zero seems like a standard default in the surrounding code
so it's probably fine here as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c
index 78a81c1..9475aa2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c
@@ -208,8 +208,7 @@ static void _rtl92s_get_txpower_writeval_byregulatory(struct ieee80211_hw *hw,
 				 "Realtek regulatory, 40MHz, writeval = 0x%x\n",
 				 writeval);
 		} else {
-			if (rtlphy->pwrgroup_cnt == 1)
-				chnlgroup = 0;
+			chnlgroup = 0;
 
 			if (rtlphy->pwrgroup_cnt >= 3) {
 				if (chnl <= 3)
