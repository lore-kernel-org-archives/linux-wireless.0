Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62452 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab1D3PSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 11:18:52 -0400
Received: by ewy4 with SMTP id 4so1391005ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 08:18:51 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/6] rt2x00: Introduce capability flag for Bluetooth co-existence.
Date: Sat, 30 Apr 2011 17:15:37 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104301713.47545.IvDoorn@gmail.com> <201104301714.49872.IvDoorn@gmail.com> <201104301715.13753.IvDoorn@gmail.com>
In-Reply-To: <201104301715.13753.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104301715.38080.IvDoorn@gmail.com> (sfid-20110430_171858_601432_71A24B22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Use flag instead of re-reading the eeprom every time.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   13 ++++++++-----
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 71c16c6..6ed646a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1640,7 +1640,6 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 					 struct channel_info *info)
 {
 	u8 rfcsr;
-	u16 eeprom;
 
 	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
 	rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
@@ -1670,11 +1669,10 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
 	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
 	if (rf->channel <= 14) {
 		int idx = rf->channel-1;
 
-		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_BT_COEXIST)) {
+		if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags)) {
 			if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
 				/* r55/r59 value array of channel 1~14 */
 				static const char r55_bt_rev[] = {0x83, 0x83,
@@ -2917,8 +2915,7 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		ant = (div_mode == 3) ? 1 : 0;
 
 		/* check if this is a Bluetooth combo card */
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
-		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_BT_COEXIST)) {
+		if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags)) {
 			u32 reg;
 
 			rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
@@ -3741,6 +3738,12 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CAPABILITY_HW_BUTTON, &rt2x00dev->cap_flags);
 
 	/*
+	 * Detect if this device has Bluetooth co-existence.
+	 */
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_BT_COEXIST))
+		__set_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags);
+
+	/*
 	 * Read frequency offset and RF programming sequence.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &eeprom);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index acf561f..86e1410 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -697,6 +697,7 @@ enum rt2x00_capability_flags {
 	CAPABILITY_EXTERNAL_LNA_A,
 	CAPABILITY_EXTERNAL_LNA_BG,
 	CAPABILITY_DOUBLE_ANTENNA,
+	CAPABILITY_BT_COEXIST,
 };
 
 /*
-- 
1.7.2.3

