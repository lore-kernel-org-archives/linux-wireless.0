Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22835 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965660AbbD1Mn2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 08:43:28 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 7/8] iwlwifi: mvm: fix typo in CONFIG option
Date: Tue, 28 Apr 2015 15:43:11 +0300
Message-Id: <1430224992-20327-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150428_144333_580351_ECB91BD5)
In-Reply-To: <1430224907.4748.3.camel@intel.com>
References: <1430224907.4748.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I forgot to rename the CPTCFG_ prefix...

Fixes: 484b3d13b4ac ("iwlwifi: mvm: add debugfs entry with the number of net-detect scans")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index a6c48c7..1b1b2bf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1726,7 +1726,7 @@ iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
 	results->matched_profiles = le32_to_cpu(query->matched_profiles);
 	memcpy(results->matches, query->matches, sizeof(results->matches));
 
-#ifdef CPTCFG_IWLWIFI_DEBUGFS
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	mvm->last_netdetect_scans = le32_to_cpu(query->n_scans_done);
 #endif
 
-- 
2.1.0

