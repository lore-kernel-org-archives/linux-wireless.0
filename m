Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62664 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaLNJKu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2014 04:10:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Moshe Benji <Moshe.Benji@intel.com>,
	Moshe Benji <moshe.benji@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/4] mac80211: handle power constraint and country IEs in RRM
Date: Sun, 14 Dec 2014 11:05:50 +0200
Message-Id: <1418547953-17699-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141214_101110_594639_605B2A1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Moshe Benji <Moshe.Benji@intel.com>

In beacons, handle the Country IE even if no Power Constraint IE
is present, and, capability wise, also in case that the Radio
Measurements capability is enabled.

In cases where the Country IE should be handled and that the
Power Constraint IE is not present, the Country IE alone will
set the power limit (and not both Country and Power Constraint
IEs).

Signed-off-by: Moshe Benji <moshe.benji@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9ae4c48..31281fa 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1287,8 +1287,11 @@ ieee80211_find_80211h_pwr_constr(struct ieee80211_sub_if_data *sdata,
 		country_ie_len -= 3;
 	}
 
-	if (have_chan_pwr)
+	if (have_chan_pwr && pwr_constr_elem)
 		*pwr_reduction = *pwr_constr_elem;
+	else
+		*pwr_reduction = 0;
+
 	return have_chan_pwr;
 }
 
@@ -1317,10 +1320,11 @@ static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	int chan_pwr = 0, pwr_reduction_80211h = 0;
 	int pwr_level_cisco, pwr_level_80211h;
 	int new_ap_level;
+	__le16 capab = mgmt->u.probe_resp.capab_info;
 
-	if (country_ie && pwr_constr_ie &&
-	    mgmt->u.probe_resp.capab_info &
-		cpu_to_le16(WLAN_CAPABILITY_SPECTRUM_MGMT)) {
+	if (country_ie &&
+	    (capab & cpu_to_le16(WLAN_CAPABILITY_SPECTRUM_MGMT) ||
+	     capab & cpu_to_le16(WLAN_CAPABILITY_RADIO_MEASURE))) {
 		has_80211h_pwr = ieee80211_find_80211h_pwr_constr(
 			sdata, channel, country_ie, country_ie_len,
 			pwr_constr_ie, &chan_pwr, &pwr_reduction_80211h);
-- 
1.9.1

