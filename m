Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:47295 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaGFJhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:03 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so3124542wes.23
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:01 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/40] iwlwifi: mvm: validate that we don't send zero quota
Date: Sun,  6 Jul 2014 12:36:02 +0300
Message-Id: <1404639376-3792-26-git-send-email-egrumbach@gmail.com> (sfid-20140706_115954_585539_D95C2422)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware currently deals with zero quota for a given
binding, but it seems odd to send that down. Make sure
that we don't do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/quota.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 8bb2fce..3f18786 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -297,6 +297,14 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	iwl_mvm_adjust_quota_for_noa(mvm, &cmd);
 
+	/* check that we have non-zero quota for all valid bindings */
+	for (i = 0; i < MAX_BINDINGS; i++) {
+		if (cmd.quotas[i].id_and_color == cpu_to_le32(FW_CTXT_INVALID))
+			continue;
+		WARN_ONCE(cmd.quotas[i].quota == 0,
+			  "zero quota on binding %d\n", i);
+	}
+
 	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_QUOTA_CMD, 0,
 				   sizeof(cmd), &cmd);
 	if (ret)
-- 
1.8.3.2

