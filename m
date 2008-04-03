Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbYDCXFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 19:05:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/5] iwlwifi: move driver status inliners into iwl-core.h
Date: Thu,  3 Apr 2008 16:05:21 -0700
Message-Id: <1207263924-25385-3-git-send-email-reinette.chatre@intel.com> (sfid-20080404_000607_129769_87B84A15)
In-Reply-To: <1207263924-25385-2-git-send-email-reinette.chatre@intel.com>
References: <1207263924-25385-1-git-send-email-reinette.chatre@intel.com>
 <1207263924-25385-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves inline functions into iwl-core.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.h     |   20 ------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   57 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-led.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c   |    9 +---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   92 +++++++++------------------
 8 files changed, 91 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3c48952..558e307 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -39,8 +39,8 @@
 #include <asm/unaligned.h>
 
 #include "iwl-eeprom.h"
-#include "iwl-core.h"
 #include "iwl-4965.h"
+#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 25fc09d..1cc6f10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -414,26 +414,6 @@ struct iwl4965_rx_queue {
 #define MAX_B_CHANNELS  14
 #define MIN_B_CHANNELS  1
 
-#define STATUS_HCMD_ACTIVE	0	/* host command in progress */
-#define STATUS_HCMD_SYNC_ACTIVE	1	/* sync host command in progress */
-#define STATUS_INT_ENABLED	2
-#define STATUS_RF_KILL_HW	3
-#define STATUS_RF_KILL_SW	4
-#define STATUS_INIT		5
-#define STATUS_ALIVE		6
-#define STATUS_READY		7
-#define STATUS_TEMPERATURE	8
-#define STATUS_GEO_CONFIGURED	9
-#define STATUS_EXIT_PENDING	10
-#define STATUS_IN_SUSPEND	11
-#define STATUS_STATISTICS	12
-#define STATUS_SCANNING		13
-#define STATUS_SCAN_ABORTING	14
-#define STATUS_SCAN_HW		15
-#define STATUS_POWER_PMI	16
-#define STATUS_FW_ERROR		17
-#define STATUS_CONF_PENDING	18
-
 #define MAX_TID_COUNT        9
 
 #define IWL_INVALID_RATE     0xFF
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 49fb52f..f122307 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -34,10 +34,10 @@
 struct iwl_priv; /* FIXME: remove */
 #include "iwl-debug.h"
 #include "iwl-eeprom.h"
+#include "iwl-4965.h" /* FIXME: remove */
 #include "iwl-core.h"
 #include "iwl-rfkill.h"
 
-#include "iwl-4965.h" /* FIXME: remove */
 
 MODULE_DESCRIPTION("iwl core");
 MODULE_VERSION(IWLWIFI_VERSION);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 64f4df5..6d82376 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -148,6 +148,63 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 			   int (*callback)(struct iwl_priv *priv,
 					   struct iwl_cmd *cmd,
 					   struct sk_buff *skb));
+/*************** DRIVER STATUS FUNCTIONS   *****/
+
+#define STATUS_HCMD_ACTIVE	0	/* host command in progress */
+#define STATUS_HCMD_SYNC_ACTIVE	1	/* sync host command in progress */
+#define STATUS_INT_ENABLED	2
+#define STATUS_RF_KILL_HW	3
+#define STATUS_RF_KILL_SW	4
+#define STATUS_INIT		5
+#define STATUS_ALIVE		6
+#define STATUS_READY		7
+#define STATUS_TEMPERATURE	8
+#define STATUS_GEO_CONFIGURED	9
+#define STATUS_EXIT_PENDING	10
+#define STATUS_IN_SUSPEND	11
+#define STATUS_STATISTICS	12
+#define STATUS_SCANNING		13
+#define STATUS_SCAN_ABORTING	14
+#define STATUS_SCAN_HW		15
+#define STATUS_POWER_PMI	16
+#define STATUS_FW_ERROR		17
+#define STATUS_CONF_PENDING	18
+
+
+static inline int iwl_is_ready(struct iwl_priv *priv)
+{
+	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
+	 * set but EXIT_PENDING is not */
+	return test_bit(STATUS_READY, &priv->status) &&
+	       test_bit(STATUS_GEO_CONFIGURED, &priv->status) &&
+	       !test_bit(STATUS_EXIT_PENDING, &priv->status);
+}
+
+static inline int iwl_is_alive(struct iwl_priv *priv)
+{
+	return test_bit(STATUS_ALIVE, &priv->status);
+}
+
+static inline int iwl_is_init(struct iwl_priv *priv)
+{
+	return test_bit(STATUS_INIT, &priv->status);
+}
+
+static inline int iwl_is_rfkill(struct iwl_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
+	       test_bit(STATUS_RF_KILL_SW, &priv->status);
+}
+
+static inline int iwl_is_ready_rf(struct iwl_priv *priv)
+{
+
+	if (iwl_is_rfkill(priv))
+		return 0;
+
+	return iwl_is_ready(priv);
+}
+
 
 enum iwlcore_card_notify {
 	IWLCORE_INIT_EVT = 0,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index b2cc552..bee358d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -36,6 +36,7 @@
 
 #include "iwl-4965.h"
 #include "iwl-debug.h"
+#include "iwl-core.h"
 #include "iwl-io.h"
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 4fe5ee2..03fdf5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -40,8 +40,8 @@
 #include <asm/unaligned.h>
 
 #include "iwl-4965.h"
-#include "iwl-io.h"
 #include "iwl-core.h"
+#include "iwl-io.h"
 #include "iwl-helpers.h"
 
 #define IWL_1MB_RATE (128 * 1024)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 66abf52..308d69b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -33,18 +33,11 @@
 #include <net/mac80211.h>
 
 #include "iwl-eeprom.h"
-#include "iwl-core.h"
 #include "iwl-4965.h"
+#include "iwl-core.h"
 #include "iwl-helpers.h"
 
 
-static inline int iwl_is_rfkill(struct iwl_priv *priv)
-{
-	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-		test_bit(STATUS_RF_KILL_SW, &priv->status);
-}
-
-
 /* software rf-kill from user */
 static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f995af6..5dfc414 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -46,8 +46,8 @@
 #include <asm/div64.h>
 
 #include "iwl-eeprom.h"
-#include "iwl-core.h"
 #include "iwl-4965.h"
+#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
@@ -496,41 +496,7 @@ u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 
 }
 
-/*************** DRIVER STATUS FUNCTIONS   *****/
-
-static inline int iwl4965_is_ready(struct iwl_priv *priv)
-{
-	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
-	 * set but EXIT_PENDING is not */
-	return test_bit(STATUS_READY, &priv->status) &&
-	       test_bit(STATUS_GEO_CONFIGURED, &priv->status) &&
-	       !test_bit(STATUS_EXIT_PENDING, &priv->status);
-}
-
-static inline int iwl4965_is_alive(struct iwl_priv *priv)
-{
-	return test_bit(STATUS_ALIVE, &priv->status);
-}
 
-static inline int iwl4965_is_init(struct iwl_priv *priv)
-{
-	return test_bit(STATUS_INIT, &priv->status);
-}
-
-static inline int iwl4965_is_rfkill(struct iwl_priv *priv)
-{
-	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-	       test_bit(STATUS_RF_KILL_SW, &priv->status);
-}
-
-static inline int iwl4965_is_ready_rf(struct iwl_priv *priv)
-{
-
-	if (iwl4965_is_rfkill(priv))
-		return 0;
-
-	return iwl4965_is_ready(priv);
-}
 
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
@@ -562,7 +528,7 @@ int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
 	       !(cmd->meta.flags & CMD_SIZE_HUGE));
 
-	if (iwl4965_is_rfkill(priv)) {
+	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_INFO("Not sending command - RF KILL");
 		return -EIO;
 	}
@@ -858,7 +824,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	DECLARE_MAC_BUF(mac);
 	int rc = 0;
 
-	if (!iwl4965_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -1;
 
 	/* always get timestamp with Rx frame */
@@ -1973,7 +1939,7 @@ static int iwl4965_scan_initiate(struct iwl_priv *priv)
 		return 0;
 	}
 
-	if (!iwl4965_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
 		return -EIO;
 	}
@@ -2127,7 +2093,7 @@ static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 	iwlcore_clear_stations_table(priv);
 
 	/* dont commit rxon if rf-kill is on*/
-	if (!iwl4965_is_ready_rf(priv))
+	if (!iwl_is_ready_rf(priv))
 		return -EAGAIN;
 
 	cancel_delayed_work(&priv->scan_check);
@@ -2343,7 +2309,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	int rc;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl4965_is_rfkill(priv)) {
+	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_DROP("Dropping - RF KILL\n");
 		goto drop_unlock;
 	}
@@ -5701,7 +5667,7 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 	/* Clear out the uCode error bit if it is set */
 	clear_bit(STATUS_FW_ERROR, &priv->status);
 
-	if (iwl4965_is_rfkill(priv))
+	if (iwl_is_rfkill(priv))
 		return;
 
 	ieee80211_start_queues(priv->hw);
@@ -5794,7 +5760,7 @@ static void __iwl4965_down(struct iwl_priv *priv)
 
 	/* If we have not previously called iwl4965_init() then
 	 * clear all bits but the RF Kill and SUSPEND bits and return */
-	if (!iwl4965_is_init(priv)) {
+	if (!iwl_is_init(priv)) {
 		priv->status = test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 					STATUS_RF_KILL_HW |
 			       test_bit(STATUS_RF_KILL_SW, &priv->status) <<
@@ -6004,7 +5970,7 @@ static void iwl4965_bg_rf_kill(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	if (!iwl4965_is_rfkill(priv)) {
+	if (!iwl_is_rfkill(priv)) {
 		IWL_DEBUG(IWL_DL_INFO | IWL_DL_RF_KILL,
 			  "HW and/or SW RF Kill no longer active, restarting "
 			  "device\n");
@@ -6071,7 +6037,7 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 
 	mutex_lock(&priv->mutex);
 
-	if (!iwl4965_is_ready(priv)) {
+	if (!iwl_is_ready(priv)) {
 		IWL_WARNING("request scan called when driver not ready.\n");
 		goto done;
 	}
@@ -6100,7 +6066,7 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
-	if (iwl4965_is_rfkill(priv)) {
+	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_HC("Aborting scan due to RF Kill activation\n");
 		goto done;
 	}
@@ -6419,7 +6385,7 @@ static void iwl4965_bg_abort_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
-	if (!iwl4965_is_ready(priv))
+	if (!iwl_is_ready(priv))
 		return;
 
 	mutex_lock(&priv->mutex);
@@ -6552,7 +6518,7 @@ static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 
 	priv->is_open = 0;
 
-	if (iwl4965_is_ready_rf(priv)) {
+	if (iwl_is_ready_rf(priv)) {
 		/* stop mac, cancel any scan request and clear
 		 * RXON_FILTER_ASSOC_MSK BIT
 		 */
@@ -6621,7 +6587,7 @@ static int iwl4965_mac_add_interface(struct ieee80211_hw *hw,
 		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 	}
 
-	if (iwl4965_is_ready(priv))
+	if (iwl_is_ready(priv))
 		iwl4965_set_mode(priv, conf->type);
 
 	mutex_unlock(&priv->mutex);
@@ -6649,7 +6615,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 	priv->add_radiotap = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
 
-	if (!iwl4965_is_ready(priv)) {
+	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
 		ret = -EIO;
 		goto out;
@@ -6713,7 +6679,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		goto out;
 	}
 
-	if (iwl4965_is_rfkill(priv)) {
+	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF kill\n");
 		ret = -EIO;
 		goto out;
@@ -6820,7 +6786,7 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 		return 0;
 	}
 
-	if (!iwl4965_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	mutex_lock(&priv->mutex);
@@ -6849,7 +6815,7 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 		priv->ibss_beacon = conf->beacon;
 	}
 
-	if (iwl4965_is_rfkill(priv))
+	if (iwl_is_rfkill(priv))
 		goto done;
 
 	if (conf->bssid && !is_zero_ether_addr(conf->bssid) &&
@@ -6923,7 +6889,7 @@ static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (iwl4965_is_ready_rf(priv)) {
+	if (iwl_is_ready_rf(priv)) {
 		iwl4965_scan_cancel_timeout(priv, 100);
 		cancel_delayed_work(&priv->post_associate);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
@@ -7064,7 +7030,7 @@ static int iwl4965_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	mutex_lock(&priv->mutex);
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (!iwl4965_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		rc = -EIO;
 		IWL_DEBUG_MAC80211("leave - not ready or exit pending\n");
 		goto out_unlock;
@@ -7231,7 +7197,7 @@ static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl4965_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF not ready\n");
 		return -EIO;
 	}
@@ -7284,7 +7250,7 @@ static int iwl4965_mac_get_tx_stats(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl4965_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF not ready\n");
 		return -EIO;
 	}
@@ -7362,7 +7328,7 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (!iwl4965_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
 		mutex_unlock(&priv->mutex);
 		return;
@@ -7403,7 +7369,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl4965_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF not ready\n");
 		mutex_unlock(&priv->mutex);
 		return -EIO;
@@ -7483,7 +7449,7 @@ static ssize_t show_temperature(struct device *d,
 {
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 
-	if (!iwl4965_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	return sprintf(buf, "%d\n", iwl4965_hw_get_temperature(priv));
@@ -7705,7 +7671,7 @@ static ssize_t store_power_level(struct device *d,
 	mode = simple_strtoul(buf, NULL, 0);
 	mutex_lock(&priv->mutex);
 
-	if (!iwl4965_is_ready(priv)) {
+	if (!iwl_is_ready(priv)) {
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -7802,7 +7768,7 @@ static ssize_t show_statistics(struct device *d,
 	u8 *data = (u8 *) & priv->statistics;
 	int rc = 0;
 
-	if (!iwl4965_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	mutex_lock(&priv->mutex);
@@ -7836,7 +7802,7 @@ static ssize_t show_antenna(struct device *d,
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
 
-	if (!iwl4965_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	return sprintf(buf, "%d\n", priv->antenna);
@@ -7873,7 +7839,7 @@ static ssize_t show_status(struct device *d,
 			   struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-	if (!iwl4965_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 	return sprintf(buf, "0x%08x\n", (int)priv->status);
 }
-- 
1.5.3.4

