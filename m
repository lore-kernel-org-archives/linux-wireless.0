Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1GUP0p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.guy@intel.com>
Subject: [PATCH 02/25] iwlagn: kill iwlagn_rx_handler_setup
Date: Thu, 21 Jul 2011 07:50:05 -0700
Message-Id: <1311259828-8415-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172653_164122_211A5D5A)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since iwlagn_rx_handler_setup is always called, fold it into
iwl_rx_handler_setup. BT related handlers are setup by the new
bt_rx_handler_setup lib_ops.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c    |    3 +--
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    3 +--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   17 +----------------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-rx.c      |   16 ++++++++++++++--
 8 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index fe15a46..5fa1719 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -168,7 +168,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 
 static struct iwl_lib_ops iwl1000_lib = {
 	.set_hw_params = iwl1000_hw_set_hw_params,
-	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.nic_config = iwl1000_nic_config,
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 7e0f766..c913410 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -167,7 +167,6 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 
 static struct iwl_lib_ops iwl2000_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
-	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.nic_config = iwl2000_nic_config,
 	.eeprom_ops = {
@@ -187,7 +186,7 @@ static struct iwl_lib_ops iwl2000_lib = {
 
 static struct iwl_lib_ops iwl2030_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
-	.rx_handler_setup = iwlagn_bt_rx_handler_setup,
+	.bt_rx_handler_setup = iwlagn_bt_rx_handler_setup,
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.nic_config = iwl2000_nic_config,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e090878..4e1204a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -320,7 +320,6 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 
 static struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
-	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.nic_config = iwl5000_nic_config,
@@ -340,7 +339,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 
 static struct iwl_lib_ops iwl5150_lib = {
 	.set_hw_params = iwl5150_hw_set_hw_params,
-	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.nic_config = iwl5000_nic_config,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 3b2d753..f1fdcdc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -258,7 +258,6 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 
 static struct iwl_lib_ops iwl6000_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
-	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.nic_config = iwl6000_nic_config,
@@ -279,7 +278,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 
 static struct iwl_lib_ops iwl6030_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
-	.rx_handler_setup = iwlagn_bt_rx_handler_setup,
+	.bt_rx_handler_setup = iwlagn_bt_rx_handler_setup,
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.set_channel_switch = iwl6000_hw_channel_switch,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e06a5c2..5d6258d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -391,8 +391,7 @@ void iwl_check_abort_status(struct iwl_priv *priv,
 	}
 }
 
-static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
+void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -479,19 +478,6 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
-void iwlagn_rx_handler_setup(struct iwl_priv *priv)
-{
-	/* init calibration handlers */
-	priv->rx_handlers[CALIBRATION_RES_NOTIFICATION] =
-					iwlagn_rx_calib_result;
-	priv->rx_handlers[REPLY_TX] = iwlagn_rx_reply_tx;
-
-	/* set up notification wait support */
-	spin_lock_init(&priv->_agn.notif_wait_lock);
-	INIT_LIST_HEAD(&priv->_agn.notif_waits);
-	init_waitqueue_head(&priv->_agn.notif_waitq);
-}
-
 void iwlagn_setup_deferred_work(struct iwl_priv *priv)
 {
 	/*
@@ -1762,7 +1748,6 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 
 void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv)
 {
-	iwlagn_rx_handler_setup(priv);
 	priv->rx_handlers[REPLY_BT_COEX_PROFILE_NOTIF] =
 		iwlagn_bt_coex_profile_notif;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 0e8ccb9..d9fef63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -162,7 +162,6 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 /* lib */
 void iwl_check_abort_status(struct iwl_priv *priv,
 			    u8 frame_count, u32 status);
-void iwlagn_rx_handler_setup(struct iwl_priv *priv);
 void iwlagn_setup_deferred_work(struct iwl_priv *priv);
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 int iwlagn_send_tx_power(struct iwl_priv *priv);
@@ -197,6 +196,7 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			   int sta_id, u8 tid, int txq_id);
 void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
+void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 
 static inline u32 iwl_tx_status_to_mac80211(u32 status)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index c10ced5..6f825d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -83,8 +83,8 @@ struct iwl_cmd;
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
-	/* setup Rx handler */
-	void (*rx_handler_setup)(struct iwl_priv *priv);
+	/* setup BT Rx handler */
+	void (*bt_rx_handler_setup)(struct iwl_priv *priv);
 	/* setup deferred work */
 	void (*setup_deferred_work)(struct iwl_priv *priv);
 	/* cancel deferred work */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 05fd75f..f67931d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -966,8 +966,20 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	/* block ack */
 	handlers[REPLY_COMPRESSED_BA]		= iwlagn_rx_reply_compressed_ba;
 
-	/* Set up hardware specific Rx handlers */
-	priv->cfg->lib->rx_handler_setup(priv);
+	/* init calibration handlers */
+	priv->rx_handlers[CALIBRATION_RES_NOTIFICATION] =
+					iwlagn_rx_calib_result;
+	priv->rx_handlers[REPLY_TX] = iwlagn_rx_reply_tx;
+
+	/* set up notification wait support */
+	spin_lock_init(&priv->_agn.notif_wait_lock);
+	INIT_LIST_HEAD(&priv->_agn.notif_waits);
+	init_waitqueue_head(&priv->_agn.notif_waitq);
+
+	/* Set up BT Rx handlers */
+	if (priv->cfg->lib->bt_rx_handler_setup)
+		priv->cfg->lib->bt_rx_handler_setup(priv);
+
 }
 
 void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
-- 
1.7.0.4

