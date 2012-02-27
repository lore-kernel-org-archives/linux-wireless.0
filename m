Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60000 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab2B0PyN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:54:13 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH] compat-wireless: fix directory copying in admin-update.sh
Date: Mon, 27 Feb 2012 15:51:44 +0100
Message-Id: <1330354304-69044-1-git-send-email-nbd@openwrt.org> (sfid-20120227_165417_358610_5AB368F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On my system the trailing slash leads to the directory contents being copied
to the target instead of the full directory, which results in breakage during
build.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 scripts/admin-update.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 369cc96..34022b7 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -425,8 +425,8 @@ mkdir -p $COMPAT
 echo "Copying $GIT_COMPAT_TREE/ files..."
 cp $GIT_COMPAT_TREE/compat/*.c $COMPAT/
 cp $GIT_COMPAT_TREE/compat/Makefile $COMPAT/
-cp -a $GIT_COMPAT_TREE/udev/ .
-cp -a $GIT_COMPAT_TREE/scripts/ $COMPAT/
+cp -a $GIT_COMPAT_TREE/udev .
+cp -a $GIT_COMPAT_TREE/scripts $COMPAT/
 cp -a $GIT_COMPAT_TREE/include/linux/* include/linux/
 cp -a $GIT_COMPAT_TREE/include/net/* include/net/
 cp -a $GIT_COMPAT_TREE/include/trace/* include/trace/
-- 
1.7.3.2

