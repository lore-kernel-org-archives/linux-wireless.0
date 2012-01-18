Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:39336 "HELO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756153Ab2ARIN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 03:13:58 -0500
From: Luciano Coelho <coelho@ti.com>
To: mcgrof@frijolero.org
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	wlist@ti.com, idor@ti.com, assaf@ti.com, gil.barak@ti.com
Subject: [PATCH] compat-wireless: check if modprobe exists before using it
Date: Wed, 18 Jan 2012 10:13:41 +0200
Message-Id: <1326874421-4654-1-git-send-email-coelho@ti.com> (sfid-20120118_091405_342790_30D346D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you're cross-compiling compat-wireless on a different host, you
can't reliably use modprobe.  The host system may not even have
modprobe, so it doesn't make sense to run modprobe, unless you're
installing the modules on the target machine.

The modprobe command was being used unconditionally to set the MADWIFI
and OLD_IWL variables.  This commit adds a check to see whether
modprobe exists before trying to use.  It also adds a dependency on
the modprobe commands to all recipes that rely on it, so we fail more
gracefully if modprobe doesn't exist in the system.

Reported by: William List <wlist@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 Makefile |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index c81d680..e3d9128 100644
--- a/Makefile
+++ b/Makefile
@@ -8,8 +8,11 @@ endif
 export KLIB_BUILD ?=	$(KLIB)/build
 # Sometimes not available in the path
 MODPROBE := /sbin/modprobe
+
+ifneq ($(wildcard $(MODPROBE)),)
 MADWIFI=$(shell $(MODPROBE) -l ath_pci)
 OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
+endif
 
 DESTDIR?=
 
@@ -95,7 +98,7 @@ $(CREL_CHECK):
 
 btinstall: btuninstall bt-install-modules
 
-bt-install-modules: bt
+bt-install-modules: bt $(MODPROBE)
 	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) $(KMODDIR_ARG) $(KMODPATH_ARG) BT=TRUE \
 		modules_install
 	@/sbin/depmod -ae
@@ -130,7 +133,7 @@ bt-install-modules: bt
 	@echo And then load the needed bluetooth modules. If unsure reboot.
 	@echo
 
-btuninstall:
+btuninstall: $(MODPROBE)
 	@# New location, matches upstream
 	@rm -rf $(KLIB)/$(KMODDIR)/net/bluetooth/
 	@rm -rf $(KLIB)/$(KMODDIR)/drivers/bluetooth/
@@ -173,7 +176,7 @@ install-modules: modules
 		modules_install
 	@./scripts/update-initramfs
 
-install-scripts:
+install-scripts: $(MODPROBE)
 	@# All the scripts we can use
 	@mkdir -p $(DESTDIR)/usr/lib/compat-wireless/
 	@install scripts/modlib.sh	$(DESTDIR)/usr/lib/compat-wireless/
@@ -330,7 +333,7 @@ install-scripts:
 	@echo If unsure reboot.
 	@echo
 
-uninstall:
+uninstall: $(MODPROBE)
 	@# New location, matches upstream
 	@rm -rf $(KLIB)/$(KMODDIR)/compat/
 	@rm -rf $(KLIB)/$(KMODDIR)/net/mac80211/
-- 
1.7.4.1

