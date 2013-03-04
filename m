Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab3CDOA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:00:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/11] iwlwifi: mvm: ignore STOP_AGG when restarting
Date: Mon,  4 Mar 2013 15:00:49 +0100
Message-Id: <1362405651-26456-9-git-send-email-johannes@sipsolutions.net> (sfid-20130304_150107_126938_23DF5803)
In-Reply-To: <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
References: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
 <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the device is being restarted, all the Rx / Tx Block
Ack sessions are been wiped out by the driver. So ignore
the requests from mac80211 that stops Tx agg while
reconfiguring the device.

Note that stopping a non-existing Rx BA session is harmless,
so just honor mac80211's request.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 861a7f9..274f44e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -770,6 +770,16 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	u16 txq_id;
 	int err;
 
+
+	/*
+	 * If mac80211 is cleaning its state, then say that we finished since
+	 * our state has been cleared anyway.
+	 */
+	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		return 0;
+	}
+
 	spin_lock_bh(&mvmsta->lock);
 
 	txq_id = tid_data->txq_id;
-- 
1.8.0

