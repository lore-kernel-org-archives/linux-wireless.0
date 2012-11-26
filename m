Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2KZLCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 06:02:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix managed mode channel flags handling
Date: Mon, 26 Nov 2012 12:02:34 +0100
Message-Id: <1353927754-17265-1-git-send-email-johannes@sipsolutions.net> (sfid-20121126_120213_647898_7E3AD214)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If ieee80211_prep_channel() decides that HT should be
disabled (because the HT IEs from the AP were invalid)
it will set the IEEE80211_STA_DISABLE_HT to not send
HT capabilities to the AP when associating. If this
happens during authentication, the flag will be lost
and we send HT frames, even if the channel config was
set up for non-HT. This can lead to issues.

Fix this by always resetting the ifmgd flags to zero
when the channel context is released so that the flag
resetting in ieee80211_mgd_assoc() isn't necessary.

To make the code a bit easier move the call to release
the channel in ieee80211_set_disassoc() to the end of
the function together with the flag resetting (which
needs to be at the end to avoid timers setting flags.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6d49d6c..d8208f1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1528,8 +1528,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	changed |= BSS_CHANGED_BSSID | BSS_CHANGED_HT;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
-	ieee80211_vif_release_channel(sdata);
-
 	/* disassociated - set to defaults now */
 	ieee80211_set_wmm_default(sdata, false);
 
@@ -1539,6 +1537,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
 
 	sdata->u.mgd.timers_running = 0;
+
+	ifmgd->flags = 0;
+	ieee80211_vif_release_channel(sdata);
 }
 
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
@@ -1864,6 +1865,7 @@ static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
 
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+		ifmgd->flags = 0;
 		ieee80211_vif_release_channel(sdata);
 	}
 
@@ -2106,6 +2108,7 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+		ifmgd->flags = 0;
 		ieee80211_vif_release_channel(sdata);
 	}
 
@@ -3536,13 +3539,6 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	/* prepare assoc data */
 	
-	/*
-	 * keep only the 40 MHz disable bit set as it might have
-	 * been set during authentication already, all other bits
-	 * should be reset for a new connection
-	 */
-	ifmgd->flags &= IEEE80211_STA_DISABLE_40MHZ;
-
 	ifmgd->beacon_crc_valid = false;
 
 	/*
-- 
1.8.0

