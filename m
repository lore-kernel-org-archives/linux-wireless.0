Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58383 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab1ENSAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 14:00:39 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: fix building of brcm80211
Date: Sat, 14 May 2011 20:00:27 +0200
Message-Id: <1305396027-5864-3-git-send-email-hauke@hauke-m.de> (sfid-20110514_200043_507531_FCF292C7)
In-Reply-To: <1305396027-5864-1-git-send-email-hauke@hauke-m.de>
References: <1305396027-5864-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Broadcom brcm80211 driver now needs brcmutil.ko. Furthermore the
config options are now set to m to, most parts are build as module when
the options are set to m and y. Some options for this driver where at
the wrong position in config.mk.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                              |   15 ++++++++++-----
 patches/35-fix-makefile-includes.patch |   13 +++++++++++++
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/config.mk b/config.mk
index abe6030..99485a4 100644
--- a/config.mk
+++ b/config.mk
@@ -370,6 +370,10 @@ endif #CONFIG_WIRELESS_EXT
 CONFIG_RTL8192CE=m
 CONFIG_RTL8192SE=m
 
+ifdef CONFIG_COMPAT_STAGING
+CONFIG_BRCMSMAC=m
+endif #CONFIG_COMPAT_STAGING
+
 endif #CONFIG_PCI
 ## end of PCI
 
@@ -540,10 +544,6 @@ CONFIG_BT_HCIBTSDIO=m
 CONFIG_BT_MRVL_SDIO=m
 
 ifdef CONFIG_COMPAT_STAGING
-
-CONFIG_BRCMSMAC=y
-# CONFIG_BRCMDBG=y
-
 ifdef CONFIG_WIRELESS_EXT
 # CONFIG_ATH6KL_DISABLE_TARGET_DBGLOGS is not set
 # CONFIG_ATH6KL_ENABLE_COEXISTENCE is not set
@@ -555,7 +555,7 @@ CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
 CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
 CONFIG_ATH6K_LEGACY=m
 
-CONFIG_BRCMFMAC=y
+CONFIG_BRCMFMAC=m
 
 endif #CONFIG_WIRELESS_EXT
 endif #CONFIG_COMPAT_STAGING
@@ -595,6 +595,11 @@ endif #CONFIG_MAC80211_LEDS
 CONFIG_ATH_COMMON=m
 # CONFIG_ATH_DEBUG=y
 
+ifdef CONFIG_COMPAT_STAGING
+CONFIG_BRCMUTIL=m
+# CONFIG_BRCMDBG=y
+endif #CONFIG_COMPAT_STAGING
+
 ifdef CONFIG_CRC7
 CONFIG_WL1251=m
 CONFIG_WL12XX=m
diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
index 7d1ceaf..4a01aa2 100644
--- a/patches/35-fix-makefile-includes.patch
+++ b/patches/35-fix-makefile-includes.patch
@@ -46,3 +46,16 @@ path the make process will search in the kernel tree for the headers.
  
  BRCMSMAC_OFILES := \
  	wl_mac80211.o \
+--- a/drivers/staging/brcm80211/util/Makefile
++++ b/drivers/staging/brcm80211/util/Makefile
+@@ -16,8 +16,8 @@
+ # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ 
+ ccflags-y :=				\
+-	-Idrivers/staging/brcm80211/util \
+-	-Idrivers/staging/brcm80211/include
++	-I$(obj)			\
++	-I$(obj)/../include
+ 
+ BRCMUTIL_OFILES := \
+ 	bcmutils.o \
-- 
1.7.4.1

