Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab0HRQSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/16] iwlwifi: remove unused iwl_send_card_state function
Date: Wed, 18 Aug 2010 09:22:49 -0700
Message-Id: <1282148571-9258-15-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl_send_card_state() is not being call from anywhere, remove it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   22 ----------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 --
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e6497c6..3d9443b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1470,28 +1470,6 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 }
 EXPORT_SYMBOL(iwl_send_statistics_request);
 
-/*
- * CARD_STATE_CMD
- *
- * Use: Sets the device's internal card state to enable, disable, or halt
- *
- * When in the 'enable' state the card operates as normal.
- * When in the 'disable' state, the card enters into a low power mode.
- * When in the 'halt' state, the card is shut down and must be fully
- * restarted to come back on.
- */
-int iwl_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
-{
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_CARD_STATE_CMD,
-		.len = sizeof(u32),
-		.data = &flags,
-		.flags = meta_flag,
-	};
-
-	return iwl_send_cmd(priv, &cmd);
-}
-
 void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 			   struct iwl_rx_mem_buffer *rxb)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6bd6013..7b1e832 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -592,8 +592,6 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 
 int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
-int iwl_send_card_state(struct iwl_priv *priv, u32 flags,
-			u8 meta_flag);
 
 /*****************************************************
  * PCI						     *
-- 
1.7.0.4

