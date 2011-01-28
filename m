Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab1A1PsE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 10:48:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/8] iwl3945: set STATUS_READY before commit_rxon
Date: Fri, 28 Jan 2011 16:47:45 +0100
Message-Id: <1296229671-3041-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar change as we already do for agn, need to avoid
"Error setting Tx power (-5)" message when loading module.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 9c986f2..55837d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2535,13 +2535,14 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	/* Configure Bluetooth device coexistence support */
 	priv->cfg->ops->hcmd->send_bt_config(priv);
 
+	set_bit(STATUS_READY, &priv->status);
+
 	/* Configure the adapter for unassociated operation */
 	iwl3945_commit_rxon(priv, ctx);
 
 	iwl3945_reg_txpower_periodic(priv);
 
 	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
-	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
 	return;
-- 
1.7.1

