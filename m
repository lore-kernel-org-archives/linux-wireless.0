Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48983 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1KHIxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 03:53:32 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH 4/4] ath9k_hw: Fix tx power settings for AR9003
Date: Tue, 8 Nov 2011 14:22:48 +0530
Message-ID: <1320742368-11343-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111108_095336_293994_554995FA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Retriving tx power for 2x2 and 3x3 chainmask is not handled
properly. While calculating tx power for 2x2, 3 dBm was reduced
and for 3x3, 5 dBm was reduced which should be added back when
retriving.

Cc: Paul Stewart <pstew@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index ee9c09b..d2e4f28 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5059,6 +5059,21 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 			regulatory->max_power_level = targetPowerValT2[i];
 	}
 
+	switch (ar5416_get_ntxchains(ah->txchainmask)) {
+	case 1:
+		break;
+	case 2:
+		regulatory->max_power_level += INCREASE_MAXPOW_BY_TWO_CHAIN;
+		break;
+	case 3:
+		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
+		break;
+	default:
+		ath_dbg(ath9k_hw_common(ah), ATH_DBG_EEPROM,
+			"Invalid chainmask configuration\n");
+		break;
+	}
+
 	if (test)
 		return;
 
-- 
1.7.7.2

