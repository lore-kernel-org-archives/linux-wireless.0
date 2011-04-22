Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab1DVRzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:55:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/10] iwlagn: clean up some exit code
Date: Fri, 22 Apr 2011 10:33:10 -0700
Message-Id: <1303493598-10979-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no point in running through iwl_down()
when we never registered with mac80211, as it
just cleans up internal structures that were
never initialised in this case. Therefore we
can also remove the special handling for this
case from __iwl_down().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   26 ++------------------------
 1 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f8559cc..2845f63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2382,20 +2382,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
-	/* If we have not previously called iwl_init() then
-	 * clear all bits but the RF Kill bit and return */
-	if (!iwl_is_init(priv)) {
-		priv->status = test_bit(STATUS_RF_KILL_HW, &priv->status) <<
-					STATUS_RF_KILL_HW |
-			       test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
-					STATUS_GEO_CONFIGURED |
-			       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
-					STATUS_EXIT_PENDING;
-		goto exit;
-	}
-
-	/* ...otherwise clear out all the status bits but the RF Kill
-	 * bit and continue taking the NIC down. */
+	/* Clear out all status bits but a few that are stable across reset */
 	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 				STATUS_RF_KILL_HW |
 			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
@@ -2421,7 +2408,6 @@ static void __iwl_down(struct iwl_priv *priv)
 	/* Stop the device, and put it in low power state */
 	iwl_apm_stop(priv);
 
- exit:
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = NULL;
 
@@ -4072,17 +4058,9 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	if (priv->mac80211_registered) {
 		ieee80211_unregister_hw(priv->hw);
 		priv->mac80211_registered = 0;
-	} else {
-		iwl_down(priv);
 	}
 
-	/*
-	 * Make sure device is reset to low power before unloading driver.
-	 * This may be redundant with iwl_down(), but there are paths to
-	 * run iwl_down() without calling apm_ops.stop(), and there are
-	 * paths to avoid running iwl_down() at all before leaving driver.
-	 * This (inexpensive) call *makes sure* device is reset.
-	 */
+	/* Reset to low power before unloading driver. */
 	iwl_apm_stop(priv);
 
 	iwl_tt_exit(priv);
-- 
1.7.0.4

