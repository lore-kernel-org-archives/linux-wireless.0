Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZEZDSj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 23:18:39 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/3] iwmc3200wifi: fix link error when CFG80211 is not selected
Date: Tue, 26 May 2009 11:10:48 +0800
Message-Id: <1243307448-17441-3-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
 <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch makes iwmc3200wifi select CFG80211 instead of LIB80211.
This fixed module link error reported by Randy Dunlap
<randy.dunlap@oracle.com> when compiling iwmc3200wifi without
cfg80211 selected. WIRELESS_EXT is also selected by iwmc3200wifi.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
index ae84dda..41bd4b2 100644
--- a/drivers/net/wireless/iwmc3200wifi/Kconfig
+++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
@@ -1,7 +1,8 @@
 config IWM
 	tristate "Intel Wireless Multicomm 3200 WiFi driver"
 	depends on MMC && WLAN_80211 && EXPERIMENTAL
-	select LIB80211
+	select WIRELESS_EXT
+	select CFG80211
 	select FW_LOADER
 	select RFKILL
 
-- 
1.6.0.4

