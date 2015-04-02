Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32677 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbbDBGm1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:27 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/31] iwlwifi: mvm: always reconfigure last MCC on init
Date: Thu,  2 Apr 2015 09:41:11 +0300
Message-Id: <1427956879-11725-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090419_179444_A91465AE)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Currently the last found MCC is reconfigured only in the recovery flow.
But it should always be used when available, for the ifdown/up or
RF-Kill/CT-Kill scenarios.
While at it, fix a couple of bugs in the init-from-last-MCC flow. Return
an error value when a current MCC is not found. Pass on the regdomain to
cfg80211 only if it was changed and don't ignore the return value from
the cfg80211-setter function.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 17 ++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/nvm.c      |  9 ++++-----
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 07344e11..0dd999c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -379,11 +379,13 @@ int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm)
 {
 	enum iwl_mcc_source used_src;
 	struct ieee80211_regdomain *regd;
+	int ret;
+	bool changed;
 	const struct ieee80211_regdomain *r =
 			rtnl_dereference(mvm->hw->wiphy->regd);
 
 	if (!r)
-		return 0;
+		return -ENOENT;
 
 	/* save the last source in case we overwrite it below */
 	used_src = mvm->mcc_src;
@@ -395,14 +397,19 @@ int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm)
 	}
 
 	/* Now set our last stored MCC and source */
-	regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, r->alpha2, used_src, NULL);
+	regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, r->alpha2, used_src,
+				     &changed);
 	if (IS_ERR_OR_NULL(regd))
 		return -EIO;
 
-	regulatory_set_wiphy_regd(mvm->hw->wiphy, regd);
-	kfree(regd);
+	/* update cfg80211 if the regdomain was changed */
+	if (changed)
+		ret = regulatory_set_wiphy_regd_sync_rtnl(mvm->hw->wiphy, regd);
+	else
+		ret = 0;
 
-	return 0;
+	kfree(regd);
+	return ret;
 }
 
 int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 524ade2..87b2a30 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -806,13 +806,12 @@ int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 		return 0;
 
 	/*
-	 * During HW restart, only replay the last set MCC to FW. Otherwise,
+	 * try to replay the last set MCC to FW. If it doesn't exist,
 	 * queue an update to cfg80211 to retrieve the default alpha2 from FW.
 	 */
-	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
-		/* This should only be called during vif up and hold RTNL */
-		return iwl_mvm_init_fw_regd(mvm);
-	}
+	retval = iwl_mvm_init_fw_regd(mvm);
+	if (retval != -ENOENT)
+		return retval;
 
 	/*
 	 * Driver regulatory hint for initial update, this also informs the
-- 
1.9.1

