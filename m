Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53968 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab2HFSdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 14:33:38 -0400
Received: by eeil10 with SMTP id l10so942345eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 11:33:36 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat-wireless: Rename compat-wireless to compat-drivers
Date: Mon,  6 Aug 2012 21:33:29 +0300
Message-Id: <1344278009-31784-1-git-send-email-ozancag@gmail.com> (sfid-20120806_203347_967623_687EA421)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This first patch touches mostly cosmetic parts to change
compat-wireless -> compat-drivers.

GIT URL's describing compat-wireless.git are not changed
for now as the git repo in github is still compat-wireless.git.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 Makefile                       | 10 +++----
 README                         | 61 +++++++++++++++++++-----------------------
 config.mk                      | 11 ++++----
 crap/README                    |  2 +-
 enable-older-kernels/README    |  6 ++---
 linux-next-cherry-picks/README |  4 +--
 linux-next-pending/README      |  4 +--
 patches/README                 |  2 +-
 pending-stable/README          |  2 +-
 scripts/admin-update.sh        | 18 ++++++-------
 scripts/athenable              |  2 +-
 scripts/athload                |  2 +-
 scripts/b43enable              |  2 +-
 scripts/b43load                |  2 +-
 scripts/check_config.sh        |  4 +--
 scripts/check_depmod           |  4 +--
 scripts/driver-select          |  8 +++---
 scripts/gen-compat-autoconf.sh | 12 ++++-----
 scripts/gen-stable-release.sh  | 10 +++----
 scripts/iwl-enable             |  2 +-
 scripts/iwl-load               |  2 +-
 scripts/refresh-compat         |  4 +--
 scripts/refresh-compat-local   |  2 +-
 23 files changed, 85 insertions(+), 91 deletions(-)

diff --git a/Makefile b/Makefile
index 4471cf5..5fee583 100644
--- a/Makefile
+++ b/Makefile
@@ -66,7 +66,7 @@ export PWD :=	$(shell pwd)
 
 # The build will fail if there is any space in PWD.
 ifneq (,$(findstring  $() ,$(PWD)))
-$(error "The path to this compat-wireless directory has spaces in it." \
+$(error "The path to this compat-drivers directory has spaces in it." \
 	"Please put it somewhere where there is no space")
 endif
 
@@ -74,7 +74,7 @@ export CFLAGS += \
         -DCOMPAT_BASE="\"$(shell cat $(PWD)/.compat_base)\"" \
         -DCOMPAT_BASE_TREE="\"$(shell cat $(PWD)/.compat_base_tree)\"" \
         -DCOMPAT_BASE_TREE_VERSION="\"$(shell cat $(PWD)/.compat_base_tree_version)\"" \
-        -DCOMPAT_PROJECT="\"Compat-wireless\"" \
+        -DCOMPAT_PROJECT="\"Compat-drivers\"" \
         -DCOMPAT_VERSION="\"$(shell cat $(PWD)/.compat_version)\""
 
 # These exported as they are used by the scripts
@@ -103,7 +103,7 @@ bt: $(CREL_CHECK)
 # We use a CREL_CHECK variable which will depend on the environment used to
 # build. If the environment requirements change it forces a reconfiguration
 # check.  This means we force a new reconfiguration check if a the user gets a
-# new updates of compat-wireless or when the user updates the $(COMPAT_CONFIG)
+# new updates of compat-drivers or when the user updates the $(COMPAT_CONFIG)
 # file.
 # XXX: add kernel target to the CREL_CHECK mix, this would ensure we also
 # reconfigure and build again fresh if we detect a new target kernel is
@@ -152,8 +152,8 @@ install-modules: modules
 
 install-scripts:
 	@# All the scripts we can use
-	@mkdir -p $(DESTDIR)/usr/lib/compat-wireless/
-	@install scripts/modlib.sh	$(DESTDIR)/usr/lib/compat-wireless/
+	@mkdir -p $(DESTDIR)/usr/lib/compat-drivers/
+	@install scripts/modlib.sh	$(DESTDIR)/usr/lib/compat-drivers/
 	@install scripts/madwifi-unload	$(DESTDIR)/usr/sbin/
 	@# This is to allow switching between drivers without blacklisting
 	@install scripts/athenable	$(DESTDIR)/usr/sbin/
diff --git a/README b/README
index 7f0ddff..6878dab 100644
--- a/README
+++ b/README
@@ -41,8 +41,8 @@ Versions
 --------
 
 There are two different versions of this package available. 
- * Version based on latest linux-next.git tree named compat-wireless-YYYY-MM-DD.tar.bz2
- * Version based on linux-2.6-stable.git tree named compat-wireless-2.6.CC.DD.tar.bz2
+ * Version based on latest linux-next.git tree named compat-drivers-YYYY-MM-DD.tar.bz2
+ * Version based on linux-stable.git tree named compat-drivers-{2.6.x, 3.x}.CC.DD.tar.bz2
 
 Both versions should work for every kernel > 2.6.24. The differences are the
 code they are containing. The version based on linux-next.git contains the
@@ -233,7 +233,7 @@ Building for external kernels
 ----------------------------------
 
 If you have a kernel you do not have installed but yet want to build the
-compat-wireless-2.6 drivers for it you can use this syntax:
+compat-drivers for it you can use this syntax:
 
 make KLIB=/home/mcgrof/kernels/linux-2.6.23.9 KLIB_BUILD=/home/mcgrof/kernels/linux-2.6.23.9
 
@@ -284,39 +284,39 @@ An extended and more up to date version can be found at:
 
 http://wireless.kernel.org/en/users/Download/hacking
 
-This section deals with development details of compat-wireless and the other
-trees it uses. If you want to make your own compat-wireless tarballs, or if you
-see something busted with compat-wireless or just want to add something new or
+This section deals with development details of compat-drivers and the other
+trees it uses. If you want to make your own compat-drivers tarballs, or if you
+see something busted with compat-drivers or just want to add something new or
 an enhancement this is the guide for you.
 
 Git trees you will need
 -----------------------
 
-compat-wireless backports both the bluetooth and 802.11 subsystems down to older
-kernels. To be able to synchronize backporting the latest and greatest the
+compat-drivers backports bluetooth, 802.11 and DRM subsystems down to older
+kernels. To be able to synchronize backporting the latest and greatest, the
 linux-next.git tree is used as its main source for kernel updates. General Linux
 kernel compatibility is addressed through a general kernel compatibility tree,
-compat.git. compat-wireless then has its own tree for specific wireless
+compat.git. compat-drivers then has its own tree for specific subsystem
 compatibility. You will then need to checkout three trees to start hacking on
-compat-wireless:
+compat-drivers:
 
 git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
 git://github.com/mcgrof/compat.git
 git://github.com/mcgrof/compat-wireless.git
 
-Linux next
+linux-next
 ----------
 
 The linux-next.git tree brings all subsystems being worked on for the next
-kernel release into one tree. So if the current rc kernel is 2.6.33-rc5, this
-means linux-next will have what people today are working on for the 2.6.34
+kernel release into one tree. So if the current rc kernel is 3.5-rc1, this
+means linux-next will have what people today are working on for the 3.6
 kernel release.
 
 compat.git
 ----------
 
 The compat git tree is a general kernel compatibility layer which can be shared
-amongst different compatibility projects, or drivers. compat-wireless is just
+amongst different compatibility projects, or drivers. compat-drivers is just
 one of the kernel compatibility projects using compat.git. compat.git builds a
 general compatibility module, compat, and any additional modules to let you get
 new general kernel updates from future kernels on your old kernels.
@@ -350,24 +350,24 @@ request_firmware_nowait(). The compat_firmware_class module registers its own
 sysfs subsystem and as such also gets udev events sent through a separate
 subsystem. Because of this a new udev rules file is required and provided.
 
-compat-wireless.git
+compat-drivers.git
 -------------------
 
-Anything that is not general kernel compatibility but instead specific to 802.11
-or bluetooth goes into compat-wireless.git. After you've cloned all three trees,
-linux-next.git, compat.git and compat-wireless.git you need to change into the
-compat-wireless directory and tell compat-wireless where you linux-next and
-compat.git trees are. You do this with environment variables GIT_TREE and
-GIT_COMPAT_TREE. You can do for example:
+Anything that is not general kernel compatibility but instead specific to
+subsystems like 802.11, bluetooth, or DRM goes into compat-drivers.git.
+After you've cloned all three trees linux-next.git, compat.git and compat-drivers.git
+you need to change into the compat-drivers directory and tell compat-drivers
+where your linux-next and compat.git trees are. You do this with environment
+variables GIT_TREE and GIT_COMPAT_TREE. You can do for example:
 
-export GIT_TREE=/home/user/wireless-testing/
-export GIT_COMPAT_TREE=/home/users/compat.git/
+export GIT_TREE=/home/mcgrof/linux-next
+export GIT_COMPAT_TREE=/home/mcgrof/compat
 
 Then you can update your local sources based on these linux-next.git and
 compat.git trees:
 
-scripts/admin-clean.sh   - Cleans the compat-wireless-2.6 tree
-scripts/admin-update.sh  - Updates compat-wireless-2.6 with your git tree
+scripts/admin-clean.sh   - Cleans the compat-drivers tree
+scripts/admin-update.sh  - Updates compat-drivers with your git trees
 scripts/admin-refresh.sh - Does the above two
 
 Adding new drivers
@@ -390,7 +390,7 @@ As another example, for bluetooth you will want to send them to Marcel
 Holtmann and cc the linux-bluetooth mailing list. If your patch touches on
 others areas of the kernel refer to the MAINTAINERS file on the kernel.
 
-For compat.git and compat-wireless.git please send patches against to:
+For compat.git and compat-drivers.git please send patches against to:
 
 To: Luis R. Rodriguez <mcgrof@kernel.org>
 CC: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
@@ -400,17 +400,10 @@ For patches for compat.git please use a subject like the following:
 
 Subject: [PATCH] compat: fix foo
 
-For compat-wireless.git please use a subject like the following:
+For 802.11 and bluetooth specific stuff please use a subject like the following:
 
 Subject: [PATCH] compat-wireless: fix foo
 
 Patches are preferred sent with a clear commit log entry, if unfamiliar with
 how to send patches please refer to
 http://wireless.kernel.org/en/developers/Documentation/git-guide.
-
-
-TODO
------
- * Dialog (make menuconfig) option for this package
- * Compatibility work for 2.6.18 --> 2.6.24
-
diff --git a/config.mk b/config.mk
index 2d797c0..4b46912 100644
--- a/config.mk
+++ b/config.mk
@@ -17,8 +17,9 @@ else
 KERNEL_26SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
 endif
 
+# FIXME: This lower limit is different (e.g. 3.0) for DRM stuff.
 ifdef CONFIG_COMPAT_KERNEL_2_6_24
-$(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
+$(error "ERROR: compat-drivers by default supports kernels >= 2.6.24, try enabling only one driver though")
 endif #CONFIG_COMPAT_KERNEL_2_6_24
 
 ifeq ($(CONFIG_CFG80211),y)
@@ -76,7 +77,7 @@ endif
 endif # build check
 endif # kernel Makefile check
 
-# These both are needed by compat-wireless || compat-bluetooth so enable them
+# These both are needed by 802.11 and bluetooth so enable
  export CONFIG_COMPAT_RFKILL=y
 
 ifeq ($(CONFIG_MAC80211),y)
@@ -165,7 +166,7 @@ endif #CONFIG_COMPAT_KERNEL_2_6_33
 export CONFIG_MAC80211_RC_DEFAULT=minstrel_ht
 export CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
 # export CONFIG_MAC80211_RC_DEFAULT_PID=y
-# This is the one used by our compat-wireless net/mac80211/rate.c
+# This is the one used by our compat-drivers net/mac80211/rate.c
 # in case you have and old kernel which is overriding this to pid.
 export CONFIG_COMPAT_MAC80211_RC_DEFAULT=minstrel_ht
 export CONFIG_MAC80211_RC_PID=y
@@ -228,8 +229,8 @@ endif #CONFIG_PCMCIA
 
 # We need CONFIG_WIRELESS_EXT for CONFIG_CFG80211_WEXT for every kernel 
 # version. The new way CONFIG_CFG80211_WEXT is called from the kernel 
-# does not work with compat-wireless because it calls some callback 
-# function on struct wiphy. This struct is shipped with compat-wireless 
+# does not work with compat-drivers because it calls some callback
+# function on struct wiphy. This struct is shipped with compat-drivers
 # and changes from kernel version to version. We are using the 
 # wireless_handlers attribute which will be activated by 
 # export CONFIG_WIRELESS_EXT. 
diff --git a/crap/README b/crap/README
index c1b512e..ff1ae85 100644
--- a/crap/README
+++ b/crap/README
@@ -1,5 +1,5 @@
 
-compat-wireless crap patches
+compat-drivers crap patches
 ============================
 
 If you are including patches into this directory you
diff --git a/enable-older-kernels/README b/enable-older-kernels/README
index 2069ce4..c26e35a 100644
--- a/enable-older-kernels/README
+++ b/enable-older-kernels/README
@@ -1,12 +1,12 @@
-compat-wireless as a whole aims to always be compiled and used with the
+compat-drivers as a whole aims to always be compiled and used with the
 oldest stable kernel supported by kernel.org. This will be the oldest
 stable kernel on the 2.6. series listed on the kernel.org front page.
 Sometimes we'll go even beyond that.
 
-Backporting compat-wireless involves backporting some subsystems but
+Backporting compat-drivers involves backporting some subsystems but
 at times we may want to support compiling only certain drivers on older
 kernels since its easier to backport some subsystems. Such is the case
 with PCI drivers. This directly exists to allow developers enable
-compilation of compat-wireless on older drivers using ./scripts/driver-select
+compilation of compat-drivers on older drivers using ./scripts/driver-select
 Upon selection of a driver a patch from this directly will be applied to
 allow further compilation of one driver onto even older kernels.
diff --git a/linux-next-cherry-picks/README b/linux-next-cherry-picks/README
index b7f5b18..101a51a 100644
--- a/linux-next-cherry-picks/README
+++ b/linux-next-cherry-picks/README
@@ -1,5 +1,5 @@
-compat-wireless linux-next chery picked patches
-===============================================
+compat-drivers linux-next chery picked patches
+==============================================
 
 We work hard to get patches in time onto the stable
 tree but sometimes a few things slip out, and sometimes a
diff --git a/linux-next-pending/README b/linux-next-pending/README
index c80d868..092fc5f 100644
--- a/linux-next-pending/README
+++ b/linux-next-pending/README
@@ -1,5 +1,5 @@
 
-compat-wireless linux-next-pending patches
+compat-drivers linux-next-pending patches
 ==========================================
 
 You must have a really good reason to be adding files
@@ -8,7 +8,7 @@ been posted to a public mailing list for the subsystem you are
 working on. Each patch you add here must have a really good
 explanation on the top of the file which clarifies why the
 patch has not yet been merged OR specify it on the commit log
-when you add it on compat-wireless.
+when you add it on compat-drivers.
 
 We try to avoid having patch files because but we understand
 if you might because you need to test code posted but not yet
diff --git a/patches/README b/patches/README
index e048cb4..3e3b4d8 100644
--- a/patches/README
+++ b/patches/README
@@ -1,5 +1,5 @@
 
-compat-wireless patches
+compat-drivers patches
 =======================
 
 You must have a really good reason to be adding files
diff --git a/pending-stable/README b/pending-stable/README
index d366977..52529d6 100644
--- a/pending-stable/README
+++ b/pending-stable/README
@@ -1,4 +1,4 @@
-compat-wireless pending-stable/ patches
+compat-drivers pending-stable/ patches
 =======================================
 
 Often right before the merge window we get a block on non
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 0afbcf6..bcd17b8 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -2,13 +2,13 @@
 # 
 # Copyright 2007, 2008, 2010	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
 #
-# Use this to update compat-wireless to the latest
+# Use this to update compat-drivers to the latest
 # linux-next.git tree you have.
 #
 # Usage: you should have the latest pull of linux-next.git
 # git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
 # We assume you have it on your ~/linux-next/ directory. If you do,
-# just run this script from the compat-wireless directory.
+# just run this script from the compat-drivers directory.
 # You can specify where your GIT_TREE is by doing:
 #
 # export GIT_TREE=/home/mcgrof/linux-next/
@@ -443,7 +443,7 @@ cp -a $GIT_COMPAT_TREE/include/pcmcia/* include/pcmcia/
 cp -a $GIT_COMPAT_TREE/include/crypto/* include/crypto/
 rm -f $COMPAT/*.mod.c
 
-# files we suck in for compat-wireless
+# files we suck in for wireless drivers
 export WSTABLE="
         net/wireless/
         net/wireless/
@@ -561,7 +561,7 @@ patchRefresh() {
 ORIG_CODE=$(find ./ -type f -name  \*.[ch] |
 	egrep -v "^./compat/|include/linux/compat" |
 	xargs wc -l | tail -1 | awk '{print $1}')
-printf "\n${CYAN}compat-wireless code metrics${NORMAL}\n\n" > $CODE_METRICS
+printf "\n${CYAN}compat-drivers code metrics${NORMAL}\n\n" > $CODE_METRICS
 printf "${PURPLE}%10s${NORMAL} - Total upstream lines of code being pulled\n" $ORIG_CODE >> $CODE_METRICS
 
 for dir in $EXTRA_PATCHES; do
@@ -625,16 +625,16 @@ if [ -d ./.git ]; then
 
 	case $TREE_NAME in
 	"wireless-testing.git") # John's wireless-testing
-		echo -e "This is a ${RED}wireless-testing.git${NORMAL} compat-wireless release"
+		echo -e "This is a ${RED}wireless-testing.git${NORMAL} compat-drivers release"
 		;;
 	"linux-next.git") # The linux-next integration testing tree
-		echo -e "This is a ${RED}linux-next.git${NORMAL} compat-wireless release"
+		echo -e "This is a ${RED}linux-next.git${NORMAL} compat-drivers release"
 		;;
 	"linux-stable.git") # Greg's all stable tree
-		echo -e "This is a ${GREEN}linux-stable.git${NORMAL} compat-wireless release"
+		echo -e "This is a ${GREEN}linux-stable.git${NORMAL} compat-drivers release"
 		;;
 	"linux-2.6.git") # Linus' 2.6 tree
-		echo -e "This is a ${GREEN}linux-2.6.git${NORMAL} compat-wireless release"
+		echo -e "This is a ${GREEN}linux-2.6.git${NORMAL} compat-drivers release"
 		;;
 	*)
 		;;
@@ -644,7 +644,7 @@ if [ -d ./.git ]; then
 	echo -e "\nBase tree: ${GREEN}$(cat .compat_base_tree)${NORMAL}" >> $CODE_METRICS
 	echo -e "Base tree version: ${PURPLE}$(cat .compat_base_tree_version)${NORMAL}" >> $CODE_METRICS
 	echo -e "compat.git: ${CYAN}$(cat .compat_base)${NORMAL}" >> $CODE_METRICS
-	echo -e "compat-wireless release: ${YELLOW}$(cat .compat_version)${NORMAL}" >> $CODE_METRICS
+	echo -e "compat-drivers release: ${YELLOW}$(cat .compat_version)${NORMAL}" >> $CODE_METRICS
 
 fi
 
diff --git a/scripts/athenable b/scripts/athenable
index c9b67a0..3ec16ad 100755
--- a/scripts/athenable
+++ b/scripts/athenable
@@ -5,7 +5,7 @@
 # Makes sure either ath5k or MadWifi are ready to be used. This allows
 # us to choose any driver without blacklisting each other.
 
-. /usr/lib/compat-wireless/modlib.sh
+. /usr/lib/compat-drivers/modlib.sh
 
 if [[ $UID -ne 0 ]]; then
 	echo "Run with root privileges"
diff --git a/scripts/athload b/scripts/athload
index 01b3072..96b28c3 100755
--- a/scripts/athload
+++ b/scripts/athload
@@ -3,7 +3,7 @@
 #
 # Loads ath5k or madwifi
 
-. /usr/lib/compat-wireless/modlib.sh
+. /usr/lib/compat-drivers/modlib.sh
 
 if [[ $UID -ne 0 ]]; then
 	echo "Run with root privileges"
diff --git a/scripts/b43enable b/scripts/b43enable
index b0b9851..2d2d22c 100755
--- a/scripts/b43enable
+++ b/scripts/b43enable
@@ -6,7 +6,7 @@
 # is enabled to be used. This allows us to choose any driver without 
 # blacklisting each other.
 
-. /usr/lib/compat-wireless/modlib.sh
+. /usr/lib/compat-drivers/modlib.sh
 
 if [[ $UID -ne 0 ]]; then
 	echo "Run with root privileges"
diff --git a/scripts/b43load b/scripts/b43load
index 5114ffa..3e7a4d9 100755
--- a/scripts/b43load
+++ b/scripts/b43load
@@ -3,7 +3,7 @@
 #
 # Loads new broadcom drivers (b43 and b43legacy) or the old ones (bcm43xx)
 
-. /usr/lib/compat-wireless/modlib.sh
+. /usr/lib/compat-drivers/modlib.sh
 
 if [[ $UID -ne 0 ]]; then
 	echo "Run with root privileges"
diff --git a/scripts/check_config.sh b/scripts/check_config.sh
index 1a08442..e7041bd 100755
--- a/scripts/check_config.sh
+++ b/scripts/check_config.sh
@@ -1,5 +1,5 @@
 #!/usr/bin/env bash
-# This script checks the compat-wireless configuration file and if changes were made
+# This script checks the compat-drivers configuration file and if changes were made
 # regenerates the compat_autoconf header.
 
 # These variables are expected to be exported:
@@ -28,7 +28,7 @@ fi
 md5sum -c $CONFIG_CHECK 2> /dev/null 1>/dev/null
 
 if [ $? -ne 0 ]; then
-	echo "Changes to compat-wireless's configuration was detected, regenerating autoconf..."
+	echo "Changes to compat-drivers's configuration was detected, regenerating autoconf..."
 	gen_compat_autoconf
 fi
 
diff --git a/scripts/check_depmod b/scripts/check_depmod
index f127a6a..fbcdd27 100755
--- a/scripts/check_depmod
+++ b/scripts/check_depmod
@@ -7,9 +7,9 @@
 # Seems Mandriva has an $DEPMOD_DIR but it doesn't have any files,
 # so lets deal with those distributions.
 DEPMOD_CONF="/etc/depmod.conf"
-DEPMOD_CONF_TMP="$DEPMOD_CONF.compat-wireless.old"
+DEPMOD_CONF_TMP="$DEPMOD_CONF.compat-drivers.old"
 DEPMOD_DIR="/etc/depmod.d/"
-COMPAT_DEPMOD_FILE=compat-wireless.conf
+COMPAT_DEPMOD_FILE=compat-drivers.conf
 GREP_REGEX_UPDATES="^[[:space:]]*search.*[[:space:]]updates\([[:space:]]\|$\)"
 GREP_REGEX_SEARCH="^[[:space:]]*search[[:space:]].\+$"
 DEPMOD_CMD="depmod"
diff --git a/scripts/driver-select b/scripts/driver-select
index 35e0eaf..0ad3855 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -1,7 +1,7 @@
 #!/usr/bin/env bash
 # Copyright 2009        Luis R. Rodriguez <mcgrof@gmail.com>
 #
-# This script allows you to select your compat-wireless driver and
+# This script allows you to select your compat-drivers driver and
 # reduce compilation time.
 
 COMPAT_CONFIG_CW="config.mk"
@@ -69,8 +69,8 @@ function usage {
 	echo -e "\t${CYAN}atlxx${NORMAL} < ${PURPLE} atl1 atl2 atl1e alx${NORMAL}>"
 	echo -e "\t${CYAN}bt${NORMAL} < ${PURPLE} Linux bluetooth drivers ${NORMAL}>"
 
-	echo -e "Restoring compat-wireless:"
-	echo -e "\t${GREEN}restore${NORMAL}: you can use this option to restore compat-wireless to the original state"
+	echo -e "Restoring compat-drivers:"
+	echo -e "\t${GREEN}restore${NORMAL}: you can use this option to restore compat-drivers to the original state"
 }
 
 function backup_file {
@@ -279,7 +279,7 @@ if [ $# -ne 1 ]; then
 fi
 
 if [ ! -f .compat_version ]; then
-	echo "Must run $0 from the compat-wireless top level directory"
+	echo "Must run $0 from the compat-drivers top level directory"
 	exit
 fi
 
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 1b82184..41b1973 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -17,7 +17,7 @@ KERNEL_RELEASE=".compat_base_tree_version"
 MULT_DEP_FILE=".compat_pivot_dep"
 
 if [ $# -ne 2 ]; then
-	echo "Usage $0 <generic-compat-config-file> <compat-wireless-config-file>"
+	echo "Usage $0 <generic-compat-config-file> <compat-drivers-config-file>"
 	exit
 fi
 
@@ -67,19 +67,19 @@ function define_config {
 	esac
 }
 
-# This deals with core compat-wireless kernel requirements.
+# This deals with core compat-drivers kernel requirements.
 function define_config_req {
 	VAR=$1
 	echo "#ifndef $VAR"
-	echo -n "#error Compat-wireless requirement: $VAR must be enabled "
+	echo -n "#error Compat-drivers requirement: $VAR must be enabled "
 	echo "in your kernel"
 	echo "#endif /* $VAR */"
 }
 
 # This handles modules which have dependencies from the kernel
-# which compat-wireless isn't providing yet either because
+# which compat-drivers isn't providing yet either because
 # the dependency is not available as kernel module or
-# the module simply isn't provided by compat-wireless.
+# the module simply isn't provided by compat-drivers.
 function define_config_dep {
 	VAR=$1
 	VALUE=$2
@@ -135,7 +135,7 @@ cat <<EOF
 /*
  * Automatically generated C config: don't edit
  * $DATE 
- * compat-wireless-2.6: $CREL
+ * compat-drivers: $CREL
  * linux-2.6: $KREL
  */
 #define COMPAT_RELEASE "$CREL"
diff --git a/scripts/gen-stable-release.sh b/scripts/gen-stable-release.sh
index 5a7dc5f..c28e2cd 100755
--- a/scripts/gen-stable-release.sh
+++ b/scripts/gen-stable-release.sh
@@ -1,7 +1,7 @@
 #!/usr/bin/env bash
 # Copyright 2009  Luis R. Rodriguez <mcgrof@gmail.com>
 #
-# You can use this to make stable compat-wireless releases
+# You can use this to make stable compat-drivers releases
 #
 # The assumption is you have the linux-stable git tree on your $HOME
 # git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
@@ -26,7 +26,7 @@ UNDERLINE="\033[02m"
 # Linus' tree as a remote and fetch those objects if you want to make an RC
 # release instead.
 ALL_STABLE_TREE="linux-stable"
-STAGING=/tmp/staging/compat-wireless/
+STAGING=/tmp/staging/compat-drivers/
 
 function usage()
 {
@@ -105,7 +105,7 @@ done
 function check_for_updates()
 {
 	case $TARGET_BRANCH in
-	"master") # Preparing a new stable compat-wireless release based on an RC kernel
+	"master") # Preparing a new stable compat-drivers release based on an RC kernel
 		git checkout -f
 		git fetch
 		git reset --hard origin
@@ -136,13 +136,13 @@ echo "On $ALL_STABLE_TREE: $TARGET_BRANCH"
 
 # At this point your linux-2.6-allstable tree should be up to date
 # with the target kernel you want to use. Lets now make sure you are
-# on matching compat-wireless branch.
+# on matching compat-drivers branch.
 
 # This is a super hack, but let me know if you figure out a cleaner way
 TARGET_KERNEL_RELEASE=$(make VERSION="linux-3" SUBLEVEL="" EXTRAVERSION=".y" kernelversion)
 
 if [[ $COMPAT_WIRELESS_BRANCH != $TARGET_KERNEL_RELEASE ]]; then
-	echo -e "You are on the compat-wireless ${GREEN}${COMPAT_WIRELESS_BRANCH}${NORMAL} but are "
+	echo -e "You are on the compat-drivers ${GREEN}${COMPAT_WIRELESS_BRANCH}${NORMAL} but are "
 	echo -en "on the ${RED}${TARGET_KERNEL_RELEASE}${NORMAL} branch... "
 	echo -e "try changing to that first."
 
diff --git a/scripts/iwl-enable b/scripts/iwl-enable
index b18fdc2..c29b71e 100755
--- a/scripts/iwl-enable
+++ b/scripts/iwl-enable
@@ -6,7 +6,7 @@
 # is enabled to be used. This allows us to choose any driver without 
 # blacklisting each other.
 
-. /usr/lib/compat-wireless/modlib.sh
+. /usr/lib/compat-drivers/modlib.sh
 
 if [[ $UID -ne 0 ]]; then
 	echo "Run with root privileges"
diff --git a/scripts/iwl-load b/scripts/iwl-load
index 96b6d89..a758902 100755
--- a/scripts/iwl-load
+++ b/scripts/iwl-load
@@ -3,7 +3,7 @@
 #
 # Loads new Intel iwl (iwlagn) or the old ones (iwl4965)
 
-. /usr/lib/compat-wireless/modlib.sh
+. /usr/lib/compat-drivers/modlib.sh
 
 IWL_OLD="iwl4965"
 IWL_NEW="iwlagn"
diff --git a/scripts/refresh-compat b/scripts/refresh-compat
index 87a647b..3321e6d 100755
--- a/scripts/refresh-compat
+++ b/scripts/refresh-compat
@@ -14,9 +14,9 @@
 # ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 # OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
-# The purpose of this script is to enable developers use compat-wireless
+# The purpose of this script is to enable developers use compat-drivers
 # backport work without having to carry code on their tree. This lets
-# developers synch to newer compat-wireless releases to gain more backport
+# developers synch to newer compat-drivers releases to gain more backport
 # work. If you use this throw the files into your .gitignore:
 #
 # compat/
diff --git a/scripts/refresh-compat-local b/scripts/refresh-compat-local
index b4b5905..7cad328 100755
--- a/scripts/refresh-compat-local
+++ b/scripts/refresh-compat-local
@@ -21,7 +21,7 @@ source .compat_copy
 UPDATE_SCRIPT="$COMPAT_SRC/scripts/refresh-compat"
 
 if [[ ! -d $COMPAT_SRC ]]; then
-	echo -e "You should have compat-wireless.git cloned and checked out under $COMPAT_SRC"
+	echo -e "You should have compat-drivers.git cloned and checked out under $COMPAT_SRC"
 	echo -e "The git tree: git://github.com/mcgrof/compat-wireless.git"
 	exit 1
 fi
-- 
1.7.11.2

