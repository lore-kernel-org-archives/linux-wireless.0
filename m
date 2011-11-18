Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46687 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1KRToP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 14:44:15 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: escape &
Date: Fri, 18 Nov 2011 20:44:05 +0100
Message-Id: <1321645446-22527-2-git-send-email-hauke@hauke-m.de> (sfid-20111118_204418_878734_83893579)
In-Reply-To: <1321645446-22527-1-git-send-email-hauke@hauke-m.de>
References: <1321645446-22527-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

& needs to be escaped.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/gen-compat-autoconf.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 0063478..28ed25a 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -152,7 +152,7 @@ for i in $(egrep '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else
 		continue
 		;;
 	'ifndef+CONFIG_'* )
-		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_3_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,\2,0))/' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(ifndef CONFIG_COMPAT_RHEL_\)\([0-9]*\)_\([0-9]*\)/if (!defined(RHEL_MAJOR) || RHEL_MAJOR != \2 || RHEL_MINOR < \3)/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_3_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,\2,0))/' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(ifndef CONFIG_COMPAT_RHEL_\)\([0-9]*\)_\([0-9]*\)/if (!defined(RHEL_MAJOR) || RHEL_MAJOR != \2 || RHEL_MINOR < \3)/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) \&\& !defined(\2_MODULE)/'
 		continue
 		;;
 	'else+#CONFIG_'* | 'endif+#CONFIG_'* )
-- 
1.7.4.1

