Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:58025 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2JZQzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 12:55:09 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH mac80211] mac80211: fix SSID copy on IBSS JOIN
Date: Fri, 26 Oct 2012 18:54:25 +0200
Message-Id: <1351270465-18946-1-git-send-email-ordex@autistici.org> (sfid-20121026_185526_836763_D58FF7A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'ssid' field of the cfg80211_ibss_params is a u8 pointer and therefore the
length is likely to be less than IEEE80211_MAX_SSID_LEN most of the times.

This patch fixes the ssid copy in ieee80211_ibss_join() by preventing it from
reading beyond the string.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 net/mac80211/ibss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5f3620f..bf87c70 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1108,7 +1108,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
 	sdata->u.ibss.ibss_join_req = jiffies;
 
-	memcpy(sdata->u.ibss.ssid, params->ssid, IEEE80211_MAX_SSID_LEN);
+	memcpy(sdata->u.ibss.ssid, params->ssid, params->ssid_len);
 	sdata->u.ibss.ssid_len = params->ssid_len;
 
 	mutex_unlock(&sdata->u.ibss.mtx);
-- 
1.7.12.4

