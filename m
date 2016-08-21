Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33756 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753245AbcHUOt3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Aug 2016 10:49:29 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, arnd@arndb.de,
        chunkeey@googlemail.com, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 3/5] ath9k: Add an eeprom_ops callback for retrieving the eepmisc value
Date: Sun, 21 Aug 2016 16:49:04 +0200
Message-Id: <20160821144906.30984-4-martin.blumenstingl@googlemail.com> (sfid-20160821_164933_534523_123DC5FD)
In-Reply-To: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows deciding if we have to swap the EEPROM data (so it matches
the system's native endianness) even if no byte-swapping (swab16, based on
the first two bytes in the EEPROM) is needed.
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 8 +++++++-
 drivers/net/wireless/ath/ath9k/eeprom.h        | 1 +
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     | 8 +++++++-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   | 8 +++++++-
 drivers/net/wireless/ath/ath9k/eeprom_def.c    | 8 +++++++-
 5 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 6669e36..7d62d1c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5498,6 +5498,11 @@ unsigned int ar9003_get_paprd_scale_factor(struct ath_hw *ah,
 	}
 }
 
+static u8 ar9003_get_eepmisc(struct ath_hw *ah)
+{
+	return ah->eeprom.map4k.baseEepHeader.eepMisc;
+}
+
 const struct eeprom_ops eep_ar9300_ops = {
 	.check_eeprom = ath9k_hw_ar9300_check_eeprom,
 	.get_eeprom = ath9k_hw_ar9300_get_eeprom,
@@ -5508,5 +5513,6 @@ const struct eeprom_ops eep_ar9300_ops = {
 	.set_board_values = ath9k_hw_ar9300_set_board_values,
 	.set_addac = ath9k_hw_ar9300_set_addac,
 	.set_txpower = ath9k_hw_ar9300_set_txpower,
-	.get_spur_channel = ath9k_hw_ar9300_get_spur_channel
+	.get_spur_channel = ath9k_hw_ar9300_get_spur_channel,
+	.get_eepmisc = ar9003_get_eepmisc
 };
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index c466ada..408cfa7 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -655,6 +655,7 @@ struct eeprom_ops {
 			   u16 cfgCtl, u8 twiceAntennaReduction,
 			   u8 powerLimit, bool test);
 	u16 (*get_spur_channel)(struct ath_hw *ah, u16 i, bool is2GHz);
+	u8 (*get_eepmisc)(struct ath_hw *ah);
 };
 
 void ath9k_hw_analog_shift_regwrite(struct ath_hw *ah, u32 reg, u32 val);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 780cb49..7cd9c64 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -1064,6 +1064,11 @@ static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 	return ah->eeprom.map4k.modalHeader.spurChans[i].spurChan;
 }
 
+static u8 ath9k_hw_4k_get_eepmisc(struct ath_hw *ah)
+{
+	return ah->eeprom.map4k.baseEepHeader.eepMisc;
+}
+
 const struct eeprom_ops eep_4k_ops = {
 	.check_eeprom		= ath9k_hw_4k_check_eeprom,
 	.get_eeprom		= ath9k_hw_4k_get_eeprom,
@@ -1073,5 +1078,6 @@ const struct eeprom_ops eep_4k_ops = {
 	.get_eeprom_rev		= ath9k_hw_4k_get_eeprom_rev,
 	.set_board_values	= ath9k_hw_4k_set_board_values,
 	.set_txpower		= ath9k_hw_4k_set_txpower,
-	.get_spur_channel	= ath9k_hw_4k_get_spur_channel
+	.get_spur_channel	= ath9k_hw_4k_get_spur_channel,
+	.get_eepmisc		= ath9k_hw_4k_get_eepmisc
 };
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index f483ba2..e1ba9bc 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -986,6 +986,11 @@ static u16 ath9k_hw_ar9287_get_spur_channel(struct ath_hw *ah,
 	return ah->eeprom.map9287.modalHeader.spurChans[i].spurChan;
 }
 
+static u8 ath9k_hw_ar9287_get_eepmisc(struct ath_hw *ah)
+{
+	return ah->eeprom.map9287.baseEepHeader.eepMisc;
+}
+
 const struct eeprom_ops eep_ar9287_ops = {
 	.check_eeprom		= ath9k_hw_ar9287_check_eeprom,
 	.get_eeprom		= ath9k_hw_ar9287_get_eeprom,
@@ -995,5 +1000,6 @@ const struct eeprom_ops eep_ar9287_ops = {
 	.get_eeprom_rev		= ath9k_hw_ar9287_get_eeprom_rev,
 	.set_board_values	= ath9k_hw_ar9287_set_board_values,
 	.set_txpower		= ath9k_hw_ar9287_set_txpower,
-	.get_spur_channel	= ath9k_hw_ar9287_get_spur_channel
+	.get_spur_channel	= ath9k_hw_ar9287_get_spur_channel,
+	.get_eepmisc		= ath9k_hw_ar9287_get_eepmisc
 };
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 39b1b27..087bdb7 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1317,6 +1317,11 @@ static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 	return ah->eeprom.def.modalHeader[is2GHz].spurChans[i].spurChan;
 }
 
+static u8 ath9k_hw_def_get_eepmisc(struct ath_hw *ah)
+{
+	return ah->eeprom.def.baseEepHeader.eepMisc;
+}
+
 const struct eeprom_ops eep_def_ops = {
 	.check_eeprom		= ath9k_hw_def_check_eeprom,
 	.get_eeprom		= ath9k_hw_def_get_eeprom,
@@ -1327,5 +1332,6 @@ const struct eeprom_ops eep_def_ops = {
 	.set_board_values	= ath9k_hw_def_set_board_values,
 	.set_addac		= ath9k_hw_def_set_addac,
 	.set_txpower		= ath9k_hw_def_set_txpower,
-	.get_spur_channel	= ath9k_hw_def_get_spur_channel
+	.get_spur_channel	= ath9k_hw_def_get_spur_channel,
+	.get_eepmisc		= ath9k_hw_def_get_eepmisc
 };
-- 
2.9.3
