Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54652 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab0IDPHI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Sep 2010 11:07:08 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/5] compat-wireless: handle depending on something build as module
Date: Sat,  4 Sep 2010 17:06:46 +0200
Message-Id: <1283612809-6798-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1283612809-6798-1-git-send-email-hauke@hauke-m.de>
References: <1283612809-6798-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If something was build as module in the kernel it is named
CONFIG_..._MODULE in autoconf.h. We have to check for bouth the name
with and wothout _MODULE at the end.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/gen-compat-autoconf.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index bd189a2..9f6e6d2 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -148,11 +148,11 @@ kernel_version_req $OLDEST_KERNEL_SUPPORTED
 for i in $(egrep '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else #CONFIG_' $COMPAT_CONFIG | sed 's/ /+/'); do
 	case $i in
 	'ifdef+CONFIG_'* )
-		echo "#$i" | sed 's/+/ /' | sed 's/\(ifdef CONFIG_COMPAT_KERNEL_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/'
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifdef \)\(CONFIG_[^:space:]*\)/#if defined(\2) || defined(\2_MODULE)/'
 		continue
 		;;
 	'ifndef+CONFIG_'* )
-		echo "#$i" | sed 's/+/ /' | sed 's/\(ifndef CONFIG_COMPAT_KERNEL_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/'
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
 		continue
 		;;
 	'else+#CONFIG_'* | 'endif+#CONFIG_'* )
-- 
1.7.0.4

