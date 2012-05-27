Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37380 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2E0Ki6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2012 06:38:58 -0400
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 1/2] bin/ckmake: Relax distribution check
Date: Sun, 27 May 2012 13:38:27 +0300
Message-Id: <1338115108-19091-1-git-send-email-ozancag@gmail.com> (sfid-20120527_123939_876906_A029C4EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not check specifically for Ubuntu as we will be using Ubuntu vanilla
kernels for every distribution.

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

