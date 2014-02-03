Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59211 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaBCU7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:05 -0500
Received: by mail-ee0-f46.google.com with SMTP id c13so3898648eek.33
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:04 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/62] iwlwifi: mvm: add the quota remainder to a data binding
Date: Mon,  3 Feb 2014 22:57:36 +0200
Message-Id: <1391461088-8082-30-git-send-email-egrumbach@gmail.com> (sfid-20140203_220008_866092_AFACA349)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Currently the quota remainder was added to the first binding, although
it is possible that this was not a data binding (only the P2P_DEVICE
interface is part of the binding).

Fix this by adding the remainder to the first binding that was actually
allocated quota.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/quota.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 5691a85..f07ae48 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -276,8 +276,13 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 		idx++;
 	}
 
-	/* Give the remainder of the session to the first binding */
-	le32_add_cpu(&cmd.quotas[0].quota, quota_rem);
+	/* Give the remainder of the session to the first data binding */
+	for (i = 0; i < MAX_BINDINGS; i++) {
+		if (le32_to_cpu(cmd.quotas[i].quota) != 0) {
+			le32_add_cpu(&cmd.quotas[i].quota, quota_rem);
+			break;
+		}
+	}
 
 	iwl_mvm_adjust_quota_for_noa(mvm, &cmd);
 
-- 
1.7.9.5

