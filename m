Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbbCLNGg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:36 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 49/49] iwlwifi: mvm: simplify iwl_mvm_get_wakeup_status() return
Date: Thu, 12 Mar 2015 15:04:34 +0200
Message-Id: <1426165474-25586-49-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140736_858587_FF755B35)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The return value in iwl_mvm_get_wakeup_status() is a bit unclear in
that it's not obvious that we don't leak fw_status in some cases.
Use fw_status directly with ERR_PTR() and return only it, that way
the compiler has a chance of proving that it's uninitialized (if it
ever is due to new changes.)

Additionally, this removes a smatch warning since smatch couldn't
figure out that fw_status can't, in fact, leak here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index e3c3084..5f8afa5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1599,7 +1599,7 @@ iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	/* RF-kill already asserted again... */
 	if (!cmd.resp_pkt) {
-		ret = -ERFKILL;
+		fw_status = ERR_PTR(-ERFKILL);
 		goto out_free_resp;
 	}
 
@@ -1608,7 +1608,7 @@ iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
 	if (len < status_size) {
 		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
-		ret = -EIO;
+		fw_status = ERR_PTR(-EIO);
 		goto out_free_resp;
 	}
 
@@ -1616,7 +1616,7 @@ iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (len != (status_size +
 		    ALIGN(le32_to_cpu(status->wake_packet_bufsize), 4))) {
 		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
-		ret = -EIO;
+		fw_status = ERR_PTR(-EIO);
 		goto out_free_resp;
 	}
 
@@ -1624,7 +1624,7 @@ iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 out_free_resp:
 	iwl_free_resp(&cmd);
-	return ret ? ERR_PTR(ret) : fw_status;
+	return fw_status;
 }
 
 /* releases the MVM mutex */
-- 
1.9.1

