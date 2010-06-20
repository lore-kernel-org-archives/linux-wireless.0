Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53870 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0FTJp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jun 2010 05:45:27 -0400
Received: by fxm10 with SMTP id 10so1315762fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jun 2010 02:45:26 -0700 (PDT)
From: Paul Fertser <fercerpav@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-wireless@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH] compat-wireless: fix compilation for 2.6.32
Date: Sun, 20 Jun 2010 13:44:57 +0400
Message-Id: <1277027097-3222-1-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2.6.32 was the latest version using CONFIG_WIRELESS_EXT. Without this patch
compilation produced

net/wireless/wext-compat.c:443: error: ‘struct wireless_dev’ has no member named ‘wext’

since config.mk defined CONFIG_CFG80211_WEXT but autoconf.sh didn't.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 scripts/gen-compat-autoconf.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 88e2740..1e3002e 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -192,7 +192,7 @@ if [ -f $KLIB_BUILD/Makefile ]; then
 		define_config_multiple_deps CONFIG_MAC80211_QOS y $ALL_DEPS
 		rm -f $MULT_DEP_FILE
 		# Kernels >= 2.6.32 can disable WEXT :D
-		if [ $SUBLEVEL -lt 32 ]; then
+		if [ $SUBLEVEL -le 32 ]; then
 			define_config_dep CONFIG_CFG80211_WEXT 1 CONFIG_WIRELESS_EXT
 		fi
 	fi
-- 
1.6.4.4

