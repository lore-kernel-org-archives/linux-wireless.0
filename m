Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934554Ab1IOTcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/27] iwlagn: do not use interruptible waits
Date: Thu, 15 Sep 2011 11:46:52 -0700
Message-Id: <1316112414-6341-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213218_836133_1147AE08)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

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

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: stable@kernel.org [2.6.24+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |    9 ++-------
 drivers/net/wireless/iwlwifi/iwl-core.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    4 ++--
 5 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 5f8d7b6..b5bae38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -114,13 +114,8 @@ static int iwlagn_load_section(struct iwl_priv *priv, const char *name,
 		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
 	IWL_DEBUG_FW(priv, "%s uCode section being loaded...\n", name);
-	ret = wait_event_interruptible_timeout(priv->shrd->wait_command_queue,
-					priv->ucode_write_complete, 5 * HZ);
-	if (ret == -ERESTARTSYS) {
-		IWL_ERR(priv, "Could not load the %s uCode section due "
-			"to interrupt\n", name);
-		return ret;
-	}
+	ret = wait_event_timeout(priv->shrd->wait_command_queue,
+				 priv->ucode_write_complete, 5 * HZ);
 	if (!ret) {
 		IWL_ERR(priv, "Could not load the %s uCode section\n",
 			name);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ce8a015..cea6520 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -869,7 +869,7 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	 * commands by clearing the ready bit */
 	clear_bit(STATUS_READY, &priv->shrd->status);
 
-	wake_up_interruptible(&priv->shrd->wait_command_queue);
+	wake_up(&priv->shrd->wait_command_queue);
 
 	if (!ondemand) {
 		/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index c7e6a74..2ee6103 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -644,7 +644,7 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
 			test_bit(STATUS_RF_KILL_HW, &priv->shrd->status));
 	else
-		wake_up_interruptible(&priv->shrd->wait_command_queue);
+		wake_up(&priv->shrd->wait_command_queue);
 }
 
 static void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 458a6fb..6f3f07d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -657,7 +657,7 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 		 */
 		clear_bit(STATUS_READY, &trans->shrd->status);
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-		wake_up_interruptible(&priv->shrd->wait_command_queue);
+		wake_up(&priv->shrd->wait_command_queue);
 		IWL_ERR(trans, "RF is used by WiMAX\n");
 		return;
 	}
@@ -1098,7 +1098,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
 		priv(trans)->ucode_write_complete = 1;
-		wake_up_interruptible(&trans->shrd->wait_command_queue);
+		wake_up(&trans->shrd->wait_command_queue);
 	}
 
 	if (inta & ~handled) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index c0def8e..d299cd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -946,7 +946,7 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb)
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
 		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(cmd->hdr.cmd));
-		wake_up_interruptible(&trans->shrd->wait_command_queue);
+		wake_up(&trans->shrd->wait_command_queue);
 	}
 
 	meta->flags = 0;
@@ -1032,7 +1032,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		return ret;
 	}
 
-	ret = wait_event_interruptible_timeout(trans->shrd->wait_command_queue,
+	ret = wait_event_timeout(trans->shrd->wait_command_queue,
 			!test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status),
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
-- 
1.7.0.4

