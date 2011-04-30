Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43423 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab1D3PSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 11:18:50 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so1390988ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 08:18:49 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/6] rt2x00: Streamline rt2800 eeprom initialisations.
Date: Sat, 30 Apr 2011 17:15:13 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104301713.47545.IvDoorn@gmail.com> <201104301714.24685.IvDoorn@gmail.com> <201104301714.49872.IvDoorn@gmail.com>
In-Reply-To: <201104301714.49872.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104301715.13753.IvDoorn@gmail.com> (sfid-20110430_171856_387063_A745C4AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

In rt2800lib.c the rt2800_init_eeprom function the same eeprom
words were read multiple times, due to inefficient ordering of the
eeprom checks.

Reorder the checks so that each EEPROM word only has to be read once.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d79c8fd..71c16c6 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3727,16 +3727,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
-	 * Read frequency offset and RF programming sequence.
+	 * Determine external LNA informations.
 	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &eeprom);
-	rt2x00dev->freq_offset = rt2x00_get_field16(eeprom, EEPROM_FREQ_OFFSET);
-
-	/*
-	 * Read external LNA informations.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
-
 	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_EXTERNAL_LNA_5G))
 		__set_bit(CAPABILITY_EXTERNAL_LNA_A, &rt2x00dev->cap_flags);
 	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_EXTERNAL_LNA_2G))
@@ -3749,6 +3741,12 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CAPABILITY_HW_BUTTON, &rt2x00dev->cap_flags);
 
 	/*
+	 * Read frequency offset and RF programming sequence.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &eeprom);
+	rt2x00dev->freq_offset = rt2x00_get_field16(eeprom, EEPROM_FREQ_OFFSET);
+
+	/*
 	 * Store led settings, for correct led behaviour.
 	 */
 #ifdef CONFIG_RT2X00_LIB_LEDS
@@ -3756,7 +3754,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2800_init_led(rt2x00dev, &rt2x00dev->led_assoc, LED_TYPE_ASSOC);
 	rt2800_init_led(rt2x00dev, &rt2x00dev->led_qual, LED_TYPE_QUALITY);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &rt2x00dev->led_mcu_reg);
+	rt2x00dev->led_mcu_reg = eeprom;
 #endif /* CONFIG_RT2X00_LIB_LEDS */
 
 	/*
-- 
1.7.2.3

