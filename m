Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:56533 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbZIRQUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 12:20:06 -0400
Received: by fxm17 with SMTP id 17so824946fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 09:20:09 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] iwlwifi: drop lib80211 dependency
Date: Fri, 18 Sep 2009 18:20:03 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909181820.04078.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ever since Johannes' "iwlwifi: improve scan support" iwlwifi
no longer needs any of lib80211's functions or definitions.

This patch updates iwlwifi's Kconfig _selections_ and
removes all left lib80211.h inclusions from the source files.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 99310c0..eb62c20 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,7 +1,6 @@
 config IWLWIFI
 	tristate "Intel Wireless Wifi"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
-	select LIB80211
 	select FW_LOADER
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 4f3a108..41f9a06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -27,7 +27,6 @@
  *****************************************************************************/
 #include <linux/types.h>
 #include <linux/etherdevice.h>
-#include <net/lib80211.h>
 #include <net/mac80211.h>
 
 #include "iwl-eeprom.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0909668..34e6af6 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -41,7 +41,6 @@
 #include <linux/if_arp.h>
 
 #include <net/ieee80211_radiotap.h>
-#include <net/lib80211.h>
 #include <net/mac80211.h>
 
 #include <asm/div64.h>
