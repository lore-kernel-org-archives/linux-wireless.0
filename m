Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41967 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbcAGMsK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:48:10 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/21] iwlwifi: mvm: check minimum temperature notification length
Date: Thu,  7 Jan 2016 14:47:38 +0200
Message-Id: <1452170861-10060-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134816_263690_B24C34F1)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This notification will be extended with extra data, so just
check that it has a minimum length, not the exact length;
we might later add handling for the extra fields added and
have more code to handle both versions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 473975c..fb76004 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -120,7 +120,7 @@ static int iwl_mvm_temp_notif_parse(struct iwl_mvm *mvm,
 	int len = iwl_rx_packet_payload_len(pkt);
 	int temp;
 
-	if (WARN_ON_ONCE(len != sizeof(*notif))) {
+	if (WARN_ON_ONCE(len < sizeof(*notif))) {
 		IWL_ERR(mvm, "Invalid DTS_MEASUREMENT_NOTIFICATION\n");
 		return -EINVAL;
 	}
-- 
2.5.0

