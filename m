Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38112 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1EaS7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 14:59:37 -0400
Received: by mail-pw0-f46.google.com with SMTP id 15so2187996pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 11:59:37 -0700 (PDT)
From: Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH] ath9k: fix two more bugs in tx power
Date: Tue, 31 May 2011 11:59:30 -0700
Message-Id: <BC07EC2E-2433-463F-B4A5-056EDEDC9630@cs.washington.edu> (sfid-20110531_205945_962403_3EC3732A)
To: linux-wireless <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the same fix as

   commit 841051602e3fa18ea468fe5a177aa92b6eb44b56
   Author: Matteo Croce <technoboy85@gmail.com>
   Date:   Fri Dec 3 02:25:08 2010 +0100

   The ath9k driver subtracts 3 dBm to the txpower as with two radios the
   signal power is doubled.
   The resulting value is assigned in an u16 which overflows and makes
   the card work at full power.

in two more places. I grepped the ath tree and didn't find any others.

Cc: stable@kernel.org
Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
---
Removed RFC.
---
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 ++++++++--
drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   10 ++++++++--
2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 729534c..934e419 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4645,10 +4645,16 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
	case 1:
		break;
	case 2:
-		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		else
+			scaledPower = 0;
		break;
	case 3:
-		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		else
+			scaledPower = 0;
		break;
	}

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 7856f0d..343fc9f 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -524,10 +524,16 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
	case 1:
		break;
	case 2:
-		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		else
+			scaledPower = 0;
		break;
	case 3:
-		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		else
+			scaledPower = 0;
		break;
	}
	scaledPower = max((u16)0, scaledPower);
-- 
1.7.0.4

