Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757266Ab1LBRqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/16] iwlagn: make debug levels more readable
Date: Fri,  2 Dec 2011 08:48:34 -0800
Message-Id: <1322844520-21149-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_185944_021968_A38B0078)
In-Reply-To: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using the actual shifted constants here allows
one to read and or them more easily.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |   58 ++++++++++++++----------------
 1 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 95740c1..f8fc239 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -134,44 +134,40 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
  */
 
 /* 0x0000000F - 0x00000001 */
-#define IWL_DL_INFO		(1 << 0)
-#define IWL_DL_MAC80211		(1 << 1)
-#define IWL_DL_HCMD		(1 << 2)
-#define IWL_DL_STATE		(1 << 3)
+#define IWL_DL_INFO		0x00000001
+#define IWL_DL_MAC80211		0x00000002
+#define IWL_DL_HCMD		0x00000004
+#define IWL_DL_STATE		0x00000008
 /* 0x000000F0 - 0x00000010 */
-/* unused (1 << 4) */
-/* unused (1 << 5) */
-#define IWL_DL_EEPROM		(1 << 6)
-#define IWL_DL_RADIO		(1 << 7)
+#define IWL_DL_EEPROM		0x00000040
+#define IWL_DL_RADIO		0x00000080
 /* 0x00000F00 - 0x00000100 */
-#define IWL_DL_POWER		(1 << 8)
-#define IWL_DL_TEMP		(1 << 9)
-/* reserved (1 << 10) */
-#define IWL_DL_SCAN		(1 << 11)
+#define IWL_DL_POWER		0x00000100
+#define IWL_DL_TEMP		0x00000200
+#define IWL_DL_SCAN		0x00000800
 /* 0x0000F000 - 0x00001000 */
-#define IWL_DL_ASSOC		(1 << 12)
-#define IWL_DL_DROP		(1 << 13)
-/* reserved (1 << 14) */
-#define IWL_DL_COEX		(1 << 15)
+#define IWL_DL_ASSOC		0x00001000
+#define IWL_DL_DROP		0x00002000
+#define IWL_DL_COEX		0x00008000
 /* 0x000F0000 - 0x00010000 */
-#define IWL_DL_FW		(1 << 16)
-#define IWL_DL_RF_KILL		(1 << 17)
-#define IWL_DL_FW_ERRORS	(1 << 18)
-#define IWL_DL_LED		(1 << 19)
+#define IWL_DL_FW		0x00010000
+#define IWL_DL_RF_KILL		0x00020000
+#define IWL_DL_FW_ERRORS	0x00040000
+#define IWL_DL_LED		0x00080000
 /* 0x00F00000 - 0x00100000 */
-#define IWL_DL_RATE		(1 << 20)
-#define IWL_DL_CALIB		(1 << 21)
-#define IWL_DL_WEP		(1 << 22)
-#define IWL_DL_TX		(1 << 23)
+#define IWL_DL_RATE		0x00100000
+#define IWL_DL_CALIB		0x00200000
+#define IWL_DL_WEP		0x00400000
+#define IWL_DL_TX		0x00800000
 /* 0x0F000000 - 0x01000000 */
-#define IWL_DL_RX		(1 << 24)
-#define IWL_DL_ISR		(1 << 25)
-#define IWL_DL_HT		(1 << 26)
+#define IWL_DL_RX		0x01000000
+#define IWL_DL_ISR		0x02000000
+#define IWL_DL_HT		0x04000000
 /* 0xF0000000 - 0x10000000 */
-#define IWL_DL_11H		(1 << 28)
-#define IWL_DL_STATS		(1 << 29)
-#define IWL_DL_TX_REPLY		(1 << 30)
-#define IWL_DL_TX_QUEUES	(1 << 31)
+#define IWL_DL_11H		0x10000000
+#define IWL_DL_STATS		0x20000000
+#define IWL_DL_TX_REPLY		0x40000000
+#define IWL_DL_TX_QUEUES	0x80000000
 
 #define IWL_DEBUG_INFO(p, f, a...)	IWL_DEBUG(p, IWL_DL_INFO, f, ## a)
 #define IWL_DEBUG_MAC80211(p, f, a...)	IWL_DEBUG(p, IWL_DL_MAC80211, f, ## a)
-- 
1.7.0.4

