Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2991 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbbJYMCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:02:05 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Moshe Harel <moshe.harel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/16] iwlwifi: nvm: free old section data when reading nvm file
Date: Sun, 25 Oct 2015 14:01:16 +0200
Message-Id: <1445774476-24792-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_131654_961181_2D0D1184)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Moshe Harel <moshe.harel@intel.com>

When reading external NVM file, if a section exists both in OTP
and in the external file, the memory that was allocated at OTP
reading is not freed.
This is possible only on systems that have an external NVM
file which is typically the case on embedded systems.

Signed-off-by: Moshe Harel <moshe.harel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 4e4a680..2ee0f6f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -483,6 +483,7 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 			ret = -ENOMEM;
 			break;
 		}
+		kfree(mvm->nvm_sections[section_id].data);
 		mvm->nvm_sections[section_id].data = temp;
 		mvm->nvm_sections[section_id].length = section_size;
 
-- 
2.1.4

