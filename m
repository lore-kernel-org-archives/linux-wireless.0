Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33049 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab1FIWED (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:04:03 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 03/11] compat-wireless: add support for kernel 3.XX
Date: Fri, 10 Jun 2011 00:03:34 +0200
Message-Id: <1307657022-23808-4-git-send-email-hauke@hauke-m.de> (sfid-20110610_000406_105434_AA9165EA)
In-Reply-To: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
References: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now we are also generating CONFIG_COMPAT_KERNEL_3XX entries for kernel
3.XX kernels. This is the final patch needed to add support for kernel
3.0.
When using a 2.6.XX kernel it generates CONFIG_COMPAT_KERNEL_26XX
entries and all CONFIG_COMPAT_KERNEL_3XX entries and when using 3.XX
kernel it will generate only the needed CONFIG_COMPAT_KERNEL_3XX
entries.

Add to compat-3.0-stable

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                      |   23 ++++++++++++++++++-----
 scripts/gen-compat-autoconf.sh |    9 +++++----
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/config.mk b/config.mk
index 58747ba..2a0c229 100644
--- a/config.mk
+++ b/config.mk
@@ -15,10 +15,23 @@ include $(KLIB_BUILD)/.config
 endif
 
 ifneq ($(wildcard $(KLIB_BUILD)/Makefile),)
-COMPAT_LATEST_VERSION = 39
-KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
+
+COMPAT_LATEST_VERSION = 1
+
+KERNEL_VERSION := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^\([0-9]\)\..*/\1/p')
+
+ifneq ($(KERNEL_VERSION),2)
+KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^3\.\([0-9]\+\).*/\1/p')
+else
+COMPAT_26LATEST_VERSION = 39
+KERNEL_26SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
+COMPAT_26VERSIONS := $(shell I=$(COMPAT_26LATEST_VERSION); while [ "$$I" -gt $(KERNEL_26SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
+$(foreach ver,$(COMPAT_26VERSIONS),$(eval CONFIG_COMPAT_KERNEL_2_6_$(ver)=y))
+KERNEL_SUBLEVEL := -1
+endif
+
 COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
-$(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_2_6_$(ver)=y))
+$(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_3_$(ver)=y))
 
 ifdef CONFIG_COMPAT_KERNEL_2_6_24
 $(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
@@ -32,7 +45,7 @@ endif
 # 2.6.27 has FTRACE_DYNAMIC borked, so we will complain if
 # you have it enabled, otherwise you will very likely run into
 # a kernel panic.
-ifeq ($(KERNEL_SUBLEVEL),27)
+ifeq ($(shell test $(KERNEL_VERSION) -eq 2 -a $(KERNEL_SUBLEVEL) -eq 27 && echo yes),yes)
 ifeq ($(CONFIG_DYNAMIC_FTRACE),y)
 $(error "ERROR: Your 2.6.27 kernel has CONFIG_DYNAMIC_FTRACE, please upgrade your distribution kernel as newer ones should not have this enabled (and if so report a bug) or remove this warning if you know what you are doing")
 endif
@@ -49,7 +62,7 @@ endif
 #
 # In kernel 2.6.32 both attributes were removed.
 #
-ifeq ($(shell test $(KERNEL_SUBLEVEL) -ge 27 -a $(KERNEL_SUBLEVEL) -le 31 && echo yes),yes)
+ifeq ($(shell test $(KERNEL_VERSION) -eq 2 -a $(KERNEL_SUBLEVEL) -ge 27 -a $(KERNEL_SUBLEVEL) -le 31 && echo yes),yes)
 ifeq ($(CONFIG_MAC80211),)
 $(error "ERROR: Your >=2.6.27 and <= 2.6.31 kernel has CONFIG_MAC80211 disabled, you should have it CONFIG_MAC80211=m if you want to use this thing.")
 endif
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 827e1ec..fd38c99 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -148,11 +148,11 @@ kernel_version_req $OLDEST_KERNEL_SUPPORTED
 for i in $(egrep '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else #CONFIG_' $COMPAT_CONFIG | sed 's/ /+/'); do
 	case $i in
 	'ifdef+CONFIG_'* )
-		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifdef \)\(CONFIG_[^:space:]*\)/#if defined(\2) || defined(\2_MODULE)/'
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_3_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(3,\2,0))/' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifdef \)\(CONFIG_[^:space:]*\)/#if defined(\2) || defined(\2_MODULE)/'
 		continue
 		;;
 	'ifndef+CONFIG_'* )
-		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_3_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,\2,0))/' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
 		continue
 		;;
 	'else+#CONFIG_'* | 'endif+#CONFIG_'* )
@@ -184,8 +184,9 @@ done
 # Deal with special cases. CONFIG_MAC80211_QOS is such a case.
 # We handle this specially for different kernels we support.
 if [ -f $KLIB_BUILD/Makefile ]; then
-	SUBLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
-	if [ $SUBLEVEL -le 22 ]; then
+	MAJORLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^\([0-9]\)\..*/\1/p')
+	SUBLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^\(2\.6\|[3-9]\)\.\([0-9]\+\).*/\2/p')
+	if [ $MAJORLEVEL -eq 2 -a $SUBLEVEL -le 22 ]; then
 		define_config CONFIG_MAC80211_QOS y
 	else # kernel >= 2.6.23
 		# CONFIG_MAC80211_QOS on these kernels requires
-- 
1.7.4.1

