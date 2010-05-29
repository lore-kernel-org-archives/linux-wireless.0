Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55753 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab0E2NfU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 May 2010 09:35:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: run refresh only on last applied directory
Date: Sat, 29 May 2010 15:35:07 +0200
Message-Id: <1275140107-4616-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1275140107-4616-1-git-send-email-hauke@hauke-m.de>
References: <1275140107-4616-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

running "./scripts/admin-refresh.sh -n -p -c refresh" failed because the patches were applied but

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 99ab6c3..36cce31 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -391,12 +391,6 @@ patchRefresh() {
 	rm -rf patches.orig .pc $1/series
 }
 
-if [[ "$REFRESH" = "y" ]]; then
-	for dir in $EXTRA_PATCHES; do
-		patchRefresh $dir
-	done
-fi
-
 ORIG_CODE=$(find ./ -type f -name  \*.[ch] |
 	egrep -v "^./compat/|include/linux/compat" |
 	xargs wc -l | tail -1 | awk '{print $1}')
@@ -404,6 +398,14 @@ printf "\n${CYAN}compat-wireless code metrics${NORMAL}\n\n" > $CODE_METRICS
 printf "${PURPLE}%10s${NORMAL} - Total upstream code being pulled\n" $ORIG_CODE >> $CODE_METRICS
 
 for dir in $EXTRA_PATCHES; do
+	LAST_ELEM=$dir
+done
+
+for dir in $EXTRA_PATCHES; do
+	if [[ $LAST_ELEM = $dir && "$REFRESH" = y ]]; then
+		patchRefresh $dir
+	fi
+
 	FOUND=$(find $dir/ -name \*.patch | wc -l)
 	if [ $FOUND -eq 0 ]; then
 		continue
-- 
1.7.0.4

