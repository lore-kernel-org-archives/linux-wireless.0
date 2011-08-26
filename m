Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab1HZGx3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/60] iwlagn: priv->lock moves to iwl_shared
Date: Thu, 25 Aug 2011 23:10:43 -0700
Message-Id: <1314339092-20797-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085453_288666_A3ECF7E0)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since it is used by all the layers, it needs to move to iwl_shared.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c     |   14 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |   12 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   14 +++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    1 -
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    2 +
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c |   28 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c         |   26 ++++++++++----------
 13 files changed, 61 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e073422..feefb5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -69,7 +69,7 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 
 	iwl_rf_config(priv);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 
 	/* W/A : NIC is stuck in a reset state after Early PCIe power off
 	 * (PCIe power is lost before PERST# is asserted),
@@ -80,7 +80,7 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 }
 
 static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index f0e38a1..fb6da14 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -658,13 +658,13 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv)
 		return;
 	}
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	rx_info = &priv->statistics.rx_non_phy;
 	ofdm = &priv->statistics.rx_ofdm;
 	cck = &priv->statistics.rx_cck;
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
 		IWL_DEBUG_CALIB(priv, "<< invalid data.\n");
-		spin_unlock_irqrestore(&priv->lock, flags);
+		spin_unlock_irqrestore(&priv->shrd->lock, flags);
 		return;
 	}
 
@@ -688,7 +688,7 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv)
 	statis.beacon_energy_c =
 			le32_to_cpu(rx_info->beacon_energy_c);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	IWL_DEBUG_CALIB(priv, "rx_enable_time = %u usecs\n", rx_enable_time);
 
@@ -976,13 +976,13 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 		return;
 	}
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 
 	rx_info = &priv->statistics.rx_non_phy;
 
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
 		IWL_DEBUG_CALIB(priv, " << Interference data unavailable\n");
-		spin_unlock_irqrestore(&priv->lock, flags);
+		spin_unlock_irqrestore(&priv->shrd->lock, flags);
 		return;
 	}
 
@@ -997,7 +997,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	if ((rxon_chnum != stat_chnum) || (rxon_band24 != stat_band24)) {
 		IWL_DEBUG_CALIB(priv, "Stats not from chan=%d, band24=%d\n",
 				rxon_chnum, rxon_band24);
-		spin_unlock_irqrestore(&priv->lock, flags);
+		spin_unlock_irqrestore(&priv->shrd->lock, flags);
 		return;
 	}
 
@@ -1016,7 +1016,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	chain_sig_b = le32_to_cpu(rx_info->beacon_rssi_b) & IN_BAND_FILTER;
 	chain_sig_c = le32_to_cpu(rx_info->beacon_rssi_c) & IN_BAND_FILTER;
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	data->beacon_count++;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 7c3e3ea..7ace507 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1673,9 +1673,9 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 
 	/* FIXME: based on notification, adjust the prio_boost */
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	priv->bt_ci_compliance = coex->bt_ci_compliance;
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 }
 
 void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 6812409..cff6442 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -877,12 +877,12 @@ static void rs_bt_update_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		 * Is there a need to switch between
 		 * full concurrency and 3-wire?
 		 */
-		spin_lock_irqsave(&priv->lock, flags);
+		spin_lock_irqsave(&priv->shrd->lock, flags);
 		if (priv->bt_ci_compliance && priv->bt_ant_couple_ok)
 			full_concurrent = true;
 		else
 			full_concurrent = false;
-		spin_unlock_irqrestore(&priv->lock, flags);
+		spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	}
 	if ((priv->bt_traffic_load != priv->last_bt_traffic_load) ||
 	    (priv->bt_full_concurrent != full_concurrent)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index e74c242..fadfc38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -576,7 +576,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 			goto out;
 		}
 
-		spin_lock_irqsave(&priv->lock, flags);
+		spin_lock_irqsave(&priv->shrd->lock, flags);
 
 		for_each_context(priv, ctx) {
 			/* Configure HT40 channels */
@@ -620,7 +620,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 					       ctx->vif);
 		}
 
-		spin_unlock_irqrestore(&priv->lock, flags);
+		spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 		iwl_update_bcast_stations(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 3e2a904..89d7b30 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -336,7 +336,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (info->control.vif)
 		ctx = iwl_rxon_ctx_from_vif(info->control.vif);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_DROP(priv, "Dropping - RF KILL\n");
 		goto drop_unlock_priv;
@@ -404,7 +404,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	else
 		txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
 
-	/* irqs already disabled/saved above when locking priv->lock */
+	/* irqs already disabled/saved above when locking priv->shrd->lock */
 	spin_lock(&priv->sta_lock);
 
 	if (ieee80211_is_data_qos(fc)) {
@@ -461,7 +461,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	}
 
 	spin_unlock(&priv->sta_lock);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	/*
 	 * Avoid atomic ops if it isn't an associated client.
@@ -478,7 +478,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 drop_unlock_sta:
 	spin_unlock(&priv->sta_lock);
 drop_unlock_priv:
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	return -1;
 }
 
@@ -620,7 +620,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 	/* do not restore/save irqs */
 	spin_unlock(&priv->sta_lock);
-	spin_lock(&priv->lock);
+	spin_lock(&priv->shrd->lock);
 
 	/*
 	 * the only reason this call can fail is queue number out of range,
@@ -630,7 +630,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	 *  mac80211 to clean up it own data.
 	 */
 	trans_txq_agg_disable(&priv->trans, txq_id, ssn, tx_fifo_id);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e77c4c4..6d2c13e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1673,10 +1673,10 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	priv->thermal_throttle.ct_kill_toggle = false;
 
 	if (priv->cfg->base_params->support_ct_kill_exit) {
@@ -3083,7 +3083,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	spin_lock_irq(&priv->lock);
+	spin_lock_irq(&priv->shrd->lock);
 
 	priv->current_ht_config.smps = conf->smps_mode;
 
@@ -3113,7 +3113,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	iwl_set_rxon_ht(priv, ht_conf);
 	iwl_set_flags_for_band(priv, ctx, channel->band, ctx->vif);
 
-	spin_unlock_irq(&priv->lock);
+	spin_unlock_irq(&priv->shrd->lock);
 
 	iwl_set_rate(priv);
 	/*
@@ -3640,7 +3640,7 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 	 * we should init now
 	 */
 	spin_lock_init(&priv->reg_lock);
-	spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->shrd->lock);
 
 	/*
 	 * stop and reset the on-board processor just in case it is in a
@@ -3796,9 +3796,9 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	/* make sure we flush any pending irq or
 	 * tasklet for the driver
 	 */
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	iwl_disable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	trans_sync_irq(&priv->trans);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a5a694d..40ad889 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1186,7 +1186,7 @@ int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	q = AC_NUM - 1 - queue;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 
 	/*
 	 * MULTI-FIXME
@@ -1204,7 +1204,7 @@ int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		ctx->qos_data.def_qos_parm.ac[q].reserved1 = 0;
 	}
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index bf166bc..c60a242 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1226,7 +1226,6 @@ struct iwl_priv {
 	u8 mgmt_tx_ant;
 
 	/* spinlock */
-	spinlock_t lock;	/* protect general shared data */
 	spinlock_t hcmd_lock;	/* protect hcmd */
 	spinlock_t reg_lock;	/* protect hw register access */
 	struct mutex mutex;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 74ff711..1c2c31c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -149,6 +149,7 @@ struct iwl_hw_params {
  * @priv: pointer to the upper layer data
  * @hw_params: see struct iwl_hw_params
  * @workqueue: the workqueue used by all the layers of the driver
+ * @lock: protect general shared data
  */
 struct iwl_shared {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -163,6 +164,7 @@ struct iwl_shared {
 	struct iwl_hw_params hw_params;
 
 	struct workqueue_struct *workqueue;
+	spinlock_t lock;
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 0b79815..26497dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -329,9 +329,9 @@ void iwlagn_rx_replenish(struct iwl_priv *priv)
 
 	iwlagn_rx_allocate(priv, GFP_KERNEL);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	iwlagn_rx_queue_restock(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 }
 
 static void iwlagn_rx_replenish_now(struct iwl_priv *priv)
@@ -499,7 +499,7 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 	u32 inta_mask;
 #endif
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
@@ -525,7 +525,7 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 	}
 #endif
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	/* saved interrupt in inta variable now we can reset priv->inta */
 	priv->inta = 0;
@@ -774,7 +774,7 @@ int iwl_reset_ict(struct iwl_priv *priv)
 	if (!priv->ict_tbl_vir)
 		return 0;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	iwl_disable_interrupts(priv);
 
 	memset(&priv->ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
@@ -794,7 +794,7 @@ int iwl_reset_ict(struct iwl_priv *priv)
 	priv->ict_index = 0;
 	iwl_write32(priv, CSR_INT, priv->inta_mask);
 	iwl_enable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	return 0;
 }
@@ -804,9 +804,9 @@ void iwl_disable_ict(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	priv->use_ict = false;
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 }
 
 static irqreturn_t iwl_isr(int irq, void *data)
@@ -820,7 +820,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	if (!priv)
 		return IRQ_NONE;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 
 	/* Disable (but don't clear!) interrupts here to avoid
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
@@ -864,7 +864,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 		iwl_enable_interrupts(priv);
 
  unplugged:
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	return IRQ_HANDLED;
 
  none:
@@ -873,7 +873,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status) && !priv->inta)
 		iwl_enable_interrupts(priv);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	return IRQ_NONE;
 }
 
@@ -901,7 +901,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	if (!priv->use_ict)
 		return iwl_isr(irq, data);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 
 	/* Disable (but don't clear!) interrupts here to avoid
 	 * back-to-back ISRs and sporadic interrupts from our NIC.
@@ -967,7 +967,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 		iwl_enable_interrupts(priv);
 	}
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	return IRQ_HANDLED;
 
  none:
@@ -977,6 +977,6 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status) && !priv->inta)
 		iwl_enable_interrupts(priv);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	return IRQ_NONE;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index ab42152..61e17dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -444,7 +444,7 @@ void iwl_trans_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 
 	/* Stop this Tx queue before configuring it */
 	iwlagn_tx_queue_stop_scheduler(priv, txq_id);
@@ -480,7 +480,7 @@ void iwl_trans_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl_trans_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 }
 
 int iwl_trans_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index a3e1bd0..cc3fc23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -210,10 +210,10 @@ static int iwl_rx_init(struct iwl_priv *priv)
 
 	iwl_trans_rx_hw_init(priv, rxq);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	rxq->need_update = 1;
 	iwl_rx_queue_update_write_ptr(priv, rxq);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	return 0;
 }
@@ -546,7 +546,7 @@ static int iwl_tx_init(struct iwl_priv *priv)
 		alloc = true;
 	}
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 
 	/* Turn off all Tx DMA fifos */
 	iwl_write_prph(priv, SCD_TXFACT, 0);
@@ -554,7 +554,7 @@ static int iwl_tx_init(struct iwl_priv *priv)
 	/* Tell NIC where to find the "keep warm" buffer */
 	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < hw_params(priv).max_txq_num; txq_id++) {
@@ -598,13 +598,13 @@ static int iwl_nic_init(struct iwl_priv *priv)
 	unsigned long flags;
 
 	/* nic_init */
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	iwl_apm_init(priv);
 
 	/* Set interrupt coalescing calibration timer to default (512 usecs) */
 	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	iwl_set_pwr_vmain(priv);
 
@@ -728,7 +728,7 @@ static int iwl_trans_start_device(struct iwl_priv *priv)
 
 /*
  * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
- * must be called under priv->lock and mac access
+ * must be called under priv->shrd->lock and mac access
  */
 static void iwl_trans_txq_set_sched(struct iwl_priv *priv, u32 mask)
 {
@@ -777,7 +777,7 @@ static void iwl_trans_tx_start(struct iwl_priv *priv)
 	int i, chan;
 	u32 reg_val;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 
 	priv->scd_base_addr = iwl_read_prph(priv, SCD_SRAM_BASE_ADDR);
 	a = priv->scd_base_addr + SCD_CONTEXT_MEM_LOWER_BOUND;
@@ -872,7 +872,7 @@ static void iwl_trans_tx_start(struct iwl_priv *priv)
 		iwl_trans_tx_queue_set_status(priv, &priv->txq[i], fifo, 0);
 	}
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	/* Enable L1-Active */
 	iwl_clear_bits_prph(priv, APMG_PCIDEV_STT_REG,
@@ -888,7 +888,7 @@ static int iwl_trans_tx_stop(struct iwl_priv *priv)
 	unsigned long flags;
 
 	/* Turn off all Tx DMA fifos */
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 
 	iwl_trans_txq_set_sched(priv, 0);
 
@@ -902,7 +902,7 @@ static int iwl_trans_tx_stop(struct iwl_priv *priv)
 			    " DMA channel %d [0x%08x]", ch,
 			    iwl_read_direct32(priv, FH_TSSR_TX_STATUS_REG));
 	}
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	if (!priv->txq) {
 		IWL_WARN(priv, "Stopping tx queues that aren't allocated...");
@@ -924,9 +924,9 @@ static void iwl_trans_stop_device(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->shrd->lock, flags);
 	iwl_disable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	trans_sync_irq(&priv->trans);
 
 	/* device going down, Stop using ICT table */
-- 
1.7.0.4

