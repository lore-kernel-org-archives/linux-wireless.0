Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45729 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752762AbbIUU7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 16:59:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:46 +0300
Message-Id: <1442869141-31637-6-git-send-email-luca@coelho.fi> (sfid-20150921_230221_860475_458D9F4A)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 06/21] iwlwifi: mvm: make sure d0i3 exit work runs before suspending
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If we are in d0i3 when entering suspend, we leave d0i3 so that
mac80211 can call us to remove connections or whatever before going to
suspend.  We do this by calling pm_runtime_resume() early in the slave
transport flow and reactivating it later, when the wiphy suspend flow
runs.

The problem is that we queue a work in order to leave d0i3.  If this
work hasn't run yet when the wiphy suspend flow is called, we have a
race and entering d0i3 fails (because we're still holding the
IWL_MVM_REF_EXIT_WORK reference).

To solve this, simply flush the d0i3_exit_work at the beginning of the
iwl_mvm_suspend() function.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 04264e4..1d54355 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1170,6 +1170,9 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 
+	/* make sure the d0i3 exit work is not pending */
+	flush_work(&mvm->d0i3_exit_work);
+
 	ret = iwl_trans_suspend(mvm->trans);
 	if (ret)
 		return ret;
-- 
2.5.1

