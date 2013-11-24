Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36491 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab3KXUG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:06:59 -0500
Received: by mail-wg0-f51.google.com with SMTP id b13so181897wgh.30
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:06:58 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/29] iwlwifi: mvm: enable d3_test even if d3_test_pme_ptr is not available
Date: Sun, 24 Nov 2013 22:06:24 +0200
Message-Id: <1385323606-3603-7-git-send-email-egrumbach@gmail.com> (sfid-20131124_210808_571303_F122BE44)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Even if d3_test_pme_ptr is not available, d3_test can still
be useful, e.g. by manually triggering resume (with ctrl-c),
and reading the wakeup reasons.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 6f45966..096cf80 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1216,10 +1216,6 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	if (len >= sizeof(u32) * 2) {
 		mvm->d3_test_pme_ptr =
 			le32_to_cpup((__le32 *)d3_cfg_cmd.resp_pkt->data);
-	} else if (test) {
-		/* in test mode we require the pointer */
-		ret = -EIO;
-		goto out;
 	}
 #endif
 	iwl_free_resp(&d3_cfg_cmd);
@@ -1870,10 +1866,14 @@ static ssize_t iwl_mvm_d3_test_read(struct file *file, char __user *user_buf,
 	u32 pme_asserted;
 
 	while (true) {
-		pme_asserted = iwl_trans_read_mem32(mvm->trans,
-						    mvm->d3_test_pme_ptr);
-		if (pme_asserted)
-			break;
+		/* read pme_ptr if available */
+		if (mvm->d3_test_pme_ptr) {
+			pme_asserted = iwl_trans_read_mem32(mvm->trans,
+						mvm->d3_test_pme_ptr);
+			if (pme_asserted)
+				break;
+		}
+
 		if (msleep_interruptible(100))
 			break;
 	}
-- 
1.7.9.5

