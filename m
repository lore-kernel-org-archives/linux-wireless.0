Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:58407 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaIOFNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:36 -0400
Received: by mail-we0-f169.google.com with SMTP id w61so3340263wes.28
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:35 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/28] iwlwifi: mvm: fix quota update avoidance
Date: Mon, 15 Sep 2014 08:12:53 +0300
Message-Id: <1410757980-2138-21-git-send-email-egrumbach@gmail.com> (sfid-20140915_073114_552947_186C5586)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When not updating the quota, the new command shouldn't be stored
as otherwise slowly drifting quota would never update the firmware.
Fix this by storing the command only when it was also sent.

Since the error message also only makes sense when attempting to
send the command, just short-circuit the function when there's no
need to send the command.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/quota.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 1eab2f2..dbb2594 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -309,17 +309,16 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
 			  "zero quota on binding %d\n", i);
 	}
 
-	if (send) {
-		err = iwl_mvm_send_cmd_pdu(mvm, TIME_QUOTA_CMD, 0,
-					   sizeof(cmd), &cmd);
-	} else {
+	if (!send) {
 		/* don't send a practically unchanged command, the firmware has
 		 * to re-initialize a lot of state and that can have an adverse
 		 * impact on it
 		 */
-		err = 0;
+		return 0;
 	}
 
+	err = iwl_mvm_send_cmd_pdu(mvm, TIME_QUOTA_CMD, 0, sizeof(cmd), &cmd);
+
 	if (err)
 		IWL_ERR(mvm, "Failed to send quota: %d\n", err);
 	else
-- 
1.9.1

