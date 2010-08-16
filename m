Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51171 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0HPXRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 19:17:02 -0400
Received: by bwz3 with SMTP id 3so3080410bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 16:17:01 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] p54: improve eeprom parser
Date: Tue, 17 Aug 2010 01:16:58 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201008170116.58759.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Like other vendors, p54* devices have a checksum for
the EEPROM descriptor data. This patch enhances the
parser code to generate and verify the data fields,
before initializing the radio-chip on the card.

Note:
	If you have to bootstrap an alternative EEPROM image
	for your device and you don't know how to generate a
	valid crc ccitt checksum, you should take a look at:
	http://git.kernel.org/?p=linux/kernel/git/chr/p54tools.git

	The "checksum" utility loads a binary p54 EEPROM blob
	(use the -f switch, to skip the check) and applies
	the correct crc automatically.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index b0342a5..60a930e 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -2,6 +2,7 @@ config P54_COMMON
 	tristate "Softmac Prism54 support"
 	depends on MAC80211 && EXPERIMENTAL
 	select FW_LOADER
+	select CRC_CCITT
 	---help---
 	  This is common code for isl38xx/stlc45xx based modules.
 	  This module does nothing by itself - the USB/PCI/SPI front-ends
diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index d687cb7..32d3f99 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 
 #include <net/mac80211.h>
+#include <linux/crc-ccitt.h>
 
 #include "p54.h"
 #include "eeprom.h"
@@ -540,6 +541,7 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 	int err;
 	u8 *end = (u8 *)eeprom + len;
 	u16 synth = 0;
+	u16 crc16 = ~0;
 
 	wrap = (struct eeprom_pda_wrap *) eeprom;
 	entry = (void *)wrap->data + le16_to_cpu(wrap->len);
@@ -655,16 +657,29 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 			}
 			break;
 		case PDR_END:
-			/* make it overrun */
-			entry_len = len;
+			crc16 = ~crc_ccitt(crc16, (u8 *) entry, sizeof(*entry));
+			if (crc16 != le16_to_cpup((__le16 *)entry->data)) {
+				wiphy_err(dev->wiphy, "eeprom failed checksum "
+					 "test!\n");
+				err = -ENOMSG;
+				goto err;
+			} else {
+				goto good_eeprom;
+			}
 			break;
 		default:
 			break;
 		}
 
-		entry = (void *)entry + (entry_len + 1)*2;
+		crc16 = crc_ccitt(crc16, (u8 *)entry, (entry_len + 1) * 2);
+		entry = (void *)entry + (entry_len + 1) * 2;
 	}
 
+	wiphy_err(dev->wiphy, "unexpected end of eeprom data.\n");
+	err = -ENODATA;
+	goto err;
+
+good_eeprom:
 	if (!synth || !priv->iq_autocal || !priv->output_limit ||
 	    !priv->curve_data) {
 		wiphy_err(dev->wiphy,
