Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44990 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab0GHVN7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 17:13:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: activate CONFIG_CFG80211_WEXT if possible
Date: Thu,  8 Jul 2010 23:13:47 +0200
Message-Id: <1278623628-25477-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_CFG80211_WEXT depends on CONFIG_WIRELESS_EXT for every kernel
version, because we use the wireless_handlers attribute.
CONFIG_CFG80211_WEXT should be set here every time it will be set in
config.mk.
The build was failing for kernel > 2.6.32 with CONFIG_WIRELESS_EXT=y

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/gen-compat-autoconf.sh |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 1e3002e..277467f 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -191,10 +191,7 @@ if [ -f $KLIB_BUILD/Makefile ]; then
 		echo CONFIG_NETDEVICES_MULTIQUEUE >> $MULT_DEP_FILE
 		define_config_multiple_deps CONFIG_MAC80211_QOS y $ALL_DEPS
 		rm -f $MULT_DEP_FILE
-		# Kernels >= 2.6.32 can disable WEXT :D
-		if [ $SUBLEVEL -le 32 ]; then
-			define_config_dep CONFIG_CFG80211_WEXT 1 CONFIG_WIRELESS_EXT
-		fi
+		define_config_dep CONFIG_CFG80211_WEXT 1 CONFIG_WIRELESS_EXT
 	fi
 fi
 echo "#endif /* COMPAT_AUTOCONF_INCLUDED */"
-- 
1.7.0.4

