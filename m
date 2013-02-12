Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab3BLQCN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:13 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/15] iwlwifi: don't ack the card state notification
Date: Tue, 12 Feb 2013 17:01:53 +0100
Message-Id: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170216_256139_A92A6B96)
In-Reply-To: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is not needed with MVM firmware.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 90473c2..d3d959d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -621,10 +621,6 @@ int iwl_mvm_rx_card_state_notif(struct iwl_mvm *mvm,
 			  (flags & CT_KILL_CARD_DISABLED) ?
 			  "Reached" : "Not reached");
 
-	if (flags & CARD_DISABLED_MSK)
-		iwl_write32(mvm->trans, CSR_UCODE_DRV_GP1_SET,
-			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-
 	return 0;
 }
 
-- 
1.8.0

