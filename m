Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38795 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2GILsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 07:48:09 -0400
Received: by eeit10 with SMTP id t10so4281740eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 04:48:08 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Fix setting $TARGET
Date: Mon,  9 Jul 2012 14:48:01 +0300
Message-Id: <1341834481-1831-1-git-send-email-ozancag@gmail.com> (sfid-20120709_134814_046576_51D4DAD8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 61077651424add644401b927b52681a191bbd7f1 moved the list of
kernels above which broke the $TARGET substitutions in them.

Move the TARGET detection above of everything to fix this.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 bin/get-compat-kernels |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/bin/get-compat-kernels b/bin/get-compat-kernels
index d80c0a7..99392b4 100755
--- a/bin/get-compat-kernels
+++ b/bin/get-compat-kernels
@@ -23,6 +23,23 @@ UNDERLINE="\033[02m"
 KERNELS=""
 KPATH="http://kernel.ubuntu.com/~kernel-ppa/mainline/"
 
+ARCH=$(uname -m)
+TARGET=""
+
+case $ARCH in
+	"x86_64")
+		TARGET="amd64"
+		;;
+	"i686")
+		TARGET="i386"
+		;;
+	*)
+		echo -e "Unsupported architecture"
+		exit
+		;;
+esac
+
+
 KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624_2.6.24-020624_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624-generic_2.6.24-020624_${TARGET}.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-image-2.6.24-020624-generic_2.6.24-020624_${TARGET}.deb"
@@ -109,22 +126,6 @@ KERNELS="$KERNELS ${KPATH}/v3.4.4-quantal/linux-image-3.4.4-030404-generic_3.4.4
 
 function get_ubuntu_kernels() {
 
-	ARCH=$(uname -m)
-	TARGET=""
-
-	case $ARCH in
-	"x86_64")
-		TARGET="amd64"
-		;;
-	"i686")
-		TARGET="i386"
-		;;
-	*)
-		echo -e "Unsupported architecture"
-		exit
-		;;
-	esac
-
 	mkdir -p debs
 	cd debs
 
-- 
1.7.10.4

