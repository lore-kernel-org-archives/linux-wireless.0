Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39678 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab1BHVgf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 16:36:35 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: fix some problems with brcm80211
Date: Tue,  8 Feb 2011 22:36:19 +0100
Message-Id: <1297200981-22971-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have to activate debug, without we get compile errors

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                              |    3 ++-
 patches/35-fix-makefile-includes.patch |   14 +++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/config.mk b/config.mk
index d8712e8..7c337bb 100644
--- a/config.mk
+++ b/config.mk
@@ -539,6 +539,7 @@ ifneq ($(CONFIG_COMPAT_STAGING),)
 
 CONFIG_BRCM80211=m
 CONFIG_BRCMSMAC=y
+CONFIG_BRCMDBG=y
 
 ifdef CONFIG_WIRELESS_EXT
 CONFIG_ATH6KL_CFG80211=y
@@ -555,7 +556,7 @@ CONFIG_ATH6K_LEGACY=m
 
 # It is not possible to compile CONFIG_BRCMSMAC and CONFIG_BRCMFMAC as
 # module at the same time
-# CONFIG_BRCMFMAC=y
+CONFIG_BRCMFMAC=y
 
 endif #CONFIG_WIRELESS_EXT
 endif #CONFIG_MMC
diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
index 2142da2..ea5b41d 100644
--- a/patches/35-fix-makefile-includes.patch
+++ b/patches/35-fix-makefile-includes.patch
@@ -20,11 +20,11 @@ path the make process will search in the kernel tree for the headers.
 +ccflags-y += -I$(obj)/..
 --- a/drivers/staging/brcm80211/brcmfmac/Makefile
 +++ b/drivers/staging/brcm80211/brcmfmac/Makefile
-@@ -32,9 +32,9 @@ ccflags-y :=			\
- 	-DPKT_FILTER_SUPPORT	\
- 	-DSHOW_EVENTS		\
- 	-DTOE			\
--	-Idrivers/staging/brcm80211/brcmfmac		\
+@@ -35,9 +35,9 @@ ccflags-y :=			\
+ ccflags-$(CONFIG_BRCMDBG)	+= -DDHD_DEBUG
+ 
+ ccflags-y += \
+-	-Idrivers/staging/brcm80211/brcmfmac	\
 -	-Idrivers/staging/brcm80211/include		\
 -	-Idrivers/staging/brcm80211/util
 +	-I$(obj)		\
@@ -35,9 +35,9 @@ path the make process will search in the kernel tree for the headers.
  	wl_cfg80211.o \
 --- a/drivers/staging/brcm80211/brcmsmac/Makefile
 +++ b/drivers/staging/brcm80211/brcmsmac/Makefile
-@@ -24,10 +24,10 @@ ccflags-y :=					\
+@@ -23,10 +23,10 @@ ccflags-y :=				\
+ 	-DWL11N					\
  	-DDBAND					\
- 	-DBCMDMA32				\
  	-DBCMNVRAMR				\
 -	-Idrivers/staging/brcm80211/brcmsmac \
 -	-Idrivers/staging/brcm80211/brcmsmac/phy \
-- 
1.7.1

