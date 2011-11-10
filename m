Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1331 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934165Ab1KJJoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 04:44:05 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH v2 4/4] ath9k_hw: Fix tx power settings for AR9003
Date: Thu, 10 Nov 2011 15:14:57 +0530
Message-ID: <1320918297-1799-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111110_104416_280445_B7057A3B)
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
v2: make use of the existing function

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index ee9c09b..a93bd63 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5059,6 +5059,8 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 			regulatory->max_power_level = targetPowerValT2[i];
 	}
 
+	ath9k_hw_update_regulatory_maxpower(ah);
+
 	if (test)
 		return;
 
-- 
1.7.7.3

