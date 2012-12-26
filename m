Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:36450
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab2LZG61 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2012 01:58:27 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] ath9k_hw: Fix RX gain initvals for AR9485
Date: Wed, 26 Dec 2012 12:27:39 +0530
Message-Id: <1356505059-18149-2-git-send-email-sujith@msujith.org> (sfid-20121226_075835_754829_6155A6F1)
In-Reply-To: <1356505059-18149-1-git-send-email-sujith@msujith.org>
References: <1356505059-18149-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Populate iniModesRxGain with the correct initvals
array for AR9485 v1.1

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 74fd397..59bf5f3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -544,7 +544,7 @@ static void ar9003_rx_gain_table_mode0(struct ath_hw *ah)
 				ar9340Common_rx_gain_table_1p0);
 	else if (AR_SREV_9485_11(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-				ar9485Common_wo_xlna_rx_gain_1_1);
+			       ar9485_common_rx_gain_1_1);
 	else if (AR_SREV_9550(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 				ar955x_1p0_common_rx_gain_table);
-- 
1.8.0.2

