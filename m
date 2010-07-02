Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:25946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759159Ab0GBSoe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:44:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/8] iwlwifi: fix fw_restart module parameter
Date: Fri,  2 Jul 2010 11:45:33 -0700
Message-Id: <1278096340-2546-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

fw_restart module parameter was broken by the recent check for stuck
queue patch, driver check the fx_restart module parameter
before reload the firmware; but the stuck queue timer kick in after
firmware error and reload the firmware even fw_restart=0. In this case,
driver should not reload the firmware, it is important to help debugging
uCode error.

The only case we can ignore the module parameter is when user request
firmware reload from debugfs, which can bypass the checking and perform
firmware reload all the time.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c    |   31 ++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    4 +-
 4 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a56fb46..f73eb08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2627,7 +2627,7 @@ static void iwl_force_rf_reset(struct iwl_priv *priv)
 }
 
 
-int iwl_force_reset(struct iwl_priv *priv, int mode)
+int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
 {
 	struct iwl_force_reset *force_reset;
 
@@ -2640,12 +2640,14 @@ int iwl_force_reset(struct iwl_priv *priv, int mode)
 	}
 	force_reset = &priv->force_reset[mode];
 	force_reset->reset_request_count++;
-	if (force_reset->last_force_reset_jiffies &&
-	    time_after(force_reset->last_force_reset_jiffies +
-	    force_reset->reset_duration, jiffies)) {
-		IWL_DEBUG_INFO(priv, "force reset rejected\n");
-		force_reset->reset_reject_count++;
-		return -EAGAIN;
+	if (!external) {
+		if (force_reset->last_force_reset_jiffies &&
+		    time_after(force_reset->last_force_reset_jiffies +
+		    force_reset->reset_duration, jiffies)) {
+			IWL_DEBUG_INFO(priv, "force reset rejected\n");
+			force_reset->reset_reject_count++;
+			return -EAGAIN;
+		}
 	}
 	force_reset->reset_success_count++;
 	force_reset->last_force_reset_jiffies = jiffies;
@@ -2655,6 +2657,19 @@ int iwl_force_reset(struct iwl_priv *priv, int mode)
 		iwl_force_rf_reset(priv);
 		break;
 	case IWL_FW_RESET:
+		/*
+		 * if the request is from external(ex: debugfs),
+		 * then always perform the request in regardless the module
+		 * parameter setting
+		 * if the request is from internal (uCode error or driver
+		 * detect failure), then fw_restart module parameter
+		 * need to be check before performing firmware reload
+		 */
+		if (!external && !priv->cfg->mod_params->restart_fw) {
+			IWL_DEBUG_INFO(priv, "Cancel firmware reload based on "
+				       "module parameter setting\n");
+			break;
+		}
 		IWL_ERR(priv, "On demand firmware reload\n");
 		/* Set the FW error flag -- cleared on iwl_down */
 		set_bit(STATUS_FW_ERROR, &priv->status);
@@ -2713,7 +2728,7 @@ static int iwl_check_stuck_queue(struct iwl_priv *priv, int cnt)
 					"queue %d stuck %d time. Fw reload.\n",
 					q->id, q->repeat_same_read_ptr);
 				q->repeat_same_read_ptr = 0;
-				iwl_force_reset(priv, IWL_FW_RESET);
+				iwl_force_reset(priv, IWL_FW_RESET, false);
 			} else {
 				q->repeat_same_read_ptr++;
 				IWL_DEBUG_RADIO(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 15930e0..bfa3456 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -525,7 +525,7 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		    struct cfg80211_scan_request *req);
 void iwl_bg_start_internal_scan(struct work_struct *work);
 void iwl_internal_short_hw_scan(struct iwl_priv *priv);
-int iwl_force_reset(struct iwl_priv *priv, int mode);
+int iwl_force_reset(struct iwl_priv *priv, int mode, bool external);
 u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 		       const u8 *ta, const u8 *ie, int ie_len, int left);
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 7d9ffc1..48f8908 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1487,7 +1487,7 @@ static ssize_t iwl_dbgfs_force_reset_write(struct file *file,
 	switch (reset) {
 	case IWL_RF_RESET:
 	case IWL_FW_RESET:
-		ret = iwl_force_reset(priv, reset);
+		ret = iwl_force_reset(priv, reset, true);
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b437f31..79773e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -238,7 +238,7 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
 				 */
 				IWL_ERR(priv, "low ack count detected, "
 					"restart firmware\n");
-				if (!iwl_force_reset(priv, IWL_FW_RESET))
+				if (!iwl_force_reset(priv, IWL_FW_RESET, false))
 					return;
 			}
 		}
@@ -249,7 +249,7 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
 				 * high plcp error detected
 				 * reset Radio
 				 */
-				iwl_force_reset(priv, IWL_RF_RESET);
+				iwl_force_reset(priv, IWL_RF_RESET, false);
 			}
 		}
 	}
-- 
1.7.0.4

