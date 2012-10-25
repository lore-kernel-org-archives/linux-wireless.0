Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab2JYWqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 18:46:09 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: make sure data is accessible in EAPOL check
Date: Fri, 26 Oct 2012 00:46:40 +0200
Message-Id: <1351205200-18094-4-git-send-email-johannes@sipsolutions.net> (sfid-20121026_004615_351690_13DCD940)
In-Reply-To: <1351205200-18094-1-git-send-email-johannes@sipsolutions.net>
References: <1351205200-18094-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code to allow EAPOL frames even when the station
isn't yet marked associated needs to check that the
incoming frame is long enough and due to paged RX it
also can't assume skb->data contains the right data,
it must use skb_copy_bits(). Fix this to avoid using
data that doesn't really exist.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6d1fd39..a5a3db8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -888,14 +888,16 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 		 */
 		if (rx->sta && rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
 		    ieee80211_is_data_present(hdr->frame_control)) {
-			u16 ethertype;
-			u8 *payload;
-
-			payload = rx->skb->data +
-				ieee80211_hdrlen(hdr->frame_control);
-			ethertype = (payload[6] << 8) | payload[7];
-			if (cpu_to_be16(ethertype) ==
-			    rx->sdata->control_port_protocol)
+			unsigned int hdrlen;
+			__be16 ethertype;
+
+			hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+			if (rx->skb->len < hdrlen + 8)
+				return RX_DROP_MONITOR;
+
+			skb_copy_bits(rx->skb, hdrlen + 6, &ethertype, 2);
+			if (ethertype == rx->sdata->control_port_protocol)
 				return RX_CONTINUE;
 		}
 
-- 
1.7.10.4

