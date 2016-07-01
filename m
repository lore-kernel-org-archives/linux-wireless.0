Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eng.riverbed.com ([208.70.196.45]:39057 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbcGAPXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 11:23:11 -0400
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@qca.qualcomm.com
From: Eduardo Abinader <eduardo.abinader@riverbed.com>
Subject: [PATCH V2] ath9k: consider return code on ar9300_eeprom_restore_flash
Message-ID: <57768ADC.6060103@riverbed.com> (sfid-20160701_172315_702812_A36C4073)
Date: Fri, 1 Jul 2016 17:23:08 +0200
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
index 5bd2cba..b7dc08e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3252,7 +3252,8 @@ static int ar9300_eeprom_restore_flash(struct ath_hw *ah, u8 *mptr,
 	int i;
 
 	for (i = 0; i < mdata_size / 2; i++, data++)
-		ath9k_hw_nvram_read(ah, i, data);
+		if (!ath9k_hw_nvram_read(ah, i, data))
+			return -1;
 
 	return 0;
 }
@@ -3282,7 +3283,8 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 	if (ath9k_hw_use_flash(ah)) {
 		u8 txrx;
 
-		ar9300_eeprom_restore_flash(ah, mptr, mdata_size);
+		if (ar9300_eeprom_restore_flash(ah, mptr, mdata_size))
+			return -1;
 
 		/* check if eeprom contains valid data */
 		eep = (struct ar9300_eeprom *) mptr;
-- 
2.5.0
