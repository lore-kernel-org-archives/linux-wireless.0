Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34646 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBCICT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 03:02:19 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath9k: Fix TX power calculation
Date: Mon,  3 Feb 2014 13:31:37 +0530
Message-Id: <1391414497-17263-1-git-send-email-sujith@msujith.org> (sfid-20140203_090222_222986_889D0BB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The commit, "ath9k_hw: Fix incorrect Tx control power in AR9003 template"
fixed the incorrect values in the eeprom templates, but if
boards have already been calibrated with incorrect values,
they would still be using the wrong TX power. Fix this by assigning
a default value in such cases.

Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 25243cb..b8daff7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5065,6 +5065,10 @@ static u16 ar9003_hw_get_max_edge_power(struct ar9300_eeprom *eep,
 			break;
 		}
 	}
+
+	if (is2GHz && !twiceMaxEdgePower)
+		twiceMaxEdgePower = 60;
+
 	return twiceMaxEdgePower;
 }
 
-- 
1.8.5.3

