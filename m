Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:2781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbcC3NM4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 09:12:56 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 1/2] iwlwifi: pcie: lower the debug level for RSA semaphore access
Date: Wed, 30 Mar 2016 16:12:50 +0300
Message-Id: <1459343571-27345-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_151259_541651_741B9610)
In-Reply-To: <1459343451.4731.6.camel@intel.com>
References: <1459343451.4731.6.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IWL_INFO is not an error but still printed by default.
"can't access the RSA semaphore it is write protected" seems
worrisome but it is not really a problem.

CC: <stable@vger.kernel.org> [4.1+]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index eb39c7e..b2b7935 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -732,8 +732,8 @@ static int iwl_pcie_rsa_race_bug_wa(struct iwl_trans *trans)
 	 */
 	val = iwl_read_prph(trans, PREG_AUX_BUS_WPROT_0);
 	if (val & (BIT(1) | BIT(17))) {
-		IWL_INFO(trans,
-			 "can't access the RSA semaphore it is write protected\n");
+		IWL_DEBUG_INFO(trans,
+			       "can't access the RSA semaphore it is write protected\n");
 		return 0;
 	}
 
-- 
2.5.0

