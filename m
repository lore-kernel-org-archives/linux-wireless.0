Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969AbbLAJ7X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:23 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/41] iwlwifi: pcie: remove ICT allocation message
Date: Tue,  1 Dec 2015 11:58:36 +0200
Message-Id: <1448963947-24302-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110356_204875_872D2821)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This message isn't very useful and presents a security risk
due to the use of %p - remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index b837b34..2b5d3e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1491,10 +1491,6 @@ int iwl_pcie_alloc_ict(struct iwl_trans *trans)
 		return -EINVAL;
 	}
 
-	IWL_DEBUG_ISR(trans, "ict dma addr %Lx ict vir addr %p\n",
-		      (unsigned long long)trans_pcie->ict_tbl_dma,
-		      trans_pcie->ict_tbl);
-
 	return 0;
 }
 
-- 
2.5.0

