Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:32769 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbcEBQjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 12:39:00 -0400
Date: Tue, 3 May 2016 00:38:36 +0800
From: Wang YanQing <udknight@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: kvalo@codeaurora.org, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] rtlwifi: Fix logic error in enter/exit power-save mode
Message-ID: <20160502163835.GA10925@udknight> (sfid-20160502_183923_818965_9F2B272B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit a269913c52ad ("rtlwifi: Rework rtl_lps_leave() and
rtl_lps_enter() to use work queue"), the tests for enter/exit
power-save mode were inverted. With this change applied, the
wifi connection becomes much more stable.

Fixes: a269913c52ad ("rtlwifi: Rework rtl_lps_leave() and rtl_lps_enter() to use work queue")
Signed-off-by: Wang YanQing <udknight@gmail.com>
CC: Stable <stable@vger.kernel.org> [3.10+]
---
 Hi, Larry!

 Because commit a269913c52ad is the first commit bring this problem, 
 so maybe use above commit message is ok, right? And stable kernels
 3.10-3.18 don't have commit fd09ff958777, but have a269913c52ad.

 Thanks for suggestion concerning to good subject and commit message
 writing, it is harder than coding sometimes:)

 Changes:
 v1-v2:
 1: Fix subject and commit message.

 drivers/net/wireless/realtek/rtlwifi/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index c74eb13..264466f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1660,9 +1660,9 @@ void rtl_watchdog_wq_callback(void *data)
 		if (((rtlpriv->link_info.num_rx_inperiod +
 		      rtlpriv->link_info.num_tx_inperiod) > 8) ||
 		    (rtlpriv->link_info.num_rx_inperiod > 2))
-			rtl_lps_enter(hw);
-		else
 			rtl_lps_leave(hw);
+		else
+			rtl_lps_enter(hw);
 	}
 
 	rtlpriv->link_info.num_rx_inperiod = 0;
-- 
1.8.5.6.2.g3d8a54e.dirty
