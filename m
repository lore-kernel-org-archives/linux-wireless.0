Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53663 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab0LGDka (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 22:40:30 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sfr@canb.auug.org.au
Subject: [PATCH] mac80211: fix a compiler warning
Date: Tue,  7 Dec 2010 04:40:18 +0100
Message-Id: <1291693218-45465-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/mac80211/mlme.c: In function 'ieee80211_sta_work':
net/mac80211/mlme.c:1981: warning: too many arguments for format

Introduced by commit 04ac3c0ee2c773c321ec472d892635a20556f34d
("mac80211: speed up AP probing using nullfunc frames").

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/mlme.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3a1dde3..04e92cf 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1981,8 +1981,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 				wiphy_debug(local->hw.wiphy,
 					    "%s: No ack for nullfunc frame to"
 					    " AP %pM, disconnecting.\n",
-					    sdata->name, bssid,
-					    ifmgd->probe_send_count);
+					    sdata->name, bssid);
 #endif
 				ieee80211_sta_connection_lost(sdata, bssid);
 			}
-- 
1.7.3.2

