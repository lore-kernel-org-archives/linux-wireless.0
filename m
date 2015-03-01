Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbbCAHKs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:48 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/16] mac80211: update TDLS sta spatial streams before auth
Date: Sun,  1 Mar 2015 09:10:11 +0200
Message-Id: <1425193815-17785-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_083416_868431_B3D273E6)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Make sure the number of spatial streams is correctly updated for a TDLS
station. Usually this is done during rate control init, during the
add_station nl80211 command. Unfortunately TDLS stations only get valid
HT/VHT-cap information in the change_station nl80211 command, and
rate-control init is delayed accordingly.

Some drivers (iwlwifi) assume the nss will be appropriately during the
sta_state(assoc) callback, and this doesn't hold for TDLS. Initialize
the nss earlier for TDLS peers, which also has the benefit of making
sta_state behavior more consistent.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 02f1125..bc33911 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1126,6 +1126,10 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
 						    params->vht_capa, sta);
 
+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
+	    (params->ht_capa || params->vht_capa))
+		ieee80211_sta_set_rx_nss(sta);
+
 	if (params->opmode_notif_used) {
 		/* returned value is only needed for rc update, but the
 		 * rc isn't initialized here yet, so ignore it
-- 
1.9.1

