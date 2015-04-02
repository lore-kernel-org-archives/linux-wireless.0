Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbbDBGlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:49 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/31] iwlwifi: mvm: add delay to scheduled scan
Date: Thu,  2 Apr 2015 09:41:00 +0300
Message-Id: <1427956879-11725-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090419_057186_D396328B)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add support for delaying the start of a scheduled scan (or a WoWLAN
net-detect scan).

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 6352587..2997864 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -935,6 +935,8 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 
 	cmd->n_channels = (u8)req->n_channels;
 
+	cmd->delay = cpu_to_le32(req->delay);
+
 	if (iwl_mvm_scan_pass_all(mvm, req))
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL;
 	else
@@ -1436,7 +1438,13 @@ int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				cpu_to_le16(req->interval / MSEC_PER_SEC);
 	sec_part->schedule[0].iter_count = 0xff;
 
-	sec_part->delay = 0;
+	if (req->delay > U16_MAX) {
+		IWL_DEBUG_SCAN(mvm,
+			       "delay value is > 16-bits, set to max possible\n");
+		sec_part->delay = cpu_to_le16(U16_MAX);
+	} else {
+		sec_part->delay = cpu_to_le16(req->delay);
+	}
 
 	iwl_mvm_build_unified_scan_probe(mvm, vif, ies, &sec_part->preq,
 		req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
-- 
1.9.1

