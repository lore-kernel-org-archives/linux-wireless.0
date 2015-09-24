Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41640 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbbIXOVX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 10:21:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: reduce indentation by inlining a check
Date: Thu, 24 Sep 2015 16:21:16 +0200
Message-Id: <1443104477-26034-1-git-send-email-johannes@sipsolutions.net> (sfid-20150924_162143_551683_EC36A0A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of nesting two if statements, inline the second
check into the first if statement and to indentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c7d316b440ef..88894d9a25b2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3437,31 +3437,27 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					  len - baselen, false, &elems,
 					  care_about_ies, ncrc);
 
-	if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK)) {
-		bool directed_tim = ieee80211_check_tim(elems.tim,
-							elems.tim_len,
-							ifmgd->aid);
-		if (directed_tim) {
-			if (local->hw.conf.dynamic_ps_timeout > 0) {
-				if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-					local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-					ieee80211_hw_config(local,
-							    IEEE80211_CONF_CHANGE_PS);
-				}
-				ieee80211_send_nullfunc(local, sdata, 0);
-			} else if (!local->pspolling && sdata->u.mgd.powersave) {
-				local->pspolling = true;
-
-				/*
-				 * Here is assumed that the driver will be
-				 * able to send ps-poll frame and receive a
-				 * response even though power save mode is
-				 * enabled, but some drivers might require
-				 * to disable power save here. This needs
-				 * to be investigated.
-				 */
-				ieee80211_send_pspoll(local, sdata);
+	if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) &&
+	    ieee80211_check_tim(elems.tim, elems.tim_len, ifmgd->aid)) {
+		if (local->hw.conf.dynamic_ps_timeout > 0) {
+			if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+				local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+				ieee80211_hw_config(local,
+						    IEEE80211_CONF_CHANGE_PS);
 			}
+			ieee80211_send_nullfunc(local, sdata, 0);
+		} else if (!local->pspolling && sdata->u.mgd.powersave) {
+			local->pspolling = true;
+
+			/*
+			 * Here is assumed that the driver will be
+			 * able to send ps-poll frame and receive a
+			 * response even though power save mode is
+			 * enabled, but some drivers might require
+			 * to disable power save here. This needs
+			 * to be investigated.
+			 */
+			ieee80211_send_pspoll(local, sdata);
 		}
 	}
 
-- 
2.5.1

