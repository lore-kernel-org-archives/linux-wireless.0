Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35380 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965449AbbJVSR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 14:17:26 -0400
From: Punit Vara <punitvara@gmail.com>
To: jirislaby@gmail.com
Cc: mickflemm@gmail.com, mcgrof@do-not-panic.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Punit Vara <punitvara@gmail.com>
Subject: [PATCH v2 14/15] net: wireless: ath: Remove unneeded variable ret returning 0
Date: Thu, 22 Oct 2015 23:47:08 +0530
Message-Id: <1445537828-2802-1-git-send-email-punitvara@gmail.com> (sfid-20151022_201800_800804_F6FDCDF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to the ath5k/eeprom.c that fixes up warning caught by
coccicheck:

-Unneeded variable: "ret". Return "0" on line 1733

Remove unneccesary variable ret created to return zero.

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/net/wireless/ath/ath5k/eeprom.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 94d34ee..0c82ea5 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1707,8 +1707,7 @@ ath5k_eeprom_read_spur_chans(struct ath5k_hw *ah)
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 offset;
 	u16 val;
-	int ret = 0, i;
-
+	int i;
 	offset = AR5K_EEPROM_CTL(ee->ee_version) +
 				AR5K_EEPROM_N_CTLS(ee->ee_version);
 
@@ -1730,7 +1729,7 @@ ath5k_eeprom_read_spur_chans(struct ath5k_hw *ah)
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 
-- 
2.5.3

