Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40174 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab2GORxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 13:53:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 01/12] ath9k_hw: fall back to OTP ROM when platform data has no valid eeprom data
Date: Sun, 15 Jul 2012 19:53:29 +0200
Message-Id: <1342374820-92409-1-git-send-email-nbd@openwrt.org> (sfid-20120715_195354_740265_6886733D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 25de6f9..3cddd78 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3260,10 +3260,20 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 	int it;
 	u16 checksum, mchecksum;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ar9300_eeprom *eep;
 	eeprom_read_op read;
 
-	if (ath9k_hw_use_flash(ah))
-		return ar9300_eeprom_restore_flash(ah, mptr, mdata_size);
+	if (ath9k_hw_use_flash(ah)) {
+		u8 txrx;
+
+		ar9300_eeprom_restore_flash(ah, mptr, mdata_size);
+
+		/* check if eeprom contains valid data */
+		eep = (struct ar9300_eeprom *) mptr;
+		txrx = eep->baseEepHeader.txrxMask;
+		if (txrx != 0 && txrx != 0xff)
+			return 0;
+	}
 
 	word = kzalloc(2048, GFP_KERNEL);
 	if (!word)
-- 
1.7.7.5 (Apple Git-26)

