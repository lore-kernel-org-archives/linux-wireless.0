Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42336 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0AAQXT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2010 11:23:19 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] compat-wireless: small fixes to admin-update.sh
Date: Fri,  1 Jan 2010 17:21:12 +0100
Message-Id: <1262362872-10251-6-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
References: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 7c63202..ddc64da 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -59,13 +59,13 @@ if [ -z $GIT_TREE ]; then
 		exit 1
 	fi
 else
-	echo "You said to use git tree at: $GIT_TREE for wireless"
+	echo "You said to use git tree at: $GIT_TREE for linux-next"
 fi
 
 if [ -z $GIT_COMPAT_TREE ]; then
 	GIT_COMPAT_TREE="/home/$USER/compat/"
 	if [ ! -d $GIT_COMPAT_TREE ]; then
-		echo "Please tell me where your bluetooth-testing git tree is."
+		echo "Please tell me where your compat git tree is."
 		echo "You can do this by exporting its location as follows:"
 		echo
 		echo "  export GIT_COMPAT_TREE=/home/$USER/compat/"
@@ -75,7 +75,7 @@ if [ -z $GIT_COMPAT_TREE ]; then
 		exit 1
 	fi
 else
-	echo "You said to use git tree at: $GIT_COMPAT_TREE for bluetooth"
+	echo "You said to use git tree at: $GIT_COMPAT_TREE for compat"
 fi
 
 # Drivers that have their own directory
@@ -98,9 +98,9 @@ DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
 DRIVERS="$DRIVERS drivers/net/wireless/iwmc3200wifi"
 
 # Ethernet drivers
-DRIVERS="$DRIVERS drivers/net/atl1c/"
-DRIVERS="$DRIVERS drivers/net/atl1e/"
-DRIVERS="$DRIVERS drivers/net/atlx/"
+DRIVERS="$DRIVERS drivers/net/atl1c"
+DRIVERS="$DRIVERS drivers/net/atl1e"
+DRIVERS="$DRIVERS drivers/net/atlx"
 
 # Bluetooth drivers
 DRIVERS_BT="drivers/bluetooth"
@@ -306,6 +306,11 @@ if [ -d ./.git ]; then
 		echo $MASTER_TAG > $DIR/master-tag
 		echo -e "This is a ${RED}bleeding edge${NORMAL} compat-wireless release based on: ${PURPLE}$MASTER_TAG${NORMAL}"
 		;;
+	"linux-next.git") # The linux-next integration testing tree
+		MASTER_TAG=$(git tag -l| grep next | tail -1)
+		echo $MASTER_TAG > $DIR/master-tag
+		echo -e "This is a ${RED}bleeding edge${NORMAL} compat-wireless release based on: ${PURPLE}$MASTER_TAG${NORMAL}"
+		;;
 	"linux-2.6-allstable.git") # HPA's all stable tree
 		echo -e "This is a ${GREEN}stable${NORMAL} compat-wireless release based on: ${PURPLE}$(git describe --abbrev=0)${NORMAL}"
 		;;
-- 
1.6.3.3

