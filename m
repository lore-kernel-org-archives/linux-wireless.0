Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:34946 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab1AKOlA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 09:41:00 -0500
Date: Tue, 11 Jan 2011 15:40:56 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: lrodriguez <lrodriguez@atheros.com>, nbd <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>
Message-ID: <15461044.40.1294756856032.JavaMail.wlan@CHBU500181>
In-Reply-To: <5840411.32.1294754666078.JavaMail.wlan@CHBU500181>
Subject: [RFC] mac80211: Wait with enabling beacons on DFS channels
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
  Basic DFS functionality requires that when we change to radar
enabled channels we need to wait and listen before we can send
beacons/frames -> Channel Availability Check (CAC).
There is a case when we can switch to it immediately if we have
been monitoring it off_channel for specific time. This is bit
more complicated and doesn't need to be implemented in the first 
place because it's sort of functional optimization.

Anyway there is a need for mechanism to control when to enable
beacons if we switch to radar channel.

Pseudo-code-diff bellow is an example for ath9k where we could enable
beacons at once or fire a worker to re-enable it after CAC expires
if radar hasn't been detected. In theory we need only to disable
beacons because we shouldn't get any directed frames we could reply
to and stations anyway can't probe directly. In practice to be 
sure it couldn't be probably done with making rx filters more 
restrictive during CAC period. Maybe there are other ways as well.

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c 
@@ -285,8 +285,14 @@
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL))) {
-		if (sc->sc_flags & SC_OP_BEACONS)
-			ath_beacon_config(sc, NULL);
+
+		if (sc->sc_flags & SC_OP_BEACONS) {
+			if (channel->flags & IEEE80211_CHAN_RADAR 
+                            && !(channel->flags & IEEE80211_CHAN_NOL_FREE))
+				ieee80211_queue_delayed_work
+                                      (sc->hw, &sc->dfs_wait_cac_work, 0);
+			else
+				ath_beacon_config(sc, NULL);
+		}
+
 		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 		ath_start_ani(common);
 	}



Problem with this solution is that every driver would need to do
their own timers and state machines to get this functionality which
is shared by all.
I don't know about other driver's structures but maybe a better way
would be to implement mac80211 command to disable/enable beacons and
set rx filters which every driver supporting DFS would have to implement.
Mac80211 would have then timer which would control when to enable
beacons. I guess Non Occupancy List (NOL) would be handled there as
well so all the DFS timers could be in the same place.

Any comments?


Br,
Wojtek
