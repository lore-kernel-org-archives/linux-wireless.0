Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60424 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab1HMSSe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/60] iwlagn: modify the debug macro to be usable by all the layers
Date: Sat, 13 Aug 2011 10:37:49 -0700
Message-Id: <1313257116-2697-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_202011_447804_9E782EF4)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since all the layers need to print debug message, the debug macro cannot suppose
that they will be given iwl_priv as a parameter and then dereference it.
Use iwl_shared instead.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |   37 +++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-rx.c    |    3 +-
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 225ae72..7c9e9af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -29,49 +29,50 @@
 #ifndef __iwl_debug_h__
 #define __iwl_debug_h__
 
+#include "iwl-shared.h"
+
 struct iwl_priv;
 
-#define IWL_ERR(p, f, a...) dev_err(p->bus->dev, f, ## a)
-#define IWL_WARN(p, f, a...) dev_warn(p->bus->dev, f, ## a)
-#define IWL_INFO(p, f, a...) dev_info(p->bus->dev, f, ## a)
-#define IWL_CRIT(p, f, a...) dev_crit(p->bus->dev, f, ## a)
+/*No matter what is m (priv, bus, trans), this will work */
+#define IWL_ERR(m, f, a...) dev_err(bus(m)->dev, f, ## a)
+#define IWL_WARN(m, f, a...) dev_warn(bus(m)->dev, f, ## a)
+#define IWL_INFO(m, f, a...) dev_info(bus(m)->dev, f, ## a)
+#define IWL_CRIT(m, f, a...) dev_crit(bus(m)->dev, f, ## a)
 
-#define iwl_print_hex_error(priv, p, len) 				\
+#define iwl_print_hex_error(m, p, len)					\
 do {									\
 	print_hex_dump(KERN_ERR, "iwl data: ",				\
 		       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);		\
 } while (0)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-#define IWL_DEBUG(__priv, level, fmt, args...)				\
+#define IWL_DEBUG(m, level, fmt, args...)				\
 do {									\
-	if (iwl_get_debug_level(__priv->shrd) & (level))		\
-		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
+	if (iwl_get_debug_level((m)->shrd) & (level))			\
+		dev_printk(KERN_ERR, bus(m)->dev,			\
 			 "%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
 			__func__ , ## args);				\
 } while (0)
 
-#define IWL_DEBUG_LIMIT(__priv, level, fmt, args...)			\
+#define IWL_DEBUG_LIMIT(m, level, fmt, args...)				\
 do {									\
-	if ((iwl_get_debug_level(__priv->shrd) & (level)) && net_ratelimit())\
-		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
+	if (iwl_get_debug_level((m)->shrd) & (level) && net_ratelimit())\
+		dev_printk(KERN_ERR, bus(m)->dev,			\
 			"%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
 			 __func__ , ## args);				\
 } while (0)
 
-#define iwl_print_hex_dump(priv, level, p, len) 			\
+#define iwl_print_hex_dump(m, level, p, len)				\
 do {                                            			\
-	if (iwl_get_debug_level(priv->shrd) & level)			\
+	if (iwl_get_debug_level((m)->shrd) & level)			\
 		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
 			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
 } while (0)
 
 #else
-#define IWL_DEBUG(__priv, level, fmt, args...)
-#define IWL_DEBUG_LIMIT(__priv, level, fmt, args...)
-static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
-				      const void *p, u32 len)
-{}
+#define IWL_DEBUG(m, level, fmt, args...)
+#define IWL_DEBUG_LIMIT(m, level, fmt, args...)
+#define iwl_print_hex_dump(m, level, p, len)
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 37bc017..a5e4dda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -122,7 +122,8 @@ static void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 					     struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	u32 __maybe_unused len =
+		le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
 			"notification for %s:\n", len,
 			get_cmd_string(pkt->hdr.cmd));
-- 
1.7.0.4

