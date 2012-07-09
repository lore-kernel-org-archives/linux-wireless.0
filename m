Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34400 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2GIOya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 10:54:30 -0400
Received: by eeit10 with SMTP id t10so4356489eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 07:54:29 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [RFC] compat: Add ability to run as non-root
Date: Mon,  9 Jul 2012 17:54:23 +0300
Message-Id: <1341845663-24539-1-git-send-email-ozancag@gmail.com> (sfid-20120709_165443_699151_F07279E7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the EUID of the process is not 0, assume that get-compat-kernels
is run as a regular user and extract the downloaded *.deb files
from debs/ into ksrcs/:

ksrcs/
├── lib
│   └── modules
│       ├── 2.6.24-020624-generic
│       ├── 2.6.25-020625-generic
│       ├── ...
│       └── 3.4.4-030404-generic
└── usr
    └── src
        ├── linux-headers-2.6.24-020624
        ├── linux-headers-2.6.24-020624-generic
        ├── linux-headers-2.6.25-020625
        ├── linux-headers-2.6.25-020625-generic
        ├── ...
        ├── linux-headers-3.4.4-030404
        └── linux-headers-3.4.4-030404-generic

If you still want to use your kernel sources under /, run
get-compat-kernels or ckmake with 'sudo'.

Adjust ckmake to look into ksrcs/lib/modules instead of
/lib/modules in the EUID != 0.

Finally put ksrcs into .gitignore for not losing the source
trees after a 'git clean'.

Tested both as root and non-root, works fine.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 .gitignore             |    1 +
 bin/ckmake             |    9 +++++++-
 bin/get-compat-kernels |   54 +++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/.gitignore b/.gitignore
index 1331796..d470753 100644
--- a/.gitignore
+++ b/.gitignore
@@ -14,3 +14,4 @@ modules.order
 modules
 *.patch
 debs/
+ksrcs/
diff --git a/bin/ckmake b/bin/ckmake
index 2a0bb3d..6419249 100755
--- a/bin/ckmake
+++ b/bin/ckmake
@@ -34,7 +34,14 @@ RET_FILE="ret-tmp.txt"
 
 RET=""
 
-for i in $(find /lib/modules/ -type d -name \*generic\* | sort -n -r | grep -v -E '\-[[:alnum:]]{1,2}\-'); do
+# Check whether we're running as root or not
+# If not, search for kernels under ksrcs/ instead of system-wide.
+KSRC_PREFIX=
+if [[ "$EUID" != "0" ]]; then
+	KSRC_PREFIX="ksrcs"
+fi
+
+for i in $(find $KSRC_PREFIX/lib/modules/ -type d -name \*generic\* | sort -n -r | grep -v -E '\-[[:alnum:]]{1,2}\-'); do
 	KLIBS="$KLIBS $i"
 done
 
diff --git a/bin/get-compat-kernels b/bin/get-compat-kernels
index 6aab18c..f8bd29b 100755
--- a/bin/get-compat-kernels
+++ b/bin/get-compat-kernels
@@ -39,6 +39,14 @@ case $ARCH in
 		;;
 esac
 
+KSRC_PREFIX=
+# Check whether we're running as root or not
+if [[ "$EUID" != "0" ]]; then
+	KSRC_PREFIX="ksrcs"
+fi
+
+# Create target directories if they doesn't exist
+mkdir -p $KSRC_PREFIX/{usr/src,lib/modules}
 
 KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624_2.6.24-020624_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624-generic_2.6.24-020624_${TARGET}.deb"
@@ -113,7 +121,7 @@ function get_ubuntu_kernels() {
 		PKG=$(echo $FILE | awk -F"_" '{print $1}')
 
 		# Do not download if installed or deb exists
-		if [[ ! -d /usr/src/$PKG && ! -f $FILE ]]; then
+		if [[ ! -d $KSRC_PREFIX/usr/src/$PKG && ! -f $FILE ]]; then
 			wget -c $i
 		fi
 	done
@@ -123,27 +131,41 @@ function get_ubuntu_kernels() {
 
 	for deb in $(ls linux-*.deb); do
 		DIR_NAME=$(echo $deb | awk -F"_" '{print $1}')
-		if [[ ! -d /usr/src/$DIR_NAME ]]; then
+		if [[ ! -d $KSRC_PREFIX/usr/src/$DIR_NAME ]]; then
 			echo "Extracting $deb..."
-			ar p $deb data.tar.gz | sudo tar xz --exclude=usr/share -C $TEMP_DIR
+			ar p $deb data.tar.gz | tar xz --exclude=usr/share -C $TEMP_DIR
 		fi
 	done
 
+	cd ..
+
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
@@ -163,19 +185,27 @@ if [[ $? -ne 0 ]]; then
 fi
 
 NUM_KERNELS=$(for i in $KERNELS; do echo $i; done | awk -F"v" '{print $2}' | awk -F"/" '{print $1}'| sort| uniq | wc -l)
-# ~ 101 MiB for installed space on /usr/src/ and /lib/modules/
+# ~ 101 MiB for installed space on $KSRC_PREFIX/usr/src/ and $KSRC_PREFIX/lib/modules/
 SPACE_PER_KERNEL="101"
 
 # ~13 MiB of both deb files
 SPACE_PER_KERNEL_DEB="13"
 
+echo -e ""
+
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
-echo -e "Note: you will need ${CYAN}libc${NORMAL} > ${GREEN}2.14${NORMAL} otherwise compilation may"
+echo -e "NOTE: you will need ${CYAN}libc${NORMAL} > ${GREEN}2.14${NORMAL} otherwise compilation may"
 echo -e "fail with Linux ${CYAN}3.4.4${NORMAL}"
 echo -e ""
 echo -e "The kernel headers used are from ${PURPLE}${UNDERLINE}Vanilla${NORMAL} kernels"
@@ -187,7 +217,7 @@ echo -e ""
 
 read -p "Do you still want to continue (y/N)? "
 if [[ "${REPLY}" != "y" ]]; then
-	echo -e "Bailing out !"
+	echo -e "Bailing out!"
 	exit 1
 fi
 
-- 
1.7.10.4

