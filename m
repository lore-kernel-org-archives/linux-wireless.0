Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965119Ab2CEUiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 17/33] iwlwifi: clean up (wowlan) suspend flow
Date: Mon,  5 Mar 2012 11:24:35 -0800
Message-Id: <1330975491-19680-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213844_672769_2489162B)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the WoWLAN suspend flow, instead of accessing
registers directly, ask the transport to do the
required setup at the end of suspend. If the
transport doesn't implement this, don't tell the
stack we support WoWLAN.

When the device suspends w/o WoWLAN, mac80211
will have stopped it already, which has already
called iwl_apm_stop() via stop_hw(). Thus, it
isn't necessary to call it again in pcie_suspend
and we can simply do nothing there.

This unifies the regular and WoWLAN suspend.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c   |    5 +--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   32 ++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   11 ++++++++
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 8b26f32..8c7ca73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -196,6 +196,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_IBSS_RSN;
 
 	if (nic(priv)->fw.ucode_wowlan.code.len &&
+	    trans(priv)->ops->wowlan_suspend &&
 	    device_can_wakeup(trans(priv)->dev)) {
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 					  WIPHY_WOWLAN_DISCONNECT |
@@ -412,9 +413,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 
 	device_set_wakeup_enable(trans(priv)->dev, true);
 
-	/* Now let the ucode operate on its own */
-	iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_SET,
-			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
+	iwl_trans_wowlan_suspend(trans(priv));
 
 	goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index f47426a..bb8f2fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1303,6 +1303,17 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 }
 
+static void iwl_trans_pcie_wowlan_suspend(struct iwl_trans *trans)
+{
+	/* let the ucode operate on its own */
+	iwl_write32(trans, CSR_UCODE_DRV_GP1_SET,
+		    CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
+
+	iwl_disable_interrupts(trans);
+	iwl_clear_bit(trans, CSR_GP_CNTRL,
+		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+}
+
 static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
 		u8 sta_id, u8 tid)
@@ -1641,25 +1652,6 @@ static void iwl_trans_pcie_free(struct iwl_trans *trans)
 #ifdef CONFIG_PM_SLEEP
 static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
 {
-	/*
-	 * This function is called when system goes into suspend state
-	 * mac80211 will call iwlagn_mac_stop() from the mac80211 suspend
-	 * function first but since iwlagn_mac_stop() has no knowledge of
-	 * who the caller is,
-	 * it will not call apm_ops.stop() to stop the DMA operation.
-	 * Calling apm_ops.stop here to make sure we stop the DMA.
-	 *
-	 * But of course ... if we have configured WoWLAN then we did other
-	 * things already :-)
-	 */
-	if (!trans->shrd->wowlan) {
-		iwl_apm_stop(trans);
-	} else {
-		iwl_disable_interrupts(trans);
-		iwl_clear_bit(trans, CSR_GP_CNTRL,
-			      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-	}
-
 	return 0;
 }
 
@@ -2227,6 +2219,8 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.start_fw = iwl_trans_pcie_start_fw,
 	.stop_device = iwl_trans_pcie_stop_device,
 
+	.wowlan_suspend = iwl_trans_pcie_wowlan_suspend,
+
 	.wake_any_queue = iwl_trans_pcie_wake_any_queue,
 
 	.send_cmd = iwl_trans_pcie_send_cmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index e2f21cf..83f04c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -210,6 +210,9 @@ struct iwl_host_cmd {
  * @wake_any_queue: wake all the queues of a specfic context IWL_RXON_CTX_*
  * @stop_device:stops the whole device (embedded CPU put to reset)
  *	May sleep
+ * @wowlan_suspend: put the device into the correct mode for WoWLAN during
+ *	suspend. This is optional, if not implemented WoWLAN will not be
+ *	supported. This callback may sleep.
  * @send_cmd:send a host command
  *	May sleep only if CMD_SYNC is set
  * @tx: send an skb
@@ -247,6 +250,8 @@ struct iwl_trans_ops {
 	void (*fw_alive)(struct iwl_trans *trans);
 	void (*stop_device)(struct iwl_trans *trans);
 
+	void (*wowlan_suspend)(struct iwl_trans *trans);
+
 	void (*wake_any_queue)(struct iwl_trans *trans,
 			       enum iwl_rxon_context_id ctx,
 			       const char *msg);
@@ -396,6 +401,12 @@ static inline void iwl_trans_stop_device(struct iwl_trans *trans)
 	trans->state = IWL_TRANS_NO_FW;
 }
 
+static inline void iwl_trans_wowlan_suspend(struct iwl_trans *trans)
+{
+	might_sleep();
+	trans->ops->wowlan_suspend(trans);
+}
+
 static inline void iwl_trans_wake_any_queue(struct iwl_trans *trans,
 					    enum iwl_rxon_context_id ctx,
 					    const char *msg)
-- 
1.7.0.4

