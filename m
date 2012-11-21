Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42542 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab2KUUQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 15:16:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8723ae: fix build break from "mac80211: support RX_FLAG_MACTIME_END"
Date: Wed, 21 Nov 2012 15:05:55 -0500
Message-Id: <1353528355-14132-1-git-send-email-linville@tuxdriver.com> (sfid-20121121_211625_744062_5F0636BD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

  CC      drivers/net/wireless/rtlwifi/rtl8723ae/trx.o
drivers/net/wireless/rtlwifi/rtl8723ae/trx.c: In function ‘rtl8723ae_rx_query_desc’:
drivers/net/wireless/rtlwifi/rtl8723ae/trx.c:324:21: error: ‘RX_FLAG_MACTIME_MPDU’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8723ae/trx.c:324:21: note: each undeclared identifier is reported only once for each function it appears in
make[3]: *** [drivers/net/wireless/rtlwifi/rtl8723ae/trx.o] Error 1

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
index 9719d54..87331d8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
@@ -321,7 +321,7 @@ bool rtl8723ae_rx_query_desc(struct ieee80211_hw *hw,
 	if (status->is_ht)
 		rx_status->flag |= RX_FLAG_HT;
 
-	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+	rx_status->flag |= RX_FLAG_MACTIME_START;
 
 	/* hw will set status->decrypted true, if it finds the
 	 * frame is open data frame or mgmt frame.
-- 
1.7.11.7

