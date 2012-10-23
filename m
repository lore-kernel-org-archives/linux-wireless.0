Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:37950 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab2JWSeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 14:34:16 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so2541654lag.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2012 11:34:16 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH v3 4/4] Add Kconfig and Makefile. Add MAINTAINERS entry
Date: Tue, 23 Oct 2012 20:34:00 +0200
Message-Id: <1351017240-2797-5-git-send-email-pontus.fuchs@gmail.com> (sfid-20121023_203428_005947_0D174D92)
In-Reply-To: <1351017240-2797-1-git-send-email-pontus.fuchs@gmail.com>
References: <1351017240-2797-1-git-send-email-pontus.fuchs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hook into the build system so driver can be built.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 MAINTAINERS                              |    6 ++++++
 drivers/net/wireless/ath/Kconfig         |    1 +
 drivers/net/wireless/ath/Makefile        |    1 +
 drivers/net/wireless/ath/ar5523/Kconfig  |    7 +++++++
 drivers/net/wireless/ath/ar5523/Makefile |    1 +
 5 files changed, 16 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ar5523/Kconfig
 create mode 100644 drivers/net/wireless/ath/ar5523/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 027ec2b..29634e3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7492,6 +7492,12 @@ S:	Maintained
 F:	Documentation/usb/acm.txt
 F:	drivers/usb/class/cdc-acm.*
 
+USB AR5523 WIRELESS DRIVER
+M:	Pontus Fuchs <pontus.fuchs@gmail.com>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/ath/ar5523/
+
 USB ATTACHED SCSI
 M:	Matthew Wilcox <willy@linux.intel.com>
 M:	Sarah Sharp <sarah.a.sharp@linux.intel.com>
diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 0960224..c25dcf1 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -26,5 +26,6 @@ source "drivers/net/wireless/ath/ath5k/Kconfig"
 source "drivers/net/wireless/ath/ath9k/Kconfig"
 source "drivers/net/wireless/ath/carl9170/Kconfig"
 source "drivers/net/wireless/ath/ath6kl/Kconfig"
+source "drivers/net/wireless/ath/ar5523/Kconfig"
 
 endif
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index d716b74..1e18621 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_ATH5K)		+= ath5k/
 obj-$(CONFIG_ATH9K_HW)		+= ath9k/
 obj-$(CONFIG_CARL9170)		+= carl9170/
 obj-$(CONFIG_ATH6KL)		+= ath6kl/
+obj-$(CONFIG_AR5523)		+= ar5523/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
diff --git a/drivers/net/wireless/ath/ar5523/Kconfig b/drivers/net/wireless/ath/ar5523/Kconfig
new file mode 100644
index 0000000..11d99ee
--- /dev/null
+++ b/drivers/net/wireless/ath/ar5523/Kconfig
@@ -0,0 +1,7 @@
+config AR5523
+       tristate "Atheros AR5523 wireless driver support"
+       depends on MAC80211 && USB
+       select FW_LOADER
+       ---help---
+         This module add support for AR5523 based USB dongles such as D-Link
+         DWL-G132, Netgear WPN111 and many more.
diff --git a/drivers/net/wireless/ath/ar5523/Makefile b/drivers/net/wireless/ath/ar5523/Makefile
new file mode 100644
index 0000000..ebf7f3b
--- /dev/null
+++ b/drivers/net/wireless/ath/ar5523/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_AR5523)   := ar5523.o
-- 
1.7.9.5

