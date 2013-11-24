Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42374 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3KXUHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:23 -0500
Received: by mail-wi0-f171.google.com with SMTP id ca18so2730558wib.10
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:22 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/29] iwlwifi: mvm: quota command max_duration should be zero
Date: Sun, 24 Nov 2013 22:06:43 +0200
Message-Id: <1385323606-3603-26-git-send-email-egrumbach@gmail.com> (sfid-20131124_210808_224583_03A0B66D)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For now, the firmware doesn't really use the field, but
it should be set to zero if there's no specific request.
Setting it to the max quota doesn't make sense.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/quota.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 17e2bc8..38165eb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -217,8 +217,7 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 		} else {
 			cmd.quotas[idx].quota =
 				cpu_to_le32(quota * data.n_interfaces[i]);
-			cmd.quotas[idx].max_duration =
-				cpu_to_le32(IWL_MVM_MAX_QUOTA);
+			cmd.quotas[idx].max_duration = cpu_to_le32(0);
 		}
 		idx++;
 	}
-- 
1.7.9.5

