Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60438 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933854AbaGQOOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:25 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so2115720wgh.15
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:24 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 14/15] mac80211: ignore frames between TDLS peers when operating as AP
Date: Thu, 17 Jul 2014 17:14:30 +0300
Message-Id: <1405606471-30128-15-git-send-email-arik@wizery.com> (sfid-20140717_161506_826633_42B8732C)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the AP receives actions frames destined for other peers, it may
mistakenly toggle BA-sessions from itself to a peer.
Ignore TDLS data packets as well - the AP should not handle them.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/rx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5f572be..5a786d4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3129,6 +3129,14 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 			if (!ieee80211_is_beacon(hdr->frame_control))
 				return false;
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
+		} else if (!ieee80211_has_tods(hdr->frame_control)) {
+			/* ignore data frames to TDLS-peers */
+			if (ieee80211_is_data(hdr->frame_control))
+				return false;
+			/* ignore action frames to TDLS-peers */
+			if (ieee80211_is_action(hdr->frame_control) &&
+			    !ether_addr_equal(bssid, hdr->addr1))
+				return false;
 		}
 		break;
 	case NL80211_IFTYPE_WDS:
-- 
1.9.1

