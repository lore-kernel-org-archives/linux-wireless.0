Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:55451 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab2AZMgz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:36:55 -0500
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Do not scan for IBSS merge with a fixed BSSID.
Date: Thu, 26 Jan 2012 13:36:34 +0100
Message-Id: <1327581394-15368-1-git-send-email-cavallar@lri.fr> (sfid-20120126_133659_805161_39F32A75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, when we are on an IBSS network with no active station,
we would scan for other BSSID, even if fixed_bssid is on,  due to
a bug in ibss.c,  where fixed_channel would be checked instead of
fixed_bssid.  This would trigger useless scans where scan results
would not be used anyway.

This patch also reverts commit 39d02a7d90602d4557ee05db2a157a4e0,
which assumed that the ifibss->fixed_channel check was legitimate
to disable single-channel scans.  IBSS single-channel scan should
now be fixed.

Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
---
 net/mac80211/ibss.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 9d8e699..22f7099 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -656,14 +656,15 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 	if (ieee80211_sta_active_ibss(sdata))
 		return;
 
-	if (ifibss->fixed_channel)
+	if (ifibss->fixed_bssid)
 		return;
 
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->name);
 
 	ieee80211_request_internal_scan(sdata,
-			ifibss->ssid, ifibss->ssid_len, NULL);
+			ifibss->ssid, ifibss->ssid_len,
+			ifibss->fixed_channel ? ifibss->channel : NULL);
 }
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
-- 
1.7.8.3

