Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47074 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbbDBGl6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:58 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/31] iwlwifi: mvm: fix debug print in the RSA ownership workaround
Date: Thu,  2 Apr 2015 09:41:04 +0300
Message-Id: <1427956879-11725-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090418_527247_9DD702CF)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

The semaphore may not be accessible. Fix the debug prints
accordingly.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index d8984fb..2de8fbf 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -691,11 +691,15 @@ static int iwl_pcie_rsa_race_bug_wa(struct iwl_trans *trans)
 {
 	u32 val, loop = 1000;
 
-	/* Check the RSA semaphore is accessible - if not, we are in trouble */
+	/*
+	 * Check the RSA semaphore is accessible.
+	 * If the HW isn't locked and the rsa semaphore isn't accessible,
+	 * we are in trouble.
+	 */
 	val = iwl_read_prph(trans, PREG_AUX_BUS_WPROT_0);
 	if (val & (BIT(1) | BIT(17))) {
-		IWL_ERR(trans,
-			"can't access the RSA semaphore it is write protected\n");
+		IWL_INFO(trans,
+			 "can't access the RSA semaphore it is write protected\n");
 		return 0;
 	}
 
-- 
1.9.1

