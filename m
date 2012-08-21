Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2HURCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 13:02:09 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Subject: [PATCH 2/8] iwlwifi: clean up properly when registration with mac80211 fails
Date: Tue, 21 Aug 2012 19:01:50 +0200
Message-Id: <1345568516-20822-2-git-send-email-johannes@sipsolutions.net> (sfid-20120821_190213_500011_F7AA929C)
In-Reply-To: <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
References: <1345568455.10280.11.camel@jlt3.sipsolutions.net>
 <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

If registration with mac80211 fails, stop the thermal
throttling and testmode work that were previously started.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 84d3db5..e8ffbe4 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1473,6 +1473,9 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	return op_mode;
 
 out_destroy_workqueue:
+	iwl_tt_exit(priv);
+	iwl_testmode_free(priv);
+	iwl_cancel_deferred_work(priv);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	iwl_uninit_drv(priv);
-- 
1.7.10.4

