Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12165 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbYKOBo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 20:44:56 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 17:44:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <nbd@openwrt.org>,
	<derek@indranet.co.nz>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <nbd@openwrt.org>,
	<derek@indranet.co.nz>
Subject: [PATCH] mac80211: make Minstrel the default rate control algorithm
Date: Fri, 14 Nov 2008 17:44:53 -0800
Message-ID: <1226713493-4449-1-git-send-email-lrodriguez@atheros.com> (sfid-20081115_024502_076099_54F0B072)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes minstrel the default rate control algorithm
for mac80211. For more information see:

http://wireless.kernel.org/en/developers/Documentation/mac80211/RateControl/minstrel

If someone can come up with a better algorithm they get a prize
(undisclosed).

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Tested with rm -rf .config ; a fresh install and with the ar9170 driver.

git://git.kernel.org/pub/scm/linux/kernel/git/jberg/ar9170.git

 arch/arm/configs/eseries_pxa_defconfig   |    7 ++++---
 arch/arm/configs/ezx_defconfig           |   16 ++++------------
 arch/arm/configs/overo_defconfig         |    7 ++++---
 arch/arm/configs/s3c2410_defconfig       |   15 ++++-----------
 arch/mips/configs/bcm47xx_defconfig      |   18 ++++--------------
 arch/mips/configs/sb1250-swarm_defconfig |    6 +++---
 arch/powerpc/configs/pmac32_defconfig    |    7 ++++---
 arch/powerpc/configs/ppc6xx_defconfig    |    7 ++++---
 arch/powerpc/configs/ps3_defconfig       |    7 ++++---
 arch/sh/configs/ul2_defconfig            |    9 ++++-----
 arch/x86/configs/i386_defconfig          |    7 ++++---
 arch/x86/configs/x86_64_defconfig        |    7 ++++---
 net/mac80211/Kconfig                     |    8 ++++----
 13 files changed, 51 insertions(+), 70 deletions(-)

diff --git a/arch/arm/configs/eseries_pxa_defconfig b/arch/arm/configs/eseries_pxa_defconfig
index 2307587..8d4118a 100644
--- a/arch/arm/configs/eseries_pxa_defconfig
+++ b/arch/arm/configs/eseries_pxa_defconfig
@@ -447,9 +447,10 @@ CONFIG_MAC80211=m
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_PID=y
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-CONFIG_MAC80211_RC_DEFAULT="pid"
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 # CONFIG_MAC80211_MESH is not set
 # CONFIG_MAC80211_LEDS is not set
 # CONFIG_MAC80211_DEBUG_MENU is not set
diff --git a/arch/arm/configs/ezx_defconfig b/arch/arm/configs/ezx_defconfig
index 2a84d55..b992b2e 100644
--- a/arch/arm/configs/ezx_defconfig
+++ b/arch/arm/configs/ezx_defconfig
@@ -566,18 +566,10 @@ CONFIG_MAC80211=m
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-# CONFIG_MAC80211_RC_DEFAULT_NONE is not set
-
-#
-# Selecting 'y' for an algorithm will
-#
-
-#
-# build the algorithm into mac80211.
-#
-CONFIG_MAC80211_RC_DEFAULT="pid"
-CONFIG_MAC80211_RC_PID=y
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 # CONFIG_MAC80211_MESH is not set
 CONFIG_MAC80211_LEDS=y
 # CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
diff --git a/arch/arm/configs/overo_defconfig b/arch/arm/configs/overo_defconfig
index 4920096..fe47064 100644
--- a/arch/arm/configs/overo_defconfig
+++ b/arch/arm/configs/overo_defconfig
@@ -461,9 +461,10 @@ CONFIG_MAC80211=y
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_PID=y
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-CONFIG_MAC80211_RC_DEFAULT="pid"
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 # CONFIG_MAC80211_MESH is not set
 CONFIG_MAC80211_LEDS=y
 # CONFIG_MAC80211_DEBUGFS is not set
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index 35faaea..5aebdc2 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -474,18 +474,11 @@ CONFIG_MAC80211=m
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-# CONFIG_MAC80211_RC_DEFAULT_NONE is not set
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 
-#
-# Selecting 'y' for an algorithm will
-#
-
-#
-# build the algorithm into mac80211.
-#
-CONFIG_MAC80211_RC_DEFAULT="pid"
-CONFIG_MAC80211_RC_PID=y
 CONFIG_MAC80211_MESH=y
 CONFIG_MAC80211_LEDS=y
 # CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
index d869433..da2fbd6 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -736,20 +736,10 @@ CONFIG_MAC80211=m
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-# CONFIG_MAC80211_RC_DEFAULT_SIMPLE is not set
-# CONFIG_MAC80211_RC_DEFAULT_NONE is not set
-
-#
-# Selecting 'y' for an algorithm will
-#
-
-#
-# build the algorithm into mac80211.
-#
-CONFIG_MAC80211_RC_DEFAULT="pid"
-CONFIG_MAC80211_RC_PID=y
-# CONFIG_MAC80211_RC_SIMPLE is not set
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 CONFIG_MAC80211_LEDS=y
 # CONFIG_MAC80211_DEBUGFS is not set
 # CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
diff --git a/arch/mips/configs/sb1250-swarm_defconfig b/arch/mips/configs/sb1250-swarm_defconfig
index a9acaa2..1cc5436 100644
--- a/arch/mips/configs/sb1250-swarm_defconfig
+++ b/arch/mips/configs/sb1250-swarm_defconfig
@@ -400,7 +400,7 @@ CONFIG_MAC80211=m
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_DEFAULT_PID=y
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
 # CONFIG_MAC80211_RC_DEFAULT_NONE is not set
 
 #
@@ -410,8 +410,8 @@ CONFIG_MAC80211_RC_DEFAULT_PID=y
 #
 # build the algorithm into mac80211.
 #
-CONFIG_MAC80211_RC_DEFAULT="pid"
-CONFIG_MAC80211_RC_PID=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
+CONFIG_MAC80211_RC_MINSTREL=y
 # CONFIG_MAC80211_MESH is not set
 # CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
 # CONFIG_MAC80211_DEBUG is not set
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index 80481f2..ee548fa 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -598,9 +598,10 @@ CONFIG_MAC80211=m
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_PID=y
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-CONFIG_MAC80211_RC_DEFAULT="pid"
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 # CONFIG_MAC80211_MESH is not set
 CONFIG_MAC80211_LEDS=y
 # CONFIG_MAC80211_DEBUG_MENU is not set
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 3c6dbde..107df52 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -867,9 +867,10 @@ CONFIG_MAC80211=m
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_PID=y
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-CONFIG_MAC80211_RC_DEFAULT="pid"
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 CONFIG_MAC80211_MESH=y
 CONFIG_MAC80211_LEDS=y
 CONFIG_MAC80211_DEBUGFS=y
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index b6eee7c..49abd26 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -413,9 +413,10 @@ CONFIG_MAC80211=m
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_PID=y
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-CONFIG_MAC80211_RC_DEFAULT="pid"
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 # CONFIG_MAC80211_MESH is not set
 # CONFIG_MAC80211_LEDS is not set
 # CONFIG_MAC80211_DEBUGFS is not set
diff --git a/arch/sh/configs/ul2_defconfig b/arch/sh/configs/ul2_defconfig
index 9afff67..c44dd07 100644
--- a/arch/sh/configs/ul2_defconfig
+++ b/arch/sh/configs/ul2_defconfig
@@ -389,11 +389,10 @@ CONFIG_MAC80211=y
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_PID=y
-# CONFIG_MAC80211_RC_MINSTREL is not set
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
-CONFIG_MAC80211_RC_DEFAULT="pid"
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 # CONFIG_MAC80211_MESH is not set
 # CONFIG_MAC80211_LEDS is not set
 # CONFIG_MAC80211_DEBUG_MENU is not set
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 13b8c86..a549ca2 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -690,9 +690,10 @@ CONFIG_MAC80211=y
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_PID=y
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-CONFIG_MAC80211_RC_DEFAULT="pid"
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 # CONFIG_MAC80211_MESH is not set
 CONFIG_MAC80211_LEDS=y
 # CONFIG_MAC80211_DEBUGFS is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index f0a03d7..0340af5 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -680,9 +680,10 @@ CONFIG_MAC80211=y
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_PID=y
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-CONFIG_MAC80211_RC_DEFAULT="pid"
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 # CONFIG_MAC80211_MESH is not set
 CONFIG_MAC80211_LEDS=y
 # CONFIG_MAC80211_DEBUGFS is not set
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 7f710a2..60c1616 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -16,20 +16,20 @@ menu "Rate control algorithm selection"
 
 config MAC80211_RC_PID
 	bool "PID controller based rate control algorithm" if EMBEDDED
-	default y
 	---help---
 	  This option enables a TX rate control algorithm for
 	  mac80211 that uses a PID controller to select the TX
 	  rate.
 
 config MAC80211_RC_MINSTREL
-	bool "Minstrel"
+	bool "Minstrel" if EMBEDDED
+	default y
 	---help---
 	  This option enables the 'minstrel' TX rate control algorithm
 
 choice
 	prompt "Default rate control algorithm"
-	default MAC80211_RC_DEFAULT_PID
+	default MAC80211_RC_DEFAULT_MINSTREL
 	---help---
 	  This option selects the default rate control algorithm
 	  mac80211 will use. Note that this default can still be
@@ -55,8 +55,8 @@ endchoice
 
 config MAC80211_RC_DEFAULT
 	string
-	default "pid" if MAC80211_RC_DEFAULT_PID
 	default "minstrel" if MAC80211_RC_DEFAULT_MINSTREL
+	default "pid" if MAC80211_RC_DEFAULT_PID
 	default ""
 
 endmenu
-- 
1.5.6.3

