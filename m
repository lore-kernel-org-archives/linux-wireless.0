Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54196 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1CJC4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 21:56:01 -0500
Received: by iyb26 with SMTP id 26so1111757iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 18:56:00 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 9 Mar 2011 18:56:00 -0800
Message-ID: <AANLkTimm0umg3rZDwYU4KGLbaCQgAA_QKCpoY9NiscLT@mail.gmail.com>
Subject: [PATCH] mac80211: do not enable ps if 802.1x controlled port is unblocked
From: Jason Young <a.young.jason@gmail.com>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If dynamic_ps is disabled, enabling power save before the 4-way
handshake completes may delay the station from being authorized to
send/receive traffic, i.e. increase roaming times. It may also result in
a failed 4-way handshake depending on the AP's timing requirements and
beacon interval, and the station's listen interval.

To fix this, prevent power save from being enabled while the station
isn't authorized and recalculate power save whenever the station's
authorized state changes.

Signed-off-by: Jason Young <a.young.jason@gmail.com>
---
 net/mac80211/cfg.c  |    3 +++
 net/mac80211/mlme.c |   37 ++++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7b701dc..6a7bdeb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -834,6 +834,9 @@ static int ieee80211_change_station(struct wiphy *wiphy,

 	rcu_read_unlock();

+	if (params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED))
+		ieee80211_recalc_ps(local, -1);
+
 	return 0;
 }

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cc984bd..64d92d5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -613,6 +613,37 @@ static void ieee80211_change_ps(struct
ieee80211_local *local)
 	}
 }

+static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *mgd = &sdata->u.mgd;
+	struct sta_info *sta = NULL;
+	u32 sta_flags = 0;
+
+	if (!mgd->powersave)
+		return false;
+
+	if (!mgd->associated)
+		return false;
+
+	if (!mgd->associated->beacon_ies)
+		return false;
+
+	if (mgd->flags & (IEEE80211_STA_BEACON_POLL |
+			  IEEE80211_STA_CONNECTION_POLL))
+		return false;
+
+	rcu_read_lock();
+	sta = sta_info_get(sdata, mgd->bssid);
+	if (sta)
+		sta_flags = get_sta_flags(sta);
+	rcu_read_unlock();
+
+	if (!(sta_flags & WLAN_STA_AUTHORIZED))
+		return false;
+
+	return true;
+}
+
 /* need to hold RTNL or interface lock */
 void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 {
@@ -647,11 +678,7 @@ void ieee80211_recalc_ps(struct ieee80211_local
*local, s32 latency)
 		count++;
 	}

-	if (count == 1 && found->u.mgd.powersave &&
-	    found->u.mgd.associated &&
-	    found->u.mgd.associated->beacon_ies &&
-	    !(found->u.mgd.flags & (IEEE80211_STA_BEACON_POLL |
-				    IEEE80211_STA_CONNECTION_POLL))) {
+	if (count == 1 && ieee80211_powersave_allowed(found)) {
 		struct ieee80211_conf *conf = &local->hw.conf;
 		s32 beaconint_us;

-- 
1.7.2.2

-- 
Jason Young
