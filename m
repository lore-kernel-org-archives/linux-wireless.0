Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62196 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2AGPgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 10:36:31 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] mac80211: minor cleanup
Date: Sat, 7 Jan 2012 21:06:21 +0530
Message-ID: <1325950581-6228-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120107_163634_924500_74E4535D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

we would have bailed out if 'ifibss->fixed_channel'
is valid i.e. we had used 'fixed-freq' parameter in iw ibss
join command. this is with the state 'IEEE80211_IBSS_MLME_JOINED'
so no need to check for it

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/ibss.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f8a32bf..8875673 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -642,8 +642,7 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 	       "IBSS networks with same SSID (merge)\n", sdata->name);
 
 	ieee80211_request_internal_scan(sdata,
-			ifibss->ssid, ifibss->ssid_len,
-			ifibss->fixed_channel ? ifibss->channel : NULL);
+			ifibss->ssid, ifibss->ssid_len, NULL);
 }
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
-- 
1.7.0.4

