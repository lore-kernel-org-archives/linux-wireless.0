Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4744 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab3J3UcN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 16:32:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/9] iwlwifi: pcie: move warning message into warning
Date: Wed, 30 Oct 2013 22:31:32 +0200
Message-Id: <1383165097-4445-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131030_213216_883367_F3E7C46C)
In-Reply-To: <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
References: <527143AA.5070900@gmail.com>
 <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Having a WARN_ON() followed by a printed message is
less useful than having the message in the warning
so move the message.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index b416841..cc18440 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1495,12 +1495,11 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
 		       get_cmd_string(trans_pcie, cmd->id));
 
-	if (WARN_ON(test_and_set_bit(STATUS_HCMD_ACTIVE,
-				     &trans_pcie->status))) {
-		IWL_ERR(trans, "Command %s: a command is already active!\n",
-			get_cmd_string(trans_pcie, cmd->id));
+	if (WARN(test_and_set_bit(STATUS_HCMD_ACTIVE,
+				  &trans_pcie->status),
+		 "Command %s: a command is already active!\n",
+		 get_cmd_string(trans_pcie, cmd->id)))
 		return -EIO;
-	}
 
 	IWL_DEBUG_INFO(trans, "Setting HCMD_ACTIVE for command %s\n",
 		       get_cmd_string(trans_pcie, cmd->id));
-- 
1.8.3.2

