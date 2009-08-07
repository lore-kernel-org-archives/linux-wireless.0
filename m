Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1415 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbZHGWl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/16] iwlwifi: fix thermal throttling locking problem
Date: Fri,  7 Aug 2009 15:41:45 -0700
Message-Id: <1249684912-22936-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Move all the thermal throttling functions to background task to make
sure do not change power and rx chain in interrupt handler.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h   |    3 ++
 drivers/net/wireless/iwlwifi/iwl-power.c |   57 +++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 61f9523..35d07a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1197,6 +1197,9 @@ struct iwl_priv {
 	struct work_struct report_work;
 	struct work_struct request_scan;
 	struct work_struct beacon_update;
+	struct work_struct tt_work;
+	struct work_struct ct_enter;
+	struct work_struct ct_exit;
 
 	struct tasklet_struct irq_tasklet;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 594b5c2..9c05af7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -481,6 +481,7 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
 			tt->tt_power_mode = IWL_POWER_INDEX_5;
 			break;
 		}
+		mutex_lock(&priv->mutex);
 		if (iwl_power_update_mode(priv, true)) {
 			/* TT state not updated
 			 * try again during next temperature read
@@ -499,6 +500,7 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
 			IWL_DEBUG_POWER(priv, "Power Index change to %u\n",
 					tt->tt_power_mode);
 		}
+		mutex_unlock(&priv->mutex);
 	}
 }
 
@@ -609,6 +611,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
 			 * in case get disabled before */
 			iwl_set_rxon_ht(priv, &priv->current_ht_config);
 		}
+		mutex_lock(&priv->mutex);
 		if (iwl_power_update_mode(priv, true)) {
 			/* TT state not updated
 			 * try again during next temperature read
@@ -631,6 +634,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
 				iwl_perform_ct_kill_task(priv, false);
 			}
 		}
+		mutex_unlock(&priv->mutex);
 	}
 }
 
@@ -644,13 +648,17 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
  * for advance mode
  * pass CT_KILL_THRESHOLD+1 to make sure move into IWL_TI_CT_KILL state
  */
-void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
+static void iwl_bg_ct_enter(struct work_struct *work)
 {
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_enter);
 	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
+	if (!iwl_is_ready(priv))
+		return;
+
 	if (tt->state != IWL_TI_CT_KILL) {
 		IWL_ERR(priv, "Device reached critical temperature "
 			      "- ucode going to sleep!\n");
@@ -662,20 +670,23 @@ void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
 					       CT_KILL_THRESHOLD + 1);
 	}
 }
-EXPORT_SYMBOL(iwl_tt_enter_ct_kill);
 
 /* Card State Notification indicated out of critical temperature
  * since Card State Notification will not provide any temperature reading
  * so pass the IWL_REDUCED_PERFORMANCE_THRESHOLD_2 temperature
  * to iwl_legacy_tt_handler() to get out of IWL_CT_KILL state
  */
-void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
+static void iwl_bg_ct_exit(struct work_struct *work)
 {
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_exit);
 	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
+	if (!iwl_is_ready(priv))
+		return;
+
 	/* stop ct_kill_exit_tm timer */
 	del_timer_sync(&priv->power_data.ct_kill_exit_tm);
 
@@ -690,10 +701,30 @@ void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
 			iwl_advance_tt_handler(priv, CT_KILL_EXIT_THRESHOLD);
 	}
 }
+
+void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	IWL_DEBUG_POWER(priv, "Queueing critical temperature enter.\n");
+	queue_work(priv->workqueue, &priv->ct_enter);
+}
+EXPORT_SYMBOL(iwl_tt_enter_ct_kill);
+
+void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	IWL_DEBUG_POWER(priv, "Queueing critical temperature exit.\n");
+	queue_work(priv->workqueue, &priv->ct_exit);
+}
 EXPORT_SYMBOL(iwl_tt_exit_ct_kill);
 
-void iwl_tt_handler(struct iwl_priv *priv)
+static void iwl_bg_tt_work(struct work_struct *work)
 {
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, tt_work);
 	s32 temp = priv->temperature; /* degrees CELSIUS except 4965 */
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
@@ -707,6 +738,15 @@ void iwl_tt_handler(struct iwl_priv *priv)
 	else
 		iwl_advance_tt_handler(priv, temp);
 }
+
+void iwl_tt_handler(struct iwl_priv *priv)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	IWL_DEBUG_POWER(priv, "Queueing thermal throttling work.\n");
+	queue_work(priv->workqueue, &priv->tt_work);
+}
 EXPORT_SYMBOL(iwl_tt_handler);
 
 /* Thermal throttling initialization
@@ -731,6 +771,12 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	init_timer(&priv->power_data.ct_kill_exit_tm);
 	priv->power_data.ct_kill_exit_tm.data = (unsigned long)priv;
 	priv->power_data.ct_kill_exit_tm.function = iwl_tt_check_exit_ct_kill;
+
+	/* setup deferred ct kill work */
+	INIT_WORK(&priv->tt_work, iwl_bg_tt_work);
+	INIT_WORK(&priv->ct_enter, iwl_bg_ct_enter);
+	INIT_WORK(&priv->ct_exit, iwl_bg_ct_exit);
+
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
 	case CSR_HW_REV_TYPE_6x00:
 	case CSR_HW_REV_TYPE_6x50:
@@ -782,6 +828,9 @@ void iwl_tt_exit(struct iwl_priv *priv)
 
 	/* stop ct_kill_exit_tm timer if activated */
 	del_timer_sync(&priv->power_data.ct_kill_exit_tm);
+	cancel_work_sync(&priv->tt_work);
+	cancel_work_sync(&priv->ct_enter);
+	cancel_work_sync(&priv->ct_exit);
 
 	if (priv->power_data.adv_tt) {
 		/* free advance thermal throttling memory */
-- 
1.5.6.3

