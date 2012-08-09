Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64271 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396Ab2HISCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:02:32 -0400
Received: by wgbdr13 with SMTP id dr13so694233wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:02:31 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 10/13] compat-wireless: Selectively apply patches
Date: Thu,  9 Aug 2012 21:01:29 +0300
Message-Id: <1344535292-4451-11-git-send-email-ozancag@gmail.com> (sfid-20120809_200256_364219_7CEFC759)
In-Reply-To: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patches are now structured in network/ and drm/ subfolders.
Apply them only if the relevant subsystem is enabled.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh | 49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index b5dbc4e..e701406 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -143,7 +143,7 @@ nagometer() {
 
 	let CHANGES=$ADD+$DEL
 
-	case $1 in
+	case `dirname $1` in
 	"patches")
 		brag_backport $ORIG_CODE $CHANGES $ADD $DEL
 		;;
@@ -201,6 +201,7 @@ copyDirectories() {
 # These switches determines which drivers to fetch in.
 ENABLE_NETWORK=
 ENABLE_DRM=
+SUBSYSTEMS=
 
 EXTRA_PATCHES="patches"
 REFRESH="n"
@@ -262,6 +263,15 @@ if [ $# -ge 1 ]; then
 	done
 fi
 
+# SUBSYSTEMS is used to select which patches to apply
+if [[ -n "$ENABLE_NETWORK" ]]; then
+	SUBSYSTEMS="network"
+fi
+
+if [[ -n "$ENABLE_DRM" ]]; then
+	SUBSYSTEMS+=" drm"
+fi
+
 # User exported this variable
 if [ -z $GIT_TREE ]; then
 	GIT_TREE="$HOME/linux-next"
@@ -604,25 +614,28 @@ for dir in $EXTRA_PATCHES; do
 	LAST_ELEM=$dir
 done
 
-for dir in $EXTRA_PATCHES; do
-	if [[ ! -d $dir ]]; then
-		echo -e "${RED}Patches: $dir empty, skipping...${NORMAL}\n"
-		continue
-	fi
-	if [[ $LAST_ELEM = $dir && "$REFRESH" = y ]]; then
-		patchRefresh $dir
-	fi
-
-	for i in $(ls -v $dir/*.patch &> /dev/null); do
-		echo -e "${GREEN}Applying backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
-		patch -p1 -N -t < $i
-		RET=$?
-		if [[ $RET -ne 0 ]]; then
-			echo -e "${RED}Patching $i failed${NORMAL}, update it"
-			exit $RET
+for subsystem in $SUBSYSTEMS; do
+	for dir in $EXTRA_PATCHES; do
+		PATCHDIR="$dir/$subsystem"
+		if [[ ! -d $PATCHDIR ]]; then
+			echo -e "${RED}Patches: $PATCHDIR empty, skipping...${NORMAL}\n"
+			continue
+		fi
+		if [[ $LAST_ELEM = $dir && "$REFRESH" = y ]]; then
+			patchRefresh $dir
 		fi
+
+		for i in $(ls -v $PATCHDIR/*.patch 2> /dev/null); do
+			echo -e "${GREEN}Applying backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
+			patch -p1 -N -t < $i
+			RET=$?
+			if [[ $RET -ne 0 ]]; then
+				echo -e "${RED}Patching $i failed${NORMAL}, update it"
+				exit $RET
+			fi
+		done
+		nagometer $PATCHDIR $ORIG_CODE >> $CODE_METRICS
 	done
-	nagometer $dir $ORIG_CODE >> $CODE_METRICS
 done
 
 DIR="$PWD"
-- 
1.7.11.2

