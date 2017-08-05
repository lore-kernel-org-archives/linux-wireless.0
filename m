Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42284 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751443AbdHEIpX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 04:45:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 11:44:29 +0300
Message-Id: <20170805084438.12550-2-luca@coelho.fi> (sfid-20170805_110252_133861_A783934F)
In-Reply-To: <20170805084438.12550-1-luca@coelho.fi>
References: <20170805084438.12550-1-luca@coelho.fi>
Subject: [PATCH 01/10] mac80211: add MESH IE in the correct order
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

VHT MESH support was added, but the order of the IEs
wasn't enforced. Fix that.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 259698de569f..6aef6793d052 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1436,7 +1436,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 			WLAN_EID_SSID_LIST,
 			WLAN_EID_CHANNEL_USAGE,
 			WLAN_EID_INTERWORKING,
-			/* mesh ID can't happen here */
+			WLAN_EID_MESH_ID,
 			/* 60 GHz can't happen here right now */
 		};
 		noffset = ieee80211_ie_split(ie, ie_len,
-- 
2.13.2
