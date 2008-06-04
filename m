Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27345 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbYFDR2O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 13:28:14 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH 1/1] mac80211: Fixing slow IBSS rejoin
Date: Wed,  4 Jun 2008 20:27:59 +0300
Message-Id: <1212600479-7787-1-git-send-email-tomas.winkler@intel.com> (sfid-20080604_192817_537247_602A49C6)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch fixes the issue of slow reconnection to an IBSS cell after
disconnection from it. Now the interface's bssid is reset upon ifdown.

ieee80211_sta_find_ibss:
if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
	    (bss = ieee80211_rx_bss_get(dev, bssid,
					local->hw.conf.channel->center_freq,
					ifsta->ssid, ifsta->ssid_len)))

Note:
In general disconnection is still not handled properly in mac80211

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4b57de4..b182f01 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -516,6 +516,7 @@ static int ieee80211_stop(struct net_device *dev)
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_DISABLED;
+		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
 		del_timer_sync(&sdata->u.sta.timer);
 		/*
 		 * When we get here, the interface is marked down.
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

