Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53171 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbaGVT1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:38 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so109713wgh.25
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:37 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/20] iwlwifi: mvm: minor change in debug print
Date: Tue, 22 Jul 2014 22:26:44 +0300
Message-Id: <1406057211-31752-13-git-send-email-egrumbach@gmail.com> (sfid-20140722_212743_545331_4C1AD6FE)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Add OTP to the string: "can't parse empty OTP/NVM section"
NVM usually refers to nvm_file while the problem can be in
the OTP.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index b04805c..cfdd314 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -265,7 +265,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
 		if (!mvm->nvm_sections[NVM_SECTION_TYPE_SW].data ||
 		    !mvm->nvm_sections[mvm->cfg->nvm_hw_section_num].data) {
-			IWL_ERR(mvm, "Can't parse empty NVM sections\n");
+			IWL_ERR(mvm, "Can't parse empty OTP/NVM sections\n");
 			return NULL;
 		}
 	} else {
@@ -273,7 +273,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 		if (!mvm->nvm_sections[NVM_SECTION_TYPE_SW].data ||
 		    !mvm->nvm_sections[NVM_SECTION_TYPE_REGULATORY].data) {
 			IWL_ERR(mvm,
-				"Can't parse empty family 8000 NVM sections\n");
+				"Can't parse empty family 8000 OTP/NVM sections\n");
 			return NULL;
 		}
 		/* MAC_OVERRIDE or at least HW section must exist */
-- 
1.8.3.2

