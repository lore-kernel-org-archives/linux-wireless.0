Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48919 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1AZQac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 11:30:32 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so1035708iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 08:30:31 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19776.19422.571177.795197@gargle.gargle.HOWL>
Date: Wed, 26 Jan 2011 21:59:18 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH] ath9k_hw: Fix INI fixup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Commit "ath9k_hw: move AR9280 PCI EEPROM fix to eeprom_def.c"
changed the behavior of INI overriding which is needed only
for PCI cards. Revert to the original check.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index c9318ff..fccd87d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -247,9 +247,9 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 	}
 
 	/* Enable fixup for AR_AN_TOP2 if necessary */
-	if (AR_SREV_9280_20_OR_LATER(ah) &&
-	    (eep->baseEepHeader.version & 0xff) > 0x0a &&
-	    eep->baseEepHeader.pwdclkind == 0)
+	if ((ah->hw_version.devid == AR9280_DEVID_PCI) &&
+	    ((eep->baseEepHeader.version & 0xff) > 0x0a) &&
+	    (eep->baseEepHeader.pwdclkind == 0))
 		ah->need_an_top2_fixup = 1;
 
 	if ((common->bus_ops->ath_bus_type == ATH_USB) &&
-- 
1.7.3.5

