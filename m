Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933357Ab1IIMPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Sep 2011 08:15:02 -0400
Subject: [FYI] iwlagn: do not use interruptible waits
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Sep 2011 14:14:56 +0200
Message-ID: <1315570496.17050.7.camel@jlt3.sipsolutions.net> (sfid-20110909_141507_339473_273626F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just submitted the following patch to our internal tree:



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
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |    9 ++-------
 drivers/net/wireless/iwlwifi/iwl-core.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    4 ++--
 5 files changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c	2011-09-09 13:59:41.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c	2011-09-09 14:00:46.000000000 +0200
@@ -114,13 +114,8 @@ static int iwlagn_load_section(struct iw
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
--- a/drivers/net/wireless/iwlwifi/iwl-core.c	2011-09-09 13:59:41.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c	2011-09-09 14:01:12.000000000 +0200
@@ -869,7 +869,7 @@ void iwlagn_fw_error(struct iwl_priv *pr
 	 * commands by clearing the ready bit */
 	clear_bit(STATUS_READY, &priv->shrd->status);
 
-	wake_up_interruptible(&priv->shrd->wait_command_queue);
+	wake_up(&priv->shrd->wait_command_queue);
 
 	if (!ondemand) {
 		/*
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c	2011-09-09 13:59:41.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c	2011-09-09 14:00:30.000000000 +0200
@@ -644,7 +644,7 @@ static void iwl_rx_card_state_notif(stru
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
 			test_bit(STATUS_RF_KILL_HW, &priv->shrd->status));
 	else
-		wake_up_interruptible(&priv->shrd->wait_command_queue);
+		wake_up(&priv->shrd->wait_command_queue);
 }
 
 static void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c	2011-09-09 13:59:41.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c	2011-09-09 14:01:13.000000000 +0200
@@ -657,7 +657,7 @@ static void iwl_irq_handle_error(struct
 		 */
 		clear_bit(STATUS_READY, &trans->shrd->status);
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-		wake_up_interruptible(&priv->shrd->wait_command_queue);
+		wake_up(&priv->shrd->wait_command_queue);
 		IWL_ERR(trans, "RF is used by WiMAX\n");
 		return;
 	}
@@ -1098,7 +1098,7 @@ void iwl_irq_tasklet(struct iwl_trans *t
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
 		priv(trans)->ucode_write_complete = 1;
-		wake_up_interruptible(&trans->shrd->wait_command_queue);
+		wake_up(&trans->shrd->wait_command_queue);
 	}
 
 	if (inta & ~handled) {
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c	2011-09-09 13:59:41.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c	2011-09-09 14:01:07.000000000 +0200
@@ -948,7 +948,7 @@ void iwl_tx_cmd_complete(struct iwl_tran
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
 		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(cmd->hdr.cmd));
-		wake_up_interruptible(&trans->shrd->wait_command_queue);
+		wake_up(&trans->shrd->wait_command_queue);
 	}
 
 	meta->flags = 0;
@@ -1034,7 +1034,7 @@ static int iwl_send_cmd_sync(struct iwl_
 		return ret;
 	}
 
-	ret = wait_event_interruptible_timeout(trans->shrd->wait_command_queue,
+	ret = wait_event_timeout(trans->shrd->wait_command_queue,
 			!test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status),
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {


