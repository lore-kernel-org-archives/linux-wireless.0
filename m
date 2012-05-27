Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52245 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2E0KjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2012 06:39:05 -0400
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 2/2] bin/get-compat-kernels: Do not depend on Ubuntu
Date: Sun, 27 May 2012 13:38:28 +0300
Message-Id: <1338115108-19091-2-git-send-email-ozancag@gmail.com> (sfid-20120527_123942_206798_CD137CAB)
In-Reply-To: <1338115108-19091-1-git-send-email-ozancag@gmail.com>
References: <1338115108-19091-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use Ubuntu PPA vanilla kernels on other distributions too.
The .deb files are extracted using 'ar' and 'tar'.

Also check if the target directory exists before downloading
the deb files.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 bin/get-compat-kernels |   81 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 24 deletions(-)

diff --git a/bin/get-compat-kernels b/bin/get-compat-kernels
index 7a253c2..6cac898 100755
--- a/bin/get-compat-kernels
+++ b/bin/get-compat-kernels
@@ -10,6 +10,9 @@
 # to test compile the Linux kernel compatibility module. You can
 # then use ckmake to cross compile against all supported kernels.
 
+KERNELS=""
+KPATH="http://kernel.ubuntu.com/~kernel-ppa/mainline/"
+
 function get_ubuntu_kernels() {
 
 	ARCH=$(uname -m)
@@ -28,10 +31,6 @@ function get_ubuntu_kernels() {
 		;;
 	esac
 
-	KERNELS=""
-
-	KPATH="http://kernel.ubuntu.com/~kernel-ppa/mainline/"
-
 	KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624_2.6.24-020624_all.deb"
 	KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624-generic_2.6.24-020624_${TARGET}.deb"
 	KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-image-2.6.24-020624-generic_2.6.24-020624_${TARGET}.deb"
@@ -121,19 +120,63 @@ function get_ubuntu_kernels() {
 			continue
 		fi
 
-		if [[ ! -f $FILE ]]; then
+		# Do not download if installed, I think this
+		# workarounds the below XXX: comment.
+		if [[ ! -d /usr/src/$PKG && ! -f $FILE ]]; then
 			wget -c $i
 		fi
 	done
 
-	# Let dpkg figure out dependency magic.
-	#
-	# XXX: I tried adding some magic to not install a package if
-	# if its already presently installed but then had to deal
-	# with the dependency mess. I welcome someone else to
-	# figure this out. Running this can come in handy once
-	# a new public kernel gets released.
-	sudo dpkg -i *.deb
+	LSB_RED_ID=$(/usr/bin/lsb_release -i -s)
+	case $LSB_RED_ID in
+	"Ubuntu")
+		# Let dpkg figure out dependency magic.
+		#
+		# XXX: I tried adding some magic to not install a package if
+		# if its already presently installed but then had to deal
+		# with the dependency mess. I welcome someone else to
+		# figure this out. Running this can come in handy once
+		# a new public kernel gets released.
+		sudo dpkg -i *.deb
+		;;
+	*)
+		# For every other distribution around
+
+		# Create a temporary directory first
+		TEMP_DIR=`mktemp -d`
+
+		# Check whether 'ar' exists
+		ar V 2>&1 | grep -q "GNU ar"
+		if [[ $? != 0 ]]; then
+			echo "ar is needed to extract the .deb files. Please install binutils."
+			exit
+		fi
+
+		for deb in $(ls linux-*.deb); do
+			DIR_NAME=$(echo $deb | awk -F"_" '{print $1}')
+			if [[ ! -d /usr/src/$DIR_NAME ]]; then
+				echo "Extracting $deb..."
+				ar p $deb data.tar.gz | sudo tar xz --exclude=usr/share -C $TEMP_DIR
+			fi
+		done
+
+		# Move the extracted folders into the system
+		if [[ -d $TEMP_DIR/lib/modules ]]; then
+			mv $TEMP_DIR/lib/modules/* /lib/modules
+		fi
+		if [[ -d $TEMP_DIR/usr/src ]]; then
+			# 2.6.2[45678] has a bug with make 3.82 and it should be fixed
+			# as Fedora uses make 3.82. Ubuntu still sticks with 3.81
+			# so no need to touch in case of Ubuntu.
+			sed -i 's#^/ %/:#%/:#' $TEMP_DIR/usr/src/linux-headers-2.6.2[45678]-0*/Makefile &>/dev/null
+
+			mv $TEMP_DIR/usr/src/* /usr/src
+		fi
+
+		# Remove the temporary directory
+		rm -rf $TEMP_DIR
+		;;
+	esac
 }
 
 function usage() {
@@ -158,14 +201,4 @@ if [[ $# -eq 1 && $1 = "-i" ]]; then
 	INSTALL_IMAGES="y"
 fi
 
-
-LSB_RED_ID=$(/usr/bin/lsb_release -i -s)
-case $LSB_RED_ID in
-"Ubuntu")
-	get_ubuntu_kernels
-	;;
-*)
-	echo -e "Unsupported distribution"
-	exit
-	;;
-esac
+get_kernels
-- 
1.7.10.2

