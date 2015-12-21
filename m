Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbbLUUwP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:15 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/45] iwlwifi: clear ieee80211_tx_info->driver_data in the op_mode
Date: Mon, 21 Dec 2015 22:50:28 +0200
Message-Id: <1450731046-2796-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220058_969091_7FFA3138)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The transport will need to use the info->driver_data
pointers. Since the op_mode has this memory hot in cache,
clear it there.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c    | 1 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c    | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
index cf0ad5f..59e2001 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -383,6 +383,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 	iwlagn_tx_cmd_build_rate(priv, tx_cmd, info, sta, fc);
 
 	memset(&info->status, 0, sizeof(info->status));
+	memset(info->driver_data, 0, sizeof(info->driver_data));
 
 	info->driver_data[0] = ctx;
 	info->driver_data[1] = dev_cmd;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 6534537..a2683ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -552,7 +552,8 @@ struct iwl_trans_txq_scd_cfg {
  *	If RFkill is asserted in the middle of a SYNC host command, it must
  *	return -ERFKILL straight away.
  *	May sleep only if CMD_ASYNC is not set
- * @tx: send an skb
+ * @tx: send an skb. The transport relies on the op_mode to zero the
+ *	the ieee80211_tx_info->driver_data.
  *	Must be atomic
  * @reclaim: free packet until ssn. Returns a list of freed packets.
  *	Must be atomic
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 04e921f..8bf48a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -346,8 +346,8 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 	iwl_mvm_set_tx_cmd_rate(mvm, tx_cmd, info, sta, hdr->frame_control);
 
 	memset(&info->status, 0, sizeof(info->status));
+	memset(info->driver_data, 0, sizeof(info->driver_data));
 
-	info->driver_data[0] = NULL;
 	info->driver_data[1] = dev_cmd;
 
 	return dev_cmd;
-- 
2.5.0

