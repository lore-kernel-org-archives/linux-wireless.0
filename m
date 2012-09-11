Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43352 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2IKGdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 02:33:05 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <mcgrof@do-not-panic.com>
CC: <mcgrof@frijolero.org>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat-drivers: Use GIT_TREE variable.
Date: Tue, 11 Sep 2012 11:59:24 +0530
Message-ID: <1347344964-4120-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120911_083310_203616_89B53CBF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In gen-stable-release.sh stable git tree path is hardcoded.
Use GIT_TREE environment variable if specified.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 scripts/gen-stable-release.sh | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/scripts/gen-stable-release.sh b/scripts/gen-stable-release.sh
index 5a7dc5f..fee1ac7 100755
--- a/scripts/gen-stable-release.sh
+++ b/scripts/gen-stable-release.sh
@@ -21,6 +21,7 @@ RED="\033[31m"
 PURPLE="\033[35m"
 CYAN="\033[36m"
 UNDERLINE="\033[02m"
+GIT_STABLE_URL="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
 
 # Note that this tree may not have the latest RC stuff, so you should also add
 # Linus' tree as a remote and fetch those objects if you want to make an RC
@@ -47,7 +48,21 @@ function usage()
 UPDATE_ARGS=""
 POSTFIX_RELEASE_TAG="-"
 
-export GIT_TREE=$HOME/$ALL_STABLE_TREE
+if [ -z $GIT_TREE ]; then
+	export GIT_TREE=$HOME/$ALL_STABLE_TREE
+	if [ ! -d $GIT_TREE ]; then
+		echo "Please tell me where your linux-stable git tree is."
+		echo "You can do this by exporting its location as follows:"
+		echo
+		echo "  export GIT_TREE=/home/$USER/linux-stable/"
+		echo
+		echo "If you do not have one you can clone the repository:"
+		echo "  git clone $GIT_STABLE_URL"
+		exit 1
+	fi
+else
+	echo "You said to use git tree at: $GIT_TREE for linux-stable"
+fi
 COMPAT_WIRELESS_DIR=$(pwd)
 COMPAT_WIRELESS_BRANCH=$(git branch | grep \* | awk '{print $2}')
 
-- 
1.7.11.4

