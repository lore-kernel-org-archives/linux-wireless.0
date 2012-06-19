Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:57020 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab2FSAUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 20:20:06 -0400
Message-ID: <4FDFC5B5.5000009@opentechinstitute.org> (sfid-20120619_022011_571722_B2E29C73)
Date: Mon, 18 Jun 2012 20:20:05 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linville@tuxdriver.com
Subject: [PATCH 2/2 v3] mac80211/cfg80211: add support for userspace to handle
 auth frames on adhoc ifaces
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the necessary flags to allow user space applications to register for
authentication frames on adhoc interfaces. Also, check to make sure that
"open" authentication frames are not sent when a userspace application
is registered for authentication frames.

Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>
---
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 725cb4b..5709dcb 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -279,7 +279,8 @@ static struct sta_info
*ieee80211_ibss_finish_sta(struct sta_info *sta,
 	/* If it fails, maybe we raced another insertion? */
 	if (sta_info_insert_rcu(sta))
 		return sta_info_get(sdata, addr);
-	if (auth) {
+	if (auth && !cfg80211_mgmt_reg_match(sdata->dev,
+	    	IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_AUTH)) {
 		ibss_vdbg("TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=1)\n",
 			  sdata->vif.addr, sdata->u.ibss.bssid, addr);
 		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d81c178..4467162 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -455,7 +455,9 @@ static const struct ieee80211_txrx_stypes
 ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	[NL80211_IFTYPE_ADHOC] = {
 		.tx = 0xffff,
-		.rx = BIT(IEEE80211_STYPE_ACTION >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_DEAUTH >> 4),
 	},
 	[NL80211_IFTYPE_STATION] = {
 		.tx = 0xffff,
