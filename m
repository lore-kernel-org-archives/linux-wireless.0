Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab3EMO4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 10:56:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10] mac80211: fix AP-mode frame matching
Date: Mon, 13 May 2013 16:56:13 +0200
Message-Id: <1368456973-20708-1-git-send-email-johannes@sipsolutions.net> (sfid-20130513_165624_640134_067F82DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In AP mode, ignore frames with mis-matched BSSID that aren't
multicast or sent to the correct destination. This fixes
reporting public action frames to userspace multiple times
on multiple virtual AP interfaces.

Cc: stable@vger.kernel.org
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6e2c8c5..3194172 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3050,6 +3050,9 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			 * and location updates. Note that mac80211
 			 * itself never looks at these frames.
 			 */
+			if (!multicast &&
+			    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
+				return 0;
 			if (ieee80211_is_public_action(hdr, skb->len))
 				return 1;
 			if (!ieee80211_is_beacon(hdr->frame_control))
-- 
1.8.0

