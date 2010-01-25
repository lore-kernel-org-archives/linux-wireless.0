Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:35756 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab0AYXBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 18:01:14 -0500
Date: Mon, 25 Jan 2010 22:57:02 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] Tweak version handling to allow vendor-specific suffixes without patching.
Message-ID: <50E4CCD2A8%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <50E4CB7318%linux@youmustbejoking.demon.co.uk>
References: <1264458811-21411-1-git-send-email-linux@youmustbejoking.demon.co.uk>
 <50E4CB7318%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This overrides the "git describe" suffix for when the packaging is in git.

---
 Makefile   |    4 ++++
 version.sh |   11 ++++++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 2c5fd9e..8d6c700 100644
--- a/Makefile
+++ b/Makefile
@@ -29,7 +29,11 @@ VERSION_OBJS := $(filter-out version.o, $(OBJS))
 version.c: version.sh $(patsubst %.o,%.c,$(VERSION_OBJS)) rfkill.h Makefile
\
 		$(wildcard .git/index .git/refs/tags)
 	@$(NQ) ' GEN ' $@
+ifeq (,$(VERSION_SUFFIX))
 	$(Q)./version.sh $@
+else
+	$(Q)./version.sh --suffix "$(VERSION_SUFFIX)" $@
+endif
 
 %.o: %.c rfkill.h
 	@$(NQ) ' CC  ' $@
diff --git a/version.sh b/version.sh
index 957684b..28b579a 100755
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
+if test "x$SUFFIX" != 'x'; then
+	v="$VERSION$SUFFIX"
+elif head=`git rev-parse --verify HEAD 2>/dev/null`; then
 	git update-index --refresh --unmerged > /dev/null
 	descr=$(git describe 2>/dev/null || echo "v$VERSION")
 
-- 
1.6.5
