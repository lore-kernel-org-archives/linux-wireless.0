Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36779 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422801AbbEUTxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 15:53:38 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/10] iwlwifi: mvm: avoid use-after-free on iwl_mvm_d0i3_enable_tx()
Date: Thu, 21 May 2015 22:53:10 +0300
Message-Id: <1432237990-5890-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150521_215353_351531_F3717D6D)
In-Reply-To: <1432237819.26813.4.camel@intel.com>
References: <1432237819.26813.4.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

qos_seq points (to a struct) inside the command response data.

Make sure to free the response only after qos_seq is not
needed anymore.

Reported-by: Heng Luo <heng.luo@intel.com>
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 1c66297..2ea0123 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1263,11 +1263,13 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 		ieee80211_iterate_active_interfaces(
 			mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 			iwl_mvm_d0i3_disconnect_iter, mvm);
-
-	iwl_free_resp(&get_status_cmd);
 out:
 	iwl_mvm_d0i3_enable_tx(mvm, qos_seq);
 
+	/* qos_seq might point inside resp_pkt, so free it only now */
+	if (get_status_cmd.resp_pkt)
+		iwl_free_resp(&get_status_cmd);
+
 	/* the FW might have updated the regdomain */
 	iwl_mvm_update_changed_regdom(mvm);
 
-- 
2.1.4

