Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36318 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874AbZBLEke (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:40:34 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 20:40:34 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18835.42852.814424.538794@gargle.gargle.HOWL> (sfid-20090212_054037_936347_45E1A9A2)
Date: Thu, 12 Feb 2009 10:06:52 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 7/8] ath9k: Fix incorrect noise floor reading for 4k EEPROM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index c2335af..b0fdb1e 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -439,7 +439,7 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 
 	switch (param) {
 	case EEP_NFTHRESH_2:
-		return pModal[1].noiseFloorThreshCh[0];
+		return pModal->noiseFloorThreshCh[0];
 	case AR_EEPROM_MAC(0):
 		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
 	case AR_EEPROM_MAC(1):
-- 
1.6.1

