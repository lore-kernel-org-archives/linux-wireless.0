Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23965 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaL3OTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:34 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>, Ido Yariv <idox.yariv@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/33] iwlwifi: mvm: Set the HW step in the core dump
Date: Tue, 30 Dec 2014 16:18:43 +0200
Message-Id: <1419949148-24046-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_151937_661302_1A45AB38)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

The HW step member was left out of the core dump information. Fix this.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index bec588d..2293a51 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -823,6 +823,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000 ?
 			cpu_to_le32(IWL_FW_ERROR_DUMP_FAMILY_7) :
 			cpu_to_le32(IWL_FW_ERROR_DUMP_FAMILY_8);
+	dump_info->hw_step = cpu_to_le32(CSR_HW_REV_STEP(mvm->trans->hw_rev));
 	memcpy(dump_info->fw_human_readable, mvm->fw->human_readable,
 	       sizeof(dump_info->fw_human_readable));
 	strncpy(dump_info->dev_human_readable, mvm->cfg->name,
-- 
1.9.1

