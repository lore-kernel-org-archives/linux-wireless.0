Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20159 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbbGLRIc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 13:08:32 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 01/10] iwlwifi: mvm: fix antenna selection when BT is active
Date: Sun, 12 Jul 2015 20:08:11 +0300
Message-Id: <1436720900-18588-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150712_193715_448512_CB0C4EAD)
In-Reply-To: <1436720814.17999.2.camel@intel.com>
References: <1436720814.17999.2.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When BT is active, we want to avoid the shared antenna for
management frame to make sure we don't disturb BT. There
was a bug in that code because it chose the antenna
BIT(ANT_A) where ANT_A is already a bitmap (0x1). This
means that the antenna chosen in the end was ANT_B.
While this is not optimal on devices with 2 antennas (it'd
disturb BT), it is critical on single antenna devices like
3160 which couldn't connect at all when BT was active.

This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=97181

CC: <stable@vger.kernel.org> [3.17+]
Fixes: 34c8b24ff284 ("iwlwifi: mvm: BT Coex - avoid the shared antenna for management frames")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 7ba7a118..8911686 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -252,7 +252,7 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 
 	if (info->band == IEEE80211_BAND_2GHZ &&
 	    !iwl_mvm_bt_coex_is_shared_ant_avail(mvm))
-		rate_flags = BIT(mvm->cfg->non_shared_ant) << RATE_MCS_ANT_POS;
+		rate_flags = mvm->cfg->non_shared_ant << RATE_MCS_ANT_POS;
 	else
 		rate_flags =
 			BIT(mvm->mgmt_last_antenna_idx) << RATE_MCS_ANT_POS;
-- 
2.1.4

