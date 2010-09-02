Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53341 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab0IBNdT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 09:33:19 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] compat-wireless: convert ifndef for compat_autoconf.h
Date: Thu,  2 Sep 2010 15:32:54 +0200
Message-Id: <1283434377-26210-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1283434377-26210-1-git-send-email-hauke@hauke-m.de>
References: <1283434377-26210-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only ifdef CONFIG_COMPAT_KERNEL_ was converted to something checking the kernel version. Now also ifndef is converted to the correct check.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/gen-compat-autoconf.sh |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 65232ab..5d38ea1 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -147,10 +147,14 @@ kernel_version_req $OLDEST_KERNEL_SUPPORTED
 # For each CONFIG_FOO=x option
 for i in $(egrep '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else #CONFIG_' $COMPAT_CONFIG | sed 's/ /+/'); do
 	case $i in
-	'ifdef+CONFIG_'* | 'ifndef+CONFIG_'* ) #
+	'ifdef+CONFIG_'* )
 		echo "#$i" | sed 's/+/ /' | sed 's/\(ifdef CONFIG_COMPAT_KERNEL_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/'
 		continue
 		;;
+	'ifndef+CONFIG_'* )
+		echo "#$i" | sed 's/+/ /' | sed 's/\(ifndef CONFIG_COMPAT_KERNEL_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/'
+		continue
+		;;
 	'else+#CONFIG_'* | 'endif+#CONFIG_'* )
 		echo "#$i */" |sed -e 's/+#/ \/* /g'
 		continue
-- 
1.7.0.4

