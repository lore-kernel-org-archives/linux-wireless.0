Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab1ITOtg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 10:49:36 -0400
Date: Tue, 20 Sep 2011 16:49:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] iwlegacy: do not use interruptible waits
Message-ID: <20110920144902.GB5358@redhat.com> (sfid-20110920_164940_125145_2636D55F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlegacy version of fix:

commit effd4d9aece9184f526e6556786a94d335e38b71
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Sep 15 11:46:52 2011 -0700

    iwlagn: do not use interruptible waits

    Since the dawn of its time, iwlwifi has used
    interruptible waits to wait for synchronous
    commands and firmware loading.

    This leads to "interesting" bugs, because it
    can't actually handle the interruptions; for
    example when a command sending is interrupted
    it will assume the command completed fully,
    and then leave it pending, which leads to all
    kinds of trouble when the command finishes
    later.

    Since there's no easy way to gracefully deal
    with interruptions, fix the driver to not use
    interruptible waits.

    This at least fixes the error
    iwlagn 0000:02:00.0: Error: Response NULL in  'REPLY_SCAN_ABORT_CMD'

    I have seen in P2P testing, but it is likely
    that there are other errors caused by this.

Cc: stable@kernel.org # 2.6.39+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-core.c     |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-hcmd.c     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    8 ++++----
 drivers/net/wireless/iwlegacy/iwl4965-base.c |   10 +++++-----
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 35cd253..e5971fe 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -937,7 +937,7 @@ void iwl_legacy_irq_handle_error(struct iwl_priv *priv)
 					&priv->contexts[IWL_RXON_CTX_BSS]);
 #endif
 
-	wake_up_interruptible(&priv->wait_command_queue);
+	wake_up(&priv->wait_command_queue);
 
 	/* Keep the restart process from trying to send host
 	 * commands by clearing the INIT status bit */
@@ -1746,7 +1746,7 @@ int iwl_legacy_force_reset(struct iwl_priv *priv, bool external)
 
 	/* Set the FW error flag -- cleared on iwl_down */
 	set_bit(STATUS_FW_ERROR, &priv->status);
-	wake_up_interruptible(&priv->wait_command_queue);
+	wake_up(&priv->wait_command_queue);
 	/*
 	 * Keep the restart process from trying to send host
 	 * commands by clearing the INIT status bit
diff --git a/drivers/net/wireless/iwlegacy/iwl-hcmd.c b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
index 62b4b09..ce1fc9f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
@@ -167,7 +167,7 @@ int iwl_legacy_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		goto out;
 	}
 
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+	ret = wait_event_timeout(priv->wait_command_queue,
 			!test_bit(STATUS_HCMD_ACTIVE, &priv->status),
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index 4b4489f..ef9e268 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -647,7 +647,7 @@ iwl_legacy_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 		IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command %s\n",
 			       iwl_legacy_get_cmd_string(cmd->hdr.cmd));
-		wake_up_interruptible(&priv->wait_command_queue);
+		wake_up(&priv->wait_command_queue);
 	}
 
 	/* Mark as unmapped */
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 015739d..b282d86 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -840,7 +840,7 @@ static void iwl3945_rx_card_state_notif(struct iwl_priv *priv,
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
 				test_bit(STATUS_RF_KILL_HW, &priv->status));
 	else
-		wake_up_interruptible(&priv->wait_command_queue);
+		wake_up(&priv->wait_command_queue);
 }
 
 /**
@@ -2268,7 +2268,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	iwl3945_reg_txpower_periodic(priv);
 
 	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
-	wake_up_interruptible(&priv->wait_command_queue);
+	wake_up(&priv->wait_command_queue);
 
 	return;
 
@@ -2299,7 +2299,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 	iwl_legacy_clear_driver_stations(priv);
 
 	/* Unblock any waiting calls */
-	wake_up_interruptible_all(&priv->wait_command_queue);
+	wake_up_all(&priv->wait_command_queue);
 
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
@@ -2852,7 +2852,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 
 	/* Wait for START_ALIVE from ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+	ret = wait_event_timeout(priv->wait_command_queue,
 			test_bit(STATUS_READY, &priv->status),
 			UCODE_READY_TIMEOUT);
 	if (!ret) {
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 6bc5575..d2fba9e 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -575,7 +575,7 @@ static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
 			test_bit(STATUS_RF_KILL_HW, &priv->status));
 	else
-		wake_up_interruptible(&priv->wait_command_queue);
+		wake_up(&priv->wait_command_queue);
 }
 
 /**
@@ -925,7 +925,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
 		priv->ucode_write_complete = 1;
-		wake_up_interruptible(&priv->wait_command_queue);
+		wake_up(&priv->wait_command_queue);
 	}
 
 	if (inta & ~handled) {
@@ -1794,7 +1794,7 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 	iwl4965_rf_kill_ct_config(priv);
 
 	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
-	wake_up_interruptible(&priv->wait_command_queue);
+	wake_up(&priv->wait_command_queue);
 
 	iwl_legacy_power_update_mode(priv, true);
 	IWL_DEBUG_INFO(priv, "Updated power mode\n");
@@ -1827,7 +1827,7 @@ static void __iwl4965_down(struct iwl_priv *priv)
 	iwl_legacy_clear_driver_stations(priv);
 
 	/* Unblock any waiting calls */
-	wake_up_interruptible_all(&priv->wait_command_queue);
+	wake_up_all(&priv->wait_command_queue);
 
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
@@ -2265,7 +2265,7 @@ int iwl4965_mac_start(struct ieee80211_hw *hw)
 
 	/* Wait for START_ALIVE from Run Time ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+	ret = wait_event_timeout(priv->wait_command_queue,
 			test_bit(STATUS_READY, &priv->status),
 			UCODE_READY_TIMEOUT);
 	if (!ret) {
-- 
1.7.1

