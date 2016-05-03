Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33461 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbcECFua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 01:50:30 -0400
Received: by mail-pa0-f52.google.com with SMTP id xk12so5237447pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2016 22:50:30 -0700 (PDT)
From: Yongqin Liu <yongqin.liu@linaro.org>
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@intel.com, filbranden@google.com,
	Yongqin Liu <yongqin.liu@linaro.org>
Subject: [PATCH 1/1] version.sh: update to get version with git correctly
Date: Tue,  3 May 2016 13:48:48 +0800
Message-Id: <1462254528-15911-1-git-send-email-yongqin.liu@linaro.org> (sfid-20160503_075053_321143_A72BBFC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update to get the version information from the
git repository where this file is located instead of the
the current directory where it is executed, otherwise if
there is .git directory in the current directory, it will
get the wrong version information.

And improved the version check since the tag information
may not be mirrored like what AOSP does now.

Change-Id: I321113b74bf2a955c202f47dca68c1183ca55318
Signed-off-by: Yongqin Liu <yongqin.liu@linaro.org>
---
 version.sh | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/version.sh b/version.sh
index 7ccd419..c8111a6 100755
--- a/version.sh
+++ b/version.sh
@@ -3,20 +3,38 @@
 VERSION="4.3"
 OUT="$1"
 
-if [ -d .git ] && head=`git rev-parse --verify HEAD 2>/dev/null`; then
-	git update-index --refresh --unmerged > /dev/null
-	descr=$(git describe --match=v*)
+# get the absolute path for the OUT file
+OUT_NAME=$(basename ${OUT})
+OUT_DIR=$(cd $(dirname ${OUT}); pwd)
+OUT="${OUT_DIR}/${OUT_NAME}"
+
+# the version check should be under the source directory
+# where this script is located, instead of the currect directory
+# where this script is excuted.
+SRC_DIR=$(dirname $0)
+SRC_DIR=$(cd ${SRC_DIR}; pwd)
+cd "${SRC_DIR}"
 
-	# on git builds check that the version number above
-	# is correct...
-	[ "${descr%%-*}" = "v$VERSION" ] || exit 2
+v=""
+if [ -d .git ] && head=`git rev-parse --verify HEAD 2>/dev/null`; then
+    git update-index --refresh --unmerged > /dev/null
+    descr=$(git describe --match=v* 2>/dev/null)
+    if [ $? -eq 0 ]; then
+        # on git builds check that the version number above
+        # is correct...
+        if [ "${descr%%-*}" = "v$VERSION" ]; then
+            v="${descr#v}"
+            if git diff-index --name-only HEAD | read dummy ; then
+                v="$v"-dirty
+            fi
+        fi
+    fi
+fi
 
-	v="${descr#v}"
-	if git diff-index --name-only HEAD | read dummy ; then
-		v="$v"-dirty
-	fi
-else
-	v="$VERSION"
+# set to the default version when failed to get the version
+# information with git
+if [ -z "${v}" ]; then
+    v="$VERSION"
 fi
 
 echo '#include "iw.h"' > "$OUT"
-- 
2.1.4

