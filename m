Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48346 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2GKK1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 06:27:19 -0400
Received: by wgbdr13 with SMTP id dr13so891632wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2012 03:27:18 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Add ability to run as non-root
Date: Wed, 11 Jul 2012 13:26:56 +0300
Message-Id: <1342002416-25468-1-git-send-email-ozancag@gmail.com> (sfid-20120711_122751_398269_C3F58D4B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get-compat-kernels now extracts the kernel headers into
$HOME/compat-ksrc if the user is not root.

Similarly, ckmake tries first to use $HOME/compat-ksrc if it
exists. If not, it fallbacks to system-wide /usr/src silently.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 bin/ckmake             |    9 +++++-
 bin/get-compat-kernels |   76 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 68 insertions(+), 17 deletions(-)

diff --git a/bin/ckmake b/bin/ckmake
index 2a0bb3d..72e9b7e 100755
--- a/bin/ckmake
+++ b/bin/ckmake
@@ -34,7 +34,14 @@ RET_FILE="ret-tmp.txt"
 
 RET=""
 
-for i in $(find /lib/modules/ -type d -name \*generic\* | sort -n -r | grep -v -E '\-[[:alnum:]]{1,2}\-'); do
+# If $HOME/compat-ksrc is found use that, otherwise use system-wide
+# sources in /usr/src.
+KSRC_PREFIX=
+if [[ -d "$HOME/compat-ksrc" ]]; then
+	KSRC_PREFIX="$HOME/compat-ksrc"
+fi
+
+for i in $(find $KSRC_PREFIX/lib/modules/ -type d -name \*generic\* | sort -n -r | grep -v -E '\-[[:alnum:]]{1,2}\-'); do
 	KLIBS="$KLIBS $i"
 done
 
diff --git a/bin/get-compat-kernels b/bin/get-compat-kernels
index 3d7a9d7..6d9d9fe 100755
--- a/bin/get-compat-kernels
+++ b/bin/get-compat-kernels
@@ -23,6 +23,18 @@ UNDERLINE="\033[02m"
 KERNELS=""
 KPATH="http://kernel.ubuntu.com/~kernel-ppa/mainline/"
 
+KSRC_PREFIX=
+# Check whether we're running as root or not
+# If we're root stuff things into /usr/src and /lib/modules
+# else, use $HOME/compat-ksrc for enabling user-mode builds.
+if [[ "$EUID" != "0" ]]; then
+	KSRC_PREFIX="$HOME/compat-ksrc"
+fi
+
+# Create target directories if they doesn't exist
+mkdir -p $KSRC_PREFIX/{usr/src,lib/modules}
+
+# List of currently supported kernels that will be downloaded
 KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624_2.6.24-020624_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.25/linux-headers-2.6.25-020625_2.6.25-020625_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.26/linux-headers-2.6.26-020626_2.6.26-020626_all.deb"
@@ -45,6 +57,15 @@ KERNELS="$KERNELS ${KPATH}/v3.2.2-precise/linux-headers-3.2.2-030202_3.2.2-03020
 KERNELS="$KERNELS ${KPATH}/v3.3.7-precise/linux-headers-3.3.7-030307_3.3.7-030307.201205211535_all.deb"
 KERNELS="$KERNELS ${KPATH}/v3.4.4-quantal/linux-headers-3.4.4-030404_3.4.4-030404.201206221555_all.deb"
 
+# Number of kernels
+NUM_KERNELS=$(echo $KERNELS | wc -w)
+
+# ~ 101 MiB for installed space on $KSRC_PREFIX/usr/src/ and $KSRC_PREFIX/lib/modules/
+SPACE_PER_KERNEL="101"
+
+# ~13 MiB of both deb files
+SPACE_PER_KERNEL_DEB="13"
+
 function get_ubuntu_kernels() {
 
 	ARCH=$(uname -m)
@@ -71,7 +92,7 @@ function get_ubuntu_kernels() {
 		PKG=$(echo $FILE | awk -F"_" '{print $1}')
 
 		# Do not download if installed or deb exists
-		if [[ ! -d /usr/src/$PKG && ! -f $FILE ]]; then
+		if [[ ! -d $KSRC_PREFIX/usr/src/$PKG && ! -f $FILE ]]; then
 			# Download the _all.deb
 			wget -c $i
 
@@ -81,32 +102,52 @@ function get_ubuntu_kernels() {
 		fi
 	done
 
+	# List of downloaded debs
+	DEB_LIST=`ls linux-*.deb 2>/dev/null`
+
+	if [[ -z $DEB_LIST ]]; then
+		echo "All kernel sources are found in $KSRC_PREFIX/usr/src."
+		exit
+	fi
+
 	# Create a temporary directory first
 	TEMP_DIR=`mktemp -d`
 
-	for deb in $(ls linux-*.deb); do
+	for deb in $DEB_LIST; do
 		DIR_NAME=$(echo $deb | awk -F"_" '{print $1}')
-		if [[ ! -d /usr/src/$DIR_NAME ]]; then
+		if [[ ! -d $KSRC_PREFIX/usr/src/$DIR_NAME ]]; then
 			echo "Extracting $deb..."
-			ar p $deb data.tar.gz | sudo tar xz --exclude=usr/share -C $TEMP_DIR
+			ar p $deb data.tar.gz | tar xz --exclude=usr/share -C $TEMP_DIR
 		fi
 	done
 
 	# Move the extracted folders into the system
 	if [[ -d $TEMP_DIR/lib/modules ]]; then
-		sudo mv $TEMP_DIR/lib/modules/* /lib/modules
+
+		# Relink lib/modules/*/build/ directories relatively to make it work
+		# for regular user based workflows
+		if [[ -n $KSRC_PREFIX ]]; then
+			echo "Adjusting build/ symlinks for non-root installation..."
+
+			for kernel in $(ls -d $TEMP_DIR/lib/modules/*generic); do
+				unlink $kernel/build
+				ln -s ../../../usr/src/linux-headers-`basename $kernel` $kernel/build
+			done
+		fi
+
+		mv $TEMP_DIR/lib/modules/* $KSRC_PREFIX/lib/modules
 	fi
 	if [[ -d $TEMP_DIR/usr/src ]]; then
 		# Because of a bug in make < 3.82, mixed implicit and normal
 		# rules do not cause harm. Since the bug is fixed in the new make
 		# we have to adjust older kernel's Makefiles to fix the bug.
-		sudo sed -i 's#^/ %/:#%/:#' $TEMP_DIR/usr/src/linux-headers-2.6.2[45678]-0*/Makefile &>/dev/null
+		sed -i 's#^/ %/:#%/:#' $TEMP_DIR/usr/src/linux-headers-2.6.2[45678]-0*/Makefile &>/dev/null
 
-		sudo mv $TEMP_DIR/usr/src/* /usr/src
+		mv $TEMP_DIR/usr/src/* $KSRC_PREFIX/usr/src
 	fi
 
 	# Remove the temporary directory
-	sudo rm -rf $TEMP_DIR
+	rm -rf $TEMP_DIR
 }
 
 function usage() {
@@ -115,9 +156,10 @@ function usage() {
 
 if [[ $# -gt 1 ]]; then
 	usage
-	exit
+	exit 1
 fi
 
+# Check for the availability of 'ar' before continuing
 which ar 2>&1 > /dev/null
 if [[ $? -ne 0 ]]; then
 	echo -e "${GREEN}ar${NORMAL} is not avilable, typically this is available through a package called binutils"
@@ -125,18 +167,20 @@ if [[ $? -ne 0 ]]; then
 	exit 1
 fi
 
-NUM_KERNELS=$(echo $KERNELS | wc -w)
-# ~ 101 MiB for installed space on /usr/src/ and /lib/modules/
-SPACE_PER_KERNEL="101"
+echo -e ""
 
-# ~13 MiB of both deb files
-SPACE_PER_KERNEL_DEB="13"
+if [[ -n $KSRC_PREFIX ]]; then
+	echo -e "** Running as a non-privileged user!"
+	echo -e "** If you want to force using system-wide ${BLUE}/lib/modules${NORMAL} and ${BLUE}/usr/src${NORMAL}, you have to"
+	echo -e "** run this script as root or using ${GREEN}sudo${NORMAL}."
+	echo -e ""
+fi
 
 echo -e "This will download ${YELLOW}${NUM_KERNELS}${NORMAL} kernel headers to allow you to"
 echo -e "cross compile any module over these kernels with ${GREEN}ckmake${NORMAL}."
 echo -e "The download payload is about ${YELLOW}~ $((${SPACE_PER_KERNEL_DEB} * ${NUM_KERNELS})) ${CYAN}MiB${NORMAL}, once uncompressed"
-echo -e "it will use ${GREEN}sudo${NORMAL} to stash kernel header files under ${BLUE}/usr/src/${NORMAL}"
-echo -e "and ${BLUE}/lib/modules/${NORMAL} and consume about ~ ${YELLOW}$((${NUM_KERNELS} * ${SPACE_PER_KERNEL})) ${RED}MiB${NORMAL} of space."
+echo -e "it will stash kernel header files under ${BLUE}$KSRC_PREFIX/usr/src/${NORMAL}"
+echo -e "and ${BLUE}$KSRC_PREFIX/lib/modules/${NORMAL} and consume about ~ ${YELLOW}$((${NUM_KERNELS} * ${SPACE_PER_KERNEL})) ${RED}MiB${NORMAL} of space."
 echo -e ""
 echo -e "Note: you will need ${CYAN}libc${NORMAL} > ${GREEN}2.14${NORMAL} otherwise compilation may"
 echo -e "fail with Linux ${CYAN}3.4.4${NORMAL}"
-- 
1.7.10.4

