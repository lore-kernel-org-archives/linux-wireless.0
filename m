Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm14.bullet.mail.ukl.yahoo.com ([217.146.183.188]:47592 "HELO
	nm14.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934067Ab1IOQKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 12:10:30 -0400
From: Marek Lindner <lindner_marek@yahoo.de>
To: linux-wireless@vger.kernel.org
Cc: Marek Lindner <lindner_marek@yahoo.de>
Subject: [PATCH] mac80211: don't allow zero mac bssid to be configured
Date: Thu, 15 Sep 2011 18:07:23 +0200
Message-Id: <1316102844-29970-1-git-send-email-lindner_marek@yahoo.de> (sfid-20110915_181048_539834_E4954A19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
---
 net/mac80211/ibss.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 4f9235b..9c7991e 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -588,12 +588,10 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	capability = WLAN_CAPABILITY_IBSS;
 	if (ifibss->privacy)
 		capability |= WLAN_CAPABILITY_PRIVACY;
-	if (ifibss->fixed_bssid)
+	if (ifibss->fixed_bssid && !is_zero_ether_addr(ifibss->bssid))
 		bssid = ifibss->bssid;
 	if (ifibss->fixed_channel)
 		chan = ifibss->channel;
-	if (!is_zero_ether_addr(ifibss->bssid))
-		bssid = ifibss->bssid;
 	cbss = cfg80211_get_bss(local->hw.wiphy, chan, bssid,
 				ifibss->ssid, ifibss->ssid_len,
 				WLAN_CAPABILITY_IBSS | WLAN_CAPABILITY_PRIVACY,
-- 
1.7.5.4

