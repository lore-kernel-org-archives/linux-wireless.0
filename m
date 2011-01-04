Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40312 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1ADHr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 02:47:29 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so14032331iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jan 2011 23:47:29 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19746.53369.901444.615660@gargle.gargle.HOWL>
Date: Tue, 4 Jan 2011 13:17:05 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 3/5] ath9k_hw: Fix thermal issue with UB94
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Hardcode the output voltage of x-PA bias LDO to the lowest
value for UB94. The card doesn't get too hot now.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 088f141..749a936 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -226,6 +226,10 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 	    eep->baseEepHeader.pwdclkind == 0)
 		ah->need_an_top2_fixup = 1;
 
+	if ((common->bus_ops->ath_bus_type == ATH_USB) &&
+	    (AR_SREV_9280(ah)))
+		eep->modalHeader[0].xpaBiasLvl = 0;
+
 	return 0;
 }
 
-- 
1.7.3.4

