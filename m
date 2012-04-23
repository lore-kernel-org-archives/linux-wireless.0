Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab2DWVwy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/29] iwlwifi: provide proper API to disable all interrupts
Date: Mon, 23 Apr 2012 14:47:16 -0700
Message-Id: <1335217660-21950-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235302_137144_B576EE63)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the op_mode may go away, the transport needs to be able to
be told not to update the op_mode at all (even for RF kill).
Provide this API and use it in the proper places.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    3 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   37 +++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   10 ++++---
 4 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 07df432..3024d8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1633,7 +1633,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		goto out_free_traffic_mem;
 	}
 	/* Reset chip to save power until we load uCode during "up". */
-	iwl_trans_stop_hw(priv->trans);
+	iwl_trans_stop_hw(priv->trans, false);
 
 	if (iwl_eeprom_check_version(priv))
 		goto out_free_eeprom;
@@ -1786,6 +1786,7 @@ void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 
 	dev_kfree_skb(priv->beacon_skb);
 
+	iwl_trans_stop_hw(priv->trans, true);
 	ieee80211_free_hw(priv->hw);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 2d7453d..b309ede 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -355,7 +355,7 @@ void iwlagn_mac_stop(struct ieee80211_hw *hw)
 	 * even if interface is down, trans->down will leave the RF
 	 * kill interrupt enabled
 	 */
-	iwl_trans_stop_hw(priv->trans);
+	iwl_trans_stop_hw(priv->trans, false);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 8e1cf97..2a9fb98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1210,6 +1210,8 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	iwl_disable_interrupts(trans);
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
+	iwl_enable_rfkill_int(trans);
+
 	/* wait to make sure we flush pending tasklet*/
 	synchronize_irq(trans_pcie->irq);
 	tasklet_kill(&trans_pcie->irq_tasklet);
@@ -1436,24 +1438,37 @@ error:
 	return err;
 }
 
-static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans)
+static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans,
+				   bool op_mode_leaving)
 {
 	bool hw_rfkill;
+	unsigned long flags;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	iwl_apm_stop(trans);
 
-	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	iwl_disable_interrupts(trans);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
-	/* Even if we stop the HW, we still want the RF kill interrupt */
-	iwl_enable_rfkill_int(trans);
+	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
 
-	/*
-	 * Check again since the RF kill state may have changed while all the
-	 * interrupts were disabled, in this case we couldn't receive the
-	 * RF kill interrupt and update the state in the op_mode.
-	 */
-	hw_rfkill = iwl_is_rfkill_set(trans);
-	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
+	if (!op_mode_leaving) {
+		/*
+		 * Even if we stop the HW, we still want the RF kill
+		 * interrupt
+		 */
+		iwl_enable_rfkill_int(trans);
+
+		/*
+		 * Check again since the RF kill state may have changed while
+		 * all the interrupts were disabled, in this case we couldn't
+		 * receive the RF kill interrupt and update the state in the
+		 * op_mode.
+		 */
+		hw_rfkill = iwl_is_rfkill_set(trans);
+		iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
+	}
 }
 
 static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 885c036..d7c3032 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -335,7 +335,8 @@ struct iwl_trans;
  * @start_hw: starts the HW- from that point on, the HW can send interrupts
  *	May sleep
  * @stop_hw: stops the HW- from that point on, the HW will be in low power but
- *	will still issue interrupt if the HW RF kill is triggered.
+ *	will still issue interrupt if the HW RF kill is triggered unless
+ *	op_mode_leaving is true.
  *	May sleep
  * @start_fw: allocates and inits all the resources for the transport
  *	layer. Also kick a fw image.
@@ -379,7 +380,7 @@ struct iwl_trans;
 struct iwl_trans_ops {
 
 	int (*start_hw)(struct iwl_trans *iwl_trans);
-	void (*stop_hw)(struct iwl_trans *iwl_trans);
+	void (*stop_hw)(struct iwl_trans *iwl_trans, bool op_mode_leaving);
 	int (*start_fw)(struct iwl_trans *trans, const struct fw_img *fw);
 	void (*fw_alive)(struct iwl_trans *trans);
 	void (*stop_device)(struct iwl_trans *trans);
@@ -478,11 +479,12 @@ static inline int iwl_trans_start_hw(struct iwl_trans *trans)
 	return trans->ops->start_hw(trans);
 }
 
-static inline void iwl_trans_stop_hw(struct iwl_trans *trans)
+static inline void iwl_trans_stop_hw(struct iwl_trans *trans,
+				     bool op_mode_leaving)
 {
 	might_sleep();
 
-	trans->ops->stop_hw(trans);
+	trans->ops->stop_hw(trans, op_mode_leaving);
 
 	trans->state = IWL_TRANS_NO_FW;
 }
-- 
1.7.0.4

