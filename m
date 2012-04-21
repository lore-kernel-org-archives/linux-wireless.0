Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49805 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab2DUUec (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 16:34:32 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: exclude AP 4-addr VLAN stations from num_mcast_sta
Date: Sat, 21 Apr 2012 22:34:17 +0200
Message-Id: <1335040457-11252-2-git-send-email-nbd@openwrt.org> (sfid-20120421_223437_632575_DBD0E0E5)
In-Reply-To: <1335040457-11252-1-git-send-email-nbd@openwrt.org>
References: <1335040457-11252-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remote 4-addr stations ignore 3-address multicast frames, in a typical bridge
configuration they receive the same packets as 4-address unicast.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 510a745..6af395f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1023,6 +1023,10 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		}
 
 		sta->sdata = vlansdata;
+
+		if (sta->sta_state == IEEE80211_STA_AUTHORIZED)
+			atomic_dec(&sta->sdata->u.ap.num_mcast_sta);
+
 		ieee80211_send_layer2_update(sta);
 	}
 
-- 
1.7.3.2

