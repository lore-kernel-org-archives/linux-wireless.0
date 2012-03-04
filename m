Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab2CDUnH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:07 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 057/101] iwlwifi: move ucode_owner to priv
Date: Sun,  4 Mar 2012 11:29:11 -0800
Message-Id: <1330889395-533-58-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214547_458970_1925403F)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The transport doesn't really need to know as
we can enforce it in the command wrapper.
Move the ucode_owner variable into priv and
do all enforcing there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    2 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    4 ----
 drivers/net/wireless/iwlwifi/iwl-testmode.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    6 ------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    1 -
 8 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 90f1f8a..dec2693 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1306,6 +1306,12 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	if (cmd->flags & CMD_SYNC)
 		lockdep_assert_held(&priv->mutex);
 
+	if (priv->ucode_owner == IWL_OWNERSHIP_TM &&
+	    !(cmd->flags & CMD_ON_DEMAND)) {
+		IWL_DEBUG_HC(priv, "tm own the uCode, no regular hcmd send\n");
+		return -EIO;
+	}
+
 	return iwl_trans_send_cmd(trans(priv), cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index f17142b..08de306 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1165,7 +1165,7 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 	iwl_notification_wait_notify(&priv->notif_wait, pkt);
 
 	if (priv->pre_rx_handler &&
-	    priv->shrd->ucode_owner == IWL_OWNERSHIP_TM)
+	    priv->ucode_owner == IWL_OWNERSHIP_TM)
 		priv->pre_rx_handler(priv, rxb);
 	else {
 		/* Based on type of command response or notification,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ce62a2f..afded29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1053,6 +1053,8 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
 	priv->agg_tids_count = 0;
 
+	priv->ucode_owner = IWL_OWNERSHIP_DRIVER;
+
 	/* initialize force reset */
 	priv->force_reset[IWL_RF_RESET].reset_duration =
 		IWL_DELAY_NEXT_FORCE_RF_RESET;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c57e605..a301daf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -748,6 +748,10 @@ struct iwl_priv {
 	struct iwl_spectrum_notification measure_report;
 	u8 measurement_status;
 
+#define IWL_OWNERSHIP_DRIVER	0
+#define IWL_OWNERSHIP_TM	1
+	u8 ucode_owner;
+
 	/* ucode beacon time */
 	u32 ucode_beacon_time;
 	int missed_beacon_threshold;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 1ec5a22..ca090d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -354,7 +354,6 @@ struct iwl_cfg {
 /**
  * struct iwl_shared - shared fields for all the layers of the driver
  *
- * @ucode_owner: IWL_OWNERSHIP_*
  * @cmd_queue: command queue number
  * @status: STATUS_*
  * @wowlan: are we running wowlan uCode
@@ -372,9 +371,6 @@ struct iwl_cfg {
  * @device_pointers: pointers to ucode event tables
  */
 struct iwl_shared {
-#define IWL_OWNERSHIP_DRIVER	0
-#define IWL_OWNERSHIP_TM	1
-	u8 ucode_owner;
 	u8 cmd_queue;
 	unsigned long status;
 	u8 valid_contexts;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index cc049d2..63868df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -770,7 +770,7 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	owner = nla_get_u8(tb[IWL_TM_ATTR_UCODE_OWNER]);
 	if ((owner == IWL_OWNERSHIP_DRIVER) || (owner == IWL_OWNERSHIP_TM))
-		priv->shrd->ucode_owner = owner;
+		priv->ucode_owner = owner;
 	else {
 		IWL_ERR(priv, "Invalid owner\n");
 		return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 9af5c8f..8d13362 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -686,12 +686,6 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
-	if ((trans->shrd->ucode_owner == IWL_OWNERSHIP_TM) &&
-	    !(cmd->flags & CMD_ON_DEMAND)) {
-		IWL_DEBUG_HC(trans, "tm own the uCode, no regular hcmd send\n");
-		return -EIO;
-	}
-
 	copy_size = sizeof(out_cmd->hdr);
 	cmd_size = sizeof(out_cmd->hdr);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 6da9972..7a2e65f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1029,7 +1029,6 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 	bool hw_rfkill;
 
-	trans->shrd->ucode_owner = IWL_OWNERSHIP_DRIVER;
 	trans_pcie->ac_to_queue[IWL_RXON_CTX_BSS] = iwlagn_bss_ac_to_queue;
 	trans_pcie->ac_to_queue[IWL_RXON_CTX_PAN] = iwlagn_pan_ac_to_queue;
 
-- 
1.7.0.4

