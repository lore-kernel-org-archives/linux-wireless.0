Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19329 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728AbYLKScn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:32:43 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/6] iwlwifi: fix resume while txpower off
Date: Thu, 11 Dec 2008 10:33:37 -0800
Message-Id: <1229020421-4823-3-git-send-email-reinette.chatre@intel.com> (sfid-20081211_193251_729045_1F210006)
In-Reply-To: <1229020421-4823-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1229020421-4823-1-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

This patch take care of coming out rfkill when the driver is up while
rfkill is on by restarting interface.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-core.c |   10 ++++++++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5f99003..c6857dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1406,8 +1406,11 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		 * the driver as well won't allow loading if RFKILL is set
 		 * therefore no need to restart the driver from this handler
 		 */
-		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status))
+		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
 			clear_bit(STATUS_RF_KILL_HW, &priv->status);
+			if (priv->is_open && !iwl_is_rfkill(priv))
+				queue_work(priv->workqueue, &priv->up);
+		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1c0d439..a3b9605 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1447,6 +1447,16 @@ int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv)
 		return 0;
 	}
 
+	/* when driver is up while rfkill is on, it wont receive
+	 * any CARD_STATE_NOTIFICATION notifications so we have to
+	 * restart it in here
+	 */
+	if (priv->is_open && !test_bit(STATUS_ALIVE, &priv->status)) {
+		clear_bit(STATUS_RF_KILL_SW, &priv->status);
+		if (!iwl_is_rfkill(priv))
+			queue_work(priv->workqueue, &priv->up);
+	}
+
 	/* If the driver is already loaded, it will receive
 	 * CARD_STATE_NOTIFICATION notifications and the handler will
 	 * call restart to reload the driver.
-- 
1.5.4.3

