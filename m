Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab0CJFWC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:02 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/24] iwlwifi: move 3945 specific data into union
Date: Tue,  9 Mar 2010 21:21:30 -0800
Message-Id: <1268198512-6572-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To be obviously correct, this patch only modifies
3945 files and the struct definition. A follow-up
patch will create the AGN part of the union.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    2 +
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   27 ++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   30 ++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   22 +++++++++---------
 5 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 3a876a8..074f42a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -78,6 +78,8 @@
 /* RSSI to dBm */
 #define IWL39_RSSI_OFFSET	95
 
+#define IWL_DEFAULT_TX_POWER	0x0F
+
 /*
  * EEPROM related constants, enums, and structures.
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 47909f9..effdd36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -372,11 +372,11 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 		}
 	}
 
-	priv->sta_supp_rates = sta->supp_rates[sband->band];
+	priv->_3945.sta_supp_rates = sta->supp_rates[sband->band];
 	/* For 5 GHz band it start at IWL_FIRST_OFDM_RATE */
 	if (sband->band == IEEE80211_BAND_5GHZ) {
 		rs_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
-		priv->sta_supp_rates = priv->sta_supp_rates <<
+		priv->_3945.sta_supp_rates = priv->_3945.sta_supp_rates <<
 						IWL_FIRST_OFDM_RATE;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 303cc81..867bd69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -242,7 +242,7 @@ int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate)
 			next_rate = IWL_RATE_6M_INDEX;
 		break;
 	case IEEE80211_BAND_2GHZ:
-		if (!(priv->sta_supp_rates & IWL_OFDM_RATES_MASK) &&
+		if (!(priv->_3945.sta_supp_rates & IWL_OFDM_RATES_MASK) &&
 		    iwl_is_associated(priv)) {
 			if (rate == IWL_RATE_11M_INDEX)
 				next_rate = IWL_RATE_5M_INDEX;
@@ -359,7 +359,7 @@ void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 		     (int)sizeof(struct iwl3945_notif_statistics),
 		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
 
-	memcpy(&priv->statistics_39, pkt->u.raw, sizeof(priv->statistics_39));
+	memcpy(&priv->_3945.statistics, pkt->u.raw, sizeof(priv->_3945.statistics));
 }
 
 /******************************************************************************
@@ -956,7 +956,7 @@ static int iwl3945_tx_reset(struct iwl_priv *priv)
 	iwl_write_prph(priv, ALM_SCD_TXF5MF_REG, 0x000005);
 
 	iwl_write_direct32(priv, FH39_TSSR_CBB_BASE,
-			     priv->shared_phys);
+			     priv->_3945.shared_phys);
 
 	iwl_write_direct32(priv, FH39_TSSR_MSG_CONFIG,
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON |
@@ -1997,13 +1997,13 @@ void iwl3945_reg_txpower_periodic(struct iwl_priv *priv)
 
  reschedule:
 	queue_delayed_work(priv->workqueue,
-			   &priv->thermal_periodic, REG_RECALIB_PERIOD * HZ);
+			   &priv->_3945.thermal_periodic, REG_RECALIB_PERIOD * HZ);
 }
 
 static void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
-					     thermal_periodic.work);
+					     _3945.thermal_periodic.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -2331,7 +2331,7 @@ int iwl3945_hw_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	int txq_id = txq->q.id;
 
-	struct iwl3945_shared *shared_data = priv->shared_virt;
+	struct iwl3945_shared *shared_data = priv->_3945.shared_virt;
 
 	shared_data->tx_base_ptr[txq_id] = cpu_to_le32((u32)txq->q.dma_addr);
 
@@ -2431,7 +2431,7 @@ int iwl3945_init_hw_rate_table(struct iwl_priv *priv)
 		/* If an OFDM rate is used, have it fall back to the
 		 * 1M CCK rates */
 
-		if (!(priv->sta_supp_rates & IWL_OFDM_RATES_MASK) &&
+		if (!(priv->_3945.sta_supp_rates & IWL_OFDM_RATES_MASK) &&
 		    iwl_is_associated(priv)) {
 
 			index = IWL_FIRST_CCK_RATE;
@@ -2470,10 +2470,11 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 	memset((void *)&priv->hw_params, 0,
 	       sizeof(struct iwl_hw_params));
 
-	priv->shared_virt = dma_alloc_coherent(&priv->pci_dev->dev,
-					       sizeof(struct iwl3945_shared),
-					       &priv->shared_phys, GFP_KERNEL);
-	if (!priv->shared_virt) {
+	priv->_3945.shared_virt =
+		dma_alloc_coherent(&priv->pci_dev->dev,
+				   sizeof(struct iwl3945_shared),
+				   &priv->_3945.shared_phys, GFP_KERNEL);
+	if (!priv->_3945.shared_virt) {
 		IWL_ERR(priv, "failed to allocate pci memory\n");
 		mutex_unlock(&priv->mutex);
 		return -ENOMEM;
@@ -2536,13 +2537,13 @@ void iwl3945_hw_rx_handler_setup(struct iwl_priv *priv)
 
 void iwl3945_hw_setup_deferred_work(struct iwl_priv *priv)
 {
-	INIT_DELAYED_WORK(&priv->thermal_periodic,
+	INIT_DELAYED_WORK(&priv->_3945.thermal_periodic,
 			  iwl3945_bg_reg_txpower_periodic);
 }
 
 void iwl3945_hw_cancel_deferred_work(struct iwl_priv *priv)
 {
-	cancel_delayed_work(&priv->thermal_periodic);
+	cancel_delayed_work(&priv->_3945.thermal_periodic);
 }
 
 /* check contents of special bootstrap uCode SRAM */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6054c5f..e6cae38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1262,10 +1262,22 @@ struct iwl_priv {
 	u16 beacon_int;
 	struct ieee80211_vif *vif;
 
-	/*Added for 3945 */
-	void *shared_virt;
-	dma_addr_t shared_phys;
-	/*End*/
+	union {
+#if defined(CONFIG_IWL3945) || defined(CONFIG_IWL3945_MODULE)
+		struct {
+			void *shared_virt;
+			dma_addr_t shared_phys;
+
+			struct delayed_work thermal_periodic;
+			struct delayed_work rfkill_poll;
+
+			struct iwl3945_notif_statistics statistics;
+
+			u32 sta_supp_rates;
+		} _3945;
+#endif
+	};
+
 	struct iwl_hw_params hw_params;
 
 	/* INT ICT Table */
@@ -1303,10 +1315,6 @@ struct iwl_priv {
 	struct delayed_work alive_start;
 	struct delayed_work scan_check;
 
-	/*For 3945 only*/
-	struct delayed_work thermal_periodic;
-	struct delayed_work rfkill_poll;
-
 	/* TX Power */
 	s8 tx_power_user_lmt;
 	s8 tx_power_device_lmt;
@@ -1339,12 +1347,6 @@ struct iwl_priv {
 	struct timer_list statistics_periodic;
 	struct timer_list ucode_trace;
 	bool hw_ready;
-	/*For 3945*/
-#define IWL_DEFAULT_TX_POWER 0x0F
-
-	struct iwl3945_notif_statistics statistics_39;
-
-	u32 sta_supp_rates;
 
 	struct iwl_event_log event_log;
 }; /*iwl_priv */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 54daa38..1b3a1ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -351,11 +351,11 @@ static int iwl3945_send_beacon_cmd(struct iwl_priv *priv)
 
 static void iwl3945_unset_hw_params(struct iwl_priv *priv)
 {
-	if (priv->shared_virt)
+	if (priv->_3945.shared_virt)
 		dma_free_coherent(&priv->pci_dev->dev,
 				  sizeof(struct iwl3945_shared),
-				  priv->shared_virt,
-				  priv->shared_phys);
+				  priv->_3945.shared_virt,
+				  priv->_3945.shared_phys);
 }
 
 static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
@@ -2786,7 +2786,7 @@ static void iwl3945_bg_alive_start(struct work_struct *data)
 static void iwl3945_rfkill_poll(struct work_struct *data)
 {
 	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, rfkill_poll.work);
+	    container_of(data, struct iwl_priv, _3945.rfkill_poll.work);
 	bool old_rfkill = test_bit(STATUS_RF_KILL_HW, &priv->status);
 	bool new_rfkill = !(iwl_read32(priv, CSR_GP_CNTRL)
 			& CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
@@ -2805,7 +2805,7 @@ static void iwl3945_rfkill_poll(struct work_struct *data)
 
 	/* Keep this running, even if radio now enabled.  This will be
 	 * cancelled in mac_start() if system decides to start again */
-	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
+	queue_delayed_work(priv->workqueue, &priv->_3945.rfkill_poll,
 			   round_jiffies_relative(2 * HZ));
 
 }
@@ -3212,7 +3212,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 
 	/* ucode is running and will send rfkill notifications,
 	 * no need to poll the killswitch state anymore */
-	cancel_delayed_work(&priv->rfkill_poll);
+	cancel_delayed_work(&priv->_3945.rfkill_poll);
 
 	iwl_led_start(priv);
 
@@ -3253,7 +3253,7 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 	flush_workqueue(priv->workqueue);
 
 	/* start polling the killswitch state again */
-	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
+	queue_delayed_work(priv->workqueue, &priv->_3945.rfkill_poll,
 			   round_jiffies_relative(2 * HZ));
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
@@ -3660,7 +3660,7 @@ static ssize_t show_statistics(struct device *d,
 	struct iwl_priv *priv = dev_get_drvdata(d);
 	u32 size = sizeof(struct iwl3945_notif_statistics);
 	u32 len = 0, ofs = 0;
-	u8 *data = (u8 *)&priv->statistics_39;
+	u8 *data = (u8 *)&priv->_3945.statistics;
 	int rc = 0;
 
 	if (!iwl_is_alive(priv))
@@ -3773,7 +3773,7 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->beacon_update, iwl3945_bg_beacon_update);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl3945_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
-	INIT_DELAYED_WORK(&priv->rfkill_poll, iwl3945_rfkill_poll);
+	INIT_DELAYED_WORK(&priv->_3945.rfkill_poll, iwl3945_rfkill_poll);
 	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
 	INIT_WORK(&priv->request_scan, iwl3945_bg_request_scan);
 	INIT_WORK(&priv->abort_scan, iwl_bg_abort_scan);
@@ -4129,7 +4129,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
 
 	/* Start monitoring the killswitch */
-	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
+	queue_delayed_work(priv->workqueue, &priv->_3945.rfkill_poll,
 			   2 * HZ);
 
 	return 0;
@@ -4203,7 +4203,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 
-	cancel_delayed_work_sync(&priv->rfkill_poll);
+	cancel_delayed_work_sync(&priv->_3945.rfkill_poll);
 
 	iwl3945_dealloc_ucode_pci(priv);
 
-- 
1.6.3.3

