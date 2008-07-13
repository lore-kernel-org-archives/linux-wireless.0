Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:61438 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYGMH4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2008 03:56:42 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1356114nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2008 00:56:40 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Reset LED assoc status after firmware update
Date: Sun, 13 Jul 2008 10:07:48 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807131007.48763.IvDoorn@gmail.com> (sfid-20080713_095654_042833_B9C167EA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the legacy drivers the LED association status
must be reset after the firmware has been uploaded to the
hardware.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00firmware.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
index b971bc6..bab05a5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
+++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
@@ -100,6 +100,14 @@ int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev)
 	retval = rt2x00dev->ops->lib->load_firmware(rt2x00dev,
 						    rt2x00dev->fw->data,
 						    rt2x00dev->fw->size);
+
+	/*
+	 * When the firmware is uploaded to the hardware the LED
+	 * association status might have been triggered, for correct
+	 * LED handling it should now be reset.
+	 */
+	rt2x00leds_led_assoc(rt2x00dev, false);
+
 	return retval;
 }
 
-- 
1.5.6.1

