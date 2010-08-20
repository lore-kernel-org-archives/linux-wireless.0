Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab0HTNZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 09:25:09 -0400
Date: Fri, 20 Aug 2010 15:23:47 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH w-t] iwlwifi: fix canceling monitor_recover timer
Message-ID: <20100820132346.GA4725@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make del_timer_sync() works we have to assure that timer function
does not rearm the timer. To achieve that we cancel timer with
STATUS_EXIT_PENDING bit set in __iwl{3945,}_down function.

Patch also fix priv->txq memory usage after free for iwl3945, because
it move timer cancellation before iwl3945_hw_txq_ctx_free(priv) is called.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    7 +++++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3ced9ea..26bc048 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2764,6 +2764,11 @@ static void __iwl_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
+	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
+	 * to prevent rearm timer */
+	if (priv->cfg->ops->lib->recover_from_tx_stall)
+		del_timer_sync(&priv->monitor_recover);
+
 	iwl_clear_ucode_stations(priv);
 	iwl_dealloc_bcast_station(priv);
 	iwl_clear_driver_stations(priv);
@@ -3870,8 +3875,6 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_work_sync(&priv->beacon_update);
 	del_timer_sync(&priv->statistics_periodic);
 	del_timer_sync(&priv->ucode_trace);
-	if (priv->cfg->ops->lib->recover_from_tx_stall)
-		del_timer_sync(&priv->monitor_recover);
 }
 
 static void iwl_init_hw_rates(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 94d7e6e..53e6cbb 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2571,6 +2571,11 @@ static void __iwl3945_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
+	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
+	 * to prevent rearm timer */
+	if (priv->cfg->ops->lib->recover_from_tx_stall)
+		del_timer_sync(&priv->monitor_recover);
+
 	/* Station information will now be cleared in device */
 	iwl_clear_ucode_stations(priv);
 	iwl_dealloc_bcast_station(priv);
@@ -3811,8 +3816,6 @@ static void iwl3945_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_delayed_work(&priv->alive_start);
 	cancel_work_sync(&priv->start_internal_scan);
 	cancel_work_sync(&priv->beacon_update);
-	if (priv->cfg->ops->lib->recover_from_tx_stall)
-		del_timer_sync(&priv->monitor_recover);
 }
 
 static struct attribute *iwl3945_sysfs_entries[] = {
-- 
1.7.1

