Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61751 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2GIOcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 10:32:00 -0400
Received: by eeit10 with SMTP id t10so4346170eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 07:31:59 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [RFC] compat: Don't download ubuntu specific kernel images
Date: Mon,  9 Jul 2012 17:31:53 +0300
Message-Id: <1341844313-12018-1-git-send-email-ozancag@gmail.com> (sfid-20120709_163204_633083_6C5AB7A0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The linux-image debs are quite specific to Ubuntu as they will
at least require generating a compliant initramfs before being able
to boot into them both in Ubuntu and in other distributions.

The image installation is also the only part that avoids us from
switching to non-root builds.

Drop this feature completely.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 bin/get-compat-kernels |   41 +----------------------------------------
 1 file changed, 1 insertion(+), 40 deletions(-)

diff --git a/bin/get-compat-kernels b/bin/get-compat-kernels
index 99392b4..6aab18c 100755
--- a/bin/get-compat-kernels
+++ b/bin/get-compat-kernels
@@ -42,87 +42,66 @@ esac
 
 KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624_2.6.24-020624_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624-generic_2.6.24-020624_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-image-2.6.24-020624-generic_2.6.24-020624_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.25/linux-headers-2.6.25-020625_2.6.25-020625_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.25/linux-headers-2.6.25-020625-generic_2.6.25-020625_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.25/linux-image-2.6.25-020625-generic_2.6.25-020625_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.26/linux-headers-2.6.26-020626_2.6.26-020626_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.26/linux-headers-2.6.26-020626-generic_2.6.26-020626_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.26/linux-image-2.6.26-020626-generic_2.6.26-020626_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.27/linux-headers-2.6.27-020627_2.6.27-020627_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.27/linux-headers-2.6.27-020627-generic_2.6.27-020627_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.27/linux-image-2.6.27-020627-generic_2.6.27-020627_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.28.10/linux-headers-2.6.28-02062810_2.6.28-02062810_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.28.10/linux-headers-2.6.28-02062810-generic_2.6.28-02062810_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.28.10/linux-image-2.6.28-02062810-generic_2.6.28-02062810_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.29.6/linux-headers-2.6.29-02062906_2.6.29-02062906_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.29.6/linux-headers-2.6.29-02062906-generic_2.6.29-02062906_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.29.6/linux-image-2.6.29-02062906-generic_2.6.29-02062906_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.30.10/linux-headers-2.6.30-02063010_2.6.30-02063010_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.30.10/linux-headers-2.6.30-02063010-generic_2.6.30-02063010_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.30.10/linux-image-2.6.30-02063010-generic_2.6.30-02063010_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.31.13-karmic/linux-headers-2.6.31-02063113_2.6.31-02063113_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.31.13-karmic/linux-headers-2.6.31-02063113-generic_2.6.31-02063113_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.31.13-karmic/linux-image-2.6.31-02063113-generic_2.6.31-02063113_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.32.55-lucid/linux-headers-2.6.32-02063255_2.6.32-02063255.201201251735_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.32.55-lucid/linux-headers-2.6.32-02063255-generic_2.6.32-02063255.201201251735_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.32.55-lucid/linux-image-2.6.32-02063255-generic_2.6.32-02063255.201201251735_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.33.5-lucid/linux-headers-2.6.33-02063305_2.6.33-02063305_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.33.5-lucid/linux-headers-2.6.33-02063305-generic_2.6.33-02063305_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.33.5-lucid/linux-image-2.6.33-02063305-generic_2.6.33-02063305_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.34.10-maverick/linux-headers-2.6.34-02063410_2.6.34-02063410.201111101535_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.34.10-maverick/linux-headers-2.6.34-02063410-generic_2.6.34-02063410.201111101535_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.34.10-maverick/linux-image-2.6.34-02063410-generic_2.6.34-02063410.201111101535_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.35.13-maverick/linux-headers-2.6.35-02063512_2.6.35-02063512.201111232118_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.35.13-maverick/linux-headers-2.6.35-02063512-generic_2.6.35-02063512.201111232118_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.35.13-maverick/linux-image-2.6.35-02063512-generic_2.6.35-02063512.201111232118_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.36.4-natty/linux-headers-2.6.36-02063604_2.6.36-02063604.201102180911_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.36.4-natty/linux-headers-2.6.36-02063604-generic_2.6.36-02063604.201102180911_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.36.4-natty/linux-image-2.6.36-02063604-generic_2.6.36-02063604.201102180911_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.37.6-natty/linux-headers-2.6.37-02063706_2.6.37-02063706.201103281005_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.37.6-natty/linux-headers-2.6.37-02063706-generic_2.6.37-02063706.201103281005_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.37.6-natty/linux-image-2.6.37-02063706-generic_2.6.37-02063706.201103281005_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.38.8-natty/linux-headers-2.6.38-02063808_2.6.38-02063808.201106040910_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.38.8-natty/linux-headers-2.6.38-02063808-generic_2.6.38-02063808.201106040910_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.38.8-natty/linux-image-2.6.38-02063808-generic_2.6.38-02063808.201106040910_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v2.6.39.4-oneiric/linux-headers-2.6.39-02063904_2.6.39-02063904.201108040905_all.deb"
 KERNELS="$KERNELS ${KPATH}/v2.6.39.4-oneiric/linux-headers-2.6.39-02063904-generic_2.6.39-02063904.201108040905_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v2.6.39.4-oneiric/linux-image-2.6.39-02063904-generic_2.6.39-02063904.201108040905_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v3.0.18-oneiric/linux-headers-3.0.18-030018_3.0.18-030018.201201252135_all.deb"
 KERNELS="$KERNELS ${KPATH}/v3.0.18-oneiric/linux-headers-3.0.18-030018-generic_3.0.18-030018.201201252135_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v3.0.18-oneiric/linux-image-3.0.18-030018-generic_3.0.18-030018.201201252135_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v3.1.10-precise/linux-headers-3.1.10-030110_3.1.10-030110.201201181135_all.deb"
 KERNELS="$KERNELS ${KPATH}/v3.1.10-precise/linux-headers-3.1.10-030110-generic_3.1.10-030110.201201181135_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v3.1.10-precise/linux-image-3.1.10-030110-generic_3.1.10-030110.201201181135_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v3.2.2-precise/linux-headers-3.2.2-030202_3.2.2-030202.201201252035_all.deb"
 KERNELS="$KERNELS ${KPATH}/v3.2.2-precise/linux-headers-3.2.2-030202-generic_3.2.2-030202.201201252035_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v3.2.2-precise/linux-image-3.2.2-030202-generic_3.2.2-030202.201201252035_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v3.3.7-precise/linux-headers-3.3.7-030307_3.3.7-030307.201205211535_all.deb"
 KERNELS="$KERNELS ${KPATH}/v3.3.7-precise/linux-headers-3.3.7-030307-generic_3.3.7-030307.201205211535_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v3.3.7-precise/linux-image-3.3.7-030307-generic_3.3.7-030307.201205211535_${TARGET}.deb"
 
 KERNELS="$KERNELS ${KPATH}/v3.4.4-quantal/linux-headers-3.4.4-030404_3.4.4-030404.201206221555_all.deb"
 KERNELS="$KERNELS ${KPATH}/v3.4.4-quantal/linux-headers-3.4.4-030404-generic_3.4.4-030404.201206221555_${TARGET}.deb"
-KERNELS="$KERNELS ${KPATH}/v3.4.4-quantal/linux-image-3.4.4-030404-generic_3.4.4-030404.201206221555_${TARGET}.deb"
 
 function get_ubuntu_kernels() {
 
@@ -133,11 +112,6 @@ function get_ubuntu_kernels() {
 		FILE=$(basename $i)
 		PKG=$(echo $FILE | awk -F"_" '{print $1}')
 
-		echo "$i" | grep image 2>&1 > /dev/null
-		if [[ $? = 0 && $INSTALL_IMAGES != "y" ]]; then
-			continue
-		fi
-
 		# Do not download if installed or deb exists
 		if [[ ! -d /usr/src/$PKG && ! -f $FILE ]]; then
 			wget -c $i
@@ -173,27 +147,14 @@ function get_ubuntu_kernels() {
 }
 
 function usage() {
-	echo -e "Usage: $0 [ -i ]"
-	echo -e ""
-	echo -e "If you specify [ -i ] you will also download all kernel images and install them"
+	echo -e "Usage: $0"
 }
 
-INSTALL_IMAGES="n"
-
 if [[ $# -gt 1 ]]; then
 	usage
 	exit
 fi
 
-if [[ $# -eq 1 && $1 != "-i" ]]; then
-	usage
-	exit
-fi
-
-if [[ $# -eq 1 && $1 = "-i" ]]; then
-	INSTALL_IMAGES="y"
-fi
-
 which ar 2>&1 > /dev/null
 if [[ $? -ne 0 ]]; then
 	echo -e "${GREEN}ar${NORMAL} is not avilable, typically this is available through a package called binutils"
-- 
1.7.10.4

