Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab2JPSPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:15:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/8] iwlwifi: improve oversized command warning
Date: Tue, 16 Oct 2012 20:16:13 +0200
Message-Id: <1350411380-2391-2-git-send-email-johannes@sipsolutions.net> (sfid-20121016_201556_168528_E39536AD)
In-Reply-To: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
References: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When warning about a command that is too large,
print out the command name/ID to help figure
out which place is attempting to send a command
that is too large.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 105e3af..b50d1b4 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -549,7 +549,10 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	 * allocated into separate TFDs, then we will need to
 	 * increase the size of the buffers.
 	 */
-	if (WARN_ON(copy_size > TFD_MAX_PAYLOAD_SIZE))
+	if (WARN(copy_size > TFD_MAX_PAYLOAD_SIZE,
+		 "Command %s (%#x) is too large (%d bytes)\n",
+		 trans_pcie_get_cmd_string(trans_pcie, cmd->id),
+		 cmd->id, copy_size))
 		return -EINVAL;
 
 	spin_lock_bh(&txq->lock);
-- 
1.7.10.4

