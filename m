Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21224 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbcAGMsI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:48:08 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/21] iwlwifi: mvm: initialize gtkdata->mvm correctly
Date: Thu,  7 Jan 2016 14:47:37 +0200
Message-Id: <1452170861-10060-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134815_684426_0F064029)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

gtkdata->mvm wasn't set in iwl_mvm_d0i3_update_keys,
resulting in kernel panic in some flows (when mvm
is actually used...)

Fixes: a3f7ba5c8825 ("iwlwifi: update key params on d0i3 entrance/exit")
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 2cd9052..d3e21d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1843,6 +1843,7 @@ void iwl_mvm_d0i3_update_keys(struct iwl_mvm *mvm,
 			      struct iwl_wowlan_status *status)
 {
 	struct iwl_mvm_d3_gtk_iter_data gtkdata = {
+		.mvm = mvm,
 		.status = status,
 	};
 
-- 
2.5.0

