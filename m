Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:40620 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab1HPRgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 13:36:16 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 16 Aug 2011 19:36:01 +0200
Subject: [PATCH 2/4] NFC: Move nfc.h from include/net to include/net/nfc
Message-ID: <AC090B9732AB2B4DB7FF476E907FE6600131E1C33A@dnce02.ent.ti.com> (sfid-20110816_193618_581565_BD38E1B6)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The nfc.h file was moved from include/net to include/net/nfc, since 2 new header files were added to the new include/net/nfc folder.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 drivers/nfc/pn533.c         |    2 +-
 include/net/{ => nfc}/nfc.h |    0
 net/nfc/nfc.h               |    2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename include/net/{ => nfc}/nfc.h (100%)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index d931e9c..dfea75f 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -28,7 +28,7 @@
 #include <linux/usb.h>
 #include <linux/nfc.h>
 #include <linux/netdevice.h>
-#include <net/nfc.h>
+#include <net/nfc/nfc.h>
 
 #define VERSION "0.1"
 
diff --git a/include/net/nfc.h b/include/net/nfc/nfc.h
similarity index 100%
rename from include/net/nfc.h
rename to include/net/nfc/nfc.h
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 1a877de..b6753f4 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -24,7 +24,7 @@
 #ifndef __LOCAL_NFC_H
 #define __LOCAL_NFC_H
 
-#include <net/nfc.h>
+#include <net/nfc/nfc.h>
 #include <net/sock.h>
 
 __attribute__((format (printf, 2, 3)))
-- 
1.7.0.4
