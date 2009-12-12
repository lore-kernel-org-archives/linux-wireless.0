Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:57805 "HELO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933081AbZLMBTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 20:19:31 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2.6.33] rt2x00: Fix rt2800usb detection in rt2800lib.
Date: Sun, 13 Dec 2009 00:39:39 +0100
Message-Id: <1260661180-2300-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800lib incorrectly detected whether RT2800USB was enabled because
it didn't account for a modularized RT2800USB driver.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---

John, this one is a fix for 2.6.33.

---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index eb1e1d0..bdc3286 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -33,6 +33,10 @@
 	Abstract: rt2800 generic device routines.
  */
 
+#ifdef CONFIG_RT2800USB_MODULE
+#define CONFIG_RT2800USB
+#endif
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-- 
1.6.5.5

