Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54109 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab1AIPcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 10:32:31 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: make NEXT_TREE configurable.
Date: Sun,  9 Jan 2011 16:32:19 +0100
Message-Id: <1294587141-11353-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1294587141-11353-1-git-send-email-hauke@hauke-m.de>
References: <1294587141-11353-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was assumed that the linux next tree is at ~/linux-next . Now the
directory can be set with NEXT_TREE like the other variables.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---

This should also go into stable.

 scripts/admin-update.sh |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index f23c33c..bf8e080 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -426,6 +426,23 @@ export WSTABLE="
 
 # Stable pending, if -n was passed
 if [[ "$GET_STABLE_PENDING" = y ]]; then
+
+	if [ -z $NEXT_TREE ]; then
+		NEXT_TREE="/home/$USER/linux-next/"
+		if [ ! -d $NEXT_TREE ]; then
+			echo "Please tell me where your linux-next git tree is."
+			echo "You can do this by exporting its location as follows:"
+			echo
+			echo "  export NEXT_TREE=/home/$USER/linux-next/"
+			echo
+			echo "If you do not have one you can clone the repository:"
+			echo "  git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"
+			exit 1
+		fi
+	else
+		echo "You said to use git tree at: $NEXT_TREE for linux-next"
+	fi
+
 	LAST_DIR=$PWD
 	cd $GIT_TREE
 	if [ -f localversion* ]; then
@@ -436,11 +453,6 @@ if [[ "$GET_STABLE_PENDING" = y ]]; then
 	# we now assume you are using a stable tree
 	cd $GIT_TREE
 	LAST_STABLE_UPDATE=$(git describe --abbrev=0)
-	NEXT_TREE="/home/$USER/linux-next/"
-	if [ ! -d $NEXT_TREE ]; then
-		echo -e "You are expected to have $NEXT_TREE directory when using -s"
-		exit 1
-	fi
 	cd $NEXT_TREE
 	PENDING_STABLE_DIR="pending-stable/"
 
-- 
1.7.1

