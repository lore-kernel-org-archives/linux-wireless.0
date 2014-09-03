Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34224 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaICT4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:39 -0400
Received: by mail-wg0-f46.google.com with SMTP id x13so9049426wgg.5
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:38 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/36] iwlwifi: mvm: don't run automatic checks if CT was caused by debugfs
Date: Wed,  3 Sep 2014 22:55:55 +0300
Message-Id: <1409774184-24665-7-git-send-email-egrumbach@gmail.com> (sfid-20140903_215646_774984_862591B4)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If we're manually testing the CT kill functionality via debugfs, we
shouldn't schedule the work to recheck the temperature after the
ct_kill_duration period has passed.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tt.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index d31603c..4c22c0a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -319,8 +319,14 @@ static void iwl_mvm_enter_ctkill(struct iwl_mvm *mvm)
 
 	IWL_ERR(mvm, "Enter CT Kill\n");
 	iwl_mvm_set_hw_ctkill_state(mvm, true);
-	schedule_delayed_work(&mvm->thermal_throttle.ct_kill_exit,
-			      round_jiffies_relative(duration * HZ));
+
+	/* Don't schedule an exit work if we're in test mode, since
+	 * the temperature will not change unless we manually set it
+	 * again (or disable testing).
+	 */
+	if (!mvm->temperature_test)
+		schedule_delayed_work(&mvm->thermal_throttle.ct_kill_exit,
+				      round_jiffies_relative(duration * HZ));
 }
 
 static void iwl_mvm_exit_ctkill(struct iwl_mvm *mvm)
-- 
1.9.1

