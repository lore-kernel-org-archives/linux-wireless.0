Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8439 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbYFLBuG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:50:06 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 28/29] iwlwifi: general code clean up
Date: Thu, 12 Jun 2008 09:47:18 +0800
Message-Id: <1213235239-2954-29-git-send-email-yi.zhu@intel.com> (sfid-20080612_041914_614792_FB7C8F49)
In-Reply-To: <1213235239-2954-28-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-19-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-20-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-21-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-22-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-23-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-24-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-25-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-26-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-27-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-28-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch cleans up iwlwifi's code: Add missing include, remove empty
lines etc...

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c   |    2 -
 drivers/net/wireless/iwlwifi/iwl-calib.h   |    9 +---
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   62 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-sta.c     |   23 ++++++----
 drivers/net/wireless/iwlwifi/iwl-sta.h     |   16 +++++--
 7 files changed, 32 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index b9a4e4b..d601d31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -38,6 +38,7 @@
 #include "../net/mac80211/rate.h"
 
 #include "iwl-dev.h"
+#include "iwl-sta.h"
 #include "iwl-core.h"
 #include "iwl-helpers.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6e6038f..9662fae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -722,7 +722,7 @@ static const u16 default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_HCCA_2
 };
 
-int iwl4965_alive_notify(struct iwl_priv *priv)
+static int iwl4965_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
 	int i = 0;
@@ -827,7 +827,7 @@ static struct iwl_sensitivity_ranges iwl4965_sensitivity = {
  *
  * Called when initializing driver
  */
-int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
+static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 {
 
 	if ((priv->cfg->mod_params->num_of_queues > IWL49_NUM_QUEUES) ||
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 72242a4..48f5800 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -60,13 +60,11 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *****************************************************************************/
 
-#include <linux/kernel.h>
 #include <net/mac80211.h>
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-calib.h"
-#include "iwl-eeprom.h"
 
 /* "false alarms" are signals that our DSP tries to lock onto,
  *   but then determines that they are either noise, or transmissions
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.h b/drivers/net/wireless/iwlwifi/iwl-calib.h
index 45f37cb..5524a29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.h
@@ -62,14 +62,9 @@
 #ifndef __iwl_calib_h__
 #define __iwl_calib_h__
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/version.h>
-
-#include <net/mac80211.h>
-#include "iwl-eeprom.h"
-#include "iwl-core.h"
 #include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-commands.h"
 
 void iwl_chain_noise_calibration(struct iwl_priv *priv,
 				struct iwl4965_notif_statistics *stat_resp);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7001854..e6188f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -29,8 +29,8 @@
  * Please use iwl-4965-hw.h for hardware-related definitions.
  */
 
-#ifndef __iwl_4965_h__
-#define __iwl_4965_h__
+#ifndef __iwl_dev_h__
+#define __iwl_dev_h__
 
 #include <linux/pci.h> /* for struct pci_device_id */
 #include <linux/kernel.h>
@@ -593,15 +593,8 @@ u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
 			 u8 flags, struct ieee80211_ht_info *ht_info);
 extern int iwl4965_is_network_packet(struct iwl_priv *priv,
 				 struct ieee80211_hdr *header);
-extern int iwl4965_power_init_handle(struct iwl_priv *priv);
-extern void iwl4965_handle_data_packet_monitor(struct iwl_priv *priv,
-					   struct iwl_rx_mem_buffer *rxb,
-					   void *data, short len,
-					   struct ieee80211_rx_status *stats,
-					   u16 phy_flags);
 extern int iwl4965_is_duplicate_packet(struct iwl_priv *priv,
 				       struct ieee80211_hdr *header);
-extern int iwl4965_calc_db_from_ratio(int sig_ratio);
 extern int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,
@@ -609,18 +602,7 @@ extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 extern void iwl4965_update_chain_flags(struct iwl_priv *priv);
 int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
 
-int iwl4965_init_geos(struct iwl_priv *priv);
-void iwl4965_free_geos(struct iwl_priv *priv);
-
 extern const u8 iwl_bcast_addr[ETH_ALEN];
-int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
-
-/*
- * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
- * call this... todo... fix that.
-*/
-extern u8 iwl4965_sync_station(struct iwl_priv *priv, int sta_id,
-			   u16 tx_rate, u8 flags);
 
 /******************************************************************************
  *
@@ -638,35 +620,16 @@ extern u8 iwl4965_sync_station(struct iwl_priv *priv, int sta_id,
  * iwl4965_mac_     <-- mac80211 callback
  *
  ****************************************************************************/
-extern void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv);
-extern void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv);
-extern int iwl4965_hw_set_hw_params(struct iwl_priv *priv);
 extern int iwl_rxq_stop(struct iwl_priv *priv);
 extern void iwl_txq_ctx_stop(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl_frame *frame, u8 rate);
-extern void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
-				     struct iwl_cmd *cmd,
-				     struct ieee80211_tx_info *info,
-				     struct ieee80211_hdr *hdr,
-				     int sta_id, int tx_id);
 extern void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
 				 struct iwl_rx_mem_buffer *rxb);
 extern void iwl4965_disable_events(struct iwl_priv *priv);
-extern int iwl4965_get_temperature(const struct iwl_priv *priv);
 extern void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
 
-/**
- * iwl_find_station - Find station id for a given BSSID
- * @bssid: MAC address of station ID to find
- *
- * NOTE:  This should not be hardware specific but the code has
- * not yet been merged into a single common layer for managing the
- * station tables.
- */
-extern u8 iwl_find_station(struct iwl_priv *priv, const u8 *bssid);
-
 extern int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel);
 extern int iwl_queue_space(const struct iwl_queue *q);
 static inline int iwl_queue_used(const struct iwl_queue *q, int i)
@@ -694,16 +657,8 @@ extern int iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio);
 /*
  * Forward declare iwl-4965.c functions for iwl-base.c
  */
-extern int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
-					  struct iwl_tx_queue *txq,
-					  u16 byte_cnt);
-extern int iwl4965_alive_notify(struct iwl_priv *priv);
-extern void iwl4965_update_rate_scaling(struct iwl_priv *priv, u8 mode);
 extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
 
-extern void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
-				struct ieee80211_ht_info *ht_info,
-				enum ieee80211_band band);
 int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 				    enum ieee80211_ampdu_mlme_action action,
 				    const u8 *addr, u16 tid, u16 *ssn);
@@ -1174,17 +1129,6 @@ static inline const char *iwl_get_tx_fail_reason(u32 status) { return ""; }
 #endif
 
 
-static inline int iwl_get_ra_sta_id(struct iwl_priv *priv,
-				    struct ieee80211_hdr *hdr)
-{
-	if (priv->iw_mode == IEEE80211_IF_TYPE_STA) {
-		return IWL_AP_ID;
-	} else {
-		u8 *da = ieee80211_get_DA(hdr);
-		return iwl_find_station(priv, da);
-	}
-}
-
 static inline struct ieee80211_hdr *iwl_tx_queue_get_hdr(struct iwl_priv *priv,
 							 int txq_id, int idx)
 {
@@ -1254,4 +1198,4 @@ extern const struct iwl_channel_info *iwl_get_channel_info(
 
 /* Requires full declaration of iwl_priv before including */
 
-#endif				/* __iwl4965_4965_h__ */
+#endif				/* __iwl_dev_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index fae5d6d..f874e7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -30,11 +30,9 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 
-#include "iwl-eeprom.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-sta.h"
-#include "iwl-io.h"
 #include "iwl-helpers.h"
 
 
@@ -74,6 +72,17 @@ u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 }
 EXPORT_SYMBOL(iwl_find_station);
 
+int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
+{
+	if (priv->iw_mode == IEEE80211_IF_TYPE_STA) {
+		return IWL_AP_ID;
+	} else {
+		u8 *da = ieee80211_get_DA(hdr);
+		return iwl_find_station(priv, da);
+	}
+}
+EXPORT_SYMBOL(iwl_get_ra_sta_id);
+
 static int iwl_add_sta_callback(struct iwl_priv *priv,
 				   struct iwl_cmd *cmd, struct sk_buff *skb)
 {
@@ -105,8 +114,6 @@ static int iwl_add_sta_callback(struct iwl_priv *priv,
 	return 1;
 }
 
-
-
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags)
 {
@@ -272,7 +279,6 @@ u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
 }
 EXPORT_SYMBOL(iwl_add_station_flags);
 
-
 static int iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
 {
 	unsigned long flags;
@@ -376,9 +382,9 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 
 	return ret;
 }
+
 /**
  * iwl_remove_station - Remove driver's knowledge of station.
- *
  */
 u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
@@ -418,7 +424,7 @@ out:
 	return 0;
 }
 EXPORT_SYMBOL(iwl_remove_station);
-int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
+static int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {
 	int i;
 
@@ -869,7 +875,6 @@ int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 }
 EXPORT_SYMBOL(iwl_rxon_add_station);
 
-
 /**
  * iwl_get_sta_id - Find station's index within station table
  *
@@ -927,7 +932,6 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 }
 EXPORT_SYMBOL(iwl_get_sta_id);
 
-
 /**
  * iwl_sta_modify_enable_tid_tx - Enable Tx for this TID in station table
  */
@@ -946,4 +950,3 @@ void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv, int sta_id, int tid)
 }
 EXPORT_SYMBOL(iwl_sta_modify_enable_tid_tx);
 
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 3d55716..b6bb209 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -32,18 +32,24 @@
 #define HW_KEY_DYNAMIC 0
 #define HW_KEY_DEFAULT 1
 
-int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
+/**
+ * iwl_find_station - Find station id for a given BSSID
+ * @bssid: MAC address of station ID to find
+ */
+u8 iwl_find_station(struct iwl_priv *priv, const u8 *bssid);
+
 int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty);
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *key);
+			       struct ieee80211_key_conf *key);
 int iwl_set_default_wep_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *key);
+			    struct ieee80211_key_conf *key);
 int iwl_set_dynamic_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *key, u8 sta_id);
+			struct ieee80211_key_conf *key, u8 sta_id);
 int iwl_remove_dynamic_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *key, u8 sta_id);
+			   struct ieee80211_key_conf *key, u8 sta_id);
 int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv, int sta_id, int tid);
+int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 #endif /* __iwl_sta_h__ */
-- 
1.5.3.6

