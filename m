Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26637 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYLQI7n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 03:59:43 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Wu, Fengguang" <fengguang.wu@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/8] iwlwifi: update comments on the debug interface
Date: Wed, 17 Dec 2008 16:52:29 +0800
Message-Id: <1229503954-30347-4-git-send-email-yi.zhu@intel.com> (sfid-20081217_095948_775054_F3477080)
In-Reply-To: <1229503954-30347-3-git-send-email-yi.zhu@intel.com>
References: <1229503954-30347-1-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-2-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wu, Fengguang <fengguang.wu@intel.com>

Bring up-to-date some comments on the location of debug files.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h |   17 +++++++----------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9d50fad..d0fb7a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3354,7 +3354,7 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 /*
  * The following adds a new attribute to the sysfs representation
- * of this device driver (i.e. a new file in /sys/bus/pci/drivers/iwl/)
+ * of this device driver (i.e. a new file in /sys/class/net/wlan0/device/)
  * used for controlling the debug level.
  *
  * See the level definitions in iwl for details.
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index e4c264b..56c13b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -96,28 +96,25 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #endif				/* CONFIG_IWLWIFI_DEBUGFS */
 
 /*
- * To use the debug system;
+ * To use the debug system:
  *
  * If you are defining a new debug classification, simply add it to the #define
- * list here in the form of:
+ * list here in the form of
  *
  * #define IWL_DL_xxxx VALUE
  *
- * shifting value to the left one bit from the previous entry.  xxxx should be
- * the name of the classification (for example, WEP)
+ * where xxxx should be the name of the classification (for example, WEP).
  *
  * You then need to either add a IWL_xxxx_DEBUG() macro definition for your
  * classification, or use IWL_DEBUG(IWL_DL_xxxx, ...) whenever you want
  * to send output to that classification.
  *
- * To add your debug level to the list of levels seen when you perform
+ * The active debug levels can be accessed via files
  *
- * % cat /sys/class/net/wlanX/device/debug_level
+ * 	/sys/module/iwlagn/parameters/debug{50}
+ * 	/sys/class/net/wlan0/device/debug_level
  *
- * you simply need to add your entry to the iwl_debug_levels array.
- *
- * If you do not see debug_level in  /sys/class/net/wlanX/device/debug_level
- * then you do not have CONFIG_IWLWIFI_DEBUG defined in your kernel config file
+ * when CONFIG_IWLWIFI_DEBUG=y.
  */
 
 #define IWL_DL_INFO		(1 << 0)
-- 
1.5.3.6

