Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42330 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab0AAQWj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2010 11:22:39 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] This adds a refresh option to admin-update.sh using quilt.
Date: Fri,  1 Jan 2010 17:21:10 +0100
Message-Id: <1262362872-10251-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
References: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It must run before applying all patches so an extra script will not work
so good. It applies all patches using quilt and automatically refreshes
then.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-refresh.sh |    4 ++--
 scripts/admin-update.sh  |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/scripts/admin-refresh.sh b/scripts/admin-refresh.sh
index 743ecd4..5848b1e 100755
--- a/scripts/admin-refresh.sh
+++ b/scripts/admin-refresh.sh
@@ -1,3 +1,3 @@
 #!/bin/bash
-./scripts/admin-clean.sh
-./scripts/admin-update.sh
+./scripts/admin-clean.sh $@
+./scripts/admin-update.sh $@
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index d029451..7c63202 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -237,6 +237,40 @@ cp $GIT_COMPAT_TREE/compat/Makefile $COMPAT/
 cp $GIT_COMPAT_TREE/include/linux/*.h include/linux/
 rm -f $COMPAT/*.mod.c
 
+# Refresh patches using quilt
+patchRefresh() {
+	if [ -d patches.orig ] ; then
+		rm -rf .pc patches/series
+	else
+		mkdir patches.orig
+	fi
+
+	mv -u patches/* patches.orig/
+
+	for i in patches.orig/*.patch; do
+		echo -e "${GREEN}Refresh backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
+		quilt import $i
+		quilt push -f
+		RET=$?
+		if [[ $RET -ne 0 ]]; then
+			echo -e "${RED}Refreshing $i failed${NORMAL}, update it"
+			echo -e "use ${CYAN}quilt edit [filename]${NORMAL} to apply the failed part manually"
+			echo -e "use ${CYAN}quilt refresh${NORMAL} after the files are corrected and rerun this script"
+			cp patches.orig/README patches/README
+			exit $RET
+		fi
+		QUILT_DIFF_OPTS="-p" quilt refresh -p ab --no-index --no-timestamp
+	done
+	quilt pop -a
+
+	cp patches.orig/README patches/README
+	rm -rf patches.orig .pc patches/series
+}
+
+if [[ "$1" = "refresh" ]]; then
+	patchRefresh
+fi
+
 for i in patches/*.patch; do
 	echo -e "${GREEN}Applying backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
 	patch -p1 -N -t < $i
-- 
1.6.3.3

