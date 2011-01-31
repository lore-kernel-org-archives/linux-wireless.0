Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57449 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626Ab1AaWHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 17:07:12 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: adapt chamhes in brcm80211
Date: Mon, 31 Jan 2011 23:06:43 +0100
Message-Id: <1296511604-16921-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1296511604-16921-1-git-send-email-hauke@hauke-m.de>
References: <1296511604-16921-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                              |    4 +-
 patches/35-fix-makefile-includes.patch |   42 ++++++++++++++++----------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/config.mk b/config.mk
index 7a29d46..d8712e8 100644
--- a/config.mk
+++ b/config.mk
@@ -538,7 +538,7 @@ CONFIG_BT_MRVL_SDIO=m
 ifneq ($(CONFIG_COMPAT_STAGING),)
 
 CONFIG_BRCM80211=m
-CONFIG_BRCM80211_PCI=y
+CONFIG_BRCMSMAC=y
 
 ifdef CONFIG_WIRELESS_EXT
 CONFIG_ATH6KL_CFG80211=y
@@ -553,7 +553,7 @@ CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
 CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
 CONFIG_ATH6K_LEGACY=m
 
-# It is not possible to compile CONFIG_BRCM80211 and CONFIG_BRCMFMAC as
+# It is not possible to compile CONFIG_BRCMSMAC and CONFIG_BRCMFMAC as
 # module at the same time
 # CONFIG_BRCMFMAC=y
 
diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
index c80e11f..2142da2 100644
--- a/patches/35-fix-makefile-includes.patch
+++ b/patches/35-fix-makefile-includes.patch
@@ -18,26 +18,9 @@ path the make process will search in the kernel tree for the headers.
  
 -ccflags-y += -Idrivers/net/wireless/rtl818x
 +ccflags-y += -I$(obj)/..
---- a/drivers/staging/brcm80211/Makefile
-+++ b/drivers/staging/brcm80211/Makefile
-@@ -24,10 +24,10 @@ ccflags-y :=					\
- 	-DDBAND					\
- 	-DBCMDMA32				\
- 	-DBCMNVRAMR				\
--	-Idrivers/staging/brcm80211/sys		\
--	-Idrivers/staging/brcm80211/phy		\
--	-Idrivers/staging/brcm80211/util	\
--	-Idrivers/staging/brcm80211/include
-+	-I$(obj)/sys		\
-+	-I$(obj)/phy		\
-+	-I$(obj)/util	\
-+	-I$(obj)/include
- 
- PCI_CFLAGS := -DWLC_LOW
- 
 --- a/drivers/staging/brcm80211/brcmfmac/Makefile
 +++ b/drivers/staging/brcm80211/brcmfmac/Makefile
-@@ -33,9 +33,9 @@ ccflags-y :=			\
+@@ -32,9 +32,9 @@ ccflags-y :=			\
  	-DPKT_FILTER_SUPPORT	\
  	-DSHOW_EVENTS		\
  	-DTOE			\
@@ -45,8 +28,25 @@ path the make process will search in the kernel tree for the headers.
 -	-Idrivers/staging/brcm80211/include		\
 -	-Idrivers/staging/brcm80211/util
 +	-I$(obj)		\
-+	-I$(obj)/../include		\
++	-I$(obj)/../include	\
 +	-I$(obj)/../util
  
- DHDOFILES = dhd_linux.o ../util/linux_osl.o ../util/bcmutils.o dhd_common.o dhd_custom_gpio.o	\
- 	wl_iw.o wl_cfg80211.o ../util/siutils.o ../util/sbutils.o ../util/aiutils.o ../util/hndpmu.o ../util/bcmwifi.o dhd_sdio.o	\
+ DHDOFILES = \
+ 	wl_cfg80211.o \
+--- a/drivers/staging/brcm80211/brcmsmac/Makefile
++++ b/drivers/staging/brcm80211/brcmsmac/Makefile
+@@ -24,10 +24,10 @@ ccflags-y :=					\
+ 	-DDBAND					\
+ 	-DBCMDMA32				\
+ 	-DBCMNVRAMR				\
+-	-Idrivers/staging/brcm80211/brcmsmac \
+-	-Idrivers/staging/brcm80211/brcmsmac/phy \
+-	-Idrivers/staging/brcm80211/util \
+-	-Idrivers/staging/brcm80211/include
++	-I$(obj)				\
++	-I$(obj)/phy				\
++	-I$(obj)/../util			\
++	-I$(obj)/../include
+ 
+ BRCMSMAC_OFILES := \
+ 	wl_mac80211.o \
-- 
1.7.1

