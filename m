Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbbEZTSM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:12 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/39] iwlwifi: pcie: simplify return value
Date: Tue, 26 May 2015 22:17:21 +0300
Message-Id: <1432667872-18092-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211821_888944_4BBA16A1)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was spot by Coccinelle.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index dd1f828..d392ef4 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -973,12 +973,8 @@ static int iwl_pcie_load_given_ucode_8000(struct iwl_trans *trans,
 		return ret;
 
 	/* load to FW the binary sections of CPU2 */
-	ret = iwl_pcie_load_cpu_sections_8000(trans, image, 2,
-					      &first_ucode_section);
-	if (ret)
-		return ret;
-
-	return 0;
+	return iwl_pcie_load_cpu_sections_8000(trans, image, 2,
+					       &first_ucode_section);
 }
 
 static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
-- 
2.1.4

