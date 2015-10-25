Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbbJYMBl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:41 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/16] iwlwifi: avoid read/write operations if the bus is dead
Date: Sun, 25 Oct 2015 14:01:10 +0200
Message-Id: <1445774476-24792-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130144_748835_C9414706)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Recovery takes too much time if the bus is dead (each timeout
is 2000ms, etc.).
Explicitly skip fw dump in this case, as it will result in
garbage data (and might take signifcant time)

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h    | 2 ++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index bb51b6f..6f76525 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -409,6 +409,7 @@ enum iwl_d3_status {
  * @STATUS_TRANS_GOING_IDLE: shutting down the trans, only special commands
  *	are sent
  * @STATUS_TRANS_IDLE: the trans is idle - general commands are not to be sent
+ * @STATUS_TRANS_DEAD: trans is dead - avoid any read/write operation
  */
 enum iwl_trans_status {
 	STATUS_SYNC_HCMD_ACTIVE,
@@ -419,6 +420,7 @@ enum iwl_trans_status {
 	STATUS_FW_ERROR,
 	STATUS_TRANS_GOING_IDLE,
 	STATUS_TRANS_IDLE,
+	STATUS_TRANS_DEAD,
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5ce29ff..8e69ab2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1137,6 +1137,12 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	/* there's no point in fw dump if the bus is dead */
+	if (test_bit(STATUS_TRANS_DEAD, &mvm->trans->status)) {
+		IWL_ERR(mvm, "Skip fw error dump since bus is dead\n");
+		return;
+	}
+
 	if (mvm->fw_dump_trig &&
 	    mvm->fw_dump_trig->mode & IWL_FW_DBG_TRIGGER_MONITOR_ONLY)
 		monitor_dump_only = true;
-- 
2.1.4

