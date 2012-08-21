Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005Ab2HURCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 13:02:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 7/8] iwlwifi: fix the preparation of the card
Date: Tue, 21 Aug 2012 19:01:55 +0200
Message-Id: <1345568516-20822-7-git-send-email-johannes@sipsolutions.net> (sfid-20120821_190222_212968_54EC8827)
In-Reply-To: <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
References: <1345568455.10280.11.camel@jlt3.sipsolutions.net>
 <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

There is no need to check if the ownership has been
relinquished but we should rather try to get it in a
loop.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index f981b73..f76efac 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -897,6 +897,7 @@ static int iwl_set_hw_ready(struct iwl_trans *trans)
 static int iwl_prepare_card_hw(struct iwl_trans *trans)
 {
 	int ret;
+	int t = 0;
 
 	IWL_DEBUG_INFO(trans, "iwl_trans_prepare_card_hw enter\n");
 
@@ -909,17 +910,15 @@ static int iwl_prepare_card_hw(struct iwl_trans *trans)
 	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
 		    CSR_HW_IF_CONFIG_REG_PREPARE);
 
-	ret = iwl_poll_bit(trans, CSR_HW_IF_CONFIG_REG,
-			   ~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
-			   CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
+	do {
+		ret = iwl_set_hw_ready(trans);
+		if (ret >= 0)
+			return 0;
 
-	if (ret < 0)
-		return ret;
+		usleep_range(200, 1000);
+		t += 200;
+	} while (t < 150000);
 
-	/* HW should be ready by now, check again. */
-	ret = iwl_set_hw_ready(trans);
-	if (ret >= 0)
-		return 0;
 	return ret;
 }
 
-- 
1.7.10.4

