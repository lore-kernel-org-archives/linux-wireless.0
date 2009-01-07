Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:58930 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZAGNvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 08:51:45 -0500
Received: by ewy10 with SMTP id 10so9020432ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 05:51:43 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Only register rfkill input when key is present
Date: Wed, 7 Jan 2009 14:51:41 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901071451.41529.IvDoorn@gmail.com> (sfid-20090107_145149_987237_B930E6A6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00 should only register the RFKILL input device when the hardware indicated
the key was present.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 5024e3d..0b089ec 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -87,7 +87,8 @@ void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 {
 	struct input_polled_dev *poll_dev;
 
-	if (test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
+	if (test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state) ||
+	    !test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
 		return;
 
 	poll_dev = input_allocate_polled_device();
