Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39122 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab1EKRJm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 13:09:42 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patches apply again
Date: Wed, 11 May 2011 19:09:32 +0200
Message-Id: <1305133772-22177-1-git-send-email-hauke@hauke-m.de> (sfid-20110511_190946_280376_7638CBF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/35-fix-makefile-includes.patch |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
index ea5b41d..7d1ceaf 100644
--- a/patches/35-fix-makefile-includes.patch
+++ b/patches/35-fix-makefile-includes.patch
@@ -20,32 +20,28 @@ path the make process will search in the kernel tree for the headers.
 +ccflags-y += -I$(obj)/..
 --- a/drivers/staging/brcm80211/brcmfmac/Makefile
 +++ b/drivers/staging/brcm80211/brcmfmac/Makefile
-@@ -35,9 +35,9 @@ ccflags-y :=			\
+@@ -35,8 +35,8 @@ ccflags-y :=			\
  ccflags-$(CONFIG_BRCMDBG)	+= -DDHD_DEBUG
  
  ccflags-y += \
 -	-Idrivers/staging/brcm80211/brcmfmac	\
--	-Idrivers/staging/brcm80211/include		\
--	-Idrivers/staging/brcm80211/util
+-	-Idrivers/staging/brcm80211/include
 +	-I$(obj)		\
-+	-I$(obj)/../include	\
-+	-I$(obj)/../util
++	-I$(obj)/../include
  
  DHDOFILES = \
  	wl_cfg80211.o \
 --- a/drivers/staging/brcm80211/brcmsmac/Makefile
 +++ b/drivers/staging/brcm80211/brcmsmac/Makefile
-@@ -23,10 +23,10 @@ ccflags-y :=				\
+@@ -23,9 +23,9 @@ ccflags-y :=				\
  	-DWL11N					\
  	-DDBAND					\
  	-DBCMNVRAMR				\
 -	-Idrivers/staging/brcm80211/brcmsmac \
 -	-Idrivers/staging/brcm80211/brcmsmac/phy \
--	-Idrivers/staging/brcm80211/util \
 -	-Idrivers/staging/brcm80211/include
 +	-I$(obj)				\
 +	-I$(obj)/phy				\
-+	-I$(obj)/../util			\
 +	-I$(obj)/../include
  
  BRCMSMAC_OFILES := \
-- 
1.7.4.1

