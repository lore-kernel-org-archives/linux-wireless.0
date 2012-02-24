Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60445 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab2BXMwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 07:52:14 -0500
Message-Id: <20120224125138.872274431@sipsolutions.net> (sfid-20120224_135223_600523_2222FFD2)
Date: Fri, 24 Feb 2012 13:50:53 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] mac80211: fix ieee80211_set_disassoc() sending DelBA
References: <20120224125050.809601111@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When ieee80211_set_disassoc() is called with the
tx argument set to true, it will send DelBA out
to the peer. This isn't useful or necessary in a
few cases where we do it today, those being when
we lost the connection or when the supplicant
explicitly asked us to not tell the AP.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/mac80211/mlme.c	2012-02-24 13:50:20.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-02-24 13:50:22.000000000 +0100
@@ -1684,7 +1684,7 @@ static void __ieee80211_connection_loss(
 	printk(KERN_DEBUG "%s: Connection to AP %pM lost.\n",
 	       sdata->name, bssid);
 
-	ieee80211_set_disassoc(sdata, true, true);
+	ieee80211_set_disassoc(sdata, true, false);
 	mutex_unlock(&ifmgd->mtx);
 
 	/*
@@ -2699,7 +2699,7 @@ static void ieee80211_sta_connection_los
 	ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 			  IEEE80211_STA_BEACON_POLL);
 
-	ieee80211_set_disassoc(sdata, true, true);
+	ieee80211_set_disassoc(sdata, true, false);
 	mutex_unlock(&ifmgd->mtx);
 	/*
 	 * must be outside lock due to cfg80211,
@@ -3497,7 +3497,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 	       sdata->name, req->bss->bssid, req->reason_code);
 
 	memcpy(bssid, req->bss->bssid, ETH_ALEN);
-	ieee80211_set_disassoc(sdata, false, true);
+	ieee80211_set_disassoc(sdata, false, !req->local_state_change);
 
 	mutex_unlock(&ifmgd->mtx);
 


