Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40879 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0FFFc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 01:32:26 -0400
Received: by vws5 with SMTP id 5so1770477vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jun 2010 22:32:25 -0700 (PDT)
Message-ID: <4C0B32E8.4080208@gmail.com>
Date: Sun, 06 Jun 2010 01:32:24 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [Patch] Enable rt2800usb in compat-wireless stable branch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables the new RT307x and RT357x chips in compat-wireless 
stable.  I'd like to enable the same for rt2800pci as well but right now 
it doesn't seem to build so I'll wait till it does to submit the diff.

Thanks,
Rick Farina

Don't see why this is needed to patch config.mk but:
Signed-off-by: Rick Farina


Enable rt3[05]7x support in compat-wireless stable branch.
diff -Naur compat-wireless-2.6.35-rc1/config.mk 
compat-wireless-2.6.35-rc1-fixed/config.mk
--- compat-wireless-2.6.35-rc1/config.mk        2010-05-31 
18:30:39.000000000 -0400
+++ compat-wireless-2.6.35-rc1-fixed/config.mk  2010-06-05 
23:48:50.000000000 -0400
@@ -366,9 +366,9 @@
 CONFIG_RT2500USB=m
 ifneq ($(CONFIG_CRC_CCITT),)
 CONFIG_RT2800USB=m
-# CONFIG_RT2800USB_RT30XX=y
-# CONFIG_RT2800USB_RT35XX=y
-# CONFIG_RT2800USB_UNKNOWN=y
+CONFIG_RT2800USB_RT30XX=y
+CONFIG_RT2800USB_RT35XX=y
+CONFIG_RT2800USB_UNKNOWN=y
 endif
 CONFIG_RT2X00_LIB_USB=m
 NEED_RT2X00=y

