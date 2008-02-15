Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14029 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763248AbYBOWf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 17:35:28 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: fix name of function in comment (_rx_card_state_notif)
Date: Fri, 15 Feb 2008 14:34:37 -0800
Message-Id: <1203114877-16101-1-git-send-email-reinette.chatre@intel.com> (sfid-20080215_223603_021722_B01E6853)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl_rx_card_state_notif is named iwl3945_rx_card_state_notif and
iwl4965_rx_card_state_notif in the two iwlwifi drivers.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
This change was originally in the "cleanup namespace" patch from Christoph
Hellwig. The change was still in wireless-2.6#everything last week, but not
in the recently created wireless-testing repo.

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4ad26f7..e9757a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4777,7 +4777,7 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 		/* Queue restart only if RF_KILL switch was set to "kill"
 		 *   when we loaded driver, and is now set to "enable".
 		 * After we're Alive, RF_KILL gets handled by
-		 *   iwl_rx_card_state_notif() */
+		 *   iwl3945_rx_card_state_notif() */
 		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
 			clear_bit(STATUS_RF_KILL_HW, &priv->status);
 			queue_work(priv->workqueue, &priv->restart);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f893199..5cf6cdd 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5149,7 +5149,7 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 		/* Queue restart only if RF_KILL switch was set to "kill"
 		 *   when we loaded driver, and is now set to "enable".
 		 * After we're Alive, RF_KILL gets handled by
-		 *   iwl_rx_card_state_notif() */
+		 *   iwl4965_rx_card_state_notif() */
 		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
 			clear_bit(STATUS_RF_KILL_HW, &priv->status);
 			queue_work(priv->workqueue, &priv->restart);
-- 
1.5.3.4

