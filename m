Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:37525 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab3IBFr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 01:47:59 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] ath9k: Use correct RX gain table for AR9565
Date: Mon,  2 Sep 2013 11:14:03 +0530
Message-Id: <1378100645-29868-4-git-send-email-sujith@msujith.org> (sfid-20130902_074804_120786_6B9F3AB5)
In-Reply-To: <1378100645-29868-1-git-send-email-sujith@msujith.org>
References: <1378100645-29868-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 608bb48..d40bdd2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -628,6 +628,9 @@ static void ar9003_rx_gain_table_mode0(struct ath_hw *ah)
 	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 				ar9462_common_rx_gain_table_2p0);
+	else if (AR_SREV_9565(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       ar9565_1p0_Common_rx_gain_table);
 	else
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 				ar9300Common_rx_gain_table_2p2);
-- 
1.8.4

