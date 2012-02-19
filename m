Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49600 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab2BSQDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 11:03:44 -0500
Received: by qadc10 with SMTP id c10so2442232qad.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2012 08:03:43 -0800 (PST)
From: Rick Farina <sidhayn@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Rick Farina <sidhayn@gmail.com>
Subject: [PATCH] [compat-wireless] replace modprobe -l with functional equivilent
Date: Sun, 19 Feb 2012 11:03:16 -0500
Message-Id: <1329667396-20357-1-git-send-email-sidhayn@gmail.com> (sfid-20120219_170347_320906_C58C9906)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

modprobe -l is either deprecated or removed, so let's replace it

Signed-off-by: Rick Farina <sidhayn@gmail.com>
---
 Makefile |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/Makefile b/Makefile
index 4149d8d..0403a34 100644
--- a/Makefile
+++ b/Makefile
@@ -6,14 +6,6 @@ else
 export KLIB:=          /lib/modules/$(shell uname -r)
 endif
 export KLIB_BUILD ?=	$(KLIB)/build
-# Sometimes not available in the path
-MODPROBE := /sbin/modprobe
-
-ifneq ($(wildcard $(MODPROBE)),)
-MADWIFI=$(shell $(MODPROBE) -l ath_pci)
-OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
-OLD_ALX=$(shell $(MODPROBE) -l atl1c)
-endif
 
 DESTDIR?=
 
@@ -99,7 +91,7 @@ $(CREL_CHECK):
 
 btinstall: btuninstall bt-install-modules
 
-bt-install-modules: bt $(MODPROBE)
+bt-install-modules: bt
 	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) $(KMODDIR_ARG) $(KMODPATH_ARG) BT=TRUE \
 		modules_install
 	@/sbin/depmod -ae
@@ -111,7 +103,7 @@ bt-install-modules: bt $(MODPROBE)
 	@echo And then load the needed bluetooth modules. If unsure reboot.
 	@echo
 
-btuninstall: $(MODPROBE)
+btuninstall:
 	@# New location, matches upstream
 	@rm -rf $(KLIB)/$(KMODDIR)/net/bluetooth/
 	@rm -rf $(KLIB)/$(KMODDIR)/drivers/bluetooth/
@@ -131,7 +123,7 @@ install-modules: modules
 		modules_install
 	@./scripts/update-initramfs
 
-install-scripts: $(MODPROBE)
+install-scripts:
 	@# All the scripts we can use
 	@mkdir -p $(DESTDIR)/usr/lib/compat-wireless/
 	@install scripts/modlib.sh	$(DESTDIR)/usr/lib/compat-wireless/
@@ -144,7 +136,7 @@ install-scripts: $(MODPROBE)
 	@install scripts/athload	$(DESTDIR)/usr/sbin/
 	@install scripts/b43load	$(DESTDIR)/usr/sbin/
 	@install scripts/iwl-load	$(DESTDIR)/usr/sbin/
-	@if [ ! -z "$(MADWIFI)" ] && [ -z "$(DESTDIR)" ]; then \
+	@if $(modinfo ath_pci > /dev/null 2>&1) && [ -z "$(DESTDIR)" ]; then \
 		echo ;\
 		echo -n "Note: madwifi detected, we're going to disable it. "  ;\
 		echo "If you would like to enable it later you can run:"  ;\
@@ -153,7 +145,7 @@ install-scripts: $(MODPROBE)
 		echo Running athenable ath5k...;\
 		/usr/sbin/athenable ath5k ;\
 	fi
-	@if [ ! -z "$(OLD_IWL)" ] && [ -z "$(DESTDIR)" ]; then \
+	@if $(modinfo iwl4965 > /dev/null 2>&1) && [ -z "$(DESTDIR)" ]; then \
 		echo ;\
 		echo -n "Note: iwl4965 detected, we're going to disable it. "  ;\
 		echo "If you would like to enable it later you can run:"  ;\
@@ -162,7 +154,7 @@ install-scripts: $(MODPROBE)
 		echo Running iwl-enable iwlagn...;\
 		/usr/sbin/iwl-enable iwlagn ;\
 	fi
-	@if [ ! -z "$(OLD_ALX)" ] && [ -z "$(DESTDIR)" ]; then \
+	@if $(modinfo atl1c > /dev/null 2>&1) && [ -z "$(DESTDIR)" ]; then \
 		echo ;\
 		echo -n "Note: atl1c detected, we're going to disable it. "  ;\
 		echo "If you would like to enable it later you can run:"  ;\
@@ -195,7 +187,7 @@ install-scripts: $(MODPROBE)
 	@echo If unsure reboot.
 	@echo
 
-uninstall: $(MODPROBE)
+uninstall:
 	@# New location, matches upstream
 	@rm -rf $(KLIB)/$(KMODDIR)/compat/
 	@rm -rf $(KLIB)/$(KMODDIR)/net/mac80211/
-- 
1.7.3.4

