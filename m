Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60102 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1DWEsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Apr 2011 00:48:55 -0400
Received: by wwa36 with SMTP id 36so1117746wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2011 21:48:53 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 23 Apr 2011 12:48:53 +0800
Message-ID: <BANLkTik=wwcWSDOqgvpc+gr9sGCr27XbXQ@mail.gmail.com>
Subject: [PATCH] ath9k: fix AR9160 xpaBiasLvlFreq endianness handling
From: Adrian Chadd <adrian.chadd@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The xpaBiasLvlFreq parameter array is made up of 16 bit words which
aren't byte-swapped like the other 16-bit eeprom parameters are.
It's only used by the AR9160.

Signed-off-by: Adrian Chadd <adrian@freebsd.org>

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c
b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 995949d..c031854 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -231,6 +231,10 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
                               integer = swab32(pModal->antCtrlChain[i]);
                               pModal->antCtrlChain[i] = integer;
                       }
+                       for (i = 0; i < 3; i++) {
+                               word = swab16(pModal->xpaBiasLvlFreq[i]);
+                               pModal->xpaBiasLvlFreq[i] = word;
+                       }

                       for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
                               word = swab16(pModal->spurChans[i].spurChan);
