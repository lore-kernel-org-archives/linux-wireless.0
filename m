Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64518 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbZGGSUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 14:20:54 -0400
Subject: [PATCH] Atheros Kconfig needs to be dependent on WLAN_80211
From: Jay Sternberg <jay.e.sternberg@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 07 Jul 2009 11:18:46 -0700
Message-Id: <1246990726.4720.12.camel@jesternb-capella>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Atheros top level menu needs a "depends WLAN_80211" to properly indent
within menuconfig and xconfig interfaces.

This is purely a visual issue but it effects all subsequent drivers.  
The issue is the top level menu does not include a dependency on
WLAN_80211 so within the tree structure, Atheros is at the same level as
WLAN_80211 but when WLAN_80211 collapsed, the menu disappears along with
all subsequent drives, so it is really a subordinate.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
---
 drivers/net/wireless/ath/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/Kconfig
b/drivers/net/wireless/ath/Kconfig
index d26e7b4..eb0337c 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -1,5 +1,6 @@
 config ATH_COMMON
 	tristate "Atheros Wireless Cards"
+	depends on WLAN_80211
 	depends on ATH5K || ATH9K || AR9170_USB
 
 source "drivers/net/wireless/ath/ath5k/Kconfig"
-- 
1.5.4.3

