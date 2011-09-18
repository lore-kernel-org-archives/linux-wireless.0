Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48906 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab1IRIWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 04:22:22 -0400
Received: by mail-gy0-f174.google.com with SMTP id 10so3574299gyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 01:22:22 -0700 (PDT)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v2 2/4 RESEND] NFC: move nfc.h from include/net to include/net/nfc
Date: Sun, 18 Sep 2011 11:19:34 +0300
Message-Id: <1316333976-30388-3-git-send-email-ilane@ti.com> (sfid-20110918_102226_273456_496F6F6E)
In-Reply-To: <1316333976-30388-1-git-send-email-ilane@ti.com>
References: <1316333976-30388-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

The file nfc.h was moved from include/net to include/net/nfc,
since new NFC header files will be added to include/net/nfc.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 MAINTAINERS                 |    2 +-
 drivers/nfc/pn533.c         |    2 +-
 include/net/{ => nfc}/nfc.h |    0
 net/nfc/nfc.h               |    2 +-
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename include/net/{ => nfc}/nfc.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 43f9137..869a4e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4517,7 +4517,7 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	net/nfc/
 F:	include/linux/nfc.h
-F:	include/net/nfc.h
+F:	include/net/nfc/
 F:	drivers/nfc/
 
 NFS, SUNRPC, AND LOCKD CLIENTS
diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index c78eb6a..7bcb1fe 100644
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

