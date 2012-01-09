Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab2AIM5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 07:57:39 -0500
Subject: [PATCH] mac80211: refactor __ieee80211_get_channel_mode
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 13:57:36 +0100
Message-ID: <1326113856.3451.22.camel@jlt3.sipsolutions.net> (sfid-20120109_135743_048185_8DFEF3B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use a switch statement instead of a list of if
statements. Also include AP_VLAN in the list
and skip them since the AP interface will also
be looked at.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/net/mac80211/chan.c	2011-11-03 13:48:28.000000000 +0100
+++ b/net/mac80211/chan.c	2012-01-09 13:55:14.000000000 +0100
@@ -20,23 +20,29 @@ __ieee80211_get_channel_mode(struct ieee
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
-		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_MONITOR:
 			continue;
-
-		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-		    !sdata->u.mgd.associated)
-			continue;
-
-		if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		case NL80211_IFTYPE_STATION:
+			if (!sdata->u.mgd.associated)
+				continue;
+			break;
+		case NL80211_IFTYPE_ADHOC:
 			if (!sdata->u.ibss.ssid_len)
 				continue;
 			if (!sdata->u.ibss.fixed_channel)
 				return CHAN_MODE_HOPPING;
-		}
-
-		if (sdata->vif.type == NL80211_IFTYPE_AP &&
-		    !sdata->u.ap.beacon)
+			break;
+		case NL80211_IFTYPE_AP_VLAN:
+			/* will also have _AP interface */
 			continue;
+		case NL80211_IFTYPE_AP:
+			if (!sdata->u.ap.beacon)
+				continue;
+			break;
+		default:
+			break;
+		}
 
 		return CHAN_MODE_FIXED;
 	}


