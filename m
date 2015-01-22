Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61463 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbbAVUdN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:13 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/38] iwlwifi: mvm: don't indicate no BA if STA was in powersave
Date: Thu, 22 Jan 2015 22:32:28 +0200
Message-Id: <1421958785-3293-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213316_464406_02341590)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox--dry-run>
References: <1421958313.6424.2.camel@egrumbacBox--dry-run>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

If Tx failed because the STA was in powersave there's no point
in sending a BAR so avoid indicating AMPDU_NO_BACK to mac80211.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index d6cdb77..1fff0f4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -656,7 +656,8 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 
 		/* Single frame failure in an AMPDU queue => send BAR */
 		if (txq_id >= mvm->first_agg_queue &&
-		    !(info->flags & IEEE80211_TX_STAT_ACK))
+		    !(info->flags & IEEE80211_TX_STAT_ACK) &&
+		    !(info->flags & IEEE80211_TX_STAT_TX_FILTERED))
 			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 
 		/* W/A FW bug: seq_ctl is wrong when the status isn't success */
-- 
1.9.1

