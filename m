Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:43224 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZGYPZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 11:25:45 -0400
Received: by fg-out-1718.google.com with SMTP id e12so255432fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 08:25:44 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix an oops in ieee80211_scan_state_set_channel
Date: Sat, 25 Jul 2009 17:25:51 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200907251725.52084.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix an oops in ieee80211_scan_state_set_channel which was triggered
if the last scanned channel was skipped (for example due to regulatory
restrictions) by returning to the decision state after each skipped
channel.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b376775..147772a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -605,8 +605,11 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
        /* advance state machine to next channel/band */
        local->scan_channel_idx++;
 
-       if (skip)
+       if (skip) {
+               /* if we skip this channel return to the decision state */
+               local->next_scan_state = SCAN_DECISION;
                return;
+       }
 
        /*
         * Probe delay is used to update the NAV, cf. 11.1.3.2.2
