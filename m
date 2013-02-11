Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43173 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab3BKMmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 07:42:11 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/14] mac80211: disable HT/VHT if AP has no HT/VHT capability
Date: Mon, 11 Feb 2013 13:38:14 +0100
Message-Id: <1360586298-15028-11-git-send-email-johannes@sipsolutions.net> (sfid-20130211_134939_423296_3F820BE4)
In-Reply-To: <1360586298-15028-1-git-send-email-johannes@sipsolutions.net>
References: <[PATCH 00/14] mac80211: HT/VHT handling>
 <1360586298-15028-1-git-send-email-johannes@sipsolutions.net>
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
index 2d8deaa..6e6031e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3588,16 +3588,22 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 
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
@@ -3610,6 +3616,12 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
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

