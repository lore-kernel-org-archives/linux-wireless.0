Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54088 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbaKXOgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:48 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so12358023wgg.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:47 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 69/75] iwlwifi: mvm: call iwl_trans_suspend/resume
Date: Mon, 24 Nov 2014 16:34:45 +0200
Message-Id: <1416839691-28533-69-git-send-email-egrumbach@gmail.com> (sfid-20141124_153656_882039_49F77498)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

call the appropriate iwl_trans_suspend/resume ops
on iwl_mvm_suspend/resume calls.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 176556e..60748bd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1116,6 +1116,7 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
+	iwl_trans_suspend(mvm->trans);
 	if (iwl_mvm_is_d0i3_supported(mvm)) {
 		mutex_lock(&mvm->d0i3_suspend_mutex);
 		__set_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags);
@@ -1739,6 +1740,8 @@ int iwl_mvm_resume(struct ieee80211_hw *hw)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
+	iwl_trans_resume(mvm->trans);
+
 	if (iwl_mvm_is_d0i3_supported(mvm))
 		return 0;
 
-- 
1.9.1

