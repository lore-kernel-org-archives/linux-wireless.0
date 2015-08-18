Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbbHRH6o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:44 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/26] iwlwifi: mvm: fix a race in D0i3 vs. Tx path
Date: Tue, 18 Aug 2015 10:57:36 +0300
Message-Id: <1439884656-18146-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100110_640232_8BA9A152)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we enter D0i3, we must stop TXing otherwise the
sequence number we use might conflict with the firmware's
internal TX. In order to do so, we have
IWL_MVM_STATUS_IN_D0I3 which should prevent any Tx while we
enter D0i3. There is a bug in this code since we may Tx even
if IWL_MVM_STATUS_IN_D0I3 is set. This can happen as long as
mvm->d0i3_ap_sta_id is not set.

To make sure that we don't have any packet in the Tx path
while we set mvm->d0i3_ap_sta_id, call synchronize_net only
after we already set mvm->d0i3_ap_sta_id.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 02ce184..07e6892 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1114,9 +1114,7 @@ int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 
 	IWL_DEBUG_RPM(mvm, "MVM entering D0i3\n");
 
-	/* make sure we have no running tx while configuring the qos */
 	set_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status);
-	synchronize_net();
 
 	/*
 	 * iwl_mvm_ref_sync takes a reference before checking the flag.
@@ -1144,6 +1142,9 @@ int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 		mvm->d0i3_offloading = false;
 	}
 
+	/* make sure we have no running tx while configuring the seqno */
+	synchronize_net();
+
 	iwl_mvm_set_wowlan_data(mvm, &wowlan_config_cmd, &d0i3_iter_data);
 	ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, flags,
 				   sizeof(wowlan_config_cmd),
-- 
2.1.4

