Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from star.freakempire.de ([37.221.197.231]:43129 "EHLO
	star.geekplace.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3IFPti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 11:49:38 -0400
From: Florian Schmaus <fschmaus@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Florian Schmaus <fschmaus@gmail.com>
Subject: [PATCH] Don't get iw version from git if there is no .git/
Date: Fri,  6 Sep 2013 17:41:10 +0200
Message-Id: <1378482070-8863-1-git-send-email-fschmaus@gmail.com> (sfid-20130906_174941_218823_D6E9E686)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The version.sh script should only try to get the version from git if the
source actually resides in a git repository, i.e. .git/ exists. Doing
otherwise in a non-git source repo results in git ascending until it
finds a .git directory, which will cause problems in some source-based
distributions ( https://bugs.gentoo.org/show_bug.cgi?id=482334 ).
---
 version.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/version.sh b/version.sh
index 80e55ab..0f1aa1d 100755
--- a/version.sh
+++ b/version.sh
@@ -3,7 +3,7 @@
 VERSION="3.11"
 OUT="$1"
 
-if head=`git rev-parse --verify HEAD 2>/dev/null`; then
+if [ -d .git ] && head=`git rev-parse --verify HEAD 2>/dev/null`; then
 	git update-index --refresh --unmerged > /dev/null
 	descr=$(git describe)
 
-- 
1.8.1.5

