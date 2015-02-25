Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42115 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbBYNZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 08:25:23 -0500
Date: Wed, 25 Feb 2015 16:24:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] rtlwifi: rtl8188ee: missing curly braces in handle_branch1()
Message-ID: <20150225132451.GL19745@mwanda> (sfid-20150225_142533_082128_25FF8D3F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From the indenting, it seems like the READ_NEXT_PAIR() was supposed to
be inside the while loop.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
index 3f6c59c..a2bb02c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
@@ -452,9 +452,10 @@ static void handle_branch1(struct ieee80211_hw *hw, u16 arraylen,
 				READ_NEXT_PAIR(v1, v2, i);
 				while (v2 != 0xDEAD &&
 				       v2 != 0xCDEF &&
-				       v2 != 0xCDCD && i < arraylen - 2)
+				       v2 != 0xCDCD && i < arraylen - 2) {
 					_rtl8188e_config_bb_reg(hw, v1, v2);
 					READ_NEXT_PAIR(v1, v2, i);
+				}
 
 				while (v2 != 0xDEAD && i < arraylen - 2)
 					READ_NEXT_PAIR(v1, v2, i);
