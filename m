Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49643 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763701AbXGaC7K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 22:59:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/7] iwlwifi: fix rate setting in beacon command
Date: Tue, 31 Jul 2007 10:56:31 +0800
Message-Id: <11858505994113-git-send-email-yi.zhu@intel.com>
In-Reply-To: <118585059814-git-send-email-yi.zhu@intel.com>
References: <11858505963374-git-send-email-yi.zhu@intel.com>
 <118585059814-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixed rate setting in beacon command. It removes
invalid <= comparsion on unsinged values.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c |    2 +-
 drivers/net/wireless/iwl-4965.c |   11 ++++++-----
 drivers/net/wireless/iwl-base.c |    6 +++---
 drivers/net/wireless/iwlwifi.h  |    2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index 8a534e1..b71e987 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -2231,7 +2231,7 @@ int iwl_hw_set_hw_setting(struct iwl_priv *priv)
 }
 
 int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
-			  struct iwl_frame *frame, u16 rate)
+			  struct iwl_frame *frame, u8 rate)
 {
 	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
 	int frame_size;
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index cc2dd49..9f4d83a 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -2718,14 +2718,11 @@ int iwl_hw_get_temperature(struct iwl_priv *priv)
 }
 
 int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
-			  struct iwl_frame *frame, u16 rate)
+			  struct iwl_frame *frame, u8 rate)
 {
 	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
 	int frame_size;
 
-	if ((rate == IWL_RATE_1M_PLCP) || (rate >= IWL_RATE_2M_PLCP))
-		rate |= RATE_MCS_CCK_MSK;
-
 	tx_beacon_cmd = &frame->u.beacon;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
@@ -2739,7 +2736,11 @@ int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 
 	tx_beacon_cmd->tx.len = frame_size;
 
-	tx_beacon_cmd->tx.rate.rate_n_flags = rate;
+	if ((rate == IWL_RATE_1M_PLCP) || (rate >= IWL_RATE_2M_PLCP))
+		tx_beacon_cmd->tx.rate.rate_n_flags = rate|RATE_MCS_CCK_MSK;
+	else
+		tx_beacon_cmd->tx.rate.rate_n_flags = rate;
+
 	tx_beacon_cmd->tx.tx_flags = (TX_CMD_FLG_SEQ_CTL_MSK |
 				TX_CMD_FLG_TSF_MSK | TX_CMD_FLG_STA_RATE_MSK);
 	return (sizeof(*tx_beacon_cmd) + frame_size);
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 6e77a51..574d01c 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -1487,7 +1487,7 @@ static int iwl_send_beacon_cmd(struct iwl_priv *priv)
 {
 	struct iwl_frame *frame;
 	int frame_size, rc;
-	u16 rate;
+	u8 rate;
 
 	frame = iwl_get_free_frame(priv);
 
@@ -1500,11 +1500,11 @@ static int iwl_send_beacon_cmd(struct iwl_priv *priv)
 	if (!(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)) {
 		rate = iwl_rate_get_lowest_plcp(priv->active_rate_basic &
 						0xFF0);
-		if (rate <= 0)
+		if (rate == IWL_INVALID_RATE)
 			rate = IWL_RATE_6M_PLCP;
 	} else {
 		rate = iwl_rate_get_lowest_plcp(priv->active_rate_basic & 0xF);
-		if (rate <= 0)
+		if (rate == IWL_INVALID_RATE)
 			rate = IWL_RATE_1M_PLCP;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi.h b/drivers/net/wireless/iwlwifi.h
index 6941031..dff6f6f 100644
--- a/drivers/net/wireless/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi.h
@@ -692,7 +692,7 @@ extern int iwl_tx_queue_free_tfd(struct iwl_priv *priv,
 extern int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 				struct iwl_tx_queue *txq);
 extern int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
-				 struct iwl_frame *frame, u16 rate);
+				 struct iwl_frame *frame, u8 rate);
 extern int iwl_hw_get_rx_read(struct iwl_priv *priv);
 extern void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 				     struct iwl_cmd *cmd,
-- 
1.5.2
