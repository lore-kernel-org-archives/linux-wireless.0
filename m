Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23627 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031447Ab2CFWnc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:32 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 12/33] iwlwifi: move status check functions out of shared
Date: Tue,  6 Mar 2012 13:30:47 -0800
Message-Id: <1331069468-11074-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234440_240407_5AF11AD1)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

They are only used in the DVM op_mode.
Also move the rfkill debug macros that
depend on them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.h    |   64 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-debug.h  |   16 -------
 drivers/net/wireless/iwlwifi/iwl-shared.h |   42 -------------------
 4 files changed, 65 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 85fe590..7712c55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -34,6 +34,7 @@
 
 #include <net/mac80211.h>
 
+#include "iwl-agn.h"
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index dfd86f2..1f62d6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -383,4 +383,68 @@ static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 }
 #endif
 
+/* status checks */
+
+static inline int iwl_is_ready(struct iwl_shared *shrd)
+{
+	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
+	 * set but EXIT_PENDING is not */
+	return test_bit(STATUS_READY, &shrd->status) &&
+	       test_bit(STATUS_GEO_CONFIGURED, &shrd->status) &&
+	       !test_bit(STATUS_EXIT_PENDING, &shrd->status);
+}
+
+static inline int iwl_is_alive(struct iwl_shared *shrd)
+{
+	return test_bit(STATUS_ALIVE, &shrd->status);
+}
+
+static inline int iwl_is_init(struct iwl_shared *shrd)
+{
+	return test_bit(STATUS_INIT, &shrd->status);
+}
+
+static inline int iwl_is_rfkill_hw(struct iwl_shared *shrd)
+{
+	return test_bit(STATUS_RF_KILL_HW, &shrd->status);
+}
+
+static inline int iwl_is_rfkill(struct iwl_shared *shrd)
+{
+	return iwl_is_rfkill_hw(shrd);
+}
+
+static inline int iwl_is_ctkill(struct iwl_shared *shrd)
+{
+	return test_bit(STATUS_CT_KILL, &shrd->status);
+}
+
+static inline int iwl_is_ready_rf(struct iwl_shared *shrd)
+{
+	if (iwl_is_rfkill(shrd))
+		return 0;
+
+	return iwl_is_ready(shrd);
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+#define IWL_DEBUG_QUIET_RFKILL(m, fmt, args...)	\
+do {									\
+	if (!iwl_is_rfkill((m)->shrd))					\
+		IWL_ERR(m, fmt, ##args);				\
+	else								\
+		__iwl_err(trans(m)->dev, true,				\
+			  !iwl_have_debug_level(IWL_DL_RADIO),		\
+			  fmt, ##args);					\
+} while (0)
+#else
+#define IWL_DEBUG_QUIET_RFKILL(m, fmt, args...)	\
+do {									\
+	if (!iwl_is_rfkill((m)->shrd))					\
+		IWL_ERR(m, fmt, ##args);				\
+	else								\
+		__iwl_err(trans(m)->dev, true, true, fmt, ##args);	\
+} while (0)
+#endif				/* CONFIG_IWLWIFI_DEBUG */
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 163d259..a6b32a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -76,24 +76,8 @@ do {                                            			\
 		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
 			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
 } while (0)
-#define IWL_DEBUG_QUIET_RFKILL(m, fmt, args...)	\
-do {									\
-	if (!iwl_is_rfkill((m)->shrd))					\
-		IWL_ERR(m, fmt, ##args);				\
-	else								\
-		__iwl_err(trans(m)->dev, true,				\
-			  !iwl_have_debug_level(IWL_DL_RADIO),		\
-			  fmt, ##args);					\
-} while (0)
 #else
 #define iwl_print_hex_dump(m, level, p, len)
-#define IWL_DEBUG_QUIET_RFKILL(m, fmt, args...)	\
-do {									\
-	if (!iwl_is_rfkill((m)->shrd))					\
-		IWL_ERR(m, fmt, ##args);				\
-	else								\
-		__iwl_err(trans(m)->dev, true, true, fmt, ##args);	\
-} while (0)
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index a5ab58c..5e12b50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -508,46 +508,4 @@ iwl_remove_notification(struct iwl_shared *shrd,
 #define STATUS_CHANNEL_SWITCH_PENDING 19
 #define STATUS_SCAN_COMPLETE	20
 
-static inline int iwl_is_ready(struct iwl_shared *shrd)
-{
-	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
-	 * set but EXIT_PENDING is not */
-	return test_bit(STATUS_READY, &shrd->status) &&
-	       test_bit(STATUS_GEO_CONFIGURED, &shrd->status) &&
-	       !test_bit(STATUS_EXIT_PENDING, &shrd->status);
-}
-
-static inline int iwl_is_alive(struct iwl_shared *shrd)
-{
-	return test_bit(STATUS_ALIVE, &shrd->status);
-}
-
-static inline int iwl_is_init(struct iwl_shared *shrd)
-{
-	return test_bit(STATUS_INIT, &shrd->status);
-}
-
-static inline int iwl_is_rfkill_hw(struct iwl_shared *shrd)
-{
-	return test_bit(STATUS_RF_KILL_HW, &shrd->status);
-}
-
-static inline int iwl_is_rfkill(struct iwl_shared *shrd)
-{
-	return iwl_is_rfkill_hw(shrd);
-}
-
-static inline int iwl_is_ctkill(struct iwl_shared *shrd)
-{
-	return test_bit(STATUS_CT_KILL, &shrd->status);
-}
-
-static inline int iwl_is_ready_rf(struct iwl_shared *shrd)
-{
-	if (iwl_is_rfkill(shrd))
-		return 0;
-
-	return iwl_is_ready(shrd);
-}
-
 #endif /* #__iwl_shared_h__ */
-- 
1.7.0.4

