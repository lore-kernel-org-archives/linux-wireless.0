Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59778 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbZBRXuX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:50:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/8] iwl3945: use SW rfkill from iwlwifi
Date: Wed, 18 Feb 2009 15:54:32 -0800
Message-Id: <1235001273-7808-8-git-send-email-reinette.chatre@intel.com> (sfid-20090219_005042_766110_45ACA940)
In-Reply-To: <1235001273-7808-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1235001273-7808-1-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-2-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-3-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-4-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-5-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-6-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch unifies use of SW rfkill between 3945 and agn driver.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   56 ++------------------------
 1 files changed, 5 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 232db2c..6dcc577 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1156,56 +1156,6 @@ drop:
 	return -1;
 }
 
-static void iwl3945_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
-{
-	unsigned long flags;
-
-	if (!!disable_radio == test_bit(STATUS_RF_KILL_SW, &priv->status))
-		return;
-
-	IWL_DEBUG_RF_KILL(priv, "Manual SW RF KILL set to: RADIO %s\n",
-			  disable_radio ? "OFF" : "ON");
-
-	if (disable_radio) {
-		iwl_scan_cancel(priv);
-		/* FIXME: This is a workaround for AP */
-		if (priv->iw_mode != NL80211_IFTYPE_AP) {
-			spin_lock_irqsave(&priv->lock, flags);
-			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
-				    CSR_UCODE_SW_BIT_RFKILL);
-			spin_unlock_irqrestore(&priv->lock, flags);
-			iwl_send_card_state(priv, CARD_STATE_CMD_DISABLE, 0);
-			set_bit(STATUS_RF_KILL_SW, &priv->status);
-		}
-		return;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-
-	clear_bit(STATUS_RF_KILL_SW, &priv->status);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* wake up ucode */
-	msleep(10);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_read32(priv, CSR_UCODE_DRV_GP1);
-	if (!iwl_grab_nic_access(priv))
-		iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
-		IWL_DEBUG_RF_KILL(priv, "Can not turn radio back on - "
-				  "disabled by HW switch\n");
-		return;
-	}
-
-	if (priv->is_open)
-		queue_work(priv->workqueue, &priv->restart);
-	return;
-}
-
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 
 #include "iwl-spectrum.h"
@@ -3879,9 +3829,13 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 	}
 #endif
 
-	iwl3945_radio_kill_sw(priv, !conf->radio_enabled);
+	if (conf->radio_enabled && iwl_radio_kill_sw_enable_radio(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - RF-KILL - waiting for uCode\n");
+		goto out;
+	}
 
 	if (!conf->radio_enabled) {
+		iwl_radio_kill_sw_disable_radio(priv);
 		IWL_DEBUG_MAC80211(priv, "leave - radio disabled\n");
 		goto out;
 	}
-- 
1.5.4.3

