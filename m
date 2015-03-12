Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4406 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbbCLNGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:20 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 42/49] iwlwifi: mvm: fix force NMI for 8000
Date: Thu, 12 Mar 2015 15:04:27 +0200
Message-Id: <1426165474-25586-42-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143417_986107_4619EA73)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The newer devices will enable a new register for this
(DEVICE_SET_NMI_8000B_REG), but the interrupt handler
isn't wired yet.
Keep the old register for now.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 03250a4..78cac43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -201,6 +201,8 @@ void iwl_force_nmi(struct iwl_trans *trans)
 	} else {
 		iwl_write_prph(trans, DEVICE_SET_NMI_8000B_REG,
 			       DEVICE_SET_NMI_8000B_VAL);
+		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
+			       DEVICE_SET_NMI_VAL_DRV);
 	}
 }
 IWL_EXPORT_SYMBOL(iwl_force_nmi);
-- 
1.9.1

