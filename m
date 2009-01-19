Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:37215 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbZASX2T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:19 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/15] iwlwifi: correct Kconfig to prevent following entries from not indenting
Date: Mon, 19 Jan 2009 15:30:31 -0800
Message-Id: <1232407835-19451-12-git-send-email-reinette.chatre@intel.com> (sfid-20090120_003048_597001_31B20A45)
In-Reply-To: <1232407835-19451-11-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-6-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-7-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-8-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-9-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-10-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

    defining configurations that are not visible caused the following
    entries to not be indented. changing the tree structure to name the
    top level selection and have all others reference IWLWIFI directly
    corrects this issue.

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 47bee0e..0221226 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,21 +1,22 @@
 config IWLWIFI
-	tristate
+	bool "Intel Wireless Wifi"
+	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	default y
 
 config IWLCORE
 	tristate "Intel Wireless Wifi Core"
-	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on IWLWIFI
 	select LIB80211
-	select IWLWIFI
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
 	select RFKILL if IWLWIFI_RFKILL
 
 config IWLWIFI_LEDS
-	bool
-	default n
+	bool "Enable LED support in iwlagn driver"
+	depends on IWLCORE
 
 config IWLWIFI_RFKILL
-	boolean "Iwlwifi RF kill support"
+	bool "Enable RF kill support in iwlagn driver"
 	depends on IWLCORE
 
 config IWLWIFI_DEBUG
@@ -51,7 +52,7 @@ config IWLWIFI_DEBUGFS
 
 config IWLAGN
 	tristate "Intel Wireless WiFi Next Gen AGN"
-	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on IWLWIFI
 	select FW_LOADER
 	select IWLCORE
 	---help---
@@ -104,10 +105,9 @@ config IWL5000
 
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection"
-	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on IWLWIFI
 	select FW_LOADER
 	select LIB80211
-	select IWLWIFI
 	select MAC80211_LEDS if IWL3945_LEDS
 	select LEDS_CLASS if IWL3945_LEDS
 	select RFKILL if IWL3945_RFKILL
-- 
1.5.4.3

