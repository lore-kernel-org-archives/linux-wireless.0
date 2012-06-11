Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61981 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2FKVq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 17:46:27 -0400
Received: by weyu7 with SMTP id u7so2403515wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 14:46:26 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] bin/ckmake: Drop Ubuntu check
Date: Tue, 12 Jun 2012 00:46:19 +0300
Message-Id: <1339451179-21171-1-git-send-email-ozancag@gmail.com> (sfid-20120611_234630_584397_A53F847B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't check for distribution as it is now possible to use ckmake
on every distribution.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 bin/ckmake |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/bin/ckmake b/bin/ckmake
index 2d422af..9956cf1 100755
--- a/bin/ckmake
+++ b/bin/ckmake
@@ -31,18 +31,9 @@ ARGS=""
 
 RET=""
 
-LSB_RED_ID=$(/usr/bin/lsb_release -i -s)
-case $LSB_RED_ID in
-"Ubuntu")
-	for i in $(find /lib/modules/ -type d -name \*generic\* | sort -n -r | grep -v -E '\-[[:alnum:]]{1,2}\-'); do
-		KLIBS="$KLIBS $i"
-	done
-	;;
-*)
-	echo -e "Unsupported distribution"
-	exit
-	;;
-esac
+for i in $(find /lib/modules/ -type d -name \*generic\* | sort -n -r | grep -v -E '\-[[:alnum:]]{1,2}\-'); do
+	KLIBS="$KLIBS $i"
+done
 
 function tee_color_split()
 {
-- 
1.7.10.2

