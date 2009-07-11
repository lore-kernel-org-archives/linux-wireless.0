Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:39884 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbZGKQTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2009 12:19:41 -0400
Received: by ewy26 with SMTP id 26so1736680ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2009 09:19:39 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Remove DEVICE_STATE_DISABLED_RADIO_HW
Date: Sat, 11 Jul 2009 18:00:19 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907111800.19613.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DEVICE_STATE_DISABLED_RADIO_HW flag is only read but never set,
it is an ancient part of one of the many versions of the rfkill implementations
in rt2x00. It is about time is disappears.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index de3f13a..a111b04 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -600,7 +600,6 @@ enum rt2x00_flags {
 	DEVICE_STATE_INITIALIZED,
 	DEVICE_STATE_STARTED,
 	DEVICE_STATE_ENABLED_RADIO,
-	DEVICE_STATE_DISABLED_RADIO_HW,
 
 	/*
 	 * Driver requirements
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 4fff3a8..658a63b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -40,8 +40,7 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Don't enable the radio twice.
 	 * And check if the hardware button has been disabled.
 	 */
-	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags) ||
-	    test_bit(DEVICE_STATE_DISABLED_RADIO_HW, &rt2x00dev->flags))
+	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return 0;
 
 	/*
