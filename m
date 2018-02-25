Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38791 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbeBYMkB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Feb 2018 07:40:01 -0500
Received: by mail-wm0-f67.google.com with SMTP id z9so12270544wmb.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Feb 2018 04:40:01 -0800 (PST)
From: Romain Naour <romain.naour@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Romain Naour <romain.naour@gmail.com>
Subject: [PATCH] cfg80211: add missing dependency to CFG80211 suboptions
Date: Sun, 25 Feb 2018 13:39:56 +0100
Message-Id: <20180225123956.32161-1-romain.naour@gmail.com> (sfid-20180225_134006_287675_0AB904E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New options introduced by [1] are still enabled even if
CFG80211 is disabled.

.config:
    # CONFIG_CFG80211 is not set
    CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
    CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
    # CONFIG_LIB80211 is not set

When CFG80211_REQUIRE_SIGNED_REGDB is enabled, it select
SYSTEM_DATA_VERIFICATION which select SYSTEM_TRUSTED_KEYRING
that need extract-cert tool. extract-cert needs some openssl
headers to be installed on the build machine.

Instead of adding missing "depends on CFG80211", it
easier to use a 'if' block around all options related
to CFG80211.

[1] 90a53e4432b12288316efaa5f308adafb8d304b0

Signed-off-by: Romain Naour <romain.naour@gmail.com>
---
 net/wireless/Kconfig | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 1abcc4fc4df1..41722046b937 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -34,9 +34,10 @@ config CFG80211
 
 	  When built as a module it will be called cfg80211.
 
+if CFG80211
+
 config NL80211_TESTMODE
 	bool "nl80211 testmode command"
-	depends on CFG80211
 	help
 	  The nl80211 testmode command helps implementing things like
 	  factory calibration or validation tools for wireless chips.
@@ -51,7 +52,6 @@ config NL80211_TESTMODE
 
 config CFG80211_DEVELOPER_WARNINGS
 	bool "enable developer warnings"
-	depends on CFG80211
 	default n
 	help
 	  This option enables some additional warnings that help
@@ -68,7 +68,7 @@ config CFG80211_DEVELOPER_WARNINGS
 
 config CFG80211_CERTIFICATION_ONUS
 	bool "cfg80211 certification onus"
-	depends on CFG80211 && EXPERT
+	depends on EXPERT
 	default n
 	---help---
 	  You should disable this option unless you are both capable
@@ -159,7 +159,6 @@ config CFG80211_REG_RELAX_NO_IR
 
 config CFG80211_DEFAULT_PS
 	bool "enable powersave by default"
-	depends on CFG80211
 	default y
 	help
 	  This option enables powersave mode by default.
@@ -170,7 +169,6 @@ config CFG80211_DEFAULT_PS
 
 config CFG80211_DEBUGFS
 	bool "cfg80211 DebugFS entries"
-	depends on CFG80211
 	depends on DEBUG_FS
 	---help---
 	  You can enable this if you want debugfs entries for cfg80211.
@@ -180,7 +178,6 @@ config CFG80211_DEBUGFS
 config CFG80211_CRDA_SUPPORT
 	bool "support CRDA" if EXPERT
 	default y
-	depends on CFG80211
 	help
 	  You should enable this option unless you know for sure you have no
 	  need for it, for example when using internal regdb (above) or the
@@ -190,7 +187,6 @@ config CFG80211_CRDA_SUPPORT
 
 config CFG80211_WEXT
 	bool "cfg80211 wireless extensions compatibility" if !CFG80211_WEXT_EXPORT
-	depends on CFG80211
 	select WEXT_CORE
 	default y if CFG80211_WEXT_EXPORT
 	help
@@ -199,11 +195,12 @@ config CFG80211_WEXT
 
 config CFG80211_WEXT_EXPORT
 	bool
-	depends on CFG80211
 	help
 	  Drivers should select this option if they require cfg80211's
 	  wext compatibility symbols to be exported.
 
+endif # CFG80211
+
 config LIB80211
 	tristate
 	default n
-- 
2.14.3
