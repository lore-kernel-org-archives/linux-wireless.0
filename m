Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35494 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760333AbdDSHV1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 03:21:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: reject ToDS broadcast data frames
Date: Wed, 19 Apr 2017 09:21:23 +0200
Message-Id: <20170419072123.8090-1-johannes@sipsolutions.net> (sfid-20170419_092131_058993_C362E500)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

AP/AP_VLAN modes don't accept any real 802.11 multicast data
frames, but since they do need to accept broadcast management
frames the same is currently permitted for data frames. This
opens a security problem because such frames would be decrypted
with the GTK, and could even contain unicast L3 frames.

Since the spec says that ToDS frames must always have the BSSID
as the RA (addr1), reject any other data frames.

The problem was originally reported in "Predicting, Decrypting,
and Abusing WPA2/802.11 Group Keys" at usenix
https://www.usenix.org/conference/usenixsecurity16/technical-sessions/presentation/vanhoef
and brought to my attention by Jouni.

Cc: stable@vger.kernel.org
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4b12c70c85f0..4d7543d1a62c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3639,6 +3639,27 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 			    !ether_addr_equal(bssid, hdr->addr1))
 				return false;
 		}
+
+		/*
+		 * 802.11-2016 Table 9-26 says that for data frames, A1 must be
+		 * the BSSID - we've checked that already but may have accepted
+		 * the wildcard (ff:ff:ff:ff:ff:ff).
+		 *
+		 * It also says:
+		 *	The BSSID of the Data frame is determined as follows:
+		 *	a) If the STA is contained within an AP or is associated
+		 *	   with an AP, the BSSID is the address currently in use
+		 *	   by the STA contained in the AP.
+		 *
+		 * So we should not accept data frames with an address that's
+		 * multicast.
+		 *
+		 * Accepting it also opens a security problem because stations
+		 * could encrypt it with the GTK and inject traffic that way.
+		 */
+		if (ieee80211_is_data(hdr->frame_control) && multicast)
+			return false;
+
 		return true;
 	case NL80211_IFTYPE_WDS:
 		if (bssid || !ieee80211_is_data(hdr->frame_control))
-- 
2.11.0
