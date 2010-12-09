Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57587 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0LIVQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 16:16:03 -0500
Received: by pzk6 with SMTP id 6so8389pzk.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 13:16:02 -0800 (PST)
From: Tim Harvey <harvey.tim@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Tim Harvey <harvey.tim@gmail.com>
Subject: [PATCH RFC] mac80211 default tx_last_beacon false (congestion)
Date: Thu,  9 Dec 2010 13:15:45 -0800
Message-Id: <1291929345-8066-1-git-send-email-harvey.tim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 802.11 spec states that the STA that generated the last Beacon frame shall
be the STA that response to a probe request.  This is important for congestion
reduction when a probe request is received - only 1 node in an adhoc BSS
will transmit a response.  While mac80211 drivers should provide the
tx_last_beacon function to report if they transmitted the last beacon many
do not.  As an attempt to reduce probe response congestion default this
to 0 such that a node not implementing this capability does not contribute
to unnecessary congestion.

In a modern medium sized office environment I see upwards of 100 probe
requests per second received at a given node from various hardware/OS/drivers
doing zeroconf 'active probing' as opposed to passively listening for beacons.
With a modest 10-node adhoc network consisting of drivers that do not implement
this tx_last_beacon feature, I have seen this result in the simultaneous xmit
of probe responses accumulating to 500 probe responses per second because of
collisions which brings the adhoc network to its knees as well as causes
needless congestion.
---
 net/mac80211/driver-ops.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4244554..af0c439 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -367,7 +367,7 @@ static inline void drv_reset_tsf(struct ieee80211_local *local)
 
 static inline int drv_tx_last_beacon(struct ieee80211_local *local)
 {
-	int ret = 1;
+	int ret = 0; /* default unsuported op for less congestion */
 
 	might_sleep();
 
-- 
1.7.0.4

