Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55381 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab2BCCsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 21:48:36 -0500
Received: by qadc10 with SMTP id c10so466944qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 18:48:35 -0800 (PST)
From: Rick Farina <sidhayn@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Rick Farina <sidhayn@gmail.com>
Subject: [PATCH 1/2] replace modprobe -l with modinfo
Date: Thu,  2 Feb 2012 21:48:21 -0500
Message-Id: <1328237302-13423-1-git-send-email-sidhayn@gmail.com> (sfid-20120203_034839_677857_1A87E220)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

modprobe -l is either deprecated or removed, so let's replace it.

Signed-of-by: Rick Farina <sidhayn@gmail.com>
---
 Makefile |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index e3d9128..1f8ab91 100644
--- a/Makefile
+++ b/Makefile
@@ -6,13 +6,6 @@ else
 export KLIB:=          /lib/modules/$(shell uname -r)
 endif
 export KLIB_BUILD ?=	$(KLIB)/build
-# Sometimes not available in the path
-MODPROBE := /sbin/modprobe
-
-ifneq ($(wildcard $(MODPROBE)),)
-MADWIFI=$(shell $(MODPROBE) -l ath_pci)
-OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
-endif
 
 DESTDIR?=
 
@@ -188,7 +181,7 @@ install-scripts: $(MODPROBE)
 	@install scripts/athload	$(DESTDIR)/usr/sbin/
 	@install scripts/b43load	$(DESTDIR)/usr/sbin/
 	@install scripts/iwl-load	$(DESTDIR)/usr/sbin/
-	@if [ ! -z "$(MADWIFI)" ] && [ -z "$(DESTDIR)" ]; then \
+	@if `modinfo ath_pci > /dev/null 2>&1` && [ -z "$(DESTDIR)" ]; then \
 		echo ;\
 		echo -n "Note: madwifi detected, we're going to disable it. "  ;\
 		echo "If you would like to enable it later you can run:"  ;\
@@ -197,7 +190,7 @@ install-scripts: $(MODPROBE)
 		echo Running athenable ath5k...;\
 		/usr/sbin/athenable ath5k ;\
 	fi
-	@if [ ! -z "$(OLD_IWL)" ] && [ -z "$(DESTDIR)" ]; then \
+	@if `modinfo iwl4965 > /dev/null 2>&1` && [ -z "$(DESTDIR)" ]; then \
 		echo ;\
 		echo -n "Note: iwl4965 detected, we're going to disable it. "  ;\
 		echo "If you would like to enable it later you can run:"  ;\
-- 
1.7.3.4

