Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30374 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYKGR6S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:18 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/13] iwlwifi: move iwl_print_hex_dump to iwl-debug.h
Date: Fri,  7 Nov 2008 09:58:43 -0800
Message-Id: <1226080726-24860-11-git-send-email-reinette.chatre@intel.com> (sfid-20081107_190857_600305_A86107F9)
In-Reply-To: <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch moves iwl_print_hex_dump to iwl-debug.h
where it belongs

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h   |   17 -----------------
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 84b7772..0e79a6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -40,6 +40,13 @@ do { if ((priv->debug_level & (level)) && net_ratelimit()) \
   dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
 	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
+#define iwl_print_hex_dump(priv, level, p, len) 			\
+do {                                            			\
+	if (priv->debug_level & level)          			\
+		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
+			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
+} while (0)
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 struct iwl_debugfs {
 	const char *name;
@@ -70,6 +77,9 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv);
 #else
 #define IWL_DEBUG(level, fmt, args...)
 #define IWL_DEBUG_LIMIT(level, fmt, args...)
+static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
+				      void *p, u32 len)
+{}
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4126a4c..7b51dd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1088,23 +1088,6 @@ static inline int is_channel_ibss(const struct iwl_channel_info *ch)
 	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
-				      void *p, u32 len)
-{
-	if (!(priv->debug_level & level))
-		return;
-
-	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
-			p, len, 1);
-}
-#else
-static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
-				      void *p, u32 len)
-{
-}
-#endif
-
 extern const struct iwl_channel_info *iwl_get_channel_info(
 	const struct iwl_priv *priv, enum ieee80211_band band, u16 channel);
 
-- 
1.5.4.3

