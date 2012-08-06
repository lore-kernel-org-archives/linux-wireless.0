Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45715 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab2HFTFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:05:46 -0400
Received: by eaac11 with SMTP id c11so948907eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:05:45 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat-wireless: Fix another $HOME glitch, unify file lists
Date: Mon,  6 Aug 2012 22:05:38 +0300
Message-Id: <1344279938-4789-1-git-send-email-ozancag@gmail.com> (sfid-20120806_210549_654955_F5350472)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- Drop duplicate lines in WSTABLE,
- Do not call mkdir -p for a second time,
- Fix another $USER/$HOME glitch.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh | 49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 3558801..73c3939 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -228,12 +228,12 @@ fi
 
 # User exported this variable
 if [ -z $GIT_TREE ]; then
-	GIT_TREE="$HOME/linux-next/"
+	GIT_TREE="$HOME/linux-next"
 	if [ ! -d $GIT_TREE ]; then
 		echo "Please tell me where your linux-next git tree is."
 		echo "You can do this by exporting its location as follows:"
 		echo
-		echo "  export GIT_TREE=$HOME/linux-next/"
+		echo "  export GIT_TREE=$HOME/linux-next"
 		echo
 		echo "If you do not have one you can clone the repository:"
 		echo "  git clone $GIT_URL"
@@ -247,12 +247,12 @@ else
 fi
 
 if [ -z $GIT_COMPAT_TREE ]; then
-	GIT_COMPAT_TREE="$HOME/compat/"
+	GIT_COMPAT_TREE="$HOME/compat"
 	if [ ! -d $GIT_COMPAT_TREE ]; then
 		echo "Please tell me where your compat git tree is."
 		echo "You can do this by exporting its location as follows:"
 		echo
-		echo "  export GIT_COMPAT_TREE=$HOME/compat/"
+		echo "  export GIT_COMPAT_TREE=$HOME/compat"
 		echo
 		echo "If you do not have one you can clone the repository:"
 		echo "  git clone $GIT_COMPAT_URL"
@@ -351,13 +351,17 @@ DRIVER_FILES="$DRIVER_FILES mwl8k.c"
 
 rm -rf drivers/
 
-mkdir -p include/linux/ include/net/ include/linux/usb \
+mkdir -p include/linux/ \
+	include/net/ \
+	include/net/bluetooth \
+	include/linux/usb \
 	include/linux/unaligned \
 	include/linux/spi \
 	include/trace \
 	include/pcmcia \
 	include/crypto \
-	net/mac80211/ net/wireless/ \
+	net/mac80211/ \
+	net/wireless/ \
 	net/rfkill/ \
 	drivers/ssb/ \
 	drivers/bcma/ \
@@ -365,7 +369,6 @@ mkdir -p include/linux/ include/net/ include/linux/usb \
 	drivers/net/wireless/ \
 	drivers/net/ethernet/atheros \
 	drivers/net/ethernet/broadcom
-mkdir -p include/net/bluetooth/
 
 # include/linux
 DIR="include/linux"
@@ -516,33 +519,31 @@ rm -f $COMPAT/*.mod.c
 
 # files we suck in for wireless drivers
 export WSTABLE="
-        net/wireless/
-        net/wireless/
-        net/mac80211/
-        net/rfkill/
-        drivers/net/wireless/
-        net/bluetooth/
-        drivers/bluetooth/
-        drivers/net/ethernet/atheros/atl1c/
-        drivers/net/ethernet/atheros/atl1e/
-        drivers/net/ethernet/atheros/atlx/
-        include/linux/nl80211.h
-        include/linux/rfkill.h
-        include/net/cfg80211.h
+	net/wireless/
+	net/mac80211/
+	net/rfkill/
+	drivers/net/wireless/
+	net/bluetooth/
+	drivers/bluetooth/
+	drivers/net/ethernet/atheros/atl1c/
+	drivers/net/ethernet/atheros/atl1e/
+	drivers/net/ethernet/atheros/atlx/
+	include/linux/nl80211.h
+	include/linux/rfkill.h
 	include/net/mac80211.h
-        include/net/regulatory.h
-        include/net/cfg80211.h"
+	include/net/regulatory.h
+	include/net/cfg80211.h"
 
 # Stable pending, if -n was passed
 if [[ "$GET_STABLE_PENDING" = y ]]; then
 
 	if [ -z $NEXT_TREE ]; then
-		NEXT_TREE="/home/$USER/linux-next/"
+		NEXT_TREE="/$HOME/linux-next"
 		if [ ! -d $NEXT_TREE ]; then
 			echo "Please tell me where your linux-next git tree is."
 			echo "You can do this by exporting its location as follows:"
 			echo
-			echo "  export NEXT_TREE=/home/$USER/linux-next/"
+			echo "  export NEXT_TREE=$HOME/linux-next"
 			echo
 			echo "If you do not have one you can clone the repository:"
 			echo "  git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"
-- 
1.7.11.2

