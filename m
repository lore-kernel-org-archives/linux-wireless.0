Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45725 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1BLW2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 17:28:19 -0500
Received: by fxm20 with SMTP id 20so3925905fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Feb 2011 14:28:18 -0800 (PST)
Message-Id: <6c1cef43fb9d4979f9f7e0dcc71f61921730149b.1297548925.git.chunkeey@googlemail.com>
In-Reply-To: <50e288fa312fbeef461043181587959576545f8d.1297548925.git.chunkeey@googlemail.com>
References: <a1716888d72252e775f666c0caf6aa15cd0de33b.1297548925.git.chunkeey@googlemail.com>
	<22063045349cb651b39a410a66fcdfedf7eb3a0c.1297548925.git.chunkeey@googlemail.com>
	<50e288fa312fbeef461043181587959576545f8d.1297548925.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 12 Feb 2011 22:53:00 +0100
Subject: [PATCH 4/4] p54spi: update sample eeprom
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit: "p54: enhance rssi->dBm database import"
changed the way how the driver deals with the
rssical data. A new data format was necessary
and hence this patch.

NOTE: (for users with a custom eeprom binary)
I spent some time updating p54tools to support
the new format too: => (git available from)
http://git.kernel.org/?p=linux/kernel/git/chr/p54tools.git

It now comes with a simplistic script "n800_rssi2v2.sh"
which can be used to automate the conversion.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/p54spi_eeprom.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi_eeprom.h b/drivers/net/wireless/p54/p54spi_eeprom.h
index d592cbd..0b7bfb0 100644
--- a/drivers/net/wireless/p54/p54spi_eeprom.h
+++ b/drivers/net/wireless/p54/p54spi_eeprom.h
@@ -65,9 +65,10 @@ static unsigned char p54spi_eeprom[] = {
 0x03, 0x00, 0x00, 0x11,		/* PDR_ANTENNA_GAIN */
 	0x08, 0x08, 0x08, 0x08,
 
-0x09, 0x00, 0xad, 0xde,		/* PDR_RSSI_LINEAR_APPROXIMATION_CUSTOM */
-	0x0a, 0x01, 0x72, 0xfe, 0x1a, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+0x0a, 0x00, 0xff, 0xca,		/* PDR_RSSI_LINEAR_APPROXIMATION_CUSTOMV2 */
+	0x01, 0x00, 0x0a, 0x00,
+	0x00, 0x00, 0x0a, 0x00,
+		0x85, 0x09, 0x0a, 0x01, 0x72, 0xfe, 0x1a, 0x00, 0x00, 0x00,
 
 /* struct pda_custom_wrapper */
 0x10, 0x06, 0x5d, 0xb0,		/* PDR_PRISM_PA_CAL_CURVE_DATA_CUSTOM */
@@ -671,7 +672,7 @@ static unsigned char p54spi_eeprom[] = {
 	0xa8, 0x09, 0x25, 0x00, 0xf5, 0xff, 0xf9, 0xff, 0x00, 0x01,
 
 0x02, 0x00, 0x00, 0x00,		/* PDR_END */
-	0x67, 0x99,
+	0xb6, 0x04,
 };
 
 #endif /* P54SPI_EEPROM_H */
-- 
1.7.2.3

