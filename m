Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3CAQfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 11:35:15 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] mac80211: fix VHT MCS calculation
Date: Fri,  1 Mar 2013 17:35:09 +0100
Message-Id: <1362155709-28944-1-git-send-email-johannes@sipsolutions.net> (sfid-20130301_173520_963881_6D1EB08B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The VHT MCSes we advertise to the AP were supposed to
be restricted to the AP, but due to a bug in the logic
mac80211 will advertise rates to the AP that aren't
even supported by the local device. To fix this skip
any adjustment if the stream isn't supported at all.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b756d29..1415774 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -647,6 +647,9 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 		our_mcs = (le16_to_cpu(vht_cap.vht_mcs.rx_mcs_map) &
 								mask) >> shift;
 
+		if (our_mcs == IEEE80211_VHT_MCS_NOT_SUPPORTED)
+			continue;
+
 		switch (ap_mcs) {
 		default:
 			if (our_mcs <= ap_mcs)
-- 
1.8.0

