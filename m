Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50575 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1HWHVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 03:21:32 -0400
Received: by wwf5 with SMTP id 5so5947161wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 00:21:31 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: allow action frames with unknown BSSID in GO mode
Date: Tue, 23 Aug 2011 10:21:27 +0300
Message-Id: <1314084087-16170-1-git-send-email-arik@wizery.com> (sfid-20110823_092135_223371_71542486)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating as a P2P GO, we receive some P2P action frames where the
BSSID is set to the peer MAC address. Specifically, this occurs for
invitation responses. These are valid action frames and they should be
passed up.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/rx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6540cd1..43ad4ef 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2689,7 +2689,9 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 		} else if (!ieee80211_bssid_match(bssid,
 					sdata->vif.addr)) {
 			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
-			    !ieee80211_is_beacon(hdr->frame_control))
+			    !ieee80211_is_beacon(hdr->frame_control) &&
+			    !(ieee80211_is_action(hdr->frame_control) &&
+			      sdata->vif.p2p))
 				return 0;
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		}
-- 
1.7.4.1

