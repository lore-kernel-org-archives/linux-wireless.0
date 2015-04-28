Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:28156 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965506AbbD1MnU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 08:43:20 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/8] iwlwifi: mvm: don't stop the FW monitor too early
Date: Tue, 28 Apr 2015 15:43:06 +0300
Message-Id: <1430224992-20327-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150428_144324_311702_35BDBB62)
In-Reply-To: <1430224907.4748.3.camel@intel.com>
References: <1430224907.4748.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the delay paramatere is provided, we need to stop
the collection only after the delay has elapsed.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c  |  9 ---------
 drivers/net/wireless/iwlwifi/mvm/ops.c | 10 ++++++++++
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index bc5eac4..9c28fe7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -494,15 +494,6 @@ int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
 
 	mvm->fw_dump_desc = desc;
 
-	/* stop recording */
-	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
-		iwl_set_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x100);
-	} else {
-		iwl_write_prph(mvm->trans, DBGC_IN_SAMPLE, 0);
-		/* wait before we collect the data till the DBGC stop */
-		udelay(100);
-	}
-
 	queue_delayed_work(system_wq, &mvm->fw_dump_wk, delay);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a08b03d..1c66297 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -865,6 +865,16 @@ static void iwl_mvm_fw_error_dump_wk(struct work_struct *work)
 		return;
 
 	mutex_lock(&mvm->mutex);
+
+	/* stop recording */
+	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
+		iwl_set_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x100);
+	} else {
+		iwl_write_prph(mvm->trans, DBGC_IN_SAMPLE, 0);
+		/* wait before we collect the data till the DBGC stop */
+		udelay(100);
+	}
+
 	iwl_mvm_fw_error_dump(mvm);
 
 	/* start recording again if the firmware is not crashed */
-- 
2.1.0

