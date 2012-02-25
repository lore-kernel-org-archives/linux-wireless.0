Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24856 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab2BYBwP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 20:52:15 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 1/5] compat: fix few compilations by adding compat_autoconf.h support
Date: Fri, 24 Feb 2012 17:52:02 -0800
Message-ID: <1330134726-1634-2-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_025221_493758_3D6D307E)
In-Reply-To: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

The Makefile was generating the appropriate CONFIG_COMPAT_KERNEL_*
variables for our Makefiles but this was being ignored by C files
as compat had no compat_autoconf.h being generated. This patch
addresses this but also puhes out the CONFIG_COMPAT_KERNEL_* variable
generation to scripts. We have now two scripts:

scripts/gen-compat-config.sh - generates .config for Makefile propagation
scripts/gen-compat-autoconf.sh  - generates compat_autoconf.h for code propagation

This fixes running ckmake on older kernels. This issue was present
only on compat and not compat_wireless as compat_wireless was generating
its own compat_autoconf.h. This fixes compilation against some older
kernels of just the compat module alone. Some work is still required
for some newer and really ancient kernels:

mcgrof@tux ~/compat (git::master)$ ckmake
Trying kernel                  3.3.0-030300rc2-generic  [FAILED]
Trying kernel                     3.2.2-030202-generic  [FAILED]
Trying kernel                    3.1.10-030110-generic  [FAILED]
Trying kernel                    3.0.18-030018-generic  [FAILED]
Trying kernel                  2.6.39-02063904-generic  [FAILED]
Trying kernel                         2.6.38-8-generic  [OK]
Trying kernel                        2.6.38-13-generic  [OK]
Trying kernel                        2.6.38-12-generic  [OK]
Trying kernel                        2.6.38-11-generic  [OK]
Trying kernel                        2.6.38-10-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [OK]
Trying kernel                  2.6.34-02063410-generic  [OK]
Trying kernel                  2.6.33-02063305-generic  [OK]
Trying kernel                  2.6.32-02063255-generic  [OK]
Trying kernel                        2.6.31-22-generic  [OK]
Trying kernel                  2.6.31-02063113-generic  [OK]
Trying kernel                  2.6.30-02063010-generic  [OK]
Trying kernel                  2.6.29-02062906-generic  [OK]
Trying kernel                  2.6.28-02062810-generic  [OK]
Trying kernel                    2.6.27-020627-generic  [OK]
Trying kernel                    2.6.26-020626-generic  [OK]
Trying kernel                    2.6.25-020625-generic  [FAILED]
Trying kernel                    2.6.24-020624-generic  [FAILED]

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 .gitignore                      |   10 ++++
 Makefile                        |   59 ++++++++++------------
 include/linux/compat_autoconf.h |   37 --------------
 scripts/gen-compat-autoconf.sh  |  105 +++++++++++++++++++++++++++++++++++++++
 scripts/gen-compat-config.sh    |   50 ++++++++++++++++++
 5 files changed, 191 insertions(+), 70 deletions(-)
 delete mode 100644 include/linux/compat_autoconf.h
 create mode 100755 scripts/gen-compat-autoconf.sh
 create mode 100755 scripts/gen-compat-config.sh

diff --git a/.gitignore b/.gitignore
index e27f6c2..498cb5a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -3,3 +3,13 @@ Module.symvers
 module.order
 .pc
 ckmake.log
+.config
+include/linux/compat_autoconf.h
+.tmp_versions/
+compat/*.cmd
+compat/*.o
+compat/*.mod.c
+compat/*.ko
+modules.order
+modules
+*.patch
diff --git a/Makefile b/Makefile
index 9215e6e..fdcff5c 100644
--- a/Makefile
+++ b/Makefile
@@ -20,37 +20,14 @@ export COMPAT_BASE_TREE_VERSION := "next-20100517"
 export COMPAT_VERSION := $(shell git describe)
 endif
 
-# This generates a bunch of CONFIG_COMPAT_KERNEL_2_6_22 CONFIG_COMPAT_KERNEL_3_0 .. etc for
-# each kernel release you need an object for.
-ifneq ($(wildcard $(KLIB_BUILD)/Makefile),)
+# to check config and compat autoconf
+export COMPAT_CONFIG=.config
+export COMPAT_AUTOCONF=include/linux/compat_autoconf.h
+export MAKE
 
-COMPAT_LATEST_VERSION = 3
-KERNEL_VERSION := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^\([0-9]\)\..*/\1/p')
-
-ifneq ($(KERNEL_VERSION),2)
-KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^3\.\([0-9]\+\).*/\1/p')
-else
-COMPAT_26LATEST_VERSION = 39
-KERNEL_26SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
-COMPAT_26VERSIONS := $(shell I=$(COMPAT_26LATEST_VERSION); while [ "$$I" -gt $(KERNEL_26SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
-$(foreach ver,$(COMPAT_26VERSIONS),$(eval export CONFIG_COMPAT_KERNEL_2_6_$(ver)=y))
-KERNEL_SUBLEVEL := -1
-endif
-
-COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
-$(foreach ver,$(COMPAT_VERSIONS),$(eval export CONFIG_COMPAT_KERNEL_3_$(ver)=y))
-
-endif
-
-ifeq ($(CONFIG_COMPAT_KERNEL_2_6_33),y)
-ifneq ($(CONFIG_FW_LOADER),)
- export CONFIG_COMPAT_FIRMWARE_CLASS=m
-endif
-endif
-
-ifeq ($(CONFIG_COMPAT_KERNEL_2_6_36),y)
- export CONFIG_COMPAT_KFIFO=m
-endif #CONFIG_COMPAT_KERNEL_2_6_36
+# Recursion lets us ensure we get this file included.
+# Trick is to run make -C $(PWD) modules later.
+-include $(PWD)/$(COMPAT_CONFIG)
 
 obj-y += compat/
 
@@ -65,15 +42,31 @@ NOSTDINC_FLAGS := -I$(M)/include/ \
 	-DCOMPAT_PROJECT="\"Generic kernel\"" \
 	-DCOMPAT_VERSION="\"$(COMPAT_VERSION)\""
 
-modules:
+all: $(COMPAT_CONFIG)
+
+modules: $(COMPAT_CONFIG) $(COMPAT_AUTOCONF)
 	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) modules
+	@touch modules
+
 install: modules
 	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) $(KMODDIR_ARG) $(KMODPATH_ARG) \
 		modules_install
 	depmod -a
-	@./scripts/compat_firmware_install
+	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) clean
+
+$(COMPAT_AUTOCONF): ;
+
+$(COMPAT_CONFIG):
+	@$(PWD)/scripts/gen-compat-config.sh > $(PWD)/$(COMPAT_CONFIG)
+	@$(PWD)/scripts/gen-compat-autoconf.sh $(COMPAT_CONFIG) > $(PWD)/$(COMPAT_AUTOCONF)
+	@$(MAKE) -C $(PWD) modules
+
+install: modules
+
 clean:
 	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) clean
-all: modules
 
 clean-files := Module.symvers modules.order Module.markers compat/modules.order
+clean-files += modules $(COMPAT_CONFIG) $(COMPAT_AUTOCONF)
+
+.PHONY: all install clean
diff --git a/include/linux/compat_autoconf.h b/include/linux/compat_autoconf.h
deleted file mode 100644
index 813755c..0000000
--- a/include/linux/compat_autoconf.h
+++ /dev/null
@@ -1,37 +0,0 @@
-#ifndef COMPAT_AUTOCONF_INCLUDED
-#define COMPAT_AUTOCONF_INCLUDED
-
-/*
- * This is an example of a compat autconf header file that gets
- * automatically generated by your projet. You will only need this
- * if you are working with a lot of config options.
- *
- * Your project will likely just override this, or leave this as-is.
- */
-
-/*
- * Example automatically generated C config: don't edit
- * Thu Dec 10 10:34:11 PST 2009 
- * compat-wireless-2.6: master-2009-11-19-5-gb4fd4dd
- * linux-2.6: next-20091208
- */
-//#define COMPAT_PROJECT_FOO_RELEASE "master-2009-11-19-5-gb4fd4dd"
-//#define COMPAT_UPSTREAM_FOO_KERNEL_RELEASE "next-20091208"
-
-/* Example kernel version minimum requirement */
-//#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,10))
-//#error Compat-wireless requirement: Linux >= 2,6,10
-//#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,10) */ 
-
-/* Example hard requirement */
-//#error Compat-wireless requirement: CONFIG_WIRELESS_EXT must be enabled in your kernel
-//#endif /* CONFIG_WIRELESS_EXT */
-
-/*
- * Example of how to match your external modules kconfig options into this.
- * You'll need something to generate this for you.
- */
-//#ifndef CONFIG_FOO_BAR
-//#define CONFIG_FOO_BAR 1
-
-#endif /* COMPAT_AUTOCONF_INCLUDED */
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
new file mode 100755
index 0000000..e52cc5a
--- /dev/null
+++ b/scripts/gen-compat-autoconf.sh
@@ -0,0 +1,105 @@
+#!/bin/bash
+#
+# Copyright 2012	Luis R. Rodriguez <mcgrof@frijolero.org>
+# Copyright 2011	Hauke Mehrtens <hauke@hauke-m.de>
+# Copyright 2011	John W. Linville <linville@tuxdriver.com>
+#
+# Use this to parse a small .config equivalent looking file to generate
+# our own autoconf.h. This file has defines for each config option
+# just like the kernels include/linux/autoconf.h
+#
+# XXX: consider using scripts/kconfig/confdata.c instead.
+# On the downside this would require the user to have libc though.
+
+# This indicates which is the oldest kernel we support
+# Update this if you are adding support for older kernels.
+OLDEST_KERNEL_SUPPORTED="2.6.24"
+
+if [ $# -ne 1 ]; then
+	echo "Usage $0 config-file"
+	exit
+fi
+
+COMPAT_CONFIG="$1"
+
+if [ ! -f $COMPAT_CONFIG ]; then
+	echo "File $1 is not a file"
+	exit
+fi
+
+# Defines a CONFIG_ option if not defined yet, this helps respect
+# linux/autoconf.h
+function define_config {
+	VAR=$1
+	VALUE=$2
+	case $VALUE in
+	n) # Try to undefine it
+		echo "#undef $VAR"
+		;;
+	y)
+		echo "#ifndef $VAR"
+		echo "#define $VAR 1"
+		echo "#endif /* $VAR */"
+		;;
+	m)
+		echo "#ifndef $VAR"
+		echo "#define $VAR 1"
+		echo "#endif /* $VAR */"
+		;;
+	*) # Assume string
+		# XXX: add better checks to make sure what was on
+		# the right was indeed a string
+		echo "#ifndef $VAR"
+		echo "#define $VAR \"$VALUE\""
+		echo "#endif /* $VAR */"
+		;;
+	esac
+}
+
+function kernel_version_req {
+	VERSION=$(echo $1 | sed -e 's/\./,/g')
+	echo "#if (LINUX_VERSION_CODE < KERNEL_VERSION($VERSION))"
+	echo "#error compat requirement: Linux >= $VERSION"
+	echo "#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION($VERSION) */"
+}
+
+cat <<EOF
+#ifndef COMPAT_AUTOCONF_INCLUDED
+#define COMPAT_AUTOCONF_INCLUDED
+/*
+ * Automatically generated C config: don't edit
+ */
+EOF
+
+# Checks user is compiling against a kernel we support
+kernel_version_req $OLDEST_KERNEL_SUPPORTED
+
+# For each CONFIG_FOO=x option
+for i in $(egrep '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else #CONFIG_' $COMPAT_CONFIG | sed 's/ /+/'); do
+	case $i in
+	'ifdef+CONFIG_'* )
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_3_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(3,\2,0))/' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/' -e 's/\(ifdef CONFIG_COMPAT_RHEL_\)\([0-9]*\)_\([0-9]*\)/if (defined(RHEL_MAJOR) \&\& RHEL_MAJOR == \2 \&\& RHEL_MINOR >= \3)/' -e 's/\(#ifdef \)\(CONFIG_[^:space:]*\)/#if defined(\2) || defined(\2_MODULE)/'
+		continue
+		;;
+	'ifndef+CONFIG_'* )
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_3_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,\2,0))/' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(ifndef CONFIG_COMPAT_RHEL_\)\([0-9]*\)_\([0-9]*\)/if (!defined(RHEL_MAJOR) || RHEL_MAJOR != \2 || RHEL_MINOR < \3)/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) \&\& !defined(\2_MODULE)/'
+		continue
+		;;
+	'else+#CONFIG_'* | 'endif+#CONFIG_'* )
+		echo "#$i */" |sed -e 's/+#/ \/* /g'
+		continue
+		;;
+	CONFIG_* )
+		# Get the element on the left of the "="
+		VAR=$(echo $i | cut -d"=" -f 1)
+		# Get the element on the right of the "="
+		VALUE=$(echo $i | cut -d"=" -f 2)
+
+		# Any other module which can *definitely* be built as a module goes here
+		define_config $VAR $VALUE
+		continue
+		;;
+	esac
+done
+
+echo "#endif /* COMPAT_AUTOCONF_INCLUDED */"
diff --git a/scripts/gen-compat-config.sh b/scripts/gen-compat-config.sh
new file mode 100755
index 0000000..82b439c
--- /dev/null
+++ b/scripts/gen-compat-config.sh
@@ -0,0 +1,50 @@
+#!/bin/bash
+# Copyright 2012        Luis R. Rodriguez <mcgrof@frijolero.org>
+# Copyright 2012        Hauke Mehrtens <hauke@hauke-m.de>
+#
+# This generates a bunch of CONFIG_COMPAT_KERNEL_2_6_22
+# CONFIG_COMPAT_KERNEL_3_0 .. etc for each kernel release you need an object
+# for.
+#
+# Note: this is part of the compat.git project, not compat-wireless.git,
+# send patches against compat.git.
+
+if [[ ! -f ${KLIB_BUILD}/Makefile ]]; then
+	exit
+fi
+
+# Actual kernel version
+KERNEL_VERSION=$(${MAKE} -C ${KLIB_BUILD} kernelversion | sed -n 's/^\([0-9]\)\..*/\1/p')
+
+# 3.0 kernel stuff
+COMPAT_LATEST_VERSION="3"
+KERNEL_SUBLEVEL="-1"
+
+# This allows all these variables to be propagated through
+# all of our Makefiles
+echo export
+
+if [[ ${KERNEL_VERSION} -eq "3" ]]; then
+	KERNEL_SUBLEVEL=$(${MAKE} -C ${KLIB_BUILD} kernelversion | sed -n 's/^3\.\([0-9]\+\).*/\1/p')
+else
+	COMPAT_26LATEST_VERSION="39"
+	KERNEL_26SUBLEVEL=$(${MAKE} -C ${KLIB_BUILD} kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
+	let KERNEL_26SUBLEVEL=${KERNEL_26SUBLEVEL}+1
+
+	for i in $(seq ${KERNEL_26SUBLEVEL} ${COMPAT_26LATEST_VERSION}); do
+		echo "CONFIG_COMPAT_KERNEL_2_6_${i}=y"
+	done
+fi
+
+let KERNEL_SUBLEVEL=${KERNEL_SUBLEVEL}+1
+for i in $(seq ${KERNEL_SUBLEVEL} ${COMPAT_LATEST_VERSION}); do
+	echo "CONFIG_COMPAT_KERNEL_3_${i}=y"
+done
+
+if [[ ${CONFIG_COMPAT_KERNEL_2_6_33} -eq "y" ]]; then
+	echo "CONFIG_COMPAT_FIRMWARE_CLASS=m"
+fi
+
+if [[ ${CONFIG_COMPAT_KERNEL_2_6_36} -eq "y" ]]; then
+	echo "CONFIG_COMPAT_KFIFO=m"
+fi
-- 
1.7.4.15.g7811d

