Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47504 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757675Ab0KQDTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 22:19:52 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/2] ath9k_hw: support reading calibration data from flash on AR9003
Date: Wed, 17 Nov 2010 04:19:47 +0100
Message-Id: <1289963987-28583-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289963987-28583-1-git-send-email-nbd@openwrt.org>
References: <1289963987-28583-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Embedded boards do not have compressed EEPROM data, they use the
struct ar9003_eeprom layout, with little endian fields, so copying
the raw data to the eeprom buffer is enough.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 230a122..9a7e151 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3271,6 +3271,18 @@ static bool ar9300_check_eeprom_header(struct ath_hw *ah, eeprom_read_op read,
 	return ar9300_check_header(header);
 }
 
+static int ar9300_eeprom_restore_flash(struct ath_hw *ah, u8 *mptr,
+				       int mdata_size)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u16 *data = (u16 *) mptr;
+	int i;
+
+	for (i = 0; i < mdata_size / 2; i++, data++)
+		ath9k_hw_nvram_read(common, i, data);
+
+	return 0;
+}
 /*
  * Read the configuration data from the eeprom.
  * The data can be put in any specified memory buffer.
@@ -3293,6 +3305,9 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 	eeprom_read_op read;
 
+	if (ath9k_hw_use_flash(ah))
+		return ar9300_eeprom_restore_flash(ah, mptr, mdata_size);
+
 	word = kzalloc(2048, GFP_KERNEL);
 	if (!word)
 		return -1;
-- 
1.7.3.2

