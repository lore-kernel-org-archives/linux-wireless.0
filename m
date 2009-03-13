Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63486 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbZCMDaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 23:30:12 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 20:30:11 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18873.53839.291542.204720@gargle.gargle.HOWL> (sfid-20090313_043018_897337_A59A2138)
Date: Fri, 13 Mar 2009 08:56:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 5/7] ath9k: Fix bug in 4K EEPROM size calculation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should be checking with the 4K header and not the non-4K
header size.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 973b576..d7b9cf4 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -416,7 +416,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 	else
 		el = ah->eeprom.map4k.baseEepHeader.length;
 
-	if (el > sizeof(struct ar5416_eeprom_def))
+	if (el > sizeof(struct ar5416_eeprom_4k))
 		el = sizeof(struct ar5416_eeprom_4k) / sizeof(u16);
 	else
 		el = el / sizeof(u16);
-- 
1.6.2

