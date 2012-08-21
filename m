Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab2HURCK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 13:02:10 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/8] iwlwifi: fix aggregation check indentation
Date: Tue, 21 Aug 2012 19:01:52 +0200
Message-Id: <1345568516-20822-4-git-send-email-johannes@sipsolutions.net> (sfid-20120821_190216_539902_659C4D9A)
In-Reply-To: <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
References: <1345568455.10280.11.camel@jlt3.sipsolutions.net>
 <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Align the code to inside the WARN_ON() as it should.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 5971a23..954ac34 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -431,7 +431,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		 * only. Check this here.
 		 */
 		if (WARN_ONCE(tid_data->agg.state != IWL_AGG_ON &&
-		    tid_data->agg.state != IWL_AGG_OFF,
+			      tid_data->agg.state != IWL_AGG_OFF,
 		    "Tx while agg.state = %d", tid_data->agg.state))
 			goto drop_unlock_sta;
 
-- 
1.7.10.4

