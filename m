Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60494 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab1FBQfo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:35:44 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/9] compat-wireless: add support for kernel 3.XX
Date: Thu,  2 Jun 2011 18:35:19 +0200
Message-Id: <1307032525-18916-4-git-send-email-hauke@hauke-m.de> (sfid-20110602_183548_714207_3487C348)
In-Reply-To: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
References: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
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
 config.mk                      |   22 ++++++++++++++++++----
 scripts/gen-compat-autoconf.sh |   15 ++++++++++++++-
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/config.mk b/config.mk
index 57903e0..2160409 100644
--- a/config.mk
+++ b/config.mk
@@ -15,10 +15,22 @@ include $(KLIB_BUILD)/.config
 endif
 
 ifneq ($(wildcard $(KLIB_BUILD)/Makefile),)
-COMPAT_LATEST_VERSION = 39
-KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
+
+COMPAT_LATEST_VERSION = 1
+KERNEL_VERSION := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^\([0-9]\)\..*/\1/p')
+
+ifeq ($(KERNEL_VERSION),3)
+KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^3\.\([0-9]\+\).*/\1/p')
+else
+COMPAT_26LATEST_VERSION = 39
+KERNEL_26SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
+COMPAT_26VERSIONS := $(shell I=$(COMPAT_26LATEST_VERSION); while [ "$$I" -gt $(KERNEL_26SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
+$(foreach ver,$(COMPAT_26VERSIONS),$(eval CONFIG_COMPAT_KERNEL_26$(ver)=y))
+KERNEL_SUBLEVEL := -1
+endif
+
 COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
-$(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_26$(ver)=y))
+$(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_3$(ver)=y))
 
 ifdef CONFIG_COMPAT_KERNEL_2624
 $(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
@@ -49,11 +61,13 @@ endif
 #
 # In kernel 2.6.32 both attributes were removed.
 #
-ifeq ($(shell test $(KERNEL_SUBLEVEL) -ge 27 -a $(KERNEL_SUBLEVEL) -le 31 && echo yes),yes)
+ifeq ($(KERNEL_VERSION),2)
+ifeq ($(shell test $(KERNEL_26SUBLEVEL) -ge 27 -a $(KERNEL_26SUBLEVEL) -le 31 && echo yes),yes)
 ifeq ($(CONFIG_MAC80211),)
 $(error "ERROR: Your >=2.6.27 and <= 2.6.31 kernel has CONFIG_MAC80211 disabled, you should have it CONFIG_MAC80211=m if you want to use this thing.")
 endif
 endif
+endif
 
 ifneq ($(KERNELRELEASE),) # This prevents a warning
 
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 0dc091c..af19da6 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -155,6 +155,14 @@ for i in $(egrep '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else
 		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_26\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
 		continue
 		;;
+	'ifdef+CONFIG_'* )
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_3\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(3,\2,0))/' -e 's/\(#ifdef \)\(CONFIG_[^:space:]*\)/#if defined(\2) || defined(\2_MODULE)/'
+		continue
+		;;
+	'ifndef+CONFIG_'* )
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_3\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,\2,0))/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
+		continue
+		;;
 	'else+#CONFIG_'* | 'endif+#CONFIG_'* )
 		echo "#$i */" |sed -e 's/+#/ \/* /g'
 		continue
@@ -184,7 +192,12 @@ done
 # Deal with special cases. CONFIG_MAC80211_QOS is such a case.
 # We handle this specially for different kernels we support.
 if [ -f $KLIB_BUILD/Makefile ]; then
-	SUBLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
+	MAJORLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^\([0-9]\)\..*/\1/p')
+	if [ $MAJORLEVEL -eq 2 ]; then
+		SUBLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
+	else
+		SUBLEVEL=99
+	fi
 	if [ $SUBLEVEL -le 22 ]; then
 		define_config CONFIG_MAC80211_QOS y
 	else # kernel >= 2.6.23
-- 
1.7.4.1

