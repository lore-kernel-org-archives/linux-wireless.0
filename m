Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47795 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbZEBFDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 01:03:13 -0400
Date: Sat, 2 May 2009 01:03:08 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, chunkeey@web.de, juhosg@openwrt.org,
	Stephen.Chen@atheros.com
Cc: linux-wireless@vger.kernel.org,
	otus-devel@lists.madwifi-project.org
Subject: [RFTW] ar9170: Use new 1-stage ar9170.fw firmware
Message-ID: <20090502050308.GA24954@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for one stage ar9170 firmware (only one file!).
We don't need the two-stages now that we have proper
reguluatory control in ar9170 through the ath module.

This needs a little more love and testing..

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

(RFTW: Request for Testing and for this Work to be picked up by someone
 interested)

I was unable to finish getting this working and need to move on
to other things so here's what I have so far. You can find what
else you need to do by reviewing the Otus code (in staging/otus/
and ensure that the code #ifdef'd around ZM_OTUS_LINUX_PHASE_2
is _not_ used. ar9170 and otus are very different (which is good)
but unfortunately for this exercise this means its very difficult
to find the exact calls #ifdef'd on the ar9170 port. I may have
missed one or two more.

You can get the stage 1 firmware from here:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ar9170/ar9170.fw

Its license:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ar9170/LICENSE

With this I'm able to scan in both 2.4 GHz and 5 Ghz but I was unable to
get a connection. Hoping someone interested might be able to pick this up.

I stripped some debugging printks I had here but I think this should compile.

 drivers/net/wireless/ath/ar9170/phy.c |    9 ++++++---
 drivers/net/wireless/ath/ar9170/usb.c |   23 ++++++++++++++++++-----
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
index 6ce2075..9086173 100644
--- a/drivers/net/wireless/ath/ar9170/phy.c
+++ b/drivers/net/wireless/ath/ar9170/phy.c
@@ -1102,9 +1102,12 @@ static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 	else
 		ackpower = ar->power_5G_leg[0] & 0x3f;
 
-	ar9170_regwrite(0x1c3694, ackpower << 20 | ackchains << 26);
-	ar9170_regwrite(0x1c3bb4, ackpower << 5 | ackchains << 11 |
-				  ackpower << 21 | ackchains << 27);
+	if (0) { /* XXX: FIXME */
+	//if (aru->init_values) /* Use container_of() {
+		ar9170_regwrite(0x1c3694, ackpower << 20 | ackchains << 26);
+		ar9170_regwrite(0x1c3bb4, ackpower << 5 | ackchains << 11 |
+					  ackpower << 21 | ackchains << 27);
+	}
 
 	ar9170_regwrite_finish();
 	return ar9170_regwrite_result();
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index d7b562d..e1e00bf 100644
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
@@ -640,6 +652,7 @@ static int ar9170_usb_init_device(struct ar9170_usb *aru)
 		err = ar9170_echo_test(&aru->common, 0x60d43110);
 		if (err) {
 			/* force user invention, by disabling the device */
+			ar9170_usb_stop(ar);
 			err = usb_driver_set_configuration(aru->udev, -1);
 			dev_err(&aru->udev->dev, "device is in a bad state. "
 						 "please reconnect it!\n");
-- 
1.6.0.6

