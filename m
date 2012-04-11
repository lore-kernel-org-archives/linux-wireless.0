Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:38042 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423Ab2DKJiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:18 -0400
Received: by lboj14 with SMTP id j14so720513lbo.22
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:15 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 01/16] wireless/wl12xx/wl1251: move TI WLAN modules to a common ti subdirectory
Date: Wed, 11 Apr 2012 12:37:48 +0300
Message-Id: <1334137083-13490-2-git-send-email-coelho@ti.com> (sfid-20120411_113823_524411_72E34299)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move wl12xx and wl1251 modules into a new drivers/net/wireless/ti
directory.  Add a TI WLAN Kconfig option and Makefile to support this
change.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Cc: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS                                        |   27 +++++++------------
 drivers/net/wireless/Kconfig                       |    3 +-
 drivers/net/wireless/Makefile                      |    4 +--
 drivers/net/wireless/ti/Kconfig                    |   11 ++++++++
 drivers/net/wireless/ti/Makefile                   |    3 ++
 drivers/net/wireless/{ => ti}/wl1251/Kconfig       |    0
 drivers/net/wireless/{ => ti}/wl1251/Makefile      |    0
 drivers/net/wireless/{ => ti}/wl1251/acx.c         |    0
 drivers/net/wireless/{ => ti}/wl1251/acx.h         |    0
 drivers/net/wireless/{ => ti}/wl1251/boot.c        |    0
 drivers/net/wireless/{ => ti}/wl1251/boot.h        |    0
 drivers/net/wireless/{ => ti}/wl1251/cmd.c         |    0
 drivers/net/wireless/{ => ti}/wl1251/cmd.h         |    0
 drivers/net/wireless/{ => ti}/wl1251/debugfs.c     |    0
 drivers/net/wireless/{ => ti}/wl1251/debugfs.h     |    0
 drivers/net/wireless/{ => ti}/wl1251/event.c       |    0
 drivers/net/wireless/{ => ti}/wl1251/event.h       |    0
 drivers/net/wireless/{ => ti}/wl1251/init.c        |    0
 drivers/net/wireless/{ => ti}/wl1251/init.h        |    0
 drivers/net/wireless/{ => ti}/wl1251/io.c          |    0
 drivers/net/wireless/{ => ti}/wl1251/io.h          |    0
 drivers/net/wireless/{ => ti}/wl1251/main.c        |    0
 drivers/net/wireless/{ => ti}/wl1251/ps.c          |    0
 drivers/net/wireless/{ => ti}/wl1251/ps.h          |    0
 drivers/net/wireless/{ => ti}/wl1251/reg.h         |    0
 drivers/net/wireless/{ => ti}/wl1251/rx.c          |    0
 drivers/net/wireless/{ => ti}/wl1251/rx.h          |    0
 drivers/net/wireless/{ => ti}/wl1251/sdio.c        |    0
 drivers/net/wireless/{ => ti}/wl1251/spi.c         |    0
 drivers/net/wireless/{ => ti}/wl1251/spi.h         |    0
 drivers/net/wireless/{ => ti}/wl1251/tx.c          |    0
 drivers/net/wireless/{ => ti}/wl1251/tx.h          |    0
 drivers/net/wireless/{ => ti}/wl1251/wl1251.h      |    0
 .../net/wireless/{ => ti}/wl1251/wl12xx_80211.h    |    0
 drivers/net/wireless/{ => ti}/wl12xx/Kconfig       |    0
 drivers/net/wireless/{ => ti}/wl12xx/Makefile      |    0
 drivers/net/wireless/{ => ti}/wl12xx/acx.c         |    0
 drivers/net/wireless/{ => ti}/wl12xx/acx.h         |    0
 drivers/net/wireless/{ => ti}/wl12xx/boot.c        |    0
 drivers/net/wireless/{ => ti}/wl12xx/boot.h        |    0
 drivers/net/wireless/{ => ti}/wl12xx/cmd.c         |    0
 drivers/net/wireless/{ => ti}/wl12xx/cmd.h         |    0
 drivers/net/wireless/{ => ti}/wl12xx/conf.h        |    0
 drivers/net/wireless/{ => ti}/wl12xx/debug.h       |    0
 drivers/net/wireless/{ => ti}/wl12xx/debugfs.c     |    0
 drivers/net/wireless/{ => ti}/wl12xx/debugfs.h     |    0
 drivers/net/wireless/{ => ti}/wl12xx/event.c       |    0
 drivers/net/wireless/{ => ti}/wl12xx/event.h       |    0
 drivers/net/wireless/{ => ti}/wl12xx/ini.h         |    0
 drivers/net/wireless/{ => ti}/wl12xx/init.c        |    0
 drivers/net/wireless/{ => ti}/wl12xx/init.h        |    0
 drivers/net/wireless/{ => ti}/wl12xx/io.c          |    0
 drivers/net/wireless/{ => ti}/wl12xx/io.h          |    0
 drivers/net/wireless/{ => ti}/wl12xx/main.c        |    0
 drivers/net/wireless/{ => ti}/wl12xx/ps.c          |    0
 drivers/net/wireless/{ => ti}/wl12xx/ps.h          |    0
 drivers/net/wireless/{ => ti}/wl12xx/reg.h         |    0
 drivers/net/wireless/{ => ti}/wl12xx/rx.c          |    0
 drivers/net/wireless/{ => ti}/wl12xx/rx.h          |    0
 drivers/net/wireless/{ => ti}/wl12xx/scan.c        |    0
 drivers/net/wireless/{ => ti}/wl12xx/scan.h        |    0
 drivers/net/wireless/{ => ti}/wl12xx/sdio.c        |    0
 drivers/net/wireless/{ => ti}/wl12xx/spi.c         |    0
 drivers/net/wireless/{ => ti}/wl12xx/testmode.c    |    0
 drivers/net/wireless/{ => ti}/wl12xx/testmode.h    |    0
 drivers/net/wireless/{ => ti}/wl12xx/tx.c          |    0
 drivers/net/wireless/{ => ti}/wl12xx/tx.h          |    0
 drivers/net/wireless/{ => ti}/wl12xx/wl12xx.h      |    0
 .../net/wireless/{ => ti}/wl12xx/wl12xx_80211.h    |    0
 .../{ => ti}/wl12xx/wl12xx_platform_data.c         |    0
 70 files changed, 26 insertions(+), 22 deletions(-)
 create mode 100644 drivers/net/wireless/ti/Kconfig
 create mode 100644 drivers/net/wireless/ti/Makefile
 rename drivers/net/wireless/{ => ti}/wl1251/Kconfig (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/Makefile (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/acx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/acx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/boot.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/boot.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/cmd.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/cmd.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/debugfs.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/debugfs.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/event.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/event.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/init.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/init.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/io.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/io.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/main.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/ps.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/ps.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/reg.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/rx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/rx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/sdio.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/spi.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/spi.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/tx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/tx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/wl1251.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/wl12xx_80211.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/Kconfig (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/Makefile (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/acx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/acx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/boot.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/boot.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/cmd.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/cmd.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/conf.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/debug.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/debugfs.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/debugfs.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/event.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/event.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/ini.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/init.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/init.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/io.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/io.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/main.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/ps.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/ps.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/reg.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/rx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/rx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/scan.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/scan.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/sdio.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/spi.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/testmode.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/testmode.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/tx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/tx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/wl12xx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/wl12xx_80211.h (100%)
 rename drivers/net/wireless/{ => ti}/wl12xx/wl12xx_platform_data.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index ec24a9f..dbfb6b2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6669,6 +6669,16 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Maintained
 F:	sound/soc/codecs/twl4030*
 
+TI WILINK WIRELESS DRIVERS
+M:	Luciano Coelho <coelho@ti.com>
+L:	linux-wireless@vger.kernel.org
+W:	http://wireless.kernel.org/en/users/Drivers/wl12xx
+W:	http://wireless.kernel.org/en/users/Drivers/wl1251
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
+S:	Maintained
+F:	drivers/net/wireless/ti/
+F:	include/linux/wl12xx.h
+
 TIPC NETWORK LAYER
 M:	Jon Maloy <jon.maloy@ericsson.com>
 M:	Allan Stephens <allan.stephens@windriver.com>
@@ -7425,23 +7435,6 @@ M:	Miloslav Trmac <mitr@volny.cz>
 S:	Maintained
 F:	drivers/input/misc/wistron_btns.c
 
-WL1251 WIRELESS DRIVER
-M:	Luciano Coelho <coelho@ti.com>
-L:	linux-wireless@vger.kernel.org
-W:	http://wireless.kernel.org/en/users/Drivers/wl1251
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
-S:	Maintained
-F:	drivers/net/wireless/wl1251/*
-
-WL1271 WIRELESS DRIVER
-M:	Luciano Coelho <coelho@ti.com>
-L:	linux-wireless@vger.kernel.org
-W:	http://wireless.kernel.org/en/users/Drivers/wl12xx
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
-S:	Maintained
-F:	drivers/net/wireless/wl12xx/
-F:	include/linux/wl12xx.h
-
 WL3501 WIRELESS PCMCIA CARD DRIVER
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 L:	linux-wireless@vger.kernel.org
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index abd3b71..5f58fa5 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -282,8 +282,7 @@ source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/rt2x00/Kconfig"
 source "drivers/net/wireless/rtlwifi/Kconfig"
-source "drivers/net/wireless/wl1251/Kconfig"
-source "drivers/net/wireless/wl12xx/Kconfig"
+source "drivers/net/wireless/ti/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/mwifiex/Kconfig"
 
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 98db761..0ce218b 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -51,9 +51,7 @@ obj-$(CONFIG_ATH_COMMON)	+= ath/
 
 obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
 
-obj-$(CONFIG_WL1251)	+= wl1251/
-obj-$(CONFIG_WL12XX)	+= wl12xx/
-obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx/
+obj-$(CONFIG_WL_TI)	+= ti/
 
 obj-$(CONFIG_IWM)	+= iwmc3200wifi/
 
diff --git a/drivers/net/wireless/ti/Kconfig b/drivers/net/wireless/ti/Kconfig
new file mode 100644
index 0000000..75722d8
--- /dev/null
+++ b/drivers/net/wireless/ti/Kconfig
@@ -0,0 +1,11 @@
+menuconfig WL_TI
+	bool "TI Wireless LAN support"
+	---help---
+	  This section contains support for all the wireless drivers
+	  for Texas Instruments WLAN chips, such as wl1251 and the wl12xx
+	  family.
+
+if WL_TI
+source "drivers/net/wireless/ti/wl1251/Kconfig"
+source "drivers/net/wireless/ti/wl12xx/Kconfig"
+endif # WL_TI
diff --git a/drivers/net/wireless/ti/Makefile b/drivers/net/wireless/ti/Makefile
new file mode 100644
index 0000000..db2cb03
--- /dev/null
+++ b/drivers/net/wireless/ti/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_WL12XX)			+= wl12xx/
+obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx/
+obj-$(CONFIG_WL1251)			+= wl1251/
diff --git a/drivers/net/wireless/wl1251/Kconfig b/drivers/net/wireless/ti/wl1251/Kconfig
similarity index 100%
rename from drivers/net/wireless/wl1251/Kconfig
rename to drivers/net/wireless/ti/wl1251/Kconfig
diff --git a/drivers/net/wireless/wl1251/Makefile b/drivers/net/wireless/ti/wl1251/Makefile
similarity index 100%
rename from drivers/net/wireless/wl1251/Makefile
rename to drivers/net/wireless/ti/wl1251/Makefile
diff --git a/drivers/net/wireless/wl1251/acx.c b/drivers/net/wireless/ti/wl1251/acx.c
similarity index 100%
rename from drivers/net/wireless/wl1251/acx.c
rename to drivers/net/wireless/ti/wl1251/acx.c
diff --git a/drivers/net/wireless/wl1251/acx.h b/drivers/net/wireless/ti/wl1251/acx.h
similarity index 100%
rename from drivers/net/wireless/wl1251/acx.h
rename to drivers/net/wireless/ti/wl1251/acx.h
diff --git a/drivers/net/wireless/wl1251/boot.c b/drivers/net/wireless/ti/wl1251/boot.c
similarity index 100%
rename from drivers/net/wireless/wl1251/boot.c
rename to drivers/net/wireless/ti/wl1251/boot.c
diff --git a/drivers/net/wireless/wl1251/boot.h b/drivers/net/wireless/ti/wl1251/boot.h
similarity index 100%
rename from drivers/net/wireless/wl1251/boot.h
rename to drivers/net/wireless/ti/wl1251/boot.h
diff --git a/drivers/net/wireless/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
similarity index 100%
rename from drivers/net/wireless/wl1251/cmd.c
rename to drivers/net/wireless/ti/wl1251/cmd.c
diff --git a/drivers/net/wireless/wl1251/cmd.h b/drivers/net/wireless/ti/wl1251/cmd.h
similarity index 100%
rename from drivers/net/wireless/wl1251/cmd.h
rename to drivers/net/wireless/ti/wl1251/cmd.h
diff --git a/drivers/net/wireless/wl1251/debugfs.c b/drivers/net/wireless/ti/wl1251/debugfs.c
similarity index 100%
rename from drivers/net/wireless/wl1251/debugfs.c
rename to drivers/net/wireless/ti/wl1251/debugfs.c
diff --git a/drivers/net/wireless/wl1251/debugfs.h b/drivers/net/wireless/ti/wl1251/debugfs.h
similarity index 100%
rename from drivers/net/wireless/wl1251/debugfs.h
rename to drivers/net/wireless/ti/wl1251/debugfs.h
diff --git a/drivers/net/wireless/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
similarity index 100%
rename from drivers/net/wireless/wl1251/event.c
rename to drivers/net/wireless/ti/wl1251/event.c
diff --git a/drivers/net/wireless/wl1251/event.h b/drivers/net/wireless/ti/wl1251/event.h
similarity index 100%
rename from drivers/net/wireless/wl1251/event.h
rename to drivers/net/wireless/ti/wl1251/event.h
diff --git a/drivers/net/wireless/wl1251/init.c b/drivers/net/wireless/ti/wl1251/init.c
similarity index 100%
rename from drivers/net/wireless/wl1251/init.c
rename to drivers/net/wireless/ti/wl1251/init.c
diff --git a/drivers/net/wireless/wl1251/init.h b/drivers/net/wireless/ti/wl1251/init.h
similarity index 100%
rename from drivers/net/wireless/wl1251/init.h
rename to drivers/net/wireless/ti/wl1251/init.h
diff --git a/drivers/net/wireless/wl1251/io.c b/drivers/net/wireless/ti/wl1251/io.c
similarity index 100%
rename from drivers/net/wireless/wl1251/io.c
rename to drivers/net/wireless/ti/wl1251/io.c
diff --git a/drivers/net/wireless/wl1251/io.h b/drivers/net/wireless/ti/wl1251/io.h
similarity index 100%
rename from drivers/net/wireless/wl1251/io.h
rename to drivers/net/wireless/ti/wl1251/io.h
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
similarity index 100%
rename from drivers/net/wireless/wl1251/main.c
rename to drivers/net/wireless/ti/wl1251/main.c
diff --git a/drivers/net/wireless/wl1251/ps.c b/drivers/net/wireless/ti/wl1251/ps.c
similarity index 100%
rename from drivers/net/wireless/wl1251/ps.c
rename to drivers/net/wireless/ti/wl1251/ps.c
diff --git a/drivers/net/wireless/wl1251/ps.h b/drivers/net/wireless/ti/wl1251/ps.h
similarity index 100%
rename from drivers/net/wireless/wl1251/ps.h
rename to drivers/net/wireless/ti/wl1251/ps.h
diff --git a/drivers/net/wireless/wl1251/reg.h b/drivers/net/wireless/ti/wl1251/reg.h
similarity index 100%
rename from drivers/net/wireless/wl1251/reg.h
rename to drivers/net/wireless/ti/wl1251/reg.h
diff --git a/drivers/net/wireless/wl1251/rx.c b/drivers/net/wireless/ti/wl1251/rx.c
similarity index 100%
rename from drivers/net/wireless/wl1251/rx.c
rename to drivers/net/wireless/ti/wl1251/rx.c
diff --git a/drivers/net/wireless/wl1251/rx.h b/drivers/net/wireless/ti/wl1251/rx.h
similarity index 100%
rename from drivers/net/wireless/wl1251/rx.h
rename to drivers/net/wireless/ti/wl1251/rx.h
diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/ti/wl1251/sdio.c
similarity index 100%
rename from drivers/net/wireless/wl1251/sdio.c
rename to drivers/net/wireless/ti/wl1251/sdio.c
diff --git a/drivers/net/wireless/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
similarity index 100%
rename from drivers/net/wireless/wl1251/spi.c
rename to drivers/net/wireless/ti/wl1251/spi.c
diff --git a/drivers/net/wireless/wl1251/spi.h b/drivers/net/wireless/ti/wl1251/spi.h
similarity index 100%
rename from drivers/net/wireless/wl1251/spi.h
rename to drivers/net/wireless/ti/wl1251/spi.h
diff --git a/drivers/net/wireless/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
similarity index 100%
rename from drivers/net/wireless/wl1251/tx.c
rename to drivers/net/wireless/ti/wl1251/tx.c
diff --git a/drivers/net/wireless/wl1251/tx.h b/drivers/net/wireless/ti/wl1251/tx.h
similarity index 100%
rename from drivers/net/wireless/wl1251/tx.h
rename to drivers/net/wireless/ti/wl1251/tx.h
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/ti/wl1251/wl1251.h
similarity index 100%
rename from drivers/net/wireless/wl1251/wl1251.h
rename to drivers/net/wireless/ti/wl1251/wl1251.h
diff --git a/drivers/net/wireless/wl1251/wl12xx_80211.h b/drivers/net/wireless/ti/wl1251/wl12xx_80211.h
similarity index 100%
rename from drivers/net/wireless/wl1251/wl12xx_80211.h
rename to drivers/net/wireless/ti/wl1251/wl12xx_80211.h
diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/ti/wl12xx/Kconfig
similarity index 100%
rename from drivers/net/wireless/wl12xx/Kconfig
rename to drivers/net/wireless/ti/wl12xx/Kconfig
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/ti/wl12xx/Makefile
similarity index 100%
rename from drivers/net/wireless/wl12xx/Makefile
rename to drivers/net/wireless/ti/wl12xx/Makefile
diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/ti/wl12xx/acx.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/acx.c
rename to drivers/net/wireless/ti/wl12xx/acx.c
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/ti/wl12xx/acx.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/acx.h
rename to drivers/net/wireless/ti/wl12xx/acx.h
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/ti/wl12xx/boot.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/boot.c
rename to drivers/net/wireless/ti/wl12xx/boot.c
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/ti/wl12xx/boot.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/boot.h
rename to drivers/net/wireless/ti/wl12xx/boot.h
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/ti/wl12xx/cmd.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/cmd.c
rename to drivers/net/wireless/ti/wl12xx/cmd.c
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/ti/wl12xx/cmd.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/cmd.h
rename to drivers/net/wireless/ti/wl12xx/cmd.h
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/ti/wl12xx/conf.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/conf.h
rename to drivers/net/wireless/ti/wl12xx/conf.h
diff --git a/drivers/net/wireless/wl12xx/debug.h b/drivers/net/wireless/ti/wl12xx/debug.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/debug.h
rename to drivers/net/wireless/ti/wl12xx/debug.h
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/ti/wl12xx/debugfs.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/debugfs.c
rename to drivers/net/wireless/ti/wl12xx/debugfs.c
diff --git a/drivers/net/wireless/wl12xx/debugfs.h b/drivers/net/wireless/ti/wl12xx/debugfs.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/debugfs.h
rename to drivers/net/wireless/ti/wl12xx/debugfs.h
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/ti/wl12xx/event.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/event.c
rename to drivers/net/wireless/ti/wl12xx/event.c
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/ti/wl12xx/event.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/event.h
rename to drivers/net/wireless/ti/wl12xx/event.h
diff --git a/drivers/net/wireless/wl12xx/ini.h b/drivers/net/wireless/ti/wl12xx/ini.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/ini.h
rename to drivers/net/wireless/ti/wl12xx/ini.h
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/ti/wl12xx/init.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/init.c
rename to drivers/net/wireless/ti/wl12xx/init.c
diff --git a/drivers/net/wireless/wl12xx/init.h b/drivers/net/wireless/ti/wl12xx/init.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/init.h
rename to drivers/net/wireless/ti/wl12xx/init.h
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/ti/wl12xx/io.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/io.c
rename to drivers/net/wireless/ti/wl12xx/io.c
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/ti/wl12xx/io.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/io.h
rename to drivers/net/wireless/ti/wl12xx/io.h
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/main.c
rename to drivers/net/wireless/ti/wl12xx/main.c
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/ti/wl12xx/ps.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/ps.c
rename to drivers/net/wireless/ti/wl12xx/ps.c
diff --git a/drivers/net/wireless/wl12xx/ps.h b/drivers/net/wireless/ti/wl12xx/ps.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/ps.h
rename to drivers/net/wireless/ti/wl12xx/ps.h
diff --git a/drivers/net/wireless/wl12xx/reg.h b/drivers/net/wireless/ti/wl12xx/reg.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/reg.h
rename to drivers/net/wireless/ti/wl12xx/reg.h
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/ti/wl12xx/rx.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/rx.c
rename to drivers/net/wireless/ti/wl12xx/rx.c
diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/ti/wl12xx/rx.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/rx.h
rename to drivers/net/wireless/ti/wl12xx/rx.h
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/ti/wl12xx/scan.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/scan.c
rename to drivers/net/wireless/ti/wl12xx/scan.c
diff --git a/drivers/net/wireless/wl12xx/scan.h b/drivers/net/wireless/ti/wl12xx/scan.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/scan.h
rename to drivers/net/wireless/ti/wl12xx/scan.h
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/ti/wl12xx/sdio.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/sdio.c
rename to drivers/net/wireless/ti/wl12xx/sdio.c
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/ti/wl12xx/spi.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/spi.c
rename to drivers/net/wireless/ti/wl12xx/spi.c
diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/ti/wl12xx/testmode.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/testmode.c
rename to drivers/net/wireless/ti/wl12xx/testmode.c
diff --git a/drivers/net/wireless/wl12xx/testmode.h b/drivers/net/wireless/ti/wl12xx/testmode.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/testmode.h
rename to drivers/net/wireless/ti/wl12xx/testmode.h
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/ti/wl12xx/tx.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/tx.c
rename to drivers/net/wireless/ti/wl12xx/tx.c
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/ti/wl12xx/tx.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/tx.h
rename to drivers/net/wireless/ti/wl12xx/tx.h
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl12xx.h
rename to drivers/net/wireless/ti/wl12xx/wl12xx.h
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/ti/wl12xx/wl12xx_80211.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl12xx_80211.h
rename to drivers/net/wireless/ti/wl12xx/wl12xx_80211.h
diff --git a/drivers/net/wireless/wl12xx/wl12xx_platform_data.c b/drivers/net/wireless/ti/wl12xx/wl12xx_platform_data.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl12xx_platform_data.c
rename to drivers/net/wireless/ti/wl12xx/wl12xx_platform_data.c
-- 
1.7.5.4

