Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40494 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab0K2Shp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 13:37:45 -0500
Received: by bwz15 with SMTP id 15so4195446bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 10:37:43 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Saqeb Akhter <saqeb.akhter@gmail.com>
Subject: [PATCH for-2.6.37?] mac80211: ignore non-bcast mcast managment frames
Date: Mon, 29 Nov 2010 19:37:24 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>, linville@tuxdriver.com
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com> <201010021332.09809.chunkeey@googlemail.com> <201011291814.58230.chunkeey@googlemail.com>
In-Reply-To: <201011291814.58230.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011291937.25195.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an curious issue due to insufficient
rx frame filtering.

Saqeb Akhter reported frequent disconnects while streaming
videos over samba:
> [ 1166.512087] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [ 1526.059997] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [ 2125.324356] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [...]

The reason is that the device generates frames with slightly
bogus SA/TA addresses.

e.g.:
 [ 2314.402316] Ignore 9f:1f:31:f8:64:ff
 [ 2314.402321] Ignore 9f:1f:31:f8:64:ff
 [ 2352.453804] Ignore 0d:1f:31:f8:64:ff
 [ 2352.453808] Ignore 0d:1f:31:f8:64:ff
 					   ^^ the group-address flag is set!
 (the correct SA/TA would be: 00:1f:31:f8:64:ff)
 
Since the AP does not know from where the frame comes from it
generates a DEAUTH response. This mcast mgmt frame confuses
the stack because the broadcast flag are not filtered and the
stack thinks we haven been kicked by the AP.

This patch fixes the problem simply by ignoring
non-broadcast group-addressed management frames.

Cc: <stable@kernel.org>
Cc: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Saqeb Akhter <saqeb.akhter@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d2fcd22..3dbf79c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1999,6 +1999,10 @@ ieee80211_rx_h_mgmt_check(struct ieee80211_rx_data *rx)
 	if (!ieee80211_is_mgmt(mgmt->frame_control))
 		return RX_DROP_MONITOR;
 
+	if (is_multicast_ether_addr(mgmt->da) &&
+	    !is_broadcast_ether_addr(mgmt->da))
+		return RX_DROP_MONITOR;
+
 	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
