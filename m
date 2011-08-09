Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62124 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1HISZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 14:25:31 -0400
From: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH] ath9k_hw: Fix STA (AR9485) bringup issue due to incorrect MAC address
Date: Tue, 9 Aug 2011 23:52:58 +0530
Message-ID: <1312914178-9601-1-git-send-email-senthilb@qca.qualcomm.com> (sfid-20110809_202535_414366_777C4B61)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to some recent optimization done in the way the mac address
bytes are written into the OTP memory, some AR9485 chipsets were
forced to use the first byte from the eeprom template and as AR9485
happens to use generic eeprom template which has 0x1 as the first
byte causes issues in bringing up the card.

So fixed the eeprom template accordingly to address the issue.

Cc: Paul Stewart <pstew@google.com>
Signed-off-by: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 184abb6..b527ea1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -69,7 +69,7 @@ static int ar9003_hw_power_interpolate(int32_t x,
 static const struct ar9300_eeprom ar9300_default = {
 	.eepromVersion = 2,
 	.templateVersion = 2,
-	.macAddr = {1, 2, 3, 4, 5, 6},
+	.macAddr = {0, 2, 3, 4, 5, 6},
 	.custData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		     0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
 	.baseEepHeader = {
-- 
1.7.0.4

