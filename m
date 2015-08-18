Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25231 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbbHRH5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:57:52 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Dor Shaish <dor.shaish@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/26] iwlwifi: mvm: print secboot status registers on alive timeout
Date: Tue, 18 Aug 2015 10:57:12 +0300
Message-Id: <1439884656-18146-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_095804_446322_9CE84135)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dor Shaish <dor.shaish@intel.com>

Print the CPU1 and CPU2 secured boot status registers from the NIC
to indicate a SYSASSERT during secured engine unlocking process
on init/protocol image.

Signed-off-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h | 2 ++
 drivers/net/wireless/iwlwifi/mvm/fw.c   | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index cd98b9f..c4e7a71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -383,6 +383,8 @@ enum aux_misc_master1_en {
 #define AUX_MISC_MASTER1_SMPHR_STATUS	0xA20800
 #define RSA_ENABLE			0xA24B08
 #define PREG_AUX_BUS_WPROT_0		0xA04CC0
+#define SB_CPU_1_STATUS			0xA01E30
+#define SB_CPU_2_STATUS			0xA01E34
 
 /* FW chicken bits */
 #define LMPM_CHICK			0xA01FF8
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index acb402b..e65a653 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -482,6 +482,11 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	ret = iwl_wait_notification(&mvm->notif_wait, &alive_wait,
 				    MVM_UCODE_ALIVE_TIMEOUT);
 	if (ret) {
+		if (mvm->trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+			IWL_ERR(mvm,
+				"SecBoot CPU1 Status: 0x%x, CPU2 Status: 0x%x\n",
+				iwl_read_prph(mvm->trans, SB_CPU_1_STATUS),
+				iwl_read_prph(mvm->trans, SB_CPU_2_STATUS));
 		mvm->cur_ucode = old_type;
 		return ret;
 	}
-- 
2.1.4

