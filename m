Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:64466 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaCDRgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 12:36:45 -0500
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 1/2] iwlwifi: mvm: don't WARN when statistics are handled late
Date: Tue,  4 Mar 2014 19:36:38 +0200
Message-Id: <1393954599-11270-1-git-send-email-egrumbach@gmail.com> (sfid-20140304_183649_771386_F535A2AD)
In-Reply-To: <53160EF4.8090005@gmail.com>
References: <53160EF4.8090005@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the statistics handler is asynchrous, it can very well
be that we will handle the statistics (hence the RSSI
fluctuation) when we already disassociated.
Don't WARN on this case.

This solves: https://bugzilla.redhat.com/show_bug.cgi?id=1071998

Cc: <stable@vger.kernel.org> [3.10+]
Fixes: 2b76ef13086f ("iwlwifi: mvm: implement reduced Tx power")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index 76cde6c..18a895a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -872,8 +872,11 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* Rssi update while not associated ?! */
-	if (WARN_ON_ONCE(mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT))
+	/*
+	 * Rssi update while not associated - can happen since the statistics
+	 * are handled asynchronously
+	 */
+	if (mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT)
 		return;
 
 	/* No BT - reports should be disabled */
-- 
1.8.3.2

