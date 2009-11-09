Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:51331 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844AbZKIWic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 17:38:32 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 10/10] rt2x00: Fix building of rt2800lib when rt2x00 driver is built-in.
Date: Mon,  9 Nov 2009 23:38:35 +0100
Message-Id: <1257806315-11089-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When enabling rt2800usb as a built-in driver (as opposed to a as a module) the build fails. See
http://marc.info/?l=linux-wireless&m=125768687711034&w=2 for details.

Fix it by properly including <linux/usb.h> from rt2x00usb.h

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---

John, this is one to merge upstream quickly --> we currently have build failures in next.

---
---
 drivers/net/wireless/rt2x00/rt2x00usb.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index d63e1df..3da6841 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -26,6 +26,8 @@
 #ifndef RT2X00USB_H
 #define RT2X00USB_H
 
+#include <linux/usb.h>
+
 #define to_usb_device_intf(d) \
 ({ \
 	struct usb_interface *intf = to_usb_interface(d); \
-- 
1.6.5.2

