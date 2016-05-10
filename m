Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40756 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751479AbcEJU3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:29:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:32 +0300
Message-Id: <1462910797-20303-36-git-send-email-luca@coelho.fi> (sfid-20160510_222957_579058_BA515AE9)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 36/41] iwlwifi: pcie: avoid msleep() with short timeout
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since msleep is based on jiffies, it can sleep for a long time.
Use usleep_range() instead to shorten the maximum time.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 59fd17a..f603d78 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -582,7 +582,7 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 
 	iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
 		    CSR_RESET_LINK_PWR_MGMT_DISABLED);
-	msleep(1);
+	usleep_range(1000, 2000);
 
 	for (iter = 0; iter < 10; iter++) {
 		/* If HW is not ready, prepare the conditions to check again */
@@ -1945,7 +1945,7 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 				      "WR pointer moved while flushing %d -> %d\n",
 				      wr_ptr, write_ptr))
 				return -ETIMEDOUT;
-			msleep(1);
+			usleep_range(1000, 2000);
 		}
 
 		if (q->read_ptr != q->write_ptr) {
-- 
2.8.1

