Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:49561 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab2FSV7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 17:59:42 -0400
Received: from mail0.frost.chambana.net (mail0.frost.chambana.net [209.66.96.68])
	by www19.servergod.com (Postfix) with ESMTP id 87A5E11FFEE
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 14:59:42 -0700 (PDT)
Received: by mail0.frost.chambana.net (Postfix) with SMTP id 44BBB59A067
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 21:59:42 +0000
From: Will Hawkins <hawkinsw@opentechinstitute.org>
To: hawkinsw@opentechinstitute.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 2/3] mac80211: Check auth frame registration count
Date: Tue, 19 Jun 2012 17:59:13 -0400
Message-Id: <4ae0ad92e1f9e353497820c5196d80d28bb3f782.1340142553.git.hawkinsw@opentechinstitute.org> (sfid-20120619_235947_088865_835093B4)
In-Reply-To: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
References: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
In-Reply-To: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
References: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the auth frame registration count before sending
"open system" authentication messages when a new station
registers on a particular adhoc network. This
stops a station from sending out multiple authentication
messages with different authentication algorithms.

Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>
---
 net/mac80211/ibss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 725cb4b..ff46ff4 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -279,7 +279,7 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
 	/* If it fails, maybe we raced another insertion? */
 	if (sta_info_insert_rcu(sta))
 		return sta_info_get(sdata, addr);
-	if (auth) {
+	if (auth && !sdata->u.ibss.auth_frame_registrations) {
 		ibss_vdbg("TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=1)\n",
 			  sdata->vif.addr, sdata->u.ibss.bssid, addr);
 		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
-- 
1.7.9.5


