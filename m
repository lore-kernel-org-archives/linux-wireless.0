Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62471 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbZKHNjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:39:39 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so2371374ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:39:44 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Date: Sun, 08 Nov 2009 14:39:16 +0100
Message-Id: <20091108133916.23584.20632.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133854.23584.86842.sendpatchset@localhost.localdomain>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/9] rt2800usb: reorganize code in rt2800usb_probe_hw_mode()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: reorganize code in rt2800usb_probe_hw_mode()

Move hw_mode information initialization code block before
HT information initialization one to match the ordering used
by rt2800pci's rt2800pci_probe_hw_mode().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   42 ++++++++++++++++----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -795,6 +795,27 @@ static int rt2800usb_probe_hw_mode(struc
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
 
 	/*
+	 * Initialize hw_mode information.
+	 */
+	spec->supported_bands = SUPPORT_BAND_2GHZ;
+	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
+
+	if (rt2x00_rf(&rt2x00dev->chip, RF2820) ||
+	    rt2x00_rf(&rt2x00dev->chip, RF2720)) {
+		spec->num_channels = 14;
+		spec->channels = rf_vals;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF2850) ||
+		   rt2x00_rf(&rt2x00dev->chip, RF2750)) {
+		spec->supported_bands |= SUPPORT_BAND_5GHZ;
+		spec->num_channels = ARRAY_SIZE(rf_vals);
+		spec->channels = rf_vals;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF3020) ||
+		   rt2x00_rf(&rt2x00dev->chip, RF2020)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_3070);
+		spec->channels = rf_vals_3070;
+	}
+
+	/*
 	 * Initialize HT information.
 	 */
 	spec->ht.ht_supported = true;
@@ -826,27 +847,6 @@ static int rt2800usb_probe_hw_mode(struc
 	}
 
 	/*
-	 * Initialize hw_mode information.
-	 */
-	spec->supported_bands = SUPPORT_BAND_2GHZ;
-	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
-
-	if (rt2x00_rf(&rt2x00dev->chip, RF2820) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF2720)) {
-		spec->num_channels = 14;
-		spec->channels = rf_vals;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2850) ||
-		   rt2x00_rf(&rt2x00dev->chip, RF2750)) {
-		spec->supported_bands |= SUPPORT_BAND_5GHZ;
-		spec->num_channels = ARRAY_SIZE(rf_vals);
-		spec->channels = rf_vals;
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF3020) ||
-		   rt2x00_rf(&rt2x00dev->chip, RF2020)) {
-		spec->num_channels = ARRAY_SIZE(rf_vals_3070);
-		spec->channels = rf_vals_3070;
-	}
-
-	/*
 	 * Create channel information array
 	 */
 	info = kzalloc(spec->num_channels * sizeof(*info), GFP_KERNEL);
