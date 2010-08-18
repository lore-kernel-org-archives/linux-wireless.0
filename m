Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1413 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab0HRQSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/16] iwlwifi: move debug options into submenu
Date: Wed, 18 Aug 2010 09:22:51 -0700
Message-Id: <1282148571-9258-17-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

more debug options being added so it is useful to move them
into a submenu for ease of readability when using config commands
like make menuconfig and make xconfig

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 7ab5b51..b823642 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -3,6 +3,9 @@ config IWLWIFI
 	depends on PCI && MAC80211
 	select FW_LOADER
 
+menu "Debugging Options"
+	depends on IWLWIFI
+
 config IWLWIFI_DEBUG
 	bool "Enable full debugging output in iwlagn and iwl3945 drivers"
 	depends on IWLWIFI
@@ -59,6 +62,7 @@ config IWLWIFI_DEVICE_TRACING
 
 	  If unsure, say Y so we can help you better when problems
 	  occur.
+endmenu
 
 config IWLAGN
 	tristate "Intel Wireless WiFi Next Gen AGN (iwlagn)"
-- 
1.7.0.4

