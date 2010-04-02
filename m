Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37744 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab0DBUi7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 16:38:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/7] iwlwifi: code cleanup for generic defines
Date: Fri,  2 Apr 2010 13:38:52 -0700
Message-Id: <1270240734-12825-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
References: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Some defines used by all agn devices, but the definitions were in
iwl-4965-hw.h, move those to iwl-agn-hw.h which is the better place for
those.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    5 -----
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |   24 ------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h   |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 9 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 074f42a..91bcb4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -71,10 +71,6 @@
 
 #include "iwl-eeprom.h"
 
-/* Time constants */
-#define SHORT_SLOT_TIME 9
-#define LONG_SLOT_TIME 20
-
 /* RSSI to dBm */
 #define IWL39_RSSI_OFFSET	95
 
@@ -230,7 +226,6 @@ struct iwl3945_eeprom {
 
 /* 4 DATA + 1 CMD. There are 2 HCCA queues that are not used. */
 #define IWL39_NUM_QUEUES        5
-#define IWL_NUM_SCAN_RATES         (2)
 
 #define IWL_DEFAULT_TX_RETRY  15
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 67ef562..cd4b61a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -81,26 +81,6 @@
  */
 #define IWL49_FIRST_AMPDU_QUEUE	7
 
-/* Time constants */
-#define SHORT_SLOT_TIME 9
-#define LONG_SLOT_TIME 20
-
-/* RSSI to dBm */
-#define IWL49_RSSI_OFFSET	44
-
-
-/* PCI registers */
-#define PCI_CFG_RETRY_TIMEOUT	0x041
-
-/* PCI register values */
-#define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
-#define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
-
-#define IWL_NUM_SCAN_RATES         (2)
-
-#define IWL_DEFAULT_TX_RETRY  15
-
-
 /* Sizes and addresses for instruction and data memory (SRAM) in
  * 4965's embedded processor.  Driver access is via HBUS_TARG_MEM_* regs. */
 #define IWL49_RTC_INST_LOWER_BOUND		(0x000000)
@@ -393,10 +373,6 @@ static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
  *     location(s) in command (struct iwl4965_txpowertable_cmd).
  */
 
-/* Limit range of txpower output target to be between these values */
-#define IWL_TX_POWER_TARGET_POWER_MIN       (0)	/* 0 dBm = 1 milliwatt */
-#define IWL_TX_POWER_TARGET_POWER_MAX      (16)	/* 16 dBm */
-
 /**
  * When MIMO is used (2 transmitters operating simultaneously), driver should
  * limit each transmitter to deliver a max of 3 dB below the regulatory limit
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 083983a..a5122a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2086,7 +2086,7 @@ static int iwl4965_calc_rssi(struct iwl_priv *priv,
 
 	/* dBm = max_rssi dB - agc dB - constant.
 	 * Higher AGC (higher radio gain) means lower signal. */
-	return max_rssi - agc - IWL49_RSSI_OFFSET;
+	return max_rssi - agc - IWLAGN_RSSI_OFFSET;
 }
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 6e331f5..28bc8f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -254,7 +254,7 @@ static int iwlagn_calc_rssi(struct iwl_priv *priv,
 
 	/* dBm = max_rssi dB - agc dB - constant.
 	 * Higher AGC (higher radio gain) means lower signal. */
-	return max_rssi - agc - IWL49_RSSI_OFFSET;
+	return max_rssi - agc - IWLAGN_RSSI_OFFSET;
 }
 
 struct iwl_hcmd_ops iwlagn_hcmd = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index e2ad870..f9a3fbb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -78,6 +78,22 @@
 #define IWLAGN_RTC_DATA_SIZE (IWLAGN_RTC_DATA_UPPER_BOUND - \
 				IWLAGN_RTC_DATA_LOWER_BOUND)
 
+/* RSSI to dBm */
+#define IWLAGN_RSSI_OFFSET	44
+
+/* PCI registers */
+#define PCI_CFG_RETRY_TIMEOUT	0x041
+
+/* PCI register values */
+#define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
+#define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
+
+#define IWLAGN_DEFAULT_TX_RETRY  15
+
+/* Limit range of txpower output target to be between these values */
+#define IWLAGN_TX_POWER_TARGET_POWER_MIN	(0)	/* 0 dBm: 1 milliwatt */
+#define IWLAGN_TX_POWER_TARGET_POWER_MAX	(16)	/* 16 dBm */
+
 /* EEPROM */
 #define IWLAGN_EEPROM_IMG_SIZE		2048
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 257e4af..ad6cb1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -404,7 +404,7 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	if (ieee80211_is_probe_resp(fc))
 		data_retry_limit = 3;
 	else
-		data_retry_limit = IWL_DEFAULT_TX_RETRY;
+		data_retry_limit = IWLAGN_DEFAULT_TX_RETRY;
 	tx_cmd->data_retry_limit = data_retry_limit;
 
 	/* Set retry limit on RTS packets */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8b66010..ef5690a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3368,7 +3368,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	/* Set the tx_power_user_lmt to the lowest power level
 	 * this value will get overwritten by channel max power avg
 	 * from eeprom */
-	priv->tx_power_user_lmt = IWL_TX_POWER_TARGET_POWER_MIN;
+	priv->tx_power_user_lmt = IWLAGN_TX_POWER_TARGET_POWER_MIN;
 
 	ret = iwl_init_channel_map(priv);
 	if (ret) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 38d19c1..ff7f5c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1376,10 +1376,11 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	int ret = 0;
 	s8 prev_tx_power = priv->tx_power_user_lmt;
 
-	if (tx_power < IWL_TX_POWER_TARGET_POWER_MIN) {
-		IWL_WARN(priv, "Requested user TXPOWER %d below lower limit %d.\n",
+	if (tx_power < IWLAGN_TX_POWER_TARGET_POWER_MIN) {
+		IWL_WARN(priv,
+			 "Requested user TXPOWER %d below lower limit %d.\n",
 			 tx_power,
-			 IWL_TX_POWER_TARGET_POWER_MIN);
+			 IWLAGN_TX_POWER_TARGET_POWER_MIN);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7f38d2d..4319bda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -43,6 +43,7 @@
 #include "iwl-debug.h"
 #include "iwl-4965-hw.h"
 #include "iwl-3945-hw.h"
+#include "iwl-agn-hw.h"
 #include "iwl-led.h"
 #include "iwl-power.h"
 #include "iwl-agn-rs.h"
-- 
1.6.3.3

