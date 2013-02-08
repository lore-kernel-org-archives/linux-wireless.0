Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3BHR2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:28:42 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 10/14] mac80211: disable HT/VHT if AP has no HT/VHT capability
Date: Fri,  8 Feb 2013 18:25:40 +0100
Message-Id: <1360344344-15742-11-git-send-email-johannes@sipsolutions.net> (sfid-20130208_190812_429304_007E97DC)
In-Reply-To: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Having HT/VHT operation IEs but not capability IEs
leads to a strange situation where we configure the
channel to an HT or VHT bandwidth and then can't
actually use it. Prevent this by checking that the
HT and VHT capability IEs are present as well as
the operation IEs; if not, disable HT and/or VHT.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1ef3efe..440e448 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3573,16 +3573,22 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT) &&
 	    sband->ht_cap.ht_supported) {
-		const u8 *ht_oper_ie;
+		const u8 *ht_oper_ie, *ht_cap;
 
 		ht_oper_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_OPERATION);
 		if (ht_oper_ie && ht_oper_ie[1] >= sizeof(*ht_oper))
 			ht_oper = (void *)(ht_oper_ie + 2);
+
+		ht_cap = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_CAPABILITY);
+		if (!ht_cap || ht_cap[1] < sizeof(struct ieee80211_ht_cap)) {
+			ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
+			ht_oper = NULL;
+		}
 	}
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT) &&
 	    sband->vht_cap.vht_supported) {
-		const u8 *vht_oper_ie;
+		const u8 *vht_oper_ie, *vht_cap;
 
 		vht_oper_ie = ieee80211_bss_get_ie(cbss,
 						   WLAN_EID_VHT_OPERATION);
@@ -3595,6 +3601,12 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 			ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
 			ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
 		}
+
+		vht_cap = ieee80211_bss_get_ie(cbss, WLAN_EID_VHT_CAPABILITY);
+		if (!vht_cap || vht_cap[1] < sizeof(struct ieee80211_vht_cap)) {
+			ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
+			vht_oper = NULL;
+		}
 	}
 
 	ifmgd->flags |= ieee80211_determine_chantype(sdata, sband,
-- 
1.8.0

