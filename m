Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from incomingmail.riverbed.com ([208.70.196.45]:23761 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbcG0NTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 09:19:13 -0400
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: kvalo@qca.qualcomm.com
From: Eduardo Abinader <eduardo.abinader@riverbed.com>
Subject: [PATCH 1/1 V3] ath9k: consider return code on
Message-ID: <490b6e07-d357-7985-8796-80125322e82e@riverbed.com> (sfid-20160727_151915_907811_052E2BA0)
Date: Wed, 27 Jul 2016 15:19:09 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

just to comply with current ath9k_hw_nvram_read to return value, hence
behaving reacting accordingly.

Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 5bd2cba..08607d7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3252,7 +3252,8 @@ static int ar9300_eeprom_restore_flash(struct ath_hw *ah, u8 *mptr,
 	int i;
 
 	for (i = 0; i < mdata_size / 2; i++, data++)
-		ath9k_hw_nvram_read(ah, i, data);
+		if (!ath9k_hw_nvram_read(ah, i, data))
+			return -EIO;
 
 	return 0;
 }
@@ -3282,7 +3283,8 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 	if (ath9k_hw_use_flash(ah)) {
 		u8 txrx;
 
-		ar9300_eeprom_restore_flash(ah, mptr, mdata_size);
+		if (ar9300_eeprom_restore_flash(ah, mptr, mdata_size))
+			return -EIO;
 
 		/* check if eeprom contains valid data */
 		eep = (struct ar9300_eeprom *) mptr;
-- 
2.5.0
