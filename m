Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47759 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaEGTxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:52 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm4so9749147wib.16
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:51 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/23] iwlwifi: mvm: Prioritize external nvm values on top of the OTP values
Date: Wed,  7 May 2014 22:52:49 +0300
Message-Id: <1399492380-12050-12-git-send-email-egrumbach@gmail.com> (sfid-20140507_215406_526943_7EC6CE8A)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Read first the nvm sections from the OTP, then read the nvm
sections from the external file and override the OTP values
(if there were any values in the OTP).

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Dor Shaish <dor.shaish@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index fe4c91e..2cb6c29 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -437,14 +437,7 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 	if (WARN_ON_ONCE(mvm->cfg->nvm_hw_section_num >= NVM_MAX_NUM_SECTIONS))
 		return -EINVAL;
 
-	/* load external NVM if configured */
-	if (iwlwifi_mod_params.nvm_file) {
-		/* move to External NVM flow */
-		ret = iwl_mvm_read_external_nvm(mvm);
-		if (ret)
-			return ret;
-	}
-
+	/* load NVM values from nic */
 	if (read_nvm_from_nic) {
 		/* list of NVM sections we are allowed/need to read */
 		if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
@@ -512,6 +505,15 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 			return ret;
 	}
 
+	/* load external NVM if configured */
+	if (iwlwifi_mod_params.nvm_file) {
+		/* move to External NVM flow */
+		ret = iwl_mvm_read_external_nvm(mvm);
+		if (ret)
+			return ret;
+	}
+
+	/* parse the relevant nvm sections */
 	mvm->nvm_data = iwl_parse_nvm_sections(mvm);
 	if (!mvm->nvm_data)
 		return -ENODATA;
-- 
1.8.3.2

