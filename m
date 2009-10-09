Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761358AbZJIUWa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:22:30 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/17] iwl3945: streamline iwl3945_rfkill_poll()
Date: Fri,  9 Oct 2009 13:20:26 -0700
Message-Id: <1255119634-3060-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

iwl3945_rfkill_poll() has been silently calling wiphy_rfkill_set_hw_state()
every 2 seconds, regardless of whether hardware RF KILL switch changed state.

Call wiphy_rfkill_set_hw_state() only when RFKILL switch changes.
Add IWL_DEBUG_RF_KILL log message and documentation.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ab4c4ba..2406b73 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2717,19 +2717,34 @@ static void iwl3945_bg_alive_start(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
+/*
+ * 3945 cannot interrupt driver when hardware rf kill switch toggles;
+ * driver must poll CSR_GP_CNTRL_REG register for change.  This register
+ * *is* readable even when device has been SW_RESET into low power mode
+ * (e.g. during RF KILL).
+ */
 static void iwl3945_rfkill_poll(struct work_struct *data)
 {
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, rfkill_poll.work);
+	bool old_rfkill = test_bit(STATUS_RF_KILL_HW, &priv->status);
+	bool new_rfkill = !(iwl_read32(priv, CSR_GP_CNTRL)
+			& CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
 
-	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &priv->status);
-	else
-		set_bit(STATUS_RF_KILL_HW, &priv->status);
+	if (new_rfkill != old_rfkill) {
+		if (new_rfkill)
+			set_bit(STATUS_RF_KILL_HW, &priv->status);
+		else
+			clear_bit(STATUS_RF_KILL_HW, &priv->status);
 
-	wiphy_rfkill_set_hw_state(priv->hw->wiphy,
-			test_bit(STATUS_RF_KILL_HW, &priv->status));
+		wiphy_rfkill_set_hw_state(priv->hw->wiphy, new_rfkill);
+
+		IWL_DEBUG_RF_KILL(priv, "RF_KILL bit toggled to %s.\n",
+				new_rfkill ? "disable radio" : "enable radio");
+	}
 
+	/* Keep this running, even if radio now enabled.  This will be
+	 * cancelled in mac_start() if system decides to start again */
 	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
 			   round_jiffies_relative(2 * HZ));
 
-- 
1.5.6.3

