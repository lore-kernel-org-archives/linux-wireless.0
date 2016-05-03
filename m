Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39616 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932762AbcECNFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 09:05:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  3 May 2016 16:05:02 +0300
Message-Id: <1462280702-20438-1-git-send-email-luca@coelho.fi> (sfid-20160503_150519_283240_1E2D82C5)
Subject: [PATCH] mac80211: remove disconnected APs from BSS table
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

In some cases, after a sudden AP disappearing and reconnection to
another AP in the same ESS, user space gets the old AP in scan
results (cached). User space may decide to roam to that old AP
which will cause a disconnection and longer recovery.
Remove APs that are probably out of range from BSS table.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 885f4ca..8d426f6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2399,6 +2399,11 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 
+	/* AP is probably out of range (or not reachable for another reason) so
+	 * remove the bss struct for that AP.
+	 */
+	cfg80211_unlink_bss(local->hw.wiphy, ifmgd->associated);
+
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
 			       true, frame_buf);
-- 
2.8.0.rc3

