Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38772 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab0F2TvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:08 -0400
Received: by ewy23 with SMTP id 23so2589ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:07 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/21] rt2x00: Align rt2800 EEPROM validation to Ralink vendor driver.
Date: Tue, 29 Jun 2010 21:44:50 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292143.45392.IvDoorn@gmail.com> <201006292144.19486.IvDoorn@gmail.com>
In-Reply-To: <201006292144.19486.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292144.51636.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Align with the latest versions of the Ralink legacy driver(s).

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 14ff706..f25997e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2185,6 +2185,8 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&word, EEPROM_NIC_WPS_PBC, 0);
 		rt2x00_set_field16(&word, EEPROM_NIC_BW40M_BG, 0);
 		rt2x00_set_field16(&word, EEPROM_NIC_BW40M_A, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_ANT_DIVERSITY, 0);
+		rt2x00_set_field16(&word, EEPROM_NIC_DAC_TEST, 0);
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC, word);
 		EEPROM(rt2x00dev, "NIC: 0x%04x\n", word);
 	}
@@ -2192,6 +2194,10 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &word);
 	if ((word & 0x00ff) == 0x00ff) {
 		rt2x00_set_field16(&word, EEPROM_FREQ_OFFSET, 0);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_FREQ, word);
+		EEPROM(rt2x00dev, "Freq: 0x%04x\n", word);
+	}
+	if ((word & 0xff00) == 0xff00) {
 		rt2x00_set_field16(&word, EEPROM_FREQ_LED_MODE,
 				   LED_MODE_TXRX_ACTIVITY);
 		rt2x00_set_field16(&word, EEPROM_FREQ_LED_POLARITY, 0);
@@ -2199,7 +2205,7 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED1, 0x5555);
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED2, 0x2221);
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED3, 0xa9f8);
-		EEPROM(rt2x00dev, "Freq: 0x%04x\n", word);
+		EEPROM(rt2x00dev, "Led Mode: 0x%04x\n", word);
 	}
 
 	/*
-- 
1.6.6.1

