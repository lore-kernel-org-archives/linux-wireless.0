Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38333 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab1BALXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 06:23:11 -0500
Received: by wyb28 with SMTP id 28so6558772wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 03:23:10 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: pass up beacons from external BSS when operating as AP
Date: Tue,  1 Feb 2011 13:23:05 +0200
Message-Id: <1296559385-5357-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacons from external BSSes are required for updating overlapping BSS
info (i.e. ERP protection). Pass them up unconditionally.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/rx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f36d70f..42dbb6f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2658,7 +2658,8 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 				return 0;
 		} else if (!ieee80211_bssid_match(bssid,
 					sdata->vif.addr)) {
-			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN))
+			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
+			    !ieee80211_is_beacon(hdr->frame_control))
 				return 0;
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		}
-- 
1.7.1

