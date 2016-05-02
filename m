Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36758 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbcEBFoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 01:44:04 -0400
Date: Mon, 2 May 2016 13:37:54 +0800
From: Wang YanQing <udknight@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: chaoming_li@realsil.com.cn, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi:rtl_watchdog_wq_callback: fix calling
 rtl_lps_enter|rtl_lps_leave in opposite condition
Message-ID: <20160502053754.GA30313@udknight> (sfid-20160502_074439_341689_DA03A532)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit a269913c52ad37952a4d9953bb6d748f7299c304
("rtlwifi: Rework rtl_lps_leave() and rtl_lps_enter() to use work queue")
make a mistake, change the meaning of num_tx|rx_inperiod comparison test.

Commit fd09ff958777cf583d7541f180991c0fc50bd2f7
("rtlwifi: Remove extra workqueue for enter/leave power state")
follow previous mistake, bring us to current code.

This patch fix it.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 I think this patch should be ported back to stable kernels, 3.10+.
 In my machine, I will lost wifi connection after minutes if I enable
 fwlps.
 
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
