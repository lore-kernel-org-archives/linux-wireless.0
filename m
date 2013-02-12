Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760313Ab3BLQCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/15] iwlwifi: mvm: fix the keyidx assignment
Date: Tue, 12 Feb 2013 17:01:57 +0100
Message-Id: <1360684927-1367-5-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170231_174143_FB6BE8AB)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Fixes an issue that smatch pointed out:

  1118
  1119          key_flags = cpu_to_le16(keyconf->keyidx &  STA_KEY_FLG_KEYID_MSK);
                                        ^^^^^^^^^^^^^^^
This is s8.
                                                          ^^^^^^^^^^^^^^^^^^^^^
STA_KEY_FLG_KEYID_MSK is 0x300.

The result after the bitwise AND is always zero because 0xff & 0x300.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 69603c3..8f8b66e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1116,7 +1116,8 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 	if (WARN_ON_ONCE(mvm_sta->vif != vif))
 		return -EINVAL;
 
-	key_flags = cpu_to_le16(keyconf->keyidx & STA_KEY_FLG_KEYID_MSK);
+	key_flags = cpu_to_le16((keyconf->keyidx << STA_KEY_FLG_KEYID_POS) &
+				 STA_KEY_FLG_KEYID_MSK);
 	key_flags |= cpu_to_le16(STA_KEY_FLG_NO_ENC | STA_KEY_FLG_WEP_KEY_MAP);
 	key_flags |= cpu_to_le16(STA_KEY_NOT_VALID);
 
-- 
1.8.0

