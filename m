Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61112 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab2HISB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:01:56 -0400
Received: by wibhm11 with SMTP id hm11so601987wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:01:55 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 05/13] compat-wireless: Add 2 convenience functions
Date: Thu,  9 Aug 2012 21:01:24 +0300
Message-Id: <1344535292-4451-6-git-send-email-ozancag@gmail.com> (sfid-20120809_200201_816914_AF5BE5E3)
In-Reply-To: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add copyFiles and copyDirectories for not repeating same
code snippets again and again.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index aa7cbd6..1c516e9 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -165,6 +165,24 @@ nagometer() {
 
 }
 
+# Copy each file in $1 into $2
+copyFiles() {
+	FILES=$1
+	TARGET=$2
+	for file in $FILES; do
+		echo "Copying $GIT_TREE/$TARGET/$file"
+		cp "$GIT_TREE/$TARGET/$file" $TARGET/
+	done
+}
+
+copyDirectories() {
+	DIRS=$1
+	for dir in $DIRS; do
+		echo "Copying $GIT_TREE/$dir/*.[ch]"
+		cp $GIT_TREE/$dir/{Kconfig,Makefile,*.[ch]} $dir/ &> /dev/null
+	done
+}
+
 # First check cmdline args to understand
 # which patches to apply and which release tag to set.
 #
-- 
1.7.11.2

