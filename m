Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33791 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab0IKQTN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:19:13 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/8] compat-wireless: remove special handling for CONFIG_CFG80211_WEXT
Date: Sat, 11 Sep 2010 18:18:32 +0200
Message-Id: <1284221913-22455-9-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284221913-22455-1-git-send-email-hauke@hauke-m.de>
References: <1284221913-22455-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The special handling for CONFIG_CFG80211_WEXT is not needed any more,
because it is only activated when CONFIG_WIRELESS_EXT is also set.
Enabling this condition only for kernel <= 2.6.32 was wrong. In compat-
wireless we are able to deactivate CONFIG_WIRELESS_EXT for every
kernel. For activating it we need CONFIG_WIRELESS_EXT on every kernel.
If kernel <= 2.6.31 was build with cfg80211 support CONFIG_WIRELESS_EXT
was also selected, so it was activated in most cases for that kernel
versions. But it is possible to build compat-wireless without having
cfg80211 while building the kernel and that caused problems in the past.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                      |   20 ++++++++------------
 scripts/gen-compat-autoconf.sh |    4 ----
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/config.mk b/config.mk
index 464a769..f2c62ed 100644
--- a/config.mk
+++ b/config.mk
@@ -183,19 +183,15 @@ CONFIG_BT_HCIBTUART=m
 endif #CONFIG_PCMCIA
 
 
-# CONFIG_CFG80211_WEXT will be resepected for
-# future kernels but for older kenrels we need
-# to enable it against the the old CONFIG_WIRELESS_EXT.
-# By using a space here we prevent scripts/gen-compat-autoconf.sh
-# from defining CONFIG_CFG80211_WEXT through its grep sweep for ^CONFIG
-# options, instead its handled specially there based on kernel revision.
-# using this logic: if you are on older kernel and have CONFIG_WIRELESS_EXT
-# defined we'll define it.
-#
-# For newer kernels we'll just respect your own kernel's
-# autoconf.h
+# We need CONFIG_WIRELESS_EXT for CONFIG_CFG80211_WEXT for every kernel 
+# version. The new way CONFIG_CFG80211_WEXT is called from the kernel 
+# does not work with compat-wireless because it calls some callback 
+# function on struct wiphy. This struct is shipped with compat-wireless 
+# and changes from kernel version to version. We are using the 
+# wireless_handlers attribute which will be activated by 
+# CONFIG_WIRELESS_EXT. 
 ifdef CONFIG_WIRELESS_EXT
- CONFIG_CFG80211_WEXT=y
+CONFIG_CFG80211_WEXT=y
 else #CONFIG_CFG80211_WEXT
 $(warning "WARNING: CONFIG_CFG80211_WEXT will be deactivated or not working because kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface like iwconfig will not work. To activate it build your kernel e.g. with CONFIG_LIBIPW=m.")
 endif #CONFIG_WIRELESS_EXT
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 62aa890..9f6e6d2 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -195,10 +195,6 @@ if [ -f $KLIB_BUILD/Makefile ]; then
 		echo CONFIG_NETDEVICES_MULTIQUEUE >> $MULT_DEP_FILE
 		define_config_multiple_deps CONFIG_MAC80211_QOS y $ALL_DEPS
 		rm -f $MULT_DEP_FILE
-		# Kernels >= 2.6.32 can disable WEXT :D
-		if [ $SUBLEVEL -le 32 ]; then
-			define_config_dep CONFIG_CFG80211_WEXT 1 CONFIG_WIRELESS_EXT
-		fi
 	fi
 fi
 echo "#endif /* COMPAT_AUTOCONF_INCLUDED */"
-- 
1.7.0.4

