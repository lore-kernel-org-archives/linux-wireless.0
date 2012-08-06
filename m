Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57887 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab2HFS4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 14:56:04 -0400
Received: by eaac11 with SMTP id c11so946654eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 11:56:02 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 2/2] compat-wireless: Small cosmetic changes
Date: Mon,  6 Aug 2012 21:55:07 +0300
Message-Id: <1344279307-2929-2-git-send-email-ozancag@gmail.com> (sfid-20120806_205607_406897_41AD8F2A)
In-Reply-To: <1344279307-2929-1-git-send-email-ozancag@gmail.com>
References: <1344279307-2929-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change old tree names to reflect the new ones, continue to replace
occurences of compat-* with compat-drivers.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-clean.sh         | 2 +-
 scripts/gen-compat-autoconf.sh | 2 +-
 scripts/gen-stable-release.sh  | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/admin-clean.sh b/scripts/admin-clean.sh
index 340a197..dd26670 100755
--- a/scripts/admin-clean.sh
+++ b/scripts/admin-clean.sh
@@ -11,4 +11,4 @@ rm -f .compat_base_tree
 rm -f .compat_base_tree_version
 rm -f .compat_version
 rm -f code-metrics.txt
-echo "Cleaned wireless-bt-compat-2.6"
+echo "Cleaned compat-drivers"
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 41b1973..f9fed36 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -136,7 +136,7 @@ cat <<EOF
  * Automatically generated C config: don't edit
  * $DATE 
  * compat-drivers: $CREL
- * linux-2.6: $KREL
+ * linux: $KREL
  */
 #define COMPAT_RELEASE "$CREL"
 #define COMPAT_KERNEL_RELEASE "$KREL"
diff --git a/scripts/gen-stable-release.sh b/scripts/gen-stable-release.sh
index c28e2cd..e787052 100755
--- a/scripts/gen-stable-release.sh
+++ b/scripts/gen-stable-release.sh
@@ -110,7 +110,7 @@ function check_for_updates()
 		git fetch
 		git reset --hard origin
 		;;
-	*) # Based on a stable 2.6.x.y release, lets just move to the target branch
+	*) # Based on a stable {2.6.x.y, 3.x.y} release, lets just move to the target branch
 	   # we'll only ask for object updates if and only if you asked us to with -f,
 	   # otherwise we eat up whatever you already have on your existing branch.
 		git checkout -f
@@ -121,7 +121,7 @@ function check_for_updates()
 	esac
 }
 
-# We will not update your linux-2.6-allstable git tree by default. You can force
+# We will not update your linux-stable git tree by default. You can force
 # an update by two methods:
 #
 # a) Specifying a different target branch
@@ -134,7 +134,7 @@ fi
 
 echo "On $ALL_STABLE_TREE: $TARGET_BRANCH"
 
-# At this point your linux-2.6-allstable tree should be up to date
+# At this point your linux-stable tree should be up to date
 # with the target kernel you want to use. Lets now make sure you are
 # on matching compat-drivers branch.
 
-- 
1.7.11.2

