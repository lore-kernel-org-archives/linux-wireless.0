Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab2FYHgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 03:36:46 -0400
Message-ID: <1340609801.4589.4.camel@jlt3.sipsolutions.net> (sfid-20120625_093649_672186_A5277CAE)
Subject: [PATCH 3.5] iwlwifi: fix activating inactive stations
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 25 Jun 2012 09:36:41 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When authentication/association timed out, the driver would
complain bitterly, printing the message
ACTIVATE a non DRIVER active station id ... addr ...

The cause turns out to be that when the AP station is added
but we don't associate, the IWL_STA_UCODE_INPROGRESS is set
but never cleared. This then causes iwl_restore_stations()
to attempt to resend it because it uses the flag internally
and uploads even if it didn't set it itself.

To fix this issue and not upload the station again when it
has already been removed by mac80211, clear the flag after
adding it in case we add it only for association.

Cc: stable@vger.kernel.org
Reviewed-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
John, will you take one more patch for 3.5? :-)

I *think* this warning is mostly harmless, but it's really annoying,
trips up users and it might also confuse the firmware if we upload that
station over and over again.


 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 3ee23134..0136803 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -796,6 +796,18 @@ int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 	switch (op) {
 	case ADD:
 		ret = iwlagn_mac_sta_add(hw, vif, sta);
+		if (ret)
+			break;
+		/*
+		 * Clear the in-progress flag, the AP station entry was added
+		 * but we'll initialize LQ only when we've associated (which
+		 * would also clear the in-progress flag). This is necessary
+		 * in case we never initialize LQ because association fails.
+		 */
+		spin_lock_bh(&priv->sta_lock);
+		priv->stations[iwl_sta_id(sta)].used &=
+			~IWL_STA_UCODE_INPROGRESS;
+		spin_unlock_bh(&priv->sta_lock);
 		break;
 	case REMOVE:
 		ret = iwlagn_mac_sta_remove(hw, vif, sta);
-- 
1.7.10



