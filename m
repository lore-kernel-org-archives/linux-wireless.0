Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758590Ab1FKOzm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/18] iwlagn: use IWL_DEBUG_TEMP for temperature related debug
Date: Sat, 11 Jun 2011 07:25:45 -0700
Message-Id: <1307802352-16398-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165553_714146_88A21A61)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of IWL_DEBUG_POWER, IWL_DEBUG_TEMP should be used for temperature
related debug messages

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c |   38 ++++++++++++++--------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 348f74f..f501d74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -198,7 +198,7 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 		/* Reschedule the ct_kill timer to occur in
 		 * CT_KILL_EXIT_DURATION seconds to ensure we get a
 		 * thermal update */
-		IWL_DEBUG_POWER(priv, "schedule ct_kill exit timer\n");
+		IWL_DEBUG_TEMP(priv, "schedule ct_kill exit timer\n");
 		mod_timer(&priv->thermal_throttle.ct_kill_exit_tm,
 			  jiffies + CT_KILL_EXIT_DURATION * HZ);
 	}
@@ -208,15 +208,15 @@ static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
 			   bool stop)
 {
 	if (stop) {
-		IWL_DEBUG_POWER(priv, "Stop all queues\n");
+		IWL_DEBUG_TEMP(priv, "Stop all queues\n");
 		if (priv->mac80211_registered)
 			ieee80211_stop_queues(priv->hw);
-		IWL_DEBUG_POWER(priv,
+		IWL_DEBUG_TEMP(priv,
 				"Schedule 5 seconds CT_KILL Timer\n");
 		mod_timer(&priv->thermal_throttle.ct_kill_exit_tm,
 			  jiffies + CT_KILL_EXIT_DURATION * HZ);
 	} else {
-		IWL_DEBUG_POWER(priv, "Wake all queues\n");
+		IWL_DEBUG_TEMP(priv, "Wake all queues\n");
 		if (priv->mac80211_registered)
 			ieee80211_wake_queues(priv->hw);
 	}
@@ -232,7 +232,7 @@ static void iwl_tt_ready_for_ct_kill(unsigned long data)
 
 	/* temperature timer expired, ready to go into CT_KILL state */
 	if (tt->state != IWL_TI_CT_KILL) {
-		IWL_DEBUG_POWER(priv, "entering CT_KILL state when "
+		IWL_DEBUG_TEMP(priv, "entering CT_KILL state when "
 				"temperature timer expired\n");
 		tt->state = IWL_TI_CT_KILL;
 		set_bit(STATUS_CT_KILL, &priv->status);
@@ -242,7 +242,7 @@ static void iwl_tt_ready_for_ct_kill(unsigned long data)
 
 static void iwl_prepare_ct_kill_task(struct iwl_priv *priv)
 {
-	IWL_DEBUG_POWER(priv, "Prepare to enter IWL_TI_CT_KILL\n");
+	IWL_DEBUG_TEMP(priv, "Prepare to enter IWL_TI_CT_KILL\n");
 	/* make request to retrieve statistics information */
 	iwl_send_statistics_request(priv, CMD_SYNC, false);
 	/* Reschedule the ct_kill wait timer */
@@ -273,7 +273,7 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 	    (temp > tt->tt_previous_temp) &&
 	    ((temp - tt->tt_previous_temp) >
 	    IWL_TT_INCREASE_MARGIN)) {
-		IWL_DEBUG_POWER(priv,
+		IWL_DEBUG_TEMP(priv,
 			"Temperature increase %d degree Celsius\n",
 			(temp - tt->tt_previous_temp));
 	}
@@ -338,9 +338,9 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 			} else if (old_state == IWL_TI_CT_KILL &&
 				 tt->state != IWL_TI_CT_KILL)
 				iwl_perform_ct_kill_task(priv, false);
-			IWL_DEBUG_POWER(priv, "Temperature state changed %u\n",
+			IWL_DEBUG_TEMP(priv, "Temperature state changed %u\n",
 					tt->state);
-			IWL_DEBUG_POWER(priv, "Power Index change to %u\n",
+			IWL_DEBUG_TEMP(priv, "Power Index change to %u\n",
 					tt->tt_power_mode);
 		}
 		mutex_unlock(&priv->mutex);
@@ -397,7 +397,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 			    (temp > tt->tt_previous_temp) &&
 			    ((temp - tt->tt_previous_temp) >
 			    IWL_TT_INCREASE_MARGIN)) {
-				IWL_DEBUG_POWER(priv,
+				IWL_DEBUG_TEMP(priv,
 					"Temperature increase %d "
 					"degree Celsius\n",
 					(temp - tt->tt_previous_temp));
@@ -467,13 +467,13 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 				set_bit(STATUS_CT_KILL, &priv->status);
 			tt->state = old_state;
 		} else {
-			IWL_DEBUG_POWER(priv,
+			IWL_DEBUG_TEMP(priv,
 					"Thermal Throttling to new state: %u\n",
 					tt->state);
 			if (old_state != IWL_TI_CT_KILL &&
 			    tt->state == IWL_TI_CT_KILL) {
 				if (force) {
-					IWL_DEBUG_POWER(priv,
+					IWL_DEBUG_TEMP(priv,
 						"Enter IWL_TI_CT_KILL\n");
 					set_bit(STATUS_CT_KILL, &priv->status);
 					iwl_perform_ct_kill_task(priv, true);
@@ -483,7 +483,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 				}
 			} else if (old_state == IWL_TI_CT_KILL &&
 				  tt->state != IWL_TI_CT_KILL) {
-				IWL_DEBUG_POWER(priv, "Exit IWL_TI_CT_KILL\n");
+				IWL_DEBUG_TEMP(priv, "Exit IWL_TI_CT_KILL\n");
 				iwl_perform_ct_kill_task(priv, false);
 			}
 		}
@@ -568,7 +568,7 @@ void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	IWL_DEBUG_POWER(priv, "Queueing critical temperature enter.\n");
+	IWL_DEBUG_TEMP(priv, "Queueing critical temperature enter.\n");
 	queue_work(priv->workqueue, &priv->ct_enter);
 }
 
@@ -577,7 +577,7 @@ void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	IWL_DEBUG_POWER(priv, "Queueing critical temperature exit.\n");
+	IWL_DEBUG_TEMP(priv, "Queueing critical temperature exit.\n");
 	queue_work(priv->workqueue, &priv->ct_exit);
 }
 
@@ -603,7 +603,7 @@ void iwl_tt_handler(struct iwl_priv *priv)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	IWL_DEBUG_POWER(priv, "Queueing thermal throttling work.\n");
+	IWL_DEBUG_TEMP(priv, "Queueing thermal throttling work.\n");
 	queue_work(priv->workqueue, &priv->tt_work);
 }
 
@@ -618,7 +618,7 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	int size = sizeof(struct iwl_tt_trans) * (IWL_TI_STATE_MAX - 1);
 	struct iwl_tt_trans *transaction;
 
-	IWL_DEBUG_POWER(priv, "Initialize Thermal Throttling\n");
+	IWL_DEBUG_TEMP(priv, "Initialize Thermal Throttling\n");
 
 	memset(tt, 0, sizeof(struct iwl_tt_mgmt));
 
@@ -638,7 +638,7 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	INIT_WORK(&priv->ct_exit, iwl_bg_ct_exit);
 
 	if (priv->cfg->base_params->adv_thermal_throttle) {
-		IWL_DEBUG_POWER(priv, "Advanced Thermal Throttling\n");
+		IWL_DEBUG_TEMP(priv, "Advanced Thermal Throttling\n");
 		tt->restriction = kzalloc(sizeof(struct iwl_tt_restriction) *
 					 IWL_TI_STATE_MAX, GFP_KERNEL);
 		tt->transaction = kzalloc(sizeof(struct iwl_tt_trans) *
@@ -671,7 +671,7 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 			priv->thermal_throttle.advanced_tt = true;
 		}
 	} else {
-		IWL_DEBUG_POWER(priv, "Legacy Thermal Throttling\n");
+		IWL_DEBUG_TEMP(priv, "Legacy Thermal Throttling\n");
 		priv->thermal_throttle.advanced_tt = false;
 	}
 }
-- 
1.7.0.4

