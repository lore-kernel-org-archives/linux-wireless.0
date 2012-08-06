Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54884 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab2HFSzP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 14:55:15 -0400
Received: by eeil10 with SMTP id l10so947525eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 11:55:14 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 1/2] compat-wireless: Minor cosmetic changes in admin-update.sh
Date: Mon,  6 Aug 2012 21:55:06 +0300
Message-Id: <1344279307-2929-1-git-send-email-ozancag@gmail.com> (sfid-20120806_205520_067539_2BD76562)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- Move functions above everything,
- Use $HOME instead of /home/$USER which fails when run as root,
- Enhance comments
- Mention about compat/bin/get-compat-trees for fetching the trees.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh | 175 +++++++++++++++++++++++++++++-------------------
 1 file changed, 105 insertions(+), 70 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index bcd17b8..3558801 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -12,29 +12,6 @@
 # You can specify where your GIT_TREE is by doing:
 #
 # export GIT_TREE=/home/mcgrof/linux-next/
-# 
-# for example
-#
-GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"
-GIT_COMPAT_URL="git://github.com/mcgrof/compat.git"
-
-INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h hci_mon.h mgmt.h sco.h smp.h a2mp.h"
-NET_BT_DIRS="bluetooth bluetooth/bnep bluetooth/cmtp bluetooth/rfcomm bluetooth/hidp"
-
-INCLUDE_LINUX="ieee80211.h nl80211.h"
-INCLUDE_LINUX="$INCLUDE_LINUX pci_ids.h eeprom_93cx6.h"
-INCLUDE_LINUX="$INCLUDE_LINUX ath9k_platform.h"
-INCLUDE_LINUX="$INCLUDE_LINUX wl12xx.h"
-INCLUDE_LINUX="$INCLUDE_LINUX rndis.h"
-
-# For rndis_wext
-INCLUDE_LINUX_USB="usbnet.h rndis_host.h"
-
-INCLUDE_LINUX_SPI="libertas_spi.h"
-
-# The good new yummy stuff
-INCLUDE_NET="cfg80211.h ieee80211_radiotap.h cfg80211-wext.h"
-INCLUDE_NET="$INCLUDE_NET mac80211.h lib80211.h regulatory.h"
 
 # Pretty colors
 GREEN="\033[01;32m"
@@ -46,19 +23,71 @@ PURPLE="\033[35m"
 CYAN="\033[36m"
 UNDERLINE="\033[02m"
 
-NET_DIRS="wireless mac80211 rfkill"
+# File in which code metrics will be written
 CODE_METRICS=code-metrics.txt
 
+# The GIT URL's for linux-next and compat trees
+GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"
+GIT_COMPAT_URL="git://github.com/mcgrof/compat.git"
+
+####################
+# Helper functions #
+# ##################
+
+# Refresh patches using quilt
+patchRefresh() {
+	if [ -d patches.orig ] ; then
+		rm -rf .pc patches/series
+	else
+		mkdir patches.orig
+	fi
+
+	export QUILT_PATCHES=$1
+
+	mv -u $1/* patches.orig/
+
+	for i in patches.orig/*.patch; do
+		if [ ! -f "$i" ]; then
+			echo -e "${RED}No patches found in $1${NORMAL}"
+			break;
+		fi
+		echo -e "${GREEN}Refresh backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
+		quilt import $i
+		quilt push -f
+		RET=$?
+		if [[ $RET -ne 0 ]]; then
+			echo -e "${RED}Refreshing $i failed${NORMAL}, update it"
+			echo -e "use ${CYAN}quilt edit [filename]${NORMAL} to apply the failed part manually"
+			echo -e "use ${CYAN}quilt refresh${NORMAL} after the files are corrected and rerun this script"
+			cp patches.orig/README $1/README
+			exit $RET
+		fi
+		QUILT_DIFF_OPTS="-p" quilt refresh -p ab --no-index --no-timestamp
+	done
+	quilt pop -a
+
+	cp patches.orig/README $1/README
+	rm -rf patches.orig .pc $1/series
+}
+
+###
+# usage() function
+###
 usage() {
-	printf "Usage: $0 [ refresh] [ --help | -h | -s | -n | -p | -c ]\n"
+	printf "Usage: $0 [refresh] [ --help | -h | -s | -n | -p | -c ]\n"
 
-	printf "${GREEN}%10s${NORMAL} - will update your all your patch offsets using quilt\n" "refresh"
-	printf "${GREEN}%10s${NORMAL} - get and apply pending-stable/ fixes purging old files there\n" "-s"
-	printf "${GREEN}%10s${NORMAL} - apply the patches linux-next-cherry-picks directory\n" "-n"
-	printf "${GREEN}%10s${NORMAL} - apply the patches on the linux-next-pending directory\n" "-p"
-	printf "${GREEN}%10s${NORMAL} - apply the patches on the crap directory\n" "-c"
+	printf "${GREEN}%10s${NORMAL} - Update all your patch offsets using quilt\n" "refresh"
+	printf "${GREEN}%10s${NORMAL} - Get and apply pending-stable/ fixes purging old files there\n" "-s"
+	printf "${GREEN}%10s${NORMAL} - Apply the patches from linux-next-cherry-picks directory\n" "-n"
+	printf "${GREEN}%10s${NORMAL} - Apply the patches from linux-next-pending directory\n" "-p"
+	printf "${GREEN}%10s${NORMAL} - Apply the patches from crap directory\n" "-c"
 }
 
+###
+# Code metrics related functions
+# 4 parameters get passed to them:
+# (ORIG_CODE, CHANGES, ADD, DEL)
+###
 brag_backport() {
 	COMPAT_FILES_CODE=$(find ./ -type f -name  \*.[ch] | egrep  "^./compat/|include/linux/compat" |
 		xargs wc -l | tail -1 | awk '{print $1}')
@@ -134,6 +163,21 @@ nagometer() {
 
 }
 
+# First check cmdline args to understand
+# which patches to apply and which release tag to set.
+#
+# Release tags (with corresponding cmdline switches):
+# ---------------------------------------------------
+# 	s: Include pending-stable/*.patch		(-s)
+# 	n: Include linux-next-cherry-picks/*.patch	(-n)
+# 	p: Include linux-next-pending/*.patch		(-p)
+# 	c: Include crap/*.patch				(-c)
+# Note that the patches under patches/ are applied by default.
+#
+# If "refresh" is given as a cmdline argument, the script
+# uses quilt to refresh the patches. This is useful if patches
+# can not be applied correctly after a code update in $GIT_URL.
+
 EXTRA_PATCHES="patches"
 REFRESH="n"
 GET_STABLE_PENDING="n"
@@ -184,15 +228,18 @@ fi
 
 # User exported this variable
 if [ -z $GIT_TREE ]; then
-	GIT_TREE="/home/$USER/linux-next/"
+	GIT_TREE="$HOME/linux-next/"
 	if [ ! -d $GIT_TREE ]; then
 		echo "Please tell me where your linux-next git tree is."
 		echo "You can do this by exporting its location as follows:"
 		echo
-		echo "  export GIT_TREE=/home/$USER/linux-next/"
+		echo "  export GIT_TREE=$HOME/linux-next/"
 		echo
 		echo "If you do not have one you can clone the repository:"
 		echo "  git clone $GIT_URL"
+		echo
+		echo "Alternatively, you can use get-compat-trees script "
+		echo "from compat.git tree to fetch the necessary trees."
 		exit 1
 	fi
 else
@@ -200,21 +247,45 @@ else
 fi
 
 if [ -z $GIT_COMPAT_TREE ]; then
-	GIT_COMPAT_TREE="/home/$USER/compat/"
+	GIT_COMPAT_TREE="$HOME/compat/"
 	if [ ! -d $GIT_COMPAT_TREE ]; then
 		echo "Please tell me where your compat git tree is."
 		echo "You can do this by exporting its location as follows:"
 		echo
-		echo "  export GIT_COMPAT_TREE=/home/$USER/compat/"
+		echo "  export GIT_COMPAT_TREE=$HOME/compat/"
 		echo
 		echo "If you do not have one you can clone the repository:"
 		echo "  git clone $GIT_COMPAT_URL"
+		echo
+		echo "Alternatively, you can use get-compat-trees script "
+		echo "from compat.git tree to fetch the necessary trees."
 		exit 1
 	fi
 else
 	echo "You said to use git tree at: $GIT_COMPAT_TREE for compat"
 fi
 
+# Now define what files to copy from $GIT_URL
+INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h hci_mon.h mgmt.h sco.h smp.h a2mp.h"
+NET_BT_DIRS="bluetooth bluetooth/bnep bluetooth/cmtp bluetooth/rfcomm bluetooth/hidp"
+
+INCLUDE_LINUX="ieee80211.h nl80211.h"
+INCLUDE_LINUX="$INCLUDE_LINUX pci_ids.h eeprom_93cx6.h"
+INCLUDE_LINUX="$INCLUDE_LINUX ath9k_platform.h"
+INCLUDE_LINUX="$INCLUDE_LINUX wl12xx.h"
+INCLUDE_LINUX="$INCLUDE_LINUX rndis.h"
+
+# For rndis_wext
+INCLUDE_LINUX_USB="usbnet.h rndis_host.h"
+
+INCLUDE_LINUX_SPI="libertas_spi.h"
+
+# The good new yummy stuff
+INCLUDE_NET="cfg80211.h ieee80211_radiotap.h cfg80211-wext.h"
+INCLUDE_NET="$INCLUDE_NET mac80211.h lib80211.h regulatory.h"
+
+NET_DIRS="wireless mac80211 rfkill"
+
 # Drivers that have their own directory
 DRIVERS="drivers/net/wireless/ath"
 DRIVERS="$DRIVERS drivers/net/wireless/ath/carl9170"
@@ -522,42 +593,6 @@ if [[ "$GET_STABLE_PENDING" = y ]]; then
 	cd $LAST_DIR
 fi
 
-# Refresh patches using quilt
-patchRefresh() {
-	if [ -d patches.orig ] ; then
-		rm -rf .pc patches/series
-	else
-		mkdir patches.orig
-	fi
-
-	export QUILT_PATCHES=$1
-
-	mv -u $1/* patches.orig/
-
-	for i in patches.orig/*.patch; do
-		if [ ! -f "$i" ]; then
-			echo -e "${RED}No patches found in $1${NORMAL}"
-			break;
-		fi
-		echo -e "${GREEN}Refresh backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
-		quilt import $i
-		quilt push -f
-		RET=$?
-		if [[ $RET -ne 0 ]]; then
-			echo -e "${RED}Refreshing $i failed${NORMAL}, update it"
-			echo -e "use ${CYAN}quilt edit [filename]${NORMAL} to apply the failed part manually"
-			echo -e "use ${CYAN}quilt refresh${NORMAL} after the files are corrected and rerun this script"
-			cp patches.orig/README $1/README
-			exit $RET
-		fi
-		QUILT_DIFF_OPTS="-p" quilt refresh -p ab --no-index --no-timestamp
-	done
-	quilt pop -a
-
-	cp patches.orig/README $1/README
-	rm -rf patches.orig .pc $1/series
-}
-
 ORIG_CODE=$(find ./ -type f -name  \*.[ch] |
 	egrep -v "^./compat/|include/linux/compat" |
 	xargs wc -l | tail -1 | awk '{print $1}')
-- 
1.7.11.2

