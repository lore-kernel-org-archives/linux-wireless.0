Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48796 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab0K2Txo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 14:53:44 -0500
Received: by bwz15 with SMTP id 15so4263426bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 11:53:43 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH for-2.6.37 v2] mac80211: ignore non-bcast mcast deauth/disassoc franes
Date: Mon, 29 Nov 2010 20:53:23 +0100
Cc: Saqeb Akhter <saqeb.akhter@gmail.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	linville@tuxdriver.com
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com> <201011291937.25195.chunkeey@googlemail.com> <1291056330.3532.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291056330.3532.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011292053.24717.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an curious issue due to insufficient
rx frame filtering.

Saqeb Akhter reported frequent disconnects while streaming
videos over samba: <http://marc.info/?m=128600031109136>
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
 
Since the AP does not know from where the frames come, it
generates a DEAUTH response for the (invalid) mcast address.
This mcast deauth frame then passes through all filters and
tricks the stack into thinking that the AP brutally kicked
us!

This patch fixes the problem by simply ignoring
non-broadcast, group-addressed deauth/disassoc frames.

Cc: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Saqeb Akhter <saqeb.akhter@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
v1 -> v2:
	* johannes pointed out that nl80211 might want
	  group-addressed action frames.
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d2fcd22..73973d6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2245,6 +2245,10 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 		break;
 	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
 	case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
+		if (is_multicast_ether_addr(mgmt->da) &&
+		    !is_broadcast_ether_addr(mgmt->da))
+			return RX_DROP_MONITOR;
+
 		/* process only for station */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			return RX_DROP_MONITOR;
