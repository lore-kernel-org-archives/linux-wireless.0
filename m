Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61112 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2HISCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:02:24 -0400
Received: by mail-wi0-f172.google.com with SMTP id hm11so601987wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:02:24 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 08/13] compat-wireless: No need to search for patches
Date: Thu,  9 Aug 2012 21:01:27 +0300
Message-Id: <1344535292-4451-9-git-send-email-ozancag@gmail.com> (sfid-20120809_200228_307936_F508A311)
In-Reply-To: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't search for patches with find. Just silent ls errors.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 05ec449..555b61b 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -613,11 +613,7 @@ for dir in $EXTRA_PATCHES; do
 		patchRefresh $dir
 	fi
 
-	FOUND=$(find $dir/ -maxdepth 1 -name \*.patch | wc -l)
-	if [ $FOUND -eq 0 ]; then
-		continue
-	fi
-	for i in $(ls -v $dir/*.patch); do
+	for i in $(ls -v $dir/*.patch &> /dev/null); do
 		echo -e "${GREEN}Applying backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
 		patch -p1 -N -t < $i
 		RET=$?
-- 
1.7.11.2

