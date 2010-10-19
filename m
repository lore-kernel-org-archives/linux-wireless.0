Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:55206 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab0JSIpz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 04:45:55 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Oct 2010 01:45:45 -0700
From: Bala Shanmugam <sbalashanmugam@atheros.com>
To: <lrodriguez@atheros.com>, <mcgrof@gmail.com>
CC: <linux-wireless@vger.kernel.org>,
	Bala Shanmugam <sbalashanmugam@atheros.com>
Subject: [PATCH] Do not compile staging directory for bt target. Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>
Date: Tue, 19 Oct 2010 14:15:38 +0530
Message-ID: <1287477938-7684-1-git-send-email-sbalashanmugam@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 Makefile |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index bca92ca..ec84197 100644
--- a/Makefile
+++ b/Makefile
@@ -31,17 +31,16 @@ obj-$(CONFIG_COMPAT_NET_USB_MODULES) += drivers/net/usb/
 
 obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/
 obj-$(CONFIG_COMPAT_VAR_MODULES) +=  drivers/ssb/ drivers/misc/eeprom/
-endif
-
-obj-$(CONFIG_COMPAT_BLUETOOTH) += net/bluetooth/
-obj-$(CONFIG_COMPAT_BLUETOOTH_MODULES) += drivers/bluetooth/
-
 
 ifeq ($(CONFIG_STAGING_EXCLUDE_BUILD),)
 obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/ath6kl/
 obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/brcm80211/
 endif
 
+endif
+
+obj-$(CONFIG_COMPAT_BLUETOOTH) += net/bluetooth/
+obj-$(CONFIG_COMPAT_BLUETOOTH_MODULES) += drivers/bluetooth/
 
 else
 
-- 
1.6.3.3

