Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47066 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab1L0QEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 11:04:12 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] mac80211: minor cleanup
Date: Tue, 27 Dec 2011 21:34:01 +0530
Message-ID: <1325001841-1881-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111227_170416_504310_06D7C3D0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

if we had set 'fixed-freq' paramter in iw ibss join command,
scan request won't be intiated in this path with the state
'IEEE80211_IBSS_MLME_JOINED'

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

