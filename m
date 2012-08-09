Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:44127 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab2HISCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:02:36 -0400
Received: by weyx8 with SMTP id x8so458482wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:02:35 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 11/13] compat-wireless: Move refresh logic into the loop
Date: Thu,  9 Aug 2012 21:01:30 +0300
Message-Id: <1344535292-4451-12-git-send-email-ozancag@gmail.com> (sfid-20120809_200253_032673_D2ACD09E)
In-Reply-To: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index e701406..f0c7ad0 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -610,11 +610,12 @@ ORIG_CODE=$(find ./ -type f -name  \*.[ch] |
 printf "\n${CYAN}compat-drivers code metrics${NORMAL}\n\n" > $CODE_METRICS
 printf "${PURPLE}%10s${NORMAL} - Total upstream lines of code being pulled\n" $ORIG_CODE >> $CODE_METRICS
 
-for dir in $EXTRA_PATCHES; do
-	LAST_ELEM=$dir
-done
-
 for subsystem in $SUBSYSTEMS; do
+
+	for dir in $EXTRA_PATCHES; do
+		LAST_ELEM=$dir
+	done
+
 	for dir in $EXTRA_PATCHES; do
 		PATCHDIR="$dir/$subsystem"
 		if [[ ! -d $PATCHDIR ]]; then
@@ -622,7 +623,7 @@ for subsystem in $SUBSYSTEMS; do
 			continue
 		fi
 		if [[ $LAST_ELEM = $dir && "$REFRESH" = y ]]; then
-			patchRefresh $dir
+			patchRefresh $PATCHDIR
 		fi
 
 		for i in $(ls -v $PATCHDIR/*.patch 2> /dev/null); do
-- 
1.7.11.2

