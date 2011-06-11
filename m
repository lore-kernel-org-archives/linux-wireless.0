Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758596Ab1FKOzm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/18] iwlagn: remove unused debug flag
Date: Sat, 11 Jun 2011 07:25:47 -0700
Message-Id: <1307802352-16398-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165551_134146_A5BD1742)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove both IWL_DEBUG_TXPOWER and IWL_DEBUG_NOTIF, not used.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index fd68ce8..c844b51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -125,12 +125,12 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 /* 0x00000F00 - 0x00000100 */
 #define IWL_DL_POWER		(1 << 8)
 #define IWL_DL_TEMP		(1 << 9)
-#define IWL_DL_NOTIF		(1 << 10)
+/* reserved (1 << 10) */
 #define IWL_DL_SCAN		(1 << 11)
 /* 0x0000F000 - 0x00001000 */
 #define IWL_DL_ASSOC		(1 << 12)
 #define IWL_DL_DROP		(1 << 13)
-#define IWL_DL_TXPOWER		(1 << 14)
+/* reserved (1 << 14) */
 #define IWL_DL_COEX		(1 << 15)
 /* 0x000F0000 - 0x00010000 */
 #define IWL_DL_FW		(1 << 16)
@@ -172,11 +172,9 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DEBUG_DROP_LIMIT(p, f, a...)	\
 		IWL_DEBUG_LIMIT(p, IWL_DL_DROP, f, ## a)
 #define IWL_DEBUG_COEX(p, f, a...)	IWL_DEBUG(p, IWL_DL_COEX, f, ## a)
-#define IWL_DEBUG_TXPOWER(p, f, a...)	IWL_DEBUG(p, IWL_DL_TXPOWER, f, ## a)
 #define IWL_DEBUG_RATE(p, f, a...)	IWL_DEBUG(p, IWL_DL_RATE, f, ## a)
 #define IWL_DEBUG_RATE_LIMIT(p, f, a...)	\
 		IWL_DEBUG_LIMIT(p, IWL_DL_RATE, f, ## a)
-#define IWL_DEBUG_NOTIF(p, f, a...)	IWL_DEBUG(p, IWL_DL_NOTIF, f, ## a)
 #define IWL_DEBUG_ASSOC(p, f, a...)	\
 		IWL_DEBUG(p, IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
 #define IWL_DEBUG_ASSOC_LIMIT(p, f, a...)	\
-- 
1.7.0.4

