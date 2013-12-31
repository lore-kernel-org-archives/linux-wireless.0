Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38202 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab3LaRQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:21 -0500
Received: by mail-ee0-f44.google.com with SMTP id b57so5593161eek.17
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:20 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/28] iwlwifi: mvm: fix possible memory leak
Date: Tue, 31 Dec 2013 19:15:42 +0200
Message-Id: <1388510157-23345-13-git-send-email-egrumbach@gmail.com> (sfid-20131231_183437_742488_AC2081E1)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

In case of invalid section_id, the function returns after
it aleready allocated memory. Fixed by change the order of actions.

Signed-off-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/nvm.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 48089b1..c03406f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -367,16 +367,17 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 			break;
 		}
 
+		if (WARN(section_id >= NVM_NUM_OF_SECTIONS,
+			 "Invalid NVM section ID %d\n", section_id)) {
+			ret = -EINVAL;
+			break;
+		}
+
 		temp = kmemdup(file_sec->data, section_size, GFP_KERNEL);
 		if (!temp) {
 			ret = -ENOMEM;
 			break;
 		}
-		if (WARN_ON(section_id >= NVM_NUM_OF_SECTIONS)) {
-			IWL_ERR(mvm, "Invalid NVM section ID\n");
-			ret = -EINVAL;
-			break;
-		}
 		mvm->nvm_sections[section_id].data = temp;
 		mvm->nvm_sections[section_id].length = section_size;
 
-- 
1.7.9.5

