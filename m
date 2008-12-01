Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53400 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbYLAUQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 15:16:23 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, dcbw@redhat.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: deauth when interface is marked down
Date: Mon,  1 Dec 2008 15:02:04 -0500
Message-Id: <1228161724-19771-1-git-send-email-linville@tuxdriver.com> (sfid-20081201_211628_927304_9E7C6F59)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems like proper etiquette to let other stations know when we are
going down in either STA or IBSS mode.  This also notifies userland, so
wpa_supplicant doesn't get confused.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/iface.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4608212..b557250 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -435,6 +435,9 @@ static int ieee80211_stop(struct net_device *dev)
 		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+		/* Announce that we are leaving the network. */
+		ieee80211_sta_deauthenticate(dev, WLAN_REASON_DEAUTH_LEAVING);
+
 		sdata->u.sta.state = IEEE80211_STA_MLME_DISABLED;
 		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
 		del_timer_sync(&sdata->u.sta.timer);
-- 
1.5.4.3

