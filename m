Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:58504 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2JKUCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 16:02:07 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so1518456lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2012 13:02:05 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 4/4] ar5523: Add Kconfig and Makefile
Date: Thu, 11 Oct 2012 22:01:42 +0200
Message-Id: <1349985702-21322-5-git-send-email-pontus.fuchs@gmail.com> (sfid-20121011_220215_609044_BEC61627)
In-Reply-To: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hook into the build system so driver can be built.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/staging/Kconfig         |    2 ++
 drivers/staging/Makefile        |    1 +
 drivers/staging/ar5523/Kconfig  |    7 +++++++
 drivers/staging/ar5523/Makefile |    1 +
 4 files changed, 11 insertions(+)
 create mode 100644 drivers/staging/ar5523/Kconfig
 create mode 100644 drivers/staging/ar5523/Makefile

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index d805eef..f742293 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -144,4 +144,6 @@ source "drivers/staging/imx-drm/Kconfig"
 
 source "drivers/staging/dgrp/Kconfig"
 
+source "drivers/staging/ar5523/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 76e2ebd..e1cb094 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -64,3 +64,4 @@ obj-$(CONFIG_NET_VENDOR_SILICOM)	+= silicom/
 obj-$(CONFIG_CED1401)		+= ced1401/
 obj-$(CONFIG_DRM_IMX)		+= imx-drm/
 obj-$(CONFIG_DGRP)		+= dgrp/
+obj-$(CONFIG_AR5523)		+= ar5523/
diff --git a/drivers/staging/ar5523/Kconfig b/drivers/staging/ar5523/Kconfig
new file mode 100644
index 0000000..962e839
--- /dev/null
+++ b/drivers/staging/ar5523/Kconfig
@@ -0,0 +1,7 @@
+config AR5523
+	tristate "Atheros AR5523 wireless driver support"
+	depends on MAC80211 && USB
+	select FW_LOADER
+	---help---
+	  This module add support for AR5523 based USB dongles such as D-Link
+	  DWL-G132, Netgear WPN111 and many more.
diff --git a/drivers/staging/ar5523/Makefile b/drivers/staging/ar5523/Makefile
new file mode 100644
index 0000000..574d0aa
--- /dev/null
+++ b/drivers/staging/ar5523/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_AR5523)	:= ar5523.o
-- 
1.7.9.5

