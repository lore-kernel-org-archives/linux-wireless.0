Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44790 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaEGTxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:55 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so1982008wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:54 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/23] iwlwifi: mvm: fix bug in parse_nvm_sections
Date: Wed,  7 May 2014 22:52:51 +0300
Message-Id: <1399492380-12050-14-git-send-email-egrumbach@gmail.com> (sfid-20140507_215410_353912_BC237054)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

The old code checks if hw_section_num is valid while the
right thing to do is to check if section[hw_section_num].data
is valid.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 6d0e659..6b88c29 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -246,7 +246,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 			return NULL;
 		}
 		/* MAC_OVERRIDE or at least HW section must exist */
-		if (!mvm->cfg->nvm_hw_section_num &&
+		if (!mvm->nvm_sections[mvm->cfg->nvm_hw_section_num].data &&
 		    !mvm->nvm_sections[NVM_SECTION_TYPE_MAC_OVERRIDE].data) {
 			IWL_ERR(mvm,
 				"Can't parse mac_address, empty sections\n");
-- 
1.8.3.2

