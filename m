Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15586 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbYICDbm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:42 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 36/39] iwlwifi: remove uneeded declarations
Date: Wed,  3 Sep 2008 11:26:56 +0800
Message-Id: <1220412419-15404-37-git-send-email-yi.zhu@intel.com> (sfid-20080903_055043_648271_A305C0C5)
In-Reply-To: <1220412419-15404-36-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-25-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-28-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-29-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-30-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-31-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-32-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-33-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-34-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-35-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-36-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch cleans up iwlwifi by removing uneeded declarations and removing
uneeded symbol export reducing the namespace pollution. It also fixes some
typos in comments.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c  |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c  |    9 ++----
 drivers/net/wireless/iwlwifi/iwl-core.h  |   10 +------
 drivers/net/wireless/iwlwifi/iwl-dev.h   |   45 ++++++++---------------------
 drivers/net/wireless/iwlwifi/iwl-power.c |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-power.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c  |    3 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c    |    9 ++----
 9 files changed, 28 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d9c4fdb..d2569a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1607,8 +1607,7 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 	return ret;
 }
 
-
-int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
+static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
 	int rc;
 	u8 band = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 45cdf31..cf882bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -485,7 +485,7 @@ static u8 iwl4965_rate_get_lowest_plcp(struct iwl_priv *priv)
 		return IWL_RATE_6M_PLCP;
 }
 
-unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
+static unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				       struct iwl_frame *frame, u8 rate)
 {
 	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 134f4ee..0901e43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -801,7 +801,7 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 	else
 		priv->staging_rxon.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
 
-	IWL_DEBUG_ASSOC("rx_chain=0x%Xi active=%d idle=%d\n",
+	IWL_DEBUG_ASSOC("rx_chain=0x%X active=%d idle=%d\n",
 			priv->staging_rxon.rx_chain,
 			active_rx_cnt, idle_rx_cnt);
 
@@ -1154,7 +1154,6 @@ int iwl_verify_ucode(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_verify_ucode);
 
-
 static const char *desc_lookup(int i)
 {
 	switch (i) {
@@ -1235,9 +1234,9 @@ EXPORT_SYMBOL(iwl_dump_nic_error_log);
 /**
  * iwl_print_event_log - Dump error event log to syslog
  *
- * NOTE: Must be called with iwl4965_grab_nic_access() already obtained!
+ * NOTE: Must be called with iwl_grab_nic_access() already obtained!
  */
-void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
+static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 				u32 num_events, u32 mode)
 {
 	u32 i;
@@ -1278,8 +1277,6 @@ void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		}
 	}
 }
-EXPORT_SYMBOL(iwl_print_event_log);
-
 
 void iwl_dump_nic_event_log(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b5db050..55a4b58 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -184,7 +184,6 @@ struct iwl_cfg {
 struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 		struct ieee80211_ops *hw_ops);
 void iwl_hw_detect(struct iwl_priv *priv);
-
 void iwl_clear_stations_table(struct iwl_priv *priv);
 void iwl_reset_qos(struct iwl_priv *priv);
 void iwl_set_rxon_chain(struct iwl_priv *priv);
@@ -215,7 +214,6 @@ void iwl_rx_replenish(struct iwl_priv *priv);
 int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwl_rx_agg_start(struct iwl_priv *priv, const u8 *addr, int tid, u16 ssn);
 int iwl_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid);
-/* FIXME: remove when TX is moved to iwl core */
 int iwl_rx_queue_restock(struct iwl_priv *priv);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
 void iwl_rx_allocate(struct iwl_priv *priv);
@@ -234,11 +232,7 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 ******************************************************/
 int iwl_txq_ctx_reset(struct iwl_priv *priv);
 int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
-/* FIXME: remove when free Tx is fully merged into iwlcore */
-int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
-int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
-					dma_addr_t addr, u16 len);
 int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn);
 int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid);
@@ -253,6 +247,7 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
  * RF -Kill - here and not in iwl-rfkill.h to be available when
  * RF-kill subsystem is not compiled.
  ****************************************************/
+void iwl_rf_kill(struct iwl_priv *priv);
 void iwl_radio_kill_sw_disable_radio(struct iwl_priv *priv);
 int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv);
 
@@ -283,7 +278,6 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 void iwl_init_scan_params(struct iwl_priv *priv);
 int iwl_scan_cancel(struct iwl_priv *priv);
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
-const char *iwl_escape_essid(const char *essid, u8 essid_len);
 int iwl_scan_initiate(struct iwl_priv *priv);
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
@@ -316,8 +310,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 /*****************************************************
 *  Error Handling Debugging
 ******************************************************/
-void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
-			 u32 num_events, u32 mode);
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
 void iwl_dump_nic_event_log(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6e150f6..1823687 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -565,50 +565,31 @@ struct iwl_hw_params {
 #define IWL_RX_STATS(x) (&x->u.rx_frame.stats)
 #define IWL_RX_DATA(x) (IWL_RX_HDR(x)->payload)
 
-
-/******************************************************************************
- *
- * Functions implemented in iwl-base.c which are forward declared here
- * for use by iwl-*.c
- *
- *****************************************************************************/
-struct iwl_addsta_cmd;
-extern int iwl_send_add_sta(struct iwl_priv *priv,
-			    struct iwl_addsta_cmd *sta, u8 flags);
-u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
-			 u8 flags, struct ieee80211_ht_info *ht_info);
-extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
-					struct ieee80211_hdr *hdr,
-					const u8 *dest, int left);
-extern void iwl4965_update_chain_flags(struct iwl_priv *priv);
-int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
-extern int iwl4965_set_power(struct iwl_priv *priv, void *cmd);
-
-extern const u8 iwl_bcast_addr[ETH_ALEN];
-
 /******************************************************************************
  *
- * Functions implemented in iwl-[34]*.c which are forward declared here
- * for use by iwl-base.c
+ * Functions implemented in core module which are forward declared here
+ * for use by iwl-[4-5].c
  *
- * NOTE:  The implementation of these functions are hardware specific
- * which is why they are in the hardware specific files (vs. iwl-base.c)
+ * NOTE:  The implementation of these functions are not hardware specific
+ * which is why they are in the core module files.
  *
  * Naming convention --
- * iwl4965_         <-- Its part of iwlwifi (should be changed to iwl4965_)
- * iwl4965_hw_      <-- Hardware specific (implemented in iwl-XXXX.c by all HW)
+ * iwl_         <-- Is part of iwlwifi
  * iwlXXXX_     <-- Hardware specific (implemented in iwl-XXXX.c for XXXX)
  * iwl4965_bg_      <-- Called from work queue context
  * iwl4965_mac_     <-- mac80211 callback
  *
  ****************************************************************************/
+struct iwl_addsta_cmd;
+extern int iwl_send_add_sta(struct iwl_priv *priv,
+			    struct iwl_addsta_cmd *sta, u8 flags);
+extern u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr,
+			int is_ap, u8 flags, struct ieee80211_ht_info *ht_info);
+extern void iwl4965_update_chain_flags(struct iwl_priv *priv);
+extern int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
+extern const u8 iwl_bcast_addr[ETH_ALEN];
 extern int iwl_rxq_stop(struct iwl_priv *priv);
 extern void iwl_txq_ctx_stop(struct iwl_priv *priv);
-extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
-				 struct iwl_frame *frame, u8 rate);
-extern void iwl4965_disable_events(struct iwl_priv *priv);
-
-extern int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel);
 extern int iwl_queue_space(const struct iwl_queue *q);
 static inline int iwl_queue_used(const struct iwl_queue *q, int i)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index bd6f600..55ec31e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -250,7 +250,7 @@ static int iwl_update_power_command(struct iwl_priv *priv,
 
 
 /*
- * calucaute the final power mode index
+ * compute the final power mode index
  */
 int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 {
@@ -267,9 +267,9 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 		return -EAGAIN;
 	}
 
-       /* If on battery, set to 3,
-	* if plugged into AC power, set to CAM ("continuously aware mode"),
-	* else user level */
+	/* If on battery, set to 3,
+	 * if plugged into AC power, set to CAM ("continuously aware mode"),
+	 * else user level */
 
 	switch (setting->system_power_setting) {
 	case IWL_POWER_SYS_AUTO:
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index a5c334f..df484a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -72,7 +72,7 @@ struct iwl_power_mgr {
 	/* final power level that used to calculate final power command */
 	u8 power_mode;
 	u8 user_power_setting; /* set by user through mac80211 or sysfs */
-	u8 system_power_setting; /* set by kernel syatem tools */
+	u8 system_power_setting; /* set by kernel system tools */
 	u8 critical_power_setting; /* set if driver over heated */
 	u8 is_battery_active; /* DC/AC power */
 	u8 power_disabled; /* flag to disable using power saving level */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 6c8ac3a..d026aaf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -88,7 +88,7 @@ static int iwl_is_empty_essid(const char *essid, int essid_len)
 
 
 
-const char *iwl_escape_essid(const char *essid, u8 essid_len)
+static const char *iwl_escape_essid(const char *essid, u8 essid_len)
 {
 	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
 	const char *s = essid;
@@ -111,7 +111,6 @@ const char *iwl_escape_essid(const char *essid, u8 essid_len)
 	*d = '\0';
 	return escaped;
 }
-EXPORT_SYMBOL(iwl_escape_essid);
 
 /**
  * iwl_scan_cancel - Cancel any currently executing HW scan
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 4b4a2bc..9ef6451 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -63,7 +63,7 @@ static const u16 default_tid_to_tx_fifo[] = {
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
-int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+static int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	struct iwl_tfd_frame *bd_tmp = (struct iwl_tfd_frame *)&txq->bd[0];
 	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.read_ptr];
@@ -115,10 +115,8 @@ int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(iwl_hw_txq_free_tfd);
 
-
-int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
+static int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 				 dma_addr_t addr, u16 len)
 {
 	int index, is_odd;
@@ -151,7 +149,6 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 
 	return 0;
 }
-EXPORT_SYMBOL(iwl_hw_txq_attach_buf_to_tfd);
 
 /**
  * iwl_txq_update_write_ptr - Send new write index to hardware
@@ -478,7 +475,6 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_hw_txq_ctx_free);
 
-
 /**
  * iwl_txq_ctx_reset - Reset TX queue context
  * Destroys all DMA structures and initialise them again
@@ -545,6 +541,7 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
  error_kw:
 	return ret;
 }
+
 /**
  * iwl_txq_ctx_stop - Stop all Tx DMA channels, free Tx queue memory
  */
-- 
1.5.3.6

