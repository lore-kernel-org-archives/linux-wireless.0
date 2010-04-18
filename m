Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55974 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab0DRNgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 09:36:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: include net and trace includes form compat.
Date: Sun, 18 Apr 2010 15:36:24 +0200
Message-Id: <1271597784-4811-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1271597784-4811-1-git-send-email-hauke@hauke-m.de>
References: <1271597784-4811-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The includes form the net and trace directory of compat were not copyed.
This broke compilation on older kernels that needed some files in these
directories from compat.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 36cdfac..39fafb2 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -116,6 +116,7 @@ DRIVER_FILES="$DRIVER_FILES mwl8k.c"
 mkdir -p include/linux/ include/net/ include/linux/usb \
 	include/linux/unaligned \
 	include/linux/spi \
+	include/trace \
 	net/mac80211/ net/wireless/ \
 	net/rfkill/ \
 	drivers/ssb/ \
@@ -233,6 +234,8 @@ cp $GIT_COMPAT_TREE/compat/Makefile $COMPAT/
 cp -a $GIT_COMPAT_TREE/udev/ .
 cp -a $GIT_COMPAT_TREE/scripts/ $COMPAT/
 cp -a $GIT_COMPAT_TREE/include/linux/* include/linux/
+cp -a $GIT_COMPAT_TREE/include/net/* include/net/
+cp -a $GIT_COMPAT_TREE/include/trace/* include/trace/
 rm -f $COMPAT/*.mod.c
 
 # Refresh patches using quilt
-- 
1.6.3.3

