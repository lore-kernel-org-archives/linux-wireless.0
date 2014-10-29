Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62774 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718AbaJ2LvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:12 -0400
Received: by mail-wg0-f50.google.com with SMTP id z12so1659748wgg.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:11 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/25] iwlwifi: allow to restrict Tx aggregation size per-device
Date: Wed, 29 Oct 2014 13:50:30 +0200
Message-Id: <1414583446-11032-9-git-send-email-egrumbach@gmail.com> (sfid-20141029_125120_135375_3F9A8123)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

A few slave bus devices show better performance when we
reduce the size of the Tx A-MPDU.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-config.h | 2 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c    | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 2ef83a3..76d363d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -246,6 +246,7 @@ struct iwl_pwr_tx_backoff {
  * @nvm_hw_section_num: the ID of the HW NVM section
  * @pwr_tx_backoffs: translation table between power limits and backoffs
  * @max_rx_agg_size: max RX aggregation size of the ADDBA request/response
+ * @max_tx_agg_size: max TX aggregation size of the ADDBA request/response
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -285,6 +286,7 @@ struct iwl_cfg {
 	const char *default_nvm_file;
 	unsigned int max_rx_agg_size;
 	bool disable_dummy_notification;
+	unsigned int max_tx_agg_size;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 047d83d..91b28e8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -403,6 +403,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (cfg->max_rx_agg_size)
 		hw->max_rx_aggregation_subframes = cfg->max_rx_agg_size;
 
+	if (cfg->max_tx_agg_size)
+		hw->max_tx_aggregation_subframes = cfg->max_tx_agg_size;
+
 	op_mode = hw->priv;
 	op_mode->ops = &iwl_mvm_ops;
 
-- 
1.9.1

