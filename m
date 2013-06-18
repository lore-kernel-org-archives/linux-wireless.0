Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:35302 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3FREqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 00:46:43 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] ath9k: Convert a couple of debug messages
Date: Tue, 18 Jun 2013 10:13:40 +0530
Message-Id: <1371530623-15746-2-git-send-email-sujith@msujith.org> (sfid-20130618_064645_904975_FAB627CC)
In-Reply-To: <1371530623-15746-1-git-send-email-sujith@msujith.org>
References: <1371530623-15746-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use the REGULATORY debug level to print the target power
details. EEPROM can be used for other purposes and this
spams the log.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index eae23b9..1e86977 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4562,7 +4562,7 @@ static void ar9003_hw_get_target_power_eeprom(struct ath_hw *ah,
 						 is2GHz);
 
 	for (i = 0; i < ar9300RateSize; i++) {
-		ath_dbg(common, EEPROM, "TPC[%02d] 0x%08x\n",
+		ath_dbg(common, REGULATORY, "TPC[%02d] 0x%08x\n",
 			i, targetPowerValT2[i]);
 	}
 }
@@ -5288,7 +5288,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 		return;
 
 	for (i = 0; i < ar9300RateSize; i++) {
-		ath_dbg(common, EEPROM, "TPC[%02d] 0x%08x\n",
+		ath_dbg(common, REGULATORY, "TPC[%02d] 0x%08x\n",
 			i, targetPowerValT2[i]);
 	}
 
-- 
1.8.3.1

