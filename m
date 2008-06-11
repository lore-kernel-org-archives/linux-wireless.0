Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:36621 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbYFKUCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 16:02:37 -0400
Date: Wed, 11 Jun 2008 16:02:32 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	compat-masters@lists.madwifi.org,
	Tim Gardner <tim.gardner@canonical.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: [compat-masters] Backported MQ requirement on 802.11n for older kernels
Message-ID: <20080611200232.GH17936@ruslug.rutgers.edu> (sfid-20080611_220242_528850_004C8CE4)
References: <43e72e890806090325y5a1aebadq68204695044f4b6f@mail.gmail.com> <1ba2fa240806101657w14599f30x67f58acbc7fe9e80@mail.gmail.com> <43e72e890806102132q1aaba42ehd76bdd30b8d4080a@mail.gmail.com> <43e72e890806102136jb8e695fla98a8594dde14396@mail.gmail.com> <43e72e890806110403nddfca7cn66b91a938919e1f0@mail.gmail.com> <7ba851519c84785f96af3637e9bab65b.squirrel@secure.sipsolutions.net> <20080611125857.GG17936@ruslug.rutgers.edu> <1ba2fa240806110627g467940b1k9ca4a43cd140506f@mail.gmail.com> <43e72e890806110646o439c1620t204e68034434968d@mail.gmail.com> <43e72e890806110749q25a2490dm325f21554409925e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890806110749q25a2490dm325f21554409925e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 07:49:15AM -0700, Luis R. Rodriguez wrote:
> 
> OK the issue is very likely that the compat_autoconf.h is leaving
> CONFIG_MAC80211_QOS enabled as the script used to generate it detects
> all ^CONFIG_FOO options. I'm working on this, should have a patch soon
> for you to review.

Issue fixed and pushed out. compat-wireless is on 4.5 now.

CONFIG_MAC80211_QOS is required for 802.11e (WME) and 802.11n (HT).
Also CONFIG_MAC80211_QOS won't be in kernels until 2.6.27, but
it does have its requirements. It requires *both* CONFIG_NETDEVICES_MULTIQUEUE
and CONFIG_NET_SCHED. Lets deal with these requirements and also
handle them specially in the compat_autoconf.h

This should fix some issues with unresolved symbols when CONFIG_MAC80211_QOS
is disabled. The problem was compat_autoconf wasn't disabling it.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Makefile                       |    2 +-
 config.mk                      |   33 ++++++++++++++++++++++------
 scripts/gen-compat-autoconf.sh |   46 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index e905402..c14e45d 100644
--- a/Makefile
+++ b/Makefile
@@ -5,7 +5,7 @@ KMODPATH_ARG:=  "INSTALL_MOD_PATH=$(KLIB)"
 else
 KLIB:=          /lib/modules/$(shell uname -r)
 endif
-KLIB_BUILD ?=	$(KLIB)/build
+export KLIB_BUILD ?=	$(KLIB)/build
 # Sometimes not available in the path
 MODPROBE := /sbin/modprobe
 MADWIFI=$(shell $(MODPROBE) -l ath_pci)
diff --git a/config.mk b/config.mk
index 66a1244..905313d 100644
--- a/config.mk
+++ b/config.mk
@@ -17,23 +17,42 @@ endif
 CONFIG_MAC80211=y
 
 # Enable QOS for 2.6.22, we'll do some hacks here to enable it.
-# You will need this for HT support (802.11n).
+# You will need this for HT support (802.11n) and WME (802.11e).
 # If you are >= 2.6.23 we'll only warn when you don't have MQ support
-# enabled, but maybe we should just exit, as I suspect everyone using
-# this package may want it enabled... hmm
+# or NET_SCHED enabled.
+#
+# We could consider just quiting if MQ and NET_SCHED is disabled
+# as I suspect all users of this package want 802.11e (WME) and
+# 802.11n (HT) support.
 ifeq ($(shell test -e $(KLIB_BUILD)/Makefile && echo yes),yes)
 KERNEL_SUBLEVEL = $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
 ifeq ($(shell test $(KERNEL_SUBLEVEL) -lt 23 && echo yes),yes)
 CONFIG_MAC80211_QOS=y
 else
-ifeq ($(CONFIG_NETDEVICES_MULTIQUEUE),)
-$(warning "WARNING: You are running a kernel >= 2.6.23, you should enable CONFIG_NETDEVICES_MULTIQUEUE for 802.11n support")
-else
-CONFIG_MAC80211_QOS=y
+
+# we're in a kernel >= 2.6.23
+
+ifneq ($(KERNELRELEASE),) # This prevents a warning
+
+ifeq ($(CONFIG_NETDEVICES_MULTIQUEUE),) # checks MQ first
+ QOS_REQS_MISSING+=CONFIG_NETDEVICES_MULTIQUEUE
 endif
+
+ifeq ($(CONFIG_NET_SCHED),)
+ QOS_REQS_MISSING+=CONFIG_NET_SCHED
 endif
+
+ifeq ($(QOS_REQS_MISSING),) # if our dependencies match for MAC80211_QOS
+CONFIG_MAC80211_QOS=y
+else # Complain about our missing dependencies
+$(warning "WARNING: You are running a kernel >= 2.6.23, you should enable in it $(QOS_REQS_MISSING) for 802.11[ne] support")
 endif
 
+endif # In build module mode
+
+endif # kernel release check
+endif # kernel Makefile check
+
 CONFIG_MAC80211_RC_DEFAULT=pid
 CONFIG_MAC80211_RC_PID=y
 
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 173431f..57065a8 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -14,6 +14,7 @@
 OLDEST_KERNEL_SUPPORTED="2.6.21"
 COMPAT_RELEASE="compat-release"
 KERNEL_RELEASE="git-describe"
+MULT_DEP_FILE=".compat_pivot_dep"
 
 if [ $# -ne 1 ]; then
 	echo "Usage $0 config-file"
@@ -93,6 +94,28 @@ function define_config_dep {
 	echo "#endif /* $WARN_VAR */"
 }
 
+# This handles options which have *multiple* dependencies from the kernel
+function define_config_multiple_deps {
+	VAR=$1
+	VALUE=$2
+	DEP_ARRAY=$3
+
+	# First, put all ifdefs
+	for i in $(cat $MULT_DEP_FILE); do
+		echo "#ifdef $i"
+	done
+
+	# Now put our option in the middle
+	define_config $VAR $VALUE
+
+	# Now close all ifdefs
+	# First, put all ifdefs
+	for i in $(cat $MULT_DEP_FILE); do
+		echo "#endif"
+	done
+
+}
+
 function kernel_version_req {
 	VERSION=$(echo $1 | sed -e 's/\./,/g')
 	echo "#if (LINUX_VERSION_CODE < KERNEL_VERSION($VERSION))"
@@ -140,9 +163,32 @@ for i in $(grep '^CONFIG_' $COMPAT_CONFIG); do
 	CONFIG_USB_NET_RNDIS_HOST)
 		define_config_dep $VAR $VALUE CONFIG_USB_NET_CDCETHER
 		continue
+		;;
+	# ignore this, we have a special hanlder for this at the botttom
+	# instead. We still need to keep this in config.mk to let Makefiles
+	# know its enabled so just ignore it here.
+	CONFIG_MAC80211_QOS)
+		continue
+		;;
 	esac
 	# Any other module which can *definitely* be built as a module goes here
 	define_config $VAR $VALUE
 done
 
+# Deal with special cases. CONFIG_MAC80211_QOS is such a case.
+# We handle this specially for different kernels we support.
+if [ -f $KLIB_BUILD/Makefile ]; then
+	SUBLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
+	if [ $SUBLEVEL -le 22 ]; then
+		define_config CONFIG_MAC80211_QOS y
+	else # kernel >= 2.6.23
+		# CONFIG_MAC80211_QOS on these kernels requires
+		# CONFIG_NET_SCHED and CONFIG_NETDEVICES_MULTIQUEUE
+		rm -f $MULT_DEP_FILE
+		echo CONFIG_NET_SCHED >> $MULT_DEP_FILE
+		echo CONFIG_NETDEVICES_MULTIQUEUE >> $MULT_DEP_FILE
+		define_config_multiple_deps CONFIG_MAC80211_QOS y $ALL_DEPS
+		rm -f $MULT_DEP_FILE
+	fi
+fi
 echo "#endif /* COMPAT_AUTOCONF_INCLUDED */"
-- 
1.5.4.3

