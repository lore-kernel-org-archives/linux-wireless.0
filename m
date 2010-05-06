Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:63751 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab0EFLB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 07:01:27 -0400
Received: by ewy20 with SMTP id 20so1628914ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 04:01:26 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Add 5GHz support for RF3052 devices
Date: Thu, 6 May 2010 13:01:21 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005061301.22323.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the Ralink drivers, the RF3052 chipset
supports the 5GHz band. Update channel initialization
to add the corresponding channels for this chip.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e7a61a3..0d6f715 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2223,7 +2223,7 @@ EXPORT_SYMBOL_GPL(rt2800_init_eeprom);
 
 /*
  * RF value list for rt28x0
- * Supports: 2.4 GHz (all) & 5.2 GHz (RF2850 & RF2750)
+ * Supports: 2.4 GHz (all) & 5.2 GHz (RF2850, RF2750 & RF3052)
  */
 static const struct rf_channel rf_vals[] = {
 	{ 1,  0x18402ecc, 0x184c0786, 0x1816b455, 0x1800510b },
@@ -2355,11 +2355,12 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 
 	if (rt2x00_rf(rt2x00dev, RF2820) ||
-	    rt2x00_rf(rt2x00dev, RF2720) ||
-	    rt2x00_rf(rt2x00dev, RF3052)) {
+	    rt2x00_rf(rt2x00dev, RF2720)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals;
-	} else if (rt2x00_rf(rt2x00dev, RF2850) || rt2x00_rf(rt2x00dev, RF2750)) {
+	} else if (rt2x00_rf(rt2x00dev, RF2850) ||
+		   rt2x00_rf(rt2x00dev, RF2750) ||
+		   rt2x00_rf(rt2x00dev, RF3052)) {
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals);
 		spec->channels = rf_vals;
-- 
1.6.6.1

