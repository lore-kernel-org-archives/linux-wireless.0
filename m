Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43892 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaEGTyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:54:04 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so1488731wgg.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:54:03 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/23] iwlwifi: mvm: wait for d0i3 exit in some more ampdu actions
Date: Wed,  7 May 2014 22:52:56 +0300
Message-Id: <1399492380-12050-19-git-send-email-egrumbach@gmail.com> (sfid-20140507_215415_347056_B9E358E6)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Some ampdu actions change queues by direct target access.

Since the bus is disabled in d0i3, make sure to exit d0i3
before handling these actions.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 97c3dea..db55d67 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -539,13 +539,22 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 		return -EACCES;
 
 	/* return from D0i3 before starting a new Tx aggregation */
-	if (action == IEEE80211_AMPDU_TX_START) {
+	switch (action) {
+	case IEEE80211_AMPDU_TX_START:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		iwl_mvm_ref(mvm, IWL_MVM_REF_TX_AGG);
 		tx_agg_ref = true;
 
 		/*
-		 * wait synchronously until D0i3 exit to get the correct
-		 * sequence number for the tid
+		 * for tx start, wait synchronously until D0i3 exit to
+		 * get the correct sequence number for the tid.
+		 * additionally, some other ampdu actions use direct
+		 * target access, which is not handled automatically
+		 * by the trans layer (unlike commands), so wait for
+		 * d0i3 exit in these cases as well.
 		 */
 		if (!wait_event_timeout(mvm->d0i3_exit_waitq,
 			  !test_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status), HZ)) {
@@ -553,6 +562,9 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 			iwl_mvm_unref(mvm, IWL_MVM_REF_TX_AGG);
 			return -EIO;
 		}
+		break;
+	default:
+		break;
 	}
 
 	mutex_lock(&mvm->mutex);
-- 
1.8.3.2

