Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25003 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0KJMOL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 07:14:11 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 04:13:58 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH 3/3] ath9k_hw: Set proper eeprom offset for AR9287 HTC devices
Date: Wed, 10 Nov 2010 17:51:26 +0530
Message-ID: <1289391686-27632-3-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1289391686-27632-1-git-send-email-rmanoharan@atheros.com>
References: <1289391686-27632-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9287 based PCI & USB devices are differed in eeprom start offset.
So set proper the offset for HTC devices to read nvram correctly.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    2 +-
 drivers/net/wireless/ath/ath9k/reg.h         |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index ebf7a89..3ad1de2 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -37,7 +37,7 @@ static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 	int addr, eep_start_loc;
 	eep_data = (u16 *)eep;
 
-	if (ah->hw_version.devid == 0x7015)
+	if (AR9287_HTC_DEVID(ah))
 		eep_start_loc = AR9287_HTC_EEP_START_LOC;
 	else
 		eep_start_loc = AR9287_EEP_START_LOC;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 52ee82d..dddf579 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -870,6 +870,10 @@
 	 ((_ah)->hw_version.devid == 0xA704) || \
 	 ((_ah)->hw_version.devid == 0x1200))
 
+#define AR9287_HTC_DEVID(_ah) \
+	(((_ah)->hw_version.devid == 0x7015) || \
+	 ((_ah)->hw_version.devid == 0x1200))
+
 #define AR_RADIO_SREV_MAJOR                   0xf0
 #define AR_RAD5133_SREV_MAJOR                 0xc0
 #define AR_RAD2133_SREV_MAJOR                 0xd0
-- 
1.7.3.2

