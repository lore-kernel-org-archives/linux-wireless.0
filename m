Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1JJPQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/34] iwlwifi: update comments on how to enable debug flag
Date: Mon, 10 Oct 2011 07:27:07 -0700
Message-Id: <1318256839-31837-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171712_242163_5A903E4B)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify comments on how to enable and change debug_level

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.h |    8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index e044103..57703d5 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -54,13 +54,13 @@ config IWLWIFI_DEBUG
 	  control which debug output is sent to the kernel log by setting the
 	  value in
 
-		/sys/class/net/wlan0/device/debug_level
+		/sys/module/iwlwifi/parameters/debug
 
 	  This entry will only exist if this option is enabled.
 
 	  To set a value, simply echo an 8-byte hex value to the same file:
 
-		  % echo 0x43fff > /sys/class/net/wlan0/device/debug_level
+		  % echo 0x43fff > /sys/module/iwlwifi/parameters/debug
 
 	  You can find the list of debug mask values in:
 		  drivers/net/wireless/iwlwifi/iwl-debug.h
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 7014f41..69a77e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -105,10 +105,12 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
  *
  * The active debug levels can be accessed via files
  *
- * 	/sys/module/iwlagn/parameters/debug{50}
- * 	/sys/class/net/wlan0/device/debug_level
- *
+ *	/sys/module/iwlwifi/parameters/debug
  * when CONFIG_IWLWIFI_DEBUG=y.
+ *
+ *	/sys/kernel/debug/phy0/iwlwifi/debug/debug_level
+ * when CONFIG_IWLWIFI_DEBUGFS=y.
+ *
  */
 
 /* 0x0000000F - 0x00000001 */
-- 
1.7.0.4

