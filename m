Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57359 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYKKWBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 17:01:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC PATCH 4/4] net/ieee80211 -> drivers/net/ipw2x00/libipw_* rename
Date: Tue, 11 Nov 2008 16:51:05 -0500
Message-Id: <1226440265-21240-4-git-send-email-linville@tuxdriver.com> (sfid-20081111_230117_740580_98090359)
In-Reply-To: <1226440265-21240-3-git-send-email-linville@tuxdriver.com>
References: <>
 <1226440265-21240-1-git-send-email-linville@tuxdriver.com>
 <1226440265-21240-2-git-send-email-linville@tuxdriver.com>
 <1226440265-21240-3-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old ieee80211 code only remains as a support library for the ipw2100
and ipw2200 drivers.  So, move the code and rename it appropriately to
reflects it's true purpose and status.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2x00/Kconfig               |   45 +++++++++++++++++++-
 drivers/net/wireless/ipw2x00/Makefile              |    8 ++++
 .../net/wireless/ipw2x00/libipw_geo.c              |    0 
 .../net/wireless/ipw2x00/libipw_module.c           |    0 
 .../net/wireless/ipw2x00/libipw_rx.c               |    0 
 .../net/wireless/ipw2x00/libipw_tx.c               |    0 
 .../net/wireless/ipw2x00/libipw_wx.c               |    0 
 net/Kconfig                                        |    1 -
 net/Makefile                                       |    1 -
 net/ieee80211/Kconfig                              |   41 ------------------
 net/ieee80211/Makefile                             |    8 ----
 11 files changed, 51 insertions(+), 53 deletions(-)
 rename net/ieee80211/ieee80211_geo.c => drivers/net/wireless/ipw2x00/libipw_geo.c (100%)
 rename net/ieee80211/ieee80211_module.c => drivers/net/wireless/ipw2x00/libipw_module.c (100%)
 rename net/ieee80211/ieee80211_rx.c => drivers/net/wireless/ipw2x00/libipw_rx.c (100%)
 rename net/ieee80211/ieee80211_tx.c => drivers/net/wireless/ipw2x00/libipw_tx.c (100%)
 rename net/ieee80211/ieee80211_wx.c => drivers/net/wireless/ipw2x00/libipw_wx.c (100%)
 delete mode 100644 net/ieee80211/Kconfig
 delete mode 100644 net/ieee80211/Makefile

diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 67c57bf..3d5cc44 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -8,7 +8,7 @@ config IPW2100
 	select WIRELESS_EXT
 	select FW_LOADER
 	select LIB80211
-	select IEEE80211
+	select LIBIPW
 	---help---
           A driver for the Intel PRO/Wireless 2100 Network 
 	  Connection 802.11b wireless network adapter.
@@ -67,7 +67,7 @@ config IPW2200
 	select WIRELESS_EXT
 	select FW_LOADER
 	select LIB80211
-	select IEEE80211
+	select LIBIPW
 	---help---
           A driver for the Intel PRO/Wireless 2200BG and 2915ABG Network
 	  Connection adapters. 
@@ -148,3 +148,44 @@ config IPW2200_DEBUG
 
 	  If you are not sure, say N here.
 
+config LIBIPW
+	tristate
+	select WIRELESS_EXT
+	select CRYPTO
+	select CRYPTO_ARC4
+	select CRYPTO_ECB
+	select CRYPTO_AES
+	select CRYPTO_MICHAEL_MIC
+	select CRYPTO_ECB
+	select CRC32
+	select LIB80211
+	select LIB80211_CRYPT_WEP
+	select LIB80211_CRYPT_TKIP
+	select LIB80211_CRYPT_CCMP
+	---help---
+	This option enables the hardware independent IEEE 802.11
+	networking stack.  This component is deprecated in favor of the
+	mac80211 component.
+
+config LIBIPW_DEBUG
+	bool "Full debugging output for the LIBIPW component"
+	depends on LIBIPW
+	---help---
+	  This option will enable debug tracing output for the
+	  libipw component.
+
+	  This will result in the kernel module being ~70k larger.  You
+	  can control which debug output is sent to the kernel log by
+	  setting the value in
+
+	  /proc/net/ieee80211/debug_level
+
+	  For example:
+
+	  % echo 0x00000FFO > /proc/net/ieee80211/debug_level
+
+	  For a list of values you can assign to debug_level, you
+	  can look at the bit mask values in <net/ieee80211.h>
+
+	  If you are not trying to debug or develop the libipw
+	  component, you most likely want to say N here.
diff --git a/drivers/net/wireless/ipw2x00/Makefile b/drivers/net/wireless/ipw2x00/Makefile
index dbc0d81..aecd2cf 100644
--- a/drivers/net/wireless/ipw2x00/Makefile
+++ b/drivers/net/wireless/ipw2x00/Makefile
@@ -4,3 +4,11 @@
 
 obj-$(CONFIG_IPW2100) += ipw2100.o
 obj-$(CONFIG_IPW2200) += ipw2200.o
+
+obj-$(CONFIG_LIBIPW) += libipw.o
+libipw-objs := \
+	libipw_module.o \
+	libipw_tx.o \
+	libipw_rx.o \
+	libipw_wx.o \
+	libipw_geo.o
diff --git a/net/ieee80211/ieee80211_geo.c b/drivers/net/wireless/ipw2x00/libipw_geo.c
similarity index 100%
rename from net/ieee80211/ieee80211_geo.c
rename to drivers/net/wireless/ipw2x00/libipw_geo.c
diff --git a/net/ieee80211/ieee80211_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
similarity index 100%
rename from net/ieee80211/ieee80211_module.c
rename to drivers/net/wireless/ipw2x00/libipw_module.c
diff --git a/net/ieee80211/ieee80211_rx.c b/drivers/net/wireless/ipw2x00/libipw_rx.c
similarity index 100%
rename from net/ieee80211/ieee80211_rx.c
rename to drivers/net/wireless/ipw2x00/libipw_rx.c
diff --git a/net/ieee80211/ieee80211_tx.c b/drivers/net/wireless/ipw2x00/libipw_tx.c
similarity index 100%
rename from net/ieee80211/ieee80211_tx.c
rename to drivers/net/wireless/ipw2x00/libipw_tx.c
diff --git a/net/ieee80211/ieee80211_wx.c b/drivers/net/wireless/ipw2x00/libipw_wx.c
similarity index 100%
rename from net/ieee80211/ieee80211_wx.c
rename to drivers/net/wireless/ipw2x00/libipw_wx.c
diff --git a/net/Kconfig b/net/Kconfig
index d789d79..3696ac0 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -247,7 +247,6 @@ if WIRELESS
 
 source "net/wireless/Kconfig"
 source "net/mac80211/Kconfig"
-source "net/ieee80211/Kconfig"
 
 endif # WIRELESS
 
diff --git a/net/Makefile b/net/Makefile
index 27d1f10..20b1e27 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -51,7 +51,6 @@ obj-$(CONFIG_IP_DCCP)		+= dccp/
 obj-$(CONFIG_IP_SCTP)		+= sctp/
 obj-y				+= wireless/
 obj-$(CONFIG_MAC80211)		+= mac80211/
-obj-$(CONFIG_IEEE80211)		+= ieee80211/
 obj-$(CONFIG_TIPC)		+= tipc/
 obj-$(CONFIG_NETLABEL)		+= netlabel/
 obj-$(CONFIG_IUCV)		+= iucv/
diff --git a/net/ieee80211/Kconfig b/net/ieee80211/Kconfig
deleted file mode 100644
index 46f24f4..0000000
--- a/net/ieee80211/Kconfig
+++ /dev/null
@@ -1,41 +0,0 @@
-config IEEE80211
-	tristate
-	select WIRELESS_EXT
-	select CRYPTO
-	select CRYPTO_ARC4
-	select CRYPTO_ECB
-	select CRYPTO_AES
-	select CRYPTO_MICHAEL_MIC
-	select CRYPTO_ECB
-	select CRC32
-	select LIB80211
-	select LIB80211_CRYPT_WEP
-	select LIB80211_CRYPT_TKIP
-	select LIB80211_CRYPT_CCMP
-	---help---
-	This option enables the hardware independent IEEE 802.11
-	networking stack.  This component is deprecated in favor of the
-	mac80211 component.
-
-config IEEE80211_DEBUG
-	bool "Full debugging output for the old IEEE80211 stack"
-	depends on IEEE80211
-	---help---
-	  This option will enable debug tracing output for the
-	  ieee80211 network stack.
-
-	  This will result in the kernel module being ~70k larger.  You
-	  can control which debug output is sent to the kernel log by
-	  setting the value in
-
-	  /proc/net/ieee80211/debug_level
-
-	  For example:
-
-	  % echo 0x00000FFO > /proc/net/ieee80211/debug_level
-
-	  For a list of values you can assign to debug_level, you
-	  can look at the bit mask values in <net/ieee80211.h>
-
-	  If you are not trying to debug or develop the ieee80211
-	  subsystem, you most likely want to say N here.
diff --git a/net/ieee80211/Makefile b/net/ieee80211/Makefile
deleted file mode 100644
index 158963f..0000000
--- a/net/ieee80211/Makefile
+++ /dev/null
@@ -1,8 +0,0 @@
-obj-$(CONFIG_IEEE80211) += ieee80211.o
-ieee80211-objs := \
-	ieee80211_module.o \
-	ieee80211_tx.o \
-	ieee80211_rx.o \
-	ieee80211_wx.o \
-	ieee80211_geo.o
-
-- 
1.5.4.3

