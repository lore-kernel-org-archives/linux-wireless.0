Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:32954 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989Ab1E0MfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 08:35:00 -0400
Received: by mail-ew0-f43.google.com with SMTP id 20so1026502ewy.30
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2011 05:34:59 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Subject: [PATCH 2.6.40 1/4] wl12xx: fix passive and radar channel generation for scheduled scan
Date: Fri, 27 May 2011 15:34:45 +0300
Message-Id: <1306499688-26603-2-git-send-email-coelho@ti.com> (sfid-20110527_143506_050934_15B9AF40)
In-Reply-To: <1306499688-26603-1-git-send-email-coelho@ti.com>
References: <1306499688-26603-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were comparing bitwise AND results with a boolean, so when the
boolean was set to true, it was not matching as it should.

Fix this by booleanizing the bitwise AND results with !!.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index f37e5a3..f223e0e 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -338,8 +338,8 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 		flags = req->channels[i]->flags;
 
 		if (!(flags & IEEE80211_CHAN_DISABLED) &&
-		    ((flags & IEEE80211_CHAN_PASSIVE_SCAN) == passive) &&
-		    ((flags & IEEE80211_CHAN_RADAR) == radar) &&
+		    (!!(flags & IEEE80211_CHAN_PASSIVE_SCAN) == passive) &&
+		    (!!(flags & IEEE80211_CHAN_RADAR) == radar) &&
 		    (req->channels[i]->band == band)) {
 			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
 				     req->channels[i]->band,
-- 
1.7.1

