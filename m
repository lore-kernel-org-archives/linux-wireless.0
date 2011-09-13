Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56194 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab1IMIqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 04:46:33 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 13 Sep 2011 10:46:09 +0200
Subject: [PATCH v2 2/4] NFC: move nfc.h from include/net to include/net/nfc
Message-ID: <AC090B9732AB2B4DB7FF476E907FE660013226A26B@dnce02.ent.ti.com> (sfid-20110913_104636_923765_2EAF7931)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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