Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:57061 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572Ab0AYWdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 17:33:37 -0500
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] Tweak version handling to allow vendor-specific suffixes without patching. This overrides the "git describe" suffix for when the packaging is in git.
Date: Mon, 25 Jan 2010 22:33:29 +0000
Message-Id: <1264458811-21411-1-git-send-email-linux@youmustbejoking.demon.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 Makefile   |    4 ++++
 version.sh |   13 +++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 2c5fd9e..770efd1 100644
--- a/Makefile
+++ b/Makefile
@@ -29,7 +29,11 @@ VERSION_OBJS := $(filter-out version.o, $(OBJS))
 version.c: version.sh $(patsubst %.o,%.c,$(VERSION_OBJS)) rfkill.h Makefile \
 		$(wildcard .git/index .git/refs/tags)
 	@$(NQ) ' GEN ' $@
+ifeq (,$(VERSION_SUFFIX))
 	$(Q)./version.sh $@
+else
+	$(Q)./version.sh --suffix "$(VERSION_SUFFIX") $@
+endif
 
 %.o: %.c rfkill.h
 	@$(NQ) ' CC  ' $@
diff --git a/version.sh b/version.sh
index 957684b..8984b39 100755
--- a/version.sh
+++ b/version.sh
@@ -1,9 +1,18 @@
 #!/bin/sh
 
 VERSION="0.3"
+
+SUFFIX=
+if test "x$1" = x--suffix; then
+	shift
+	SUFFIX="-$1"
+	shift
+fi
 OUT="$1"
 
-if head=`git rev-parse --verify HEAD 2>/dev/null`; then
+if test "x$SUFFIX" = ''; then
+	v="$VERSION"
+elif head=`git rev-parse --verify HEAD 2>/dev/null`; then
 	git update-index --refresh --unmerged > /dev/null
 	descr=$(git describe 2>/dev/null || echo "v$VERSION")
 
@@ -17,7 +26,7 @@ if head=`git rev-parse --verify HEAD 2>/dev/null`; then
 		v="$v"-dirty
 	fi
 else
-	v="$VERSION"
+	v="$VERSION$SUFFIX"
 fi
 
 echo "const char rfkill_version[] = \"$v\";" > "$OUT"
-- 
1.6.5

