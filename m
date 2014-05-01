Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:55402 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaEAIDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2014 04:03:49 -0400
Received: by mail-ee0-f42.google.com with SMTP id d17so2056142eek.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 May 2014 01:03:48 -0700 (PDT)
From: Henning Rogge <hrogge@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Fix mac80211 station info rx bitrate for IBSS mode
Date: Thu, 01 May 2014 10:03:46 +0200
Message-ID: <4194886.cHRlWHyH6L@desktop.local> (sfid-20140501_100434_872920_C371559D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henning Rogge <hrogge@gmail.com>

Filter out incoming multicast packages before applying their bitrate
to the rx bitrate station info field to prevent them from setting the
rx bitrate to the basic multicast rate.

Signed-off-by: Henning Rogge <hrogge@gmail.com>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 216c45b..2b608b2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1231,7 +1231,8 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		if (ether_addr_equal(bssid, rx->sdata->u.ibss.bssid) &&
 		    test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
 			sta->last_rx = jiffies;
-			if (ieee80211_is_data(hdr->frame_control)) {
+			if (ieee80211_is_data(hdr->frame_control) &&
+			    !is_multicast_ether_addr(hdr->addr1)) {
 				sta->last_rx_rate_idx = status->rate_idx;
 				sta->last_rx_rate_flag = status->flag;
 				sta->last_rx_rate_vht_flag = status->vht_flag;
-- 
1.9.0
