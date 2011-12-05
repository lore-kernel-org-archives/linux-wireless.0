Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46576 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab1LEQUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 11:20:18 -0500
Subject: [PATCH] mac80211: accept public action frames with mismatched BSSID
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Arik Nemtsov <anamtsov@gmail.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 17:20:12 +0100
Message-ID: <1323102012.4051.38.camel@jlt3.sipsolutions.net> (sfid-20111205_172021_889659_866B269D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Arik's patch "mac80211: allow action frames with unknown
BSSID in GO mode" allowed any action frames in P2P mode
to go through, but only to cooked monitor interfaces as
the IEEE80211_RX_RA_MATCH was still cleared. As a result
my no-monitor patches broke invitation responses.

Instead of allowing any action frames in P2P GO mode to
go through with a wrong BSSID like that patch did, allow
all public action frames. They will never be processed
by mac80211, but can be reported via nl80211 then.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h |   17 +++++++++++++++++
 net/mac80211/rx.c         |   13 ++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

--- a/include/linux/ieee80211.h	2011-11-10 09:27:31.000000000 +0100
+++ b/include/linux/ieee80211.h	2011-12-05 17:02:43.000000000 +0100
@@ -1695,6 +1695,23 @@ static inline bool ieee80211_is_robust_m
 }
 
 /**
+ * ieee80211_is_public_action - check if frame is a public action frame
+ * @hdr: the frame
+ * @len: length of the frame
+ */
+static inline bool ieee80211_is_public_action(struct ieee80211_hdr *hdr,
+					      size_t len)
+{
+	struct ieee80211_mgmt *mgmt = (void *)hdr;
+
+	if (len < 25)
+		return false;
+	if (!ieee80211_is_action(hdr->frame_control))
+		return false;
+	return mgmt->u.action.category == WLAN_CATEGORY_PUBLIC;
+}
+
+/**
  * ieee80211_fhss_chan_to_freq - get channel frequency
  * @channel: the FHSS channel
  *
--- a/net/mac80211/rx.c	2011-12-05 10:23:11.000000000 +0100
+++ b/net/mac80211/rx.c	2011-12-05 17:08:56.000000000 +0100
@@ -2796,10 +2796,17 @@ static int prepare_for_handlers(struct i
 				return 0;
 		} else if (!ieee80211_bssid_match(bssid,
 					sdata->vif.addr)) {
+			/*
+			 * Accept public action frames even when the
+			 * BSSID doesn't match, this is used for P2P
+			 * and location updates. Note that mac80211
+			 * itself never looks at these frames.
+			 */
 			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
-			    !ieee80211_is_beacon(hdr->frame_control) &&
-			    !(ieee80211_is_action(hdr->frame_control) &&
-			      sdata->vif.p2p))
+			    ieee80211_is_public_action(hdr, skb->len))
+				return 1;
+			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
+			    !ieee80211_is_beacon(hdr->frame_control))
 				return 0;
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		}


