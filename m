Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbZE1VgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 17:36:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, chunkeey@web.de
Cc: linux-wireless@vger.kernel.org, jal2@gmx.de,
	Peter.Grabienski@Atheros.com, Stephen.Chen@Atheros.com,
	Michael.Fortin@Atheros.com, Johnny.Cheng@Atheros.com,
	Yuan-Gu.Wei@atheros.com, otus-devel@lists.madwifi-project.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] ar9170: add support for 1-stage firmware
Date: Thu, 28 May 2009 17:36:04 -0400
Message-Id: <1243546565-19404-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1243546565-19404-1-git-send-email-lrodriguez@atheros.com>
References: <1243546565-19404-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You can get the stage 1 firmware from here:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ar9170/ar9170.fw

md5sum: 34feec4ec0eae3bb92c7c1ea2dfb4530
sha1sum: 6e5250498b815c2940d97242de31e054ae44e079

Its license:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ar9170/LICENSE

This is a new firmware, tested with WNDA3100.

Cc: Peter Grabienski <Peter.Grabienski@Atheros.com>
Cc: Stephen Chen <Stephen.Chen@Atheros.com>
Cc: Michael Fortin <Michael.Fortin@Atheros.com>
Cc: Johnny Cheng <Johnny.Cheng@Atheros.com>
Cc: Yuan-Gu Wei <Yuan-Gu.Wei@atheros.com>
Cc: Joerg Albert <jal2@gmx.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ar9170/usb.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

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

