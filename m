Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56624 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000AbZE1Bsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 21:48:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: jal2@gmx.de, Peter.Grabienski@Atheros.com,
	Stephen.Chen@Atheros.com, Michael.Fortin@Atheros.com,
	Johnny.Cheng@Atheros.com, Yuan-Gu.Wei@atheros.com,
	otus-devel@lists.madwifi-project.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 1/2] ar9170: add initial support for 1-stage firmware
Date: Wed, 27 May 2009 21:48:45 -0400
Message-Id: <1243475326-28867-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1243475326-28867-1-git-send-email-lrodriguez@atheros.com>
References: <1243475326-28867-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You can get the stage 1 firmware from here:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ar9170/ar9170.fw

Its license:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ar9170/LICENSE

It seems with some devices this works, with some others
I see only scan working. We shall not push this firmware
into the linux-firmware tree until these issues have been
resolved.

Cc: Peter Grabienski <Peter.Grabienski@Atheros.com>
Cc: Stephen Chen <Stephen.Chen@Atheros.com>
Cc: Michael Fortin <Michael.Fortin@Atheros.com>
Cc: Johnny Cheng <Johnny.Cheng@Atheros.com>
Cc: Yuan-Gu Wei <Yuan-Gu.Wei@atheros.com>
Cc: Joerg Albert <jal2@gmx.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ar9170/phy.c |   13 ++++++++++---
 drivers/net/wireless/ath/ar9170/usb.c |   22 +++++++++++++++++-----
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
index 6ce2075..0675dc8 100644
--- a/drivers/net/wireless/ath/ar9170/phy.c
+++ b/drivers/net/wireless/ath/ar9170/phy.c
@@ -39,6 +39,7 @@
 #include <linux/bitrev.h>
 #include "ar9170.h"
 #include "cmd.h"
+#include "usb.h"
 
 static int ar9170_init_power_cal(struct ar9170 *ar)
 {
@@ -996,6 +997,10 @@ static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 	int idx, i, n;
 	u8 ackpower, ackchains, f;
 	u8 pwr_freqs[AR5416_MAX_NUM_TGT_PWRS];
+	struct ar9170_usb *aru;
+
+	/* All ar9170 devices are USB */
+	aru = container_of(ar, struct ar9170_usb, common);
 
 	if (freq < 3000)
 		f = freq - 2300;
@@ -1102,9 +1107,11 @@ static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 	else
 		ackpower = ar->power_5G_leg[0] & 0x3f;
 
-	ar9170_regwrite(0x1c3694, ackpower << 20 | ackchains << 26);
-	ar9170_regwrite(0x1c3bb4, ackpower << 5 | ackchains << 11 |
-				  ackpower << 21 | ackchains << 27);
+	if (aru->init_values)  {
+		ar9170_regwrite(0x1c3694, ackpower << 20 | ackchains << 26);
+		ar9170_regwrite(0x1c3bb4, ackpower << 5 | ackchains << 11 |
+					  ackpower << 21 | ackchains << 27);
+	}
 
 	ar9170_regwrite_finish();
 	return ar9170_regwrite_result();
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index d7c13c0..3c97c09 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -51,6 +51,7 @@ MODULE_AUTHOR("Johannes Berg <johannes@sipsolutions.net>");
 MODULE_AUTHOR("Christian Lamparter <chunkeey@web.de>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Atheros AR9170 802.11n USB wireless");
+MODULE_FIRMWARE("ar9170.fw");
 MODULE_FIRMWARE("ar9170-1.fw");
 MODULE_FIRMWARE("ar9170-2.fw");
 
@@ -504,17 +505,23 @@ static int ar9170_usb_request_firmware(struct ar9170_usb *aru)
 {
 	int err = 0;
 
-	err = request_firmware(&aru->init_values, "ar9170-1.fw",
+	err = request_firmware(&aru->firmware, "ar9170.fw",
 			       &aru->udev->dev);
-	if (err) {
-		dev_err(&aru->udev->dev, "file with init values not found.\n");
-		return err;
+	if (!err) {
+		aru->init_values = NULL;
+		return 0;
 	}
 
+	dev_err(&aru->udev->dev, "ar9170.fw firmware file "
+		"not found, trying old firmware...\n");
+
+	err = request_firmware(&aru->init_values, "ar9170-1.fw",
+			       &aru->udev->dev);
+
 	err = request_firmware(&aru->firmware, "ar9170-2.fw", &aru->udev->dev);
 	if (err) {
 		release_firmware(aru->init_values);
-		dev_err(&aru->udev->dev, "firmware file not found.\n");
+		dev_err(&aru->udev->dev, "file with init values not found.\n");
 		return err;
 	}
 
@@ -548,6 +555,9 @@ static int ar9170_usb_upload_firmware(struct ar9170_usb *aru)
 {
 	int err;
 
+	if (!aru->init_values)
+		goto upload_fw_start;
+
 	/* First, upload initial values to device RAM */
 	err = ar9170_usb_upload(aru, aru->init_values->data,
 				aru->init_values->size, 0x102800, false);
@@ -557,6 +567,8 @@ static int ar9170_usb_upload_firmware(struct ar9170_usb *aru)
 		return err;
 	}
 
+upload_fw_start:
+
 	/* Then, upload the firmware itself and start it */
 	return ar9170_usb_upload(aru, aru->firmware->data, aru->firmware->size,
 				0x200000, true);
-- 
1.6.0.6

