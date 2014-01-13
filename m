Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36960 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaAMUWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:10 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so3319295eek.18
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:09 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/18] iwlwifi: mvm: don't set the drain bit when we flush the AP station
Date: Mon, 13 Jan 2014 22:21:44 +0200
Message-Id: <1389644517-22807-5-git-send-email-egrumbach@gmail.com> (sfid-20140113_212215_363768_E8B15394)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we disassociate in managed mode, we flush the queues
after mac80211 has already removed the station.
During that time, the pointer to ieee80211_sta to the
fw_id_to_mac_id map is -EINVAL. In that case we should not
set the station as being drained when the last Tx of this
station has exited the shared Tx queue since we are
flushing all the queues anyway.
The draining logic is meant to be used in GO / AP mode only.
In GO / AP mode, we set -EBUSY in the fw_id_to_mac_id map.

This is why testing the ieee80211_sta pointer in the
fw_id_to_mac_id map with IS_ERR isn't enough to set the
station as draining, we need to check that it is -EBUSY.

The only impact of the bug was a print:

Drained sta 1, but it is internal?

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 3c575a3..a4d3bce 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -704,7 +704,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			 */
 			spin_lock_bh(&mvmsta->lock);
 			sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
-			if (IS_ERR_OR_NULL(sta)) {
+			if (!sta || PTR_ERR(sta) == -EBUSY) {
 				/*
 				 * Station disappeared in the meantime:
 				 * so we are draining.
@@ -713,7 +713,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 				schedule_work(&mvm->sta_drained_wk);
 			}
 			spin_unlock_bh(&mvmsta->lock);
-		} else if (!mvmsta) {
+		} else if (!mvmsta && PTR_ERR(sta) == -EBUSY) {
 			/* Tx response without STA, so we are draining */
 			set_bit(sta_id, mvm->sta_drained);
 			schedule_work(&mvm->sta_drained_wk);
-- 
1.7.9.5

