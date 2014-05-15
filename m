Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37436 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaEORE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:04:59 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 04/24] iwlwifi: pcie: try to get ownership several times
Date: Thu, 15 May 2014 20:04:21 +0300
Message-Id: <1400173481-9047-4-git-send-email-egrumbach@gmail.com> (sfid-20140515_190506_796376_2798DE1D)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Some races with the hardware can happen when we take
ownership of the device. Don't give up after the first try.

Cc: <stable@vger.kernel.org>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index f41f9b7..f8ebd47 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -454,6 +454,7 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 {
 	int ret;
 	int t = 0;
+	int iter;
 
 	IWL_DEBUG_INFO(trans, "iwl_trans_prepare_card_hw enter\n");
 
@@ -462,18 +463,23 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 	if (ret >= 0)
 		return 0;
 
-	/* If HW is not ready, prepare the conditions to check again */
-	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_PREPARE);
+	for (iter = 0; iter < 10; iter++) {
+		/* If HW is not ready, prepare the conditions to check again */
+		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+			    CSR_HW_IF_CONFIG_REG_PREPARE);
+
+		do {
+			ret = iwl_pcie_set_hw_ready(trans);
+			if (ret >= 0)
+				return 0;
 
-	do {
-		ret = iwl_pcie_set_hw_ready(trans);
-		if (ret >= 0)
-			return 0;
+			usleep_range(200, 1000);
+			t += 200;
+		} while (t < 150000);
+		msleep(25);
+	}
 
-		usleep_range(200, 1000);
-		t += 200;
-	} while (t < 150000);
+	IWL_DEBUG_INFO(trans, "got NIC after %d iterations\n", iter);
 
 	return ret;
 }
-- 
1.8.3.2

