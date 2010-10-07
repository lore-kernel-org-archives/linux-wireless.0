Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab0JGXIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/22] iwlwifi: remove spurious exports
Date: Thu,  7 Oct 2010 16:07:48 -0700
Message-Id: <1286492881-15743-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A number of exports, especially related to
thermal throttling, are unnecessary because
the code lives in the same module that it
is used in, so remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c |    5 -----
 drivers/net/wireless/iwlwifi/iwl-core.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-scan.c   |    1 -
 3 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 0c6c4d9..e3a8216 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -571,7 +571,6 @@ void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
 	IWL_DEBUG_POWER(priv, "Queueing critical temperature enter.\n");
 	queue_work(priv->workqueue, &priv->ct_enter);
 }
-EXPORT_SYMBOL(iwl_tt_enter_ct_kill);
 
 void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
 {
@@ -581,7 +580,6 @@ void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
 	IWL_DEBUG_POWER(priv, "Queueing critical temperature exit.\n");
 	queue_work(priv->workqueue, &priv->ct_exit);
 }
-EXPORT_SYMBOL(iwl_tt_exit_ct_kill);
 
 static void iwl_bg_tt_work(struct work_struct *work)
 {
@@ -608,7 +606,6 @@ void iwl_tt_handler(struct iwl_priv *priv)
 	IWL_DEBUG_POWER(priv, "Queueing thermal throttling work.\n");
 	queue_work(priv->workqueue, &priv->tt_work);
 }
-EXPORT_SYMBOL(iwl_tt_handler);
 
 /* Thermal throttling initialization
  * For advance thermal throttling:
@@ -678,7 +675,6 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 		priv->thermal_throttle.advanced_tt = false;
 	}
 }
-EXPORT_SYMBOL(iwl_tt_initialize);
 
 /* cleanup thermal throttling management related memory and timer */
 void iwl_tt_exit(struct iwl_priv *priv)
@@ -701,4 +697,3 @@ void iwl_tt_exit(struct iwl_priv *priv)
 		tt->transaction = NULL;
 	}
 }
-EXPORT_SYMBOL(iwl_tt_exit);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 71f245f..eefcb2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2653,7 +2653,6 @@ int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(iwl_force_reset);
 
 /**
  * iwl_bg_monitor_recover - Timer callback to check for stuck queue and recover
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index a7e8c7f..67da312 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -121,7 +121,6 @@ void iwl_force_scan_end(struct iwl_priv *priv)
 	clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 	iwl_complete_scan(priv, true);
 }
-EXPORT_SYMBOL(iwl_force_scan_end);
 
 static void iwl_do_scan_abort(struct iwl_priv *priv)
 {
-- 
1.7.0.4

