Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40791 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2HISBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:01:54 -0400
Received: by wgbfm10 with SMTP id fm10so546868wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:01:53 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 04/13] compat-wireless: Add ability to enable/disable subsystems
Date: Thu,  9 Aug 2012 21:01:23 +0300
Message-Id: <1344535292-4451-5-git-send-email-ozancag@gmail.com> (sfid-20120809_200158_421089_961C6C60)
In-Reply-To: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass wlan,bluetooth,ethernet or drm to the end of the cmdline
to fetch the relevant drivers into the tree.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh | 94 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 61 insertions(+), 33 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 6d7ca54..aa7cbd6 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -74,8 +74,10 @@ patchRefresh() {
 # usage() function
 ###
 usage() {
-	printf "Usage: $0 [refresh] [ --help | -h | -s | -n | -p | -c ]\n"
+	printf "Usage: $0 [refresh] [ --help | -h | -s | -n | -p | -c ] <subsystem1 subsystem2 ..>\n
+  Where subsystems are: wlan, bluetooth, ethernet and drm.\n"
 
+	printf "\n"
 	printf "${GREEN}%10s${NORMAL} - Update all your patch offsets using quilt\n" "refresh"
 	printf "${GREEN}%10s${NORMAL} - Get and apply pending-stable/ fixes purging old files there\n" "-s"
 	printf "${GREEN}%10s${NORMAL} - Apply the patches from linux-next-cherry-picks directory\n" "-n"
@@ -178,12 +180,20 @@ nagometer() {
 # uses quilt to refresh the patches. This is useful if patches
 # can not be applied correctly after a code update in $GIT_URL.
 
+# These switches determines which drivers to fetch in.
+ENABLE_WLAN=
+ENABLE_ETH=
+ENABLE_DRM=
+ENABLE_BT=
+
 EXTRA_PATCHES="patches"
 REFRESH="n"
 GET_STABLE_PENDING="n"
 POSTFIX_RELEASE_TAG=""
+
+# Parse command line arguments
 if [ $# -ge 1 ]; then
-	if [ $# -gt 4 ]; then
+	if [ $# -gt 8 ]; then
 		usage $0
 		exit
 	fi
@@ -192,38 +202,56 @@ if [ $# -ge 1 ]; then
 		exit
 	fi
 	while [ $# -ne 0 ]; do
-		if [[ "$1" = "-s" ]]; then
-			GET_STABLE_PENDING="y"
-			EXTRA_PATCHES="${EXTRA_PATCHES} pending-stable" 
-			EXTRA_PATCHES="${EXTRA_PATCHES} pending-stable/backports/"
-			POSTFIX_RELEASE_TAG="${POSTFIX_RELEASE_TAG}s"
-			shift; continue;
-		fi
-		if [[ "$1" = "-n" ]]; then
-			EXTRA_PATCHES="${EXTRA_PATCHES} linux-next-cherry-picks"
-			POSTFIX_RELEASE_TAG="${POSTFIX_RELEASE_TAG}n"
-			shift; continue;
-		fi
-		if [[ "$1" = "-p" ]]; then
-			EXTRA_PATCHES="${EXTRA_PATCHES} linux-next-pending"
-			POSTFIX_RELEASE_TAG="${POSTFIX_RELEASE_TAG}p"
-			shift; continue;
-		fi
-		if [[ "$1" = "-c" ]]; then
-			EXTRA_PATCHES="${EXTRA_PATCHES} crap"
-			POSTFIX_RELEASE_TAG="${POSTFIX_RELEASE_TAG}c"
-			shift; continue;
-		fi
-		if [[ "$1" = "refresh" ]]; then
-			REFRESH="y"
-			shift; continue;
-		fi
-
-		echo "Unexpected argument passed: $1"
-		usage $0
-		exit
+		case $1 in
+			"-s")
+				GET_STABLE_PENDING="y"
+				EXTRA_PATCHES="${EXTRA_PATCHES} pending-stable" 
+				EXTRA_PATCHES="${EXTRA_PATCHES} pending-stable/backports/"
+				POSTFIX_RELEASE_TAG="${POSTFIX_RELEASE_TAG}s"
+				shift
+				;;
+			"-n")
+				EXTRA_PATCHES="${EXTRA_PATCHES} linux-next-cherry-picks"
+				POSTFIX_RELEASE_TAG="${POSTFIX_RELEASE_TAG}n"
+				shift
+				;;
+			"-p")
+				EXTRA_PATCHES="${EXTRA_PATCHES} linux-next-pending"
+				POSTFIX_RELEASE_TAG="${POSTFIX_RELEASE_TAG}p"
+				shift
+				;;
+			"-c")
+				EXTRA_PATCHES="${EXTRA_PATCHES} crap"
+				POSTFIX_RELEASE_TAG="${POSTFIX_RELEASE_TAG}c"
+				shift
+				;;
+			"refresh")
+				REFRESH="y"
+				shift
+				;;
+			"wlan")
+				ENABLE_WLAN=1
+				shift
+				;;
+			"bluetooth")
+				ENABLE_BT=1
+				shift
+				;;
+			"ethernet")
+				ENABLE_ETH=1
+				shift
+				;;
+			"drm")
+				ENABLE_DRM=1
+				shift
+				;;
+			*)
+				echo "Unexpected argument passed: $1"
+				usage $0
+				exit
+				;;
+		esac
 	done
-
 fi
 
 # User exported this variable
-- 
1.7.11.2

