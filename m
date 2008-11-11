Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28720 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbYKKXMl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 18:12:41 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2008 15:12:41 -0800
Date: Tue, 11 Nov 2008 15:12:33 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hin-Tak Leung <htl10@users.sourceforge.net>
CC: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	"compat-masters@lists.madwifi.org" <compat-masters@lists.madwifi.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: a couple of small bugs in compat-wireless
Message-ID: <20081111231233.GK14202@tesla> (sfid-20081112_001245_721463_7DD0F88F)
References: <252423.50522.qm@web23105.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <252423.50522.qm@web23105.mail.ird.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 10, 2008 at 09:28:59PM -0800, Hin-Tak Leung wrote:
> "make unload" doesn't unload iwlagn, and iwlagn keeps mac80211 in the kernel, which results in make unload failing. Needs to include iwlagn
> in the unload list in script/unload.sh. Should be trivial to fix, and
> probably quicker "just do it" then having a patch from me :-).
> 
> There is another annoyance - probably not strictly speaking a bug, but nonetheless, for some unexplainable reasons, I expect "make clean" to do the usual thing, and it doesn't - this is probably easy to fix by having an almost empty libertas_tf/Makefile ? (this shows an older compat-wireless , but current compat-wireless also seem to have this problem
> if I remember correctly):
> ---------------
> scripts/Makefile.clean:17: /tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf/Makefile: No such file or directory
> make[4]: *** No rule to make target `/tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf/Makefile'.  Stop.
> make[3]: *** [/tmp/compat-wireless-2008-10-23/drivers/net/wireless/libertas_tf] Error 2
> make[2]: *** [/tmp/compat-wireless-2008-10-23/drivers/net/wireless] Error 2
> make[1]: *** [_clean_/tmp/compat-wireless-2008-10-23] Error 2
> make[1]: Leaving directory `/usr/src/kernels/2.6.27.5-92.fc10.x86_64'
> make: *** [clean] Error 2
> ---------------

Try this patch, but the issue you see is related to libertas... anyway,
I've added this patch I'll try to see what's wrong with libertas.

  Luis

From: Luis R. Rodriguez <lrodriguez@atheros.com>
[PATCH] Add iwl-load, and make sure we disable iwl4965 upon install

We now has two drivers for different kernel releases for
the Intel 4965 device. To account for this we add a script
to allow us to disable and enable one or each other.
By default we disable iwl4965 as we are replacing it with
iwlagn.

If you want to enable iwl4965:

iwl-load iwl4965

If you want to enable iwlagn:

iwl-load iwlagn

By default we'll use iwlagn.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Makefile           |   14 ++++++++++++
 scripts/iwl-enable |   47 ++++++++++++++++++++++++++++++++++++++++++
 scripts/iwl-load   |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+), 0 deletions(-)
 create mode 100755 scripts/iwl-enable
 create mode 100755 scripts/iwl-load

diff --git a/Makefile b/Makefile
index c0ccbd5..7383214 100644
--- a/Makefile
+++ b/Makefile
@@ -9,6 +9,7 @@ export KLIB_BUILD ?=	$(KLIB)/build
 # Sometimes not available in the path
 MODPROBE := /sbin/modprobe
 MADWIFI=$(shell $(MODPROBE) -l ath_pci)
+OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
 
 ifneq ($(KERNELRELEASE),)
 
@@ -67,8 +68,10 @@ install: uninstall modules
 	@# This is to allow switching between drivers without blacklisting
 	@install scripts/athenable	/usr/sbin/
 	@install scripts/b43enable	/usr/sbin/
+	@install scripts/iwl-enable	/usr/sbin/
 	@install scripts/athload	/usr/sbin/
 	@install scripts/b43load	/usr/sbin/
+	@install scripts/iwl-load	/usr/sbin/
 	@if [ ! -z $(MADWIFI) ]; then \
 		echo ;\
 		echo -n "Note: madwifi detected, we're going to disable it. "  ;\
@@ -79,6 +82,15 @@ install: uninstall modules
 		/usr/sbin/athenable ath5k ;\
 	fi
 	@/sbin/depmod -ae
+	@if [ ! -z $(OLD_IWL) ]; then \
+		echo ;\
+		echo -n "Note: iwl4965 detected, we're going to disable it. "  ;\
+		echo "If you would like to enable it later you can run:"  ;\
+		echo "    sudo iwl-load iwl4965"  ;\
+		echo ;\
+		echo Running iwl-enable iwlagn...;\
+		/usr/sbin/iwl-enable iwlagn ;\
+	fi
 	@echo
 	@echo "Currently detected wireless subsystem modules:"
 	@echo 
@@ -95,6 +107,7 @@ install: uninstall modules
 	@$(MODPROBE) -l ssb
 	@$(MODPROBE) -l iwl3945
 	@$(MODPROBE) -l iwl4965
+	@$(MODPROBE) -l iwlagn
 	@$(MODPROBE) -l ipw2100
 	@$(MODPROBE) -l ipw2200
 	@$(MODPROBE) -l ieee80211
@@ -153,6 +166,7 @@ uninstall:
 	@$(MODPROBE) -l rc80211_simple
 	@$(MODPROBE) -l iwl3945
 	@$(MODPROBE) -l iwl4965
+	@$(MODPROBE) -l iwlagn
 	@$(MODPROBE) -l ipw2100
 	@$(MODPROBE) -l ipw2200
 	@$(MODPROBE) -l ieee80211
diff --git a/scripts/iwl-enable b/scripts/iwl-enable
new file mode 100755
index 0000000..1236deb
--- /dev/null
+++ b/scripts/iwl-enable
@@ -0,0 +1,47 @@
+#!/bin/bash
+#
+# Copyright 2007	Luis R. Rodriguez <lrodriguez@atheros.com>
+#
+# Makes sure either iwlagn (new) or iwl4965 (old)
+# is enabled to be used. This allows us to choose any driver without 
+# blacklisting each other.
+
+. /usr/lib/compat-wireless/modlib.sh
+
+if [[ $UID -ne 0 ]]; then
+	echo "Run with root privileges"
+	exit
+fi
+
+IWL_NEW="iwlagn"
+IWL_OLD="iwl4965"
+
+# Appended to module file at the end when we want to ignore one
+USAGE="Usage: $0 [ $IWL | $IWL_OLD ]"
+
+function enable_iwlagn {
+	module_disable $IWL_OLD
+	for i in $IWL_NEW; do
+		module_enable $i
+	done
+}
+
+# Default behavior: disables the old iwl4965 driver and enables iwlagn
+if [ $# -eq 0 ]; then
+	enable_iwlagn
+	exit
+elif [ $# -ne 1 ]; then
+	echo "$USAGE"
+	exit
+fi
+
+MODULE=$1
+if [ "$MODULE" == "iwl4954" ]; then
+	module_disable $IWL_NEW
+	module_enable $IWL_OLD
+elif [ "$MODULE" == "iwlagn" ]; then
+	enable_iwlagn
+else
+	echo "$USAGE"
+	exit
+fi
diff --git a/scripts/iwl-load b/scripts/iwl-load
new file mode 100755
index 0000000..96b6d89
--- /dev/null
+++ b/scripts/iwl-load
@@ -0,0 +1,58 @@
+#!/bin/bash
+# Copyright 2008	Luis R. Rodriguez <lrodriguez@atheros.com>
+#
+# Loads new Intel iwl (iwlagn) or the old ones (iwl4965)
+
+. /usr/lib/compat-wireless/modlib.sh
+
+IWL_OLD="iwl4965"
+IWL_NEW="iwlagn"
+
+if [[ $UID -ne 0 ]]; then
+	echo "Run with root privileges"
+	exit
+fi
+
+
+USAGE="Usage: $0 [ iwlagn | iwl4965 ]"
+
+# Default behavior: unload iwl4965 and load iwlagn
+if [ $# -eq 0 ]; then
+	1=iwlagn
+elif [ $# -ne 1 ]; then
+	echo "$USAGE"
+	exit
+fi
+
+MODULE=$1
+if [ "$MODULE" == "iwlagn" ]; then
+        grep iwl4965 /proc/modules 2>&1 > /dev/null
+        if [ $? -eq 0 ]; then
+                echo Unloading $i...
+		modprobe -r --ignore-remove iwl4965
+        fi
+	# Enables both b43 and b43legacy
+	iwl-enable iwlagn
+	modprobe iwlagn
+	CHECK=`modprobe -l iwlagn`
+	if [ ! -z $CHECK ]; then
+		echo "iwlagn loaded successfully"
+	fi
+elif [ "$MODULE" == "iwl4965" ]; then
+	CHECK=`modprobe -l iwlagn`
+	if [ ! -z $CHECK ]; then
+		echo "iwlagn currently loaded, going to try to unload the module..."
+		modprobe -r --ignore-remove iwlagn
+	fi
+	iwl-enable iwl4965
+	# iwl4965 may be loaded already lets remove it first
+	modprobe -r --ignore-remov iwl4965 2>&1 > /dev/null
+	modprobe iwl4965
+	CHECK=`modprobe -l iwl4965`
+	if [ ! -z $CHECK ]; then
+		echo "iwl4965 loaded successfully!"
+	fi
+else
+	echo "$USAGE"
+	exit
+fi
-- 
1.5.6.rc2.15.g457bb.dirty

