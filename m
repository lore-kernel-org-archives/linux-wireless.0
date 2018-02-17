Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59288 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751086AbeBQIeH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 03:34:07 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 17 Feb 2018 10:33:51 +0200
Message-Id: <20180217083354.31160-7-luca@coelho.fi> (sfid-20180217_093421_577043_E293CD77)
In-Reply-To: <20180217083354.31160-1-luca@coelho.fi>
References: <20180217083354.31160-1-luca@coelho.fi>
Subject: [PATCH 6/9] iwlwifi: mvm: fix "failed to remove key" message
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When the GTK is installed, we install it to HW with the
station ID of the AP.

Mac80211 will try to remove it only after the AP sta is
removed, which will result in a failure to remove key
since we do not have any station for it.

This is a valid situation, but a previous commit removed
the early return and added a return with error value, which
resulted in an error message that is confusing to users.

Remove the error return value.

Fixes: 85aeb58cec1a ("iwlwifi: mvm: Enable security on new TX API")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index dbd2ba2bb714..3739e42b34e4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -3170,8 +3170,9 @@ static int __iwl_mvm_remove_sta_key(struct iwl_mvm *mvm, u8 sta_id,
 	int ret, size;
 	u32 status;
 
+	/* This is a valid situation for GTK removal */
 	if (sta_id == IWL_MVM_INVALID_STA)
-		return -EINVAL;
+		return 0;
 
 	key_flags = cpu_to_le16((keyconf->keyidx << STA_KEY_FLG_KEYID_POS) &
 				 STA_KEY_FLG_KEYID_MSK);
-- 
2.15.1
