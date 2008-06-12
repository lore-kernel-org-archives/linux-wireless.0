Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8439 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbYFLBuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:50:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 29/29] iwlwifi: remove iwlcore_low_level_notify
Date: Thu, 12 Jun 2008 09:47:19 +0800
Message-Id: <1213235239-2954-30-git-send-email-yi.zhu@intel.com> (sfid-20080612_041915_137328_4C02394B)
In-Reply-To: <1213235239-2954-29-git-send-email-yi.zhu@intel.com>
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
 <1213235239-2954-29-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch removes the iwlcore_low_level_notify. The
notification chain is not required in this level.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   31 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    9 -------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   14 ++++++------
 3 files changed, 7 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8096463..fa17cd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -965,37 +965,6 @@ void iwl_uninit_drv(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_uninit_drv);
 
-
-
-/* Low level driver call this function to update iwlcore with
- * driver status.
- */
-int iwlcore_low_level_notify(struct iwl_priv *priv,
-			      enum iwlcore_card_notify notify)
-{
-	int ret;
-	switch (notify) {
-	case IWLCORE_INIT_EVT:
-		ret = iwl_rfkill_init(priv);
-		if (ret)
-			IWL_ERROR("Unable to initialize RFKILL system. "
-				  "Ignoring error: %d\n", ret);
-		iwl_power_initialize(priv);
-		break;
-	case IWLCORE_START_EVT:
-		iwl_power_update_mode(priv, 1);
-		break;
-	case IWLCORE_STOP_EVT:
-		break;
-	case IWLCORE_REMOVE_EVT:
-		iwl_rfkill_unregister(priv);
-		break;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(iwlcore_low_level_notify);
-
 int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags)
 {
 	u32 stat_flags = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 054ab7c..6626665 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -359,15 +359,6 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 	return iwl_is_ready(priv);
 }
 
-enum iwlcore_card_notify {
-	IWLCORE_INIT_EVT = 0,
-	IWLCORE_START_EVT = 1,
-	IWLCORE_STOP_EVT = 2,
-	IWLCORE_REMOVE_EVT = 3,
-};
-
-int iwlcore_low_level_notify(struct iwl_priv *priv,
-			     enum iwlcore_card_notify notify);
 extern int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags);
 extern int iwl_verify_ucode(struct iwl_priv *priv);
 extern void iwl_rf_kill_ct_config(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5aec7d5..81a1c22 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2271,7 +2271,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	if (priv->error_recovering)
 		iwl4965_error_recovery(priv);
 
-	iwlcore_low_level_notify(priv, IWLCORE_START_EVT);
+	iwl_power_update_mode(priv, 1);
 	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 
 	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
@@ -2297,8 +2297,6 @@ static void __iwl4965_down(struct iwl_priv *priv)
 
 	iwl_leds_unregister(priv);
 
-	iwlcore_low_level_notify(priv, IWLCORE_STOP_EVT);
-
 	iwlcore_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
@@ -4460,8 +4458,11 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	if (err)
 		IWL_ERROR("failed to create debugfs files\n");
 
-	/* notify iwlcore to init */
-	iwlcore_low_level_notify(priv, IWLCORE_INIT_EVT);
+	err = iwl_rfkill_init(priv);
+	if (err)
+		IWL_ERROR("Unable to initialize RFKILL system. "
+				  "Ignoring error: %d\n", err);
+	iwl_power_initialize(priv);
 	return 0;
 
  out_remove_sysfs:
@@ -4524,8 +4525,7 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 		}
 	}
 
-	iwlcore_low_level_notify(priv, IWLCORE_REMOVE_EVT);
-
+	iwl_rfkill_unregister(priv);
 	iwl4965_dealloc_ucode_pci(priv);
 
 	if (priv->rxq.bd)
-- 
1.5.3.6

