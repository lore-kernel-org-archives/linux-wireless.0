Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63198 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbaICT5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:16 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so1633285wib.4
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:15 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/36] iwlwifi: mvm: clean up FIFO definitions
Date: Wed,  3 Sep 2014 22:56:19 +0300
Message-Id: <1409774184-24665-31-git-send-email-egrumbach@gmail.com> (sfid-20140903_220114_490397_AAC2652A)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move all FIFO definitions together into the firmware API
header file and use the same enum/naming scheme for the
command FIFO.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 9 ++++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h    | 8 --------
 drivers/net/wireless/iwlwifi/mvm/ops.c    | 2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 4274f8d..94342db 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -84,7 +84,14 @@ enum {
 	IWL_MVM_CMD_QUEUE = 9,
 };
 
-#define IWL_MVM_CMD_FIFO	7
+enum iwl_mvm_tx_fifo {
+	IWL_MVM_TX_FIFO_BK = 0,
+	IWL_MVM_TX_FIFO_BE,
+	IWL_MVM_TX_FIFO_VI,
+	IWL_MVM_TX_FIFO_VO,
+	IWL_MVM_TX_FIFO_MCAST = 5,
+	IWL_MVM_TX_FIFO_CMD = 7,
+};
 
 #define IWL_MVM_STATION_COUNT	16
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 43f5364..b529cf6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -105,14 +105,6 @@
  */
 #define IWL_MVM_CS_UNBLOCK_TX_TIMEOUT 3
 
-enum iwl_mvm_tx_fifo {
-	IWL_MVM_TX_FIFO_BK = 0,
-	IWL_MVM_TX_FIFO_BE,
-	IWL_MVM_TX_FIFO_VI,
-	IWL_MVM_TX_FIFO_VO,
-	IWL_MVM_TX_FIFO_MCAST = 5,
-};
-
 extern const struct ieee80211_ops iwl_mvm_hw_ops;
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 8139adc..d7ec07d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -459,7 +459,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	trans_cfg.command_names = iwl_mvm_cmd_strings;
 
 	trans_cfg.cmd_queue = IWL_MVM_CMD_QUEUE;
-	trans_cfg.cmd_fifo = IWL_MVM_CMD_FIFO;
+	trans_cfg.cmd_fifo = IWL_MVM_TX_FIFO_CMD;
 
 	snprintf(mvm->hw->wiphy->fw_version,
 		 sizeof(mvm->hw->wiphy->fw_version),
-- 
1.9.1

