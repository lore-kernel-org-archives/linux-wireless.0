Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57913 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0GKKbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:31:39 -0400
Received: by ewy23 with SMTP id 23so640186ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:31:37 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/17] rt2x00: Limit txpower by eeprom values
Date: Sun, 11 Jul 2010 12:23:09 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
MIME-Version: 1.0
Message-Id: <201007111223.11190.IvDoorn@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Limit the txpower per rate by the approriate values in the eeprom.
This avoids too high txpower values resulting in bad tx performance.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   20 ++++-
 drivers/net/wireless/rt2x00/rt2800lib.c |  153 ++++++++++++++++++++-----------
 2 files changed, 120 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 3ed87ba..3cda229 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -803,6 +803,18 @@
 #define EDCA_TID_AC_MAP			0x1310
 
 /*
+ * TX_PWR_CFG:
+ */
+#define TX_PWR_CFG_RATE0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_RATE1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_RATE2		FIELD32(0x00000f00)
+#define TX_PWR_CFG_RATE3		FIELD32(0x0000f000)
+#define TX_PWR_CFG_RATE4		FIELD32(0x000f0000)
+#define TX_PWR_CFG_RATE5		FIELD32(0x00f00000)
+#define TX_PWR_CFG_RATE6		FIELD32(0x0f000000)
+#define TX_PWR_CFG_RATE7		FIELD32(0xf0000000)
+
+/*
  * TX_PWR_CFG_0:
  */
 #define TX_PWR_CFG_0			0x1314
@@ -1853,9 +1865,15 @@ struct mac_iveiv_entry {
 #define EEPROM_TXPOWER_A_2		FIELD16(0xff00)
 
 /*
- * EEPROM TXpower byrate: 20MHZ power
+ * EEPROM TXPOWER by rate: tx power per tx rate for HT20 mode
  */
 #define EEPROM_TXPOWER_BYRATE		0x006f
+#define EEPROM_TXPOWER_BYRATE_SIZE	9
+
+#define EEPROM_TXPOWER_BYRATE_RATE0	FIELD16(0x000f)
+#define EEPROM_TXPOWER_BYRATE_RATE1	FIELD16(0x00f0)
+#define EEPROM_TXPOWER_BYRATE_RATE2	FIELD16(0x0f00)
+#define EEPROM_TXPOWER_BYRATE_RATE3	FIELD16(0xf000)
 
 /*
  * EEPROM BBP.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d3cf0cc..9030eef 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1086,66 +1086,115 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
-				  const int txpower)
+				  const int max_txpower)
 {
+	u8 txpower;
+	u8 max_value = (u8)max_txpower;
+	u16 eeprom;
+	int i;
 	u32 reg;
-	u32 value = TXPOWER_G_TO_DEV(txpower);
 	u8 r1;
+	u32 offset;
 
+	/*
+	 * set to normal tx power mode: +/- 0dBm
+	 */
 	rt2800_bbp_read(rt2x00dev, 1, &r1);
 	rt2x00_set_field8(&r1, BBP1_TX_POWER, 0);
 	rt2800_bbp_write(rt2x00dev, 1, r1);
 
-	rt2800_register_read(rt2x00dev, TX_PWR_CFG_0, &reg);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_0_1MBS, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_0_2MBS, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_0_55MBS, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_0_11MBS, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_0_6MBS, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_0_9MBS, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_0_12MBS, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_0_18MBS, value);
-	rt2800_register_write(rt2x00dev, TX_PWR_CFG_0, reg);
-
-	rt2800_register_read(rt2x00dev, TX_PWR_CFG_1, &reg);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_1_24MBS, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_1_36MBS, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_1_48MBS, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_1_54MBS, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_1_MCS0, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_1_MCS1, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_1_MCS2, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_1_MCS3, value);
-	rt2800_register_write(rt2x00dev, TX_PWR_CFG_1, reg);
-
-	rt2800_register_read(rt2x00dev, TX_PWR_CFG_2, &reg);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS4, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS5, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS6, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS7, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS8, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS9, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS10, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS11, value);
-	rt2800_register_write(rt2x00dev, TX_PWR_CFG_2, reg);
-
-	rt2800_register_read(rt2x00dev, TX_PWR_CFG_3, &reg);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS12, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS13, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS14, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS15, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN1, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN2, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN3, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN4, value);
-	rt2800_register_write(rt2x00dev, TX_PWR_CFG_3, reg);
-
-	rt2800_register_read(rt2x00dev, TX_PWR_CFG_4, &reg);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN5, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN6, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN7, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN8, value);
-	rt2800_register_write(rt2x00dev, TX_PWR_CFG_4, reg);
+	/*
+	 * The eeprom contains the tx power values for each rate. These
+	 * values map to 100% tx power. Each 16bit word contains four tx
+	 * power values and the order is the same as used in the TX_PWR_CFG
+	 * registers.
+	 */
+	offset = TX_PWR_CFG_0;
+
+	for (i = 0; i < EEPROM_TXPOWER_BYRATE_SIZE; i += 2) {
+		/* just to be safe */
+		if (offset > TX_PWR_CFG_4)
+			break;
+
+		rt2800_register_read(rt2x00dev, offset, &reg);
+
+		/* read the next four txpower values */
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + i,
+				   &eeprom);
+
+		/* TX_PWR_CFG_0: 1MBS, TX_PWR_CFG_1: 24MBS,
+		 * TX_PWR_CFG_2: MCS4, TX_PWR_CFG_3: MCS12,
+		 * TX_PWR_CFG_4: unknown */
+		txpower = rt2x00_get_field16(eeprom,
+					     EEPROM_TXPOWER_BYRATE_RATE0);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE0,
+				   min(txpower, max_value));
+
+		/* TX_PWR_CFG_0: 2MBS, TX_PWR_CFG_1: 36MBS,
+		 * TX_PWR_CFG_2: MCS5, TX_PWR_CFG_3: MCS13,
+		 * TX_PWR_CFG_4: unknown */
+		txpower = rt2x00_get_field16(eeprom,
+					     EEPROM_TXPOWER_BYRATE_RATE1);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE1,
+				   min(txpower, max_value));
+
+		/* TX_PWR_CFG_0: 55MBS, TX_PWR_CFG_1: 48MBS,
+		 * TX_PWR_CFG_2: MCS6,  TX_PWR_CFG_3: MCS14,
+		 * TX_PWR_CFG_4: unknown */
+		txpower = rt2x00_get_field16(eeprom,
+					     EEPROM_TXPOWER_BYRATE_RATE2);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE2,
+				   min(txpower, max_value));
+
+		/* TX_PWR_CFG_0: 11MBS, TX_PWR_CFG_1: 54MBS,
+		 * TX_PWR_CFG_2: MCS7,  TX_PWR_CFG_3: MCS15,
+		 * TX_PWR_CFG_4: unknown */
+		txpower = rt2x00_get_field16(eeprom,
+					     EEPROM_TXPOWER_BYRATE_RATE3);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE3,
+				   min(txpower, max_value));
+
+		/* read the next four txpower values */
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + i + 1,
+				   &eeprom);
+
+		/* TX_PWR_CFG_0: 6MBS, TX_PWR_CFG_1: MCS0,
+		 * TX_PWR_CFG_2: MCS8, TX_PWR_CFG_3: unknown,
+		 * TX_PWR_CFG_4: unknown */
+		txpower = rt2x00_get_field16(eeprom,
+					     EEPROM_TXPOWER_BYRATE_RATE0);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE4,
+				   min(txpower, max_value));
+
+		/* TX_PWR_CFG_0: 9MBS, TX_PWR_CFG_1: MCS1,
+		 * TX_PWR_CFG_2: MCS9, TX_PWR_CFG_3: unknown,
+		 * TX_PWR_CFG_4: unknown */
+		txpower = rt2x00_get_field16(eeprom,
+					     EEPROM_TXPOWER_BYRATE_RATE1);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE5,
+				   min(txpower, max_value));
+
+		/* TX_PWR_CFG_0: 12MBS, TX_PWR_CFG_1: MCS2,
+		 * TX_PWR_CFG_2: MCS10, TX_PWR_CFG_3: unknown,
+		 * TX_PWR_CFG_4: unknown */
+		txpower = rt2x00_get_field16(eeprom,
+					     EEPROM_TXPOWER_BYRATE_RATE2);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE6,
+				   min(txpower, max_value));
+
+		/* TX_PWR_CFG_0: 18MBS, TX_PWR_CFG_1: MCS3,
+		 * TX_PWR_CFG_2: MCS11, TX_PWR_CFG_3: unknown,
+		 * TX_PWR_CFG_4: unknown */
+		txpower = rt2x00_get_field16(eeprom,
+					     EEPROM_TXPOWER_BYRATE_RATE3);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE7,
+				   min(txpower, max_value));
+
+		rt2800_register_write(rt2x00dev, offset, reg);
+
+		/* next TX_PWR_CFG register */
+		offset += 4;
+	}
 }
 
 static void rt2800_config_retry_limit(struct rt2x00_dev *rt2x00dev,
-- 
1.7.1.1

