Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46203 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaB0FOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 00:14:54 -0500
Received: by mail-pa0-f46.google.com with SMTP id rd3so1983301pab.5
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 21:14:54 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: add missing update on rx status VHT flag
Date: Thu, 27 Feb 2014 13:14:14 +0800
Message-Id: <1393478054-19367-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140227_061500_082206_9A8EE0EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing update on the rx status vht flag of the last
data packet. Otherwise, cfg80211_calculate_bitrate_vht
may not consider the channel width resulting in wrong
calculation of the received bitrate.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/rx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 58e4b70..f3719e6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1238,6 +1238,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		if (ieee80211_is_data(hdr->frame_control)) {
 			sta->last_rx_rate_idx = status->rate_idx;
 			sta->last_rx_rate_flag = status->flag;
+			sta->last_rx_rate_vht_flag = status->vht_flag;
 			sta->last_rx_rate_vht_nss = status->vht_nss;
 		}
 	}
-- 
1.7.9.5

