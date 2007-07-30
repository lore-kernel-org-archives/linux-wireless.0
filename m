Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13405 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbXG3C7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 22:59:41 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/8] iwlwifi: Endainity Fix for scan host command
Date: Mon, 30 Jul 2007 10:57:01 +0800
Message-Id: <1185764238442-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11857642362891-git-send-email-yi.zhu@intel.com>
References: <11857642261522-git-send-email-yi.zhu@intel.com>
 <11857642343783-git-send-email-yi.zhu@intel.com>
 <11857642362891-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endianity issues in scan host command.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwl-3945.h     |    4 ++--
 drivers/net/wireless/iwl-base.c     |   18 ++++++++++--------
 drivers/net/wireless/iwl-commands.h |    2 +-
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index 6c42f53..8a534e1 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -195,7 +195,7 @@ void iwl_disable_events(struct iwl_priv *priv)
  * IWL_ANTENNA_MAIN      - Force MAIN antenna
  * IWL_ANTENNA_AUX       - Force AUX antenna
  */
-int iwl3945_get_antenna_flags(const struct iwl_priv *priv)
+__le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv)
 {
 	switch (priv->antenna) {
 	case IWL_ANTENNA_DIVERSITY:
diff --git a/drivers/net/wireless/iwl-3945.h b/drivers/net/wireless/iwl-3945.h
index d134a4b..0f4db4c 100644
--- a/drivers/net/wireless/iwl-3945.h
+++ b/drivers/net/wireless/iwl-3945.h
@@ -32,7 +32,7 @@
  * In non IWL == 3945 builds, these must build to nothing in order to allow
  * the common code to not have several #if IWL == XXXX / #endif blocks
  */
-static inline int iwl3945_get_antenna_flags(const struct iwl_priv *priv)
+static inline __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv)
 { return 0; }
 static inline int iwl3945_init_hw_rate_table(struct iwl_priv *priv)
 { return 0; }
@@ -48,7 +48,7 @@ static inline u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
  * Forward declare iwl-3945.c functions for iwl-base.c
  */
 extern int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv);
-extern int iwl3945_get_antenna_flags(const struct iwl_priv *priv);
+extern __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv);
 extern int iwl3945_init_hw_rate_table(struct iwl_priv *priv);
 extern void iwl3945_reg_txpower_periodic(struct iwl_priv *priv);
 extern void iwl3945_bg_reg_txpower_periodic(struct work_struct *work);
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 0648bec..a1dc3d9 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -3355,7 +3355,7 @@ static int iwl_get_measurement(struct iwl_priv *priv,
 
 	memset(&spectrum, 0, sizeof(spectrum));
 
-	spectrum.channel_count = 1;
+	spectrum.channel_count = cpu_to_le32(1);
 	spectrum.flags =
 	    RXON_FLG_TSF2HOST_MSK | RXON_FLG_ANT_A_MSK | RXON_FLG_DIS_DIV_MSK;
 	spectrum.filter_flags = MEASUREMENT_FILTER_FLAG;
@@ -5480,8 +5480,8 @@ static int iwl_init_channel_map(struct iwl_priv *priv)
  * time if it's a quiet channel (nothing responded to our probe, and there's
  * no other traffic).
  * Disable "quiet" feature by setting PLCP_QUIET_THRESH to 0. */
-#define IWL_PLCP_QUIET_THRESH       (1)	/* packets */
-#define IWL_ACTIVE_QUIET_TIME       (5)	/* msec */
+#define IWL_PLCP_QUIET_THRESH       __constant_cpu_to_le16(1)	/* packets */
+#define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(5)	/* msec */
 
 /* For passive scan, listen PASSIVE_DWELL_TIME (msec) on each channel.
  * Must be set longer than active dwell time.
@@ -7011,6 +7011,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		u16 interval = 0;
 		u32 extra;
 		u32 suspend_time = 100;
+		u32 scan_suspend_time = 100;
 		unsigned long flags;
 
 		IWL_DEBUG_INFO("Scanning while associated...\n");
@@ -7020,7 +7021,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		spin_unlock_irqrestore(&priv->lock, flags);
 
 		scan->suspend_time = 0;
-		scan->max_out_time = 600 * 1024;
+		scan->max_out_time = cpu_to_le32(600 * 1024);
 		if (!interval)
 			interval = suspend_time;
 #if IWL == 3945
@@ -7032,15 +7033,16 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		 */
 
 		extra = (suspend_time / interval) << 24;
-		scan->suspend_time = 0xFF0FFFFF &
+		scan_suspend_time = 0xFF0FFFFF &
 		    (extra | ((suspend_time % interval) * 1024));
 #else
 		extra = (suspend_time / interval) << 22;
-		scan->suspend_time = (extra |
+		scan_suspend_time = (extra |
 		    ((suspend_time % interval) * 1024));
-		IWL_DEBUG_SCAN("suspend_time 0x%X beacon interval %d\n",
-			       scan->suspend_time, interval);
 #endif
+		scan->suspend_time = cpu_to_le32(scan_suspend_time);
+		IWL_DEBUG_SCAN("suspend_time 0x%X beacon interval %d\n",
+			       scan_suspend_time, interval);
 	}
 
 	/* We should add the ability for user to lock to PASSIVE ONLY */
diff --git a/drivers/net/wireless/iwl-commands.h b/drivers/net/wireless/iwl-commands.h
index 297d24a..e3f2977 100644
--- a/drivers/net/wireless/iwl-commands.h
+++ b/drivers/net/wireless/iwl-commands.h
@@ -443,7 +443,7 @@ struct iwl_ssid_ie {
 #define PROBE_OPTION_MAX        0x4
 #define TX_CMD_FLG_SEQ_CTL_MSK  0x2000
 #define TX_CMD_LIFE_TIME_INFINITE       0xFFFFFFFF
-#define IWL_GOOD_CRC_TH             (1)
+#define IWL_GOOD_CRC_TH		__constant_cpu_to_le16(1)
 
 #define IWL_MAX_SCAN_SIZE 1024
 struct iwl_scan_cmd {
-- 
1.5.2
