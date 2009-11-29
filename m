Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZK2LTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 06:19:05 -0500
Subject: [PATCH] mac80211: recalculate idle later in MLME
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Nov 2009 12:19:06 +0100
Message-ID: <1259493546.32171.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hwsim testing has revealed that when the MLME
recalculates the idle state of the device, it
sometimes does so before sending the final
deauthentication or disassociation frame. This
patch changes the place where the idle state
is recalculated, but of course driver transmit
is typically asynchronous while configuration
is expected to be synchronous, so it doesn't
fix all possible cases yet.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-11-29 11:33:01.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-11-29 11:33:47.000000000 +0100
@@ -1083,8 +1083,6 @@ static void ieee80211_set_disassoc(struc
 
 	ieee80211_set_wmm_default(sdata);
 
-	ieee80211_recalc_idle(local);
-
 	/* channel(_type) changes are handled by ieee80211_hw_config */
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 
@@ -1370,6 +1368,7 @@ ieee80211_rx_mgmt_deauth(struct ieee8021
 
 	if (!wk) {
 		ieee80211_set_disassoc(sdata, true);
+		ieee80211_recalc_idle(sdata->local);
 	} else {
 		list_del(&wk->list);
 		kfree(wk);
@@ -1403,6 +1402,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 			sdata->name, mgmt->sa, reason_code);
 
 	ieee80211_set_disassoc(sdata, false);
+	ieee80211_recalc_idle(sdata->local);
 	return RX_MGMT_CFG80211_DISASSOC;
 }
 
@@ -2117,6 +2117,7 @@ static void ieee80211_sta_work(struct wo
 				" after %dms, disconnecting.\n",
 				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
 			ieee80211_set_disassoc(sdata, true);
+			ieee80211_recalc_idle(local);
 			mutex_unlock(&ifmgd->mtx);
 			/*
 			 * must be outside lock due to cfg80211,
@@ -2560,6 +2561,8 @@ int ieee80211_mgd_deauth(struct ieee8021
 			IEEE80211_STYPE_DEAUTH, req->reason_code,
 			cookie);
 
+	ieee80211_recalc_idle(sdata->local);
+
 	return 0;
 }
 
@@ -2592,5 +2595,8 @@ int ieee80211_mgd_disassoc(struct ieee80
 	ieee80211_send_deauth_disassoc(sdata, req->bss->bssid,
 			IEEE80211_STYPE_DISASSOC, req->reason_code,
 			cookie);
+
+	ieee80211_recalc_idle(sdata->local);
+
 	return 0;
 }


