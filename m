Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55968 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab2GINrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:47:11 -0400
Received: by bkwj10 with SMTP id j10so5959815bkw.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 06:47:09 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Directly call perl instead of skip-colors
Date: Mon,  9 Jul 2012 16:47:03 +0300
Message-Id: <1341841623-21800-1-git-send-email-ozancag@gmail.com> (sfid-20120709_154717_244190_D45946B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we can now install ckmake with make, drop dependency
on scripts/skip-colors as it is a simple oneliner. Directly
call perl instead of using it.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 bin/ckmake |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/bin/ckmake b/bin/ckmake
index 5468b7a..2a0bb3d 100755
--- a/bin/ckmake
+++ b/bin/ckmake
@@ -41,7 +41,7 @@ done
 function tee_color_split()
 {
 	while read; do
-		echo -e $REPLY | ./scripts/skip-colors >> $1
+		echo -e $REPLY | perl -pe 's|(\e)\[(\d+)(;*)(\d*)(\w)||g' >> $1
 		echo -e $REPLY
 	done
 }
@@ -104,7 +104,7 @@ function run_ckmake()
 		# We cannot use tee_color_split() as bash read only spits
 		# out output when a newline comes in. We can modif IFS but
 		# I am still not sure how to do this properly.
-		log_try_kernel $KERNEL | ./scripts/skip-colors >> $LOG
+		log_try_kernel $KERNEL | perl -pe 's|(\e)\[(\d+)(;*)(\d*)(\w)||g' >> $LOG
 		log_try_kernel $KERNEL
 
 		#ionice -c 3 nice -n 20 make $QUIET KLIB=$DIR KLIB_BUILD=$DIR -j6 -Wunused-but-set-variable $ARGS &>> $LOG
-- 
1.7.10.4

