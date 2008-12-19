Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbYLSCpV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:21 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wu Fengguang <fengguang.wu@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 23/43] iwlwifi: beautify code
Date: Fri, 19 Dec 2008 10:37:23 +0800
Message-Id: <1229654263-21454-24-git-send-email-yi.zhu@intel.com> (sfid-20081219_034609_006567_25116E60)
In-Reply-To: <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wu Fengguang <fengguang.wu@intel.com>

This patch beautifies macros in iwl-debug.h.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |  167 +++++++++++++++---------------
 1 files changed, 85 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index aa20d72..067bd8e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -32,15 +32,19 @@
 struct iwl_priv;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-#define IWL_DEBUG(level, fmt, args...) \
-do { if (priv->debug_level & (level)) \
-  dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
+#define IWL_DEBUG(level, fmt, args...)					    \
+do {									    \
+	if (priv->debug_level & (level))				    \
+		dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
+			   in_interrupt() ? 'I' : 'U', __func__ , ## args); \
+} while (0)
 
-#define IWL_DEBUG_LIMIT(level, fmt, args...) \
-do { if ((priv->debug_level & (level)) && net_ratelimit()) \
-  dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
+#define IWL_DEBUG_LIMIT(level, fmt, args...)				    \
+do {									    \
+	if ((priv->debug_level & (level)) && net_ratelimit())		    \
+		dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
+			   in_interrupt() ? 'I' : 'U', __func__ , ## args); \
+} while (0)
 
 #define iwl_print_hex_dump(priv, level, p, len) 			\
 do {                                            			\
@@ -119,86 +123,85 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
  * when CONFIG_IWLWIFI_DEBUG=y.
  */
 
+/* 0x0000000F - 0x00000001 */
 #define IWL_DL_INFO		(1 << 0)
 #define IWL_DL_MAC80211		(1 << 1)
 #define IWL_DL_HCMD		(1 << 2)
 #define IWL_DL_STATE		(1 << 3)
+/* 0x000000F0 - 0x00000010 */
 #define IWL_DL_MACDUMP		(1 << 4)
 #define IWL_DL_HCMD_DUMP	(1 << 5)
-#define IWL_DL_RADIO         (1 << 7)
-#define IWL_DL_POWER         (1 << 8)
-#define IWL_DL_TEMP          (1 << 9)
-
-#define IWL_DL_NOTIF         (1 << 10)
-#define IWL_DL_SCAN          (1 << 11)
-#define IWL_DL_ASSOC         (1 << 12)
-#define IWL_DL_DROP          (1 << 13)
-
-#define IWL_DL_TXPOWER       (1 << 14)
-
-#define IWL_DL_AP            (1 << 15)
-
-#define IWL_DL_FW            (1 << 16)
-#define IWL_DL_RF_KILL       (1 << 17)
-#define IWL_DL_FW_ERRORS     (1 << 18)
-
-#define IWL_DL_LED           (1 << 19)
-
-#define IWL_DL_RATE          (1 << 20)
-
-#define IWL_DL_CALIB         (1 << 21)
-#define IWL_DL_WEP           (1 << 22)
-#define IWL_DL_TX            (1 << 23)
-#define IWL_DL_RX            (1 << 24)
-#define IWL_DL_ISR           (1 << 25)
-#define IWL_DL_HT            (1 << 26)
-#define IWL_DL_IO            (1 << 27)
-#define IWL_DL_11H           (1 << 28)
-
-#define IWL_DL_STATS         (1 << 29)
-#define IWL_DL_TX_REPLY      (1 << 30)
-#define IWL_DL_QOS           (1 << 31)
-
-#define IWL_ERROR(f, a...) dev_printk(KERN_ERR, \
-			&(priv->hw->wiphy->dev), f, ## a)
-#define IWL_WARNING(f, a...) dev_printk(KERN_WARNING, \
-			&(priv->hw->wiphy->dev), f, ## a)
-#define IWL_DEBUG_INFO(f, a...)    IWL_DEBUG(IWL_DL_INFO, f, ## a)
-
-#define IWL_DEBUG_MAC80211(f, a...)     IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
-#define IWL_DEBUG_MACDUMP(f, a...)     IWL_DEBUG(IWL_DL_MACDUMP, f, ## a)
-#define IWL_DEBUG_TEMP(f, a...)   IWL_DEBUG(IWL_DL_TEMP, f, ## a)
-#define IWL_DEBUG_SCAN(f, a...)   IWL_DEBUG(IWL_DL_SCAN, f, ## a)
-#define IWL_DEBUG_RX(f, a...)     IWL_DEBUG(IWL_DL_RX, f, ## a)
-#define IWL_DEBUG_TX(f, a...)     IWL_DEBUG(IWL_DL_TX, f, ## a)
-#define IWL_DEBUG_ISR(f, a...)    IWL_DEBUG(IWL_DL_ISR, f, ## a)
-#define IWL_DEBUG_LED(f, a...) IWL_DEBUG(IWL_DL_LED, f, ## a)
-#define IWL_DEBUG_WEP(f, a...)    IWL_DEBUG(IWL_DL_WEP, f, ## a)
-#define IWL_DEBUG_HC(f, a...) IWL_DEBUG(IWL_DL_HCMD, f, ## a)
-#define IWL_DEBUG_HC_DUMP(f, a...) IWL_DEBUG(IWL_DL_HCMD_DUMP, f, ## a)
-#define IWL_DEBUG_CALIB(f, a...) IWL_DEBUG(IWL_DL_CALIB, f, ## a)
-#define IWL_DEBUG_FW(f, a...) IWL_DEBUG(IWL_DL_FW, f, ## a)
-#define IWL_DEBUG_RF_KILL(f, a...) IWL_DEBUG(IWL_DL_RF_KILL, f, ## a)
-#define IWL_DEBUG_DROP(f, a...) IWL_DEBUG(IWL_DL_DROP, f, ## a)
-#define IWL_DEBUG_DROP_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_DROP, f, ## a)
-#define IWL_DEBUG_AP(f, a...) IWL_DEBUG(IWL_DL_AP, f, ## a)
-#define IWL_DEBUG_TXPOWER(f, a...) IWL_DEBUG(IWL_DL_TXPOWER, f, ## a)
-#define IWL_DEBUG_IO(f, a...) IWL_DEBUG(IWL_DL_IO, f, ## a)
-#define IWL_DEBUG_RATE(f, a...) IWL_DEBUG(IWL_DL_RATE, f, ## a)
-#define IWL_DEBUG_RATE_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_RATE, f, ## a)
-#define IWL_DEBUG_NOTIF(f, a...) IWL_DEBUG(IWL_DL_NOTIF, f, ## a)
-#define IWL_DEBUG_ASSOC(f, a...) IWL_DEBUG(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
-#define IWL_DEBUG_ASSOC_LIMIT(f, a...) \
-	IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
-#define IWL_DEBUG_HT(f, a...) IWL_DEBUG(IWL_DL_HT, f, ## a)
-#define IWL_DEBUG_STATS(f, a...) IWL_DEBUG(IWL_DL_STATS, f, ## a)
-#define IWL_DEBUG_STATS_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_STATS, f, ## a)
-#define IWL_DEBUG_TX_REPLY(f, a...) IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
+#define IWL_DL_RADIO		(1 << 7)
+
+#define IWL_DL_POWER		(1 << 8)
+#define IWL_DL_TEMP		(1 << 9)
+#define IWL_DL_NOTIF		(1 << 10)
+#define IWL_DL_SCAN		(1 << 11)
+
+#define IWL_DL_ASSOC		(1 << 12)
+#define IWL_DL_DROP		(1 << 13)
+#define IWL_DL_TXPOWER		(1 << 14)
+#define IWL_DL_AP		(1 << 15)
+
+#define IWL_DL_FW		(1 << 16)
+#define IWL_DL_RF_KILL		(1 << 17)
+#define IWL_DL_FW_ERRORS	(1 << 18)
+#define IWL_DL_LED		(1 << 19)
+
+#define IWL_DL_RATE		(1 << 20)
+#define IWL_DL_CALIB		(1 << 21)
+#define IWL_DL_WEP		(1 << 22)
+#define IWL_DL_TX		(1 << 23)
+#define IWL_DL_RX		(1 << 24)
+#define IWL_DL_ISR		(1 << 25)
+#define IWL_DL_HT		(1 << 26)
+#define IWL_DL_IO		(1 << 27)
+#define IWL_DL_11H		(1 << 28)
+#define IWL_DL_STATS		(1 << 29)
+#define IWL_DL_TX_REPLY		(1 << 30)
+#define IWL_DL_QOS		(1 << 31)
+
+#define IWL_ERROR(f, a...)		\
+		dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), f, ## a)
+#define IWL_WARNING(f, a...)		\
+		dev_printk(KERN_WARNING, &(priv->hw->wiphy->dev), f, ## a)
+
+#define IWL_DEBUG_INFO(f, a...)		IWL_DEBUG(IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_MAC80211(f, a...)	IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
+#define IWL_DEBUG_MACDUMP(f, a...)	IWL_DEBUG(IWL_DL_MACDUMP, f, ## a)
+#define IWL_DEBUG_TEMP(f, a...)		IWL_DEBUG(IWL_DL_TEMP, f, ## a)
+#define IWL_DEBUG_SCAN(f, a...)		IWL_DEBUG(IWL_DL_SCAN, f, ## a)
+#define IWL_DEBUG_RX(f, a...)		IWL_DEBUG(IWL_DL_RX, f, ## a)
+#define IWL_DEBUG_TX(f, a...)		IWL_DEBUG(IWL_DL_TX, f, ## a)
+#define IWL_DEBUG_ISR(f, a...)		IWL_DEBUG(IWL_DL_ISR, f, ## a)
+#define IWL_DEBUG_LED(f, a...)		IWL_DEBUG(IWL_DL_LED, f, ## a)
+#define IWL_DEBUG_WEP(f, a...)		IWL_DEBUG(IWL_DL_WEP, f, ## a)
+#define IWL_DEBUG_HC(f, a...)		IWL_DEBUG(IWL_DL_HCMD, f, ## a)
+#define IWL_DEBUG_HC_DUMP(f, a...)	IWL_DEBUG(IWL_DL_HCMD_DUMP, f, ## a)
+#define IWL_DEBUG_CALIB(f, a...)	IWL_DEBUG(IWL_DL_CALIB, f, ## a)
+#define IWL_DEBUG_FW(f, a...)		IWL_DEBUG(IWL_DL_FW, f, ## a)
+#define IWL_DEBUG_RF_KILL(f, a...)	IWL_DEBUG(IWL_DL_RF_KILL, f, ## a)
+#define IWL_DEBUG_DROP(f, a...)		IWL_DEBUG(IWL_DL_DROP, f, ## a)
+#define IWL_DEBUG_DROP_LIMIT(f, a...)	IWL_DEBUG_LIMIT(IWL_DL_DROP, f, ## a)
+#define IWL_DEBUG_AP(f, a...)		IWL_DEBUG(IWL_DL_AP, f, ## a)
+#define IWL_DEBUG_TXPOWER(f, a...)	IWL_DEBUG(IWL_DL_TXPOWER, f, ## a)
+#define IWL_DEBUG_IO(f, a...)		IWL_DEBUG(IWL_DL_IO, f, ## a)
+#define IWL_DEBUG_RATE(f, a...)		IWL_DEBUG(IWL_DL_RATE, f, ## a)
+#define IWL_DEBUG_RATE_LIMIT(f, a...)	IWL_DEBUG_LIMIT(IWL_DL_RATE, f, ## a)
+#define IWL_DEBUG_NOTIF(f, a...)	IWL_DEBUG(IWL_DL_NOTIF, f, ## a)
+#define IWL_DEBUG_ASSOC(f, a...)	\
+		IWL_DEBUG(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_ASSOC_LIMIT(f, a...)	\
+		IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_HT(f, a...)		IWL_DEBUG(IWL_DL_HT, f, ## a)
+#define IWL_DEBUG_STATS(f, a...)	IWL_DEBUG(IWL_DL_STATS, f, ## a)
+#define IWL_DEBUG_STATS_LIMIT(f, a...)	IWL_DEBUG_LIMIT(IWL_DL_STATS, f, ## a)
+#define IWL_DEBUG_TX_REPLY(f, a...)	IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
 #define IWL_DEBUG_TX_REPLY_LIMIT(f, a...) \
-	IWL_DEBUG_LIMIT(IWL_DL_TX_REPLY, f, ## a)
-#define IWL_DEBUG_QOS(f, a...)   IWL_DEBUG(IWL_DL_QOS, f, ## a)
-#define IWL_DEBUG_RADIO(f, a...)  IWL_DEBUG(IWL_DL_RADIO, f, ## a)
-#define IWL_DEBUG_POWER(f, a...)  IWL_DEBUG(IWL_DL_POWER, f, ## a)
-#define IWL_DEBUG_11H(f, a...)  IWL_DEBUG(IWL_DL_11H, f, ## a)
+		IWL_DEBUG_LIMIT(IWL_DL_TX_REPLY, f, ## a)
+#define IWL_DEBUG_QOS(f, a...)		IWL_DEBUG(IWL_DL_QOS, f, ## a)
+#define IWL_DEBUG_RADIO(f, a...)	IWL_DEBUG(IWL_DL_RADIO, f, ## a)
+#define IWL_DEBUG_POWER(f, a...)	IWL_DEBUG(IWL_DL_POWER, f, ## a)
+#define IWL_DEBUG_11H(f, a...)		IWL_DEBUG(IWL_DL_11H, f, ## a)
 
 #endif
-- 
1.5.3.6

