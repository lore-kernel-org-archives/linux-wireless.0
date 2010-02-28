Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:55160 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968431Ab0B1OnG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 09:43:06 -0500
Message-ID: <4B8A80EE.6000102@free.fr>
Date: Sun, 28 Feb 2010 15:42:54 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Dan Williams <dcbw@redhat.com>, Jose Alonso <joalonsof@gmail.com>
Subject: [PATCH] airo : Print of firmware version
Content-Type: multipart/mixed;
 boundary="------------040300010604020708080406"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040300010604020708080406
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

For the firmware version 5.30.17 the log file shows:
Firmware version 5.30.11

The variable softSubVer is binary.


Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Signed-off-by: Jose Alonso <joalonsof@gmail.com>

--------------040300010604020708080406
Content-Type: text/x-diff;
 name="airo_firmware.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="airo_firmware.diff"

Index: airo.c
===================================================================
--- 1/drivers/net/wireless/airo.c	(révision 47)
+++ 2/drivers/net/wireless/airo.c	(révision 48)
@@ -2993,7 +2993,7 @@
 	ai->wep_capable = (cap_rid.softCap & cpu_to_le16(0x02)) ? 1 : 0;
 	ai->max_wep_idx = (cap_rid.softCap & cpu_to_le16(0x80)) ? 3 : 0;
 
-	airo_print_info(dev->name, "Firmware version %x.%x.%02x",
+	airo_print_info(dev->name, "Firmware version %x.%x.%02d",
 	                ((le16_to_cpu(cap_rid.softVer) >> 8) & 0xF),
 	                (le16_to_cpu(cap_rid.softVer) & 0xFF),
 	                le16_to_cpu(cap_rid.softSubVer));

--------------040300010604020708080406--
